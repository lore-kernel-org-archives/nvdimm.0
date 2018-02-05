Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D910F2237A4C9
 for <linux-nvdimm@lists.01.org>; Mon,  5 Feb 2018 01:15:55 -0800 (PST)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 23F344A6FA
 for <linux-nvdimm@lists.01.org>; Mon,  5 Feb 2018 09:21:36 +0000 (UTC)
Received: from localhost (unknown [10.66.12.130])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 9B0595C25E
 for <linux-nvdimm@lists.01.org>; Mon,  5 Feb 2018 09:21:35 +0000 (UTC)
Date: Mon, 5 Feb 2018 17:21:33 +0800
From: Xiong Zhou <xzhou@redhat.com>
Subject: nvml/pmdk libvmmaloc segmentation fault when exit
Message-ID: <20180205092133.svny2wlqrb56t4vc@XZHOUW.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi,

This happens when testing nvml or pmdk libvmmalloc library:
+ dmesg
[12890.676033] traps: test_libvmmallo[15789] general protection ip:7f3f01481a31 sp:7ffd85f4b7a0 error:0 in libvmmalloc.so.1.0.0[7f3f0146d000+3e000]

gdb output:
Program received signal SIGSEGV, Segmentation fault.
0x00007ffff7bada31 in arena_purge () from /usr/local/lib64/libvmmalloc.so.1
(gdb) bt
#0  0x00007ffff7bada31 in arena_purge () from /usr/local/lib64/libvmmalloc.so.1
#1  0x00007ffff7badcca in arena_dalloc_bin_run () from /usr/local/lib64/libvmmalloc.so.1
#2  0x00007ffff7baf0e0 in je_vmem_je_arena_dalloc_bin_locked () from /usr/local/lib64/libvmmalloc.so.1
#3  0x00007ffff7bc6d31 in je_vmem_je_tcache_bin_flush_small () from /usr/local/lib64/libvmmalloc.so.1
#4  0x00007ffff7bc761e in je_vmem_je_tcache_destroy () from /usr/local/lib64/libvmmalloc.so.1
#5  0x00007ffff7bc7895 in je_vmem_je_tcache_thread_cleanup () from /usr/local/lib64/libvmmalloc.so.1
#6  0x00007ffff7b9dccc in jemalloc_destructor () from /usr/local/lib64/libvmmalloc.so.1
#7  0x00007ffff7deb18a in _dl_fini () at dl-fini.c:253
#8  0x00007ffff7805b19 in __run_exit_handlers (status=0, listp=0x7ffff7b926c8 <__exit_funcs>, run_list_atexit=run_list_atexit@entry=true) at exit.c:77
#9  0x00007ffff7805b67 in __GI_exit (status=<optimized out>) at exit.c:99
#10 0x00007ffff77ee38c in __libc_start_main (main=0x40072d <main>, argc=1, ubp_av=0x7fffffffe388, init=<optimized out>, fini=<optimized out>,
    rtld_fini=<optimized out>, stack_end=0x7fffffffe378) at ../csu/libc-start.c:308
#11 0x0000000000400669 in _start ()

I did not find issue opening entry in github repo, hope it's ok
sending here.

Thanks,
Xiong

Full test log:

# ./nf.sh
+ cc -ggdb test_libvmmalloc.c '-DALLOC_SIZE=((size_t)(1UL << 8))' -o test_libvmmalloc -lvmmalloc
+ VMMALLOC_POOL_DIR=/daxmnt/
+ VMMALLOC_POOL_SIZE=1073741824
+ ./test_libvmmalloc
        Testing ./test_libvmmalloc, alloc size 256
