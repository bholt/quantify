#
#  DiffController.rb
#  QuantifyX
#
#  Created by Brandon Holt on 2/3/11.
#

framework 'Cocoa'

class String
	def scan_matches(re)
		list = []
		self.scan(re) {
			list << $~
		}
		return list
	end
end

#relative error calculation
def compare(a, b)
	(b - a) / b
end

	def Absolute(a, b)	b-a  end
	def Relative(a, b)	(b-a)/((b+a)/2)  end
	def Error(a, b)		(a-b)/b  end
		
	Value = Struct.new(:func, :on, :value, :color, :colorValue)

class DiffController < NSWindowController
	
	#outlets
	attr_accessor :fieldA, :fieldB, :diffView, :comparisonChooser, :fieldTotal
	
	def awakeFromNib()
		@numberRe = /((\d+(\.\d*)?)|(\.\d+)([eE][+-]?\d+)?)/
		@compare = {
			"Absolute" => Value.new(:Absolute, false, 0, "blue", NSColor.blueColor),
			"Relative" => Value.new(:Relative, true, 0, "green", NSColor.greenColor),
			"Error"    => Value.new(:Error, false, 0, "red", NSColor.redColor)
		}
		
		@compare.each_with_index do |(key, value), index|
			puts "key:#{key} value:#{value.color} index:#{index}"
			
			path = NSBundle.mainBundle.pathForResource(value.color, ofType:"png")
			
			puts path
			
			img = NSImage.alloc.initWithContentsOfFile(path)
			img.setSize([15,15])
			@comparisonChooser.setImage(img, forSegment:index)
		end
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
	
	def segSelected(sender)
		id = sender.selectedSegment
		@compare[sender.labelForSegment(id)].on = sender.isSelectedForSegment(id)
		diff()
	end
	
	def diff()
		if @filenameA == nil or @filenameB == nil
			return
		end
		
		@compare.each do |key, c|
			c.value = 0
		end
		
		s = diffView.textStorage
		
		s.beginEditing
		s.addAttribute(NSForegroundColorAttributeName, value:NSColor.blackColor, range:[0,s.length])
		 
		fA = File.new(@filenameA, "r")
		fB = File.new(@filenameB, "r")
		
		total = 0
		count = 0
		
		difftext = ""
		
		attrs = []
		
		while (lineA = fA.gets and lineB = fB.gets)
			iterA = lineA.scan_matches(@numberRe)
			iterB = lineB.scan_matches(@numberRe)
			
			iterA.zip(iterB) do |tokA, tokB| 
				if tokA == nil
					puts "tokA nil"
				elsif tokB == nil
					puts "tokB nil"
				else
					difftext += "<"
					#diffView.insertText("<", color:NSColor.blackColor)
					temp = ""
					
					valA, valB = tokA.to_s.to_f, tokB.to_s.to_f
					@compare.each do |key, c|
						if c.on
							c.value += send(c.func, valA, valB)
							valueText = "%6.3f"%c.value
							
							colorStart = difftext.size + temp.size
							colorLen = valueText.size
							
							attrs << [c.colorValue, colorStart, colorLen]
							
							temp += valueText + "|"
							#diffView.insertText(valueText, color:c.colorValue)
							#diffView.insertText("|", color:NSColor.blackColor)
						end
					end
					temp.chop! #remove trailing '|'
					
					count += 1
					difftext += temp + "> "
					#diffView.insertText("> ", color:NSColor.blackColor)
				end
			end
			difftext.chop!
			difftext += "\n"
			#diffView.insertText("\n", color:NSColor.blackColor)
		end
		
		agregate = ""
		@compare.each do |key, c|
			agregate += "<#{"%6.3f"%(c.value/count)}> " if c.on
		end
		agregate.chop!
		
		fieldTotal.setStringValue(agregate)
		
		s.replaceCharactersInRange([0, s.length], withString: difftext)
		
		s.setFont(NSFont.fontWithName("Menlo", size:11))
		
		attrs.each do |r|
			s.addAttribute(NSForegroundColorAttributeName, value:r[0], range:[r[1],r[2]])
		end
		
		s.endEditing
	end
end
