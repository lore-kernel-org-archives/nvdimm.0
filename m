Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C3CF220349DA3
 for <linux-nvdimm@lists.01.org>; Fri, 17 Nov 2017 12:24:26 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [fstests PATCH v4 4/4] generic: add test for DAX MAP_SYNC support
Date: Fri, 17 Nov 2017 13:28:28 -0700
Message-Id: <20171117202828.25472-5-ross.zwisler@linux.intel.com>
In-Reply-To: <20171117202828.25472-1-ross.zwisler@linux.intel.com>
References: <20171117202828.25472-1-ross.zwisler@linux.intel.com>
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
To: fstests <fstests@vger.kernel.org>
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
 tests/generic/468     | 83 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/468.out |  3 ++
 tests/generic/group   |  1 +
 3 files changed, 87 insertions(+)
 create mode 100755 tests/generic/468
 create mode 100644 tests/generic/468.out

diff --git a/tests/generic/468 b/tests/generic/468
new file mode 100755
index 0000000..fcbbf34
--- /dev/null
+++ b/tests/generic/468
@@ -0,0 +1,83 @@
+#! /bin/bash
+# FS QA Test No. 468
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
+_require_log_writes
+_require_scratch_dax
+_require_xfs_io_command "log_writes"
+
+_log_writes_init
+_log_writes_mkfs >> $seqres.full 2>&1
+_log_writes_mount -o dax
+
+LEN=$((1024 * 1024)) # 1 MiB
+
+xfs_io -t -c "truncate $LEN" -c "mmap -S 0 $LEN" -c "mwrite 0 $LEN" \
+	-c "log_writes -d $LOGWRITES_NAME -m preunmap" \
+	-f $SCRATCH_MNT/test > /dev/null 2>&1
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
+stat -c "%s" $SCRATCH_MNT/test
+
+_scratch_unmount
+_check_scratch_fs
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/generic/468.out b/tests/generic/468.out
new file mode 100644
index 0000000..5f897af
--- /dev/null
+++ b/tests/generic/468.out
@@ -0,0 +1,3 @@
+QA output created by 468
+1048576
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 9183950..c061842 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -470,3 +470,4 @@
 465 auto rw quick aio
 466 auto quick rw
 467 auto quick exportfs
+468 auto quick dax
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
