# This is code from Gemini with slight modifications 🙂

# This script attempts to find the Lombok JAR file by searching the
# local Gradle cache directory. It does NOT require any modification to
# your project's build.gradle file.

# Check for a specific version number from the command line, or default to a wildcard
if [[ -n "$1" ]]; then
    VERSION="$1"
    echo "Searching for Lombok version: $VERSION"
else
    VERSION="*"
    echo "Searching for any Lombok version..."
fi

GRADLE_CACHE_DIR="$HOME/.gradle/caches/modules-2/files-2.1"

# Check if the Gradle cache directory exists
if [[ ! -d "$GRADLE_CACHE_DIR" ]]; then
    echo "Error: Gradle cache directory not found at $GRADLE_CACHE_DIR"
    echo "Ensure you have run a Gradle build at least once."
    exit 1
fi

echo "Searching for 'org.projectlombok:lombok' in the Gradle cache..."

# Use 'find' to locate the JAR file.
# The path pattern is consistent for Maven/Gradle dependencies.
# The `\(` and `\)` are for grouping, and `\|` is for OR.
# This finds a path ending in either 'lombok.jar' or 'lombok-<version>.jar'
LOMBOK_JAR_PATH=$(find "$GRADLE_CACHE_DIR" -type f \
    -path "*/org.projectlombok/lombok/$VERSION/*" \
    -name "lombok-*.jar" \
    -not -name "*-sources.jar")

# Check if a path was found
if [[ -z "$LOMBOK_JAR_PATH" ]]; then
    echo "Error: Lombok JAR file not found in the cache."
    echo "Check if the dependency is correctly configured in your project."
    exit 1
fi

echo
echo "Successfully located Lombok JAR."
echo "Select path:"
LOMBOK_JAR=$(echo "$LOMBOK_JAR_PATH" | fzf)

HL=$(tput setaf 4)$(tput bold)
RESET=$(tput sgr0)
echo "${HL}${LOMBOK_JAR}${RESET}"

echo "export JAVA_TOOL_OPTIONS=\"-javaagent:${LOMBOK_JAR}\"" > .envrc
echo
echo "Wrote selected Lombok JAR to .envrc's JAVA_TOOL_OPTIONS."
