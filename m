Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7F9842195406C
 for <linux-nvdimm@lists.01.org>; Thu, 27 Apr 2017 15:41:20 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] test: regression test for a kernel panic on running ARS for
 BTTs
Date: Thu, 27 Apr 2017 16:39:56 -0600
Message-Id: <20170427223956.9216-1-vishal.l.verma@intel.com>
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

Runing an Address Range Scrub on a region with a BTT namespace would
cause a kernel null pointer dereference. This tests we don't regress
that.

Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/Makefile.am      |  3 +-
 test/btt-ars-panic.sh | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+), 1 deletion(-)
 create mode 100755 test/btt-ars-panic.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index 9353a34..4d31a88 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -12,7 +12,8 @@ TESTS =\
 	daxdev-errors.sh \
 	btt-check.sh \
 	label-compat.sh \
-	blk-exhaust.sh
+	blk-exhaust.sh \
+	btt-ars-panic.sh
 
 check_PROGRAMS =\
 	libndctl \
diff --git a/test/btt-ars-panic.sh b/test/btt-ars-panic.sh
new file mode 100755
index 0000000..725d260
--- /dev/null
+++ b/test/btt-ars-panic.sh
@@ -0,0 +1,93 @@
+#!/bin/bash -E
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
+	echo "test/btt-ars-panic: failed at line $1"
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
+check_min_kver "4.12" || { echo "kernel $KVER is known to panic after an ARS"; exit "$rc"; }
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
+run_ars_scrub()
+{
+	query=".dev"
+	ndbus=$($ndctl list -b $bus -t pmem | jq -r "$query")
+	scrub_file="/sys/bus/nd/devices/$ndbus/nfit/scrub"
+	echo "starting scrub: $scrub_file"
+	echo 1 > "$scrub_file"
+	sleep 3
+}
+
+test_pass()
+{
+	# If the test failed, there would have been a kernel null pointer
+	# dereference, and a subsequent ndctl disable-region would hang
+	$ndctl disable-region all &
+	pid=$!
+	sleep 3
+	kill -0 $pid && { echo "Test failed, ndctl is hung after the scrub (reboot required)"; err "$LINENO" 3 ; }
+	wait
+}
+
+# setup (reset nfit_test dimms, create the BTT namespace)
+modprobe nfit_test
+rc=1
+reset && create
+run_ars_scrub
+test_pass
+exit 0
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
