From: Xiong Zhou <xzhou@redhat.com>
Subject: [PATCH v6 2/2] generic: test mmap io through DAX and non-DAX
Date: Wed,  8 Feb 2017 12:11:18 +0800
Message-ID: <1486527078-11173-3-git-send-email-xzhou@redhat.com>
References: <20170206191717.GB12290@linux.intel.com>
 <1486527078-11173-1-git-send-email-xzhou@redhat.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1486527078-11173-1-git-send-email-xzhou@redhat.com>
Sender: fstests-owner@vger.kernel.org
To: ross.zwisler@linux.intel.com, fstests@vger.kernel.org
Cc: linux-nvdimm@ml01.01.org, jmoyer@redhat.com, eguan@redhat.com, Xiong Zhou <xzhou@redhat.com>
List-Id: linux-nvdimm@lists.01.org

Mount TEST_DEV as non-DAX, SCRATCH_DEV as DAX, then
do some IO between them. In this case we use mmap
and dio/buffered IO read/write test programme.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Xiong Zhou <xzhou@redhat.com>
---
 tests/generic/407     | 152 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/407.out |   2 +
 tests/generic/group   |   1 +
 3 files changed, 155 insertions(+)
 create mode 100755 tests/generic/407
 create mode 100644 tests/generic/407.out

diff --git a/tests/generic/407 b/tests/generic/407
new file mode 100755
index 0000000..b5b2ce4
--- /dev/null
+++ b/tests/generic/407
@@ -0,0 +1,152 @@
+#! /bin/bash
+# FS QA Test 407
+#
+# mmap direct/buffered io between DAX and non-DAX mountpoints.
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
+_supported_fs generic
+_supported_os Linux
+_require_test
+_require_scratch_dax
+_require_test_program "feature"
+_require_test_program "t_mmap_dio"
+_require_xfs_io_command "falloc"
+
+prep_files()
+{
+	rm -f $SCRATCH_MNT/tf_{s,d}
+	rm -f $TEST_DIR/tf_{s,d}
+
+	$XFS_IO_PROG -f -c "falloc 0 $tsize" \
+		$SCRATCH_MNT/tf_{s,d} >> $seqres.full 2>&1
+	$XFS_IO_PROG -f -c "falloc 0 $tsize" \
+		$TEST_DIR/tf_{s,d} >> $seqres.full 2>&1
+}
+
+t_both_dax()
+{
+	prep_files
+	# with O_DIRECT first
+	src/t_mmap_dio $SCRATCH_MNT/tf_{s,d} $1 "dio both dax"
+
+	prep_files
+	# again with buffered IO
+	src/t_mmap_dio -b $SCRATCH_MNT/tf_{s,d} \
+		$1 "buffered both dax"
+}
+
+t_nondax_to_dax()
+{
+	prep_files
+	src/t_mmap_dio $TEST_DIR/tf_s \
+		$SCRATCH_MNT/tf_d $1 "dio nondax to dax"
+
+	prep_files
+	src/t_mmap_dio -b $TEST_DIR/tf_s \
+		$SCRATCH_MNT/tf_d $1 "buffered nondax to dax"
+}
+
+t_dax_to_nondax()
+{
+	prep_files
+	src/t_mmap_dio $SCRATCH_MNT/tf_s \
+		$TEST_DIR/tf_d $1 "dio dax to nondax"
+
+	prep_files
+	src/t_mmap_dio -b $SCRATCH_MNT/tf_s \
+		$TEST_DIR/tf_d $1 "buffered dax to nondax"
+}
+
+t_both_nondax()
+{
+	prep_files
+	src/t_mmap_dio $TEST_DIR/tf_{s,d} $1 "dio both nondax"
+
+	prep_files
+	src/t_mmap_dio -b $TEST_DIR/tf_{s,d} \
+		$1 "buffered both nondax"
+}
+
+# $1 mmap read/write size
+t_mmap_dio_dax()
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
+	t_mmap_dio_dax 1024
+	# page size
+	t_mmap_dio_dax `src/feature -s`
+	# bigger sizes, for PMD faults
+	t_mmap_dio_dax $((16 * 1024 * 1024))
+	t_mmap_dio_dax $((64 * 1024 * 1024))
+}
+
+# make fs 2Mb aligned for PMD fault testing
+if [[ $FSTYP =~ ext ]] ; then
+	_scratch_mkfs "-E stride=512,stripe_width=1" \
+		> /dev/null 2>&1
+elif [[ $FSTYP =~ xfs ]] ; then
+	_scratch_mkfs "-d su=2m,sw=1" > /dev/null 2>&1
+fi
+
+# mount SCRATCH_DEV with dax option, TEST_DEV not
+export MOUNT_OPTIONS=""
+export TEST_FS_MOUNT_OPTS=""
+_test_cycle_mount
+_fs_options $TEST_DEV | grep -qw "dax" && \
+	_notrun "we need $TEST_DEV mount without dax"
+_scratch_mount "-o dax"
+
+tsize=$((128 * 1024 * 1024))
+
+do_tests
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/generic/407.out b/tests/generic/407.out
new file mode 100644
index 0000000..d05a416
--- /dev/null
+++ b/tests/generic/407.out
@@ -0,0 +1,2 @@
+QA output created by 407
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 159d691..027a238 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -409,3 +409,4 @@
 404 auto quick insert
 405 auto mkfs
 406 auto quick dangerous
+407 auto quick
-- 
1.8.3.1
