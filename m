Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB1B2BE7DB
	for <nvdimm@lists.linux.dev>; Wed, 18 Feb 2026 19:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771441874; cv=none; b=jCDQNf/Zf9BFLz5fdxtvZ4DYbWK/bzsCnWWHlwg0V8zCXBnYLn97B/LNJHLqTPDRe6mEnXcibDucbC7GcRrAg+UoeAEVlHxp2PCAXVzK0YVJtHCwHJSmnIVjvHlx3GaLiat07ciwBDObOaMS2YUg7/W5LTL+6erq9SYOtMjo8Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771441874; c=relaxed/simple;
	bh=Blj+oEHu1O9G0n1XXDQSv1gKyDmiDFUXf4UxdRhVs8k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fQiP02lUxd3AS+y2m7M8KS5ljsFhZAg6hZ6Lxgr+i3j5Ryl+K6ppDl25Aoo2m9d53vsUH8tn4k3NJJNoGqxDiIWWZy+1hBhIVIhsBVu1or7ineNujXwcuoRB7vWKJeHRle6GjJlB4W7qt+4g39zK9yv/ZaGGGMKw0HoTzChnv9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a6G6LU5H; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a6G6LU5H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771441872; x=1802977872;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Blj+oEHu1O9G0n1XXDQSv1gKyDmiDFUXf4UxdRhVs8k=;
  b=a6G6LU5HtZtpJaUlz5K/K0Ir+pj269jK6b3GokYKdNqNWo0ERVAfTxim
   9K7h2apNn1CiexsuV++gpgXU6T9RjUOXtvO0a2XUz2roVu+BGux7h5xha
   1J3D6mmjcSGR3WU7XZcQNPuIq7tJ+OSsj6+XZ3rzzXLiW0VyZ/dMvp5ux
   IiRxiUZl0jm9FMJJeq0+BFzsKkhx8PgnrrYl5iwUkCh9C5QAop9BYcTWr
   8KpnJaAF+8wqswgo1Zl/3qh5yjGh6FtSpR9uk+zqH/Uwm6qGVcUytgo61
   B3BbMSrJRt58M2YSgP/KWWhg9UDUN3n9BtvNOptzRQuwbWuIKI9WRcRzf
   Q==;
X-CSE-ConnectionGUID: lRx1yTouTy2UGsjNdnzoJQ==
X-CSE-MsgGUID: +hrErnxnRjuOPTqs75zcFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11705"; a="72593648"
X-IronPort-AV: E=Sophos;i="6.21,298,1763452800"; 
   d="scan'208";a="72593648"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 11:11:12 -0800
X-CSE-ConnectionGUID: Sbjd6AwcQAyPnWdyabXAEw==
X-CSE-MsgGUID: AfB4rciJT8OrcTgVFTb3zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,298,1763452800"; 
   d="scan'208";a="237266432"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.94])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 11:11:12 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Cheatham <Benjamin.Cheatham@amd.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v3] test/cxl-poison.sh: replace sysfs usage with cxl-cli cmds
Date: Wed, 18 Feb 2026 11:11:06 -0800
Message-ID: <20260218191108.1471718-1-alison.schofield@intel.com>
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

All cxl-test memdevs are created as poison_injectable, so just
confirm that the new poison_injectable field is indeed 'true'.

Continue to use the sysfs writes for inject and clear poison
by region offset until that support arrives in cxl-cli.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

Change in v3:
Use new field 'poison_injectable' in memdev selection (BenC)
Update commit log to include poison_injectable check.

Change in v2:
Use final format of new cxl-cli cmds:
	inject-media-poison and clear-media-poison


 test/cxl-poison.sh | 82 +++++++++++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 38 deletions(-)

diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
index 58cf132b613b..bbd147c85a77 100644
--- a/test/cxl-poison.sh
+++ b/test/cxl-poison.sh
@@ -20,7 +20,8 @@ find_memdev()
 {
 	readarray -t capable_mems < <("$CXL" list -b "$CXL_TEST_BUS" -M |
 		jq -r ".[] | select(.pmem_size != null) |
-		select(.ram_size != null) | .memdev")
+		select(.ram_size != null) |
+		select(.poison_injectable == true) | .memdev")
 
 	if [ ${#capable_mems[@]} == 0 ]; then
 		echo "no memdevs found for test"
@@ -41,32 +42,37 @@ find_auto_region()
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
@@ -121,27 +127,27 @@ validate_poison_found()
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
 
@@ -168,15 +174,15 @@ test_poison_by_region_offset()
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
@@ -196,21 +202,21 @@ test_poison_by_region_offset_negative()
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
 
 is_unaligned() {
-- 
2.37.3

