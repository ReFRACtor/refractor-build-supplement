# ---------------------------------------------------------------------------
# These can be modified directly, or you can supply these on the command line
# You can also create a Makefile.local file, which gets read in and can
# override things without changing this file.
# ---------------------------------------------------------------------------

# Where we put the source code
MUSES_DIR=${HOME}/muses

# Where the conda environment goes. Assuming we always make a stand alone
# environment
# ---------------------------------------------------------------------------
ENV_DIR=$(MUSES_DIR)/muses-env

# Should we include close sourced packages? Generally you want this, but if
# you are make a public distribution you'll want to leave this out.
# ---------------------------------------------------------------------------

USE_CLOSED_SOURCE=yes

# Where support data is located
 # ---------------------------------------------------------------------------
MUSES_OSP_PATH=/project/muses/osp/develop/repo/OSP
MUSES_JOSH_OSP_PATH=/tb/sandbox17/laughner/OSP-mine/OSP
MUSES_GMAO_PATH=/project/muses/input/geos_fp_it

# Are you a developer, or are you just installing to run the pipeline?
# ---------------------------------------------------------------------------

DEVELOPER_MODE=no

# Should we install the latest anaconda packages, or the "fixed" set known to
# work (which will often lag the latest anaconda packages). Most of the time
# latest should work fine, but there might be the occasional breakage (e.g.,
# conda moves to a newer version of python and our various packages haven't
# been rebuilt yet the newer python, a python package update breaks
# something).

PIXI_LOCKED=$(if $(filter $(DEVELOPER_MODE),no),yes, no)

# refractor_test_data is pretty large, and you might not need it, or already 
# have a copy of it elsewhere. So indicate if we should install this or not.
# Note this is needed for running out test-run-py-retrieve or test-run-refractor.
# We default to installing for DEVELOPER_MODE=yes, but not otherwise. You can
# override this. See REFRACTOR_TEST_DATA_DIR below, if you want to not install
# the test data but use another copy elsewhere on the system.
# ---------------------------------------------------------------------------

INSTALL_TEST_DATA=$(if $(filter $(DEVELOPER_MODE),no),no,yes)
RUN_CTEST=$(if $(filter $(INSTALL_TEST_DATA),no),no,yes)

# When you run the end to end tests (e.g., test-run-py-retrieve) we check against
# expected results. Note a failure here *doesn't* indicate a problem, it just indicates
# a change that needs to be looked at more closely. If you are testing changes that are
# expected to change the results, you might want to skip treating a failed check as
# an error, e.g., you'll get around to updating the expected results but just want to see
# differences for now. You can set this value to indicate comparision failures isn't actually
# an error.
# ---------------------------------------------------------------------------

COMPARISON_FAILURE_IS_ERROR=yes

# Should we install most of the amuse-me pipeline from the conda version? This
# code only occasionally changes, so by default we use the package (which can be
# easily updated). However if you are working on the pipeline to fix something, you
# want to be using the source as you might change this then.
# ---------------------------------------------------------------------------

AMUSE_ME_PIPELINE_FROM_SOURCE=no

# Should we install py-retrieve from the conda version? If you are developer,
# you probably want this. Default is yes for developer, no otherwise.
# ---------------------------------------------------------------------------

PY_RETRIEVE_FROM_SOURCE=$(DEVELOPER_MODE)

# Should we install refractor-muses from the conda version? If you are developer,
# you probably want this. Default is yes for developer, no otherwise.
# ---------------------------------------------------------------------------

REFRACTOR_MUSES_FROM_SOURCE=$(DEVELOPER_MODE)

# Should we install eclair from the source rather than conda version?
# Default is no, this is more Frank Werner's code. But if you need it,
# you can set this to yes.
# ---------------------------------------------------------------------------

ECLAIR_FROM_SOURCE=no

# Should we install troppy from the source rather than conda version?
# Default is no, this is more Frank Werner's code. But if you need it,
# you can set this to yes.
# ---------------------------------------------------------------------------

TROPPY_FROM_SOURCE=no

# Should we build framework, or install a conda version? Framework doesn't
# change much, and is easy enough to update the conda package. So we don't
# normally build. You can turn this on if desired, or alternatively just
# "pixi rm refractor-framework" from your environment. But it takes about
# 10 minutes to build, and doesn't change much so unless you are specifically
# fixing a problem in framework you likely want the conda version.
#
# Note that if you are building, then the following files will get overwritten:
#
# 1. $(BUILD_FRAMEWORK_DIR)/build_conda.txt
# 2. $(BUILD_FRAMEWORK_DIR)/build_conda_debug.txt
# 3. Entire directory $(BUILD_FRAMEWORK_DIR)/build_conda
# 4. Entire directory $(BUILD_FRAMEWORK_DIR)/build_conda_debug
# ---------------------------------------------------------------------------

BUILD_FRAMEWORK=no

# If you build framework, you can either build a debug or a optimized version. The
# debug is better for debugging, but the optimized version runs faster.
# Note that LIDORT is always installed optimized, so although the debug version
# is slower it isn't vastly slower (you can of course install a debug version
# of LIDORT, but this Makefile doesn't directly support this).
# ---------------------------------------------------------------------------

BUILD_FRAMEWORK_DEBUG=yes

# If we are building framework, this is the top location of the build area.
# ---------------------------------------------------------------------------

BUILD_FRAMEWORK_DIR=$(MUSES_DIR)/framework-build

# Should we install packages as editable (so changing source code is immediately scene
# in the package), or as a normal pip package? Defaults to editable, since if you
# are installing packages directly rather than from conda you almost certainly are
# doing development on it.
# 
# Note refractor-framework is not installed as editable - we just don't support
# that because we use a separate cmake to build these. You can override this.
# ---------------------------------------------------------------------------

PIP_INSTALL_EDITABLE=$(if $(filter $(DEVELOPER_MODE),no),no,yes)

# Location of refractor test data, if in a different place than checkout
# ---------------------------------------------------------------------------

REFRACTOR_TEST_DATA_DIR=$(MUSES_DIR)/refractor_test_data

