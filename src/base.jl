#FileIO2 base types & core functions
#-------------------------------------------------------------------------------

#==Lists for code generation
===============================================================================#
fmtsymblist = Symbol[] #List of sybols corresponding to DataFormat types


#==Data encoding definitions
===============================================================================#
abstract DataEncoding
abstract BinaryEncoding <: DataEncoding
abstract TextEncoding <: DataEncoding
abstract UnknownEncoding <: DataEncoding

#TODO: Add Endianess for Binary encoding??

#Specific text encoding schemes:
abstract UnknownTextEncoding <: TextEncoding
abstract Unicode <: TextEncoding
abstract ASCIIEncoding <: TextEncoding
abstract UTF8Encoding <: Unicode
abstract UTF16Encoding <: Unicode
abstract UTF32Encoding <: Unicode


#==Generic data format/file definitions
===============================================================================#
abstract DataFormat;
abstract UnknownDataFormat <: DataFormat

#Image formats:
abstract ImageFormat{E<:DataEncoding} <: DataFormat
abstract PixelImageFormat{E<:DataEncoding} <: ImageFormat{E}
abstract VectorImageFormat{E<:DataEncoding} <: ImageFormat{E}

#File object definitions
#-------------------------------------------------------------------------------
type File{T<:DataFormat}
	path::String
end
typealias UnknownFileFormat File{UnknownDataFormat}

#Handy way to construct file objects:
File{T}(::Type{T}, path::String) = File{T}(path)
File(path::String) = info("TODO: Implement filetype auto-detection")


#==Text format definitions
===============================================================================#
abstract TextFormat{E<:TextEncoding} <: DataFormat

#Handy aliases (Eventually want to export aliases):
#-------------------------------------------------------------------------------
typealias TextFmt TextFormat{UnknownTextEncoding}
typealias ASCIIFmt TextFormat{ASCIIEncoding}
typealias UTF8Fmt  TextFormat{UTF8Encoding}
typealias UTF16Fmt TextFormat{UTF16Encoding}
typealias UTF32Fmt TextFormat{UTF32Encoding}
push!(fmtsymblist, :TextFmt, :ASCIIFmt, :UTF8Fmt, :UTF16Fmt, :UTF32Fmt)

#Specify expected file extensions:
Extensions(::Type{File{TextFmt}}) = ["txt", "log", "dat", "csv"]


#==Tabular (text) data format definitions
===============================================================================#
#Identify Delimiter Seperated Value (DSV) schemes:
abstract DelimiterScheme
abstract SpaceDelimiters <: DelimiterScheme
abstract TabDelimiters <: DelimiterScheme
abstract CommaDelimiters <: DelimiterScheme
#Actually use the ASCII codes created to store table data to file:
abstract ASCIIDelimiters <: DelimiterScheme

#Delimiter seperated values:
abstract DSVFormat{E<:TextEncoding, D<:DelimiterScheme} <: DataFormat
abstract CSVFormat{E<:TextEncoding} <: DSVFormat{E, CommaDelimiters}
	typealias CSVFmt CSVFormat{UnknownTextEncoding}
push!(fmtsymblist, :CSVFmt)


#==Markup language data format definitions
===============================================================================#
abstract HTMLFormat{E<:TextEncoding} <: DataFormat
abstract XMLFormat{E<:TextEncoding} <: DataFormat
abstract MarkdownFormat{E<:TextEncoding} <: DataFormat
abstract AsciiDocFormat{E<:TextEncoding} <: DataFormat

#TODO: Is the above better, or should we structure things this way:
#abstract HTMLFmt{E<:TextEncoding} <: TextFormat{E}
#...or how about:
#abstract HTMLFmt{TextFormat} <: DataFormat
#???
#...Try to figure out which way is most natural/easiest to use...

#Handy aliases
#-------------------------------------------------------------------------------
typealias HTMLFmt HTMLFormat{UnknownTextEncoding}
typealias ASCIIHTMLFmt HTMLFormat{ASCIIEncoding}
typealias UTF8HTMLFmt  HTMLFormat{UTF8Encoding}
push!(fmtsymblist, :HTMLFmt, :ASCIIHTMLFmt, :UTF8HTMLFmt)

typealias XMLFmt XMLFormat{UnknownTextEncoding}
typealias MarkdownFmt MarkdownFormat{UnknownTextEncoding}
typealias AsciiDocFmt AsciiDocFormat{UnknownTextEncoding}
#TODO: Register others
push!(fmtsymblist, :XMLFmt, :MarkdownFmt, :AsciiDocFmt)

#Specify expected file extensions:
Extensions(::Type{File{HTMLFmt}}) = ["htm", "html"]


#==Bitmap image formats
===============================================================================#
abstract BMPFmt  <: PixelImageFormat{BinaryEncoding}
abstract PNGFmt  <: PixelImageFormat{BinaryEncoding}
abstract GIFFmt  <: PixelImageFormat{BinaryEncoding}
abstract JPEGFmt <: PixelImageFormat{BinaryEncoding}
abstract TIFFFmt <: PixelImageFormat{BinaryEncoding}
#NOTE: Default show() function gives desired result
push!(fmtsymblist, :BMPFmt, :PNGFmt, :GIFFmt, :JPEGFmt, :TIFFFmt)


#==Vector image formats
===============================================================================#
abstract SVGFormat{E<:DataEncoding} <: VectorImageFormat{E}
	typealias SVGFmt SVGFormat{UnknownEncoding}
abstract CGMFmt <: VectorImageFormat{BinaryEncoding}
abstract EPSFormat{E<:TextEncoding} <: VectorImageFormat{E}
	typealias EPSFmt EPSFormat{UnknownTextEncoding}
abstract EMFFmt <: VectorImageFormat{BinaryEncoding}
abstract STLImgFormat{E<:TextEncoding} <: VectorImageFormat{E}
	typealias STLImgFmt SVGFormat{UnknownTextEncoding}
push!(fmtsymblist, :SVGFmt, :CGMFmt, :EPSFmt, :EMFFmt, :STLImgFmt)


#==File object casting functions
===============================================================================#
#TODO: Add more casting functions for other DataFormat types
#Question: Should casting be done using Base.conv instead?

#Markup language --> plain text:
File{E<:TextEncoding}(::Type{TextFormat}, f::File{HTMLFormat{E}}) = File(TextFormat{E}, f.path)

#Casting on Vector{File} to arbitrary data format:
File{RFMT<:DataFormat, VT<:File}(::Type{RFMT}, v::Vector{VT}) = map((f)->File(RFMT, f), v)


#==Generate friendly show functions
===============================================================================#
Base.string(f::File) = f.path

for fmt in fmtsymblist
	eval(genexpr_ShowSimpleFileSign(fmt))
end

function Base.show{T<:File}(io::IO, filelist::Vector{T})
	typestr = string(T)
	print(io, "$typestr[\n")
	for f in filelist
		print(io, "   "); show(io, f); println(io)
	end
	print(io, "]\n")
end

#Last line
