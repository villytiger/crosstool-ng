# Copyright 2016 Ilya Lyubimov
# Licensed under the GPL v2. See COPYING in the root of this package

do_libc_get() {
    CT_Fetch CENTOS_GLIBC
    CT_Fetch CENTOS_GLIBC_HEADERS
    CT_Fetch CENTOS_GLIBC_DEVEL
}

do_libc_extract() {
    CT_ExtractPatch CENTOS_GLIBC
    CT_ExtractPatch CENTOS_GLIBC_HEADERS
    CT_ExtractPatch CENTOS_GLIBC_DEVEL
}

do_libc_check_config() {
    :
}

do_libc_start_files() {
    local lib_dir

    CT_DoStep INFO "Installing CentOS libc binaries"

    case "${CT_ARCH}:${CT_ARCH_BITNESS}" in
        x86:32) lib_dir=lib;;
        x86:64) lib_dir=lib64;;
        *) CT_Abort "Unsupported arch and bitness: ${CT_ARCH}:${CT_ARCH_BITNESS}"
    esac

    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/centos-glibc/${lib_dir}/" "${CT_SYSROOT_DIR}/"
    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/centos-glibc/usr/${lib_dir}/" "${CT_SYSROOT_DIR}/usr/"
    
    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/centos-glibc-headers/usr/include/" "${CT_SYSROOT_DIR}/usr/"

    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/centos-glibc-devel/usr/include/" "${CT_SYSROOT_DIR}/usr/"
    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/centos-glibc-devel/usr/${lib_dir}/" "${CT_SYSROOT_DIR}/usr/"

    CT_EndStep
}

do_libc() {
    :
}

do_libc_post_cc() {
    :
}
