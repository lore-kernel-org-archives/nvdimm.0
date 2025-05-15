Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DF177111
	for <nvdimm@lists.linux.dev>; Thu, 15 May 2025 02:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747275532; cv=none; b=t9I/ftUU8R17fpq64SuF9UUH6/st3WL7sO7Exh+V63G/P3hoQFEsDGaNe2t+8guyhFGHnNcEqd2atXYsc7b3Ysx08rrw0+oT9uf8IS4ezqBePRI1y5C24x7UU1+vJSzbrLps8nXKGJ/OAXLfMifAZerAeWUvT6F2jXCIdB5HpLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747275532; c=relaxed/simple;
	bh=WlKAAdslIKgEOfgEPuSCLePGW7C4BpbU8GeU6gXX3oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqYwm7jW2diIoLkWEuawgrmUmeRP6hNGeXfL+pVLQyK+pK0Gs/xLAppbqQBytENv2O7SWRM1TQ3xxB57ZAle3gCyZ9bb6m25PXwaqIoY01YQcZiNZ8vDBZerXYKtziXsSi6glBE4sB0YrNkTvJS1b5nd6EtBXVwrXzrIPjgBnXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K2j3sAOn; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K2j3sAOn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747275531; x=1778811531;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WlKAAdslIKgEOfgEPuSCLePGW7C4BpbU8GeU6gXX3oo=;
  b=K2j3sAOnELJ47P0Qad+kBcOEMCO5h54eeu4NukrbeWQDnTHfmcK6W/hz
   Hb9hukwWQ7C7reAUGRYyC7Duz0uY2JMKZ9QkG/gagekBp07vNCXUbgLeO
   UWERGNI1rPdVpvqB9U6taynHZHEVTYUv0ApNi6rZiULPhEZ2nUU+vbaBs
   +GFkhIOakw3LjLQBBZL8BTsMc4XFNd14F5bvBG8t1HJYMNJQX06s+f9T/
   QA6i6LZwiepBOwuTXpWtmXDcuXf1DMOevqODDyk89uv6WDsLKiwKkeVrz
   KpWytVXEunv+xAtTfnVzX/tW1vci6LjcvpzBuoRBKuWhmPWR6mQaiQaHV
   Q==;
X-CSE-ConnectionGUID: IdHj18T3Tkex9zMznHbSpg==
X-CSE-MsgGUID: /fyKFU3zT+q6Sovalvxk5A==
X-IronPort-AV: E=McAfee;i="6700,10204,11433"; a="60600551"
X-IronPort-AV: E=Sophos;i="6.15,289,1739865600"; 
   d="scan'208";a="60600551"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 19:18:50 -0700
X-CSE-ConnectionGUID: Hd49OEIyQBaoEqHeDYyV0g==
X-CSE-MsgGUID: 0DCxjUcYRum1CYwxVugkkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,289,1739865600"; 
   d="scan'208";a="138724847"
Received: from unknown (HELO hyperion.jf.intel.com) ([10.243.61.29])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 19:18:50 -0700
From: marc.herbert@linux.intel.com
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	alison.schofield@intel.com
Cc: Marc Herbert <marc.herbert@linux.intel.com>
Subject: [ndctl PATCH v2 2/2] test: fail on unexpected kernel error & warning, not just "Call Trace"
Date: Thu, 15 May 2025 02:14:46 +0000
Message-ID: <20250515021730.1201996-3-marc.herbert@linux.intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250515021730.1201996-1-marc.herbert@linux.intel.com>
References: <aCKWR4DdzdUh1VN6@aschofie-mobl2.lan>
 <20250515021730.1201996-1-marc.herbert@linux.intel.com>
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

Stop relying on the magic and convenient but inaccurate $SECONDS bash
variable because its precision is (surprise!) about 1 second. In the
first version of this patch, $SECONDS was kept and working but it
required a 1++ second long "cooldown" between tests to isolate their
logs from each other. After dropping $SECONDS from journalctl, no
cooldown delay is required.

As a good example (which initiated this), the test feedback when hitting
bug https://github.com/pmem/ndctl/issues/278, where the cxl_test module
errors at load, is completely changed by this. Instead of only half the
tests failing with a fairly cryptic and late "Numerical result out of
range" error from user space, now all tests are failing early and more
consistently; displaying the same, earlier and more relevant error.

