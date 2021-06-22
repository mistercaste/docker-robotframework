# docker-robotframework
A container to run RobotFramework tests.

Original project: ppodgorsek/docker-robot-framework

- Build: 'docker build $(pwd)'
- Run: 'docker run --rm -v /home/matteo/dev/robotframework/test:/opt/robotframework/tests:Z -e BROWSER=chrome <CONTAINER_ID>'
- Inspect container: 'docker run -it --rm --user root --entrypoint /bin/sh <CONTAINER_ID>'
# docker-robotframework
