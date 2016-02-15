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
immutable Shorthand{T}; end; #Temp: used to dispatch on symbol (ex: Shorthand{:png})
Shorthand(datafmt::Symbol) = Shorthand{datafmt}();

abstract DataFormat;
abstract UnknownDataFormat <: DataFormat

#Image formats:
abstract ImageFormat{E<:DataEncoding} <: DataFormat
abstract PixelImageFormat{E<:DataEncoding} <: ImageFormat{E}
abstract VectorImageFormat{E<:DataEncoding} <: ImageFormat{E}

#File object definitions
#-------------------------------------------------------------------------------
type File{T<:DataFormat}
	path::AbstractString
end
typealias UnknownFileFormat File{UnknownDataFormat}

#Handy way to construct file objects:
File(path::AbstractString) = info("TODO: Implement filetype auto-detection")
File{T<:DataFormat}(::Type{T}, path::AbstractString) = File{T}(path)
#Shortcut to construct file object of default data format wrt symbol:
File(datafmt::Symbol, path::AbstractString) = File(Shorthand(datafmt), path)
File{T}(::Shorthand{T}, path::AbstractString) =
	throw(ArgumentError("Unrecognized data format: File(:$T, ::AbstractString)"))


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
abstract DSVFormat{E<:TextEncoding, D<:DelimiterScheme} <: TextFormat{TextEncoding}
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


#==Default File object constructors
===============================================================================#
File(::Shorthand{:text}, path::AbstractString) = File{TextFmt}(path)
File(::Shorthand{:csv}, path::AbstractString) = File{CSVFmt}(path)
File(::Shorthand{:html}, path::AbstractString) = File{HTMLFmt}(path)
File(::Shorthand{:xml}, path::AbstractString) = File{XMLFmt}(path)
File(::Shorthand{:md}, path::AbstractString) = File{MarkdownFmt}(path)
File(::Shorthand{:adoc}, path::AbstractString) = File{AsciiDocFmt}(path)

File(::Shorthand{:svg}, path::AbstractString) = File{SVGFmt}(path)
File(::Shorthand{:cgm}, path::AbstractString) = File{CGMFmt}(path)
File(::Shorthand{:eps}, path::AbstractString) = File{EPSFmt}(path)
File(::Shorthand{:emf}, path::AbstractString) = File{EMFFmt}(path)
File(::Shorthand{:stl}, path::AbstractString) = File{STLImgFmt}(path)

File(::Shorthand{:bmp}, path::AbstractString) = File{BMPFmt}(path)
File(::Shorthand{:png}, path::AbstractString) = File{PNGFmt}(path)
File(::Shorthand{:gif}, path::AbstractString) = File{GIFFmt}(path)
File(::Shorthand{:jpeg}, path::AbstractString) = File{JPEGFmt}(path)
File(::Shorthand{:tiff}, path::AbstractString) = File{TIFFFmt}(path)


#==File object casting functions
===============================================================================#
#TODO: Add more casting functions for other DataFormat types
#Question: Should casting be done using Base.convert instead?

File(datafmt::Symbol, f::File) = File(Shorthand(datafmt), f)
File{T,TF<:File}(::Shorthand{T}, f::TF) =
	throw(ArgumentError("Conversion not possible: File($T, ::$TF)"))

#Markup language --> plain text:
#TODO: Use convert()??
File{E<:TextEncoding}(::Type{TextFormat}, f::File{HTMLFormat{E}}) = File(TextFormat{E}, f.path)
File{E<:TextEncoding}(::Shorthand{:text}, f::File{HTMLFormat{E}}) = File(TextFormat{E}, f.path)

#Casting on Vector{File} to arbitrary data format:
File{RFMT<:DataFormat, VT<:File}(::Type{RFMT}, v::Vector{VT}) = map((f)->File(RFMT, f), v)
File{VT<:File}(datafmt::Symbol, v::Vector{VT}) = map((f)->File(datafmt, f), v)

#==Generic data reader/writer functions
===============================================================================#
#Define generic interface for user-defined reader/writer state-machines:
abstract AbstractDataIO{READ,WRITE,T<:DataFormat}
typealias AbstractDataIORW{T<:DataFormat} AbstractDataIO{true,true,T} #Same state machine to read/write
#If user prefers to seperate reader/writer state machines:
typealias AbstractReader{T<:DataFormat} AbstractDataIO{true,false,T}
typealias AbstractWriter{T<:DataFormat} AbstractDataIO{false,true,T}

#Identify IO options & make it easier to dispatch on types (ex: read function):
immutable IOOptions{READ,WRITE}
	create::Bool
	truncate::Bool
	append::Bool