./nf.sh: line 47: 15789 Segmentation fault      VMMALLOC_POOL_DIR=$MNT1/ VMMALLOC_POOL_SIZE=$pshift ./test_libvmmalloc
+ ldd -v ./test_libvmmalloc
        linux-vdso.so.1 =>  (0x00007ffe4fdf9000)
        libvmmalloc.so.1 => /usr/local/lib64/libvmmalloc.so.1 (0x00007f786ce1e000)
        libc.so.6 => /lib64/libc.so.6 (0x00007f786ca51000)
        libpthread.so.0 => /lib64/libpthread.so.0 (0x00007f786c835000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f786d060000)

        Version information:
        ./test_libvmmalloc:
                libc.so.6 (GLIBC_2.2.5) => /lib64/libc.so.6
        /usr/local/lib64/libvmmalloc.so.1:
                ld-linux-x86-64.so.2 (GLIBC_2.3) => /lib64/ld-linux-x86-64.so.2
                libpthread.so.0 (GLIBC_2.3.4) => /lib64/libpthread.so.0
                libpthread.so.0 (GLIBC_2.3.2) => /lib64/libpthread.so.0
                libpthread.so.0 (GLIBC_2.2.5) => /lib64/libpthread.so.0
                libc.so.6 (GLIBC_2.14) => /lib64/libc.so.6
                libc.so.6 (GLIBC_2.3) => /lib64/libc.so.6
                libc.so.6 (GLIBC_2.3.2) => /lib64/libc.so.6
                libc.so.6 (GLIBC_2.7) => /lib64/libc.so.6
                libc.so.6 (GLIBC_2.17) => /lib64/libc.so.6
                libc.so.6 (GLIBC_2.3.4) => /lib64/libc.so.6
                libc.so.6 (GLIBC_2.2.5) => /lib64/libc.so.6
        /lib64/libc.so.6:
                ld-linux-x86-64.so.2 (GLIBC_2.3) => /lib64/ld-linux-x86-64.so.2
                ld-linux-x86-64.so.2 (GLIBC_PRIVATE) => /lib64/ld-linux-x86-64.so.2
        /lib64/libpthread.so.0:
                ld-linux-x86-64.so.2 (GLIBC_2.2.5) => /lib64/ld-linux-x86-64.so.2
                ld-linux-x86-64.so.2 (GLIBC_2.3) => /lib64/ld-linux-x86-64.so.2
                ld-linux-x86-64.so.2 (GLIBC_PRIVATE) => /lib64/ld-linux-x86-64.so.2
                libc.so.6 (GLIBC_2.14) => /lib64/libc.so.6
                libc.so.6 (GLIBC_2.3.2) => /lib64/libc.so.6
                libc.so.6 (GLIBC_PRIVATE) => /lib64/libc.so.6
                libc.so.6 (GLIBC_2.2.5) => /lib64/libc.so.6
+ echo 0
0
+ dmesg
[12890.676033] traps: test_libvmmallo[15789] general protection ip:7f3f01481a31 sp:7ffd85f4b7a0 error:0 in libvmmalloc.so.1.0.0[7f3f0146d000+3e000]
+ set +x
GNU gdb (GDB) Red Hat Enterprise Linux 7.6.1-110.el7
Copyright (C) 2013 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-redhat-linux-gnu".
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>...
Reading symbols from /home/xzhou/fsdax/test_libvmmalloc...done.
(gdb) b main
Breakpoint 1 at 0x40073c: file test_libvmmalloc.c, line 18.
(gdb) r
Starting program: /home/xzhou/fsdax/./test_libvmmalloc
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib64/libthread_db.so.1".

Breakpoint 1, main (argc=1, argv=0x7fffffffe388) at test_libvmmalloc.c:18
18              char *buf = NULL;
(gdb) c
Continuing.
        Testing /home/xzhou/fsdax/./test_libvmmalloc, alloc size 256

Program received signal SIGSEGV, Segmentation fault.
0x00007ffff7bada31 in arena_purge () from /usr/local/lib64/libvmmalloc.so.1
(gdb) bt
#0  0x00007ffff7bada31 in arena_purge () from /usr/local/lib64/libvmmalloc.so.1
#1  0x00007ffff7badcca in arena_dalloc_bin_run () from /usr/local/lib64/libvmmalloc.so.1
#2  0x00007ffff7baf0e0 in je_vmem_je_arena_dalloc_bin_locked () from /usr/local/lib64/libvmmalloc.so.1
#3  0x00007ffff7bc6d31 in je_vmem_je_tcache_bin_flush_small () from /usr/local/lib64/libvmmalloc.so.1
#4  0x00007ffff7bc761e in je_vmem_je_tcache_destroy () from /usr/local/lib64/libvmmalloc.so.1
#5  0x00007ffff7bc7895 in je_vmem_je_tcache_thread_cleanup () from /usr/local/lib64/libvmmalloc.so.1
#6  0x00007ffff7b9dccc in jemalloc_destructor () from /usr/local/lib64/libvmmalloc.so.1
#7  0x00007ffff7deb18a in _dl_fini () at dl-fini.c:253
#8  0x00007ffff7805b19 in __run_exit_handlers (status=0, listp=0x7ffff7b926c8 <__exit_funcs>, run_list_atexit=run_list_atexit@entry=true) at exit.c:77
#9  0x00007ffff7805b67 in __GI_exit (status=<optimized out>) at exit.c:99
#10 0x00007ffff77ee38c in __libc_start_main (main=0x40072d <main>, argc=1, ubp_av=0x7fffffffe388, init=<optimized out>, fini=<optimized out>,
    rtld_fini=<optimized out>, stack_end=0x7fffffffe378) at ../csu/libc-start.c:308
