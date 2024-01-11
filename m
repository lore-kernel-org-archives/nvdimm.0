Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA0655C2E
	for <nvdimm@lists.linux.dev>; Thu, 11 Jan 2024 23:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k9D/kS0m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705014067; x=1736550067;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:to:cc;
  bh=Rlrnly6chOmqdGtuPDW/JrMHkVi3SX2jvpaqcTRxNaQ=;
  b=k9D/kS0m/DHZ447/qOLqyo8dnPMJn7PZ9J7cNmPxgKOlVN9157MR69ij
   K+DwEf1lcG3qN6QzQtxnhUI7zKZe3hIyW93dzM2fA5E/fG69H41TWZ6Eh
   mX9cpBWOFZ4Kr9C6oACR7E911VcayxT+5rm1lujoUMySyyka208mqcaHU
   JZ1l9UMPlJSX+fLusXkUp3sjFy6bwh5g53LmKPxo/RiD1zybUiM5fjboU
   NKaKD9jvGHYaOPEfsj9E9y71cquhvZPuN6BXY7L9piAm0MS/pXIzHahO5
   4xU7ToO2ECGfHHogxPbI3QGmmSUDJ1uKLfRogDEn65bC+ea+VkIx0ZoDs
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="398705228"
X-IronPort-AV: E=Sophos;i="6.04,187,1695711600"; 
   d="scan'208";a="398705228"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 15:00:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="775792615"
X-IronPort-AV: E=Sophos;i="6.04,187,1695711600"; 
   d="scan'208";a="775792615"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.89.200])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2024 15:00:56 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Thu, 11 Jan 2024 16:00:53 -0700
Subject: [PATCH ndctl v2] test/daxctl-create.sh: remove region and dax
 device assumptions
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240111-vv-daxctl-create-v2-1-1052c8390c5d@intel.com>
X-B4-Tracking: v=1; b=H4sIACRzoGUC/32NQQrCMBBFr1Jm7Ugm2Jq68h7SRUimdqCmkoRQK
 b27sQdw+R789zdIHIUT3JoNIhdJsoQK+tSAm2x4MoqvDFrpiyJSWAp6u7o8o4tsM6Pr7JWpV0b
 3HdTZO/Io65F8DJUnSXmJn+Oh0M/+iRVCQkVj61tjR+fNXULm+eyWFwz7vn8BXQ6p8LAAAAA=
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Joao Martins <joao.m.martins@oracle.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.13-dev-433a8
X-Developer-Signature: v=1; a=openpgp-sha256; l=8014;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=Rlrnly6chOmqdGtuPDW/JrMHkVi3SX2jvpaqcTRxNaQ=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDKkLilVdnxqefeAo+mCL9QTtlWscLd79/lurukiKzyJyc
 ejV/A+dHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZgI1z1Ghq50tX4ex69fwgzW
 XDi0jkE6MSd20rm12pp/m0Wur0yZfJaRYWsUv3jlsmNP9MS/q8kcamhzKGJOnfhu7jWrMBnOmXv
 b+AE=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

The daxctl-create.sh test had some hard-coded assumptions about what dax
device it expects to find, and what region number it will be under. This
usually worked when the unit test environment only had efi_fake_mem
devices as the sources of hmem memory. With CXL however, the region
numbering namespace is shared with CXL regions, often pushing the
efi_fake_mem region to something other than 'region0'.

Remove any region and device number assumptions from this test so it
works regardless of how regions get enumerated.

Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
Changes in v2:
- Fix hmem region selection in case the first dax region is not an hmem
  one (Dan)
- Link to v1: https://lore.kernel.org/r/20240110-vv-daxctl-create-v1-1-01f5d58afcd8@intel.com
---
 test/daxctl-create.sh | 58 ++++++++++++++++++++++++++-------------------------
 1 file changed, 30 insertions(+), 28 deletions(-)

diff --git a/test/daxctl-create.sh b/test/daxctl-create.sh
index d319a39..c093cb9 100755
--- a/test/daxctl-create.sh
+++ b/test/daxctl-create.sh
@@ -29,14 +29,14 @@ find_testdev()
 	fi
 
 	# find a victim region provided by dax_hmem
-	testpath=$("$DAXCTL" list -r 0 | jq -er '.[0].path | .//""')
-	if [[ ! "$testpath" == *"hmem"* ]]; then
+	region_id="$("$DAXCTL" list -R | jq -r '.[] | select(.path | contains("hmem")) | .id')"
+	if [[ ! "$region_id" ]]; then
 		printf "Unable to find a victim region\n"
 		exit "$rc"
 	fi
 
 	# find a victim device
