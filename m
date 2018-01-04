Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F885222EDCF5
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 00:08:01 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/2] ext4: test for DAX + journaling corruption
Date: Thu,  4 Jan 2018 01:11:20 -0700
Message-Id: <20180104081121.313-1-ross.zwisler@linux.intel.com>
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

  ext4: prevent data corruption with journaling + DAX

The test passes if either we successfully compare the data between the mmap
with journaling turned on and the one with journaling turned off, or if we
fail the chattr command to turn on or off journaling.  The latter is how we
prevent this issue in the kernel.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

---

Changes since v1:

 - Reordered .gitignore entry. (Eryu)

 - Added comments about how "chattr +j" turns off DAX and about why we need
   the 'nodelalloc' mount option. (Eryu)

 - Added a _require_command for chattr. (Eryu)

 - Added $here for src/t_ext4_dax_journal_corruption command. (Eryu)

The previous version of this series is here:

https://lists.01.org/pipermail/linux-nvdimm/2017-September/012463.html

The related kernel patches were merged in v4.15-rc1.
---
 .gitignore                          |   1 +
 src/Makefile                        |   3 +-
 src/t_ext4_dax_journal_corruption.c | 102 ++++++++++++++++++++++++++++++++++++
 tests/ext4/030                      |  74 ++++++++++++++++++++++++++
 tests/ext4/030.out                  |   2 +
 tests/ext4/group                    |   1 +
 6 files changed, 182 insertions(+), 1 deletion(-)
 create mode 100644 src/t_ext4_dax_journal_corruption.c
 create mode 100755 tests/ext4/030
 create mode 100644 tests/ext4/030.out

diff --git a/.gitignore b/.gitignore
index f27c30af..840e4fe4 100644
--- a/.gitignore
+++ b/.gitignore
@@ -115,6 +115,7 @@
 /src/t_dir_offset2
 /src/t_dir_type
 /src/t_encrypted_d_revalidate
+/src/t_ext4_dax_journal_corruption
 /src/t_futimens
 /src/t_getcwd
 /src/t_holes
diff --git a/src/Makefile b/src/Makefile
index b1012172..86c5440c 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -13,7 +13,8 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes \
 	t_mmap_writev t_truncate_cmtime dirhash_collide t_rename_overwrite \
 	holetest t_truncate_self t_mmap_dio af_unix t_mmap_stale_pmd \
-	t_mmap_cow_race t_mmap_fallocate fsync-err t_mmap_write_ro
+	t_mmap_cow_race t_mmap_fallocate fsync-err t_mmap_write_ro \
+	t_ext4_dax_journal_corruption
 
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
diff --git a/src/t_ext4_dax_journal_corruption.c b/src/t_ext4_dax_journal_corruption.c
new file mode 100644
index 00000000..18a2acdc
--- /dev/null
+++ b/src/t_ext4_dax_journal_corruption.c
@@ -0,0 +1,102 @@
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
+void chattr_cmd(char *chattr, char *cmd, char *file)
+{
+	int ret;
+	char command[STRLEN];
+
+	ret = snprintf(command, STRLEN, "%s %s %s 2>/dev/null", chattr, cmd, file);
+	if (ret < 0)
+		err_exit("snprintf");
+
+	ret = system(command);
+	if (ret) /* Success - the kernel fix is to have this chattr fail */
+		exit(77);
+}
+
+int main(int argc, char *argv[])
+{
+	int fd, err, len = PAGE(1);
+	char *data, *dax_data, *chattr, *file;
+	char string[STRLEN];
+
+	if (argc < 3) {
+		printf("Usage: %s <chattr program> <file>\n", basename(argv[0]));
+		exit(0);
+	}
+
+	chattr = argv[1];
+	file = argv[2];
+
+	srand(time(NULL));
+	snprintf(string, STRLEN, "random number %d\n", rand());
+
+	fd = open(file, O_RDWR|O_CREAT, S_IRUSR|S_IWUSR);
+	if (fd < 0)
+		err_exit("fd");
+
+	/* begin with journaling off and DAX on */
+	chattr_cmd(chattr, "-j", file);
+
+	ftruncate(fd, 0);
+	fallocate(fd, 0, 0, len);
+
+	dax_data = mmap(NULL, len, PROT_READ, MAP_SHARED, fd, 0);
+	if (!dax_data)
+		err_exit("mmap dax_data");
+
+	/*
+	 * This turns on journaling.  It also has the side-effect that it
+	 * turns off DAX for the given inode since journaling and DAX aren't
+	 * allowed to be on at the same time.  This happens in
+	 * ext4_change_inode_journal_flag() in kernel v4.14 and before.
+	 *
+	 * Note that this turns off the runtime DAX flag (S_DAX) in the
+	 * in-memory inode, and has nothing to do with per-inode on-media DAX
+	 * inode flags.
+	 */
+	chattr_cmd(chattr, "+j", file);
+
+	data = mmap(NULL, len, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
+	if (!data)
+		err_exit("mmap data");
+
+	/*
+	 * Write the data using the non-DAX mapping, and try and read it back
+	 * using the DAX mapping.
+	 */
+	strcpy(data, string);
+	if (strcmp(dax_data, string) != 0)
+		printf("Data miscompare\n");
+
+	err = munmap(data, len);
+	if (err < 0)
+		err_exit("munmap data");
+
+	err = munmap(dax_data, len);
+	if (err < 0)
+		err_exit("munmap dax_data");
+
+	err = close(fd);
+	if (err < 0)
+		err_exit("close");
+	return 0;
+}
diff --git a/tests/ext4/030 b/tests/ext4/030
new file mode 100755
index 00000000..85da7557
--- /dev/null
+++ b/tests/ext4/030
@@ -0,0 +1,74 @@
+#! /bin/bash
+# FS QA Test ext4/030
+#
+# This is a regression test for kernel patch:
+#   ext4: prevent data corruption with journaling + DAX
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
+# Modify as appropriate.
+_supported_os Linux
+_supported_fs ext4
+_require_scratch_dax
+_require_test_program "t_ext4_dax_journal_corruption"
+_require_command "$CHATTR_PROG" chattr
+
+# real QA test starts here
+_scratch_mkfs > $seqres.full 2>&1
+
+# In order to get our failure condition consistently we need to turn off
+# delayed allocation.  With delayed allocation on this simple test will pass,
+# but we would almost certainly see data corruption down the road as the
+# contents of the journal would conflict with the DAX data.
+_scratch_mount "-o dax,nodelalloc" >> $seqres.full 2>&1
+
+$here/src/t_ext4_dax_journal_corruption $CHATTR_PROG $SCRATCH_MNT/testfile
+
+if [[ $? != 0 && $? != 77 ]]; then
+	echo "Test failed, status $?"
+	exit 1
+fi
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/ext4/030.out b/tests/ext4/030.out
new file mode 100644
index 00000000..06a1c8fe
--- /dev/null
+++ b/tests/ext4/030.out
@@ -0,0 +1,2 @@
+QA output created by 030
+Silence is golden
diff --git a/tests/ext4/group b/tests/ext4/group
index 257bb646..ef768dff 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -32,6 +32,7 @@
 027 auto quick fsmap
 028 auto quick fsmap
 029 auto quick fsmap
+030 auto quick
 271 auto rw quick
 301 aio auto ioctl rw stress defrag
 302 aio auto ioctl rw stress defrag
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
