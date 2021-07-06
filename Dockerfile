FROM registry.redhat.io/rhel8/python-39

LABEL description Robot Framework in Docker

# Set the reports directory environment variable
ENV ROBOT_REPORTS_DIR /opt/robotframework/reports

# Set the tests directory environment variable
ENV ROBOT_TESTS_DIR /opt/robotframework/tests

# Set the working directory environment variable
ENV ROBOT_WORK_DIR /opt/robotframework/temp

# Set the scripts directory environment variable
ENV ROBOT_BIN_DIR /opt/robotframework/bin

# Setup X Window Virtual Framebuffer
ENV SCREEN_COLOUR_DEPTH 24
ENV SCREEN_HEIGHT 1080
ENV SCREEN_WIDTH 1920

# Set number of threads for parallel execution (default is no parallelisation)
ENV ROBOT_THREADS 1

# Define the default user who'll run the tests
ENV ROBOT_UID 1000
ENV ROBOT_GID 1000

# Dependencies versions
ENV FIREFOX_VERSION 78.0
ENV GECKO_DRIVER_VERSION 0.29.0

# Prepare binaries to be executed
COPY bin/chromedriver.sh ${ROBOT_BIN_DIR}/chromedriver
COPY bin/chromium-browser.sh ${ROBOT_BIN_DIR}/chromium-browser
COPY bin/run-tests-in-virtual-screen.sh ${ROBOT_BIN_DIR}/

# Setup for DNF install of Google Chrome
COPY extra.repo /etc/yum.repos.d/google-chrome.repo
COPY rpm-gpg/RPM-GPG-KEY-EPEL-8 /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-8

################################## Root Section ##################################

USER root

# Install system dependencies
RUN dnf install --nodocs -y \
  gcc \
  libffi-devel \
  make \
  openssl-devel \
  which \
  wget \
  chromium \
  chromedriver \
  xorg-x11-server-Xvfb \
# Update pip
  && /opt/app-root/bin/python3.9 -m pip install --upgrade pip \
# Install Robot Framework and Selenium Library
  && pip3 install --no-cache-dir \
    robotframework==4.0 \
    robotframework-databaselibrary==1.2 \
    robotframework-faker==5.0.0 \
    robotframework-ftplibrary==1.9 \
    robotframework-imaplibrary2==0.4.0 \
    robotframework-pabot==1.11 \
    robotframework-requests==0.8.1 \
    robotframework-seleniumlibrary==5.1.1 \
    robotframework-sshlibrary==3.6.0 \
    robotframework-excellib==2.0.1 \
    robotframework-selenium2library==3.0.0 \
    robotframework-pdf2textlibrary==1.0.1 \
    robotframework-archivelibrary \
    PyYAML \
    JayDeBeApi \
    lxml\
    xlrd\
    suds-py3\
    requests==2.25.1 \
# Install Firefox browser
  && wget -O- "https://ftp.mozilla.org/pub/firefox/releases/${FIREFOX_VERSION}/linux-x86_64/en-US/firefox-${FIREFOX_VERSION}.tar.bz2" | tar -jx -C /usr/local/ \
  && echo "exclude=firefox" >> /etc/dnf/dnf.conf \
  && ln -s /usr/local/firefox/firefox /usr/bin/firefox \
# Install Gecko driver
  && wget -q "https://npm.taobao.org/mirrors/geckodriver/v${GECKO_DRIVER_VERSION}/geckodriver-v${GECKO_DRIVER_VERSION}-linux64.tar.gz" \
  && tar xzf geckodriver-v$GECKO_DRIVER_VERSION-linux64.tar.gz \
  && mkdir -p /opt/robotframework/drivers/ \
  && mv geckodriver /opt/robotframework/drivers/geckodriver \
  && rm geckodriver-v$GECKO_DRIVER_VERSION-linux64.tar.gz \
# Create the default report and work folders with the default user to avoid runtime issues
# Folders are writeable by anyone, to ensure the user can be changed on the command line
  && mkdir -p ${ROBOT_REPORTS_DIR} \
  && mkdir -p ${ROBOT_WORK_DIR} \
  && chown ${ROBOT_UID}:${ROBOT_GID} ${ROBOT_REPORTS_DIR} \
  && chown ${ROBOT_UID}:${ROBOT_GID} ${ROBOT_WORK_DIR} \
# Allow any user to write logs
  && chmod ugo+w ${ROBOT_REPORTS_DIR} ${ROBOT_WORK_DIR} /var/log \
  && chown ${ROBOT_UID}:${ROBOT_GID} /var/log \
# Grant execute permissions to scripts in bin/ folder
  && chown ${ROBOT_UID}:${ROBOT_GID} ${ROBOT_BIN_DIR}/* \
  && chmod +x  ${ROBOT_BIN_DIR}/*

USER 1001

################################ Root Section End ################################

# Update system path
ENV PATH=${ROBOT_BIN_DIR}:/opt/robotframework/drivers:$PATH

# Set up a volume for the generated reports
VOLUME ${ROBOT_REPORTS_DIR}

USER ${ROBOT_UID}:${ROBOT_GID}

# A dedicated work folder to allow for the creation of temporary files
WORKDIR ${ROBOT_WORK_DIR}

# Execute all robot tests
CMD ["run-tests-in-virtual-screen.sh"]
