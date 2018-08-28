#!/usr/bin/env bash

: ${RELEASE_WIN32_ZIP:=https://ioquake3.org/files/jenkins/latest/gcc/no_options/release-mingw32-x86_64.zip}
: ${IOQUAKE3_Q3A_RUN:=https://ioquake3.org/files/1.36/data/ioquake3-q3a-1.32-9.run}
: ${CPMA_NOMAPS_ZIP:=https://cdn.playmorepromode.com/files/cpma/cpma-1.51-nomaps.zip}
: ${CPMA_MAPPACK_FULL_ZIP:=https://cdn.playmorepromode.com/files/cpma-mappack-full.zip}

if [ -z "$NO_CACHE" ] || [ "$NO_CACHE" = 0 ]; then
    NO_CACHE=""
else
    NO_CACHE="--no-cache"
fi

set -o errexit -o nounset -o pipefail
set -x

which readlink xargs dirname docker

SELF=`readlink -f $0 | xargs dirname`

[ -f "$SELF/files/pak0.pk3" ]

docker build $NO_CACHE -t cpma-win32 $SELF/ -f- <<EOF
FROM ubuntu:18.04

RUN apt-get -q update -y \\
 && apt-get -q install -y curl zip unzip vim mc \\
 && apt-get -q clean -y

ENV Q3A_HOME=/root/.q3a
ENV BASEQ3=\$Q3A_HOME/baseq3

RUN curl -fsSL $RELEASE_WIN32_ZIP -o /root/download.zip \\
 && unzip /root/download.zip -d \$Q3A_HOME/ \\
 && /bin/rm -f /root/download.zip

RUN curl -fsSL $IOQUAKE3_Q3A_RUN -o /root/download.run \\
 && chmod +x /root/download.run \\
 && mkdir -p /root/download.tmp/ \\
 && /root/download.run --noexec --target /root/download.tmp/ \\
 && tar xf /root/download.tmp/idpatchpk3s.tar -C \$BASEQ3/ \\
 && /bin/rm -rf /root/download.run /root/download.tmp/

RUN curl -fsSL $CPMA_NOMAPS_ZIP -o /root/download.zip \\
 && unzip /root/download.zip -d \$Q3A_HOME/ \\
 && /bin/rm -f /root/download.zip

RUN curl -fsSL $CPMA_MAPPACK_FULL_ZIP -o /root/download.zip \\
 && unzip /root/download.zip -d \$Q3A_HOME/cpma/ \\
 && /bin/rm -f /root/download.zip

WORKDIR /root/

ENTRYPOINT []
CMD /bin/bash
EOF

if [ -z "$@" ]; then
    CMD="zip -r /output/.q3a-win32.zip .q3a/"
else
    CMD="$@"
fi

exec docker run --rm \
    --network="host" \
    --privileged="true" \
    -v $SELF/files/pak0.pk3:/root/.q3a/baseq3/pak0.pk3:Z \
    -v $SELF/output/:/output/:Z \
    -it cpma-win32 \
    $CMD

# vim:ts=4:sw=4:et:
