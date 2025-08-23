Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA97B11CA0
	for <nvdimm@lists.linux.dev>; Sat, 23 Aug 2025 02:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755918001; cv=none; b=MK5q9ZsHP6cZTyv1GpRZPYVfMGuB4uqCfi33X7UIngZyvwbakU4NFErIxKh3BN8irJSdgA/uws0vQZdrpsPnKPv5ycd9ErIMBQoQ8AbzP0CYUjucAeQzMIW5jKrC3aD/4/uhrk/TxCIgFiINdUrAvgiAZywYGnqaPNuvUZZ/YAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755918001; c=relaxed/simple;
	bh=p3HOPIEPk6tHNPrurr4HyssFXqWiRqBwgynznzHb8JM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YJGfs2yFTv4sEnvugH6LM6JVoAOxB4ymL9+S5XMKSV14D7qS6/ojV4450EK9hWNsNLTVA+8OoSzxEIuVbMXrDTScOJwfoxuHdcLlwyDasAXsp+WOle0osTgrK5lg+Ze4CwpwbJnP7ywV5SjHcMMjUIG+As2ehiT3VpY9JnfOhG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mETAyR5D; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mETAyR5D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755917998; x=1787453998;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=p3HOPIEPk6tHNPrurr4HyssFXqWiRqBwgynznzHb8JM=;
  b=mETAyR5Df4QVkD92twQ7WVCYoy5kXdD6m33uHjMpYDhP5aLGmH6BTZSh
   B50xjYy//1DZv0LYA4d9pOCWwlR9nz/a9b0KqjCczZ+uqn7CEjJSWW1HT
   nDy3X/JSM3s25JmIa3IxxWhm902nORr/+gVjoE4dUA1AOjBxx3P6cU1oQ
   K6q5M9Lg+vnpep5RbQIBYWut0vBaCCXoYTEsCP7MQ5CDx2MiDzbuNoJTS
   tYuvtPYahwQ8pQLECWJcqKg38G/47VeHPzLTR8jaOXFy9kdwK6CluwRMV
   JuDu743uhHKgkKDJcDvxuYBTIP/8k0HMuFlFkyJjb8+rOJQt0oR8xyPY+
   w==;
X-CSE-ConnectionGUID: aASF4TlVTyKnUcVyfQRsFA==
X-CSE-MsgGUID: cP/7HYrPRg+yMLPA53oB9A==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="75810411"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="75810411"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 19:59:58 -0700
X-CSE-ConnectionGUID: AvMwi+gqQHaiFPVOM0gY+w==
X-CSE-MsgGUID: DBaxzvn1Q5KxW3U2B+Bkpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="168445132"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.222.147])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 19:59:58 -0700
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH v3] test/cxl-poison.sh: test inject and clear poison by region offset
Date: Fri, 22 Aug 2025 19:59:52 -0700
Message-ID: <20250823025954.3161194-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

The CXL kernel driver recently added support to inject and clear
poison in a region by specifying an offset. Add a test case to the
existing cxl-poison unit test that demonstrates how to use the new
debugfs attributes. Use the kernel trace log to validate the round
trip address translations.

SKIP, do not fail, if the new debugfs attributes are not present.

See the kernel ABI documentation for usage:
Documentation/ABI/testing/debugfs-cxl

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

Changes in v3:
Replace string compare with boolean value for expect_fail (Marc)
Add local declarations in new or modified funcs (Marc)
De-duplicate clear & poison funcs (Marc)
Remove stderr redirection (Marc)

Changes in v2:
Add test_poison_by_region_offset_negative set of test cases


 test/cxl-poison.sh | 132 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 117 insertions(+), 15 deletions(-)

diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
index 6ed890bc666c..f941f3cbcffd 100644
--- a/test/cxl-poison.sh
+++ b/test/cxl-poison.sh
@@ -63,20 +63,58 @@ create_x2_region()
 # When cxl-cli support for inject and clear arrives, replace
 # the writes to /sys/kernel/debug with the new cxl commands.
 
+_do_poison_sysfs()
+{
+	local action="$1" dev="$2" addr="$3"
+	local expect_fail=${4:-false}
+
+	if "$expect_fail"; then
+		if echo "$addr" > "/sys/kernel/debug/cxl/$dev/${action}_poison"; then
+			echo "Expected ${action}_poison to fail for $addr"
+			err "$LINENO"
+		fi
+	else
+		echo "$addr" > "/sys/kernel/debug/cxl/$dev/${action}_poison"
+	fi
+}
+
 inject_poison_sysfs()
 {
-	memdev="$1"
-	addr="$2"
-
-	echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/inject_poison
+	_do_poison_sysfs 'inject' "$@"
 }
 
 clear_poison_sysfs()
 {
-	memdev="$1"
-	addr="$2"
+	_do_poison_sysfs 'clear' "$@"
+}
 
