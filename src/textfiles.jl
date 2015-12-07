#FileIO2 tools to manipulate text files
#-------------------------------------------------------------------------------

#Read in entire text file as string
#TODO: Add exception handling
#NOTE: Does not implement an "AbstractReader" object...
#TODO: Change to conform to new system.
#-------------------------------------------------------------------------------
function Base.read{T<:TextFormat}(f::File{T})
	s = open(f.path)
	data = readall(s)
	close(s)
	return data
end

#Last line
