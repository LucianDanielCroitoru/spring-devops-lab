#!/bin/sh

echo "Running Maven tests (./mvnw test) before commit..."

STAGED_JAVA_OR_POM=$(git diff --cached --name-only --diff-filter=ACM | grep -E '(\.java$)|(pom\.xml)$' || true)

if [ -z "$STAGED_JAVA_OR_POM" ]; then
  echo "No Java or pom.xml changes staged. Skipping tests."
  exit 0
fi

./mvnw test
RESULT=$?

if [ $RESULT -ne 0 ]; then
  echo "Tests failed. Commit aborted."
  exit 1
fi

echo "Tests passed. Proceeding with commit."
exit 0
