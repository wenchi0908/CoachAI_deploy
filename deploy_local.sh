#/bin/bash

# check flags
build_b=0
build_f=0
while getopts 'bf' OPTION; do
    case "$OPTION" in
        b)
            build_b=1
            ;;
        f)
            echo "[ Build frontend ]"
            build_f=1
            ;;
        ?)
            echo "script usage: sh deploy_local.sh [-b] [-f]" >&2
            exit 1
            ;;
    esac
done

# stop all cintainers
docker-compose down

# build image
echo "[ Images building ... ]"

if [ $build_f -eq 1 ]
then
    echo "[ Build frontend ]"
    docker-compose build --no-cache frontend-web
fi
if [ $build_b -eq 1 ]
then
    echo "[ Build backend ]"
    docker-compose build --no-cache www
fi
echo "[ Images builded ]"

# run app in container:www
docker-compose up -d www
#docker-compose exec -itd www sh /APP/deploy.sh
echo "[ App is running in container:www ]"

# package static source in container:frontend-web
docker-compose up -d frontend-web
echo "[ Static source created in container:frontend-web ]"

docker-compose ps
