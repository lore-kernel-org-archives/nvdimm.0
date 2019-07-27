Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 05E1E212E259E
 for <linux-nvdimm@lists.01.org>; Sat, 27 Jul 2019 14:58:12 -0700 (PDT)
Subject: [ndctl PATCH v2 24/26] ndctl/test: Regression test 'failed to track'
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 27 Jul 2019 14:41:28 -0700
Message-ID: <156426368860.531577.4971154560351562053.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <156426356088.531577.14828880045306313118.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <156426356088.531577.14828880045306313118.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Exercise the failing condition behind kernel commit c4703ce11c23
"libnvdimm/namespace: Fix label tracking error", i.e. rename (change
uuid) allocated namespace capacity.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/Makefile.am   |    3 ++-
 test/track-uuid.sh |   41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 1 deletion(-)
 create mode 100755 test/track-uuid.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index decc8377258a..782b01cc4a97 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -25,7 +25,8 @@ TESTS =\
 	inject-smart.sh \
 	monitor.sh \
 	max_available_extent_ns.sh \
-	pfn-meta-errors.sh
+	pfn-meta-errors.sh \
+	track-uuid.sh
 
 check_PROGRAMS =\
 	libndctl \
diff --git a/test/track-uuid.sh b/test/track-uuid.sh
new file mode 100755
index 000000000000..ece11193f01d
--- /dev/null
+++ b/test/track-uuid.sh
@@ -0,0 +1,41 @@
+#!/bin/bash -Ex
+
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2018 Intel Corporation. All rights reserved.
+
+blockdev=""
+rc=77
+
+. ./common
+
+set -e
+trap 'err $LINENO' ERR
+
+# setup (reset nfit_test dimms)
+modprobe nfit_test
+$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
+$NDCTL enable-region -b $NFIT_TEST_BUS0 all
+
+rc=1
+
+# create a fsdax namespace and clear errors (if any)
+dev="x"
+json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -t pmem -m raw)
+eval "$(echo "$json" | json2var)"
+[ $dev = "x" ] && echo "fail: $LINENO" && exit 1
+
+$NDCTL disable-namespace $dev
+# On broken kernels this reassignment of capacity triggers a warning
+# with the following signature, and results in ENXIO.
+#     WARNING: CPU: 11 PID: 1378 at drivers/nvdimm/label.c:721 __pmem_label_update+0x55d/0x570 [libnvdimm]
+#     Call Trace:
+#      nd_pmem_namespace_label_update+0xd6/0x160 [libnvdimm]
+#      uuid_store+0x15c/0x170 [libnvdimm]
+#      kernfs_fop_write+0xf0/0x1a0
+#      __vfs_write+0x26/0x150
+uuidgen > /sys/bus/nd/devices/$dev/uuid
+$NDCTL enable-namespace $dev
+
+_cleanup
+exit 0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
