Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D741021EA15BD
 for <linux-nvdimm@lists.01.org>; Thu,  5 Oct 2017 18:52:53 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 6/8] ndctl/test: add a new unit test for inject-error
Date: Thu,  5 Oct 2017 19:54:03 -0600
Message-Id: <20171006015405.29908-7-vishal.l.verma@intel.com>
In-Reply-To: <20171006015405.29908-1-vishal.l.verma@intel.com>
References: <20171006015405.29908-1-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add a new unit test to test all the features of the inject-error
command.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/Makefile.am     |  3 +-
 test/inject-error.sh | 89 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 91 insertions(+), 1 deletion(-)
 create mode 100755 test/inject-error.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index ac3547e..8cec451 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -13,7 +13,8 @@ TESTS =\
 	multi-dax.sh \
 	btt-check.sh \
 	label-compat.sh \
-	blk-exhaust.sh
+	blk-exhaust.sh \
+	inject-error.sh
 
 check_PROGRAMS =\
 	libndctl \
diff --git a/test/inject-error.sh b/test/inject-error.sh
new file mode 100755
index 0000000..a8348df
--- /dev/null
+++ b/test/inject-error.sh
@@ -0,0 +1,89 @@
+#!/bin/bash -Ex
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
+[ -f "../ndctl/ndctl" ] && [ -x "../ndctl/ndctl" ] && ndctl="../ndctl/ndctl"
+[ -f "./ndctl/ndctl" ] && [ -x "./ndctl/ndctl" ] && ndctl="./ndctl/ndctl"
+[ -z "$ndctl" ] && echo "Couldn't find an ndctl binary" && exit 1
+bus="nfit_test.0"
+json2var="s/[{}\",]//g; s/:/=/g"
+dev=""
+mode=""
+size=""
+sector_size=""
+blockdev=""
+bs=4096
+rc=77
+
+trap 'err $LINENO' ERR
+
+# sample json:
+# {
+#   "dev":"namespace5.0",
+#   "mode":"sector",
+#   "size":32440320,
+#   "uuid":"51805176-e124-4635-ae17-0e6a4a16671a",
+#   "sector_size":4096,
+#   "blockdev":"pmem5s"
+# }
+
+# $1: Line number
+# $2: exit code
+err()
+{
+	[ -n "$2" ] && rc="$2"
+	echo "test/btt-check: failed at line $1"
+	exit "$rc"
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
+check_min_kver "4.15" || { echo "kernel $KVER may not support error injection"; exit $rc; }
+
+create()
+{
+	json=$($ndctl create-namespace -b "$bus" -t pmem -m sector)
+	eval "$(echo "$json" | sed -e "$json2var")"
+	[ -n "$dev" ] || err "$LINENO" 2
+	[ "$mode" = "sector" ] || err "$LINENO" 2
+	[ -n "$size" ] || err "$LINENO" 2
+	[ -n "$sector_size" ] || err "$LINENO" 2
+	[ -n "$blockdev" ] || err "$LINENO" 2
+	[ $size -gt 0 ] || err "$LINENO" 2
+}
+
+reset()
+{
+	$ndctl disable-region -b "$bus" all
+	$ndctl zero-labels -b "$bus" all
+	$ndctl enable-region -b "$bus" all
+}
+
+do_tests()
+{
+	# TODO
+	return
+}
+
+modprobe nfit_test
+rc=1
+create && reset
+do_tests
+reset
+exit 0
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
