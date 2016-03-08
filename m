Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id B45131A1F4F
 for <linux-nvdimm@lists.01.org>; Tue,  8 Mar 2016 15:37:49 -0800 (PST)
Subject: [ndctl PATCH 8/8] ndctl: test clear poison
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 08 Mar 2016 15:37:09 -0800
Message-ID: <20160308233709.18628.37210.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160308233628.18628.13786.stgit@dwillia2-desk3.jf.intel.com>
References: <20160308233628.18628.13786.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Now that nfit_test arranges for poison to be injected into the middle of
pmem ranges, add the following tests:

1/ Expect errors to be present and cause I/O failures

2/ Expect writes to those sectors to clear poison

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Makefile.am   |    3 ++-
 test/clear.sh |   67 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+), 1 deletion(-)
 create mode 100755 test/clear.sh

diff --git a/Makefile.am b/Makefile.am
index c8ce3177e5a2..ce97a15c7c0d 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -141,7 +141,8 @@ pkgconfig_DATA = lib/libndctl.pc
 EXTRA_DIST += lib/libndctl.pc.in
 CLEANFILES += lib/libndctl.pc
 
-TESTS = test/libndctl test/dpa-alloc test/parent-uuid test/create.sh
+TESTS = test/libndctl test/dpa-alloc test/parent-uuid test/create.sh \
+	test/clear.sh
 check_PROGRAMS = test/libndctl test/dpa-alloc test/parent-uuid
 
 if ENABLE_DESTRUCTIVE
diff --git a/test/clear.sh b/test/clear.sh
new file mode 100755
index 000000000000..e74522201231
--- /dev/null
+++ b/test/clear.sh
@@ -0,0 +1,67 @@
+#!/bin/bash -x
+DEV=""
+NDCTL="./ndctl"
+BUS="-b nfit_test.0"
+BUS1="-b nfit_test.1"
+json2var="s/[{}\",]//g; s/:/=/g"
+rc=77
+
+set -e
+
+err() {
+	echo "test/clear: failed at line $1"
+	exit $rc
+}
+
+set -e
+trap 'err $LINENO' ERR
+
+# setup (reset nfit_test dimms)
+modprobe nfit_test
+$NDCTL disable-region $BUS all
+$NDCTL zero-labels $BUS all
+$NDCTL enable-region $BUS all
+
+rc=1
+
+# create pmem
+dev="x"
+json=$($NDCTL create-namespace $BUS -t pmem -m raw)
+eval $(echo $json | sed -e "$json2var")
+[ $dev = "x" ] && echo "fail: $LINENO" && exit 1
+[ $mode != "raw" ] && echo "fail: $LINENO" && exit 1
+
+# check for expected errors in the middle of the namespace
+read sector len < /sys/block/$blockdev/badblocks
+[ $((sector * 2)) -ne $((size /512)) ] && echo "fail: $LINENO" && exit 1
+if dd if=/dev/$blockdev of=/dev/null iflag=direct bs=512 skip=$sector count=$len; then
+	echo "fail: $LINENO" && exit 1
+fi
+
+size_raw=$size
+sector_raw=$sector
+
+# convert pmem to memory mode
+json=$($NDCTL create-namespace -m memory -f -e $dev)
+eval $(echo $json | sed -e "$json2var")
+[ $mode != "memory" ] && echo "fail: $LINENO" && exit 1
+
+# check for errors relative to the offset injected by the pfn device
+read sector len < /sys/block/$blockdev/badblocks
+[ $((sector_raw - sector)) -ne $(((size_raw - size) / 512)) ] && echo "fail: $LINENO" && exit 1
+
+# check that writing clears the errors
+if ! dd of=/dev/$blockdev if=/dev/zero oflag=direct bs=512 seek=$sector count=$len; then
+	echo "fail: $LINENO" && exit 1
+fi
+
+if read sector len < /sys/block/$blockdev/badblocks; then
+	# fail if reading badblocks returns data
+	echo "fail: $LINENO" && exit 1
+fi
+
+$NDCTL disable-region $BUS all
+$NDCTL disable-region $BUS1 all
+modprobe -r nfit_test
+
+exit 0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
