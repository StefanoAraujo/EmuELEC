# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019 Trond Haugland (trondah@gmail.com)

PKG_NAME="mame"
PKG_VERSION="1961f6c1453370ddc493161ef8893dff8c4d5805"
PKG_SHA256="3d3d7c9006737d53ba5d23402c80f920b6947700195e6391327dca7e4c12d3a7"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/mame"
PKG_URL="https://github.com/libretro/mame/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib flac sqlite expat"
PKG_SECTION="escalade"
PKG_SHORTDESC="MAME - Multiple Arcade Machine Emulator"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="-lto"

PTR64="0"
NOASM="0"

if [ "$ARCH" == "arm" ]; then
  NOASM="1"
elif [ "$ARCH" == "x86_64" ]; then
  PTR64="1"
fi

PKG_MAKE_OPTS_TARGET="VERBOSE=1 \
		      NOWERROR=1 \
		      OPENMP=1 \
		      RETRO=1 \
		      PTR64=$PTR64 \
		      NOASM=$NOASM \
		      CONFIG=libretro \
		      LIBRETRO_OS=unix \
		      LIBRETRO_CPU=$ARCH \
		      PLATFORM=$ARCH \
		      TARGET=mame \
		      SUBTARGET=arcade \
		      OSD=retro \
		      USE_SYSTEM_LIB_EXPAT=1 \
		      USE_SYSTEM_LIB_ZLIB=1 \
		      USE_SYSTEM_LIB_FLAC=1 \
		      USE_SYSTEM_LIB_SQLITE3=1"

make_target() {
  unset ARCH
  unset DISTRO
  unset PROJECT
  make CC=$HOST_CC CXX=$HOST_CXX LD=$HOST_LD AR=$AR $MAKEFLAGS verbose=1 -C 3rdparty/genie/build/gmake.linux -f genie.make
  make CC=$HOST_CC CXX=$HOST_CXX $MAKEFLAGS -C src/devices/cpu/m68000
  make CC=$CC CXX=$CXX LD=$LD AR=$AR $PKG_MAKE_OPTS_TARGET $MAKEFLAGS 
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp *.so $INSTALL/usr/lib/libretro/mame_libretro.so
  mkdir -p $INSTALL/usr/config/retroarch/savefiles/mame/hi
  cp plugins/hiscore/hiscore.dat $INSTALL/usr/config/retroarch/savefiles/mame/hi
}