-	echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/clear_poison
+check_trace_entry()
+{
+	local expected_region="$1"
+	local expected_hpa="$2"
+
+	local trace_line
+	trace_line=$(grep "cxl_poison" /sys/kernel/tracing/trace | tail -n 1)
+	if [[ -z "$trace_line" ]]; then
+		echo "No cxl_poison trace event found"
+		err "$LINENO"
+	fi
+
+	local trace_region trace_hpa
+	trace_region=$(echo "$trace_line" | grep -o 'region=[^ ]*' | cut -d= -f2)
+	trace_hpa=$(echo "$trace_line" | grep -o 'hpa=0x[0-9a-fA-F]\+' | cut -d= -f2)
+
+	if [[ "$trace_region" != "$expected_region" ]]; then
+		echo "Expected region $expected_region not found in trace"
+		echo "$trace_line"
+		err "$LINENO"
+	fi
+
+	if [[ "$trace_hpa" != "$expected_hpa" ]]; then
+		echo "Expected HPA $expected_hpa not found in trace"
+		echo "$trace_line"
+		err "$LINENO"
+	fi
 }
 
 validate_poison_found()
@@ -97,7 +135,7 @@ validate_poison_found()
 	fi
 }
 
-test_poison_by_memdev()
+test_poison_by_memdev_by_dpa()
 {
 	find_memdev
 	inject_poison_sysfs "$memdev" "0x40000000"
@@ -113,9 +151,8 @@ test_poison_by_memdev()
 	validate_poison_found "-m $memdev" 0
 }
 
-test_poison_by_region()
+test_poison_by_region_by_dpa()
 {
-	create_x2_region
 	inject_poison_sysfs "$mem0" "0x40000000"
 	inject_poison_sysfs "$mem1" "0x40000000"
 	validate_poison_found "-r $region" 2
@@ -125,13 +162,78 @@ test_poison_by_region()
 	validate_poison_found "-r $region" 0
 }
 
-# Turn tracing on. Note that 'cxl list --media-errors' toggles the tracing.
-# Turning it on here allows the test user to also view inject and clear
-# trace events.
+test_poison_by_region_offset()
+{
+	local base gran hpa1 hpa2
+	base=$(cat /sys/bus/cxl/devices/"$region"/resource)
+	gran=$(cat /sys/bus/cxl/devices/"$region"/interleave_granularity)
+
+	# Test two HPA addresses: base and base + granularity
+	# This hits the two memdevs in the region interleave.
+	hpa1=$(printf "0x%x" $((base)))
+	hpa2=$(printf "0x%x" $((base + gran)))
+
+	# Inject at the offset and check result using the hpa's 
+	# ABI takes an offset, but recall the hpa to check trace event
+
+	inject_poison_sysfs "$region" 0
+	check_trace_entry "$region" "$hpa1"
+	inject_poison_sysfs "$region" "$gran"
+	check_trace_entry "$region" "$hpa2"
+	validate_poison_found "-r $region" 2
+
+	clear_poison_sysfs "$region" 0
+	check_trace_entry "$region" "$hpa1"
+	clear_poison_sysfs "$region" "$gran"
+	check_trace_entry "$region" "$hpa2"
+	validate_poison_found "-r $region" 0
+}
+
+test_poison_by_region_offset_negative()
+{
+	local region_size cache_size cache_offset exceed_offset large_offset
+	region_size=$(cat /sys/bus/cxl/devices/"$region"/size)
+	cache_size=0
+
+	# This case is a no-op until cxl-test ELC mocking arrives
+	# Try to get cache_size if the attribute exists
+	if [ -f "/sys/bus/cxl/devices/$region/cache_size" ]; then
+		cache_size=$(cat /sys/bus/cxl/devices/"$region"/cache_size)
+	fi
+
+	# Offset within extended linear cache (if cache_size > 0)
+	if [[ $cache_size -gt 0 ]]; then
+		cache_offset=$((cache_size - 1))
+		echo "Testing offset within cache: $cache_offset (cache_size: $cache_size)"
+		inject_poison_sysfs "$region" "$cache_offset" true
+		clear_poison_sysfs "$region" "$cache_offset" true
+	else
+		echo "Skipping cache test - cache_size is 0"
+	fi
+
+	# Offset exceeds region size
+	exceed_offset=$((region_size))
+	inject_poison_sysfs "$region" "$exceed_offset" true
+	clear_poison_sysfs "$region" "$exceed_offset" true
+
+	# Offset exceeds region size by a lot
+	large_offset=$((region_size * 2))
+	inject_poison_sysfs "$region" "$large_offset" true
+	clear_poison_sysfs "$region" "$large_offset" true
+}
+
+# Clear old trace events, enable cxl_poison, enable global tracing
+echo "" > /sys/kernel/tracing/trace
 echo 1 > /sys/kernel/tracing/events/cxl/cxl_poison/enable
+echo 1 > /sys/kernel/tracing/tracing_on
 
-test_poison_by_memdev
-test_poison_by_region
+test_poison_by_memdev_by_dpa
+create_x2_region
+test_poison_by_region_by_dpa
+[ -f "/sys/kernel/debug/cxl/$region/inject_poison" ] ||
+       do_skip "test cases requires inject by region kernel support"
+test_poison_by_region_offset
+test_poison_by_region_offset_negative
 
 check_dmesg "$LINENO"
 
-- 
2.37.3

