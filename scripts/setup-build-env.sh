#!/bin/sh
set -e

# Prepares the local environment for building Shop. Safe to run repeatedly; every step is a no-op once satisfied.
#   1. Registers a JDK 21 Maven toolchain. MockBukkit 4 requires the tests to run on JDK 21, while the plugin
#      itself still targets an older bytecode level (see the maven-toolchains-plugin config in core/pom.xml).
#   2. Installs the integration APIs that are not reliably resolvable from their upstream Maven/JitPack repos
#      (Dynmap, BlockProt) from their stable GitHub Releases. See the respective install scripts for details.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Discover and verify a real JDK 21 home. We can't simply trust $JAVA_HOME: locally it is often a newer JDK, and
# Mockito's inline mock maker cannot instrument classes on JDK 25. The toolchain's <jdkHome> must therefore point
# at an actual JDK 21, not whatever happens to be on the PATH. We verify every candidate's reported version
# because helpers like `/usr/libexec/java_home -v 21` can return an older JDK when no 21 is registered.
is_jdk21() {
  [ -n "$1" ] && [ -x "$1/bin/java" ] && "$1/bin/java" -version 2>&1 | grep -q 'version "21'
}

JDK21_HOME=""
if is_jdk21 "${JAVA_HOME:-}"; then
  JDK21_HOME="${JAVA_HOME}"
fi
if [ -z "${JDK21_HOME}" ]; then
  for candidate in "${HOME}"/.sdkman/candidates/java/21*; do
    if is_jdk21 "${candidate}"; then JDK21_HOME="${candidate}"; break; fi
  done
fi
if [ -z "${JDK21_HOME}" ] && [ -x /usr/libexec/java_home ]; then
  candidate="$(/usr/libexec/java_home -v 21 2>/dev/null || true)"
  if is_jdk21 "${candidate}"; then JDK21_HOME="${candidate}"; fi
fi

if [ -z "${JDK21_HOME}" ]; then
  echo "ERROR: Could not find a JDK 21 installation (required to run the tests with MockBukkit 4)." >&2
  echo "       Install one (e.g. 'sdk install java 21.0.7-amzn') or set JAVA_HOME to a JDK 21." >&2
  exit 1
fi

echo "Using JDK 21 toolchain: ${JDK21_HOME}"

mkdir -p ~/.m2
cat > ~/.m2/toolchains.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<toolchains>
  <toolchain>
    <type>jdk</type>
    <provides>
      <version>21</version>
      <vendor>any</vendor>
    </provides>
    <configuration>
      <jdkHome>${JDK21_HOME}</jdkHome>
    </configuration>
  </toolchain>
</toolchains>
EOF

"${SCRIPT_DIR}/install-dynmap-api.sh"
"${SCRIPT_DIR}/install-blockprot-api.sh"
