#!/bin/sh
set -e
"$(dirname "$0")/scripts/setup-build-env.sh"
export MAVEN_OPTS="-Xms2g -Xmx4g"
mvn clean -DskipTests package -T 2C 
