Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CBD86337
	for <nvdimm@lists.linux.dev>; Sat, 14 Feb 2026 02:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771036366; cv=none; b=hYj3cuRGZwlYRNWtYsL/T8KxoOC4EATrnNoNSyKXpAvqJIQQD5FK5qMIsRhXXX7GY/vASTJdaKpTZEU4WZNCociYFz0jvV9ArAPaqe+zY8AP/A4VlCJRkS1EbHVynnB0WXc6LZA3Y2fS9In/IJ9Esgoev1ArOnGi8Ye8Q+XhhxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771036366; c=relaxed/simple;
	bh=7DRgXnhuE57KLANHRIp3C9Q+B05mbXGLHxWHi/nTtGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NqKz5J9GwCj+qTRfwUWRQy+e/gjdtO5BV14RVkSJ8OiCnrVbDyMVAOptPHcWdnF/I0aUiJSotimdUk9XSYx3bOCbss8BmosO0iSpzUN81DUnF900J2eEWdK3j1PfyaF8wM4EzNFv2p+aMHBWwAJVIJCTdUcKf1YSvMKybRZjz20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q9AA+btt; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q9AA+btt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771036364; x=1802572364;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7DRgXnhuE57KLANHRIp3C9Q+B05mbXGLHxWHi/nTtGQ=;
  b=Q9AA+bttltf1METXSG9uvJHsQhE/sSba+OXaZPlXrg2twmUqtgDoFKuz
   1TD5rc4sZEXR9RnQ67WHUzVmS2invTDXE+MMwQhIAXrsfhAADoJBamlUM
   r7ivhzxpGtLm/eMlNWkFLUEpABUdwMEfjkDmiYn9j1uj55wFapcZAssme
   9ZCohkuyCagZdg6QZH8JwO2nCp0yhfjizp3KZ5sK0uwqtfClH6YGlmLA/
   OElyjJV4oGEV5RLKDoOnHP9MtI2ER8lwWnbd00KvsG2ERjNPWKzceQhVb
   M6j7KFmzZH6YgdbmyhRpGGqgSzni9ofCCTTW8tuPXxDaZ0wQFEGiHrQQg
   Q==;
X-CSE-ConnectionGUID: dRzH/Z6GRk20XAM4sInfwA==
X-CSE-MsgGUID: GaCabrWvTJqrz5Vd+nBZNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11700"; a="71418937"
X-IronPort-AV: E=Sophos;i="6.21,289,1763452800"; 
   d="scan'208";a="71418937"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2026 18:32:43 -0800
X-CSE-ConnectionGUID: QPyhWp7+SP6jX0BoOlNx/A==
X-CSE-MsgGUID: TL5GxHuJSCi3vi53/N5dCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,289,1763452800"; 
   d="scan'208";a="213096194"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.134])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2026 18:32:42 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Cheatham <Benjamin.Cheatham@amd.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v2] test/cxl-poison.sh: replace sysfs usage with cxl-cli cmds
Date: Fri, 13 Feb 2026 18:32:37 -0800
Message-ID: <20260214023239.1352245-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
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

Hi Ben - This is updated to use the naming we are about to
merge. Please review and add any more testing you'd like to
see covered for the media poison cmds.

Change in v2: use final format of new cxl-cli cmds
	inject-media-poison and clear-media-poison


 test/cxl-poison.sh | 79 ++++++++++++++++++++++++----------------------
 1 file changed, 42 insertions(+), 37 deletions(-)

diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
index 59e807ece932..05ab7bc1fc6a 100644
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
+	inject) local cmd=("$CXL" inject-media-poison "$dev" -a "$addr") ;;
+	clear)	local cmd=("$CXL" clear-media-poison "$dev" -a "$addr") ;;
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

