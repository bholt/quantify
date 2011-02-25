#!/usr/bin/env ruby

class DiffController
	#outlets
	attr_accessor :fieldA, :fieldB, :diffView, :comparisonChooser, :fieldTotal
	attr_accessor :filenameA, :filenameB
	
	def initialize()
		@numberRe = /((\d+(\.\d*)?)|(\.\d+)([eE][+-]?\d+)?)/
	end
	
	#actions
	def fieldA_Entered(sender)
		filename = fieldA.stringValue
		
		if filename != @filenameB
			@filenameA = filename
			puts @filenameA
			diff()
		end
	end
	
	def fieldB_Entered(sender)
		filename = fieldB.stringValue
		
		if filename != @filenameB
			@filenameB = filename
			puts @filenameB
			diff()
		end
	end
	
	def diff()
		if @filenameA == nil or @filenameB == nil
			return
		end
		
		numberRe = /((\d+(\.\d*)?)|(\.\d+)([eE][+-]?\d+)?)/
		
		s = diffView.textStorage
		
#		s.beginEditing
		
		fA = File.new(@filenameA, "r")
		fB = File.new(@filenameB, "r")
		
		while (lineA = fA.gets && lineB = fB.gets)
			puts "lineA:#{lineA} lineB:#{lineB}"
			iterA = lineA.scan(numberRe)
			iterB = lineB.scan(numberRe)
			iterA.zip(iterB) do |tokA, tokB| 
				if tokA == nil
					puts "tokA nil"
				elsif tokB == nil
					puts "tokB nil"
				else
					puts "tokA: #{tokA.offset(0)[0]} #{tokA.offset(0)[]}" 
					#puts "tokB: #{tokB.begin()} #{tokB.end()}"
				end
			end
		end
	end
end

def diff(filenameA, filenameB)
	if filenameA == nil or filenameB == nil
		return
	end
	
	numberRe = /((\d+(\.\d*)?)|(\.\d+)([eE][+-]?\d+)?)/
	
	fA = File.new(filenameA, "r")
	fB = File.new(filenameB, "r")
	
	while (lineA = fA.gets && lineB = fB.gets)
		puts "lineA:#{lineA} lineB:#{lineB}"
		iterA = lineA.scan(numberRe)
		iterB = lineB.scan(numberRe)
		iterA.zip(iterB) do |tokA, tokB| 
			if tokA == nil
				puts "tokA nil"
			elsif tokB == nil
				puts "tokB nil"
			else
				puts "tokA: #{tokA.offset(0)[0]} #{tokA.offset(0)[]}"
			end
		end
	end
end

class String
	def scan_matches(re)
		list = []
		self.scan(re) {
			list << $~
		}
		return list
	end
end

numberRe = /((\d+(\.\d*)?)|(\.\d+)([eE][+-]?\d+)?)/

lineA = " this is 1.0 strings with numbers like 2.0. Not too hard."
lineB = "2.0 3.0"

matchesA = lineA.scan_matches(numberRe)
matchesB = lineB.scan_matches(numberRe)

matchesA.zip(matchesB) do |a, b|
	puts "a: #{a.begin(0)} b: #{b.begin(0)}"
end

matches = lineA.scan_matches(/s/)
puts "matches[0].begin: #{matches[1].begin 0}"

startA, startB = 0, 0

#while tokA = lineA.match(numberRe) && tokB = lineB.match(numberRe)
#	puts "tokA:#{tokA} #{tokA.offset(0)}"
#end

if m = lineA.match(numberRe)
	puts m
end

lineA.match(numberRe) { |m| puts "test" }
#	puts "test"
#	puts "m:#{m} begin:#{m.begin(0)} end:#{m.end(0)}"
#}
