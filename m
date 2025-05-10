Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0642CCC5
	for <nvdimm@lists.linux.dev>; Sat, 10 May 2025 01:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746840063; cv=none; b=o5dSYgoH/QoxfVyDJGgP+6XsEtgmqKTu70Yhj/crUVSrJCuZl190zcOwHpgFFVs94U8fSGXr8Y2PDh27N6k1NlCaZVJ7uob7iMVAEpntlZghAlPxKk3djykqEUQ1yYzCPhuk5znJ3LOqLhpB9ubpSOsG4WtWrYKflHIE2eUqR70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746840063; c=relaxed/simple;
	bh=00l892IqZoSUv5fd235eXrNHgxD0pt0+a8rndCMWpmg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BKLPmv3H+B1jSPy9Yc+HV2p831vFpBJwVa4onuZGsHLxN45ldS9BWMOpkfl+thvxra/yORRLUyuGtIXIyQQMwoWOZtnL1A23niJn1vOL0i6MQPhPOJ07dcNjd27HjWrfolxOTrV4wLHoPyrLTlbB87pbY79N65MZIXmVDKJhUwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fl/fSdct; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fl/fSdct"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746840061; x=1778376061;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=00l892IqZoSUv5fd235eXrNHgxD0pt0+a8rndCMWpmg=;
  b=Fl/fSdctwlZVl8dqVYpbHUIf2IvUAQFoM9A778hwaVhJLjAYUMicHee+
   +cpzPKPdre5jm9Y2u4edpN879nsV9ewRe2hqUWtVWmqozPxVrviZpvUv4
   g+47JwDaQ9A6fCQeZrgrjyA3mDzneA4CC5PNh8cEFAf4+wqm1BomD1LRp
   iOpYajc9qm/yAblYLUOHObT8GN8OpT2Thg2KybuHTE3D/QmFmrXhw0p0G
   NwjLBrFA+GsInuABR0AM0Zs9NsesoqbzNAwduTJGys5fDKmvfp9a/k77R
   DRptcIiR8OPw8efCgHsbFpoEJyjSN6s4vJJ0Qa6/TaR9ju8uoD6qUzfq4
   A==;
X-CSE-ConnectionGUID: LtWYiJUlT/y35+dEMgLeZg==
X-CSE-MsgGUID: aOhWtNLcQfm5oRzJ0kyblQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48589269"
X-IronPort-AV: E=Sophos;i="6.15,276,1739865600"; 
   d="scan'208";a="48589269"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 18:21:00 -0700
X-CSE-ConnectionGUID: cwRCH3P/TnesW43hGkzhGg==
X-CSE-MsgGUID: 9IPZU7kiT+2G9a/L/2HoyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,276,1739865600"; 
   d="scan'208";a="137720416"
Received: from unknown (HELO hyperion.jf.intel.com) ([10.243.61.29])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 18:21:01 -0700
From: marc.herbert@linux.intel.com
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: Marc Herbert <marc.herbert@linux.intel.com>
Subject: [ndctl PATCH] test: fail on unexpected kernel error & warning, not just "Call Trace"
Date: Sat, 10 May 2025 01:20:46 +0000
Message-ID: <20250510012046.1067514-1-marc.herbert@linux.intel.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Marc Herbert <marc.herbert@linux.intel.com>

While a "Call Trace" is usually a bad omen, the show_trace_log_lvl()
function supports any log level. So a "Call Trace" is not a reliable
indication of a failure. More importantly: any other WARNING or ERROR
during a test should make a test FAIL. Before this commit, it does not.

So, leverage log levels for the PASS/FAIL decision.  This catches all
issues and not just the ones printing Call Traces.

Add a simple way to exclude expected warnings and errors, either on a
per-test basis or globally.

Add a way for negative tests to fail when if some expected errors are
missing.

Add COOLDOWN_MS to address the inaccuracy of the magic $SECONDS
variable.

