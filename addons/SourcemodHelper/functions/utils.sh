#! /bin/bash
## vim: noet:sw=0:sts=0:ts=4

# downloads a file and validates its checksum
SourcemodHelper::downloadFile () {
	[[ $2 ]] || return
	local cachefile="$SM_FILECACHE_DIR/$2"
	[[ -e $cachefile ]] || {
		local tmp=$(mktemp)
		wget -O "$tmp" "$1" || return
		local sha="$(sha256sum "$tmp")"
		sha=${sha%% *}
		[[ $sha == $2 ]] || {
			error <<< "Mismatched checksum for file $1"
			return 1
		}
		mv "$tmp" "$cachefile"
	}
	echo "$cachefile"
}