This simple log-level based approach has been successfully used for
years in the CI of https://github.com/thesofproject and caught
countless firmware and kernel bugs.

Note: the popular message "possible circular locking ..." recently fixed
by revert v6.15-rc1-4-gdc1771f71854 is at the WARNING level, including
its Call Trace.

Signed-off-by: Marc Herbert <marc.herbert@linux.intel.com>
---
 test/common            | 137 +++++++++++++++++++++++++++++++++++++++--
 test/cxl-events.sh     |   2 +
 test/cxl-poison.sh     |   7 +++
 test/cxl-xor-region.sh |   2 +
 test/dax.sh            |   6 ++
 5 files changed, 149 insertions(+), 5 deletions(-)

diff --git a/test/common b/test/common
index 74e74dd4fff9..67dfd03f9693 100644
--- a/test/common
+++ b/test/common
@@ -15,6 +15,28 @@ err()
 	exit "$rc"
 }
 
+time_init()
+{
+	test "$SECONDS" -le 1 || err 'test/common must be included first!'
+	# ... otherwise NDTEST_START is inaccurate
+
+	NDTEST_START=$(LC_TIME=C date '+%F %T.%3N')
+
+	# Log anchor, especially useful when running tests back to back
+	printf "<5>%s@%ds: sourcing test/common: NDTEST_START=%s\n" \
+		"$test_basename" "$SECONDS" "$NDTEST_START" > /dev/kmsg
+
+	# Default value, can be overriden by the environment
+	: "${NDTEST_LOG_DBG:=false}"
+
+	if "$NDTEST_LOG_DBG"; then
+		local _cd_dbg_msg="NDTEST_LOG_DBG: $test_basename early msg must be found by check_dmesg()"
+		printf '<3>%s: %s\n' "$test_basename" "$_cd_dbg_msg" > /dev/kmsg
+		kmsg_fail_if_missing+=("$_cd_dbg_msg")
+	fi
+}
+time_init
+
 # Global variables
 
 # NDCTL
@@ -143,15 +165,120 @@ json2var()
 	sed -e "s/[{}\",]//g; s/\[//g; s/\]//g; s/:/=/g"
 }
 