# Location of ABSCO data, only needed if you are building framework and
# want to run the unit tests that depend on this. Note that without absco,
# a lot of unit tests in framework will fail
# ---------------------------------------------------------------------------

MUSES_ABSCO_DIR=not_set

# Location that we put our test pipeline configuration
# ---------------------------------------------------------------------------

TEST_PIPELINE_CONFIG=$(MUSES_DIR)/test-pipeline-config

# Directory we put our muses test run
# ---------------------------------------------------------------------------

MUSES_TEST_RUN_PY_RETRIEVE_DIR=$(MUSES_DIR)/muses-test-run-py-retrieve
MUSES_TEST_RUN_REFRACTOR_DIR=$(MUSES_DIR)/muses-test-run-refractor

# Directory we are running from
# ---------------------------------------------------------------------------

mkfile_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

REFRACTOR_BUILD_SUPPLEMENT_OPEN_SOURCE_VERSION=v0.9
# URLs for repos
# ---------------------------------------------------------------------------
AMUSE_CONFIG_URL=git@github.jpl.nasa.gov:MUSES-Processing/amuse-config.git
PY_COMBINE_URL=git@github.jpl.nasa.gov:MUSES-Processing/py-combine.git
PY_GENERATE_TARGETS_URL=git@github.jpl.nasa.gov:MUSES-Processing/py-generate-targets.git
PY_GEOLOCATE_URL=git@github.jpl.nasa.gov:MUSES-Processing/py-geolocate.git
AMUSE_ME_URL=git@github.jpl.nasa.gov:MUSES-Processing/amuse-me.git
PY_PAIR_URL=git@github.jpl.nasa.gov:MUSES-Processing/py-pair.git
PY_THIN_URL=git@github.jpl.nasa.gov:MUSES-Processing/py-thin.git
PY_LEVEL3_URL=git@github.jpl.nasa.gov:MUSES-Processing/py-level3.git
PY_PLOT_URL=git@github.jpl.nasa.gov:MUSES-Processing/py-plot.git
PY_SETUP_TARGETS_URL=git@github.jpl.nasa.gov:MUSES-Processing/py-setup-targets.git
MUSES_TOOLS_URL=git@github.jpl.nasa.gov:MUSES-Processing/muses-tools.git
PY_RETRIEVE_URL=git@github.jpl.nasa.gov:MUSES-Processing/py-retrieve.git
REFRACTOR_MUSES_URL=git@github.jpl.nasa.gov:refractor/refractor-muses.git
REFRACTOR_FRAMEWORK_URL=git@github.jpl.nasa.gov:refractor/framework.git
REFRACTOR_TEST_DATA_URL=git@github.jpl.nasa.gov:refractor/refractor_test_data.git
# For now, use forks of frank's code
#ECLAIR_URL=git@github-fn.jpl.nasa.gov:fwerner/eclair.git
#TROPPY_URL=git@github-fn.jpl.nasa.gov:fwerner/troppy.git
ECLAIR_URL=git@github-fn.jpl.nasa.gov:ReFRACtor/eclair.git
TROPPY_URL=git@github-fn.jpl.nasa.gov:ReFRACtor/troppy.git
REFRACTOR_BUILD_SUPPLEMENT_OPEN_SOURCE_URL=https://github.com/ReFRACtor/refractor-build-supplement.git
MUSES_CONDA_CHANNEL_OPEN_SOURCE_TAR_URL=https://github.com/ReFRACtor/refractor-build-supplement/releases/download/$(REFRACTOR_BUILD_SUPPLEMENT_OPEN_SOURCE_VERSION)/muses-conda-channel.tar
REFRACTOR_MUSES_OPEN_SOURCE_URL=https://github.com/ReFRACtor/refractor-muses.git
CRIS_ML_TEST_INPUT=https://github.com/ReFRACtor/refractor-build-supplement/releases/download/$(REFRACTOR_BUILD_SUPPLEMENT_OPEN_SOURCE_VERSION)/cris_docker_run_data.tar.gz
# Include a Makefile.local to override things, if found
-include Makefile.local

# ---------------------------------------------------------------------------
# Past this point are the rules, shouldn't need to modify these
# ---------------------------------------------------------------------------

# Primary targets, most of the time you will call one of these
# ============================================================

# Install the current version of everything.
# ------------------------------------------------------------

install-current:
	$(MAKE) clone-all
	@if [ -n "$(install_list)" ]; then \
	  $(MAKE) $(addprefix install-, $(install_list)); \
	fi

# Update everything, and then install updated versions.
# ------------------------------------------------------------

install-update:
	$(MAKE) update-all
	$(MAKE) install-current

# Do a test run. You should have done a "install-current"
# before calling this. This does both airs-omi and cris-tropomi,
# or you can call each of those separately
# ------------------------------------------------------------

test-run-py-retrieve: test-airs-py-retrieve test-cris-py-retrieve

test-run-all: test-run-py-retrieve test-run-refractor

# We are using h5diff, because there really isn't a equivalent netcdf
# diff program. This works fine, however there are some netcdf fields
# that h5diff can't compare. This is fine, h5diff just says "Some
# object not comparable". However since we *know* # these can't be
# compared it is better just to list this. This is a list here that
# the use in our h5diff command to just skip stuff we can't compare.
H5DIFF_OPTION = --exclude-path /Grid_Targets --exclude-path /dim_cloud
H5DIFF_OPTION+= --exclude-path /dim_column --exclude-path /dim_emissivity
H5DIFF_OPTION+= --exclude-path /dim_filter --exclude-path /dim_pressure
H5DIFF_OPTION+= --exclude-path /grid_1 --exclude-path /grid_417
H5DIFF_OPTION+= --exclude-path /string19
# Backdoor to set creation date to "FAKE_DATE". This is needed so we don't fail
# h5diff just because the date has changed.
export MUSES_FAKE_CREATION_DATE=FAKE_DATE

PIXI_RUN=pixi run --manifest-path $(ENV_DIR)

ifneq '$(COMPARISON_FAILURE_IS_ERROR)' 'no'

%-compare-airs-py-retrieve:
	$(PIXI_RUN) h5diff $(H5DIFF_OPTION) $(MUSES_TEST_RUN_PY_RETRIEVE_DIR)/airs_omi/2016-04-01/combine/Test_Survey/$* $(REFRACTOR_TEST_DATA_DIR)/airs_omi/expected/run_py_retrieve/$*

