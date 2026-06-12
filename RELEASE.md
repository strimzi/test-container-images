# Release Process

This document describes the end-to-end release process for the Strimzi Test Container Images and the [Strimzi Test Container](https://github.com/strimzi/test-container) Java library.
Both repositories are tightly coupled: this repo builds the container images, and `strimzi/test-container` is the Java library that pulls and runs them.
The release always starts here.

## Overview

Both projects use a **branch-based release strategy** with `release-*` branches.
The process goes: publish RC images, validate them via the test-container test suite, then publish GA images and the Maven artifact.

## Prerequisites

- Write access to both `strimzi/test-container-images` and `strimzi/test-container`
- A `release-*` branch in each repository (e.g., `release-0.116.x`)
- Repository secrets configured:
  - **test-container-images:** `QUAY_USER`, `QUAY_PASS` (Quay.io registry)
  - **test-container:** `GPG_PASSPHRASE`, `GPG_SIGNING_KEY`, `CENTRAL_USERNAME`, `CENTRAL_PASSWORD` (Maven Central)

## Version Files (test-container-images)

These files control what gets built into the container images:

| File                       | Purpose                                  | Example                   |
|----------------------------|------------------------------------------|---------------------------|
| `supported_kafka.versions` | Kafka versions to include (one per line) | `4.2.0`, `4.2.1`, `4.3.0` |
| `supported_scala.version`  | Scala version for Kafka binaries         | `2.13`                    |
| `test-connectors.version`  | Strimzi test connectors plugin version   | `0.1.0`                   |

## Bundled Test Connectors

The container images bundle connector plugins from [strimzi/test-connectors](https://github.com/strimzi/test-connectors) (e.g., the Fault Injection Source Connector).
The version is pinned in `test-connectors.version` and the build downloads the distribution ZIP from Maven Central during the prepare step (`images/download_connectors.sh`).

The test-connectors project has its own independent release process.
If you need a newer version of the connectors in the images, update `test-connectors.version` to the desired release version **before** starting the release process below.
Make sure the version you reference is already published on [Maven Central](https://central.sonatype.com/namespace/io.strimzi.strimzi-test-connectors).

## Step-by-step Release

### 1. Create release branches (if they do not exist)

Create a release branch in **both** repositories:

```bash
# test-container-images
cd test-container-images
git checkout main
git pull upstream main  # upstream = git@github.com:strimzi/test-container-images.git
git checkout -b release-0.116.x
git push upstream release-0.116.x

# test-container
cd ../test-container
git checkout main
git pull upstream main  # upstream = git@github.com:strimzi/test-container.git
git checkout -b release-0.116.x
git push upstream release-0.116.x
```

### 2. Prepare the release branches

**In test-container-images:** make sure `supported_kafka.versions`, `supported_scala.version`, and `test-connectors.version` on the release branch reflect the Kafka versions you want to ship.

**In test-container:** update `pom.xml` to the correct GA version and make sure `src/main/resources/kafka_versions.json` lists the Kafka versions you intend to support. Then push the changes to the release branch:

```bash
cd test-container
git checkout release-0.116.x

# Update the version in pom.xml from SNAPSHOT to GA
mvn versions:set -DnewVersion=0.116.0 -DgenerateBackupPoms=false

# Update kafka_versions.json if needed (e.g., add/remove Kafka versions)

git add pom.xml src/main/resources/kafka_versions.json
git commit -m "Set version to 0.116.0"
git push upstream release-0.116.x
```

### 3. Wait for CI builds to pass

Before triggering the release, make sure the **Build** workflow passes on the `release-*` branch in **both** repositories:

- **test-container-images:** check [Actions](https://github.com/strimzi/test-container-images/actions/workflows/build.yml) for the `release-*` branch
- **test-container:** check [Actions](https://github.com/strimzi/test-container/actions/workflows/build.yml) for the `release-*` branch

Do not proceed until both builds are green.

If a build is red, the failure needs to be fixed before continuing. 
Always fix the issue on `main` first by creating a PR against `main`, then cherry-pick the fix commit into the release branch:

```bash
git checkout release-0.116.x
git cherry-pick <commit-hash>
git push upstream release-0.116.x
```

Wait for the release branch build to go green after the cherry-pick before proceeding.

### 4. Release RC images from test-container-images

Trigger the **Release** workflow on the `release-*` branch with an RC version:

**GitHub UI:**
1. Go to **Actions** > **Release** > **Run workflow**
2. Select the release branch (e.g., `release-0.116.x`)
3. Enter the release version: `0.116.0-rc1`
4. Click **Run workflow**

Similarly, you can do it via **GitHub CLI:**
```bash
gh workflow run release.yml \
  --ref release-0.116.x \
  -f releaseVersion=0.116.0-rc1
```

**Verify:** confirm images appear on Quay.io, e.g.:
```
quay.io/strimzi-test-container/test-container:0.116.0-rc1-kafka-4.2.0
quay.io/strimzi-test-container/test-container:0.116.0-rc1-kafka-4.2.1
quay.io/strimzi-test-container/test-container:0.116.0-rc1-kafka-4.3.0
```

### 5. Validate RC images in test-container

Trigger the **Release** workflow in `strimzi/test-container` with the RC version.
The release workflow sets the version in `pom.xml` and updates `kafka_versions.json` to use the RC-tagged images automatically, then runs the full build including integration tests:

**GitHub UI:**
1. Go to **Actions** > **Release** > **Run workflow**
2. Select the release branch (e.g., `release-0.116.x`)
3. Enter the release version: `0.116.0-rc1`
4. Click **Run workflow**

Similarly, you can do it via **GitHub CLI:**
```bash
gh workflow run release.yml \
  --repo strimzi/test-container \
  --ref release-0.116.x \
  -f releaseVersion=0.116.0-rc1
```

> **Note:** The regular CI build on `release-*` branches skips integration tests (because GA-tagged images may not exist yet).
> Running the release workflow with an RC version is the way to validate the images end-to-end.

Once the RC release workflow passes, manually publish the artifacts to Maven Central:

1. Go to [Maven Central Publishing](https://central.sonatype.com/publishing)
2. Find the deployment in **Validated** state
3. Click **Publish**
4. Wait ~30 minutes for the artifacts to propagate
5. Verify the RC artifact is available on [Maven Central](https://central.sonatype.com/artifact/io.strimzi/strimzi-test-container)

Then create a tag and a GitHub release for the RC in both repositories:

```bash
# test-container-images
git checkout release-0.116.x
git tag 0.116.0-rc1
git push upstream 0.116.0-rc1

# test-container
cd ../test-container
git checkout release-0.116.x
git tag 0.116.0-rc1
git push upstream 0.116.0-rc1
```

Create GitHub releases from these tags in both repositories, marking them as pre-releases.

Then announce the RC:
- Send an announcement to the **cncf-strimzi-users** mailing list
- Post in the **#strimzi** Slack channel

### 6. Release GA images from test-container-images

Once RC validation passes, trigger the **Release** workflow again with the GA version:

```bash
gh workflow run release.yml \
  --ref release-0.116.x \
  -f releaseVersion=0.116.0
```

**Verify:** confirm GA images appear on Quay.io, e.g.:
```
quay.io/strimzi-test-container/test-container:0.116.0-kafka-4.3.0
```

### 7. Release test-container GA

Trigger the **Release** workflow in `strimzi/test-container` with the GA version to publish the Maven artifact:

```bash
gh workflow run release.yml \
  --repo strimzi/test-container \
  --ref release-0.116.x \
  -f releaseVersion=0.116.0
```

Once the GA release workflow passes, manually publish the artifacts to Maven Central:

1. Go to [Maven Central Publishing](https://central.sonatype.com/publishing)
2. Find the deployment in **Validated** state
3. Click **Publish**
4. Wait ~30 minutes for the artifacts to propagate
5. Verify the GA artifact is available on [Maven Central](https://central.sonatype.com/artifact/io.strimzi/strimzi-test-container)

Then create a tag and a GitHub release for the GA in both repositories:
```bash
# test-container-images
git checkout release-0.116.x
git tag 0.116.0
git push upstream 0.116.0

# test-container
cd ../test-container
git checkout release-0.116.x
git tag 0.116.0
git push upstream 0.116.0
```

### 8. Post-release

- Verify the Maven artifact is available on [Maven Central](https://central.sonatype.com/artifact/io.strimzi/strimzi-test-container)
- Create GitHub releases in both repositories
- Bump the SNAPSHOT version on `main` in `strimzi/test-container` if needed