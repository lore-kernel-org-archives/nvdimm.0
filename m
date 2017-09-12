Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 29F2821D492C8
 for <linux-nvdimm@lists.01.org>; Mon, 11 Sep 2017 21:42:37 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 3/3] ext4: test for inline data + DAX corruption
Date: Mon, 11 Sep 2017 22:45:21 -0600
Message-Id: <20170912044521.22644-3-ross.zwisler@linux.intel.com>
In-Reply-To: <20170912044521.22644-1-ross.zwisler@linux.intel.com>
References: <20170912044521.22644-1-ross.zwisler@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: fstests@vger.kernel.org, Eryu Guan <eguan@redhat.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Add a regression test for the following kernel commit:

  ext4: prevent data corruption with inline data + DAX

The test passes either if we don't encounter corruption, or if mounting
with DAX + inline data fails.  The latter is the way that we prevent this
issue in the kernel.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 .gitignore                         |  1 +
 src/Makefile                       |  3 +-
 src/t_ext4_dax_inline_corruption.c | 70 +++++++++++++++++++++++++++++++
 tests/ext4/031                     | 84 ++++++++++++++++++++++++++++++++++++++
 tests/ext4/031.out                 |  2 +
 tests/ext4/group                   |  1 +
 6 files changed, 160 insertions(+), 1 deletion(-)
 create mode 100644 src/t_ext4_dax_inline_corruption.c
 create mode 100755 tests/ext4/031
 create mode 100644 tests/ext4/031.out

diff --git a/.gitignore b/.gitignore
index 4bdc5bf..37670e6 100644
--- a/.gitignore
+++ b/.gitignore
@@ -155,6 +155,7 @@
 /src/t_mmap_cow_race
 /src/t_mmap_fallocate
 /src/t_ext4_dax_journal_corruption
+/src/t_ext4_dax_inline_corruption
 
 # dmapi/ binaries
 /dmapi/src/common/cmd/read_invis
diff --git a/src/Makefile b/src/Makefile
index e6558e2..bcfae01 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -13,7 +13,8 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes \
 	t_mmap_writev t_truncate_cmtime dirhash_collide t_rename_overwrite \
 	holetest t_truncate_self t_mmap_dio af_unix t_mmap_stale_pmd \
-	t_mmap_cow_race t_mmap_fallocate fsync-err t_ext4_dax_journal_corruption
+	t_mmap_cow_race t_mmap_fallocate fsync-err t_ext4_dax_journal_corruption \
+	t_ext4_dax_inline_corruption
 
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
diff --git a/src/t_ext4_dax_inline_corruption.c b/src/t_ext4_dax_inline_corruption.c
new file mode 100644
index 0000000..4b7d893
--- /dev/null
+++ b/src/t_ext4_dax_inline_corruption.c
@@ -0,0 +1,70 @@
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <time.h>
+#include <unistd.h>
+
+#define PAGE(a) ((a)*0x1000)
+#define STRLEN 256
+
+void err_exit(char *op)
+{
+	fprintf(stderr, "%s: %s\n", op, strerror(errno));
+	exit(1);
+}
+
+int main(int argc, char *argv[])
+{
+	int fd, err, len = PAGE(1);
+	char *dax_data, *data;
+	char string[STRLEN];
+
+	if (argc < 2) {
+		printf("Usage: %s <file>\n", basename(argv[0]));
+		exit(0);
+	}
+
+	srand(time(NULL));
+	snprintf(string, STRLEN, "random number %d\n", rand());
+
+	fd = open(argv[1], O_RDWR);
+	if (fd < 0)
+		err_exit("fd");
+
+	data = mmap(NULL, len, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
+	if (!data)
+		err_exit("mmap data");
+
+	/* this fallocate turns off inline data and turns on DAX */
+	fallocate(fd, 0, 0, PAGE(2));
+
+	dax_data = mmap(NULL, len, PROT_READ, MAP_SHARED, fd, 0);
+	if (!dax_data)
+		err_exit("mmap dax_data");
+
+	/*
+	 * Write the data using the non-DAX mapping, and try and read it back
+	 * using the DAX mapping.
+	 */
+	strcpy(data, string);
+	if (strcmp(dax_data, string) != 0)
+		printf("Data miscompare\n");
+
+	err = munmap(dax_data, len);
+	if (err < 0)
+		err_exit("munmap dax_data");
+
+	err = munmap(data, len);
+	if (err < 0)
+		err_exit("munmap data");
+
+	err = close(fd);
+	if (err < 0)
+		err_exit("close");
+	return 0;
+}
diff --git a/tests/ext4/031 b/tests/ext4/031
new file mode 100755
index 0000000..95a5c65
--- /dev/null
+++ b/tests/ext4/031
@@ -0,0 +1,84 @@
+#! /bin/bash
+# FS QA Test ext4/031
+#
+# This is a regression test for kernel patch:
+#   ext4: prevent data corruption with inline data + DAX
+# created by Ross Zwisler <ross.zwisler@linux.intel.com>
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Intel Corporation.  All Rights Reserved.
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
+# Modify as appropriate.
+_supported_os Linux
+_supported_fs ext4
+_require_scratch_dax
+_require_test_program "t_ext4_dax_inline_corruption"
+
+# real QA test starts here
+_scratch_mkfs_ext4 -O inline_data > $seqres.full 2>&1
+
+TESTFILE=$SCRATCH_MNT/testfile
+
+# DAX needs to be off so we can create an inode with inline data
+SAVE_MOUNT_OPTIONS="$MOUNT_OPTIONS"
+MOUNT_OPTIONS=""
+_scratch_mount  >> $seqres.full 2>&1
+
+echo "Need to make some inline data..." > $TESTFILE
+
+export MOUNT_OPTIONS="$SAVE_MOUNT_OPTIONS"
+
+_scratch_unmount >> $seqres.full 2>&1
+_scratch_mount "-o dax" >> $seqres.full 2>&1
+
+if [[ $? != 0 ]]; then
+	# _require_scratch_dax already verified that we could mount with DAX.
+	# Failure here is expected because we have inline data.
+	echo "Silence is golden"
+	status=0
+	exit
+fi
+
+src/t_ext4_dax_inline_corruption $TESTFILE
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/ext4/031.out b/tests/ext4/031.out
new file mode 100644
index 0000000..b3d0bb0
--- /dev/null
+++ b/tests/ext4/031.out
@@ -0,0 +1,2 @@
+QA output created by 031
+Silence is golden
diff --git a/tests/ext4/group b/tests/ext4/group
index ef768df..396f963 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -33,6 +33,7 @@
 028 auto quick fsmap
 029 auto quick fsmap
 030 auto quick
+031 auto quick
 271 auto rw quick
 301 aio auto ioctl rw stress defrag
 302 aio auto ioctl rw stress defrag
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
