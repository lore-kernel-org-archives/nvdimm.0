Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6146B21A134AE
 for <linux-nvdimm@lists.01.org>; Thu,  4 May 2017 14:49:28 -0700 (PDT)
Subject: [PATCH v6 3/3] ndctl: add test for clear-error
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 04 May 2017 14:49:12 -0700
Message-ID: <149393455208.2642.112369988570724817.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <149393422747.2642.5136375594842641153.stgit@djiang5-desk3.ch.intel.com>
References: <149393422747.2642.5136375594842641153.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding unit test for ndctl clear-error (and list-errors)

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 test/Makefile.am              |    1 +
 test/ndctl-clear-error-dax.sh |   66 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)
 create mode 100755 test/ndctl-clear-error-dax.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index 9353a34..3cd159e 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -10,6 +10,7 @@ TESTS =\
 	clear.sh \
 	dax-errors.sh \
 	daxdev-errors.sh \
+	ndctl-clear-error-dax.sh \
 	btt-check.sh \
 	label-compat.sh \
 	blk-exhaust.sh
diff --git a/test/ndctl-clear-error-dax.sh b/test/ndctl-clear-error-dax.sh
new file mode 100755
index 0000000..1608db9
--- /dev/null
+++ b/test/ndctl-clear-error-dax.sh
@@ -0,0 +1,66 @@
+#!/bin/bash -x
+DEV=""
+NDCTL="../ndctl/ndctl"
+BUS="-b nfit_test.0"
+BUS1="-b nfit_test.1"
+json2var="s/[{}\",]//g; s/:/=/g"
+rc=77
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
+check_min_kver "4.12" || { echo "kernel $KVER lacks dax dev error handling"; exit $rc; }
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
+query=". | sort_by(.available_size) | reverse | .[0].dev"
+region=$($NDCTL list $BUS -t pmem -Ri | jq -r "$query")
+
+# create dax
+chardev="x"
+json=$($NDCTL create-namespace $BUS -r $region -t pmem -m dax -a 4096)
+chardev=$(echo $json | jq -r ". | select(.mode == \"dax\") | .daxregion.devices[0].chardev")
+[ $chardev = "x" ] && echo "fail: $LINENO" && exit 1
+
+json1=$($NDCTL list $BUS)
+eval $(sed -e "$json2var" <<< "$json1")
+
+read sector len <<< `$NDCTL list-errors -f /dev/$chardev`
+echo "sector: $sector len: $len"
+
+# clearing using ndctl
+$NDCTL clear-error -f /dev/$chardev -s $sector -l $len
+
+# check badblocks, should be empty
+read sector len <<< `$NDCTL list-errors -f /dev/$chardev`
+[ -n "$sector" ] && echo "fail: $LINENO" && exit 1
+
+echo "badblocks empty, expected"
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
