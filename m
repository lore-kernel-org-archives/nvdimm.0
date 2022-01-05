Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819F22C9C
	for <nvdimm@lists.linux.dev>; Wed,  5 Jan 2022 21:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641418315; x=1672954315;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nkw69Y9cVQM75moQImxfRDkfj6yZ6Kns0MeaOUeKsSU=;
  b=mFiRqdAtaHI8sQUwGxzkCJdDwS2MgUoWC0QsDqG5Br7roYbRuxZxb/YC
   jkeeKI2KPvnQnVAqhAr7ALVpgOqzeHDPUQIKEib/BS8B0ztYdKkgnS7ea
   39oYcG+PFac4s7NZrmEvq87ogi3NBJFmXG+TrNhFMdNfAbb9LPB+CCUWa
   qEcaWUptH+RzMcvIFvpkEyCRW9R0vaUfEYHlrqE53GjCW1Ig4m/I83y3i
   1vanjIokWz7jKblYnitdtfgKFjx0VUqAi2WXKevx8ZyhjJUiexSN20WpV
   KrKSIrM3WKN8lZ/Ge7L3y9OiN7fdU00A26jGND+sjFHibDxcfphWwu72k
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="240083974"
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="240083974"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:31:55 -0800
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="470718730"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:31:55 -0800
Subject: [ndctl PATCH v3 03/16] ndctl/test: Move 'reset()' to function in
 'common'
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Date: Wed, 05 Jan 2022 13:31:55 -0800
Message-ID: <164141831509.3990253.14783946910211635678.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

When BLK mode is removed, tests that expect the nfit_test region to allow
pmem namespace creation will need to 'init' rather than 'zero' labels. In
preparation, take the time opportunity to move reset() to a common
function. So that 'ndctl zero-labels' can be replaced with 'ndctl
init-labels' in one central location.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/blk-exhaust.sh             |    4 +---
 test/btt-check.sh               |    7 -------
 test/btt-errors.sh              |   12 +++---------
 test/btt-pad-compat.sh          |    7 -------
 test/clear.sh                   |    4 +---
 test/common                     |   15 +++++++++++++++
 test/create.sh                  |    4 +---
 test/daxctl-create.sh           |    4 ++--
 test/daxdev-errors.sh           |    4 +---
 test/firmware-update.sh         |    8 +++-----
 test/inject-error.sh            |    7 -------
 test/max_available_extent_ns.sh |    9 +--------
 test/monitor.sh                 |   11 ++---------
 test/multi-dax.sh               |    4 +---
 test/pfn-meta-errors.sh         |    4 +---
 test/pmem-errors.sh             |    4 +---
 test/rescan-partitions.sh       |    7 -------
 test/sector-mode.sh             |    9 ++-------
 test/track-uuid.sh              |    4 +---
 19 files changed, 36 insertions(+), 92 deletions(-)

diff --git a/test/blk-exhaust.sh b/test/blk-exhaust.sh
index 09c4aae146a6..b6d3808969f1 100755
--- a/test/blk-exhaust.sh
+++ b/test/blk-exhaust.sh
@@ -14,9 +14,7 @@ trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
-$NDCTL disable-region -b $NFIT_TEST_BUS0 all
-$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
-$NDCTL enable-region -b $NFIT_TEST_BUS0 all
+reset
 
 # if the kernel accounting is correct we should be able to create two
 # pmem and two blk namespaces on nfit_test.0
diff --git a/test/btt-check.sh b/test/btt-check.sh
index 8e0b489a8eca..65b5c58bb236 100755
--- a/test/btt-check.sh
+++ b/test/btt-check.sh
@@ -39,13 +39,6 @@ create()
 	[ $size -gt 0 ] || err "$LINENO"
 }
 
-reset()
-{
-	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
-	$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
-	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
-}
-
 # re-enable the BTT namespace, and do IO to it in an attempt to
 # verify it still comes up ok, and functions as expected
 post_repair_test()
diff --git a/test/btt-errors.sh b/test/btt-errors.sh
index 4e59f57aea7c..5a20d26fe6d5 100755
--- a/test/btt-errors.sh
+++ b/test/btt-errors.sh
@@ -45,9 +45,7 @@ trap 'err $LINENO cleanup' ERR
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
-$NDCTL disable-region -b $NFIT_TEST_BUS0 all
-$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
-$NDCTL enable-region -b $NFIT_TEST_BUS0 all
+reset
 
 rc=1
 
@@ -126,9 +124,7 @@ dd if=$MNT/$FILE of=/dev/null iflag=direct bs=4096 count=1
 
 # reset everything to get a clean log
 if grep -q "$MNT" /proc/mounts; then umount $MNT; fi
-$NDCTL disable-region -b $NFIT_TEST_BUS0 all
-$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
-$NDCTL enable-region -b $NFIT_TEST_BUS0 all
+reset
 dev="x"
 json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -t pmem -m sector)
 eval "$(echo "$json" | json2var)"
