typeset -U path PATH

for dir in \
	"$HOME/bin" \
	"$HOME/.local/bin" \
	"$HOME/.npm-global/bin"; do
	[[ -d "$dir" ]] && path=("$dir" $path)
done
unset dir

if [[ "$OSTYPE" == darwin* ]]; then
	if [[ -d "$HOME/Library/Android/sdk" ]]; then
		export ANDROID_HOME="$HOME/Library/Android/sdk"
		for dir in \
			"$ANDROID_HOME/emulator" \
			"$ANDROID_HOME/platform-tools" \
			"$ANDROID_HOME/tools" \
			"$ANDROID_HOME/tools/bin"; do
			[[ -d "$dir" ]] && path+=("$dir")
		done
		unset dir
	fi

	[[ -d /Library/TeX/texbin ]] && path=(/Library/TeX/texbin $path)

	if [[ -d "$HOME/Desktop/3rd_party/vcpkg" ]]; then
		export VCPKG_ROOT="$HOME/Desktop/3rd_party/vcpkg"
		path=("$VCPKG_ROOT" $path)
	fi
fi

export PATH
