Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D0ABC21B02820
 for <linux-nvdimm@lists.01.org>; Thu,  7 Dec 2017 15:15:27 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [fstests PATCH v6 2/2] generic: add test for DAX MAP_SYNC support
Date: Thu,  7 Dec 2017 16:19:50 -0700
Message-Id: <20171207231950.9023-1-ross.zwisler@linux.intel.com>
In-Reply-To: <20171207103657.GF2749@eguan.usersys.redhat.com>
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
To: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

This test creates a file and writes to it via an mmap(), but never syncs
via fsync/msync.  This process is tracked via dm-log-writes, then replayed.

If MAP_SYNC is working the dm-log-writes replay will show the test file
with 1 MiB of on-media block allocations.  This is because each allocating
page fault included an implicit metadata sync.  If MAP_SYNC isn't working
(which you can test by removing the "-S" flag to xfs_io mmap) the file
will be smaller or missing entirely.

Note that dm-log-writes doesn't track the data that we write via the
mmap(), so we can't do any data integrity checking.  We can only verify
that the metadata writes for the page faults happened.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

---

Changes since v5:
 - Addressed Eryu's comments.  Thanks for the review.

---
 common/dmlogwrites    | 19 ++++++++++++
 tests/generic/999     | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999.out |  2 ++
 tests/generic/group   |  1 +
 4 files changed, 102 insertions(+)
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out

diff --git a/common/dmlogwrites b/common/dmlogwrites
index 05829dbc..c235ee49 100644
--- a/common/dmlogwrites
+++ b/common/dmlogwrites
@@ -28,6 +28,25 @@ _require_log_writes()
 	_require_test_program "log-writes/replay-log"
 }
 
+_require_log_writes_dax()
+{
+	[ -z "$LOGWRITES_DEV" -o ! -b "$LOGWRITES_DEV" ] && \
+		_notrun "This test requires a valid \$LOGWRITES_DEV"
+
+	_require_dm_target log-writes
+	_require_test_program "log-writes/replay-log"
+
+	_log_writes_init
+	_log_writes_mkfs > /dev/null 2>&1
+	_log_writes_mount -o dax
+	# Check options to be sure. XFS ignores dax option
+	# and goes on if dev underneath does not support dax.
+	_fs_options $LOGWRITES_DMDEV | grep -qw "dax" || \
+		_notrun "$LOGWRITES_DMDEV $FSTYP does not support -o dax"
+	_log_writes_unmount
+	_log_writes_remove
+}
+
 _log_writes_init()
 {
 	local BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
diff --git a/tests/generic/999 b/tests/generic/999
new file mode 100755
index 00000000..e20faa8f
--- /dev/null
+++ b/tests/generic/999
@@ -0,0 +1,80 @@
+#! /bin/bash
+# FS QA Test No. 999
+#
+# Use dm-log-writes to verify that MAP_SYNC actually syncs metadata during
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
+_require_scratch
+_require_log_writes_dax
+_require_xfs_io_command "mmap" "-S"
+_require_xfs_io_command "log_writes"
+
+_log_writes_init
+_log_writes_mkfs >> $seqres.full 2>&1
+_log_writes_mount -o dax
+
+LEN=$((1024 * 1024)) # 1 MiB
+
+$XFS_IO_PROG -t -c "truncate $LEN" -c "mmap -S 0 $LEN" -c "mwrite 0 $LEN" \
+	-c "log_writes -d $LOGWRITES_NAME -m preunmap" \
+	-f $SCRATCH_MNT/test
+
+# Unmount the scratch dir and tear down the log writes target
+_log_writes_unmount
+_log_writes_remove
+_check_scratch_fs
+
+# destroy previous filesystem so we can be sure our rebuild works
+_scratch_mkfs >> $seqres.full 2>&1
+
+# check pre-unmap state
+_log_writes_replay_log preunmap
+_scratch_mount
+
+# We should see $SCRATCH_MNT/test as having 1 MiB in block allocations
+du -sh $SCRATCH_MNT/test | _filter_scratch | _filter_spaces
+
+status=0
+exit
diff --git a/tests/generic/999.out b/tests/generic/999.out
new file mode 100644
index 00000000..611289b6
--- /dev/null
+++ b/tests/generic/999.out
@@ -0,0 +1,2 @@
+QA output created by 999
+1.0M SCRATCH_MNT/test
diff --git a/tests/generic/group b/tests/generic/group
index 6c3bb03a..ae88aa03 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -472,3 +472,4 @@
 467 auto quick exportfs
 468 shutdown auto quick metadata
 469 auto quick
+999 auto quick dax
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
