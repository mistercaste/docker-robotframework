# docker-robotframework
A Docker container to run RobotFramework tests.

Original project(s): [ppodgorsek/docker-robot-framework](https://github.com/ppodgorsek/docker-robot-framework) and [christophettat/Robot_CoE](https://github.com/christophettat/Robot_CoE)

### Build & Run RobotFramework
From project folder:
1. Build: `docker build $(pwd) --tag docker-robotframework:latest`
2. Run Tests:
  - Firefox: `docker run --rm -v $(pwd)/test:/opt/robotframework/tests:Z -e BROWSER=firefox docker-robotframework`
  - Chromium: `docker run --shm-size=1g --rm -v $(pwd)/test:/opt/robotframework/tests:Z -e BROWSER=chrome docker-robotframework`

### Useful Tips
- Get inside the container (once built): `docker run -it --rm --user root --entrypoint /bin/sh docker-robotframework`
- Test virtual screen browser (inside container sample): `xvfb-run --server-args="-screen 0 1920x1080x24 -ac" /usr/bin/chromium-browser --no-sandbox --disable-gpu`

### Release Notes
- 1.0
  - RPMs from mixed CentOS/Fedora repositories
  - Gecko Driver and Firefox downloaded with wget
- Latest
  - RPMs from Fedora repositories
  - Gecko Driver and Firefox downloaded with wget
