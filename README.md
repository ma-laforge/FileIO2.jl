# FileIO2.jl

## Description

A very Julian way of describing files leveraging the built-in type system.  FileIO2.jl simply provides tools/patterns to register data types with Julia type system.

FileIO2.jl therefore competes with the solution found at: <http://github.com/JuliaIO/FileIO.jl>.

### Advantages

 - New file/data format types do not have to be registered with the FileIO2.jl module.
 - Only types of imported (used) modules are made available (including those provided with FileIO2.jl).

### Sample Code

Sample code is provided under the [test directory](test/).

## Known Limitations

FileIO2.jl tries to minimize the set of exported types/aliases until a better way
is found for the user to import them.  At the moment, exporting too much
pollutes the symbol namespace - making collisions between modules highly likely.

### Compatibility

Extensive compatibility testing of FileIO2.jl has not been performed.  The module has been tested using the following environment(s):

 - Linux / Julia-0.4.0.

## Disclaimer

The FileIO2.jl module is not yet mature.  Expect significant changes.

This software is provided "as is", with no guarantee of correctness.  Use at own risk.