-# check_dmesg
+# check_dmesg() performs two actions controlled by two bash arrays:
+# "kmsg_no_fail_on" and "kmsg_fail_if_missing". These list of extended
+# regular expressions (grep '-E') have default values here that can
+# be customized by each test.
+#
+# 1. check_dmesg() first checks the output of `journalctl -k -p warning`
+# and makes the invoking test FAIL if any unexpected kernel error or
+# warning occurred during the test. Messages in either the
+# "kmsg_no_fail_on" or the "kmsg_fail_if_missing" arrays are expected
+# and do NOT cause a test failure. All other errors and warnings cause a
+# test failure.
+#
+# 2.1 Then, check_dmesg() makes sure at least one line in the logs
+# matches each regular expression in the "kmsg_fail_if_missing" array. If
+# any of these expected messages was never issued during the test, then
+# the test fails. This is especially useful for "negative" tests
+# triggering expected errors; but not just. Unlike 1., all log levels
+# are searched. Avoid relying on "optional" messages (e.g.: dyndbg) in
+# "kmsg_fail_if_missing".
+#
+# 2.2 to make sure "something" happened during the test, check_dmesg()
+# provides a default, non-empty kmsg_fail_if_missing value that searches
+# for either "nfit_test" or pmem" or "cxl_". These are not searched if
+# the test already provides some value(s) in "kmsg_fail_if_missing".
+# While not recommended, a test could use check_dmesg() and opt out of
+# "kmsg_fail_if_missing" with a pointless regular expression like '.'
+
+# Always append with '+=' to give any test the freedom to source this
+# file before or after adding exclusions.
+# kmsg_no_fail_on+=('this array cannot be empty otherwise grep -v fails')
+
+kmsg_no_fail_on+=('cxl_core: loading out-of-tree module taints kernel')
+kmsg_no_fail_on+=('cxl_mock_mem.*: CXL MCE unsupported')
+kmsg_no_fail_on+=('cxl_mock_mem cxl_mem.*: Extended linear cache calculation failed rc:-2')
+
+# 'modprobe nfit_test' prints these every time it's not already loaded
+kmsg_no_fail_on+=(
+    'nd_pmem namespace.*: unable to guarantee persistence of writes'
+    'nfit_test nfit_test.*: failed to evaluate _FIT'
+    'nfit_test nfit_test.*: Error found in NVDIMM nmem.* flags: save_fail restore_fail flush_fail not_armed'
+    'nfit_test nfit_test.1: Error found in NVDIMM nmem.* flags: map_fail'
+)
+
+# notice level to give some information without flooding the (single!)
+# testlog.txt file
+journalctl_notice()
+{
+	( set +x;
+	  printf ' ------------ More verbose logs at t=%ds ----------\n' "$SECONDS" )
+	journalctl -b --no-pager -o short-precise -p notice --since "-$((SECONDS*1000 + 1000)) ms"
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
+	if "$NDTEST_LOG_DBG"; then
+		journalctl -q -b --since "$NDTEST_START" \
+			-o short-precise > journal-"$(basename "$0")".log
+	fi
+	# After enabling, check the timings in:
+	#    head -n 7 $(ls -1t build/journal-*.log | tac)
+	#    journalctl --since='- 5 min' -o short-precise -g 'test/common'
+
+	{ # Redirect to stderr so this is all at the _bottom_ in the log file
+
+	# Fail on kernel WARNING or ERROR.
+	if journalctl -q -o short-precise -p warning -k --since "$NDTEST_START" |
+		grep -E -v "${_e_kmsg_no_fail_on[@]}"; then
+			journalctl_notice
+			err "$1"
+	fi
+
+	# Sanity check: make sure "something" has run
+	if [ "${#kmsg_fail_if_missing[@]}" = 0 ]; then
+		kmsg_fail_if_missing+=( '(nfit_test)|(pmem)|(cxl_)' )
+	fi
+
+	local expected_re
+	for expected_re in "${kmsg_fail_if_missing[@]}"; do
+		journalctl -q -k -p 7 --since "$NDTEST_START" |
+			grep -q -E -e "${expected_re}" || {
+				printf 'FAIL: expected error not found: %s\n' "$expected_re"
+				journalctl_notice
+				err "$1"
+		}
+	done
+	} >&2
+
+	# Log anchor, especially useful when running tests back to back
+	printf "<5>%s@%ds: test/common: check_dmesg() OK\n" "$test_basename" "$SECONDS" > /dev/kmsg
+
+	if "$NDTEST_LOG_DBG"; then
+	    log_stress from_check_dmesg
+	fi
+}
+# Many tests don't use check_dmesg() (yet?) so double down here. Also, this
+# runs later which is better. But before using this make sure there is
+# still no test defining its own EXIT trap.
+if "$NDTEST_LOG_DBG"; then
+    trap 'log_stress from_trap' EXIT
+fi
+
+log_stress()
+{
+	printf '<3>%s@%ds: NDTEST_LOG_DBG; trying to break the next check_dmesg() %s\n' \
+		"$test_basename" "$SECONDS" "$1" > /dev/kmsg
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
index 2caf092db460..3985c817914b 100644
--- a/test/cxl-poison.sh
+++ b/test/cxl-poison.sh
@@ -8,6 +8,13 @@ rc=77
 
 set -ex
 
+# FIXME: this should be in "kmsg_fail_if_missing" but this test seems to
+# work only once. Cleanup/reset issue?
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
index 3ffbc8079eba..0589f0d053ec 100755
--- a/test/dax.sh
+++ b/test/dax.sh
@@ -118,6 +118,12 @@ else
 	run_xfs
 fi
 
+kmsg_fail_if_missing+=(
+    'nd_pmem pfn.*: unable to guarantee persistence of writes'
+    'Memory failure: .*: Sending SIGBUS to dax-pmd:.* due to hardware memory corruption'
+    'Memory failure: .*: recovery action for dax page: Recovered'
+)
+
 check_dmesg "$LINENO"
 
 exit 0
-- 
2.49.0

