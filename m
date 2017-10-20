Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C5D12034C0B7
 for <linux-nvdimm@lists.01.org>; Fri, 20 Oct 2017 14:22:24 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [fstests PATCH v2] generic: add test for DAX MAP_SYNC support
Date: Fri, 20 Oct 2017 15:25:56 -0600
Message-Id: <20171020212556.30816-1-ross.zwisler@linux.intel.com>
In-Reply-To: <20171020052943.15104-1-ross.zwisler@linux.intel.com>
References: <20171020052943.15104-1-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org, Josef Bacik <jbacik@fb.com>, Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-raid@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Add a test that exercises DAX's new MAP_SYNC flag.

This test creates a file and writes to it via an mmap(), but never syncs
via fsync/msync.  This process is tracked via dm-log-writes, then replayed.

If MAP_SYNC is working the dm-log-writes replay will show the test file
with 1MiB of on-media block allocations.  This is because each allocating
page fault included an implicit metadata sync.  If MAP_SYNC isn't working
(which you can test by fiddling with the parameters to mmap()) the file
will be smaller or missing entirely.

Note that dm-log-writes doesn't track the data that we write via the
mmap(), so we can't do any data integrity checking.  We can only verify
that the metadata writes for the page faults happened.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

---

Changes since v1:
 - Addressed review feedback from Amir.  Thank you for the review!

---
 .gitignore            |  1 +
 common/dmlogwrites    |  1 -
 src/Makefile          |  3 +-
 src/t_map_sync.c      | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/466     | 76 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/466.out |  3 ++
 tests/generic/group   |  1 +
 7 files changed, 175 insertions(+), 2 deletions(-)
 create mode 100644 src/t_map_sync.c
 create mode 100755 tests/generic/466
 create mode 100644 tests/generic/466.out

diff --git a/.gitignore b/.gitignore
index 2014c08..9fc0695 100644
--- a/.gitignore
+++ b/.gitignore
@@ -119,6 +119,7 @@
 /src/t_getcwd
 /src/t_holes
 /src/t_immutable
+/src/t_map_sync
 /src/t_mmap_cow_race
 /src/t_mmap_dio
 /src/t_mmap_fallocate
diff --git a/common/dmlogwrites b/common/dmlogwrites
index 247c744..5b57df9 100644
--- a/common/dmlogwrites
+++ b/common/dmlogwrites
@@ -23,7 +23,6 @@ _require_log_writes()
 	[ -z "$LOGWRITES_DEV" -o ! -b "$LOGWRITES_DEV" ] && \
 		_notrun "This test requires a valid \$LOGWRITES_DEV"
 
-	_exclude_scratch_mount_option dax
 	_require_dm_target log-writes
 	_require_test_program "log-writes/replay-log"
 }
diff --git a/src/Makefile b/src/Makefile
index 3eb25b1..af7e7e9 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -13,7 +13,8 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes \
 	t_mmap_writev t_truncate_cmtime dirhash_collide t_rename_overwrite \
 	holetest t_truncate_self t_mmap_dio af_unix t_mmap_stale_pmd \
