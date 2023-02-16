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

scan() {
    VERSION="`cat .version`-dev"
    DOCKERFILE=`echo "./Dockerfile."$1`
    IMAGE_NAME="`cat .image_name`"
    IMAGE="$IMAGE_NAME:$1-$2-$VERSION"

    if [ ! -f "$DOCKERFILE" ]; then
        echo "Dockerfile '$DOCKERFILE' not found"
        exit 1
    fi

    docker scan $IMAGE -f "$DOCKERFILE" --accept-license 
}

if [ ! -z "$2" ]; then
    scan $1 $2
else
    scan $1 14
    scan $1 16
    scan $1 18
fi

# End