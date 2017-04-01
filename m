Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 795A92193930C
 for <linux-nvdimm@lists.01.org>; Sat,  1 Apr 2017 12:33:12 -0700 (PDT)
Subject: [ndctl PATCH] test: blk allocation exhaustion
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 01 Apr 2017 12:28:02 -0700
Message-ID: <149107488272.16325.8536491917958323727.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Test that the kernel properly accounts for all blk allocations when all
aliased pmem is allocated before un-aliased blk. This targets a
regression that was introduced with commit a1f3e4d6a0c3 ("libnvdimm,
region: update nd_region_available_dpa() for multi-pmem support").

Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/Makefile.am    |    3 ++-
 test/blk-exhaust.sh |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 1 deletion(-)
 create mode 100755 test/blk-exhaust.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index d2a0cf9fe2ba..4567f7465ebd 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -10,7 +10,8 @@ TESTS =\
 	clear.sh \
 	dax-errors.sh \
 	btt-check.sh \
-	label-compat.sh
+	label-compat.sh \
+	blk-exhaust.sh
 
 check_PROGRAMS =\
 	libndctl \
diff --git a/test/blk-exhaust.sh b/test/blk-exhaust.sh
new file mode 100755
index 000000000000..24a1ec216767
--- /dev/null
+++ b/test/blk-exhaust.sh
@@ -0,0 +1,47 @@
+#!/bin/bash -x
+NDCTL="../ndctl/ndctl"
+BUS="-b nfit_test.0"
+BUS1="-b nfit_test.1"
+rc=77
+
+set -e
+
+err() {
+	echo "test/label-compat.sh: failed at line $1"
+	exit $rc
+}
+
+check_min_kver()
+{
+	local ver="$1"
+	: "${KVER:=$(uname -r)}"
+
+	[ -n "$ver" ] || return 1
+	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
+}
+
+check_min_kver "4.11" || { echo "kernel $KVER may lack blk-exhaustion fix"; exit $rc; }
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
+# if the kernel accounting is correct we should be able to create two
+# pmem and two blk namespaces on nfit_test.0
+rc=1
+$NDCTL create-namespace $BUS -t pmem
+$NDCTL create-namespace $BUS -t pmem
+$NDCTL create-namespace $BUS -t blk -m raw
+$NDCTL create-namespace $BUS -t blk -m raw
+
+# clearnup and exit
+$NDCTL disable-region $BUS all
+$NDCTL disable-region $BUS1 all
+modprobe -r nfit_test
+
+exit 0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
