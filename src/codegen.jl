#FileIO2 code generation tools

#==Object builders
===============================================================================#


#==Function builders
===============================================================================#

#Generate a Base.show(File{}) Expr with a simplified (readable) signature.
function genexpr_ShowSimpleFileSign(fmt::Symbol)
	fmtstr = string(fmt)
	#TODO: how to escape fmt??? only know how to escape Expr
	return :(Base.show(io::IO, f::File{$fmt}) = print(io, "File{", $fmtstr, "}(\"$(f.path)\")"))
end

#==TODO:
Figure out how to make a macro in order to call genexpr_ShowSimpleFileSig using
nice syntax like:
	@Gen_ShowSimpleFileSign TextFmt HTMLFmt ...

#Generate Base.show(File{}) functions with a simplified (readable) signature.
macro Gen_ShowSimpleFileSig(fmtlist...)
	fnlist = Expr[]
	for fmt in fmtlist
		push!(fnlist, expr_FileShowSimple(fmt))
	end
	return [expr_FileShowSimple(fmt)) for fmt in fmtlist]
end
==#
#Last line
