#FileIO2: Method of categorizing/dispatching on data formats & files.
module FileIO2

include("codegen.jl")
include("base.jl")
include("textfiles.jl")

export File
export Extensions

#Useful file types/aliases:
export TextFmt, CSVFmt
export HTMLFmt, XMLFmt, MarkdownFmt, AsciiDocFmt
export BMPFmt, PNGFmt, GIFFmt, JPEGFmt, TIFFFmt
export SVGFmt, CGMFmt, EPSFmt, EMFFmt, STLImgFmt

#Base does not export load/save... so FileIO2 will "own" the symbols:
#NOTE: Must define dummy functions in order to export.
load() = throw("Nothing to load")
save() = throw("Nothing to save")
export load, save

export AbstractReader, AbstractWriter
#==Create your own reader/writer state machine using the following pattern:
immutable MyDataType <: FileIO2.DataFormat; end
type MyReader <: AbstractReader{MyDataType}
...
end
==#

end #FileIO2
