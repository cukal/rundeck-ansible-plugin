@echo off
docker-compose -f dockercomposefile-debian8.yaml rm -fv
docker-compose -f dockercomposefile-debian8.yaml pull && docker-compose -f dockercomposefile-debian8.yaml build && docker-compose -f dockercomposefile-debian8.yaml run -d rundeck
docker logs -f ansibleplugin_rundeck_run_1
rem `docker-compose run` doesn't support interactive mode on windows yet, so we need to run it in the background and fetch the logs
rem exit /b %errorlevel%
