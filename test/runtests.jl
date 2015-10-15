#Test code
#-------------------------------------------------------------------------------

using FileIO2

#No real test code yet... just run demos:

#Use alias shorthands:
typealias ASCIIFmt FileIO2.ASCIIFmt
typealias UTF8Fmt  FileIO2.UTF8Fmt
typealias UTF16Fmt FileIO2.UTF16Fmt
typealias UTF32Fmt FileIO2.TextFormat{FileIO2.UTF32Encoding}

typealias ASCIIHTMLFmt FileIO2.ASCIIHTMLFmt
typealias UTF16HTMLFmt FileIO2.HTMLFormat{FileIO2.UTF16Encoding}

#For extra convenience:
typealias TextFile File{TextFmt}
typealias ASCIIFile File{ASCIIFmt}

typealias HTMLFile File{FileIO2.HTMLFmt}

filelist = [
	#Prefered notation (no specific encoding):
	File{TextFmt}("generictextfile.txt")

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


println("\nTry auto-detecting file:")
x=File("displaynogomsg.txt")

println("\nGet extensions for an html file:")
show(Extensions(HTMLFile)); println()


println("\nText clean/simple method to print out a text file:")
println("---------------------------------------------------------------------")
#print(read(TextFile(@__FILE__)))
print(read(ASCIIFile(@__FILE__)))

:Test_Complete
