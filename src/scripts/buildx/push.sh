#!/bin/sh

#
# gp-node-devenv
# Copyright (c) 2023, Greg PFISTER. MIT License.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <UBUNUT_VERSION> <NODE_VERSION>"
    exit 1
fi

if [ -z "$2" ]; then
    echo "Usage: $0 <UBUNUT_VERSION> <NODE_VERSION>"
    exit 1
fi

VERSION=$(cat .version)
VERSION_MAJOR=$(echo $VERSION | sed 's/\([0-9]*\).\([0-9]*\).\([0-9]*\)$/\1/')
VERSION_MINOR=$(echo $VERSION | sed 's/\([0-9]*\).\([0-9]*\).\([0-9]*\)$/\1.\2/')
DOCKERFILE=$(echo "./Dockerfile."$1)
IMAGE_NAME=$(cat .image_name)
IMAGE="$IMAGE_NAME:$1-$2"
IMAGE_VERSION="$IMAGE_NAME:$1-$2-$VERSION"
IMAGE_VERSION_MAJOR="$IMAGE_NAME:$1-$2-$VERSION_MAJOR"
IMAGE_VERSION_MINOR="$IMAGE_NAME:$1-$2-$VERSION_MINOR"

if [ ! -f "$DOCKERFILE" ]; then
    echo "Dockerfile '$DOCKERFILE' not found"
    exit 1
fi

docker buildx build --push \
                    --platform linux/arm64,linux/amd64 \
                    --build-arg NODE_VERSION="$2" \
                    -t $IMAGE \
                    -t $IMAGE_VERSION \
                    -t $IMAGE_VERSION_MAJOR \
                    -t $IMAGE_VERSION_MINOR \
                    -f "$DOCKERFILE" .
docker buildx build --push \
                    --platform linux/arm64 \
                    --build-arg NODE_VERSION="$2" \
                    -t $IMAGE-arm64 \
                    -t $IMAGE_VERSION-arm64 \
                    -t $IMAGE_VERSION_MAJOR-arm64 \
                    -t $IMAGE_VERSION_MINOR-arm64 \
                    -f "$DOCKERFILE" .
docker buildx build --push \
                    --platform linux/amd64 \
                    --build-arg NODE_VERSION="$2" \
                    -t $IMAGE-amd64 \
                    -t $IMAGE_VERSION-amd64 \
                    -t $IMAGE_VERSION_MAJOR-amd64 \
                    -t $IMAGE_VERSION_MINOR-amd64 \
                    -f "$DOCKERFILE" .

# End