# docker-robotframework
A container to run RobotFramework tests.

Original project: ppodgorsek/docker-robot-framework

- Build: 'docker build $(pwd) --tag docker-robotframework:latest'
- Run: 'docker run --rm -v /home/matteo/dev/robotframework/test:/opt/robotframework/tests:Z -e BROWSER=chrome docker-robotframework'
- Inspect container: 'docker run -it --rm --user root --entrypoint /bin/sh docker-robotframework'
- Test virtual screen browser: 'xvfb-run --server-args="-screen 0 1920x1080x24 -ac" /usr/bin/chromium-browser --no-sandbox --disable-gpu'
