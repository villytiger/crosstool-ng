# This file declares functions to install the kernel headers for freebsd
# Copyright 2015 Ilya Lyubimov
# Licensed under the GPL v2. See COPYING in the root of this package

CT_DoKernelTupleValues() {
    CT_TARGET_KERNEL="freebsd${CT_FREEBSD_VERSION%-*}"
    CT_TARGET_SYS=
}

do_kernel_get() {
    :
}

do_kernel_extract() {
    :
}

do_kernel_headers() {
   :
}
