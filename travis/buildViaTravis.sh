#!/bin/bash
# This script will build the project.

# Stop at the first error
set -e

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
  echo -e "Build Pull Request #$TRAVIS_PULL_REQUEST => Branch [$TRAVIS_BRANCH]"
  ./gradlew --no-daemon build javadoc asciidoc coveralls dockerBuildAllImages
  # Re-run genie-web integration tests with MySQL...
  INTEGRATION_TEST_DB=mysql ./gradlew --no-daemon genie-web:integrationTests
  # ... and PostgreSQL
  INTEGRATION_TEST_DB=postgresql ./gradlew --no-daemon genie-web:integrationTests
elif [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_BRANCH" == "develop" ]; then
  echo -e 'Build Develop without publishing artifacts'
  ./gradlew build --no-daemon
elif [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_TAG" == "" ]; then
  echo -e 'Build Branch with Snapshot => Branch ['$TRAVIS_BRANCH']'
  ./gradlew --no-daemon -Prelease.travisBranch=$TRAVIS_BRANCH -Prelease.travisci=true -PbintrayUser="${bintrayUser}" -PbintrayKey="${bintrayKey}" -PsonatypeUsername="${sonatypeUsername}" -PsonatypePassword="${sonatypePassword}" snapshot coveralls publishGhPages dockerPush
elif [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_TAG" != "" ]; then
  echo -e 'Build Branch for Release => Branch ['$TRAVIS_BRANCH']  Tag ['$TRAVIS_TAG']'
  case "$TRAVIS_TAG" in
  *-rc\.*)
    ./gradlew --no-daemon -Prelease.travisci=true -Prelease.useLastTag=true -PbintrayUser="${bintrayUser}" -PbintrayKey="${bintrayKey}" -PsonatypeUsername="${sonatypeUsername}" -PsonatypePassword="${sonatypePassword}" candidate coveralls publishGhPages dockerPush
    ;;
  *)
    ./gradlew --no-daemon -Prelease.travisci=true -Prelease.useLastTag=true -PbintrayUser="${bintrayUser}" -PbintrayKey="${bintrayKey}" -PsonatypeUsername="${sonatypeUsername}" -PsonatypePassword="${sonatypePassword}" final coveralls publishGhPages dockerPush
    ;;
  esac
else
  echo -e 'WARN: Should not be here => Branch ['$TRAVIS_BRANCH']  Tag ['$TRAVIS_TAG']  Pull Request ['$TRAVIS_PULL_REQUEST']'
  ./gradlew --no-daemon build coveralls
fi
