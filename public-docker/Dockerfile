FROM oraclelinux:8

MAINTAINER Mike Smyth Mike.M.Smyth@jpl.nasa.gov

ARG REFRACTOR_BUILD_SUPPLEMNT_OPEN_SOURCE_VERSION=v0.1
ARG REFRACTOR_BUILD_SUPPLEMENT_OPEN_SOURCE_URL=https://github.com/ReFRACtor/refractor-build-supplement.git
ARG MUSES_CONDA_CHANNEL_OPEN_SOURCE_TAR_URL=https://github.com/ReFRACtor/refractor-build-supplement/releases/download/v0.1/muses-conda-channel.tar
ARG REFRACTOR_MUSES_OPEN_SOURCE_URL=https://github.com/ReFRACtor/refractor-muses.git

# Install pixi
# ------------------------------------------------------------
RUN dnf install -y git git-lfs make && curl -fsSL https://pixi.sh/install.sh | sh

# Download build supplement (public open source version)
# ------------------------------------------------------------
RUN mkdir /home/workdir && cd /home/workdir && git clone $REFRACTOR_BUILD_SUPPLEMENT_OPEN_SOURCE_URL refractor-build-supplement && cd refractor-build-supplement && curl -fsSL $MUSES_CONDA_CHANNEL_OPEN_SOURCE_TAR_URL | tar -x

# Install pixi environment, with latest refractor-muses
# ------------------------------------------------------------
RUN bash --login -c "cd /home/workdir/refractor-build-supplement && make REFRACTOR_MUSES_URL=$REFRACTOR_MUSES_OPEN_SOURCE_URL REFRACTOR_MUSES_FROM_SOURCE=yes USE_CLOSED_SOURCE=no MUSES_DIR=/home/muses install-current"

# Set up to automatically start pixi environment on login
# ------------------------------------------------------------
RUN bash --login -c "pixi shell-hook --shell bash --manifest-path /home/muses/muses-env > /etc/profile.d/pixi.sh"