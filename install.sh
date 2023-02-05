#!/usr/bin/env bash
if [ -n "$(flatpak list | grep -q org.gnome.Builder.Devel)" ]; then
	echo "Flatpak org.gnome.Builder.Devel missing"
	exit 1
fi
sudo dnf install -y swift-lang \
	git vala meson \
	gcc libgee-devel \
	json-glib-devel gtk4-devel \
	gtksourceview5-devel \
	libadwaita-devel \
	libpeas-devel \
	template-glib-devel \
	g++ libsoup3-devel
swift build -c release --static-swift-stdlib
git clone https://github.com/JCWasmx86/GNOME-Builder-Plugins
cd GNOME-Builder-Plugins || exit 1
meson -Dplugin_cabal=disabled \
	-Dplugin_clangd=disabled \
	-Dplugin_gitgui=disabled \
	-Dplugin_hadolint=disabled \
	-Dplugin_hls=disabled \
	-Dplugin_icon_installer=disabled \
	-Dplugin_markdown=disabled \
	-Dplugin_muon=disabled \
	-Dplugin_pylint=disabled \
	-Dplugin_shfmt=disabled \
	-Dplugin_sqls=disabled \
	-Dplugin_stack=disabled \
	-Dplugin_swift=disabled \
	-Dplugin_swift_format=disabled \
	-Dplugin_swift_lint=disabled \
	-Dplugin_swift_templates=disabled \
	-Dplugin_sourcekit=disabled \
	-Dplugin_texlab=disabled \
	-Dplugin_xmlfmt=disabled \
	-Dplugin_xmlfmt=disabled \
	-Duse_swift_meson_lsp=true \
	_build
cd _build || exit 1
ninja install
cd ../..
rm -rf GNOME-Builder-Plugins
sudo cp .build/release/Swift-MesonLSP /usr/local/bin/