-	testdev=$("$DAXCTL" list -D -r 0 | jq -er '.[0].chardev | .//""')
+	testdev=$("$DAXCTL" list -D -r "$region_id" | jq -er '.[0].chardev | .//""')
 	if [[ ! $testdev  ]]; then
 		printf "Unable to find a victim device\n"
 		exit "$rc"
@@ -56,9 +56,10 @@ setup_dev()
 		exit "$rc"
 	fi
 
+	"$DAXCTL" reconfigure-device -m devdax -f "$testdev"
 	"$DAXCTL" disable-device "$testdev"
 	"$DAXCTL" reconfigure-device -s 0 "$testdev"
-	available=$("$DAXCTL" list -r 0 | jq -er '.[0].available_size | .//""')
+	available=$("$DAXCTL" list -r "$region_id" | jq -er '.[0].available_size | .//""')
 }
 
 reset_dev()
@@ -74,8 +75,8 @@ reset_dax()
 {
 	test -n "$testdev"
 
-	"$DAXCTL" disable-device -r 0 all
-	"$DAXCTL" destroy-device -r 0 all
+	"$DAXCTL" disable-device -r "$region_id" all
+	"$DAXCTL" destroy-device -r "$region_id" all
 	"$DAXCTL" reconfigure-device -s "$available" "$testdev"
 }
 
@@ -90,7 +91,7 @@ test_pass()
 	local rc=1
 
 	# Available size
-	_available_size=$("$DAXCTL" list -r 0 | jq -er '.[0].available_size | .//""')
+	_available_size=$("$DAXCTL" list -r "$region_id" | jq -er '.[0].available_size | .//""')
 	if [[ ! $_available_size == "$available" ]]; then
 		echo "Unexpected available size $_available_size != $available"
 		exit "$rc"
@@ -101,7 +102,7 @@ fail_if_available()
 {
 	local rc=1
 
-	_size=$("$DAXCTL" list -r 0 | jq -er '.[0].available_size | .//""')
+	_size=$("$DAXCTL" list -r "$region_id" | jq -er '.[0].available_size | .//""')
 	if [[ $_size ]]; then
 		echo "Unexpected available size $_size"
 		exit "$rc"
@@ -170,30 +171,31 @@ daxctl_test_multi()
 		"$DAXCTL" reconfigure-device -s $size "$testdev"
 	fi
 
-	daxdev_1=$("$DAXCTL" create-device -r 0 -s $size | jq -er '.[].chardev')
+	daxdev_1=$("$DAXCTL" create-device -r "$region_id" -s $size | jq -er '.[].chardev')
 	test -n "$daxdev_1"
 
-	daxdev_2=$("$DAXCTL" create-device -r 0 -s $size | jq -er '.[].chardev')
+	daxdev_2=$("$DAXCTL" create-device -r "$region_id" -s $size | jq -er '.[].chardev')
 	test -n "$daxdev_2"
 
 	if [[ ! $2 ]]; then
-		daxdev_3=$("$DAXCTL" create-device -r 0 -s $size | jq -er '.[].chardev')
+		daxdev_3=$("$DAXCTL" create-device -r "$region_id" -s $size | jq -er '.[].chardev')
 		test -n "$daxdev_3"
 	fi
 
 	# Hole
-	"$DAXCTL" disable-device  "$1" && "$DAXCTL" destroy-device "$1"
+	"$DAXCTL" disable-device  "$1"
+	"$DAXCTL" destroy-device "$1"
 
 	# Pick space in the created hole and at the end
 	new_size=$((size * 2))
-	daxdev_4=$("$DAXCTL" create-device -r 0 -s "$new_size" | jq -er '.[].chardev')
+	daxdev_4=$("$DAXCTL" create-device -r "$region_id" -s "$new_size" | jq -er '.[].chardev')
 	test -n "$daxdev_4"
 	test "$(daxctl_get_nr_mappings "$daxdev_4")" -eq 2
 
 	fail_if_available
 
-	"$DAXCTL" disable-device -r 0 all
-	"$DAXCTL" destroy-device -r 0 all
+	"$DAXCTL" disable-device -r "$region_id" all
+	"$DAXCTL" destroy-device -r "$region_id" all
 }
 
 daxctl_test_multi_reconfig()
@@ -210,7 +212,7 @@ daxctl_test_multi_reconfig()
 	"$DAXCTL" reconfigure-device -s $size "$testdev"
 	"$DAXCTL" disable-device "$testdev"
 
