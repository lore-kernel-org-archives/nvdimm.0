From: Xiong Zhou <xzhou@redhat.com>
Subject: [PATCH v3] xfs: test per-inode DAX flag by IO
Date: Fri, 20 Jan 2017 10:21:28 +0800
Message-ID: <1484878888-11483-1-git-send-email-xzhou@redhat.com>
References: <20170119204925.GB28456@linux.intel.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20170119204925.GB28456@linux.intel.com>
Sender: fstests-owner@vger.kernel.org
To: ross.zwisler@linux.intel.com
Cc: eguan@redhat.com, fstests@vger.kernel.org, linux-nvdimm@ml01.01.org, Xiong Zhou <xzhou@redhat.com>
List-Id: linux-nvdimm@lists.01.org

In a DAX mountpoint, do IO betwen files with and
without DAX per-inode flag. We do mmap and O_DIRECT
read/write IO in this case. Then test again in the
same device without dax mountoption.

Add help _require_scratch_dax to make sure we can
test DAX feature on SCRATCH_DEV.

Add mmap dio test programme to test read/write
between a mmap area of one file and another file
directly, with different size.

Signed-off-by: Xiong Zhou <xzhou@redhat.com>
---
v3:
 close fds in C test programme for clean up.

 .gitignore        |   1 +
 common/rc         |  14 +++++++
 src/Makefile      |   2 +-
 src/t_mmap_dio.c  |  89 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/138     | 110 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/138.out |   2 +
 tests/xfs/group   |   1 +
 7 files changed, 218 insertions(+), 1 deletion(-)
 create mode 100644 src/t_mmap_dio.c
 create mode 100755 tests/xfs/138
 create mode 100644 tests/xfs/138.out

diff --git a/.gitignore b/.gitignore
index 7dcea14..48a40a0 100644
--- a/.gitignore
+++ b/.gitignore
@@ -129,6 +129,7 @@
 /src/cloner
 /src/renameat2
 /src/t_rename_overwrite
+/src/t_mmap_dio
 
 # dmapi/ binaries
 /dmapi/src/common/cmd/read_invis
diff --git a/common/rc b/common/rc
index 892c46e..3706620 100644
--- a/common/rc
+++ b/common/rc
@@ -2632,6 +2632,20 @@ _require_scratch_shutdown()
 	_scratch_unmount
 }
 
