# FileIO2.jl

## Description

A very Julian way of describing files leveraging the built-in type system.  FileIO2.jl simply provides tools/patterns to register data types with Julia type system.

FileIO2.jl therefore competes with the solution found at: <http://github.com/JuliaIO/FileIO.jl>.

### Advantages (wrt FileIO.jl)

 - FileIO2.jl is a more lightweight module than FileIO.jl (Should probably be called FileIOLight.jl).
  - New file/data format types do not have to be registered with the FileIO2.jl module.
  - Only types of imported (used) modules are made available (including those provided with FileIO2.jl).

### Disadvantages (wrt FileIO.jl)

 - TODO: Add disadvantages.

### Sample Code

Sample code is provided under the [test directory](test/).

### Philosophy

#### `open`, `read`, `write`, `load`, and `save`

 - **`open`**: Opens a file, and read sufficient header data to return an object of `T<:DataReader` / `T<:DataWriter`.  These objects are basically higher-level versions of IO streams.
 - **`read`**: Reads data with whatever granularity the module developper desires (ex: individual `Int`/`String`/..., a large data block, or even an entire file).
 - **`write`**: Writes data with whatever granularity the module developper desires (ex: individual `Int`/`String`/..., a large data block, or even an entire file).
 - **`load`**: The simplest interface to reading in data.  Performs `open`/`read`\*/`close` in one convenient function.
  - DEPRECATE? It might be simpler to simply overload the `read(::File)` function.  This should not interfere with the primary role of `read` (`read{::DataReader, ...}` methods).
 - **`save`**: The simplest interface to writing data.  Performs `open`/`write`\*/`close` in one convenient function.
  - DEPRECATE? Same argument as with `load`, but using `write`.

#### Principal Types

 - **`DataFormat`**: (abstract) Identifies a data format, as opposed to a file.
 - **`DataEncoding`**: (abstract) Identifies the type of data encoding used.  Can be used to specialize a type `T<:DataFormat`.
  - Can use `UnknownTextEncoding` to describe "generic" versions of a type.  For example: `typealias TextFmt TextFormat{UnknownTextEncoding}` defines `TextFmt` to represent any text data format (irrespective of the data encoding used).
  - TODO: Does anybody really need to specialize a `DataFormat` with a particular encoding?
 - **`AbstractReader{DataFormat}`**: (abstract) Used to define an object for reading stream formatted with `DataFormat`.
 - **`File{DataFormat}`**: An object used to dispatch to the appropriate `open`/`load`/`save`/... functions.

#### Constructing `File`

The simplest way to construct a `File` object is to call the particular method: `File(::Symbol, ::AbstractString)`.  For example:

		f1 = File(:text, "myfile.txt")
		f2 = File(:png, "myimage.png")
		f3 = File(:html, "myfile.html")
		
		#When html files need to be recognized as simple text files:
		f3 = File(:text, "myfile.html")

This method allows different `File` specializations to be constructed without exporting different `DataFormat` type identifiers (namespace pollution).

**NOTE**: When new file types are added, someone must define the functions that map these symbols to a particular `DataFormat`.  See source code for examples.

#### Opening `File` for read/write

		file = File(:png, "myfile.png")
		reader = open(:read, file)

NOTE: The user must define a .png reader file:

		type PNGReader <: AbstractReader{PNGFmt}; end
		open(r::Type{PNGReader}, f::File{PNGFmt}, ...) = ...

## Known Limitations

FileIO2.jl tries to minimize the set of exported types/aliases until a better way is found for the user to import them.  At the moment, exporting too much pollutes the symbol namespace - making collisions between modules highly likely.

### Compatibility

Extensive compatibility testing of FileIO2.jl has not been performed.  The module has been tested using the following environment(s):

 - Linux / Julia-0.4.0 (64-bit).

## Disclaimer

The FileIO2.jl module is not yet mature.  Expect significant changes.

This software is provided "as is", with no guarantee of correctness.  Use at own risk.
