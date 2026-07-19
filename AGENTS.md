# Build Setup

## Prerequisites

- JDK 25 (Homebrew: `brew install openjdk@25`)
- Maven 3.9+ (Homebrew: `brew install maven`)
- `~/.m2/toolchains.xml` must exist with JDK 25 configured:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<toolchains>
  <toolchain>
    <type>jdk</type>
    <provides>
      <version>25</version>
      <vendor>any</vendor>
    </provides>
    <configuration>
      <jdkHome>/opt/homebrew/opt/openjdk@25/libexec/openjdk.jdk/Contents/Home</jdkHome>
    </configuration>
  </toolchain>
</toolchains>
```

## Build

```bash
export JAVA_HOME=/opt/homebrew/opt/openjdk@25
export PATH=$JAVA_HOME/bin:$PATH

# Install BlockProt API (optional runtime dependency)
bash scripts/install-blockprot-api.sh

# Compile
mvn compile -pl core -am

# Run tests (all 137 should pass)
mvn test -pl core -am

# Package (core only, without legacy modules)
mvn clean package -pl core,dist -am -DskipTests
```

The packaged JAR is at `target/Shop-1.11.jar`.

## Quick test (single test class)

```bash
mvn test -pl core -am -Dtest=ShopSaveTest
mvn test -pl core -am -Dtest=ShopSaveTest#saveShops_yamlContainsExpectedStructure_forMultipleShops
```

## Notes

- Legacy version-specific modules (`v1_14_R1` through `v1_20_R4`) are excluded from the build. They target pre-26.x Minecraft versions and require Spigot BuildTools artifacts. The core module's unversioned `Display.java` handles Paper 26.x natively via direct Mojang-mapped NMS imports.
- BlockProt 1.2.6 is not published to any public Maven repo; the install script downloads it from GitHub Releases.
