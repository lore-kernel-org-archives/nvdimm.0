Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832EDF4FE
	for <nvdimm@lists.linux.dev>; Tue, 28 Nov 2023 04:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j63bD7se"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701144707; x=1732680707;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dJglqphnvdxezvitIujtsqJJ6XB6KC9QjQFLQwt0L0E=;
  b=j63bD7sekVAwA4oTBkbdG3lkHW3YCDok82nfwhvfogn7GKNaxeU+Y5u6
   XOHvmtaeLBvp2GMZxqAuK1/58vityXPuz56WeNVU0KYlsTA3RvgpBzWQn
   q2f6ECjSactJCOAtYd3ZGB4mr5RWZsXTreh5hmcvDbjI4uMUX/yDMWfi9
   Gb8soTuU3ieOGYA9JizS4yh+7La2c4wTdXyM9CMr5niNhGhfmraD/GnoX
   J1DAI8k1UR7gcuvRWhuK/k16Htbee/wOlojNv0nrAzNKWbvXXsTgqMtn2
   RbqXLd84R1as8yxzLaNNsZDvnWmVJwp0WhA+GuFhUYbHz5d/OsKVvChvG
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="390001065"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="390001065"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 20:11:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="891948434"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="891948434"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.212.170.56])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 20:11:45 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 1/3] cxl/test: add and use cxl_common_[start|stop] helpers
Date: Mon, 27 Nov 2023 20:11:40 -0800
Message-Id: <d76c005105b7612dc47ccd19e102d462c0f4fc1b.1701143039.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1701143039.git.alison.schofield@intel.com>
References: <cover.1701143039.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

CXL unit tests use a mostly common set of commands to setup and tear down
their test environments. Standardize on a common set and make all unit
tests that run as part of the CXL suite use the helpers.

This assures that each test is following the best known practice of
set up and tear down, and that each is using the existing common
helper - check_dmesg(). It also allows for expansion of the common
helpers without the need to touch every unit test.

Note that this makes all tests have the same execution prerequisites,
so all tests will skip if a prerequisite for any test is not present.
At the moment, the extra prereqs are sha256sum and dd, both used by
cxl-update-firmware.sh. The broad requirement is a good thing, in that
it enforces correct setup and complete runs of the entire CXL suite.

cxl-security.sh was excluded from this migration as its setup has more
in common with the nfit_test and legacy security test than with the
other CXL unit tests.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/common                 | 23 +++++++++++++++++++++++
 test/cxl-create-region.sh   | 16 ++--------------
 test/cxl-events.sh          | 18 +++---------------
 test/cxl-labels.sh          | 16 ++--------------
 test/cxl-poison.sh          | 17 ++---------------
 test/cxl-region-sysfs.sh    | 16 ++--------------
 test/cxl-topology.sh        | 16 ++--------------
 test/cxl-update-firmware.sh | 17 ++---------------
 test/cxl-xor-region.sh      | 15 ++-------------
 9 files changed, 40 insertions(+), 114 deletions(-)

diff --git a/test/common b/test/common
index f1023ef20f7e..7a4711593624 100644
--- a/test/common
+++ b/test/common
@@ -150,3 +150,26 @@ check_dmesg()
 	grep -q "Call Trace" <<< $log && err $1
 	true
 }
+
+# cxl_common_start
+# $1: optional module parameter(s) for cxl-test
+cxl_common_start()
+{
+	rc=77
+	set -ex
+	trap 'err $LINENO' ERR
+	check_prereq "jq"
+	check_prereq "dd"
+	check_prereq "sha256sum"
+	modprobe -r cxl_test
+	modprobe cxl_test "$1"
+	rc=1
+}
+
+# cxl_common_end
+# $1: line number where this is called
+cxl_common_stop()
+{
+	check_dmesg "$1"
+	modprobe -r cxl_test
+}
diff --git a/test/cxl-create-region.sh b/test/cxl-create-region.sh
index 658b9b8ff58a..aa586b1471f6 100644
--- a/test/cxl-create-region.sh
+++ b/test/cxl-create-region.sh
@@ -4,17 +4,7 @@
 
 . $(dirname $0)/common
 
