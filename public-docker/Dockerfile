FROM oraclelinux:8

MAINTAINER Mike Smyth Mike.M.Smyth@jpl.nasa.gov

ARG MUSES_CONDA_CHANNEL_OPEN_SOURCE_TAR_URL=https://github.com/ReFRACtor/refractor-build-supplement/releases/download/v0.9/muses-conda-channel.tar
ARG MUSES_CRIS_ML_TEST_IN_TAR_URL=https://github.com/ReFRACtor/refractor-build-supplement/releases/download/v0.9/cris_ml_test_in.tar
ARG REFRACTOR_MUSES_OPEN_SOURCE_URL=https://github.com/ReFRACtor/refractor-muses.git

# Install pixi
# ------------------------------------------------------------
RUN dnf install -y git git-lfs make && curl -fsSL https://pixi.sh/install.sh | sh
RUN chmod a+rX -R /root/.pixi

# Download build supplement (public open source version)
# ------------------------------------------------------------
RUN mkdir -p /home/workdir/refractor-build-supplement
COPY . /home/workdir/refractor-build-supplement
RUN cd /home/workdir/refractor-build-supplement && curl -fsSL $MUSES_CONDA_CHANNEL_OPEN_SOURCE_TAR_URL | tar -x

# Install pixi environment, with latest refractor-muses
# ------------------------------------------------------------
RUN bash --login -c "cd /home/workdir/refractor-build-supplement && make REFRACTOR_MUSES_URL=$REFRACTOR_MUSES_OPEN_SOURCE_URL REFRACTOR_MUSES_FROM_SOURCE=yes USE_CLOSED_SOURCE=no MUSES_DIR=/home/muses install-current"

# Install cris test input. It isn't clear how we want to handle this
# long term, perhaps as part of OSP that is in a S3 bucket or something.
# But for now, have just downloaded and installed
# ------------------------------------------------------------
RUN cd /home/muses && curl -fsSL $MUSES_CRIS_ML_TEST_IN_TAR_URL | tar -x

# Set up to automatically start pixi environment on login
# ------------------------------------------------------------
RUN bash --login -c "pixi shell-hook --shell bash --manifest-path /home/muses/muses-env > /etc/profile.d/pixi.sh"