-	t_mmap_cow_race t_mmap_fallocate fsync-err t_mmap_write_ro
+	t_mmap_cow_race t_mmap_fallocate fsync-err t_mmap_write_ro \
+	t_map_sync
 
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
diff --git a/src/t_map_sync.c b/src/t_map_sync.c
new file mode 100644
index 0000000..29b546a
--- /dev/null
+++ b/src/t_map_sync.c
@@ -0,0 +1,92 @@
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+#define MiB(a) ((a)*1024*1024)
+
+/*
+ * These two defines were added to the kernel via commits entitled
+ * "mm: Define MAP_SYNC and VM_SYNC flags" and
+ * "mm: introduce MAP_SHARED_VALIDATE, a mechanism to safely define new mmap
+ * flags", respectively.
+ */
+#ifndef MAP_SYNC
+#define MAP_SYNC 0x80000
+#endif
+
+#ifndef MAP_SHARED_VALIDATE
+#define MAP_SHARED_VALIDATE 0x3
+#endif
+
+void err_exit(char *op)
+{
+	fprintf(stderr, "%s: %s\n", op, strerror(errno));
+	exit(1);
+}
+
+void mark_log(char *logwrites_name, char *mark_name)
+{
+	char command[256];
+
+	snprintf(command, 256, "dmsetup message %s 0 mark %s",
+			logwrites_name, mark_name);
+
+	if (system(command))
+		err_exit("mark_log");
+}
+
+int main(int argc, char *argv[])
+{
+	int page_size = getpagesize();
+	int len = MiB(1);
+	int i, fd, err;
+	char *data;
+
+	if (argc < 4) {
+		printf("Usage: %s <file> <logwrites_name> <mark_name>\n",
+				basename(argv[0]));
+		exit(0);
+	}
+
+	fd = open(argv[1], O_RDWR|O_CREAT|O_TRUNC, S_IRUSR|S_IWUSR);
+	if (fd < 0)
+		err_exit("fd");
+
+	ftruncate(fd, len);
+
+	data = mmap(NULL, len, PROT_READ|PROT_WRITE,
+			MAP_SHARED_VALIDATE|MAP_SYNC, fd, 0);
+	if (data == MAP_FAILED)
+		err_exit("mmap");
+
+	/*
+	 * We intentionally don't sync 'fd' manually.  If MAP_SYNC is working
+	 * these allocating page faults will cause the filesystem to sync its
+	 * metadata so that when we replay the dm-log-writes log the test file
+	 * will have 1 MiB worth of block allocations.
+	 *
+	 * dm-log-writes doesn't track the data that we write via the mmap(),
+	 * so we can't check that, we can only verify that the metadata writes
+	 * happened.
+	 */
+	for (i = 0; i < len; i+=page_size)
+		data[i] = 0xff;
+
+	mark_log(argv[2], argv[3]);
+
+	err = munmap(data, len);
+	if (err < 0)
+		err_exit("munmap");
+
+	err = close(fd);
+	if (err < 0)
+		err_exit("close");
+
+	return 0;
+}
diff --git a/tests/generic/466 b/tests/generic/466
new file mode 100755
index 0000000..592213f
--- /dev/null
+++ b/tests/generic/466
@@ -0,0 +1,76 @@
+#! /bin/bash
+# FS QA Test No. 466
+#
+# Use md_log_writes to verify that MAP_SYNC actually syncs metadata during
+# page faults.
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
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_log_writes_cleanup
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmlogwrites
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_log_writes
+_require_scratch_dax
+_require_test_program "t_map_sync"
+
+_log_writes_init
+_log_writes_mkfs >> $seqres.full 2>&1
+_log_writes_mount -o dax
+
+src/t_map_sync $SCRATCH_MNT/test $LOGWRITES_NAME pre_unmap
+
+# Unmount the scratch dir and tear down the log writes target
+_log_writes_unmount
+_log_writes_remove
+_check_scratch_fs
+
+# check pre-unmap state
+_log_writes_replay_log pre_unmap
+_scratch_mount
+
+# We should see $SCRATCH_MNT/test as having 1MiB in block allocations
+du -sh $SCRATCH_MNT/test | _filter_scratch | _filter_spaces
+
+_scratch_unmount
+_check_scratch_fs
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/generic/466.out b/tests/generic/466.out
new file mode 100644
index 0000000..4c54d7a
--- /dev/null
+++ b/tests/generic/466.out
@@ -0,0 +1,3 @@
+QA output created by 466
+1.0M SCRATCH_MNT/test
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index fbe0a7f..65328c6 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -468,3 +468,4 @@
 463 auto quick clone dangerous
 464 auto rw
 465 auto rw quick aio
+466 auto quick dax
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
