Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C64ED21A18AA9
 for <linux-nvdimm@lists.01.org>; Mon, 27 Mar 2017 21:09:02 -0700 (PDT)
Subject: [PATCH] test: add fio test for device-dax
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 27 Mar 2017 21:03:52 -0700
Message-ID: <149067383236.19079.12786890634892425193.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Jeff found that device-dax was broken with respect to falling back to
smaller fault granularities. Now that the fixes are upstream ([1], [2]),
add a test to backstop against future regressions and validate
backports.

Note that kernels without device-dax pud-mapping support will always
fail the alignment == 1GiB test. Kernels with the broken fallback
handling will fail the first alignment == 4KiB test.

The test requires an fio binary with support for the "dev-dax" ioengine.

[1]: commit 70b085b06c45 ("device-dax: fix pud fault fallback handling")
[2]: commit 0134ed4fb9e7 ("device-dax: fix pmd/pte fault fallback handling")
Cc: Dave Jiang <dave.jiang@intel.com>
Reported-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/Makefile.am       |    1 +
 test/device-dax-fio.sh |   74 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)
 create mode 100755 test/device-dax-fio.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index 98f444231306..969fe055b35e 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -26,6 +26,7 @@ TESTS +=\
 	dax-dev \
 	dax.sh \
 	device-dax \
+	device-dax-fio.sh \
 	mmap.sh
 
 check_PROGRAMS +=\
diff --git a/test/device-dax-fio.sh b/test/device-dax-fio.sh
new file mode 100755
index 000000000000..ab620b67027f
--- /dev/null
+++ b/test/device-dax-fio.sh
@@ -0,0 +1,74 @@
+#!/bin/bash
+NDCTL="../ndctl/ndctl"
+rc=77
+
+set -e
+
+err() {
+	echo "test/device-dax-fio.sh: failed at line $1"
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
+check_min_kver "4.11" || { echo "kernel $KVER may lack latest device-dax fixes"; exit $rc; }
+
+set -e
+trap 'err $LINENO' ERR
+
+if ! fio --enghelp | grep -q "dev-dax"; then
+	echo "fio lacks dev-dax engine"
+	exit 77
+fi
+
+dev=$(./dax-dev)
+for align in 4k 2m 1g
+do
+	json=$($NDCTL create-namespace -m dax -a $align -f -e $dev)
+	chardev=$(echo $json | jq -r ". | select(.mode == \"dax\") | .daxregion.devices[0].chardev")
+	if [ align = "1g" ]; then
+		bs="1g"
+	else
+		bs="2m"
+	fi
+
+	cat > fio.job <<- EOF
+		[global]
+		ioengine=dev-dax
+		direct=0
+		filename=/dev/${chardev}
+		verify=crc32c
+		bs=${bs}
+
+		[write]
+		rw=write
+		runtime=5
+
+		[read]
+		stonewall
+		rw=read
+		runtime=5
+	EOF
+
+	rc=1
+	fio fio.job 2>&1 | tee fio.log
+
+	if grep -q "fio.*got signal" fio.log; then
+		echo "test/device-dax-fio.sh: failed with align: $align"
+		exit 1
+	fi
+
+	# revert namespace to raw mode
+	json=$($NDCTL create-namespace -m raw -f -e $dev)
+	mode=$(echo $json | jq -r ".mode")
+	[ $mode != "memory" ] && echo "fail: $LINENO" && exit 1
+done
+
+exit 0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
