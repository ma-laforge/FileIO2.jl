# FileIO2.jl

## Description

A very Julian way of describing files leveraging the built-in type system.  FileIO2.jl simply provides tools/patterns to register data types with Julia type system.

FileIO2.jl therefore competes with the solution found at: <http://github.com/JuliaIO/FileIO.jl>.

### Advantages (wrt FileIO.jl)

 - FileIO2.jl is a more lightweight module than FileIO.jl (Should probably have been named better).
  - New file/data format types do not have to be registered with the FileIO2.jl module.
  - Only types of imported (used) modules are made available (including those provided with FileIO2.jl).

### Disadvantages (wrt FileIO.jl)

 - No facilities to perform dynamic loading of IO module.
 - No ability to auto-detect filetype by extension.
 - No ability to auto-detect filetype by magic bytes.

### Points of Consideration

It might be a good idea to consolidate/re-organize the FileIO.jl and FileIO2.jl modules.

 - **A base module** could provide the base File object hierarchies and manipulation tools.
  - This module should be relatively static (unchanging).
 - **A registration module** could provide a repository of IO modules to that read/write different files.
  - This module would demonstrate how to register all the PNG readers, the MP3 readers, etc.
  - Users could then create a stripped-down version of the module to meet the needs of their application - thus avoiding complex dependencies.

### MIME Support

FileIO2.jl includes simple MIME support for images.  As a result, \*IJulia notebook users can display *IJulia-supported* images with very little code:

	display(File(:jpeg, "myfile.jpeg"))

Supported image formats include:

 - Pixel formats: `:bmp`, `:png`, `:gif`, `:jpeg`, `:tiff`
 - Vector formats: `:svg`, `:cgm`, `:eps`, `:emf`

### More Sample Code

Sample code is provided under the [test directory](test/).

### Philosophy

#### `open`, `read`, `write`, `load`, and `save`

 - **`open`**: Opens a file, and read sufficient header data to return an object of `T<:AbstractReader` / `T<:AbstractWriter`.  These objects are basically higher-level versions of IO streams.
 - **`read`**: Reads data with whatever granularity the module developper desires (ex: individual `Int`/`String`/..., a large data block, or even an entire file).
  - `read(::Type{TIO<:AbstractReader}, ::File{T<:FileIO2.DataFormat}, ...)`: Equivalent to `load` for user-defined reader-only state machines.
  - `read(::Type{TIO<:AbstractDataIORW}, ::File{T<:FileIO2.DataFormat}, ...)`: Equivalent to `load` for user-defined read/write-capable state machines.
  - `read(r::TIO<:{AbstractReader/AbstractDataIORW}, ::Type{T<:DataType})`: Reads a value of type `T`, using `r`.  Example: `val = read(myreader, Float64)`.
 - **`write`**: Writes data with whatever granularity the module developper desires (ex: individual `Int`/`String`/..., a large data block, or even an entire file).
  - `write(::TIO<:AbstractWriter, ::File{T<:FileIO2.DataFormat}, ...)`: Equivalent to `save` for user-defined writer-only state machines.
  - `write(::TIO<:AbstractDataIORW, ::File{T<:FileIO2.DataFormat}, ...)`: Equivalent to `save` for user-defined read/write-capable state machines.
 - **`load`**: The simplest interface to reading in data.  Performs `open`/`read`\*/`close` in one convenient function.
  - **DEPRECATED** Please overload the `read()` function as described above.
 - **`save`**: The simplest interface to writing data.  Performs `open`/`write`\*/`close` in one convenient function.
  - **DEPRECATED** Please overload the `write()` function as described above.

#### Principal Types

 - **`FileIO2.DataFormat`**: (abstract) Identifies a data format, as opposed to a file.
 - **`FileIO2.DataEncoding`**: (abstract) Identifies the type of data encoding used.  Can be used to specialize a type `T<:DataFormat`.
  - Can use `UnknownTextEncoding` to describe "generic" versions of a type.  For example: `const TextFmt = TextFormat{UnknownTextEncoding}` defines `TextFmt` to represent any text data format (irrespective of the data encoding used).
  - TODO: Does anybody really need to specialize a `DataFormat` with a particular encoding?
 - **`AbstractReader{DataFormat}`**: (abstract) Used to define an object for reading from a stream formatted with `DataFormat`.
 - **`AbstractWriter{DataFormat}`**: (abstract) Used to define an object for writing to a stream formatted with `DataFormat`.
 - **`AbstractDataIORW{DataFormat}`**: (abstract) Used to define an object for reading/writing to a stream formatted with `DataFormat`.
 - **`File{DataFormat}`**: An object used to dispatch to the appropriate `open`/`load`/`save`/... functions.

#### Constructing `File` Objects (Shorthand)

The simplest way to construct a `File` object is to call the "shorthand" method: `File(::Symbol, ::String)`.  For example:

		f1 = File(:text, "myfile.txt")
		f2 = File(:png, "myimage.png")
		f3 = File(:html, "myfile.html")
		
		#When html files need to be recognized as simple text files:
		f3 = File(:text, "myfile.html")

This method allows different `File` specializations to be constructed without exporting different `DataFormat` type identifiers (namespace pollution).

##### User-Defined `File` Constructors (Shorthand)

To register a user-defined `File` constructor with this shorthand notation, simply add the following method declaration:

		FileIO2.File(::FileIO2.Shorthand{[NEWFMTSYMBOL]}, path::String) = File{[NEWFMT<:DataFormat]}(path)

For example, the "text" format can be registered using:

		FileIO2.File(::FileIO2.Shorthand{:text}, path::String) = File{FileIO2.TextFmt}(path)

#### Opening `File` for read/write

		file = File(:png, "myfile.png")
		reader = open(file, read=true) #Default is read=true

NOTE: A module developper must have first defined a .png reader object:

		type MyPNGReader <: AbstractReader{PNGFmt}; end
		Base.open(r::Type{MyPNGReader}, f::File{PNGFmt}, ...) = ...

A user can therefore call `open` with this specific reader:

		open(MyPNGReader, file, read=true)

## Known Limitations

FileIO2.jl tries to minimize the set of exported types/aliases until a better way is found for the user to import them.  At the moment, exporting too much pollutes the symbol namespace - making collisions between modules highly likely.

### Compatibility

Extensive compatibility testing of FileIO2.jl has not been performed.  The module has been tested using the following environment(s):

 - Linux / Julia-1.1.1 (64-bit).

## Disclaimer

The FileIO2.jl module is not yet mature.  Expect significant changes.

This software is provided "as is", with no guarantee of correctness.  Use at own risk.
