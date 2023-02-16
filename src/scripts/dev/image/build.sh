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

build() {
    VERSION="`cat .version`-dev"
    DOCKERFILE=`echo "./Dockerfile."$1`
    IMAGE_NAME="`cat .image_name`"
    IMAGE="$IMAGE_NAME:$1-$2-$VERSION"

    if [ ! -f "$DOCKERFILE" ]; then
        echo "Dockerfile '$DOCKERFILE' not found"
        exit 1
    fi

    echo "Building $IMAGE from $DOCKERFILE"

    docker build --no-cache \
                 --build-arg NODE_VERSION="$2.x" \
                 -t $IMAGE \
                 -f $DOCKERFILE \
                 .
}

if [ ! -z "$2" ]; then
    build $1 $2
else
    build $1 14
    build $1 16
    build $1 18
fi

# End