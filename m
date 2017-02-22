Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6B1C98224D
 for <linux-nvdimm@lists.01.org>; Wed, 22 Feb 2017 14:48:46 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 3/3] ndctl, test: Add a unit test for the BTT checker
Date: Wed, 22 Feb 2017 15:47:24 -0700
Message-Id: <20170222224724.7696-4-vishal.l.verma@intel.com>
In-Reply-To: <20170222224724.7696-1-vishal.l.verma@intel.com>
References: <20170222224724.7696-1-vishal.l.verma@intel.com>
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

Add a new unit test that will set up BTTs, corrupt them in known ways,
and test that the checker is able to detect or repair the corruption in
the expected way.

Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/Makefile.am  |   5 +-
 test/btt-check.sh | 167 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 171 insertions(+), 1 deletion(-)
 create mode 100755 test/btt-check.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index 524fafa..73c4463 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -8,7 +8,8 @@ TESTS =\
 	multi-pmem \
 	create.sh \
 	clear.sh \
-	dax-errors.sh
+	dax-errors.sh \
+	btt-check.sh
 
 check_PROGRAMS =\
 	libndctl \
@@ -78,6 +79,7 @@ device_dax_SOURCES = \
 		dax-pmd.c \
 		$(testcore) \
 		../ndctl/builtin-xaction-namespace.c \
+		../ndctl/builtin-check.c \
 		../util/json.c
 device_dax_LDADD = \
 		$(LIBNDCTL_LIB) \
@@ -89,6 +91,7 @@ multi_pmem_SOURCES = \
 		multi-pmem.c \
 		$(testcore) \
 		../ndctl/builtin-xaction-namespace.c \
+		../ndctl/builtin-check.c \
 		../util/json.c
 multi_pmem_LDADD = \
 		$(LIBNDCTL_LIB) \
diff --git a/test/btt-check.sh b/test/btt-check.sh
new file mode 100755
index 0000000..7df5fb1
--- /dev/null
+++ b/test/btt-check.sh
@@ -0,0 +1,167 @@
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
+bs=4096
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
+	[ -n "$2" ] && rc="$2" || rc=1
+	echo "test/btt-check: failed at line $1"
+	exit "$rc"
+}
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
+# re-enable the BTT namespace, and do IO to it in an attempt to
+# verify it still comes up ok, and functions as expected
+post_repair_test()
+{
+	echo "${FUNCNAME[0]}: I/O to BTT namespace"
+	test -b /dev/$blockdev
+	dd if=/dev/zero of=/dev/$blockdev bs=$sector_size count=$((size/sector_size)) > /dev/null 2>&1
+	dd if=/dev/$blockdev of=/dev/null bs=$sector_size count=$((size/sector_size)) > /dev/null 2>&1
+	echo "done"
+}
+
+test_normal()
+{
+	echo "=== ${FUNCNAME[0]} ==="
+	# disable the namespace
+	$ndctl disable-namespace $dev
+	$ndctl check-namespace $dev
+	$ndctl enable-namespace $dev
+	post_repair_test
+}
+
+test_force()
+{
+	echo "=== ${FUNCNAME[0]} ==="
+	$ndctl check-namespace --force $dev
+	post_repair_test
+}
+
+set_raw()
+{
+	$ndctl disable-namespace $dev
+	echo -n "set raw_mode: "
+	echo 1 | tee /sys/bus/nd/devices/$dev/force_raw
+	$ndctl enable-namespace $dev
+	raw_bdev="${blockdev%%s}"
+	test -b /dev/$raw_bdev
+	raw_size="$(cat /sys/bus/nd/devices/$dev/size)"
+}
+
+unset_raw()
+{
+	$ndctl disable-namespace $dev
+	echo -n "set raw_mode: "
+	echo 0 | tee /sys/bus/nd/devices/$dev/force_raw
+	$ndctl enable-namespace $dev
+	raw_bdev=""
+}
+
+test_bad_info2()
+{
+	echo "=== ${FUNCNAME[0]} ==="
+	set_raw
+	seek="$((raw_size/bs - 1))"
+	echo "wiping info2 block (offset = $seek blocks)"
+	dd if=/dev/zero of=/dev/$raw_bdev bs=$bs count=1 seek=$seek
+	unset_raw
+	$ndctl disable-namespace $dev
+	$ndctl check-namespace $dev 2>&1 | grep "info2 needs to be restored"
+	$ndctl check-namespace --repair $dev
+	$ndctl enable-namespace $dev
+	post_repair_test
+}
+
+test_bad_info()
+{
+	echo "=== ${FUNCNAME[0]} ==="
+	set_raw
+	echo "wiping info block"
+	dd if=/dev/zero of=/dev/$raw_bdev bs=$bs count=1 seek=1
+	unset_raw
+	$ndctl disable-namespace $dev
+	$ndctl check-namespace $dev 2>&1 | grep "info block at offset 0 needs to be restored"
+	$ndctl check-namespace --repair $dev
+	$ndctl enable-namespace $dev
+	post_repair_test
+}
+
+test_bitmap()
+{
+	echo "=== ${FUNCNAME[0]} ==="
+	reset && create
+	set_raw
+	# scribble over the last 4K of the map
+	rm -f /tmp/scribble
+	for (( i=0 ; i<512 ; i++ )); do
+		echo -n -e \\x1e\\x1e\\x00\\xc0\\x1e\\x1e\\x00\\xc0 >> /tmp/scribble
+	done
+	seek="$((raw_size/bs - (256*64/bs) - 2))"
+	echo "scribbling over map entries (offset = $seek blocks)"
+	dd if=/tmp/scribble of=/dev/$raw_bdev bs=$bs seek=$seek
+	rm -f /tmp/scribble
+	unset_raw
+	$ndctl disable-namespace $dev
+	$ndctl check-namespace $dev 2>&1 | grep "bitmap error"
+	# This is not repairable
+	reset && create
+}
+
+do_tests()
+{
+	test_normal
+	test_force
+	test_bad_info2
+	test_bad_info
+	test_bitmap
+}
+
+# setup (reset nfit_test dimms, create the BTT namespace)
+modprobe nfit_test
+reset && create
+do_tests
+reset
+exit 0
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