#11 0x0000000000400669 in _start ()
(gdb) c
Continuing.

Program terminated with signal SIGSEGV, Segmentation fault.
The program no longer exists.
(gdb) q

# cat nf.sh
#!/bin/bash

set xfs /dev/pmem0 /daxmnt

[ $# -ne 3 ] && { echo $0 fst dev mnt; exit 1; }

#yum install -y libvmmalloc-devel libvmmalloc libvmem-devel
#debuginfo-install glibc libgcc libvmmalloc

FSTYP=$1
DEV1=$2
MNT1=$3

mountpoint $MNT1 > /dev/null 2>&1 && umount $MNT1
mkdir -p $MNT1

if [ "$FSTYP" == "ext4" ] ; then
        mkfs.ext4 -Fq -b 4096 $DEV1
elif [ "$FSTYP" == "xfs" ] ; then
        mkfs.xfs -fq -b size=4096 $DEV1
fi

mount -o dax $DEV1 $MNT1

cat > /dev/null <<EOF
for psize in 20 21 25 30 31 32 ; do
for asize in 3 8 13 21 31 32; do
        cc test_libvmmalloc.c -DALLOC_SIZE="((size_t)(1UL << $asize))" -o test_libvmmalloc -lvmmalloc
        if [ $? -ne 0 ] ; then
                echo "nvml libvmmalloc $asize cc FAIL"
                exit 1
        fi
        ((pshift=1<<psize))
        echo -ne "\t$psize $asize"
        VMMALLOC_POOL_DIR=$MNT1/ VMMALLOC_POOL_SIZE=$pshift ./test_libvmmalloc && \
        VMMALLOC_POOL_DIR=$MNT1/ VMMALLOC_POOL_SIZE=$pshift ls > /dev/null $MNT1
done
done
EOF

psize=30
asize=8
((pshift=1<<psize))
dmesg -C
set -x
cc -ggdb test_libvmmalloc.c -DALLOC_SIZE="((size_t)(1UL << $asize))" -o test_libvmmalloc -lvmmalloc || exit
VMMALLOC_POOL_DIR=$MNT1/ VMMALLOC_POOL_SIZE=$pshift ./test_libvmmalloc
ldd -v ./test_libvmmalloc
echo $?
dmesg
set +x
VMMALLOC_POOL_DIR=$MNT1/ VMMALLOC_POOL_SIZE=$pshift gdb ./test_libvmmalloc

umount $MNT1 $DEV1 > /dev/null 2>&1

# cat test_libvmmalloc.c
#include <stdio.h>
#include <fcntl.h>
#include <errno.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <libvmem.h>

/* alloc size -- 1 KB */
#ifndef ALLOC_SIZE
#define ALLOC_SIZE ((size_t)(1 << 10))
#endif

int main(int argc, char *argv[])
{
        char *path;
        char *ptr;
        char *buf = NULL;

        printf("\tTesting %s, alloc size %lu\n", argv[0], ALLOC_SIZE);

        if ((ptr = malloc(ALLOC_SIZE)) == NULL) {
                perror("vmem_malloc");
                exit(1);
        }

        buf = (char *)malloc(ALLOC_SIZE);
        if (buf == NULL) {
                perror("a buf malloc");
                free(ptr);
                exit(1);
        }
        memset(buf, 'a', ALLOC_SIZE);
        strncpy(ptr, buf, ALLOC_SIZE);

        buf = (char *)realloc(buf, ALLOC_SIZE - 1);
        if (buf == NULL) {
                perror("b buf malloc");
                free(ptr);
                exit(1);
        }
        memset(buf, 'b', ALLOC_SIZE - 1);
        strncpy(ptr, buf, ALLOC_SIZE - 1);

        buf = (char *)realloc(buf, ALLOC_SIZE + 1024);
        if (buf == NULL) {
                perror("c buf malloc");
                free(ptr);
                exit(1);
        }
        memset(buf, 'c', ALLOC_SIZE + 1024);
        strncpy(ptr, buf, ALLOC_SIZE + 1024);

        /* give the memory back */
        free(ptr);
        free(buf);

        return 0;
}
# git remote -v
origin  https://github.com/pmem/nvml.git (fetch)
origin  https://github.com/pmem/nvml.git (push)
# git log --oneline -1
2f9a347 Merge pull request #2576 from plebioda/bug-fixing
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
