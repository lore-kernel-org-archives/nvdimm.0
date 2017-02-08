From: Xiong Zhou <xzhou@redhat.com>
Subject: [PATCH v6 1/2] xfs: test per-inode DAX flag by IO
Date: Wed,  8 Feb 2017 12:11:17 +0800
Message-ID: <1486527078-11173-2-git-send-email-xzhou@redhat.com>
References: <20170206191717.GB12290@linux.intel.com>
 <1486527078-11173-1-git-send-email-xzhou@redhat.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1486527078-11173-1-git-send-email-xzhou@redhat.com>
Sender: fstests-owner@vger.kernel.org
To: ross.zwisler@linux.intel.com, fstests@vger.kernel.org
Cc: linux-nvdimm@ml01.01.org, jmoyer@redhat.com, eguan@redhat.com, Xiong Zhou <xzhou@redhat.com>
List-Id: linux-nvdimm@lists.01.org

In a DAX mountpoint, do IO betwen files with and
without DAX per-inode flag. We do mmap, both
O_DIRECT and buffered read/write IO in this case.
Then test again in the same device without dax
mountoption.

Add help _require_scratch_dax to make sure we can
test DAX feature on SCRATCH_DEV.

Add mmap dio test programme to test read/write
between a mmap area of one file and another file
directly or buffered, with different size.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Xiong Zhou <xzhou@redhat.com>
---
 .gitignore        |   1 +
 common/rc         |  13 +++++
 src/Makefile      |   2 +-
 src/t_mmap_dio.c  | 111 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/196     | 158 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/196.out |   2 +
 tests/xfs/group   |   1 +
 7 files changed, 287 insertions(+), 1 deletion(-)
 create mode 100644 src/t_mmap_dio.c
 create mode 100755 tests/xfs/196
 create mode 100644 tests/xfs/196.out

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
index 7e2eaee..b99c4e2 100644
--- a/common/rc
+++ b/common/rc
@@ -2633,6 +2633,19 @@ _require_scratch_shutdown()
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
+	_fs_options $SCRATCH_DEV | grep -qw "dax" || \
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
index 0000000..69b9ca8
--- /dev/null
+++ b/src/t_mmap_dio.c
@@ -0,0 +1,111 @@
+/*
+ * This programme was originally written by
+ *     Jeff Moyer <jmoyer@redhat.com>
+ *
+ * Copyright (C) 2016, Red Hat, Inc.
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
+	int fd, fd2, ret, dio = 1;
+	char *map;
+	char *msg;
+	char *sfile;
+	char *dfile;
+	unsigned long len, opt;
+
+	if (argc < 4)
+		usage(basename(argv[0]));
+
+	while ((opt = getopt(argc, argv, "b")) != -1)
+		dio = 0;
+
+	sfile = argv[optind];
+	dfile = argv[optind + 1];
+	msg = argv[optind + 3];
+	len = strtoul(argv[optind + 2], NULL, 10);
+	if (errno == ERANGE)
+		err_exit("strtoul", 0, msg);
+
+	/* Open source file and mmap*/
+	fd = open(sfile, O_RDWR, 0644);
+	if (fd < 0)
+		err_exit("open src", len, msg);
+
+	map = (char *)mmap(NULL, len,
+		PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
+	if (map == MAP_FAILED)
+		err_exit("mmap", len, msg);
+
+	if (dio == 1) {
+		/* Open dest file with O_DIRECT */
+		fd2 = open(dfile, O_RDWR|O_DIRECT, 0644);
+		if (fd2 < 0)
+			err_exit("open dest", len, msg);
+	} else {
+		/* Open dest file without O_DIRECT */
+		fd2 = open(dfile, O_RDWR, 0644);
+		if (fd2 < 0)
+			err_exit("open dest", len, msg);
+	}
+
+	/* First, test storing to dest file from source mapping */
+	ret = write(fd2, map, len);
+	if (ret != len)
+		err_exit("write", len, msg);
+
+	ret = fsync(fd2);
+	if (ret != 0)
+		err_exit("fsync", len, msg);
+
+	ret = (int)lseek(fd2, 0, SEEK_SET);
+	if (ret == -1)
+		err_exit("lseek", len, msg);
+
+	/* Next, test reading from dest file into source mapping */
+	ret = read(fd2, map, len);
+	if (ret != len)
+		err_exit("read", len, msg);
+	ret = msync(map, len, MS_SYNC);
+	if (ret < 0)
+		err_exit("msync", len, msg);
+
+	ret = munmap(map, len);
+	if (ret < 0)
+		err_exit("munmap", len, msg);
+
+	ret = close(fd);
+	if (ret < 0)
+		err_exit("clsoe fd", len, msg);
+
+	ret = close(fd2);
+	if (ret < 0)
+		err_exit("close fd2", len, msg);
+
+	exit(0);
+}
diff --git a/tests/xfs/196 b/tests/xfs/196
new file mode 100755
index 0000000..8b1099c
--- /dev/null
+++ b/tests/xfs/196
@@ -0,0 +1,158 @@
+#! /bin/bash
+# FS QA Test 196
+#
+# Test per-inode DAX flag by mmap direct/buffered IO.
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
+_require_xfs_io_command "falloc"
+
+prep_files()
+{
+	rm -f $SCRATCH_MNT/tf_{s,d}
+
+	$XFS_IO_PROG -f -c "falloc 0 $tsize" \
+		$SCRATCH_MNT/tf_{s,d} >> $seqres.full 2>&1
+}
+
+t_both_dax()
+{
+	prep_files
+	$XFS_IO_PROG -c "chattr +x" $SCRATCH_MNT/tf_{s,d}
+	# with O_DIRECT first
+	src/t_mmap_dio $SCRATCH_MNT/tf_{s,d} $1 "dio both dax"
+
+	prep_files
+	$XFS_IO_PROG -c "chattr +x" $SCRATCH_MNT/tf_{s,d}
+	# again with buffered IO
+	src/t_mmap_dio -b $SCRATCH_MNT/tf_{s,d} \
+		$1 "buffered both dax"
+}
+
+t_nondax_to_dax()
+{
+	prep_files
+	$XFS_IO_PROG -c "chattr -x" $SCRATCH_MNT/tf_s
+	$XFS_IO_PROG -c "chattr +x" $SCRATCH_MNT/tf_d
+	src/t_mmap_dio $SCRATCH_MNT/tf_{s,d} \
+		$1 "dio nondax to dax"
+
+	prep_files
+	$XFS_IO_PROG -c "chattr -x" $SCRATCH_MNT/tf_s
+	$XFS_IO_PROG -c "chattr +x" $SCRATCH_MNT/tf_d
+	src/t_mmap_dio -b $SCRATCH_MNT/tf_{s,d} \
+		$1 "buffered nondax to dax"
+}
+
+t_dax_to_nondax()
+{
+	prep_files
+	$XFS_IO_PROG -c "chattr +x" $SCRATCH_MNT/tf_s
+	$XFS_IO_PROG -c "chattr -x" $SCRATCH_MNT/tf_d
+	src/t_mmap_dio $SCRATCH_MNT/tf_{s,d} \
+		$1 "dio dax to nondax"
+
+	prep_files
+	$XFS_IO_PROG -c "chattr +x" $SCRATCH_MNT/tf_s
+	$XFS_IO_PROG -c "chattr -x" $SCRATCH_MNT/tf_d
+	src/t_mmap_dio -b $SCRATCH_MNT/tf_{s,d} \
+		$1 "buffered dax to nondax"
+}
+
+t_both_nondax()
+{
+	prep_files
+	$XFS_IO_PROG -c "chattr -x" $SCRATCH_MNT/tf_{s,d}
+	src/t_mmap_dio $SCRATCH_MNT/tf_{s,d} \
+		$1 "dio both nondax"
+
+	prep_files
+	$XFS_IO_PROG -c "chattr -x" $SCRATCH_MNT/tf_{s,d}
+	src/t_mmap_dio -b $SCRATCH_MNT/tf_{s,d} \
+		$1 "buffered both nondax"
+}
+
+# $1 mmap read/write size
+t_dax_flag_mmap_dio()
+{
+	t_both_dax $1
+	t_dax_to_nondax $1
+	t_nondax_to_dax $1
+	t_both_nondax $1
+}
+
+do_tests()
+{
+	# less than page size
+	t_dax_flag_mmap_dio 1024
+	# page size
+	t_dax_flag_mmap_dio `src/feature -s`
+	# bigger sizes, for PMD faults
+	t_dax_flag_mmap_dio $((16 * 1024 * 1024))
+	t_dax_flag_mmap_dio $((64 * 1024 * 1024))
+}
+
+# make xfs 2Mb aligned for PMD fault testing
+_scratch_mkfs "-d su=2m,sw=1" > /dev/null 2>&1
+
+# mount with dax option
+_scratch_mount "-o dax"
+
+tsize=$((128 * 1024 * 1024))
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
diff --git a/tests/xfs/196.out b/tests/xfs/196.out
new file mode 100644
index 0000000..477dcf0
--- /dev/null
+++ b/tests/xfs/196.out
@@ -0,0 +1,2 @@
+QA output created by 196
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index 9757ec8..41d053f 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -193,6 +193,7 @@
 193 auto quick clone
 194 rw auto
 195 ioctl dump auto quick
+196 auto attr quick
 197 dir auto quick
 198 auto quick clone
 199 mount auto quick
-- 
1.8.3.1
