Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B06256B81
	for <nvdimm@lists.linux.dev>; Wed, 17 Dec 2025 05:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765947667; cv=none; b=g6eeuywKgwV7+f9JtnDy18i/QRJnO4tIpbvw778OAlQVnRh1x6qNqNE1Uj4onkcNyZHT/hJDcQO1LnJHLcB+IMVgGUKm+intysyr7pKrZONz32oL6bYjlDmJ1DCr3MVpE+sbsekJRrX6EfXFxn0mZffVutKs4XK94582xVbIoCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765947667; c=relaxed/simple;
	bh=FFX300bGQMSMitRu9eiwO37nZ5xTun1EQalD7s7TGuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmSGLgAE2R59AiZ8xKffykFelt5QOSSB8dqUAetqSS9tNHXoIlUeMMARcJNmizeYFHSpokKMI0w+UTrEHAvcFD9RuhyAPM8vDP9Qppy1JwtAo1LHhh/DZhgUeIJyfM7Fs5jF2ggw95RbSL5fIvj9JVLdbGb9rX9UXsCwyeUlmmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bi+UOxgv; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bi+UOxgv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765947665; x=1797483665;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FFX300bGQMSMitRu9eiwO37nZ5xTun1EQalD7s7TGuk=;
  b=Bi+UOxgvInLkj0XRmGEUV4OHwBkJV+jmCWMgrmWnahIRvuP12qTpXOu6
   Jfp8s6ONd4YS//AcBSuUskgrg4ny9uIICSmm37CgK/gE27BKXa5ULEKKW
   qghuSvkyhAt0ZKv7GNeJd7ppnFC+6HO+zbsNy7cztLwP6wymCawlctKOV
   5KiTgdLnSi7Emu11+J9Go2pYl+0n69mURQeCasB1zgExAzE1HRiVo7OUa
   1lYdiUA9IAkQqG793fdC6lIOrbq3eMzd6fKHRtbIAfG7EJTWuVy9QMkWp
   FB6Dn/ZsVgYlT/PYI1UTVSx840KFk0ERyMGYieczOMWrJerof/BOhJpSR
   g==;
X-CSE-ConnectionGUID: 9bPDcxvGRTGr/RUkxi3U4A==
X-CSE-MsgGUID: 5rS/n38mT2eFCQw1MXZczw==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="67761790"
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="67761790"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 21:01:04 -0800
X-CSE-ConnectionGUID: yvOA0A8ET/mcurcgvbZbIQ==
X-CSE-MsgGUID: AQo0L92QTlaT7J2yEDZU4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="199008609"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.223.78])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 21:01:03 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Cheatham <Benjamin.Cheatham@amd.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH] cxl/test: use inject and clear cmds in cxl-poison.sh
Date: Tue, 16 Dec 2025 21:00:58 -0800
Message-ID: <20251217050100.2393796-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
References: 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cxl-cli commands were recently added for poison inject and clear
operations by memdev. Replace the writes to sysfs with the new
commands in the cxl-poison unit test.

Continue to use the sysfs writes for inject and clear poison
by region offset until that support arrives in cxl-cli.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

Ben - Please append this to your in flight set and suggest 
anything else you'd like to see covered here.


 test/cxl-poison.sh | 79 ++++++++++++++++++++++++----------------------
 1 file changed, 42 insertions(+), 37 deletions(-)

diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
index 59e807ece932..ebad38c14e3e 100644
--- a/test/cxl-poison.sh
+++ b/test/cxl-poison.sh
@@ -41,32 +41,37 @@ find_auto_region()
 	echo "$region"
 }
 
-# When cxl-cli support for inject and clear arrives, replace
-# the writes to /sys/kernel/debug with the new cxl commands.
-
-_do_poison_sysfs()
+_do_poison()
 {
 	local action="$1" dev="$2" addr="$3"
 	local expect_fail=${4:-false}
 
-	if "$expect_fail"; then
-		if echo "$addr" > "/sys/kernel/debug/cxl/$dev/${action}_poison"; then
-			echo "Expected ${action}_poison to fail for $addr"
-			err "$LINENO"
-		fi
-	else
-		echo "$addr" > "/sys/kernel/debug/cxl/$dev/${action}_poison"
+	# Regions use sysfs, memdevs use cxl-cli commands
+	if [[ "$dev" =~ ^region ]]; then
+		local sysfs_path="/sys/kernel/debug/cxl/$dev/${action}_poison"
+		"$expect_fail" && echo "$addr" > "$sysfs_path" && err "$LINENO"
+		"$expect_fail" || echo "$addr" > "$sysfs_path"
+		return
 	fi
+
+	case "$action" in
+	inject) local cmd=("$CXL" inject-error "$dev" -t poison -a "$addr") ;;
+	clear)	local cmd=("$CXL" clear-error "$dev" -a "$addr") ;;
+	*)	err "$LINENO" ;;
+	esac
+
+	"$expect_fail" && "${cmd[@]}" && err "$LINENO"
+	"$expect_fail" || "${cmd[@]}"
 }
 
