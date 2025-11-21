Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183ED23183B;
	Fri, 21 Nov 2025 00:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763684424; cv=none; b=r7iQAGhKQvzfUtDTml8rHXZqtONUMtD0NMJo2K7vzNQcrcnzohcsjRJU2gSuvlYqWBtf6hWCMD1rbCdz1q/XPvAtxKiSfDnszd9iQKYM+2uhtVsqcXRYwvMWSmsmKg7vlFpBAT12WRpMgol8PcSnCh3Kkgi1/1VXYel09lsTeDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763684424; c=relaxed/simple;
	bh=7GU98SPfEH904grARy5f84PKbH2wR2d7zEeNcalsEkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0AIx/LkWO6RA7gDBYDiBqIW9gSMQizDqqQJ9RLeJnH6Cxx281ETTW1qpe6Ggo7F73XAOre/xjRlx+zNo0vIow7V0Qy/qC2AObAWVV0gWavW31IEp6zNw+KFDcVZXxNpbqD6wZIOBOhQwNh5XSTVFPXvHPklA3aNtVWnd8bYgv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851ABC4CEF1;
	Fri, 21 Nov 2025 00:20:23 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com
Subject: [NDCTL PATCH v2 2/2] cxl/test: Add support for poison test for ELC
Date: Thu, 20 Nov 2025 17:20:18 -0700
Message-ID: <20251121002018.4136006-3-dave.jiang@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251121002018.4136006-1-dave.jiang@intel.com>
References: <20251121002018.4136006-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expand cxl-poison.sh test to include extended linear cache testing.
Additional adjustments are needed for test_poison_by_region_offset()
to test ELC functionality.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 test/cxl-poison.sh | 61 +++++++++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 22 deletions(-)

diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
index 8dfed1877907..0cb7bc77b814 100644
--- a/test/cxl-poison.sh
+++ b/test/cxl-poison.sh
@@ -13,11 +13,6 @@ trap 'err $LINENO' ERR
 
 check_prereq "jq"
 
-modprobe -r cxl_test
-modprobe cxl_test
-
-rc=1
-
 # THEORY OF OPERATION: Exercise cxl-cli and cxl driver ability to
 # inject, clear, and get the poison list. Do it by memdev and by region.
 
@@ -150,9 +145,18 @@ test_poison_by_region_by_dpa()
 
 test_poison_by_region_offset()
 {
-	local base gran hpa1 hpa2
+	local base gran hpa1 hpa2 cache_size
 	base=$(cat /sys/bus/cxl/devices/"$region"/resource)
 	gran=$(cat /sys/bus/cxl/devices/"$region"/interleave_granularity)
+	cache_size=0
+
+	if [ -f "/sys/bus/cxl/devices/$region/extended_linear_cache_size" ]; then
+		cache_size=$(cat /sys/bus/cxl/devices/"$region"/extended_linear_cache_size)
+	fi
+
+	if [[ $cache_size -gt 0 ]]; then
+		base=$((base + cache_size))
+	fi
 
 	# Test two HPA addresses: base and base + granularity
 	# This hits the two memdevs in the region interleave.
@@ -162,15 +166,15 @@ test_poison_by_region_offset()
 	# Inject at the offset and check result using the hpa
 	# ABI takes an offset, but recall the hpa to check trace event
 
-	inject_poison_sysfs "$region" 0
+	inject_poison_sysfs "$region" "$cache_size"
 	check_trace_entry "$region" "$hpa1"
-	inject_poison_sysfs "$region" "$gran"
+	inject_poison_sysfs "$region" "$((gran + cache_size))"
 	check_trace_entry "$region" "$hpa2"
 	validate_poison_found "-r $region" 2
 
-	clear_poison_sysfs "$region" 0
+	clear_poison_sysfs "$region" "$cache_size"
 	check_trace_entry "$region" "$hpa1"
-	clear_poison_sysfs "$region" "$gran"
+	clear_poison_sysfs "$region" "$((gran + cache_size))"
 	check_trace_entry "$region" "$hpa2"
 	validate_poison_found "-r $region" 0
 }
@@ -207,19 +211,32 @@ test_poison_by_region_offset_negative()
 	clear_poison_sysfs "$region" "$large_offset" true
 }
 
-# Clear old trace events, enable cxl_poison, enable global tracing
-echo "" > /sys/kernel/tracing/trace
-echo 1 > /sys/kernel/tracing/events/cxl/cxl_poison/enable
-echo 1 > /sys/kernel/tracing/tracing_on
+run_poison_test()
+{
+	# Clear old trace events, enable cxl_poison, enable global tracing
+	echo "" > /sys/kernel/tracing/trace
+	echo 1 > /sys/kernel/tracing/events/cxl/cxl_poison/enable
+	echo 1 > /sys/kernel/tracing/tracing_on
 
-test_poison_by_memdev_by_dpa
-find_auto_region
-test_poison_by_region_by_dpa
-[ -f "/sys/kernel/debug/cxl/$region/inject_poison" ] ||
-       do_skip "test cases requires inject by region kernel support"
-test_poison_by_region_offset
-test_poison_by_region_offset_negative
+	test_poison_by_memdev_by_dpa
+	find_auto_region
+	test_poison_by_region_by_dpa
+	[ -f "/sys/kernel/debug/cxl/$region/inject_poison" ] ||
+		do_skip "test cases requires inject by region kernel support"
+	test_poison_by_region_offset
+	test_poison_by_region_offset_negative
 
-check_dmesg "$LINENO"
+	check_dmesg "$LINENO"
+}
+
+modprobe -r cxl_test
+modprobe cxl_test
+rc=1
+run_poison_test
 
 modprobe -r cxl-test
+modprobe cxl_test extended_linear_cache=1
+rc=1
+run_poison_test
+
+modprobe -r cxl_test
-- 
2.51.1

