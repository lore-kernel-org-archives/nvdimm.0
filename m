Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0B12621EB526B
 for <linux-nvdimm@lists.01.org>; Wed, 30 Aug 2017 21:07:12 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [fstests v2] generic: add test for executables on read-only DAX mounts
Date: Wed, 30 Aug 2017 22:09:10 -0600
Message-Id: <20170831040910.25015-1-ross.zwisler@linux.intel.com>
In-Reply-To: <20170830105930.GE27835@eguan.usersys.redhat.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, Randy Dodgen <rdodgen@gmail.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

This adds a regression test for the following kernel patch:

commit 42d4a99b09cb ("ext4: fix fault handling when mounted with -o dax,ro")

The above patch fixes an issue with ext4 where executables cannot be run on
read-only filesystems mounted with the DAX option.

This issue does not appear to be present in ext2 or XFS, as they both pass
the test.  I've also confirmed outside of the test that they are both
indeed able to execute binaries on read-only DAX mounts.

Thanks to Randy Dodgen for the bug report and reproduction steps.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Randy Dodgen <rdodgen@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>

---

Changes in v2:
 - A bunch of cleanup and simplifications from Eryu.
---
 tests/generic/451     | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/451.out |  3 +++
 tests/generic/group   |  1 +
 3 files changed, 77 insertions(+)
 create mode 100755 tests/generic/451
 create mode 100644 tests/generic/451.out

diff --git a/tests/generic/451 b/tests/generic/451
new file mode 100755
index 0000000..785c52e
--- /dev/null
+++ b/tests/generic/451
@@ -0,0 +1,73 @@
+#! /bin/bash
+# FS QA Test 451
+#
+# This is a regression test for kernel patch:
+#   commit 42d4a99b09cb ("ext4: fix fault handling when mounted with -o dax,ro")
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
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+
+# we need to be able to execute binaries on scratch
+_exclude_scratch_mount_option "noexec"
+
+# real QA test starts here
+# format and mount
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+LS=$(which ls --skip-alias --skip-functions)
+SCRATCH_LS=$SCRATCH_MNT/ls_on_scratch
+cp $LS $SCRATCH_LS
+
+$SCRATCH_LS $SCRATCH_LS | _filter_scratch
+
+_scratch_remount ro
+
+$SCRATCH_LS $SCRATCH_LS | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/451.out b/tests/generic/451.out
new file mode 100644
index 0000000..70e3126
--- /dev/null
+++ b/tests/generic/451.out
@@ -0,0 +1,3 @@
+QA output created by 451
+SCRATCH_MNT/ls_on_scratch
+SCRATCH_MNT/ls_on_scratch
diff --git a/tests/generic/group b/tests/generic/group
index 044ec3f..45f5789 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -453,3 +453,4 @@
 448 auto quick rw
 449 auto quick acl enospc
 450 auto quick rw
+451 auto quick
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
