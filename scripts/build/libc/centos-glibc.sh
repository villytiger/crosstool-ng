# Copyright 2016 Ilya Lyubimov
# Licensed under the GPL v2. See COPYING in the root of this package

CT_CENTOS_LIBC_BASENAME=
CT_CENTOS_LIBC_DEV_BASENAME=

do_extract_rpm_file() {
    local basename="$1"
    local filename="${basename}.rpm"

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

    rpm2cpio "${CT_TARBALLS_DIR}/${filename}" | xz -d | cpio -id

    CT_Popd
    CT_Popd
    CT_DoExecLog DEBUG rm -f "${CT_SRC_DIR}/.${basename}.extracting"
}

do_libc_get() {
    local arch
    local arch_dir

    CT_DoStep INFO "Fetching CentOS glibc binaries"

    case "${CT_ARCH}:${CT_ARCH_BITNESS}" in
        x86:32)
            arch=i686
            arch_dir=i386
            ;;
        x86:64)
            arch=x86_64
            arch_dir=x86_64
            ;;
        *) CT_Abort "Unsupported arch and bitness: ${CT_ARCH}:${CT_ARCH_BITNESS}"
    esac

    case "${CT_CENTOS_GLIBC_VERSION}:${arch}" in
        2.12:i686)
            CT_CENTOS_LIBC_BASENAME=glibc-2.12-1.7.el6.i686
            CT_CENTOS_LIBC_HEADERS_BASENAME=glibc-headers-2.12-1.7.el6.i686
            CT_CENTOS_LIBC_DEVEL_BASENAME=glibc-devel-2.12-1.7.el6.i686
            ;;
        2.12:x86_64)
            CT_CENTOS_LIBC_BASENAME=glibc-2.12-1.7.el6.x86_64
            CT_CENTOS_LIBC_HEADERS_BASENAME=glibc-headers-2.12-1.7.el6.x86_64
            CT_CENTOS_LIBC_DEVEL_BASENAME=glibc-devel-2.12-1.7.el6.x86_64
            ;;
    esac

    CT_GetFile "${CT_CENTOS_LIBC_BASENAME}.rpm" "http://vault.centos.org/6.0/os/${arch_dir}/Packages"
    CT_GetFile "${CT_CENTOS_LIBC_HEADERS_BASENAME}.rpm" "http://vault.centos.org/6.0/os/${arch_dir}/Packages"
    CT_GetFile "${CT_CENTOS_LIBC_DEVEL_BASENAME}.rpm" "http://vault.centos.org/6.0/os/${arch_dir}/Packages"

    CT_EndStep
}

do_libc_extract() {
    do_extract_rpm_file "${CT_CENTOS_LIBC_BASENAME}"
    do_extract_rpm_file "${CT_CENTOS_LIBC_HEADERS_BASENAME}"
    do_extract_rpm_file "${CT_CENTOS_LIBC_DEVEL_BASENAME}"
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

    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/${CT_CENTOS_LIBC_BASENAME}/${lib_dir}/" "${CT_SYSROOT_DIR}/"
    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/${CT_CENTOS_LIBC_BASENAME}/usr/${lib_dir}/" "${CT_SYSROOT_DIR}/usr/"
    
    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/${CT_CENTOS_LIBC_HEADERS_BASENAME}/usr/include/" "${CT_SYSROOT_DIR}/usr/"

    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/${CT_CENTOS_LIBC_DEVEL_BASENAME}/usr/include/" "${CT_SYSROOT_DIR}/usr/"
    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/${CT_CENTOS_LIBC_DEVEL_BASENAME}/usr/${lib_dir}/" "${CT_SYSROOT_DIR}/usr/"

    CT_EndStep
}

do_libc() {
    :
}

do_libc_post_cc() {
    :
}
