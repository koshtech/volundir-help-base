# frozen_string_literal: true
require 'json'

module Volundir
  module Help
    class Base  < Volundir::IngotBase
      def self.show_help(context, command, args, registry = nil)
        context        = context || 'volundir-help-base'
        help_file_name = command || 'main'
        help_file      = locale_help_file(context, help_file_name) || ""
        show_registry  = false

        unless File.exist?(help_file)
          help_file     = locale_help_file('volundir-help-base', 'main')
          show_registry = true
        end
        if help_file && File.exist?(help_file)
          data = JSON.parse(File.read(help_file))
          puts "#{data['header']}\n\n"
          puts "Usage: #{data['usage']}\n\n"
          puts "#{data['available_commands_title']}\n\n"
          puts "#{data['description']}\n"
        else
          puts "Volundir CLI Help System\n\n"
        end

        if show_registry && registry
          processed_commands = []
          registry.registered_commands.each do |cmd, info|
            next if processed_commands.include?(info[:name])

            processed_commands << info[:name]
            aliases = info[:aliases].empty? ? '' : " (#{info[:aliases].join(', ')})"
            puts "  #{info[:name].ljust(15)} #{aliases.ljust(10)} #{info[:description]}"
          end
        end

        puts "\nThank you for choosing our amazing tools. |o/|"
      end
    end
  end
end
