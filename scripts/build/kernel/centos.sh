# Copyright 2018 Ilya Lyubimov
# Licensed under the GPL v2. See COPYING in the root of this package

CT_DoKernelTupleValues() {
    CT_TARGET_KERNEL="linux"
    CT_TARGET_SYS=
}

do_kernel_get() {
    CT_Fetch CENTOS_KERNEL_HEADERS
}

do_kernel_extract() {
    CT_ExtractPatch CENTOS_KERNEL_HEADERS
}

do_kernel_headers() {
    CT_DoExecLog ALL cp -r -P "${CT_SRC_DIR}/centos-kernel-headers/usr/include/" "${CT_SYSROOT_DIR}/usr/"
}