end
typealias IOOptionsRead IOOptions{true,false}
typealias IOOptionsWrite IOOptions{false,true}
typealias IOOptionsReadWrite IOOptions{true,true}
function IOOptionsWrite(write::Bool, create::Bool, truncate::Bool, append::Bool)
	write = write||create||truncate||append
	create = write #Don't create for read-only
	return (write, create, truncate, append)
end
function IOOptionsWrite(write::Bool, create::Void, truncate::Bool, append::Bool)
	write = write||truncate||append
	create = write #Don't create for read-only
	return (write, create, truncate, append)
end
function IOOptions(;read=nothing, write::Bool=false,
	create = nothing, truncate::Bool=false, append::Bool=false)

	(write, create, truncate, append) = IOOptionsWrite(write, create, truncate, append)
	if nothing==read
		#if user specified write, default is no read;
		#if user did not specify write, default is read.
		read = !write
	end
	return IOOptions{read, write}(create, truncate, append)
end


#==Base _open "algorithm" (not exported externally)
===============================================================================#

#Open for read:
function _open{DF<:DataFormat}(fn::Function, f::File{DF}, ::IOOptionsRead, args...; kwargs...)
	readerlist = subtypes(AbstractReader{DF})
	dataiolist = subtypes(AbstractDataIORW{DF})
	if length(readerlist) + length(dataiolist) < 1
		msg = "No registered readers for $DF"
		error(msg)
	end
	for reader in readerlist; try
		result = fn(reader, f.path, args...; kwargs...)
		return result
	end; end
	for reader in dataiolist; try
		result = fn(reader, f.path, args...; kwargs...)
		return result
	end; end
	listall = vcat(readerlist, dataiolist)
	msg = "Failed to $fn $f with readers: $listall"
	error(msg)
end

#Open for write:
function _open{DF<:DataFormat}(fn::Function, f::File{DF}, opt::IOOptionsWrite, args...; kwargs...)
	writerlist = subtypes(AbstractWriter{DF})
	dataiolist = subtypes(AbstractDataIORW{DF})
		writerlist = vcat(writerlist, dataiolist)
	if length(writerlist) < 1
		msg = "No registered writers for $DF"
		error(msg)
	end
	for writer in writerlist; try
		result = fn(writer, f.path, args...; kwargs..., opt=opt)
		return result
	end; end
	msg = "Failed to $fn $f with writers: $writerlist"
	error(msg)
end

#Open for read/write (Neither pure readers nor writers):
function _open{DF<:DataFormat}(fn::Function, f::File{DF}, opt::IOOptions, args...; kwargs...)
	dataiolist = subtypes(AbstractDataIORW{DF})
	if length(dataiolist) < 1
		msg = "No registered AbstractDataIO for $DF"
		error(msg)
	end
	for dataio in dataiolist; try
		result = fn(dataio, f.path, args...; kwargs..., opt=opt)
		return result
	end; end
	msg = "Failed to $fn $f with AbstractDataIO: $dataiolist"
	error(msg)
end

#==Generic open/close read/write functions
===============================================================================#
#(High-level API called by user)

function open(f::File, args...; read=nothing, write::Bool=false,
	create=nothing, truncate::Bool=false, append::Bool=false, kwargs...)
	opt = IOOptions(read=read, write=write, create=create, truncate=truncate, append=append)
	return _open(open, f, opt, args...; kwargs...)
end

#Support open-do (default declaration does not support kwargs...):
function open(fn::Function, file::File, args...; kwargs...)
    reader = open(file, args...; kwargs...)
    try
        fn(reader)
    finally
        close(reader)
    end
end

function read(f::File, args...; kwargs...)
	return _open(read, f, IOOptions(read=true), args...; kwargs...)
end

function write(f::File, args...; kwargs...)
	return _open(write, f, IOOptions(write=true), args...; kwargs...)
end

#Support for open() do syntax:
function open{IOT<:AbstractDataIO}(fn::Function, iot::Type{IOT}, args...; kwargs...)
	io = open(iot, args...; kwargs...)
	try
		return fn(io)
	finally
		close(io)
	end
end

#Read in entire file using a particular reader:
function read{T<:AbstractReader}(RT::Type{T}, path::AbstractString)
	open(RT, path) do reader
		return readall(reader)
	end
end

#Define generic read(reader, filepath) functionality:
function read{T<:AbstractReader}(RT::Type{T}, path::AbstractString, args...; kwargs...)
	open(RT, path) do reader
		return read(reader, args...; kwargs...)
	end
end

#Define generic write(writer, filepath) functionality:
function write{T<:AbstractWriter}(WT::Type{T}, path::AbstractString, args...;
	opt::IOOptionsWrite=IOOptions(write=true), kwargs...)
	open(WT, path, opt=opt) do writer
		return write(writer, args...; kwargs...)
	end
end


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
