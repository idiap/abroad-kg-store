#!/bin/bash

# SPDX-FileCopyrightText: 2025 2025 Idiap Research Institute <contact@idiap.ch>
# SPDX-FileContributor: Delmas Maxime maxime.delmas@idiap.ch
# SPDX-License-Identifier: gpl-3.0-or-later.txt

# necessite ./share/updload.sh

# USAGE (1) : ${0} start                  # start virtuoso and load data with script ./share/updload.sh
# USAGE (2) : ${0} stop                   # stop virtuoso                  
# USAGE (3) : ${0} clean                  # remove docker directory

# Run: bash workflow/w_virtuoso.sh -d /home/mdelmas/Documents/ABRoad/data/kg-test -c start settings.sh load_voc.sh upload_gbif-taxonomy_01-12-2022.sh upload_gbifspecies-closeMatch_20-03-2023.sh upload_gbif-species2pubchem_18-03-2023.sh upload_mycobank-taxonomy_23-03-2022.sh upload_mycobank-closeMatch_20-03-2023.sh upload_mycobank-species2pubchem_18-03-2023.sh upload_pubchem-type_2023-03-09.sh upload_identification_2022.sh update.sh

while getopts d:s:c: flag;
	do
	    case "${flag}" in
	        d) DOCKER_DIR=${OPTARG};;
            c) CMD=${OPTARG};;
	    esac
	done

if [ "$CMD" != "start" ] && [ "$CMD" != "stop" ] && [ "$CMD" != "clean" ]; then
    echo "-c (command) must be 'start' or 'stop' or 'clean'"
    exit 1
fi

shift $(($OPTIND - 1))
uploads="$@"

COMPOSE_PROJECT_NAME="abroad"
LISTEN_PORT="80" #"9980"
PASSWORD="ABRoad"
GRAPH="http://default#"
ALLOW_UDPATE="true"


function waitStarted() {
    set +e
    RES=1
    echo -n "Wait for start "
    until [ $RES -eq 0 ]; do
        echo -n "."
        sleep 1
        # As we check logs every 1 sec (sleep 1), we only check logs for the last 2 sec (--since 2s) to avoid grapping a "Server Online message" from a previous start
        docker logs --since 2s ${CONTAINER_NAME} 2>&1 | grep "Server online at 1111" > /dev/null
        RES=$?
    done
    echo ""
    set -e
}

function virtuosoControler() {
    echo " -- Virtuoso controler"

    echo " -- Generating docker-compose"
    COMPOSE_FILE="${DOCKER_DIR}/docker-compose-${LISTEN_PORT}.yml"
    COMPOSE_CMD="docker compose -p ${COMPOSE_PROJECT_NAME} -f ${COMPOSE_FILE}" # Ici Olivier faisait sudo -n docker-compose
    CONTAINER_NAME="${COMPOSE_PROJECT_NAME}_virtuoso_${LISTEN_PORT}"
    NETWORK_NAME="virtuoso_${LISTEN_PORT}_net"
    OUT_NETWORK_NAME="${COMPOSE_PROJECT_NAME}_${NETWORK_NAME}"
    cat << EOF | tee ${COMPOSE_FILE} > /dev/null
services:
    virtuoso:
        image: openlink/virtuoso-opensource-7:latest
        container_name: ${CONTAINER_NAME}
        environment:
            VIRT_Parameters_DirsAllowed: "., ../vad, /usr/share/proj, /import"
            VIRT_Parameters_NumberOfBuffers: 680000   # See virtuoso/README.md to adapt value of this line
            VIRT_Parameters_MaxDirtyBuffers: 500000    # See virtuoso/README.md to adapt value of this line
            VIRT_Parameters_MaxCheckpointRemap: 680000
            VIRT_Parameters_TN_MAX_memory: 2000000000
            VIRT_SPARQL_ResultSetMaxRows: 10000000000
            VIRT_SPARQL_MaxDataSourceSize: 10000000000
            VIRT_SPARQL_MaxConstructTriples: 10000000
            VIRT_Flags_TN_MAX_memory: 2000000000
            VIRT_Parameters_StopCompilerWhenXOverRunTime: 1
            VIRT_SPARQL_MaxQueryCostEstimationTime: 0       # query time estimation
            VIRT_SPARQL_MaxQueryExecutionTime: 50000          # 5 min
            VIRT_Parameters_MaxMemPoolSize: 200000000
            VIRT_HTTPServer_EnableRequestTrap: 0
            VIRT_Parameters_ThreadCleanupInterval: 1
            VIRT_Parameters_ResourcesCleanupInterval: 1
            VIRT_Parameters_AsyncQueueMaxThreads: 1
            VIRT_Parameters_ThreadsPerQuery: 1
            VIRT_Parameters_VectorSize: 100000
            VIRT_Parameters_MaxVectorSize: 3000000
            VIRT_Parameters_AdjustVectorSize: 1
            VIRT_Parameters_MaxQueryMem: 8G
            DBA_PASSWORD: "${PASSWORD}"
            SPARQL_UPDATE: "${ALLOW_UDPATE}"
            DEFAULT_GRAPH: "${GRAPH}"
        volumes:
           - ${DOCKER_DIR}/database:/database
           - ${DOCKER_DIR}/import:/import
        ports:
           - ${LISTEN_PORT}:8890
        networks:
           - ${NETWORK_NAME}

networks:
    ${NETWORK_NAME}:
EOF
    case $CMD in
        start)
	    chgrp -R docker ${DOCKER_DIR}/import
	    chmod -R g+rwx ${DOCKER_DIR}/import
            if [ -d ${DOCKER_DIR}/database ]; then
                echo " -- Already generated."
                echo " -- Start Container"
                ${COMPOSE_CMD} up -d
                waitStarted
            else
                if [ "${uploads[0]}" = "" ]; then
                    echo "No upload files to load. Please, specificy a list of upload files."
                    echo "Exit"
                    exit 1
                fi
                echo " -- Generating new compose instance."             
                echo "---------------------------------" 
		mkdir -p ${DOCKER_DIR}/database
		chgrp docker ${DOCKER_DIR}/database
		chmod g+rwx ${DOCKER_DIR}/database
                echo " -- Pull Images"
                ${COMPOSE_CMD} pull
                echo " -- Start Container"
                ${COMPOSE_CMD} up -d
                waitStarted
                echo " -- Container started."
                
                for f in ${uploads[@]}; do
                echo "Load $f: docker exec ${CONTAINER_NAME} isql 1111 dba '${PASSWORD}' /import/$f"
                docker exec \
                    ${CONTAINER_NAME} \
                    isql 1111 dba "${PASSWORD}" /import/$f
                done
            fi
        ;;
        stop)
            ${COMPOSE_CMD} stop
        ;;
        clean)
            if [ -d ${DOCKER_DIR}/database ];then
		        ${COMPOSE_CMD} down
                set +e
                rm -rf ${DOCKER_DIR}/database
                set -e
            else
                echo " -- Instance not present. Skipping cleaning."
            fi
        ;;
        *)
            rm ${COMPOSE_FILE}
            echo "Error: unsupported command $CMD"
            exit 1
        ;;
    esac
    exit 0
}

virtuosoControler
