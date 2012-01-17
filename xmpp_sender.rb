#!/usr/local/bin/ruby

require 'yaml'
require 'getoptlong'
require 'rubygems'
gem 'xmpp4r', '~>0.5'
require 'xmpp4r/client'

# Incapsulates all utility logic
#
class XmppSender
	include Jabber
	
	@@version = "1.0.0"
	@@instant_variables = %w/server login password to subject body/
	@@instant_variables.each{ |a| attr_accessor a.intern }
	
	@@opts = GetoptLong.new(
		[ "--config",           "-c",   GetoptLong::REQUIRED_ARGUMENT ],
		[ "--server",           "-s",   GetoptLong::REQUIRED_ARGUMENT ],
		[ "--login",            "-l",   GetoptLong::REQUIRED_ARGUMENT ],
		[ "--password",         "-p",   GetoptLong::REQUIRED_ARGUMENT ],
		[ "--subject",          "-j",   GetoptLong::REQUIRED_ARGUMENT ],
		[ "--body",             "-b",   GetoptLong::REQUIRED_ARGUMENT ],
		[ "--usage",            "-u",   GetoptLong::NO_ARGUMENT ],
		[ "--version",          "-v",   GetoptLong::NO_ARGUMENT ]
	)

	# Sends a message
	# @return [void]
	#
	def send
		#Jabber::debug = true
		
		jid=JID::new "#{@login}@#{@server}" 
		cl = Client::new(jid)
		cl.connect
		cl.auth @password
		m = Message::new("#{@to}@#{@server}", @body).set_type(:normal).set_id('1').set_subject(@subject)
		cl.send m
	end
	
	# Sets up instance variables named in @@instance_variables with values
	# 	passed by hash 
	# @param [Hash] hash contains values for instance variables
	# @return [void]
	#
	def set_instance_variables_from hash
		@@instant_variables.each do |var_name|
			var_value = hash[ var_name ]
			var_name  = "@" + var_name
			self.instance_variable_set(var_name, var_value) if self.instance_variable_get(var_name).nil?
		end
	end

	# Prints out instance variables named in @@instance_variables
	# @return [void]
	#
	def show_instance_variables
		@@instant_variables.each do |var_name|
			var_name  = "@" + var_name
			var_value = self.instance_variable_get var_name
			puts "%12s: %s"%[var_name, var_value]
		end
	end
	
	# Reads configuration parameters from config file
	# @return [void]
	#
	def read_config
		@config_file = @config || 'xmpp_sender.yml'
		begin
			settings = YAML.load_file( @config_file )['xmpp_sender']
		rescue
			$stderr.puts "Error reading config file '#{@config_file}'"
			XmppSender.printusage -1
		end

		self.set_instance_variables_from settings
		self.show_instance_variables

		if @password.nil?
			$stderr.puts "Can not authenticate due to password is nil" 
			exit -2
		end

		if @login.nil?
			$stderr.puts "Can not authenticate due to login is nil" 
			exit -3
		end

		if @server.nil?
			$stderr.puts "Can not authenticate due to server is nil" 
			exit -4
		end

		if @to.nil?
			$stderr.puts "Can not send because to is nil" 
			exit -5
		end

		if @body.nil? && @subject.nil? 
			$stderr.puts "Can not send because both subject and body are nil" 
			exit -6
		end

	end
	
	# Prints usage and exits with passed *error_code*
	# @param [Integer] error_code process exit code
	# @return [void]
	#
	def XmppSender.printusage(error_code)
		print "xmpp_sender -- sends a message over XMPP protocol\n"
		print "Usage: xmpp [POSIX or GNU style options]\n\n"
		print "POSIX options                     GNU long options\n"
		print "    -c config_file_name               --config config_file_name\n"
		print "    -s server_name                    --server server_name\n"
		print "    -l login                          --login login\n"
		print "    -p password                       --password password\n"
		print "    -t to                             --to to\n"
		print "    -b body                           --body body\n"
		print "    -j subject                        --subject subject\n"
		print "    -u                                --usage\n"
		print "    -v                                --version\n\n"
		print "Examples: \n"
		print "xmpp_sender -b Erlang\ Programming.pdf                    sends a message with specified body\n"
		print "xmpp_sender -t VassiliyPupkin -b Erlang\ Programming.pdf  sends a message with specified body to VassiliyPupkin\n\n"
		print "All options could be saved to the config file in YAML format. See settings.yml\n"
		print "Command line options have precedende over the options in config file\n"
		print "For licensing terms, see source code\n\n"
		exit(error_code)
	end

	# Processes command line parameters
	# @return [void]
	#
	def get_opts
		begin
			@@opts.each do |opt, arg|
				case opt
					when "--config"
						@config = arg
					when "--server"
						@server = arg
					when "--login"
						@login  = arg
					when "--password"
						@password  = arg
					when "--to"
						@to  = to
					when "--subject"
						@subject  = arg
					when "--body"
						@body  = arg
					when "--help"
						XmppSender.printusage 0
					when "--usage"
						XmppSender.printusage 0
					when "--version"
						puts @@version
						exit 0
					else
						puts "ignored unknown option: #{opt}"
				end
			end
		rescue GetoptLong::InvalidOption => e
		end
	end
end

if __FILE__ == $0
	dir = /(.*\/)src$/.match( File.dirname $0 )[1] rescue dir = './'
	puts "working directory: %s"%dir
	Dir.chdir dir
	
	xmpp_sender = XmppSender.new
	xmpp_sender.get_opts
	xmpp_sender.read_config
	xmpp_sender.send
end