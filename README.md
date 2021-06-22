# docker-robotframework
A Docker container to run RobotFramework tests.

Original project(s): [ppodgorsek/docker-robot-framework](https://github.com/ppodgorsek/docker-robot-framework) and [christophettat/Robot_CoE](https://github.com/christophettat/Robot_CoE)

1. Build (from project folder): `docker build $(pwd) --tag docker-robotframework:latest`
2. Run (from project folder): `docker run --shm-size=1g --rm -v $(pwd)/test:/opt/robotframework/tests:Z -e BROWSER=chrome docker-robotframework`
3. Get inside the container (once built): `docker run -it --rm --user root --entrypoint /bin/sh docker-robotframework`
4. Test virtual screen browser (inside container sample): `xvfb-run --server-args="-screen 0 1920x1080x24 -ac" /usr/bin/chromium-browser --no-sandbox --disable-gpu`