As a good example (which initiated this), the test feedback when hitting
bug https://github.com/pmem/ndctl/issues/278, where the cxl_test module
errors at load, is completely changed by this. Instead of only half the
tests failing with a fairly cryptic and late "Numerical result out of
range" error from user space, now all tests are failing early and
consistently, all displaying the same, earlier and more relevant error.

This simple log-level based approach has been successfully used for
years in the CI of https://github.com/thesofproject and caught
countless firmware and kernel bugs.

Note: the popular message "possible circular locking ..." recently fixed
by revert v6.15-rc1-4-gdc1771f71854 is at the WARNING level, including
its Call Trace.

Signed-off-by: Marc Herbert <marc.herbert@linux.intel.com>
---
 test/common            | 74 +++++++++++++++++++++++++++++++++++++++---
 test/cxl-events.sh     |  2 ++
 test/cxl-poison.sh     |  5 +++
 test/cxl-xor-region.sh |  2 ++
 test/dax.sh            |  6 ++++
 5 files changed, 84 insertions(+), 5 deletions(-)

diff --git a/test/common b/test/common
index 75ff1a6e12be..2a95437186e7 100644
--- a/test/common
+++ b/test/common
@@ -3,6 +3,15 @@
 
 # Global variables
 
+# Small gap in journalctl to avoid cross-test pollution.  Unfortunately,
+# this needs be at least 1 second because we don't know how bash rounds
+# up or down its magic $SECONDS variable that we use below.
+COOLDOWN_MS=1200
+sleep "${COOLDOWN_MS}E-3"
+
+# Log anchor, especially useful when running tests back to back
+printf "<5>%s: sourcing test/common\n" "$0" > /dev/kmsg
+
 # NDCTL
 if [ -z $NDCTL ]; then
 	if [ -f "../ndctl/ndctl" ] && [ -x "../ndctl/ndctl" ]; then
@@ -140,15 +149,70 @@ json2var()
 	sed -e "s/[{}\",]//g; s/\[//g; s/\]//g; s/:/=/g"
 }
 
-# check_dmesg
+# - "declare -a" gives the main script the freedom to source this file
+#   before OR after adding some excludes.
+declare -a kmsg_no_fail_on
+# kmsg_no_fail_on+=('this array must never be empty to keep the code simple')
+
+kmsg_no_fail_on+=('cxl_core: loading out-of-tree module taints kernel')
+kmsg_no_fail_on+=('cxl_mock_mem.*: CXL MCE unsupported')
+kmsg_no_fail_on+=('cxl_mock_mem cxl_mem.*: Extended linear cache calculation failed rc:-2')
+
+# 'modprobe nfit_test' prints these every time it's not already loaded
+kmsg_no_fail_on+=(
+    'nd_pmem namespace.*: unable to guarantee persistence of writes'
+    'nfit_test nfit_test.*: failed to evaluate _FIT'
+    'nfit_test nfit_test.*: Error found in NVDIMM nmem. flags: save_fail restore_fail flush_fail not_armed'
+    'nfit_test nfit_test.1: Error found in NVDIMM nmem. flags: map_fail'
+)
+
+declare -a kmsg_fail_if_missing
+
+print_all_warnings()
+{
+	( set +x;
+	  printf '%s\n' '------------ ALL warnings and errors -----------')
+	journalctl -p warning -b --since "-$((SECONDS*1000)) ms"
+}
+
 # $1: line number where this is called
 check_dmesg()
 {
-	# validate no WARN or lockdep report during the run
+	local _e_kmsg_no_fail_on=()
+	for re in "${kmsg_no_fail_on[@]}" "${kmsg_fail_if_missing[@]}"; do
+		_e_kmsg_no_fail_on+=('-e' "$re")
+	done
+
+	# Give some time for a complete kmsg->journalctl flush + any delayed test effect.
 	sleep 1
-	log=$(journalctl -r -k --since "-$((SECONDS+1))s")
-	grep -q "Call Trace" <<< $log && err $1
-	true
+
+	# Optional code to manually verify the SECONDS / COOLDOWN_MS logic.
+	# journalctl -q -b -o short-precise --since "-$((SECONDS*1000 - COOLDOWN_MS/2)) ms" > journal-"$(basename "$0")".log
+	# After enabling, check the timings in:
+	#    head -n 7 $(ls -1t build/journal-*.log | tac)
+	#    journalctl --since='- 5 min' -o short-precise -g 'test/common'
+
+	{ # Redirect to stderr so this is all at the _bottom_ in the log file
+	# Fail on kernel WARNING or ERROR. $SECONDS is bash magic.
+	if journalctl -q -p warning -k --since "-$((SECONDS*1000 - COOLDOWN_MS/2)) ms" |
+		grep -E -v "${_e_kmsg_no_fail_on[@]}"; then
+			print_all_warnings
+			err "$1"
+	fi
+
+	local expected_re
+	for expected_re in "${kmsg_fail_if_missing[@]}"; do
+		journalctl -q -p warning -k --since "-$((SECONDS*1000 - COOLDOWN_MS/2)) ms" |
+			grep -q "${expected_re}" || {
+				printf 'FAIL: expected error not found: %s\n' "$expected_re"
+				print_all_warnings
+				err "$1"
+		}
+	done
+	} >&2
+
+	# Log anchor, especially useful when running tests back to back
+	printf "<5>%s: test/common check_dmesg() OK\n" "$0" > /dev/kmsg
 }
 
 # CXL COMMON
