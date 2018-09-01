#Test code
#-------------------------------------------------------------------------------

using FileIO2

#No real test code yet... just run demos:

#Use alias shorthands:
const ASCIIFmt = FileIO2.ASCIIFmt
const UTF8Fmt  = FileIO2.UTF8Fmt
const UTF16Fmt = FileIO2.UTF16Fmt
const UTF32Fmt = FileIO2.TextFormat{FileIO2.UTF32Encoding}

const ASCIIHTMLFmt = FileIO2.ASCIIHTMLFmt
const UTF16HTMLFmt = FileIO2.HTMLFormat{FileIO2.UTF16Encoding}

#For extra convenience:
const TextFile = File{TextFmt}
const ASCIIFile = File{ASCIIFmt}

const HTMLFile = File{FileIO2.HTMLFmt}

samplefile(filename) = 
	joinpath(FileIO2.rootpath, "test/samplefiles", filename)

sepline = "---------------------------------------------------------------------"



println("\nText clean/simple method to print out a text file:")
println(sepline)
print(read(File{FileIO2.TextFormat}(samplefile("textfile.txt")))) #This works on abstract types too
print(read(TextFile(samplefile("textfile.txt"))))
print(read(ASCIIFile(samplefile("asciifile.txt"))))
print(read(File{UTF8Fmt}(samplefile("utf8file.txt"))))

filelist = [
	#Prefered notation (no specific encoding):
	File{TextFmt}("generictextfile.txt")
	#Even better, in some instances:
	File(TextFmt, "generictextfile.txt")

	#Verbose constructor tests:
	File{FileIO2.TextFormat{FileIO2.UTF8Encoding}}("utf8file.txt")

	#Shorthand notation (alias made by user):
	ASCIIFile("asciifile.txt")
]

println("\n=====Test text file list:")
show(filelist)

filelist = [
	HTMLFile("generichtmlfile.html")
	File{UTF16HTMLFmt}("utf16htmlfile.html")
	File{ASCIIHTMLFmt}("asciihtmlfile.html")
]

println("\n=====Test HTML file list:")
show(filelist)

println("\n...Cast to simple text file list")
println("   (to process files with >>basic text<< handling code):")
show(File(FileIO2.TextFormat, filelist))

println("\n...Same thing with shorthand notation:")
println("   (to process files with >>basic text<< handling code):")
show(File(:text, filelist))


println("\nTry auto-detecting file:")
x=File("displaynogomsg.txt")

println("\nGet extensions for an html file:")
show(Extensions(HTMLFile)); println()

println("\nTest open/read/close dispatch system:")
println(sepline)

try; read(File(:bmp, "fakefile.bmp"))
catch e; @warn(e.msg)
end

module PNGReaderTest
	using FileIO2
	struct PNGReader1 <: AbstractReader{PNGFmt}; end
	struct PNGReader2 <: AbstractReader{PNGFmt}; end
	Base.open(r::Type{PNGReader1}, path::String) = #Throw error to look for working reader
		(msg = "$PNGReader1: Failed to open $path"; @warn(msg); error(msg))
	Base.open(r::Type{PNGReader2}, path::String) = @info("\nOpening $path...")
end
#using PNGReaderTest #no longer need to do "using"

open(File(:png, "fakefile.png"), read=true)

println("\nTest text reader system:")
println(sepline)

println("\nUse introspection to auto-select \"text\" reader:")
open(File(:text, samplefile("integer_data.txt")), read=true) do reader
	@show typeof(reader)
	while !eof(reader)
		data = read(reader, Int)
		println("Read: $(typeof(data))(`$data`)")
	end
end
#NOTE: Open :csv instead of :text if ',' is a desired separator

#Ensure we use FileIO2.TextReader - to ensure consisten
println("\nForce use of FileIO2.TextReader:")
open(FileIO2.TextReader, samplefile("integer_data.txt")) do reader
	while !eof(reader)
		data = read(reader, Int)
		println("Read: $(typeof(data))(`$data`)")
	end
end

:Test_Complete
