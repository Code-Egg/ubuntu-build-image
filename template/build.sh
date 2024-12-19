#!/usr/bin/env bash
OLS_VERSION=''
PHP_VERSION=''
PUSH=''
CONFIG=''
TAG=''
BUILDER='eggcold'
REPO='debian-build'
EPACE='        '

echow(){
    FLAG=${1}
    shift
    echo -e "\033[1m${EPACE}${FLAG}\033[0m${@}"
}

help_message(){
    echo -e "\033[1mOPTIONS\033[0m" 
    echo "${EPACE}${EPACE}Example: bash build.sh"
    echow '--push'
    echo "${EPACE}${EPACE}Example: build.sh --push, will push to the dockerhub"
    exit 0
}

check_input(){
    if [ -z "${1}" ]; then
        help_message
    fi
}

build_image(){
    docker build . --tag ${BUILDER}/${REPO} 
}

push_image(){
    if [ ! -z "${PUSH}" ]; then
        docker ${CONFIG} push ${BUILDER}/${REPO}:${1}-${2}
        if [ ! -z "${TAG}" ]; then
            docker tag ${BUILDER}/${REPO}:${1}-${2} ${BUILDER}/${REPO}:${3}
            docker ${CONFIG} push ${BUILDER}/${REPO}:${3}
        fi
    else
        echo 'Skip Push.'    
    fi
}

main(){
    build_image ${OLS_VERSION} ${PHP_VERSION}
    push_image ${OLS_VERSION} ${PHP_VERSION} ${TAG}
}

check_input ${1}
while [ ! -z "${1}" ]; do
    case ${1} in
        -[hH] | -help | --help)
            help_message
            ;;
        -[tT] | -tag | -TAG | --tag) shift
            TAG="${1}"
            ;;       
        --push ) shift
            PUSH=true
            ;;            
        *) 
            help_message
            ;;              
    esac
    shift
done

main