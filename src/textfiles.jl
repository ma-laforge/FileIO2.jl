#FileIO2 tools to manipulate text files
#-------------------------------------------------------------------------------

#==Implements a text reader.

NOTE: Uses inefficient high-level tools (readline/split) to provide functionnality.
==#


#==Constants
===============================================================================#
const splitter_default = [' ', '\t']
const splitter_csv = [' ', '\t', ',']

#==Main data structures
===============================================================================#
type TextReader{T<:TextFormat} <: AbstractReader{T}
	s::IO
	splitter
	linebuf::Vector
end

#Define default TextReader - when text format not (fully) specified:
call(::Type{TextReader}, s::IO, splitter, linebuf::Vector) =
	TextReader{TextFormat{UnknownTextEncoding}}(s, splitter, linebuf)
call(::Type{TextReader{TextFormat}}, s::IO, splitter, linebuf::Vector) =
	TextReader{TextFormat{UnknownTextEncoding}}(s, splitter, linebuf)

#Default splitter value:
call{T<:TextReader}(RT::Type{T}, s::IO, splitter = splitter_default) =
	RT(s, splitter, AbstractString[])


#==Helper functions
===============================================================================#
#Advance TextReader linebuf, if necessary:
#TODO: Re-implement with more efficient, lower level functions
function refreshbuf(r::TextReader)
	while length(r.linebuf) < 1
		if eof(r.s); throw(EOFError()); end
		linebuf = split(chomp(readline(r.s)), r.splitter)

		for token in linebuf
			if token != ""
				push!(r.linebuf, token)
			end
		end
	end
end


#==Open/read/close functions
===============================================================================#

open{T<:TextReader}(RT::Type{T}, path::AbstractString, splitter = splitter_default) =
	RT(open(path, "r"), splitter)
open{T<:CSVFormat}(RT::Type{TextReader{T}}, path::AbstractString, splitter = splitter_csv) =
	RT(open(path, "r"), splitter)

#Read in entire text file as string
function read{T<:TextReader}(RT::Type{T}, path::AbstractString)
	open(RT, path) do reader
		return readall(reader.s)
	end
end

#Read in next token as String:
function read{DT<:AbstractString}(r::TextReader, ::Type{DT})
	refreshbuf(r)
	v = shift!(r.linebuf)
	try
		#Read ahead if necessary (Update state for eof()):
		refreshbuf(r)
	end
	return v
end

#Read in next token & interpret as of type DT:
function read{DT}(r::TextReader, ::Type{DT})
	return parse(DT, read(r, AbstractString))
end

#Read in next token & interpret as most appropriate type:
function read(r::TextReader, ::Type{Any})
	return parse(read(r, AbstractString))
end


close(r::TextReader) = close(r.s)

#==Support functions
===============================================================================#
eof(r::TextReader) = (eof(r.s) && length(r.linebuf) < 1)

function Base.readline(r::TextReader)
	linebuf = []
	return readline(r.s)
end

function Base.readall(r::TextReader)
	linebuf = []
	return readall(r.s)
end

#Last line
