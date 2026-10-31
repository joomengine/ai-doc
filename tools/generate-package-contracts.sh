#!/usr/bin/env bash
set -euo pipefail
TOOLS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$TOOLS_DIR/lib/common.sh"
if [[ ${1:-} == --help ]]; then
	printf '%s\n' 'Usage: bash tools/generate-package-contracts.sh JCB_SOURCE OUTPUT_DIRECTORY' 'Read a clean, pinned JCB Git checkout; generate package model-contracts.json,' 'reference/*.json and *.md, schemas/*.json. OUTPUT must not exist.' 'Requires PHP tokenizer and SimpleXML. No inspected PHP is executed.'
	exit 0
fi
[[ $# == 2 ]] || fail 'Expected JCB_SOURCE and new OUTPUT_DIRECTORY; use --help'
need php; need git
source_root=$(realpath -e -- "$1")
[[ ! -e $2 ]] || fail 'Output already exists; generate separately and review the diff'
destination=$(realpath -m -- "$2")
[[ -d $(dirname -- "$destination") ]] || fail 'Output parent directory must exist'
[[ -z $(git -C "$source_root" status --porcelain --untracked-files=no) ]] || fail 'JCB source has tracked changes'
commit=$(git -C "$source_root" rev-parse HEAD)
temporary=$(mktemp -d "$(dirname -- "$destination")/.package-contracts.XXXXXXXX")
trap 'rm -rf -- "$temporary"' EXIT
mkdir -p -- "$temporary/reference" "$temporary/schemas"
php "$TOOLS_DIR/php/package-contracts.php" "$source_root" "$temporary" "$commit"
cp "$TOOLS_DIR/../packages/schemas/dependencies.schema.json" "$temporary/schemas/dependencies.schema.json"
if [[ -f $source_root/LICENSE.txt ]]; then cp -- "$source_root/LICENSE.txt" "$temporary/reference/LICENSE.txt"; fi
mv -- "$temporary" "$destination"
printf 'Generated package contracts from %s in %s\n' "$commit" "$destination"
