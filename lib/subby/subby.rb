module Subby

  def self.setup input=ARGV, &blk
    config = Config.new
    config.instance_eval(&blk)
    config.create! input
  end

  module OptionBase

    def switch name, description='', options={}
      @options[name] = Switch.new(name, description, options)
    end

    def parameter name, description='', options={}
      @options[name] = Parameter.new(name, description, options)
    end

    def command name, &blk
      @commands[name] = Command.new(name, &blk)
    end

    protected

    def is_valid_switch? name
      name[0...2] == '--' && options.keys.include?(name[2..-1].to_sym) && options[name[2..-1].to_sym].switch?
    end

    def is_valid_parameter? name
      name[0...2] == '--' && options.keys.include?(name[2..-1].to_sym) && options[name[2..-1].to_sym].parameter?
    end
  end

  class RuntimeConfig

    attr_accessor :options, :command

    def initialize
      @options = {}
      @command = nil
    end
  end

  class Config

    include OptionBase

    attr_reader :options, :commands

    def initialize
      @options = {}
      @commands = {}
    end

    def create! input
      parse input
      validate_required
      runtime_config
    end

    private

    def runtime_config
      @runtime_config ||= RuntimeConfig.new
    end

    def validate_required
      options.merge(runtime_config.command.options).each do |name, config|
        raise "Required option missing - #{name}" unless config.required? && config.valid?
      end
    end

    def parse input
      i = 0
      current_command = nil

      until i >= input.length
        arg = input[i]

        if is_valid_command? arg
          runtime_config.command = current_command = commands[arg.to_sym]

        elsif is_valid_switch?(arg) || (current_command && current_command.is_valid_switch?(arg))
          option = options[arg[2..-1].to_sym]
          runtime_config.options[option.name] = option

        elsif is_valid_parameter?(arg) || (current_command && current_command.is_valid_parameter?(arg))
          if is_valid_parameter?(arg)
            option = options[arg[2..-1].to_sym]
          else
            option = current_command.options[arg[2..-1].to_sym]
          end

          option.value = input[i += 1]

          raise 'Invalid parameter value' unless option.valid?

          if is_valid_parameter?(arg)
            runtime_config.options[option.name] = option
          else
            runtime_config.command.options[option.name] = option
          end
        end

        i += 1
      end
    end

    def is_valid_command? name
      commands.include? name.to_sym
    end
  end

  class Option

    attr_reader :name, :description, :options, :value
    attr_writer :value

    def initialize name, description='', options={}
      @name = name
      @description = description
      @options = options
    end

    def required?
      options.fetch(:required, false)
    end

    def switch?
      false
    end

    def parameter?
      false
    end
  end

  class Switch < Option

    def valid?
      true
    end

    def switch?
      true
    end
  end

  class Parameter < Option

    attr_accessor

    def valid?
      if options.fetch(:format, false) && (!value.nil? && value.match(options[:format]))
        true
      else
        false
      end
    end

    def parameter?
      true
    end
  end

  class Command

    include OptionBase

    attr_reader :name, :description, :options

    def initialize name, &blk
      @name = name
      @options = {}
      instance_eval(&blk)
    end

    def description description
      @description = description
    end
  end
end