%-compare-cris-py-retrieve:
	$(PIXI_RUN) h5diff $(H5DIFF_OPTION) $(MUSES_TEST_RUN_PY_RETRIEVE_DIR)/cris_tropomi/2020-07-01/combine/Test_Survey_2/$* $(REFRACTOR_TEST_DATA_DIR)/cris_tropomi/expected/run_py_retrieve/$*

%-compare-airs-refractor:
	$(PIXI_RUN) h5diff $(H5DIFF_OPTION) $(MUSES_TEST_RUN_REFRACTOR_DIR)/airs_omi/2016-04-01/combine/Test_Survey/$* $(REFRACTOR_TEST_DATA_DIR)/airs_omi/expected/run_refractor/$*

%-compare-cris-refractor:
	$(PIXI_RUN) h5diff $(H5DIFF_OPTION) $(MUSES_TEST_RUN_REFRACTOR_DIR)/cris_tropomi/2020-07-01/combine/Test_Survey_2/$* $(REFRACTOR_TEST_DATA_DIR)/cris_tropomi/expected/run_refractor/$*

else

%-compare-airs-py-retrieve:
	-$(PIXI_RUN) h5diff $(H5DIFF_OPTION) $(MUSES_TEST_RUN_PY_RETRIEVE_DIR)/airs_omi/2016-04-01/combine/Test_Survey/$* $(REFRACTOR_TEST_DATA_DIR)/airs_omi/expected/run_py_retrieve/$*

%-compare-cris-py-retrieve:
	-$(PIXI_RUN) h5diff $(H5DIFF_OPTION) $(MUSES_TEST_RUN_PY_RETRIEVE_DIR)/cris_tropomi/2020-07-01/combine/Test_Survey_2/$* $(REFRACTOR_TEST_DATA_DIR)/cris_tropomi/expected/run_py_retrieve/$*

%-compare-airs-refractor:
	-$(PIXI_RUN) h5diff $(H5DIFF_OPTION) $(MUSES_TEST_RUN_REFRACTOR_DIR)/airs_omi/2016-04-01/combine/Test_Survey/$* $(REFRACTOR_TEST_DATA_DIR)/airs_omi/expected/run_refractor/$*

%-compare-cris-refractor:
	-$(PIXI_RUN) h5diff $(H5DIFF_OPTION) $(MUSES_TEST_RUN_REFRACTOR_DIR)/cris_tropomi/2020-07-01/combine/Test_Survey_2/$* $(REFRACTOR_TEST_DATA_DIR)/cris_tropomi/expected/run_refractor/$*

endif

