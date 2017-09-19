Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 048F721CEB108
 for <linux-nvdimm@lists.01.org>; Tue, 19 Sep 2017 13:00:03 -0700 (PDT)
Subject: [ndctl PATCH 2/2] ndctl,
 test: regression test NVDIMM-N sector mode configuration
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Sep 2017 12:56:43 -0700
Message-ID: <150585100336.18300.18006925931215154678.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150585099801.18300.4357728197672633739.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150585099801.18300.4357728197672633739.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Regression test for the kernel fix for this crash report:

    Testing ndctl-58 on our NVDIMM-Ns with the latest kernel (4.13.2)
    causes a panic when configuring a pmem device from raw to sector mode.

    ndctl create-namespace -f -e namespace0.0 -m sector

    I was not able to reproduce this issue using ndctl-57. Below is the
    stack trace from configuring a pmem device from raw to sector mode.

    BUG: unable to handle kernel NULL pointer dereference at
    0000000000000028
    IP: holder_class_store+0x253/0x2b0 [libnvdimm]

This requires an NFIT test implementation that disables label support
for the DIMMs on the 'nfit_test.1' bus.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Reported-by: Maurice A. Saldivar <maurice.a.saldivar@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/Makefile.am    |    3 ++-
 test/sector-mode.sh |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 1 deletion(-)
 create mode 100755 test/sector-mode.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index ac3547e22ccb..9223628b2608 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -13,7 +13,8 @@ TESTS =\
 	multi-dax.sh \
 	btt-check.sh \
 	label-compat.sh \
-	blk-exhaust.sh
+	blk-exhaust.sh \
+	sector-mode.sh
 
 check_PROGRAMS =\
 	libndctl \
diff --git a/test/sector-mode.sh b/test/sector-mode.sh
new file mode 100755
index 000000000000..75bd3c1f82bb
--- /dev/null
+++ b/test/sector-mode.sh
@@ -0,0 +1,53 @@
+#!/bin/bash -x
+
+# Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of version 2 of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it will be useful, but
+# WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
+
+NDCTL="../ndctl/ndctl"
+BUS="-b nfit_test.0"
+BUS1="-b nfit_test.1"
+TEST=$0
+rc=77
+
+err() {
+	echo "$TEST: failed at line $1"
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
+$NDCTL disable-region $BUS1 all
+if $NDCTL zero-labels $BUS1 all; then
+	echo "DIMMs on $BUS1 support labels, skip..."
+	$NDCTL enable-region $BUS1 all
+	false
+fi
+$NDCTL enable-region $BUS1 all
+
+rc=1
+query=". | sort_by(.size) | reverse | .[0].dev"
+NAMESPACE=$($NDCTL list $BUS1 -N | jq -r "$query")
+REGION=$($NDCTL list -R --namespace=$NAMESPACE | jq -r ".dev")
+echo 0 > /sys/bus/nd/devices/$REGION/read_only
+$NDCTL create-namespace -e $NAMESPACE -m sector -f -l 4K
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
