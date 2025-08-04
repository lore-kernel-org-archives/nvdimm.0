Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4418423C511
	for <nvdimm@lists.linux.dev>; Mon,  4 Aug 2025 08:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754295247; cv=none; b=koMpaP0uW/f27i9Z4VXkHBjvJssF2+tN5WScY5cQ17VDQHAwoDGmPq0Px3mqahRur6kf/ZQFNpNx5PNjLvJ6Rxif0xUp3JwnsMZ9IZynwx2GikMx2dGsdfzE5ohry1rakk4f1DAiTEFsT4Hll2o30xoR1XFj0DP6/PHLwhFnAQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754295247; c=relaxed/simple;
	bh=WtomoPHoNVkDhFcU/dc2lIQjv1mVO9FZGCaYlTTzA8g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KM1pRPIQldIFkts5P1jTx7xlDIOZWID2wJ7qIRcZzMZkXUceYU/CPjU/Vp8xdsEu6NJZNbmwfhJ8Jc6FFAdC5ddqIXMeeS4hP9VSdm6Rskoaqk/+6DKTR+cBedKgyTeSOWM7R/hctsqQpYilnJ/5uX9XBOAOO79H7Utc+z60UlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FG5YpLlQ; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FG5YpLlQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754295246; x=1785831246;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WtomoPHoNVkDhFcU/dc2lIQjv1mVO9FZGCaYlTTzA8g=;
  b=FG5YpLlQoIiH9fwrbgAEd2nFHJdJUmeD0hRMWz0MLyI393HP8nOeREH1
   R47lPTUDpg4nQosS/sDNrQO0w1TpElsaHU5ddi1SQvW/L6aHWwdl4RMV1
   w9FQbVHUjAH/8GWaDco5LgNf8LFYV/tSUb+94Op7iOdF2AafEFelFF+wD
   crjeZ+9EL6129IM7P4UMi3Y+D9lemuno+gJO1oapg2abr0suqf5fcOoQA
   IUqIHhsaO+MsqiIDC2FJWLAkyCjGNZDBHNYyTbKSLlo2wV6hhJ24fMdFw
   AcrE3vAKQ4+V/67BnwcQmK2BbmG4l7TPJ9AJSTW12tpDX0lWEKCqrE6EY
   Q==;
X-CSE-ConnectionGUID: 8KSYClxBRa6Qvp3S9Y52vw==
X-CSE-MsgGUID: aOX0oOOcRsCLpgZ+gbrnBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11511"; a="56686589"
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="56686589"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 01:14:06 -0700
X-CSE-ConnectionGUID: wDwhXupeTeiFOor+78SdpA==
X-CSE-MsgGUID: Z17pei+gT2m8LBHxtmSPVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="164427364"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.223.77])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 01:14:06 -0700
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH v2] test/cxl-poison.sh: test inject and clear poison by region offset
Date: Mon,  4 Aug 2025 01:14:01 -0700
Message-ID: <20250804081403.2590033-1-alison.schofield@intel.com>
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

Changes in v2:
Add test_poison_by_region_offset_negative set of test cases


 test/cxl-poison.sh | 129 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 117 insertions(+), 12 deletions(-)

diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
index 6ed890bc666c..517e3db23223 100644
--- a/test/cxl-poison.sh
+++ b/test/cxl-poison.sh
@@ -65,18 +65,61 @@ create_x2_region()
 
 inject_poison_sysfs()
 {
-	memdev="$1"
+	dev="$1"
 	addr="$2"
+	expect_fail="$3"
 
-	echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/inject_poison
+	if [[ "$expect_fail" == "true" ]]; then
+		if echo "$addr" > /sys/kernel/debug/cxl/"$dev"/inject_poison 2>/dev/null; then
+			echo "Expected inject_poison to fail for $addr"
+			err "$LINENO"
+		fi
+	else
+		echo "$addr" > /sys/kernel/debug/cxl/"$dev"/inject_poison
+	fi
 }
 
 clear_poison_sysfs()
 {
-	memdev="$1"
+	dev="$1"
 	addr="$2"
+	expect_fail="$3"
 
-	echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/clear_poison
+	if [[ "$expect_fail" == "true" ]]; then
+		if echo "$addr" > /sys/kernel/debug/cxl/"$dev"/clear_poison 2>/dev/null; then
+			echo "Expected clear_poison to fail for $addr"
+			err "$LINENO"
+		fi
+	else
+		echo "$addr" > /sys/kernel/debug/cxl/"$dev"/clear_poison
+	fi
+}
+
+check_trace_entry()
+{
+	expected_region="$1"
+	expected_hpa="$2"
+
+	trace_line=$(grep "cxl_poison" /sys/kernel/tracing/trace | tail -n 1)
+	if [[ -z "$trace_line" ]]; then
+		echo "No cxl_poison trace event found"
+		err "$LINENO"
+	fi
+
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
@@ -97,7 +140,7 @@ validate_poison_found()
 	fi
 }
 
-test_poison_by_memdev()
+test_poison_by_memdev_by_dpa()
 {
 	find_memdev
 	inject_poison_sysfs "$memdev" "0x40000000"
@@ -113,9 +156,8 @@ test_poison_by_memdev()
 	validate_poison_found "-m $memdev" 0
 }
 
-test_poison_by_region()
+test_poison_by_region_by_dpa()
 {
-	create_x2_region
 	inject_poison_sysfs "$mem0" "0x40000000"
 	inject_poison_sysfs "$mem1" "0x40000000"
 	validate_poison_found "-r $region" 2
@@ -125,13 +167,76 @@ test_poison_by_region()
 	validate_poison_found "-r $region" 0
 }
 
-# Turn tracing on. Note that 'cxl list --media-errors' toggles the tracing.
-# Turning it on here allows the test user to also view inject and clear
-# trace events.
+test_poison_by_region_offset()
+{
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
+		inject_poison_sysfs "$region" "$cache_offset" "true"
+		clear_poison_sysfs "$region" "$cache_offset" "true"
+	else
+		echo "Skipping cache test - cache_size is 0"
+	fi
+
+	# Offset exceeds region size
+	exceed_offset=$((region_size))
+	inject_poison_sysfs "$region" "$exceed_offset" "true"
+	clear_poison_sysfs "$region" "$exceed_offset" "true"
+
+	# Offset exceeds region size by a lot
+	large_offset=$((region_size * 2))
+	inject_poison_sysfs "$region" "$large_offset" "true"
+	clear_poison_sysfs "$region" "$large_offset" "true"
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

