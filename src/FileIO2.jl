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

end #FileIO2