@@ -148,9 +144,7 @@ force_raw 0
 dd if=/dev/$blockdev of=/dev/null iflag=direct bs=4096 count=1 && err $LINENO || true
 
 # done, exit
-$NDCTL disable-region -b $NFIT_TEST_BUS0 all
-$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
-$NDCTL enable-region -b $NFIT_TEST_BUS0 all
+reset
 cleanup
 _cleanup
 exit 0
diff --git a/test/btt-pad-compat.sh b/test/btt-pad-compat.sh
index bf1ea54af9d2..be538b761151 100755
--- a/test/btt-pad-compat.sh
+++ b/test/btt-pad-compat.sh
@@ -37,13 +37,6 @@ create()
 	fi
 }
 
-reset()
-{
-	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
-	$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
-	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
-}
-
 verify_idx()
 {
 	idx0="$1"
diff --git a/test/clear.sh b/test/clear.sh
index fb9d52c837d4..c4d02d54714d 100755
--- a/test/clear.sh
+++ b/test/clear.sh
@@ -14,9 +14,7 @@ trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
-$NDCTL disable-region -b $NFIT_TEST_BUS0 all
-$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
-$NDCTL enable-region -b $NFIT_TEST_BUS0 all
+reset
 
 rc=1
 
diff --git a/test/common b/test/common
index 6bcefcad9bf9..3c54d633251f 100644
--- a/test/common
+++ b/test/common
@@ -46,6 +46,21 @@ err()
 	exit $rc
 }
 
+reset()
+{
+	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+	$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
+	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
+}
+
+reset1()
+{
+	$NDCTL disable-region -b $NFIT_TEST_BUS1 all
+	$NDCTL zero-labels -b $NFIT_TEST_BUS1 all
+	$NDCTL enable-region -b $NFIT_TEST_BUS1 all
+}
+
+
 # check_min_kver
 # $1: Supported kernel version. format: X.Y
 #
diff --git a/test/create.sh b/test/create.sh
index b0fd99f1e7b1..e9baaa075a28 100755
--- a/test/create.sh
+++ b/test/create.sh
@@ -15,9 +15,7 @@ trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
-$NDCTL disable-region -b $NFIT_TEST_BUS0 all
-$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
-$NDCTL enable-region -b $NFIT_TEST_BUS0 all
+reset
 
 rc=1
 
diff --git a/test/daxctl-create.sh b/test/daxctl-create.sh
index 198779a851b4..d319a3939ac5 100755
--- a/test/daxctl-create.sh
+++ b/test/daxctl-create.sh
@@ -10,7 +10,7 @@ trap 'cleanup $LINENO' ERR
 cleanup()
 {
 	printf "Error at line %d\n" "$1"
-	[[ $testdev ]] && reset
+	[[ $testdev ]] && reset_dax
 	exit $rc
 }
 
@@ -70,7 +70,7 @@ reset_dev()
 	"$DAXCTL" enable-device "$testdev"
 }
 
