Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9843E222A54FB
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 00:08:02 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 2/2] ext4: test for inline data + DAX corruption
Date: Thu,  4 Jan 2018 01:11:21 -0700
Message-Id: <20180104081121.313-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20180104081121.313-1-ross.zwisler@linux.intel.com>
References: <20180104081121.313-1-ross.zwisler@linux.intel.com>
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
Cc: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add a regression test for the following kernel commit:

  ext4: prevent data corruption with inline data + DAX

The test passes either if we don't encounter corruption, or if mounting
with DAX + inline data fails.  The latter is the way that we prevent this
issue in the kernel.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

---

Changes since v1:

 - Changed ordering of .gitignore entries. (Eryu)

 - Added '_require_scratch_ext4_feature "inline_data"' test. (Eryu)
---
 .gitignore                         |  1 +
 src/Makefile                       |  2 +-
 src/t_ext4_dax_inline_corruption.c | 70 +++++++++++++++++++++++++++++++
 tests/ext4/031                     | 86 ++++++++++++++++++++++++++++++++++++++
 tests/ext4/031.out                 |  2 +
 tests/ext4/group                   |  1 +
 6 files changed, 161 insertions(+), 1 deletion(-)
 create mode 100644 src/t_ext4_dax_inline_corruption.c
 create mode 100755 tests/ext4/031
 create mode 100644 tests/ext4/031.out

diff --git a/.gitignore b/.gitignore
index 840e4fe4..09dd01cb 100644
--- a/.gitignore
+++ b/.gitignore
@@ -116,6 +116,7 @@
 /src/t_dir_type
 /src/t_encrypted_d_revalidate
 /src/t_ext4_dax_journal_corruption
+/src/t_ext4_dax_inline_corruption
 /src/t_futimens
 /src/t_getcwd
 /src/t_holes
diff --git a/src/Makefile b/src/Makefile
index 86c5440c..b96b8cf2 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -14,7 +14,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 	t_mmap_writev t_truncate_cmtime dirhash_collide t_rename_overwrite \
 	holetest t_truncate_self t_mmap_dio af_unix t_mmap_stale_pmd \
 	t_mmap_cow_race t_mmap_fallocate fsync-err t_mmap_write_ro \
-	t_ext4_dax_journal_corruption
+	t_ext4_dax_journal_corruption t_ext4_dax_inline_corruption
 
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
diff --git a/src/t_ext4_dax_inline_corruption.c b/src/t_ext4_dax_inline_corruption.c
new file mode 100644
index 00000000..4b7d8938
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
index 00000000..58177b44
--- /dev/null
+++ b/tests/ext4/031
@@ -0,0 +1,86 @@
+#! /bin/bash
+# FS QA Test ext4/031
+#
+# This is a regression test for kernel patch:
+#   ext4: prevent data corruption with inline data + DAX
+# created by Ross Zwisler <ross.zwisler@linux.intel.com>
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017-2018 Intel Corporation.  All Rights Reserved.
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
+# DAX needs to be off so we can create an inode with inline data
+SAVE_MOUNT_OPTIONS="$MOUNT_OPTIONS"
+MOUNT_OPTIONS=""
+
+# Modify as appropriate.
+_supported_os Linux
+_supported_fs ext4
+_require_scratch_dax
+_require_test_program "t_ext4_dax_inline_corruption"
+_require_scratch_ext4_feature "inline_data"
+
+# real QA test starts here
+_scratch_mkfs_ext4 -O inline_data > $seqres.full 2>&1
+
+TESTFILE=$SCRATCH_MNT/testfile
+
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
+$here/src/t_ext4_dax_inline_corruption $TESTFILE
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/ext4/031.out b/tests/ext4/031.out
new file mode 100644
index 00000000..b3d0bb03
--- /dev/null
+++ b/tests/ext4/031.out
@@ -0,0 +1,2 @@
+QA output created by 031
+Silence is golden
diff --git a/tests/ext4/group b/tests/ext4/group
index ef768dff..396f963d 100644
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
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
