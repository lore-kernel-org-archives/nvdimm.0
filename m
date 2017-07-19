Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D997221D1B280
 for <linux-nvdimm@lists.01.org>; Wed, 19 Jul 2017 11:37:57 -0700 (PDT)
Subject: [ndctl PATCH 6/6] test: add multi-dax test
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Jul 2017 11:33:27 -0700
Message-ID: <150048920777.12895.10251738236110732171.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150048917662.12895.15953645444185664230.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150048917662.12895.15953645444185664230.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Add a simple sanity check for multiple dax instances per
libnvdimm-region support. This is known to fail with a sysfs duplicate
filename warning on kernels prior to 4.13-final.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/Makefile.am  |    1 +
 test/multi-dax.sh |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)
 create mode 100755 test/multi-dax.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index 9353a34326c1..ac3547e22ccb 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -10,6 +10,7 @@ TESTS =\
 	clear.sh \
 	dax-errors.sh \
 	daxdev-errors.sh \
+	multi-dax.sh \
 	btt-check.sh \
 	label-compat.sh \
 	blk-exhaust.sh
diff --git a/test/multi-dax.sh b/test/multi-dax.sh
new file mode 100755
index 000000000000..751f16f5b07b
--- /dev/null
+++ b/test/multi-dax.sh
@@ -0,0 +1,61 @@
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
+DEV=""
+NDCTL="../ndctl/ndctl"
+DAXCTL="../daxctl/daxctl"
+BUS="-b nfit_test.0"
+BUS1="-b nfit_test.1"
+json2var="s/[{}\",]//g; s/:/=/g"
+rc=77
+
+err() {
+	rc=1
+	echo "test/multi-dax: failed at line $1"
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
+check_min_kver "4.13" || { echo "kernel $KVER may lack multi-dax support"; exit $rc; }
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
+query=". | sort_by(.available_size) | reverse | .[0].dev"
+region=$($NDCTL list $BUS -t pmem -Ri | jq -r "$query")
+
+json=$($NDCTL create-namespace $BUS -r $region -t pmem -m dax -a 4096 -s 16M)
+chardev1=$(echo $json | jq ". | select(.mode == \"dax\") | .daxregion.devices[0].chardev")
+json=$($NDCTL create-namespace $BUS -r $region -t pmem -m dax -a 4096 -s 16M)
+chardev2=$(echo $json | jq ". | select(.mode == \"dax\") | .daxregion.devices[0].chardev")
+
+# cleanup
+$NDCTL disable-region $BUS all
+$NDCTL disable-region $BUS1 all
+modprobe -r nfit_test
+
+exit 0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