+# Does dax mount option work on this dev/fs?
+_require_scratch_dax()
+{
+	_require_scratch
+	_scratch_mkfs > /dev/null 2>&1
+	_scratch_mount -o dax
+	# Check options to be sure. XFS ignores dax option
+	# and goes on if dev underneath does not support dax.
+	_fs_options $SCRATCH_DEV | grep -w "dax" > /dev/null 2>&1
+	[ $? -ne 0 ] && \
+		_notrun "$SCRATCH_DEV $FSTYP does not support -o dax"
+	_scratch_unmount
+}
+
 # Does norecovery support by this fs?
 _require_norecovery()
 {
diff --git a/src/Makefile b/src/Makefile
index 94d74aa..eb5a56c 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -12,7 +12,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 	godown resvtest writemod makeextents itrash rename \
 	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes \
 	t_mmap_writev t_truncate_cmtime dirhash_collide t_rename_overwrite \
-	holetest t_truncate_self
+	holetest t_truncate_self t_mmap_dio
 
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
diff --git a/src/t_mmap_dio.c b/src/t_mmap_dio.c
new file mode 100644
index 0000000..abec442
--- /dev/null
+++ b/src/t_mmap_dio.c
@@ -0,0 +1,89 @@
+/*
+ * This programme was originally written by
+ *     Jeff Moyer <jmoyer@redhat.com>
+ */
+#define _GNU_SOURCE 1
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/mman.h>
+#include <libaio.h>
+#include <errno.h>
+#include <sys/time.h>
+
+void usage(char *prog)
+{
+	fprintf(stderr,
+		"usage: %s <src file> <dest file> <size> <msg>\n",
+		prog);
+	exit(1);
+}
+
+void err_exit(char *op, unsigned long len, char *s)
+{
+	fprintf(stderr, "%s(%s) len %lu %s\n",
+		op, strerror(errno), len, s);
+	exit(1);
+}
+
+int main(int argc, char **argv)
+{
+	int fd, fd2, ret;
+	char *map;
+	unsigned long len;
+
+	if (argc < 3)
+		usage(basename(argv[0]));
+
+	len = strtoul(argv[3], NULL, 10);
+	if (errno == ERANGE)
+		err_exit("strtoul", 0, argv[4]);
+
+	/* Open source file and mmap*/
+	fd = open(argv[1], O_RDWR, 0644);
+	if (fd < 0)
+		err_exit("open s", len, argv[4]);
+
+	map = (char *)mmap(NULL, len,
+		PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
+	if (map == MAP_FAILED)
+		err_exit("mmap", len, argv[4]);
+
+	/* Open dest file with O_DIRECT */
+	fd2 = open(argv[2], O_RDWR|O_DIRECT, 0644);
+	if (fd2 < 0)
+		err_exit("open d", len, argv[4]);
+
+	/* First, test storing to dest file from source mapping */
+	ret = write(fd2, map, len);
+	if (ret != len)
+		err_exit("write", len, argv[4]);
+
+	ret = (int)lseek(fd2, 0, SEEK_SET);
+	if (ret == -1)
+		err_exit("lseek", len, argv[4]);
+
+	/* Next, test reading from dest file into source mapping */
+	ret = read(fd2, map, len);
+	if (ret != len)
+		err_exit("read", len, argv[4]);
+	ret = msync(map, len, MS_SYNC);
+	if (ret < 0)
+		err_exit("msync", len, argv[4]);
+
+	ret = munmap(map, len);
+	if (ret < 0)
+		err_exit("munmap", len, argv[4]);
+
+	ret = close(fd);
+	if (ret < 0)
+		err_exit("clsoe fd", len, argv[4]);
+
+	ret = close(fd2);
+	if (ret < 0)
+		err_exit("close fd2", len, argv[4]);
+
+	exit(0);
+}
diff --git a/tests/xfs/138 b/tests/xfs/138
new file mode 100755
index 0000000..9822441
--- /dev/null
+++ b/tests/xfs/138
@@ -0,0 +1,110 @@
+#! /bin/bash
+# FS QA Test 138
+#
+# Test per-inode DAX flag by mmap direct IO.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Red Hat Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+_supported_fs xfs
+_supported_os Linux
+_require_scratch_dax
+_require_test_program "feature"
+_require_test_program "t_mmap_dio"
+_require_xfs_io_command "chattr" "+/-x"
+
+# $1 mmap read/write size
+t_dax_flag_mmap_dio()
+{
+	# both dax
+	$XFS_IO_PROG -c "chattr +x" $SCRATCH_MNT/tf_s
+	$XFS_IO_PROG -c "chattr +x" $SCRATCH_MNT/tf_d
+	src/t_mmap_dio $SCRATCH_MNT/tf_{s,d} $1 "both dax"
+
+	# from non dax to dax
+	$XFS_IO_PROG -c "chattr -x" $SCRATCH_MNT/tf_s
+	src/t_mmap_dio $SCRATCH_MNT/tf_{s,d} $1 "nondax to dax"
+
+	# from dax to non dax
+	$XFS_IO_PROG -c "chattr +x" $SCRATCH_MNT/tf_s
+	$XFS_IO_PROG -c "chattr -x" $SCRATCH_MNT/tf_d
+	src/t_mmap_dio $SCRATCH_MNT/tf_{s,d} $1 "dax to nondax"
+
+	# both non dax
+	$XFS_IO_PROG -c "chattr -x" $SCRATCH_MNT/tf_s
+	src/t_mmap_dio $SCRATCH_MNT/tf_{s,d} $1 "both nondax"
+}
+
+do_tests()
+{
+	# less than page size
+	t_dax_flag_mmap_dio 1024
+	# page size
+	t_dax_flag_mmap_dio `src/feature -s`
+	# bigger sizes, for PMD faults
+	t_dax_flag_mmap_dio 16777216
+	t_dax_flag_mmap_dio 67108864
+}
+
+_scratch_mkfs > /dev/null 2>&1
+
+# mount with dax option
+_scratch_mount "-o dax"
+
+psize=`src/feature -s`
+tsize=$((1024 * 1024 * 1024))
+
+$XFS_IO_PROG -f -c "pwrite -W -b $psize 0 $tsize" \
+	$SCRATCH_MNT/tf_s >> $seqres.full 2>&1
+$XFS_IO_PROG -f -c "pwrite -W -b $psize 0 $tsize" \
+	$SCRATCH_MNT/tf_d >> $seqres.full 2>&1
+
+do_tests
+_scratch_unmount
+
+# mount again without dax option
+export MOUNT_OPTIONS=""
+_scratch_mount
+do_tests
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/xfs/138.out b/tests/xfs/138.out
new file mode 100644
index 0000000..614ba1a
--- /dev/null
+++ b/tests/xfs/138.out
@@ -0,0 +1,2 @@
+QA output created by 138
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index 3c5884c..4b406c0 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -135,6 +135,7 @@
 135 auto logprint quick v2log
 136 attr2
 137 auto metadata v2log
+138 auto attr quick
 139 auto quick clone
 140 auto clone
 141 auto log metadata
-- 
1.8.3.1
