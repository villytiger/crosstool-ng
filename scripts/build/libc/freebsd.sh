# Copyright 2015 Ilya Lyubimov
# Licensed under the GPL v2. See COPYING in the root of this package

do_libc_get() {
    CT_Fetch FREEBSD
}

do_libc_extract() {
    CT_ExtractPatch FREEBSD


    CT_Pushd "${CT_SRC_DIR}/freebsd"
    
    for link in $(find -lname '/*' -printf '%P\n'); do
	local relroot=$(dirname "${link}" | sed 's|[^/]\+|..|g')
	CT_DoExecLog ALL ln -snf "${relroot}$(readlink "${link}")" "${link}"
    done

    CT_Popd
}

do_libc_check_config() {
    :
}

do_libc_start_files() {
    CT_DoStep INFO "Installing FreeBSD base binaries"

    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/freebsd/lib/" "${CT_SYSROOT_DIR}/"
    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/freebsd/usr/lib/" "${CT_SYSROOT_DIR}/usr/"
    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/freebsd/usr/include/" "${CT_SYSROOT_DIR}/usr/"

    CT_EndStep
}

do_libc() {
    :
}

do_libc_post_cc() {
    :
}
