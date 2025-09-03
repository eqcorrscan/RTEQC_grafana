#!/bin/bash

# Defaults that can be overwritten by the user through cmd line args
IMAGE="rteqc-grafana"
TAG="latest"
NAME="rteqc-grafana"

# Ports
HOST_PORT="3000"
CONTAINER_PORT="3000"


function usage(){
cat <<EOF
Usage: $0 [Options] 
Build or run docker $IMAGE

Optional Arguments:
    -h, --help              Show this message.
    -b, --build             Rebuild the image.
    -c, --clean             Clean out the old image.
    -r, --run               Run the API
    --image                 Provide alternative image name.
    --name                  Provide an alternative name for the running image
    --tag                   Provide alternative tag
EOF
}

# Processing command line options
if [[ $# -eq 0 ]] ; then
    usage
    exit 1
fi

while [ $# -gt 0 ]
do
    case "$1" in
        -b | --build) BUILD=true;;
        -r | --run) RUN=true;;
        -c | --clean) CLEAN=true;;
        --image) IMAGE="$2";shift;;
        --name) NAME="$2";shift;;
        --tag) TAG="$2";shift;;
        -h) usage; exit 0;;
        -*) echo "Unknown args: $1"; usage; exit 1;;
esac
shift
done

if [ "${CLEAN}" == "true" ]; then
  echo "Removing current version of ${IMAGE}:${TAG}"
  docker rmi "${IMAGE}:${TAG}"
fi

if [ "${BUILD}" == "true" ]; then
  echo "Building ${IMAGE}:${TAG}"
  # Usually you should be able to re-use the old image, for changes to the rteqcorrscan or 
  # eqcorrscan repos we need to rebuild
  if [ "${CLEAN}" == "true" ]; then
      docker build --no-cache -t $IMAGE:${TAG} .
  else
      docker build -t $IMAGE .
  fi
fi

if [ "${RUN}" == "true" ]; then
  echo "Running API"
  docker run \
    --rm -d --name $NAME -h $HOSTNAME \
    -p $HOST_PORT:$CONTAINER_PORT \
    $IMAGE:$TAG

  # -- Find container
  CONTAINER="$(docker ps | grep $NAME:$TAG | awk '{print $1}')"
  PORT="$(docker inspect $CONTAINER | grep HostPort | tail -1 | awk -F\" '{print $4}')"

  echo $NAME:$TAG up and running on container: $CONTAINER
  echo Try
  echo http://`hostname`:$PORT
fi
