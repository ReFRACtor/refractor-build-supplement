We have a handful of things that we need to build from scratch, but don't change
much. So we make this packages that we can just install with conda. We might want
to rethink this, it wouldn't be too hard to just build everything in our environment.
But we already had these package things lying around from previous work, so at least
for now we'll create packages.

Note that framework is a bit of a package on the fence. For *users* of muses, we would
want to just have an already built version. For developers, they may want to build
there own copy - or if they are just working in python might want to use a already
built package. We go ahead an create a conda package, but we may or may not actually
use it when we create environments.

The rules for building these packages are in the Makefile above this directory.
