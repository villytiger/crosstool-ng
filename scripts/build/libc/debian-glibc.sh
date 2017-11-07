# Copyright 2015 Ilya Lyubimov
# Licensed under the GPL v2. See COPYING in the root of this package

CT_DEBIAN_LIBC_BASENAME=
CT_DEBIAN_LIBC_DEV_BASENAME=
CT_DEBIAN_LIBC_MIRROR=

do_extract_deb_file() {
    local basename="$1"
    local filename="${basename}.deb"

    if [ ! -e "${CT_TARBALLS_DIR}/${filename}" ]; then
        CT_DoLog WARN "'${basename}' not found in '${CT_TARBALLS_DIR}'"
        return 1
    fi

    if [ -e "${CT_SRC_DIR}/.${basename}.extracted" ]; then
        CT_DoLog DEBUG "Already extracted '${basename}'"
        return 0
    fi

    if [ -e "${CT_SRC_DIR}/.${basename}.extracting" ]; then
        CT_DoLog ERROR "The '${basename}' sources were partially extracted."
        CT_DoLog ERROR "Please remove first:"
        CT_DoLog ERROR " - the source dir for '${basename}', in '${CT_SRC_DIR}'"
        CT_DoLog ERROR " - the file '${CT_SRC_DIR}/.${basename}.extracting'"
        CT_Abort "I'll stop now to avoid any carnage..."
    fi

    CT_DoExecLog DEBUG touch "${CT_SRC_DIR}/.${basename}.extracting"
    CT_Pushd "${CT_SRC_DIR}"

    CT_DoLog EXTRA "Extracting '${basename}'"
    CT_DoExecLog FILE mkdir -p "${basename}"

    CT_Pushd "${basename}"

    CT_DoExecLog FILE ar xv "${CT_TARBALLS_DIR}/${filename}"
    CT_DoExecLog FILE tar xf data.tar.gz

    CT_Popd
    CT_Popd
    CT_DoExecLog DEBUG rm -f "${CT_SRC_DIR}/.${basename}.extracting"
}

do_libc_get() {
    local arch

    CT_DoStep INFO "Fetching Debian glibc binaries"

    case "${CT_ARCH}:${CT_ARCH_BITNESS}" in
        x86:32) arch=i386;;
        x86:64) arch=amd64;;
        *) CT_Abort "Unsupported arch and bitness: ${CT_ARCH}:${CT_ARCH_BITNESS}"
    esac

    case "${CT_DEBIAN_GLIBC_VERSION}:${arch}" in
        debian-2.3.6:i386)
            CT_DEBIAN_LIBC_BASENAME=libc6_2.3.6.ds1-13etch10+b1_i386
            CT_DEBIAN_LIBC_DEV_BASENAME=libc6-dev_2.3.6.ds1-13etch10+b1_i386
            ;;
        debian-2.3.6:amd64)
            CT_DEBIAN_LIBC_BASENAME=libc6_2.3.6.ds1-13etch10_amd64
            CT_DEBIAN_LIBC_DEV_BASENAME=libc6-dev_2.3.6.ds1-13etch10_amd64
            ;;
        debian-2.8:i386)
            CT_DEBIAN_LIBC_BASENAME=libc6_2.8~20080505-0ubuntu9_i386
            CT_DEBIAN_LIBC_DEV_BASENAME=libc6-dev_2.8~20080505-0ubuntu9_i386.deb
            ;;
        ubuntu-2.8:amd64)
            CT_DEBIAN_LIBC_BASENAME=libc6_2.8~20080505-0ubuntu9_amd64
            CT_DEBIAN_LIBC_DEV_BASENAME=libc6-dev_2.8~20080505-0ubuntu9_amd64
            ;;
    esac

    case "${CT_DEBIAN_GLIBC_VERSION}" in
        debian-*) CT_DEBIAN_LIBC_MIRROR="http://archive.kernel.org/debian-archive/debian/pool/main/g/glibc";;
        ubuntu-*) CT_DEBIAN_LIBC_MIRROR="http://archive.kernel.org/ubuntu-archive/ubuntu/pool/main/g/glibc/";;
    esac

    CT_GetFile "${CT_DEBIAN_LIBC_BASENAME}.deb" "${CT_DEBIAN_LIBC_MIRROR}"
    CT_GetFile "${CT_DEBIAN_LIBC_DEV_BASENAME}.deb" "${CT_DEBIAN_LIBC_MIRROR}"

    CT_EndStep
}

do_libc_extract() {
    do_extract_deb_file "${CT_DEBIAN_LIBC_BASENAME}"
    do_extract_deb_file "${CT_DEBIAN_LIBC_DEV_BASENAME}"
}

do_libc_check_config() {
    :
}

do_libc_start_files() {
    CT_DoStep INFO "Installing Debian libc binaries"

    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/${CT_DEBIAN_LIBC_BASENAME}/lib/" "${CT_SYSROOT_DIR}/"
    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/${CT_DEBIAN_LIBC_BASENAME}/usr/lib/" "${CT_SYSROOT_DIR}/usr/"
    
    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/${CT_DEBIAN_LIBC_DEV_BASENAME}/usr/include/" "${CT_SYSROOT_DIR}/usr/"
    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/${CT_DEBIAN_LIBC_DEV_BASENAME}/usr/lib/" "${CT_SYSROOT_DIR}/usr/"
    
    CT_DoExecLog ALL find "${CT_SYSROOT_DIR}" -lname '/*' -exec sh -c 'ln -snf "$0$(readlink "$1")" "$1"' "${CT_SYSROOT_DIR}" {} \;

    CT_EndStep
}

do_libc() {
    :
}

do_libc_post_cc() {
    :
}