-	daxdev_1=$("$DAXCTL" create-device -r 0 -s $size | jq -er '.[].chardev')
+	daxdev_1=$("$DAXCTL" create-device -r "$region_id" -s $size | jq -er '.[].chardev')
 	"$DAXCTL" disable-device "$daxdev_1"
 
 	start=$((size + size))
@@ -249,16 +251,16 @@ daxctl_test_adjust()
 	start=$((size + size))
 	for i in $(seq 1 1 $ncfgs)
 	do
-		daxdev=$("$DAXCTL" create-device -r 0 -s "$size" | jq -er '.[].chardev')
+		daxdev=$("$DAXCTL" create-device -r "$region_id" -s "$size" | jq -er '.[].chardev')
 		test "$(daxctl_get_nr_mappings "$daxdev")" -eq 1
 	done
 
-	daxdev=$(daxctl_get_dev "dax0.1")
+	daxdev=$(daxctl_get_dev "dax$region_id.1")
 	"$DAXCTL" disable-device "$daxdev" && "$DAXCTL" destroy-device "$daxdev"
-	daxdev=$(daxctl_get_dev "dax0.4")
+	daxdev=$(daxctl_get_dev "dax$region_id.4")
 	"$DAXCTL" disable-device "$daxdev" && "$DAXCTL" destroy-device "$daxdev"
 
-	daxdev=$(daxctl_get_dev "dax0.2")
+	daxdev=$(daxctl_get_dev "dax$region_id.2")
 	"$DAXCTL" disable-device "$daxdev"
 	"$DAXCTL" reconfigure-device -s $((size * 2)) "$daxdev"
 	# Allocates space at the beginning: expect two mappings as
@@ -266,7 +268,7 @@ daxctl_test_adjust()
 	# preserve the relative page_offset of existing allocations
 	test "$(daxctl_get_nr_mappings "$daxdev")" -eq 2
 
-	daxdev=$(daxctl_get_dev "dax0.3")
+	daxdev=$(daxctl_get_dev "dax$region_id.3")
 	"$DAXCTL" disable-device "$daxdev"
 	"$DAXCTL" reconfigure-device -s $((size * 2)) "$daxdev"
 	# Adjusts space at the end, expect one mapping because we are
@@ -275,9 +277,9 @@ daxctl_test_adjust()
 
 	fail_if_available
 
-	daxdev=$(daxctl_get_dev "dax0.3")
+	daxdev=$(daxctl_get_dev "dax$region_id.3")
 	"$DAXCTL" disable-device "$daxdev" && "$DAXCTL" destroy-device "$daxdev"
-	daxdev=$(daxctl_get_dev "dax0.2")
+	daxdev=$(daxctl_get_dev "dax$region_id.2")
 	"$DAXCTL" disable-device "$daxdev" && "$DAXCTL" destroy-device "$daxdev"
 }
 
@@ -295,7 +297,7 @@ daxctl_test1()
 {
 	local daxdev
 
-	daxdev=$("$DAXCTL" create-device -r 0 | jq -er '.[].chardev')
+	daxdev=$("$DAXCTL" create-device -r "$region_id" | jq -er '.[].chardev')
 
 	test -n "$daxdev"
 	test "$(daxctl_get_nr_mappings "$daxdev")" -eq 1
@@ -312,17 +314,17 @@ daxctl_test1()
 # having the region device reconfigured with some of the memory.
 daxctl_test2()
 {
-	daxctl_test_multi "dax0.1" 1
+	daxctl_test_multi "$region_id.1" 1
 	clear_dev
 	test_pass
 }
 
 # Test 3: space at the beginning and at the end
 # Successfully pick space in the beginning and space at the end, by
-# having the region device emptied (so region beginning starts with dax0.1).
+# having the region device emptied (so region beginning starts with daxX.1).
 daxctl_test3()
 {
-	daxctl_test_multi "dax0.1"
+	daxctl_test_multi "$region_id.1"
 	clear_dev
 	test_pass
 }
@@ -366,7 +368,7 @@ daxctl_test6()
 		size=$align
 	fi
 
-	daxdev=$("$DAXCTL" create-device -r 0 -s $size -a $align | jq -er '.[].chardev')
+	daxdev=$("$DAXCTL" create-device -r "$region_id" -s $size -a $align | jq -er '.[].chardev')
 
 	test -n "$daxdev"
 

---
base-commit: 14b4c6f9116b1c7a32e0e83d7b201b78de3fa02f
change-id: 20240110-vv-daxctl-create-c6a7e1908296

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>