compare-airs-py-retrieve: $(addsuffix -compare-airs-py-retrieve, $(notdir $(wildcard $(REFRACTOR_TEST_DATA_DIR)/airs_omi/expected/run_py_retrieve/*.nc)))

compare-cris-py-retrieve: $(addsuffix -compare-cris-py-retrieve, $(notdir $(wildcard $(REFRACTOR_TEST_DATA_DIR)/cris_tropomi/expected/run_py_retrieve/*.nc)))

compare-airs-refractor: $(addsuffix -compare-airs-refractor, $(notdir $(wildcard $(REFRACTOR_TEST_DATA_DIR)/airs_omi/expected/run_refractor/*.nc)))

compare-cris-refractor: $(addsuffix -compare-cris-refractor, $(notdir $(wildcard $(REFRACTOR_TEST_DATA_DIR)/cris_tropomi/expected/run_refractor/*.nc)))

update-expected-all:
	$(MAKE) update-expected-airs-py-retrieve update-expected-cris-py-retrieve update-expected-airs-refractor update-expected-cris-refractor

update-expected-airs-py-retrieve:
	cp -f $(MUSES_TEST_RUN_PY_RETRIEVE_DIR)/airs_omi/2016-04-01/combine/Test_Survey/*.nc $(REFRACTOR_TEST_DATA_DIR)/airs_omi/expected/run_py_retrieve

update-expected-cris-py-retrieve:
	cp -f $(MUSES_TEST_RUN_PY_RETRIEVE_DIR)/cris_tropomi/2020-07-01/combine/Test_Survey_2/*.nc $(REFRACTOR_TEST_DATA_DIR)/cris_tropomi/expected/run_py_retrieve

update-expected-airs-refractor:
	cp -f $(MUSES_TEST_RUN_REFRACTOR_DIR)/airs_omi/2016-04-01/combine/Test_Survey/*.nc $(REFRACTOR_TEST_DATA_DIR)/airs_omi/expected/run_refractor

update-expected-cris-refractor:
	cp -f $(MUSES_TEST_RUN_REFRACTOR_DIR)/cris_tropomi/2020-07-01/combine/Test_Survey_2/*.nc $(REFRACTOR_TEST_DATA_DIR)/cris_tropomi/expected/run_refractor

test-airs-py-retrieve: $(TEST_PIPELINE_CONFIG)
	$(MKDIR_P) $(MUSES_TEST_RUN_PY_RETRIEVE_DIR)
	-rm -r $(MUSES_TEST_RUN_PY_RETRIEVE_DIR)/airs $(MUSES_TEST_RUN_PY_RETRIEVE_DIR)/airs_omi $(MUSES_TEST_RUN_PY_RETRIEVE_DIR)/omi
	$(PIXI_RUN) amuse-me --pipeline-config $(TEST_PIPELINE_CONFIG)/config.yml --sensor-set AIRS_OMI --profile Test_Survey --date 2016-04-01 --output $(MUSES_TEST_RUN_PY_RETRIEVE_DIR) --clear-output --OSP $(MUSES_OSP_PATH) --programs in-path --hosts localhost --tasks-per-host 8 --python --start-step geolocate --end-step plot
	$(MAKE) compare-airs-py-retrieve

# To run actual py-retrieve (for some backwards testing) do:
# 1. Edit retrive.yml in $(TEST_PIPELINE_CONFIG) to change refractor-retrieve to py-retrieve
# 2. Add MUSES_VLIDORT_CLI and MUSES_RING_CLI environment variables. Note despite the
#    name, these actually go to a directory. So something like:
#
# MUSES_RING_CLI=$CONDA_PREFIX/bin MUSES_VLIDORT_CLI=$CONDA_PREFIX/bin amuse-me --pipeline-config $(TEST_PIPELINE_CONFIG)/config.yml --sensor-set AIRS_OMI --profile Test_Survey --date 2016-04-01 --output $(MUSES_TEST_RUN_PY_RETRIEVE_DIR) --clear-output --OSP $(MUSES_OSP_PATH) --programs in-path --hosts localhost --tasks-per-host 8 --python --start-step geolocate --end-step plot

test-cris-py-retrieve: $(TEST_PIPELINE_CONFIG)
	$(MKDIR_P) $(MUSES_TEST_RUN_PY_RETRIEVE_DIR)
	-rm -r $(MUSES_TEST_RUN_PY_RETRIEVE_DIR)/cris $(MUSES_TEST_RUN_PY_RETRIEVE_DIR)/cris_tropomi $(MUSES_TEST_RUN_PY_RETRIEVE_DIR)/tropomi
	$(PIXI_RUN) amuse-me --tropomi-dataset-path $(REFRACTOR_TEST_DATA_DIR)/fake_input/tropomi --pipeline-config $(TEST_PIPELINE_CONFIG)/config.yml --sensor-set CRIS_TROPOMI --profile Test_Survey_2 --date 2020-07-01 --output $(MUSES_TEST_RUN_PY_RETRIEVE_DIR) --clear-output --OSP $(MUSES_OSP_PATH) --programs in-path --hosts localhost --tasks-per-host 8 --python --start-step geolocate --end-step plot
	$(MAKE) compare-cris-py-retrieve

# Do a test run using refractor. You should have done a "install-current"
# before calling this. This does both airs-omi and cris-tropomi,
# or you can call each of those separately
# ------------------------------------------------------------

test-run-refractor: test-airs-refractor test-cris-refractor

test-airs-refractor: $(TEST_PIPELINE_CONFIG)
	$(MKDIR_P) $(MUSES_TEST_RUN_REFRACTOR_DIR)
	-rm -r $(MUSES_TEST_RUN_REFRACTOR_DIR)/airs $(MUSES_TEST_RUN_REFRACTOR_DIR)/airs_omi $(MUSES_TEST_RUN_REFRACTOR_DIR)/omi
	$(PIXI_RUN) amuse-me --pipeline-config $(TEST_PIPELINE_CONFIG)/config.yml --sensor-set AIRS_OMI --profile Test_Survey --date 2016-04-01 --output $(MUSES_TEST_RUN_REFRACTOR_DIR) --refractor --refractor-config $(MUSES_DIR)/refractor-muses/muses_config/refractor_config.py --clear-output --OSP $(MUSES_OSP_PATH) --programs in-path --hosts localhost --tasks-per-host 8 --python --start-step geolocate --end-step plot
	$(MAKE) compare-airs-refractor

test-cris-refractor: $(TEST_PIPELINE_CONFIG)
	$(MKDIR_P) $(MUSES_TEST_RUN_REFRACTOR_DIR)
	-rm -r $(MUSES_TEST_RUN_REFRACTOR_DIR)/cris $(MUSES_TEST_RUN_REFRACTOR_DIR)/cris_tropomi $(MUSES_TEST_RUN_REFRACTOR_DIR)/tropomi
	$(PIXI_RUN) amuse-me --tropomi-dataset-path $(REFRACTOR_TEST_DATA_DIR)/fake_input/tropomi --pipeline-config $(TEST_PIPELINE_CONFIG)/config.yml --sensor-set CRIS_TROPOMI --profile Test_Survey_2 --date 2020-07-01 --output $(MUSES_TEST_RUN_REFRACTOR_DIR) --refractor --refractor-config $(MUSES_DIR)/refractor-muses/muses_config/refractor_config.py --clear-output --OSP $(MUSES_OSP_PATH) --programs in-path --hosts localhost --tasks-per-host 8 --python --start-step geolocate --end-step plot
	$(MAKE) compare-cris-refractor

# Recreate the environment, deleting if already there
# ------------------------------------------------------------

recreate-env:
	-rm -rf $(ENV_DIR)
	$(MAKE) create-env

# Build the conda envirornment, if needed or out of date.
# ------------------------------------------------------------

create-env: $(ENV_DIR)
	$(MAKE) install-current

# Save the environment to unpack. This is how we deliver to the
# public version since we can attach a large file as a artifact to
# a delivery, but don't have git-lfs for packages. So we create the
# environment at JPL, pack it up, and then in public unpack it.
# ------------------------------------------------------------

# Unfortunately, this is too big. public github only allows 2GB file,
# and this is larger. We will instead need to package up the conda channel
# with our packages and install everything else.
pixi-pack-didnt-work:
	cd $(ENV_DIR); pixi-pack --create-executable --platform linux-64

# Instead, we create a tar file of our packages
# ------------------------------------------------------------

mkfile_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

tar-muses-conda-channel:
	cd $(ENV_DIR); pixi run python $(mkfile_dir)/create_channel_tar.py; mv muses-conda-channel.tar $(mkfile_dir)

# It isn't clear how exactly we want to handle the input needed for
# running the CRIS ML data in MAP. For now, we create a tar file that gets
# installed in the docker. Note this does not have the actual test data
# (the CRIS L1B and stac file). These might get moved to an OSP or something
# else.
# We don't bother gzipping, the data is already pretty compressed
# ------------------------------------------------------------

tar-cris-ml-test-in:
	-rm -r cris_ml_test_in
	mkdir -p cris_ml_test_in
	cp -r $(REFRACTOR_TEST_DATA_DIR)/cris/in/product_spec $(REFRACTOR_TEST_DATA_DIR)/cris/in/ml_weight $(REFRACTOR_TEST_DATA_DIR)/cris/in/ml_1 cris_ml_test_in/
	rm cris_ml_test_in/ml_1/*.json cris_ml_test_in/ml_1/Table.asc
	tar -cf cris_ml_test_in.tar ./cris_ml_test_in
	-rm -r cris_ml_test_in

# Create a generated CWL file from refractor. Rather than fight with the tool,
# we use this as a basis for creating a formatted process.cwl file at the top
# directory. This is done for now by manually modifying the file. I'm not sure
# how often we will do this, so I don't know how much more we need to try to
# automate this.

generate_cwl: generated/process.cwl

generated/process.cwl:
	$(PIXI_RUN) refractor-retrieve-stac --stac-catalog-dir $(REFRACTOR_TEST_DATA_DIR)/cris/in/ml_1 -o ./output_dir --dump cwl --docker docker.io/mikesmyth/refractor-docker:$(DOCKER_VERSION) > $@
	@echo "Manually update generated/process.cwl to create process.cwl"

# Build a docker image based on open source data. We will
# want to have this built for MAPS, but this first setup here
# will give us the steps needed for that.
# ------------------------------------------------------------

BASE_DOCKER=oraclelinux:8
DOCKER_VERSION=0.91
# Docker build from a standard dockerfile
docker-public-build:
	docker build -t refractor-docker:$(DOCKER_VERSION) -f public-docker/Dockerfile .

# Docker as steps, easier to debug
docker-public-build-steps:
	docker run -t -d --cidfile=docker_run.id $(BASE_DOCKER) /bin/bash
	echo "Install pixi"
	docker exec $$(cat docker_run.id) bash --login -c "dnf install -y git git-lfs make && curl -fsSL https://pixi.sh/install.sh | sh"
	echo "Download build supplement (public open source version)"
	docker exec $$(cat docker_run.id) bash --login -c "mkdir /home/workdir && cd /home/workdir && git clone $(REFRACTOR_BUILD_SUPPLEMENT_OPEN_SOURCE_URL) refractor-build-supplement && cd refractor-build-supplement && curl -fsSL $(MUSES_CONDA_CHANNEL_OPEN_SOURCE_TAR_URL) | tar -x"
	echo "Install pixi environment, with latest refractor-muses"
	docker exec $$(cat docker_run.id) bash --login -c "cd /home/workdir/refractor-build-supplement && make REFRACTOR_MUSES_URL=$(REFRACTOR_MUSES_OPEN_SOURCE_URL) REFRACTOR_MUSES_FROM_SOURCE=yes USE_CLOSED_SOURCE=no MUSES_DIR=/home/muses install-current"
	echo "Set up to automatically start pixi environment"
	docker exec $$(cat docker_run.id) bash --login -c "pixi shell-hook --shell bash --manifest-path /home/muses/muses-env > /etc/profile.d/pixi.sh"
	docker commit $$(cat docker_run.id) refractor-docker:$(DOCKER_VERSION)
	docker container stop $$(cat docker_run.id)
	rm docker_run.id

# This will probably go away, but as we are getting everything working it can
# be useful to just update our existing docker instance to have the latest
# version of refractor-muses
# ---------------------------------------------------------------------

docker-public-update:
	docker run -t -d --cidfile=docker_run.id refractor-docker:$(DOCKER_VERSION) /bin/bash
	echo "Updating refractor-muses"
	docker exec $$(cat docker_run.id) bash --login -c "cd /home/muses/refractor-muses && git pull origin master && cd /home/workdir/refractor-build-supplement && make REFRACTOR_MUSES_URL=$(REFRACTOR_MUSES_OPEN_SOURCE_URL) REFRACTOR_MUSES_FROM_SOURCE=yes USE_CLOSED_SOURCE=no MUSES_DIR=/home/muses install-current"
	docker commit $$(cat docker_run.id) refractor-docker:$(DOCKER_VERSION)
	docker container stop $$(cat docker_run.id)
	rm docker_run.id

# Upload to docker.io. Not sure that this is right way to handle this
# long term, this is my personal docker account. But for now, do this
# so we have a delivery point
# ---------------------------------------------------------------------

docker-public-upload:
	docker tag refractor-docker:$(DOCKER_VERSION) docker.io/mikesmyth/refractor-docker:$(DOCKER_VERSION)
	docker login --username mikesmyth docker.io
	docker push docker.io/mikesmyth/refractor-docker:$(DOCKER_VERSION)

# Run a simple example test
# ---------------------------------------------------------------------

# Location of test work directory. Probably need to modify this for MAP, but just
# need a directory mounted somwhere and the location passed to the refractor-retrieve arguments
DOCKER_TEST_DATA=$(mkfile_dir)/../cris_docker_run_data

# Note cwl-runner needs the --podman if you are using podman. It will give you
# mysterious errors if you run without this - it will run a docker command that
# points to podman but with weird permission differences. It seems everything including
# the working directory get mounted as readonly. There permission of docker/podman have
# always been a mystery to me, so this took a long time to track down. We should
# probably put some kind of control in here based on autodetection, but for now just
# have this explicit. I assume the oppose (saying --podman but having docker) would be
# a problem also.

CWL_RUNNER_ARG= --podman
$(DOCKER_TEST_DATA):
	mkdir -p $(dir $(DOCKER_TEST_DATA))
	curl -fsSL $(CRIS_ML_TEST_INPUT) | tar -xz -C $(dir $(DOCKER_TEST_DATA))

docker-public-test: 
	echo "Example of running public docker, after it has been built"
	$(MAKE) $(DOCKER_TEST_DATA)
	-rm -r $(DOCKER_TEST_DATA)/output
	$(MKDIR_P) $(DOCKER_TEST_DATA)/output
	$(PIXI_RUN) cwl-runner --podman --outdir $(DOCKER_TEST_DATA)/output process.cwl#refractor-retrieve-stac inp.yml
	@echo "Output is in $(DOCKER_TEST_DATA)/output"
	ls $(DOCKER_TEST_DATA)/output

# Rule to start a interactive docker instance, just so I don't need to
# remember the syntax
# ---------------------------------------------------------------------

docker-public-start:
	docker run -it --workdir /home/docker-run -v $(DOCKER_TEST_DATA):/home/docker-run:z refractor-docker:$(DOCKER_VERSION) /bin/bash

# When a failure occurs, can connect to the docker instance used in a rule
# ---------------------------------------------------------------------

docker-connect:
	docker exec -it $$(cat docker_run.id) bash --login

# If we have a failure and want to start with a new container, this
# stops the old one and removes the docker_run.id file
# ---------------------------------------------------------------------

docker-cleanup:
	docker container stop $$(cat docker_run.id)
	rm docker_run.id

# Finer control targets.
# ============================================================

# Do initial clone of all the packages
# ------------------------------------------------------------
clone-all:
	@if [ -n "$(package_list)" ]; then \
	   $(MAKE) $(addprefix $(MUSES_DIR)/, $(package_list)); \
	fi


# Update all the checked out packages, or clone them if we
# don't already have them.
# ------------------------------------------------------------
update-all:
	@if [ -n "$(package_list)" ]; then \
	   $(MAKE) $(addprefix $(MUSES_DIR)/, $(package_list)); \
	   $(MAKE) $(addsuffix -update, $(package_list)); \
	fi
	git pull origin $$(git rev-parse --abbrev-ref HEAD)

BLUE =\e[0;34m
ENDC =\e[0m

# List status all repositories, good for finding stuff you may have changed
# and not checked in or pushed to github
# ------------------------------------------------------------
status-all:
	@if [ -n "$(package_list)" ]; then \
	   $(MAKE) $(addsuffix -status, $(package_list)); \
	fi
	@echo -e "$(BLUE)---------------------------------" && echo -e "Status refractor-build-supplement" && echo -e "---------------------------------$(ENDC)" && git status


# Short cut for directions on activating environment, so you
# don't need to remember the commands
# ------------------------------------------------------------

activate-env:
	@echo "execute the following command:"
	@echo "pixi shell --manifest-path $(ENV_DIR)"

# Create the amuse-config generated files used by test-run
# ------------------------------------------------------------

test-pipeline-config: $(TEST_PIPELINE_CONFIG)

# Update lock files, from existing environment
# --------------------------------------------

update-lock:
# Save current environment
	cp -f $(ENV_DIR)/pixi.toml $(ENV_DIR)/pixi.toml.save
	cp -f $(ENV_DIR)/pixi.lock $(ENV_DIR)/pixi.lock.save
# Remove packages we want to track separately
	-pixi rm --manifest-path $(ENV_DIR) refractor-pipeline
	-pixi rm --manifest-path $(ENV_DIR) refractor-muses
	-pixi rm --manifest-path $(ENV_DIR) py-retrieve
	-pixi rm --manifest-path $(ENV_DIR) refractor-framework
	-pixi rm --manifest-path $(ENV_DIR) eclair
	-pixi rm --manifest-path $(ENV_DIR) troppy
	sed "s|$(CONDA_PACKAGE_DIR)|fake-muses-conda-channel|"g $(ENV_DIR)/pixi.toml > $(PIXI_LOCK_DIR)/pixi.toml
	sed "s|$(CONDA_PACKAGE_DIR)|fake-muses-conda-channel|"g $(ENV_DIR)/pixi.lock > $(PIXI_LOCK_DIR)/pixi.lock
# Restore environment
	cp -f $(ENV_DIR)/pixi.toml.save $(ENV_DIR)/pixi.toml
	cp -f $(ENV_DIR)/pixi.lock.save $(ENV_DIR)/pixi.lock
	pixi install --manifest-path $(ENV_DIR)

# Build all the muses-packages. 
# --------------------------------------------

build-all-package:
	$(MAKE) build-libgfortran4-compatiblity
	$(MAKE) build-lidort
	$(MAKE) build-lidort-twostream
	$(MAKE) build-muses-oss
	$(MAKE) build-muses-vlidort
	$(MAKE) build-muses-rrs
	$(MAKE) build-refractor-development-tools
	$(MAKE) build-refractor-framework
	$(MAKE) build-refractor-pipeline
	$(MAKE) build-py-retrieve
	$(MAKE) build-refractor-muses
	$(MAKE) build-eclair
	$(MAKE) build-troppy
	$(MAKE) reindex


# Occasionally we have a package in the cache that is out of date. This can
# happen when we rebuild the same package multiple times (e.g., we are ironing out
# a build issue). Unlike conda, pixi has just one source cache location that can just
# be deleted to clear it.
clean-pixi-cache:
	-yes | rm -r ~/.cache/rattler

# Other, mostly internal targets and rules
# ============================================================

# List of packages. Most but not all of these get installed, so we have
# two lists here
install_list =
ifeq ($(USE_CLOSED_SOURCE),yes)
   ifneq '$(AMUSE_ME_PIPELINE_FROM_SOURCE)' 'no'
      install_list = amuse-config py-combine py-generate-targets py-geolocate amuse-me
      install_list+= py-pair py-thin py-level3 py-plot py-setup-targets muses-tools
   endif
   ifneq '$(PY_RETRIEVE_FROM_SOURCE)' 'no'
      install_list+= py-retrieve
   endif
   ifneq '$(ECLAIR_FROM_SOURCE)' 'no'
      install_list+= eclair
   endif
   ifneq '$(TROPPY_FROM_SOURCE)' 'no'
      install_list+= troppy
   endif
endif

ifneq '$(REFRACTOR_MUSES_FROM_SOURCE)' 'no'
   install_list+= refractor-muses
endif
ifneq '$(BUILD_FRAMEWORK)' 'no'
   install_list+= refractor-framework
endif

package_list = $(install_list)
ifeq ($(USE_CLOSED_SOURCE),yes)
   ifneq '$(INSTALL_TEST_DATA)' 'no'
     package_list+= refractor_test_data
   endif
endif

MKDIR_P = mkdir -p
LN_S = ln -s
$(MUSES_DIR)/%:
	$(MAKE) git-lfs-check
	$(MKDIR_P) $(MUSES_DIR)
	cd $(MUSES_DIR) && \
	export REPO_NAME=$(shell echo $* | tr a-z- A-Z_) && \
	export URL=$(value $(shell echo $* | tr a-z- A-Z_)_URL) && \
	echo "Cloning $* from $$URL" && \
	git clone "$$URL" $* && \
	cd $* && git checkout develop

# Doesn't fit our naming convention, perhaps we should replace the name?
$(MUSES_DIR)/refractor-framework:
	$(MAKE) git-lfs-check
	$(MKDIR_P) $(MUSES_DIR)
	cd $(MUSES_DIR) && \
	echo "Cloning refractor-framework from $(REFRACTOR_FRAMEWORK_URL)" && \
	git clone "$(REFRACTOR_FRAMEWORK_URL)" refractor-framework && \
	$(LN_S) refractor-framework framework && cd framework && git checkout master

$(MUSES_DIR)/eclair:
	$(MAKE) git-lfs-check
	$(MKDIR_P) $(MUSES_DIR)
	cd $(MUSES_DIR) && \
	echo "Cloning eclair from $(ECLAIR_URL)" && \
	git clone "$(ECLAIR_URL)" eclair && \
	cd eclair && git checkout main

$(MUSES_DIR)/troppy:
	$(MAKE) git-lfs-check
	$(MKDIR_P) $(MUSES_DIR)
	cd $(MUSES_DIR) && \
	echo "Cloning troppy from $(TROPPY_URL)" && \
	git clone "$(TROPPY_URL)" troppy && \
	cd troppy && git checkout main

$(MUSES_DIR)/refractor-muses:
	$(MAKE) git-lfs-check
	$(MKDIR_P) $(MUSES_DIR)
	cd $(MUSES_DIR) && \
	echo "Cloning refractor-muses from $(REFRACTOR_MUSES_URL)" && \
	git clone "$(REFRACTOR_MUSES_URL)" refractor-muses && \
	cd refractor-muses && git checkout master

# Doesn't fit our naming convention, perhaps we should replace the name?
$(MUSES_DIR)/refractor_test_data:
	$(MAKE) git-lfs-check
	$(MKDIR_P) $(MUSES_DIR)
	cd $(MUSES_DIR) && \
	echo "Cloning refractor_test_data from $(REFRACTOR_TEST_DATA_URL)" && \
	git clone "$(REFRACTOR_TEST_DATA_URL)" refractor_test_data && \
	cd refractor_test_data && git checkout master

# Update a repository.
%-update: $(MUSES_DIR)/%
	$(MAKE) git-lfs-check
	cd $(MUSES_DIR)/$* && git pull origin $$(git rev-parse --abbrev-ref HEAD)

# Status of repository
%-status: $(MUSES_DIR)/%
	@cd $(MUSES_DIR)/$* && echo -e "$(BLUE)--------------------------" && echo -e "Status $*" && echo -e "--------------------------$(ENDC)" && git status && git rev-parse HEAD

# Check for git lfs, printing error message if not there
git-lfs-check:
	@ (git lfs version > /dev/null) && exit 0 ; echo "You need to install git lfs to clone/update repositories"; exit 1

OS := $(shell uname -s)

ifeq ($(OS),Darwin)
  PIXI_LOCK_DIR:=$(mkfile_dir)osx
else
   ifeq ($(USE_CLOSED_SOURCE),yes)
     PIXI_LOCK_DIR:=$(mkfile_dir)linux
   else
     PIXI_LOCK_DIR:=$(mkfile_dir)linux-opensource
   endif
endif

CONDA_PACKAGE_DIR:=$(mkfile_dir)muses-conda-channel

EXTRA_INSTALL=
ifeq '$(BUILD_FRAMEWORK)' 'no'
   EXTRA_INSTALL += refractor-framework
endif
ifeq '$(REFRACTOR_MUSES_FROM_SOURCE)' 'no'
   EXTRA_INSTALL += refractor-muses
endif
ifeq ($(USE_CLOSED_SOURCE),yes)
   ifeq '$(AMUSE_ME_PIPELINE_FROM_SOURCE)' 'no'
      EXTRA_INSTALL += refractor-pipeline
   endif
   ifeq '$(PY_RETRIEVE_FROM_SOURCE)' 'no'
      EXTRA_INSTALL += py-retrieve
   endif
   ifeq '$(ECLAIR_FROM_SOURCE)' 'no'
      EXTRA_INSTALL += eclair
   endif
   ifeq '$(TROPPY_FROM_SOURCE)' 'no'
      EXTRA_INSTALL += troppy
   endif
endif

$(ENV_DIR)/pixi.toml: $(PIXI_LOCK_DIR)/pixi.toml
	sed s"|fake-muses-conda-channel|$(CONDA_PACKAGE_DIR)|"g $< > $@

$(ENV_DIR)/pixi.lock: $(PIXI_LOCK_DIR)/pixi.lock
	sed s"|fake-muses-conda-channel|$(CONDA_PACKAGE_DIR)|"g $< > $@

ifeq '$(PIXI_LOCKED)' 'yes'
   PIXI_FILE_INSTALL= $(ENV_DIR)/pixi.toml $(ENV_DIR)/pixi.lock

   PIXI_FILE_DEPEND=$(PIXI_LOCK_DIR)/pixi.toml $(PIXI_LOCK_DIR)/pixi.lock

   PIXI_INSTALL_COMMAND= pixi install --frozen --manifest-path $(ENV_DIR) 
else
   PIXI_FILE_INSTALL= $(ENV_DIR)/pixi.toml

   PIXI_FILE_DEPEND=$(PIXI_LOCK_DIR)/pixi.toml

   PIXI_INSTALL_COMMAND= pixi install --manifest-path $(ENV_DIR) 
endif

$(ENV_DIR): $(PIXI_FILE_DEPEND)
	-rm -rf $(ENV_DIR)
	pixi init -c conda-forge -c $(CONDA_PACKAGE_DIR) $(ENV_DIR)
	rm $(ENV_DIR)/pixi.toml
	$(MAKE) $(PIXI_FILE_INSTALL)
	$(PIXI_INSTALL_COMMAND)
	$(PIXI_RUN) bash -c "\$$CONDA_PREFIX/bin/conda env config vars set REFRACTOR_INPUT_PATH=\$$CONDA_PREFIX/etc/refractor/input MUSES_ABSCO_DIR=$(MUSES_ABSCO_DIR) MUSES_OSP_PATH=$(MUSES_OSP_PATH) MUSES_JOSH_OSP_PATH=$(MUSES_JOSH_OSP_PATH) MUSES_GMAO_PATH=$(MUSES_GMAO_PATH) MUSES_RING_CLI=\$$CONDA_PREFIX/bin MUSES_VLIDORT_CLI=\$$CONDA_PREFIX/bin"
	if [ -n "$(EXTRA_INSTALL)" ]; then \
	  cd $(ENV_DIR) && pixi add $(EXTRA_INSTALL); \
	fi

# Don't normally need to run index, it happens automatically when we build.
# But can be useful if for example you manually remove an older version file
reindex:
	-rm -r muses-conda-channel/linux-64/shards
	-rm -r muses-conda-channel/noarch/shards
	-rm -r muses-conda-channel/osx-arm64/shards
	rattler-index fs -f ./muses-conda-channel

muses-conda-channel/built-%: muses-package/%/recipe.yaml
	rattler-build build --output-dir ./muses-conda-channel/ -c conda-forge -c ./muses-conda-channel --recipe $<
	touch $@
	chmod -R a+rX ./muses-conda-channel

build-%: 
	$(MAKE) muses-conda-channel/built-$*

force-build-%:
	-rm muses-conda-channel/built-$*
	$(MAKE) muses-conda-channel/built-$*

# We use --no-cache-dir so we don't use a fixed wheel, since we tend
# to update source without updating the version number. Also, we use
# --no-build-isolation, we don't need or want build isolation but
# rather want to use the packages we have already installed in conda.
# Installed in editable mode if PIP_INSTALL_EDITABLE is true
# Finally, muses-tools has versions nailed down too tight in its specification.
#
# Should perhaps discuss that and work around it, but for now just skip installing
# requirements. This is probably the right thing, the idea is that the conda environment
# installs all the requirements, not the packages. We can revisit this if needed.

install-%: $(ENV_DIR)
	$(MAKE) $(addprefix $(MUSES_DIR)/, $*)
	cd $(ENV_DIR) && NO_FIXED_VERSION=t pixi run pip install $(if $(filter $(PIP_INSTALL_EDITABLE),yes),--editable) $(MUSES_DIR)/$* --no-cache-dir --no-build-isolation --no-dependencies

# py-setup-targets depends on muses-tools, so install those first
install-py-setup-targets: install-muses-tools

# refractor-muses depends on refractor-framework
install-refractor-muses: install-refractor-framework

# Install refractor-muses, but don't rebuild framework
install-refractor-muses-only: 
	cd $(ENV_DIR) && NO_FIXED_VERSION=t pixi run pip install $(if $(filter $(PIP_INSTALL_EDITABLE),yes),--editable) $(MUSES_DIR)/refractor-muses --no-cache-dir --no-build-isolation --no-dependencies

$(BUILD_FRAMEWORK_DIR)/build_conda.txt: $(ENV_DIR) support_files/build_conda.txt support_files/build_conda_debug.txt
	$(MAKE) $(addprefix $(MUSES_DIR)/, refractor-framework)
	$(MKDIR_P) $(BUILD_FRAMEWORK_DIR)
	cp -f support_files/build_conda.txt support_files/build_conda_debug.txt $(BUILD_FRAMEWORK_DIR)
	-rm -r $(BUILD_FRAMEWORK_DIR)/build_conda $(BUILD_FRAMEWORK_DIR)/build_conda_debug
	$(MKDIR_P) $(BUILD_FRAMEWORK_DIR)/build_conda $(BUILD_FRAMEWORK_DIR)/build_conda_debug
	cd $(BUILD_FRAMEWORK_DIR)/build_conda && ln -s ../build_conda.txt
	cd $(BUILD_FRAMEWORK_DIR)/build_conda_debug && ln -s ../build_conda_debug.txt

ifeq "$(RUN_CTEST)" "yes"
   EXTRA_FRAMEWORK_BUILD=&& CTEST_PARALLEL_LEVEL=20 CTEST_OUTPUT_ON_FAILURE=1 ninja all_test
else
   EXTRA_FRAMEWORK_BUILD=
endif

ifeq "$(BUILD_FRAMEWORK_DEBUG)" "yes"
   BUILD_FRAMEWORK_CONFIG_SCRIPT:=$(BUILD_FRAMEWORK_DIR)/build_conda_debug.txt
   FULL_BUILD_FRAMEWORK_DIR=$(BUILD_FRAMEWORK_DIR)/build_conda_debug
else
   BUILD_FRAMEWORK_CONFIG_SCRIPT:=$(BUILD_FRAMEWORK_DIR)/build_conda.txt
   FULL_BUILD_FRAMEWORK_DIR=$(BUILD_FRAMEWORK_DIR)/build_conda
endif

ifeq "$(BUILD_FRAMEWORK)" "yes"

   install-refractor-framework: $(BUILD_FRAMEWORK_DIR)/build_conda.txt
	$(PIXI_RUN) bash -c "cd $(FULL_BUILD_FRAMEWORK_DIR) && source $(BUILD_FRAMEWORK_CONFIG_SCRIPT) && ninja all && ninja install $(EXTRA_FRAMEWORK_BUILD)"

else

   install-refractor-framework: $(ENV_DIR)
	echo "Nothing to do"

endif

# Generate our own pipeline config to 1) point at our test data (so we can run
# standalone) and 2) add a test grid that has just a few values so we can run
# end to end quickly
$(TEST_PIPELINE_CONFIG): support_files/test_survey.yml
	-rm -r $(TEST_PIPELINE_CONFIG)
	$(PIXI_RUN) amuse-config export -p $(TEST_PIPELINE_CONFIG)
	sed -i 's#/project/muses/input#$(REFRACTOR_TEST_DATA_DIR)/fake_input#g' $(TEST_PIPELINE_CONFIG)/sensor_config.yml
	sed -i 's#/project/muses/input/geos_fp_it#$(MUSES_GMAO_PATH)#g' $(TEST_PIPELINE_CONFIG)/setup_targets.yml
	sed -i 's#bin/py-retrieve#bin/refractor-retrieve#g' $(TEST_PIPELINE_CONFIG)/retrieve.yml
	cat support_files/test_survey.yml >> $(TEST_PIPELINE_CONFIG)/profile.yml




