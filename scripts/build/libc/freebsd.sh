# Copyright 2015 Ilya Lyubimov
# Licensed under the GPL v2. See COPYING in the root of this package

do_libc_get() {
    local arch=

    CT_DoStep INFO "Fetching FreeBSD base binaries"

    case "${CT_ARCH}:${CT_ARCH_BITNESS}" in
        x86:32)      arch=i386;;
        x86:64)      arch=amd64;;
        *)           arch="${CT_ARCH}";;
    esac

    CT_GetFile "base.txz" "http://ftp.freebsd.org/pub/FreeBSD/releases/${arch}/${CT_FREEBSD_VERSION}-RELEASE"

    CT_EndStep
}

do_libc_extract() {
    CT_Extract "base"
}

do_libc_check_config() {
    :
}

do_libc_start_files() {
    CT_DoStep INFO "Installing FreeBSD base binaries"

    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/base/lib/" "${CT_SYSROOT_DIR}/"
    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/base/usr/lib/" "${CT_SYSROOT_DIR}/usr/"
    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/base/usr/include/" "${CT_SYSROOT_DIR}/usr/"
    CT_DoExecLog ALL find "${CT_SYSROOT_DIR}" -lname '/*' -exec sh -c 'ln -snf "$0$(readlink "$1")" "$1"' "${CT_SYSROOT_DIR}" {} \;

    CT_EndStep
}

do_libc() {
    :
}

do_libc_post_cc() {
    :
}