diff --git a/test/cxl-events.sh b/test/cxl-events.sh
index c216d6aa9148..1461b487e208 100644
--- a/test/cxl-events.sh
+++ b/test/cxl-events.sh
@@ -25,6 +25,8 @@ rc=1
 dev_path="/sys/bus/platform/devices"
 trace_path="/sys/kernel/tracing"
 
+kmsg_no_fail_on+=('cxl_mock_mem cxl_mem.* no CXL window for range')
+
 test_region_info()
 {
 	# Trigger a memdev in the cxl_test autodiscovered region
diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
index 2caf092db460..4df7d7ffbe8a 100644
--- a/test/cxl-poison.sh
+++ b/test/cxl-poison.sh
@@ -8,6 +8,11 @@ rc=77
 
 set -ex
 
+kmsg_no_fail_on+=(
+    'cxl_mock_mem cxl_mem.*: poison inject dpa:0x'
+    'cxl_mock_mem cxl_mem.*: poison clear dpa:0x'
+)
+
 trap 'err $LINENO' ERR
 
 check_prereq "jq"
diff --git a/test/cxl-xor-region.sh b/test/cxl-xor-region.sh
index b9e1d79212d3..f5e0db98b67f 100644
--- a/test/cxl-xor-region.sh
+++ b/test/cxl-xor-region.sh
@@ -17,6 +17,8 @@ modprobe cxl_test interleave_arithmetic=1
 udevadm settle
 rc=1
 
+kmsg_fail_if_missing+=('cxl_mock_mem cxl_mem.* no CXL window for range')
+
 # THEORY OF OPERATION: Create x1,2,3,4 regions to exercise the XOR math
 # option of the CXL driver. As with other cxl_test tests, changes to the
 # CXL topology in tools/testing/cxl/test/cxl.c may require an update here.
diff --git a/test/dax.sh b/test/dax.sh
index 3ffbc8079eba..c325e144753d 100755
--- a/test/dax.sh
+++ b/test/dax.sh
@@ -118,6 +118,12 @@ else
 	run_xfs
 fi
 
+kmsg_fail_if_missing=(
+    'nd_pmem pfn.*: unable to guarantee persistence of writes'
+    'Memory failure: .*: Sending SIGBUS to dax-pmd:.* due to hardware memory corruption'
+    'Memory failure: .*: recovery action for dax page: Recovered'
+)
+
 check_dmesg "$LINENO"
 
 exit 0
-- 
2.49.0

