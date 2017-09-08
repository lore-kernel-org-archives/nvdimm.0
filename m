Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CC55521A143F5
 for <linux-nvdimm@lists.01.org>; Fri,  8 Sep 2017 14:19:09 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] xfs: add regression test for DAX mount option usage
Date: Fri,  8 Sep 2017 15:21:53 -0600
Message-Id: <20170908212153.14880-1-ross.zwisler@linux.intel.com>
In-Reply-To: <20170908152805.GA16646@linux.intel.com>
References: <20170908152805.GA16646@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, "Darrick J.  Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

This adds a regression test for the following kernel patch:

  xfs: always use DAX if mount option is used

This test will also pass with kernel v4.14-rc1 and beyond because the XFS
DAX I/O mount option has been disabled (but not removed), so the
"chattr -x" to turn off DAX doesn't actually do anything.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
---
 tests/xfs/431     | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/431.out |  3 +++
 tests/xfs/group   |  1 +
 3 files changed, 85 insertions(+)
 create mode 100755 tests/xfs/431
 create mode 100644 tests/xfs/431.out

diff --git a/tests/xfs/431 b/tests/xfs/431
new file mode 100755
index 0000000..4ff3a02
--- /dev/null
+++ b/tests/xfs/431
@@ -0,0 +1,81 @@
+#! /bin/bash
+# FS QA Test xfs/431
+#
+# This is a regression test for kernel patch:
+# 	xfs: always use DAX if mount option is used
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
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# Modify as appropriate.
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_dax
+
+# real QA test starts here
+# format and mount
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount "-o dax" >> $seqres.full 2>&1
+
+pgsize=`$here/src/feature -s`
+
+# disable tracing, clear the existing trace buffer and turn on dax tracepoints
+echo 0 > /sys/kernel/debug/tracing/tracing_on
+echo > /sys/kernel/debug/tracing/trace
+echo 1 > /sys/kernel/debug/tracing/events/fs_dax/enable
+
+# enable tracing for our one mmap I/O, then see if dax was used
+echo 1 > /sys/kernel/debug/tracing/tracing_on
+xfs_io  -t -c "truncate $pgsize" \
+	-c "chattr -x" \
+	-c "mmap -r 0 $pgsize" -c "mread 0 $pgsize" -c "munmap" \
+	-f $SCRATCH_MNT/testfile >> $seqres.full
+echo 0 > /sys/kernel/debug/tracing/tracing_on
+
+grep -q 'xfs_io.*dax_load_hole' /sys/kernel/debug/tracing/trace
+if [[ $? == 0 ]]; then
+	echo "DAX was used"
+else
+	echo "DAX was NOT used"
+fi
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/xfs/431.out b/tests/xfs/431.out
new file mode 100644
index 0000000..265dc46
--- /dev/null
+++ b/tests/xfs/431.out
@@ -0,0 +1,3 @@
+QA output created by 431
+DAX was used
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index 0a449b9..4e7019c 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -427,3 +427,4 @@
 428 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 429 dangerous_fuzzers dangerous_scrub dangerous_repair
 430 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+431 auto quick
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
