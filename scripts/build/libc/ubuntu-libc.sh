# Copyright 2018 Ilya Lyubimov
# Licensed under the GPL v2. See COPYING in the root of this package

do_libc_get() {
    CT_Fetch UBUNTU_LIBC
    CT_Fetch UBUNTU_LIBC_DEV
}

do_libc_extract() {
    CT_ExtractPatch UBUNTU_LIBC
    CT_ExtractPatch UBUNTU_LIBC_DEV
}

do_libc_check_config() {
    :
}

do_libc_start_files() {
    CT_DoStep INFO "Installing Ubuntu libc binaries"

    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/ubuntu-libc/lib/" "${CT_SYSROOT_DIR}/"
    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/ubuntu-libc/usr/lib/" "${CT_SYSROOT_DIR}/usr/"
    
    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/ubuntu-libc-dev/usr/include/" "${CT_SYSROOT_DIR}/usr/"
    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/ubuntu-libc-dev/usr/lib/" "${CT_SYSROOT_DIR}/usr/"

    CT_Pushd "${CT_SRC_DIR}/ubuntu-libc-dev"
    
    for link in $(find usr/lib -lname '/*'); do
        CT_DoExecLog ALL ln -snf "${CT_SYSROOT_DIR}$(readlink "$link")" "${CT_SYSROOT_DIR}/$link"
    done

    CT_Popd

    CT_EndStep
}

do_libc() {
    :
}

do_libc_post_cc() {
    :
}
