SCF deployment
==============

This is a rewrite of the build supplement. This should be much simpler. In particular,
we remove the use of python 'shiv', and just deploy everything in a conda environment.

Use pixi
--------
We use [pixi](https://pixi.sh/latest/) for handling the conda environment. You should
have [installed](https://pixi.sh/latest/#installation) that before using the Makefile.
If you are building packages, we also depend on 
[rattler-build](https://rattler.build/latest/) and 
[rattler-index](https://crates.io/crates/rattler_index).

   ```
   curl -fsSL https://pixi.sh/install.sh | sh
   source ~/.bashrc
   pixi global install rattler-build
   pixi global install rattler-index
   ```

Important issue
---------------
The latest updates to the SCF system can cause hanging when using micromamba. 
This appears to be hanging on internal file locking. This can be avoided by
creating a ~/.mambarc file with the contents:

    use_lockfiles: false
	
A similiar problem can happen with pixi. The fix for pixi is to make sure the
cache (defaults to ~/.cache/rattler) is on the /home drive, not the sandbox drive.

Doing SCF deployment
--------------------
To use this you need to:

1. Make sure [git-lfs](https://git-lfs.com) is installed and in you path. You can test this
   by running the command "git lfs version" and making sure you don't get an error message.
2. Clone this repository

   ```
      git clone git@github.jpl.nasa.gov:refractor/build_supplement.git refractor-build-supplement
   ```
3. Make sure you are on the master branch:

   ```
      cd refractor-build-supplement
	  git checkout master
   ```

Look at the [Makefile](../Makefile), and read the top portion. If you want to make any
modifications, create a "Makefile.local" with your changes. We use a separate file rather
than directly modifying the Makefile so that you can update the repository (and possibly
the Makefile) without losing your changes.

Note that "Makefile.local" should just contain changes, it isn't a copy or "Makefile" or
anything like that. It gets included by Makefile to override values. 
In particular, you may want to modify the location that things go to, and if you are
a developer turn on developer mode. So an example Makefile.local might be:

```
DEVELOPER_MODE=yes
MUSES_DIR=/home/smyth/Local/muses-test2
MUSES_OSP_PATH=/bigdata/smyth/OSP/OSP
MUSES_GMAO_PATH=/bigdata/smyth/GMAO
MUSES_ABSCO_DIR=/home/smyth/sandbox/absco_test
```

Note that `MUSES_OSP_PATH` and `MUSES_GMAO_PATH` should point to existing OSP and GEOS met directories,
the build process won't download anything, it just needs to know where to find that data for the tests.
If you have custom OSPs for development, it is important that `MUSES_OSP_PATH` point to that directory,
as parts of the code use that environmental variable to find the OSPs.

Similarly, `MUSES_ABSCO_DIR` would point to an existing directory with absorption coefficient data from
the OCO project, which is used in the `refractor-framework` tests. The directory used in the example above
is Mike's copy on the SCF. If you do not set this, many of the framework tests will fail, which might look
like the install failed, when really the tests just couldn't run.

In developer mode we install the various muses packages using pip "--editable" mode, which
means that any changes you make so the source code are immediately seen by the system.

For non-developer mode, we install everything is a conda package. For developer mode,
we by default install "things that don't change often" as packages, and things that
do as source.

You can provide overrides in your Makefile.local to change various things into source 
install.

1. PIXI_LOCKED - if "yes", use a fixed set of packages. If "no", grab the latest version
2. AMUSE_ME_PIPELINE_FROM_SOURCE - install all the amuse-me scripts (other than
   py-retrieve) as a conda package if "no", otherwise install from source (as editable
   python packages).
3. PY_RETRIEVE_FROM_SOURCE - install py-retrieve from source, or as a conda package.
4. REFRACTOR_MUSES_FROM_SOURCE - install refractor-muses from source, or as a conda package
5. ECLAIR_FROM_SOURCE - install eclair from source, or as a conda package.
6. BUILD_FRAMEWORK - install refractor-framework from a conda package, or build from
   the refractor-framework source.
   
You can also choose to build framework in debug mode (the default), or
build an optimized version from source by setting
BUILD_FRAMEWORK_DEBUG=no.

Note that you can also change your mind. All these rules just shuffle around pixi
installation of packages vs. pip install. You can uninstall either a pixi or pip package,
and then reinstall  the other.

You can read the various targets to determine what you can do automatically with the
Makefile. A few common things:

1. To install all the pixi packages, do:

   `make create-env`
   
2. To remove the environment and recreate:

   `make recreate-env`
   
3. To install the current version of all the source packages (doing a git clone of 
   any repository you don't already have) do:
   
   `make install-current`
   
   This also builds refractor-framework if you have selected that.
   
4. To grab the latest version of all the various git repositories for the source packages
   and do an then install, do:

   `make install-update`

   This also builds refractor-framework if you have selected that.

5. If you have selected [refractor_test_data](https://github.jpl.nasa.gov/refractor/refractor_test_data) available, 
   either because you pointed to it or because you are using developer mode where we
   automatically install this, then you can run a small end to end test of the pipeline.
   This uses only 8 soundings, and runs everything on the local machine (i.e., not the
   various tb1_20 cluster normally used). This should be a realistic test to run everything
   with. This has a airs_omi test, and cris_tropomi, and does both py-retrieve and
   refractor. To run this:
   ```
   make test-run-all
   ```   
   
   You can also just run the py-retrieve version 
   ```
   make test-run-py-retrieve
   ```
   
   Or just refractor:
   ```
   make test-run-refractor
   ```

4. You can activate the environment like any normal pixi environment. 
   ```
   cd <muses-env>; pixi shell
   ```

   
5. Once in the environment, you can run tools like "amuse-me" as normal - these are
   just in your path.
   
> **IMPORTANT**
> Note that you should specify the "--programs" argument as "in-path" since we want to use each of tools found in
> our path rather than explicitly finding them like the shiv
> implementation used. (The --programs in-path is a new option added to amuse-me
> to support our conda installation).
   
List of targets
---------------

We listed the main make targets above, but there are other useful lower level targets.
You can refer to the [Makefile](../Makefile) for a complete list, but for reference here
is a partial list.

Target          | Description
:-------------- | :-----------
install-current | Install the current version of everything. Useful if you have local modifications that haven't been pushed to github yet.
install-update  | Update all the repositories to the latest in github, and then install everything.
test-run-all    | Run both test-run-py-retrieve and test-run-refractor.
test-run-py-retrieve | Do a test run using py-retrieve/VLIDORT. You should have done a install-current or install-update before calling this. This does both airs_omi and cris_tropomi, and compares combine results to expected data.
test-airs-py-retrieve | Like test-run-py-retrieve, but only runs airs_omi
test-cris-py-retrieve | Like test-run-py-retrieve, but only runs cris_tropomi
test-run-refractor | Do a test run using ReFRACtor/LIDORT. You should have done a install-current or install-update before calling this. This does both airs_omi and cris_tropomi, and compares combine results to expected data.
test-airs-refractor | Like test-run-refractor, but only runs airs_omi
test-cris-refractor | Like test-run-refractor, but only runs cris_tropomi
compare-airs-py-retrieve | Run just the compare step of test-airs-py-retrieve. Need to have previously run the test.
compare-cris-py-retrieve | Run just the compare step of test-cris-py-retrieve. Need to have previously run the test.
compare-airs-refractor | Run just the compare step of test-airs-refractor. Need to have previously run the test.
compare-cris-refractor | Run just the compare step of test-cris-refractor. Need to have previously run the test.
update-expected-all | Copy the results of a test run to the expected files, to update them (e.g., after a change when you have validated the new results).
update-expected-airs-py-retrieve | Like update-expected-all, but for airs_omi py-retrieve only
update-expected-cris-py-retrieve | Like update-expected-all, but for cris_tropomi py-retrieve only
update-expected-airs-refractor | Like update-expected-all, but for airs_omi refractor only
update-expected-cris-refractor | Like update-expected-all, but for cris_tropomi refractor only
recreate-env    | Recreate the conda environment, deleting if already there. Useful to do a fresh start if something gets mangled.
clone-all       | Do an initial clone of all packages. This only created missing directories, so it is fine to call this if you already have some checked out.
update-all      | Update all the checked current packages, or clone them if they aren't already there.
status-all      | List status all repositories, good for finding stuff you may have changed and not checked in or pushed to github
create-env      | Create the conda environment, if not already there or if out of date.
activate-env    | Print out directions for activating the environment, just so you don't need to remember the commands. Note this doesn't actually activate the environment, we can't do that because Make runs in a subshell and can't change the parent shell.
test-pipeline-config | Create the amuse-config generated files used by test-run-xxx
install-refractor-framework | Build an existing refractor-framework checkout. Note you don't need to use this rule, often it is more convenient to just go to the build directory and do it there. But this is here for convenience
update-lock | Update the pixi.lock file and pix.toml for the fixed package installation
build-all-package | Build all the muses-package packages


   
