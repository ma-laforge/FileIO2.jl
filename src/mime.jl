#FileIO2 MIME support.
#-------------------------------------------------------------------------------

#==Constants
===============================================================================#
#TODO: Not sure if mime type strings are correct.
const MIMEASSOCIATIONS = Tuple{String,Symbol}[
	("image/bmp", :BMPFmt),
	("image/png", :PNGFmt),
	("image/gif", :GIFFmt),
	("image/jpeg", :JPEGFmt),
	("image/tiff", :TIFFFmt),

	("image/svg+xml", :SVGFmt),
	("image/cgm", :CGMFmt),
	("image/eps", :EPSFmt),
	("image/emf", :EMFFmt),
]

for (mtstr, fmt) in MIMEASSOCIATIONS; @eval begin #CODEGEN-----------------------

Base.show(stream, ::MIME{Symbol($mtstr)}, f::File{$fmt}) = write(stream, read(f.path, String))

end; end #CODEGEN---------------------------------------------------------------

#Last line
