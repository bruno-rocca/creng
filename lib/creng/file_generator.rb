

module Creng

	 class FileGenerator



	 	def initialize projectname
	 		
	 		@projectname = projectname
	 		generate
	 	end


	 	def self.getAccessibleResources projectname = nil

	 		if projectname.nil?
	 			allfiles = Dir["dev/**/*"]
	 			regex = Regexp.new("^dev\/")
	 		else
	 			allfiles = Dir["#{projectname}/dev/**/*"]
	 			regex = Regexp.new("^#{projectname}\/dev\/")
	 		end

	 		#allfiles = projectname.nil? ? Dir["dev/**/*"] : Dir["#{projectname}/dev/**/*"] 



	 		#puts "allfiles #{allfiles}, #{projectname}"
	 		accessible_resources = []

	 		allfiles.each do |file|
	 			unless File.directory? file
	 				if File.basename(file) != 'manifest.json'
	 					accessible_resources.push(file.gsub(regex, ""))
	 				end
	 			end
	 		end

	 		accessible_resources
	 	end

	 	

	 	def generateManifest

	 		accessible_resources = FileGenerator.getAccessibleResources(@projectname)

			File.open("#{@projectname}/dev/manifest.json", 'w') do |f|
		        f.write <<-"...".gsub!(/^ {20}/, '')
                    {
  "name": "#{@projectname}",
  "version": "0.0.1",
  "manifest_version": 2,
  "description": "Sample extension generated by Creng ruby gem",
  "icons": {
    "16": "images/extension-16x16.png",
    "48": "images/extension-48x48.png",
    "128": "images/extension-64x64.png"
  },
  "background": {
    "page" : "html/background.html",
    "persistent": true
  },
  "permissions": [
    "webRequest",
    "webRequestBlocking",
    "tabs",
    "*://*/*"
  ],
  "content_scripts": [
    {
      "matches": ["*://*/*"],
      "js": [
        "js/frameworks/cajon.js",
        "js/frameworks/jquery.min.js",
        "js/frameworks/underscore.min.js",
        "js/process.js"
      ],
      "run_at": "document_start"
    }
  ],
  "web_accessible_resources": #{accessible_resources}
}
        		...
        	end

	 	end

	 	#point of enter
	 	def generate
	 		
			generateJS([ProcessJS.new, ContentJS.new, BackgroundJS.new, DaemonJS.new])

			fetchLibs
			generateHTML
			fetchImages
			generateManifest
			puts "		create #{@projectname}/dev/manifest.json"
	 	end


	 	def generateJS filearray

	 		filearray.each do |file|

		 		File.open("#{@projectname}/dev/#{file.path}/#{file.name}", 'w') do |f|
		 			f.write file.contents
		 		end
		 		puts "		create #{@projectname}/dev/#{file.path}/#{file.name}"
		 		
	 		end




	 	end


	 	def fetchLibs

	 		require 'open-uri'

	 		#####################
	 		# Cajon
	 		#####################
	 		File.open("#{@projectname}/dev/js/frameworks/content/cajon.js", 'w') do |f|

			 	open("https://raw.github.com/requirejs/cajon/master/cajon.js", 'rb') do |read_file|
				    f.write(read_file.read)
				end

		 	end
		 	puts "		fetching cajon from https://github.com/requirejs/cajon"

		 	#####################
		 	# Jquery
		 	#####################
		 	File.open("#{@projectname}/dev/js/frameworks/content/jquery.min.js", 'w') do |f|

			 	open("http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js", 'rb') do |read_file|
				    f.write(read_file.read)
				end

		 	end
		 	puts "		fetching jquery from Google CDN"

		 	#####################
		 	# Underscore
		 	#####################
		 	File.open("#{@projectname}/dev/js/frameworks/underscore.min.js", 'w') do |f|

			 	open("https://raw.github.com/documentcloud/underscore/master/underscore-min.js", 'rb') do |read_file|
				    f.write(read_file.read)
				end

		 	end
		 	puts "		fetching underscore from https://github.com/documentcloud/underscore"

		 	#####################
		 	# RequireJS
		 	#####################
		 	File.open("#{@projectname}/dev/js/frameworks/background/require.js", 'w') do |f|

			 	open("https://raw.github.com/jrburke/requirejs/master/require.js", 'rb') do |read_file|
				    f.write(read_file.read)
				end

		 	end
		 	puts "		fetching requirejs from https://github.com/jrburke/requirejs"


	 	end


	 	def fetchImages
	 		#fetching sample extension icons from github
	 		File.open("#{@projectname}/dev/images/extension-16x16.png", 'w') do |f|
			 	open("https://raw.github.com/traa/creng/master/lib/creng/vendor/images/extension-16x16.png", 'rb') do |read_file|
				    f.write(read_file.read)
				end
		 	end
		 	puts "		fetching extension icon 16x16 from https://github.com/traa/creng"

	 		File.open("#{@projectname}/dev/images/extension-48x48.png", 'w') do |f|
			 	open("https://raw.github.com/traa/creng/master/lib/creng/vendor/images/extension-48x48.png", 'rb') do |read_file|
				    f.write(read_file.read)
				end
		 	end
		 	puts "		fetching extension icon 48x48 from https://github.com/traa/creng"

	 		File.open("#{@projectname}/dev/images/extension-64x64.png", 'w') do |f|
			 	open("https://raw.github.com/traa/creng/master/lib/creng/vendor/images/extension-64x64.png", 'rb') do |read_file|
				    f.write(read_file.read)
				end
		 	end
		 	puts "		fetching extension icon 64x64 from https://github.com/traa/creng"
	 	end


	 	def generateHTML

	 		File.open("#{@projectname}/dev/html/background.html", 'w') do |f|

	 			f.write <<-"...".gsub!(/^ {20}/, '')
                    <!doctype html>
                    <html>
                    <head>
</head>

<body>
  <center><h1>BACKGROUND PAGE</h1></center>
</body>


</html>
	 			...

		 	end
		 	puts "		create #{@projectname}/dev/html/background.html"

	 	end

	 end

end