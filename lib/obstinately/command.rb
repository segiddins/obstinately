# frozen_string_literal: true

require 'claide'
require 'English'
require 'shellwords'

module Obstinately
  class Command < CLAide::Command
    self.command = 'obstinately'
    self.version = VERSION

    class MissingExecutableError < Error
      include CLAide::InformativeError
    end

    self.summary = <<-EOS
      A small command-line utility to retry shell invocations with exponential backoff.
    EOS

    self.arguments = [
      CLAide::Argument.new('COMMAND', true, true)
    ]

    DEFAULT_RETRIES = '3'
    DEFAULT_BACKOFF = '1.5'

    def self.options
      super.concat([
                     ['--retries=RETRIES', "The number of retries. Defaults to #{DEFAULT_RETRIES}"],
                     ['--backoff=BACKOFF', "The number of seconds to wait after the first failure. Doubles after each subsequent failure. Defaults to #{DEFAULT_BACKOFF}"]
                   ]).reject { |name, _| name == '--no-ansi' }
    end

    def initialize(argv)
      @retries = argv.option('retries', DEFAULT_RETRIES)
      @backoff = argv.option('backoff', DEFAULT_BACKOFF)
      @command = argv.arguments!
      super
    end

    def run
      backoff = @backoff
      @retries.succ.times do |i|
        message { "Running `#{@command.shelljoin}`" }
        exe, *args = *@command

        begin
          subprocess = spawn([exe, exe], *args)
        rescue SystemCallError => e
          raise MissingExecutableError, "Unable to find executable `#{exe}`#{" (#{e.class})" if verbose?}"
        else
          Process.wait(subprocess)
          status = $CHILD_STATUS
        end

        break if status.success?

        if i == @retries
          message { "Running `#{@command.shelljoin}` failed #{i.succ} times" }
          exit status.exitstatus
        end

        message { "Running `#{@command.shelljoin}` failed#{", sleeping #{backoff} seconds, then" if backoff > 0} retrying (#{i.succ}/#{@retries.succ})" }

        sleep backoff
        backoff *= 2
      end
    end

    def validate!
      super

      help! "Must specify a positive number of retries, not #{@retries}" unless @retries =~ /\A\d+\z/ && (@retries = @retries.to_i) && (@retries >= 0)

      help! "Must specify a positive number of seconds for backoff, not #{@backoff}" unless @backoff =~ /\A(\d+)?\.?\d+\z/ && (@backoff = @backoff.to_f) && (@backoff >= 0)

      help! 'Must specify a command to run' if @command.empty?
    end

    def message
      return unless verbose?

      warn yield
    end
  end
end