-rc=77
-
-set -ex
-
-trap 'err $LINENO' ERR
-
-check_prereq "jq"
-
-modprobe -r cxl_test
-modprobe cxl_test
-rc=1
+cxl_common_start
 
 destroy_regions()
 {
@@ -149,6 +139,4 @@ for mem in ${mems[@]}; do
 	create_subregions "$mem"
 done
 
-check_dmesg "$LINENO"
-
-modprobe -r cxl_test
+cxl_common_stop "$LINENO"
diff --git a/test/cxl-events.sh b/test/cxl-events.sh
index fe702bf98ad4..b181646d0fcb 100644
--- a/test/cxl-events.sh
+++ b/test/cxl-events.sh
@@ -4,24 +4,14 @@
 
 . "$(dirname "$0")/common"
 
+cxl_common_start
+
 # Results expected
 num_overflow_expected=1
 num_fatal_expected=2
 num_failure_expected=16
 num_info_expected=3
 
-rc=77
-
-set -ex
-
-trap 'err $LINENO' ERR
-
-check_prereq "jq"
-
-modprobe -r cxl_test
-modprobe cxl_test
-rc=1
-
 dev_path="/sys/bus/platform/devices"
 
 test_cxl_events()
@@ -74,6 +64,4 @@ if [ "$num_info" -ne $num_info_expected ]; then
 	err "$LINENO"
 fi
 
-check_dmesg "$LINENO"
-
-modprobe -r cxl_test
+cxl_common_stop "$LINENO"
diff --git a/test/cxl-labels.sh b/test/cxl-labels.sh
index 36b0341c8039..c911816696c5 100644
--- a/test/cxl-labels.sh
+++ b/test/cxl-labels.sh
@@ -4,17 +4,7 @@
 
 . $(dirname $0)/common
 
-rc=77
-
-set -ex
-
-trap 'err $LINENO' ERR
-
-check_prereq "jq"
-
-modprobe -r cxl_test
-modprobe cxl_test
-rc=1
+cxl_common_start
 
 test_label_ops()
 {
@@ -66,6 +56,4 @@ for nmem in ${nmems[@]}; do
 	test_label_ops "$nmem"
 done
 
-check_dmesg "$LINENO"
-
-modprobe -r cxl_test
+cxl_common_stop "$LINENO"
diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
index 8747ffe8cff7..2f16dc11884c 100644
--- a/test/cxl-poison.sh
+++ b/test/cxl-poison.sh
@@ -4,18 +4,7 @@
 
 . "$(dirname "$0")"/common
 
-rc=77
-
-set -ex
-
-trap 'err $LINENO' ERR
-
-check_prereq "jq"
-
-modprobe -r cxl_test
-modprobe cxl_test
-
-rc=1
+cxl_common_start
 
 # THEORY OF OPERATION: Exercise cxl-cli and cxl driver ability to
 # inject, clear, and get the poison list. Do it by memdev and by region.
@@ -153,6 +142,4 @@ echo 1 > /sys/kernel/tracing/events/cxl/cxl_poison/enable
 test_poison_by_memdev
 test_poison_by_region
 
-check_dmesg "$LINENO"
-
-modprobe -r cxl-test
+cxl_common_stop "$LINENO"
diff --git a/test/cxl-region-sysfs.sh b/test/cxl-region-sysfs.sh
index 863639271afa..2c81d8f0b006 100644
--- a/test/cxl-region-sysfs.sh
+++ b/test/cxl-region-sysfs.sh
@@ -4,17 +4,7 @@
 
 . $(dirname $0)/common
 
-rc=77
-
-set -ex
-
-trap 'err $LINENO' ERR
-
-check_prereq "jq"
-
-modprobe -r cxl_test
-modprobe cxl_test
-rc=1
+cxl_common_start
 
 # THEORY OF OPERATION: Create a x8 interleave across the pmem capacity
 # of the 8 endpoints defined by cxl_test, commit the decoders (which
@@ -163,6 +153,4 @@ readarray -t endpoint < <($CXL free-dpa -t pmem ${mem[*]} |
 			  jq -r ".[] | .decoder.decoder")
 echo "$region released ${#endpoint[@]} targets: ${endpoint[@]}"
 
-check_dmesg "$LINENO"
-
-modprobe -r cxl_test
+cxl_common_stop "$LINENO"
diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
index e8b9f56543b5..7822abada7dc 100644
--- a/test/cxl-topology.sh
+++ b/test/cxl-topology.sh
@@ -4,17 +4,7 @@
 
 . $(dirname $0)/common
 
-rc=77
-
-set -ex
-
-trap 'err $LINENO' ERR
-
-check_prereq "jq"
-
-modprobe -r cxl_test
-modprobe cxl_test
-rc=1
+cxl_common_start
 
 # THEORY OF OPERATION: Validate the hard coded assumptions of the
 # cxl_test.ko module that defines its topology in
@@ -187,6 +177,4 @@ done
 # validate that the bus can be disabled without issue
 $CXL disable-bus $root -f
 
-check_dmesg "$LINENO"
-
-modprobe -r cxl_test
+cxl_common_stop "$LINENO"
diff --git a/test/cxl-update-firmware.sh b/test/cxl-update-firmware.sh
index f326868977a9..cf080150ccbc 100755
--- a/test/cxl-update-firmware.sh
+++ b/test/cxl-update-firmware.sh
@@ -4,19 +4,7 @@
 
 . $(dirname $0)/common
 
-rc=77
-
-set -ex
-
-trap 'err $LINENO' ERR
-
-check_prereq "jq"
-check_prereq "dd"
-check_prereq "sha256sum"
-
-modprobe -r cxl_test
-modprobe cxl_test
-rc=1
+cxl_common_start
 
 mk_fw_file()
 {
@@ -192,5 +180,4 @@ test_nonblocking_update
 test_multiple_memdev
 test_cancel
 
-check_dmesg "$LINENO"
-modprobe -r cxl_test
+cxl_common_stop "$LINENO"
diff --git a/test/cxl-xor-region.sh b/test/cxl-xor-region.sh
index 117e7a4bba61..6d74af8c98cd 100644
--- a/test/cxl-xor-region.sh
+++ b/test/cxl-xor-region.sh
@@ -4,18 +4,7 @@
 
 . $(dirname $0)/common
 
-rc=77
-
-set -ex
-
-trap 'err $LINENO' ERR
-
-check_prereq "jq"
-
-modprobe -r cxl_test
-modprobe cxl_test interleave_arithmetic=1
-udevadm settle
-rc=1
+cxl_common_start "interleave_arithmetic=1"
 
 # THEORY OF OPERATION: Create x1,2,3,4 regions to exercise the XOR math
 # option of the CXL driver. As with other cxl_test tests, changes to the
@@ -93,4 +82,4 @@ create_and_destroy_region
 setup_x4
 create_and_destroy_region
 
-modprobe -r cxl_test
+cxl_common_stop "$LINENO"
-- 
2.37.3