-inject_poison_sysfs()
+inject_poison()
 {
-	_do_poison_sysfs 'inject' "$@"
+	_do_poison 'inject' "$@"
 }
 
-clear_poison_sysfs()
+clear_poison()
 {
-	_do_poison_sysfs 'clear' "$@"
+	_do_poison 'clear' "$@"
 }
 
 check_trace_entry()
@@ -119,27 +124,27 @@ validate_poison_found()
 test_poison_by_memdev_by_dpa()
 {
 	find_memdev
-	inject_poison_sysfs "$memdev" "0x40000000"
-	inject_poison_sysfs "$memdev" "0x40001000"
-	inject_poison_sysfs "$memdev" "0x600"
-	inject_poison_sysfs "$memdev" "0x0"
+	inject_poison "$memdev" "0x40000000"
+	inject_poison "$memdev" "0x40001000"
+	inject_poison "$memdev" "0x600"
+	inject_poison "$memdev" "0x0"
 	validate_poison_found "-m $memdev" 4
 
-	clear_poison_sysfs "$memdev" "0x40000000"
-	clear_poison_sysfs "$memdev" "0x40001000"
-	clear_poison_sysfs "$memdev" "0x600"
-	clear_poison_sysfs "$memdev" "0x0"
+	clear_poison "$memdev" "0x40000000"
+	clear_poison "$memdev" "0x40001000"
+	clear_poison "$memdev" "0x600"
+	clear_poison "$memdev" "0x0"
 	validate_poison_found "-m $memdev" 0
 }
 
 test_poison_by_region_by_dpa()
 {
-	inject_poison_sysfs "$mem0" "0"
-	inject_poison_sysfs "$mem1" "0"
+	inject_poison "$mem0" "0"
+	inject_poison "$mem1" "0"
 	validate_poison_found "-r $region" 2
 
-	clear_poison_sysfs "$mem0" "0"
-	clear_poison_sysfs "$mem1" "0"
+	clear_poison "$mem0" "0"
+	clear_poison "$mem1" "0"
 	validate_poison_found "-r $region" 0
 }
 
@@ -166,15 +171,15 @@ test_poison_by_region_offset()
 	# Inject at the offset and check result using the hpa
 	# ABI takes an offset, but recall the hpa to check trace event
 
-	inject_poison_sysfs "$region" "$cache_size"
+	inject_poison "$region" "$cache_size"
 	check_trace_entry "$region" "$hpa1"
-	inject_poison_sysfs "$region" "$((gran + cache_size))"
+	inject_poison "$region" "$((gran + cache_size))"
 	check_trace_entry "$region" "$hpa2"
 	validate_poison_found "-r $region" 2
 
-	clear_poison_sysfs "$region" "$cache_size"
+	clear_poison "$region" "$cache_size"
 	check_trace_entry "$region" "$hpa1"
-	clear_poison_sysfs "$region" "$((gran + cache_size))"
+	clear_poison "$region" "$((gran + cache_size))"
 	check_trace_entry "$region" "$hpa2"
 	validate_poison_found "-r $region" 0
 }
@@ -194,21 +199,21 @@ test_poison_by_region_offset_negative()
 	if [[ $cache_size -gt 0 ]]; then
 		cache_offset=$((cache_size - 1))
 		echo "Testing offset within cache: $cache_offset (cache_size: $cache_size)"
-		inject_poison_sysfs "$region" "$cache_offset" true
-		clear_poison_sysfs "$region" "$cache_offset" true
+		inject_poison "$region" "$cache_offset" true
+		clear_poison "$region" "$cache_offset" true
 	else
 		echo "Skipping cache test - cache_size is 0"
 	fi
 
 	# Offset exceeds region size
 	exceed_offset=$((region_size))
-	inject_poison_sysfs "$region" "$exceed_offset" true
-	clear_poison_sysfs "$region" "$exceed_offset" true
+	inject_poison "$region" "$exceed_offset" true
+	clear_poison "$region" "$exceed_offset" true
 
 	# Offset exceeds region size by a lot
 	large_offset=$((region_size * 2))
-	inject_poison_sysfs "$region" "$large_offset" true
-	clear_poison_sysfs "$region" "$large_offset" true
+	inject_poison "$region" "$large_offset" true
+	clear_poison "$region" "$large_offset" true
 }
 
 run_poison_test()
-- 
2.37.3

