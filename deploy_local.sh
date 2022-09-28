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
if [ $build_b -eq 0 ] && [ $build_f -eq 0 ]
then
    build_b=1
    build_f=1
fi

# clean folder
rm -rf ./front_src/
mkdir -p ./front_src/
#rm -rf ./front_src/build/
echo "[ Init ./front_src/ ]"

# stop all cintainers
docker-compose down
#docker volume rm 0823_2022_test_vol 

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
#docker-compose build frontend-web www
echo "[ Images builded ]"

# package static source in container:frontend-web
docker-compose up frontend-web
echo "[ Static source created in container:frontend-web ]"

# run app in container:www
docker-compose up -d www
docker-compose exec -itd www sh /APP/deploy.sh
echo "[ App is running in container:www ]"
docker-compose ps

