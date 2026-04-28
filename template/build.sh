#!/usr/bin/env bash

PUSH=''
TAG=''
BUILDER='eggcold'
REPO='debian-build'
EPACE='        '

echow(){
    FLAG=${1}
    shift
    echo -e "\033[1m${EPACE}${FLAG}\033[0m ${@}"
}

help_message(){
    echo -e "\033[1mOPTIONS\033[0m"
    echo "${EPACE}Example: bash build.sh (build with tag dev)"
    echo "${EPACE}Example: bash build.sh -t 10 (build only with tag 10)"
    echo "${EPACE}Example: bash build.sh --push (push with latest and number+1)"
    exit 0
}

check_input(){
    if [ -z "${1}" ]; then
        return
    fi
}

auto_tag(){
    echow "INFO" "Fetching latest tag from Docker Hub..."

    LATEST=$(curl -s "https://hub.docker.com/v2/repositories/${BUILDER}/${REPO}/tags?page_size=100" \
        | jq -r '.results[].name' \
        | grep -E '^[0-9]+$' \
        | sort -n \
        | tail -1)

    if [[ -z "$LATEST" ]]; then
        TAG=1
    else
        TAG=$((LATEST + 1))
    fi

    echow "INFO" "Auto tag: ${TAG}"
}

build(){
    OUTPUT="--load"

    if [[ ! -z "${PUSH}" ]]; then
        OUTPUT="--push"
    fi

    echow "INFO" "Building image..."
    echow "INFO" "Tag: ${TAG}"
    echow "INFO" "Push: ${PUSH:-false}"

    docker buildx build \
        -f Dockerfile . \
        --platform linux/amd64,linux/arm64 \
        -t ${BUILDER}/${REPO}:latest \
        -t ${BUILDER}/${REPO}:${TAG} \
        ${OUTPUT} \
        --progress=plain
}

main(){
    if [[ -z "${TAG}" && ! -z "${PUSH}" ]]; then
        auto_tag
    fi
    if [[ -z "${TAG}" ]]; then
        TAG="dev"
    fi
    build
}

while [ ! -z "${1}" ]; do
    case ${1} in
        -h|-H|-help|--help)
            help_message
            ;;

        -t|-T|--tag)
            TAG="${2}"
            shift
            ;;

        --push)
            PUSH=true
            ;;

        *)
            if [[ "${1}" == -* ]]; then
                help_message
            fi
            ;;
    esac
    shift
done

main