-reset()
+reset_dax()
 {
 	test -n "$testdev"
 
diff --git a/test/daxdev-errors.sh b/test/daxdev-errors.sh
index 9547d781162b..e13453dfaa73 100755
--- a/test/daxdev-errors.sh
+++ b/test/daxdev-errors.sh
@@ -15,9 +15,7 @@ trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
-$NDCTL disable-region -b $NFIT_TEST_BUS0 all
-$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
-$NDCTL enable-region -b $NFIT_TEST_BUS0 all
+reset
 
 rc=1
 
diff --git a/test/firmware-update.sh b/test/firmware-update.sh
index 8cc9c41b57ca..93ce166e6255 100755
--- a/test/firmware-update.sh
+++ b/test/firmware-update.sh
@@ -10,11 +10,9 @@ image="update-fw.img"
 
 trap 'err $LINENO' ERR
 
-reset()
+fwupd_reset()
 {
-	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
-	$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
-	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
+	reset
 	if [ -f $image ]; then
 		rm -f $image
 	fi
@@ -73,7 +71,7 @@ do_tests()
 check_min_kver "4.16" || do_skip "may lack firmware update test handling"
 
 modprobe nfit_test
-reset
+fwupd_reset
 detect
 rc=1
 do_tests
diff --git a/test/inject-error.sh b/test/inject-error.sh
index 7d0b8269f5db..fd823b6cfa13 100755
--- a/test/inject-error.sh
+++ b/test/inject-error.sh
@@ -37,13 +37,6 @@ create()
 	[ $size -gt 0 ] || err "$LINENO"
 }
 
-reset()
-{
-	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
-	$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
-	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
-}
-
 check_status()
 {
 	local sector="$1"
diff --git a/test/max_available_extent_ns.sh b/test/max_available_extent_ns.sh
index 343f3c9eac49..47a921f5edf2 100755
--- a/test/max_available_extent_ns.sh
+++ b/test/max_available_extent_ns.sh
@@ -11,13 +11,6 @@ trap 'err $LINENO' ERR
 check_min_kver "4.19" || do_skip "kernel $KVER may not support max_available_size"
 check_prereq "jq"
 
-init()
-{
-	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
-	$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
-	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
-}
-
 do_test()
 {
 	region=$($NDCTL list -b $NFIT_TEST_BUS0 -R -t pmem | jq -r 'sort_by(-.size) | .[].dev' | head -1)
@@ -40,7 +33,7 @@ do_test()
 
 modprobe nfit_test
 rc=1
-init
+reset
 do_test
 _cleanup
 exit 0
diff --git a/test/monitor.sh b/test/monitor.sh
index 28c55415c819..14450a7b23e3 100755
--- a/test/monitor.sh
+++ b/test/monitor.sh
@@ -19,13 +19,6 @@ trap 'err $LINENO' ERR
 
 check_min_kver "4.15" || do_skip "kernel $KVER may not support monitor service"
 
-init()
-{
-	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
-	$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
-	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
-}
-
 start_monitor()
 {
 	logfile=$(mktemp)
@@ -112,7 +105,7 @@ test_filter_region()
 
 test_filter_namespace()
 {
-	init
+	reset
 	monitor_namespace=$($NDCTL create-namespace -b $smart_supported_bus | jq -r .dev)
 	monitor_dimms=$(get_monitor_dimm "-n $monitor_namespace")
 	start_monitor "-n $monitor_namespace"
@@ -170,7 +163,7 @@ do_tests()
 
 modprobe nfit_test
 rc=1
-init
+reset
 set_smart_supported_bus
 do_tests
 _cleanup
diff --git a/test/multi-dax.sh b/test/multi-dax.sh
index b343a3869f9c..04070adb18e4 100755
--- a/test/multi-dax.sh
+++ b/test/multi-dax.sh
@@ -17,9 +17,7 @@ ALIGN_SIZE=`getconf PAGESIZE`
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
-$NDCTL disable-region -b $NFIT_TEST_BUS0 all
-$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
-$NDCTL enable-region -b $NFIT_TEST_BUS0 all
+reset
 rc=1
 
 query=". | sort_by(.available_size) | reverse | .[0].dev"
diff --git a/test/pfn-meta-errors.sh b/test/pfn-meta-errors.sh
index 0ade2e52a8ad..631489797087 100755
--- a/test/pfn-meta-errors.sh
+++ b/test/pfn-meta-errors.sh
@@ -29,9 +29,7 @@ trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
-$NDCTL disable-region -b $NFIT_TEST_BUS0 all
-$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
-$NDCTL enable-region -b $NFIT_TEST_BUS0 all
+reset
 
 rc=1
 
diff --git a/test/pmem-errors.sh b/test/pmem-errors.sh
index 4225c3bce0c7..20657801fc0e 100755
--- a/test/pmem-errors.sh
+++ b/test/pmem-errors.sh
@@ -28,9 +28,7 @@ trap 'err $LINENO cleanup' ERR
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
-$NDCTL disable-region -b $NFIT_TEST_BUS0 all
-$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
-$NDCTL enable-region -b $NFIT_TEST_BUS0 all
+reset
 
 rc=1
 
diff --git a/test/rescan-partitions.sh b/test/rescan-partitions.sh
index 1686de3552f1..51bbd731fb55 100755
--- a/test/rescan-partitions.sh
+++ b/test/rescan-partitions.sh
@@ -25,13 +25,6 @@ check_min_kver "4.16" || do_skip "may not contain fixes for partition rescanning
 check_prereq "parted"
 check_prereq "blockdev"
 
-reset()
-{
-	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
-	$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
-	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
-}
-
 test_mode()
 {
 	local mode="$1"
diff --git a/test/sector-mode.sh b/test/sector-mode.sh
index 7a2faeae8a2d..439ef331adaf 100755
--- a/test/sector-mode.sh
+++ b/test/sector-mode.sh
@@ -15,13 +15,8 @@ ALIGN_SIZE=`getconf PAGESIZE`
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
-$NDCTL disable-region -b $NFIT_TEST_BUS0 all
-$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
-$NDCTL enable-region -b $NFIT_TEST_BUS0 all
-
-$NDCTL disable-region -b $NFIT_TEST_BUS1 all
-$NDCTL zero-labels -b $NFIT_TEST_BUS1 all
-$NDCTL enable-region -b $NFIT_TEST_BUS1 all
+reset
+reset1
 
 rc=1
 query=". | sort_by(.size) | reverse | .[0].dev"
diff --git a/test/track-uuid.sh b/test/track-uuid.sh
index be3cf9c07a0a..3bacd2c24787 100755
--- a/test/track-uuid.sh
+++ b/test/track-uuid.sh
@@ -12,9 +12,7 @@ trap 'err $LINENO' ERR
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
-$NDCTL disable-region -b $NFIT_TEST_BUS0 all
-$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
-$NDCTL enable-region -b $NFIT_TEST_BUS0 all
+reset
 
 rc=1
 

