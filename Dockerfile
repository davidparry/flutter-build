FROM openjdk:8
MAINTAINER David Parry

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    git \
    lib32stdc++6 \
    libglu1-mesa \
  && rm -rf /var/lib/apt/lists/*


# RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

ENV SDK_TOOLS "6858069_latest"
ENV BUILD_TOOLS "29.0.2"
ENV TARGET_SDK "30"
ENV ANDROID_HOME "/opt/sdk"

# Download and extract Android Tools
RUN curl -L http://dl.google.com/android/repository/commandlinetools-linux-${SDK_TOOLS}.zip -o /tmp/tools.zip --progress-bar && \
  mkdir -p ${ANDROID_HOME} && \
  unzip /tmp/tools.zip -d ${ANDROID_HOME} && \
  rm -v /tmp/tools.zip

RUN mv ${ANDROID_HOME}/cmdline-tools ${ANDROID_HOME}/tools

RUN mkdir ${ANDROID_HOME}/cmdline-tools

RUN mv ${ANDROID_HOME}/tools ${ANDROID_HOME}/cmdline-tools/tools

RUN ${ANDROID_HOME}/cmdline-tools/tools/bin/sdkmanager "--update"

# Install SDK Packages
RUN mkdir -p /root/.android/ && touch /root/.android/repositories.cfg && \
  yes | ${ANDROID_HOME}/cmdline-tools/tools/bin/sdkmanager "--licenses" && \
  ${ANDROID_HOME}/cmdline-tools/tools/bin/sdkmanager "--update" && \
  ${ANDROID_HOME}/cmdline-tools/tools/bin/sdkmanager "build-tools;${BUILD_TOOLS}" "platform-tools" "platforms;android-${TARGET_SDK}" "extras;android;m2repository" "extras;google;google_play_services" "extras;google;m2repository"

# Install flutter
ENV FLUTTER_HOME "/opt/flutter"
ENV FLUTTER_VERSION "2.8.1-stable"
RUN mkdir -p ${FLUTTER_HOME} && \
  curl -L http://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}.tar.xz -o /tmp/flutter.tar.xz --progress-bar && \
  tar xf /tmp/flutter.tar.xz -C /tmp && \
  mv /tmp/flutter/ -T ${FLUTTER_HOME} && \
  rm -rf /tmp/flutter.tar.xz

ENV PATH=$PATH:$FLUTTER_HOME/bin

RUN flutter doctor

# Using Debian, as root
RUN curl -fsSL https://deb.nodesource.com/setup_17.x | bash -
RUN apt-get install -y nodejs

RUN npm install -g typescript


RUN echo 'Done instaling Flutter, Node  ready to build'
