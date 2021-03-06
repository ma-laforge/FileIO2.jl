#FileIO2: Method of categorizing/dispatching on data formats & files.
__precompile__(true)
module FileIO2

import Base: open, read, write, close
import Base: eof
import InteractiveUtils: subtypes

include("codegen.jl")
include("base.jl")
include("textfiles.jl")
include("mime.jl")

const rootpath = realpath(joinpath(dirname(realpath(@__FILE__)),"../."))

export File
export Extensions
export IOOptions, IOOptionsRead, IOOptionsWrite

#Useful file types/aliases:
#TODO: Stop exporting these aliases to avoid namespace pollution.
#TODO: Find a new way to export types (maybe collect them in a different submodule).
export TextFmt, CSVFmt
export HTMLFmt, XMLFmt, MarkdownFmt, AsciiDocFmt
export BMPFmt, PNGFmt, GIFFmt, JPEGFmt, TIFFFmt
export SVGFmt, CGMFmt, EPSFmt, EMFFmt, STLImgFmt

export AbstractDataIO, AbstractReader, AbstractWriter, AbstractDataIORW
#==Create your own reader/writer state machine using the following pattern:
struct MyDataType <: FileIO2.DataFormat; end
mutable struct MyReader <: AbstractReader{MyDataType}
...
end
==#

end #FileIO2
