
module Creng

	 class BackgroundJS < FileGenerator

	 	attr_reader :name
	 	attr_reader :path
	 	attr_reader :contents

	 	def initialize
	 		@name = 'background.js'
	 		@path = 'js'
	 	end

	 	def create
	 		puts "called create of #{@filename}"
	 	end

	 	def contents
	 		<<-"...".gsub!(/^ {16}/, '')
                console.log("background script of my extension is running!");
	 		...
	 	end



	 end


end