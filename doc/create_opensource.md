Create opensource
=================

We have a completely different repository, so we don't have any closed source stuff
in the history. Located on [github](git@github.com:ReFRACtor/refractor-build-supplement.git).

We use the file rsync_public.sh to copy files over to a clone of the public github. We
just copy files, none of the git history.  Run rsync_public.sh and then we can commit
everything to the public github.

We can't have the muses-conda-channel on the public github, they charge for using
git-lfs and some of the files are too large. We instead attach an artifact to
a release tag, which can accept files up to 2G.

On other projects, we have used pixi pack to create a simple sh script to install
the environment. However, we can't do that for refractor. The tensorflow/pytorch stuff
needed by Frank's machine learning is huge (something like 6 GB). The pixi pack file
is > 7GB, and too large for github.com.

So instead, we have a simple python script to create a .tar file of just our conda
packages, along with a build rule for installing this (we unpack the tar file, and then
use a pixi.lock file for installing).

In the full build directory, make sure the linux-opensource/pixi.lock is up to date.
Then do something like:

    make USE_CLOSED_SOURCE=no PIXI_LOCKED=yes recreate-env
    make USE_CLOSED_SOURCE=no PIXI_LOCKED=yes tar-muses-conda-channel

This create a muses-conda-channel.tar file that can be attached to a release
tag in the public github.

You can try creating a docker public version with

    make docker-public-build
	
You can run a test with

    make docker-public-test
	
While we are doing initial development, you can update an existing docker public build
with the latest refractor-muses version:

    make docker-public-update
