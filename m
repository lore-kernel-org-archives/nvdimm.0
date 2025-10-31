Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B0B27144A;
	Fri, 31 Oct 2025 17:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761932411; cv=none; b=twi3pVMkqGhljkeYJlKCDf1O6pp0SM4OA5OJ8QprVS1rqZamGiwoVu3Gwy35cw4MntOnbcANHvTMWvSEde+vpx0geEG27xWiY3LuKVtLdn8xFPk1b1dXXwzrj7UPY0jiJjCzqjR3sJNjUI7SmeDqWh4uDbDvAGmm9ikf1w/Ynsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761932411; c=relaxed/simple;
	bh=t85GV6pfmdlRapwIPymMTuPYlttx5cWnK3UfF0B4w4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRd5AxYH++qZPgRmBuhi/kmxtg+0NfzulHkfT+YvDW7yaoYTKLqVFggsNsF2nU+bMYjK/d+1TfWbeidrpSejmHBe9dXpx91KXgJlSpGoIi2US3t8BGzKH+CDFvWwvxMFw4zUrZxLRknwscrnIJ1HLLZz3a8RKLVKpcQLcP0tviA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA05C4CEE7;
	Fri, 31 Oct 2025 17:40:10 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com
Subject: [NDCTL PATCH 4/5] cxl/test: Move common part of poison unit test to common file
Date: Fri, 31 Oct 2025 10:40:02 -0700
Message-ID: <20251031174003.3547740-5-dave.jiang@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251031174003.3547740-1-dave.jiang@intel.com>
References: <20251031174003.3547740-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To allow extended linear cache to also utilize the poison test, move
the common helper functions to a common file for sourcing.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 test/common-poison | 190 +++++++++++++++++++++++++++++++++++++++++++++
 test/cxl-poison.sh | 187 +-------------------------------------------
 2 files changed, 191 insertions(+), 186 deletions(-)
 create mode 100644 test/common-poison

diff --git a/test/common-poison b/test/common-poison
new file mode 100644
index 000000000000..15a091e41dc3
--- /dev/null
+++ b/test/common-poison
@@ -0,0 +1,190 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2025 Intel Corporation. All rights reserved.
+
+find_memdev()
+{
+	readarray -t capable_mems < <("$CXL" list -b "$CXL_TEST_BUS" -M |
+		jq -r ".[] | select(.pmem_size != null) |
+		select(.ram_size != null) | .memdev")
+
+	if [ ${#capable_mems[@]} == 0 ]; then
+		echo "no memdevs found for test"
+		err "$LINENO"
+	fi
+
+	memdev=${capable_mems[0]}
+}
+
+find_auto_region()
+{
+	region="$($CXL list -b "$CXL_TEST_BUS" -R | jq -r ".[0].region")"
+	[[ -n "$region" && "$region" != "null" ]] || do_skip "no test region found"
+	mem0="$($CXL list -r "$region" --targets | jq -r ".[0].mappings[0].memdev")"
+	[[ -n "$mem0" && "$mem0" != "null" ]] || do_skip "no region target0 found"
+	mem1="$($CXL list -r "$region" --targets | jq -r ".[0].mappings[1].memdev")"
+	[[ -n "$mem1" && "$mem1" != "null" ]] || do_skip "no region target1 found"
+	echo "$region"
+}
+
+# When cxl-cli support for inject and clear arrives, replace
+# the writes to /sys/kernel/debug with the new cxl commands.
+
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
+inject_poison_sysfs()
+{
+	_do_poison_sysfs 'inject' "$@"
+}
+
+clear_poison_sysfs()
+{
+	_do_poison_sysfs 'clear' "$@"
+}
+
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
+}
+
+validate_poison_found()
+{
+	list_by="$1"
+	nr_expect="$2"
+
+	poison_list="$($CXL list "$list_by" --media-errors |
+		jq -r '.[].media_errors')"
+	if [[ ! $poison_list ]]; then
+		nr_found=0
+	else
+		nr_found=$(jq "length" <<< "$poison_list")
+	fi
+	if [ "$nr_found" -ne "$nr_expect" ]; then
+		echo "$nr_expect poison records expected, $nr_found found"
+		err "$LINENO"
+	fi
+}
+
+test_poison_by_memdev_by_dpa()
+{
+	find_memdev
+	inject_poison_sysfs "$memdev" "0x40000000"
+	inject_poison_sysfs "$memdev" "0x40001000"
+	inject_poison_sysfs "$memdev" "0x600"
+	inject_poison_sysfs "$memdev" "0x0"
+	validate_poison_found "-m $memdev" 4
+
+	clear_poison_sysfs "$memdev" "0x40000000"
+	clear_poison_sysfs "$memdev" "0x40001000"
+	clear_poison_sysfs "$memdev" "0x600"
+	clear_poison_sysfs "$memdev" "0x0"
+	validate_poison_found "-m $memdev" 0
+}
+
+test_poison_by_region_by_dpa()
+{
+	inject_poison_sysfs "$mem0" "0"
+	inject_poison_sysfs "$mem1" "0"
+	validate_poison_found "-r $region" 2
+
+	clear_poison_sysfs "$mem0" "0"
+	clear_poison_sysfs "$mem1" "0"
+	validate_poison_found "-r $region" 0
+}
+
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
+	# Inject at the offset and check result using the hpa
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
+	if [ -f "/sys/bus/cxl/devices/$region/extended_linear_cache_size" ]; then
+		cache_size=$(cat /sys/bus/cxl/devices/"$region"/extended_linear_cache_size)
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
diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
index 430780cf7128..b4caec0af12a 100644
--- a/test/cxl-poison.sh
+++ b/test/cxl-poison.sh
@@ -21,192 +21,7 @@ rc=1
 # THEORY OF OPERATION: Exercise cxl-cli and cxl driver ability to
 # inject, clear, and get the poison list. Do it by memdev and by region.
 
-find_memdev()
-{
-	readarray -t capable_mems < <("$CXL" list -b "$CXL_TEST_BUS" -M |
-		jq -r ".[] | select(.pmem_size != null) |
-		select(.ram_size != null) | .memdev")
-
-	if [ ${#capable_mems[@]} == 0 ]; then
-		echo "no memdevs found for test"
-		err "$LINENO"
-	fi
-
-	memdev=${capable_mems[0]}
-}
-
-find_auto_region()
-{
-	region="$($CXL list -b "$CXL_TEST_BUS" -R | jq -r ".[0].region")"
-	[[ -n "$region" && "$region" != "null" ]] || do_skip "no test region found"
-	mem0="$($CXL list -r "$region" --targets | jq -r ".[0].mappings[0].memdev")"
-	[[ -n "$mem0" && "$mem0" != "null" ]] || do_skip "no region target0 found"
-	mem1="$($CXL list -r "$region" --targets | jq -r ".[0].mappings[1].memdev")"
-	[[ -n "$mem1" && "$mem1" != "null" ]] || do_skip "no region target1 found"
-	echo "$region"
-}
-
-# When cxl-cli support for inject and clear arrives, replace
-# the writes to /sys/kernel/debug with the new cxl commands.
-
-_do_poison_sysfs()
-{
-	local action="$1" dev="$2" addr="$3"
-	local expect_fail=${4:-false}
-
-	if "$expect_fail"; then
-		if echo "$addr" > "/sys/kernel/debug/cxl/$dev/${action}_poison"; then
-			echo "Expected ${action}_poison to fail for $addr"
-			err "$LINENO"
-		fi
-	else
-		echo "$addr" > "/sys/kernel/debug/cxl/$dev/${action}_poison"
-	fi
-}
-
-inject_poison_sysfs()
-{
-	_do_poison_sysfs 'inject' "$@"
-}
-
-clear_poison_sysfs()
-{
-	_do_poison_sysfs 'clear' "$@"
-}
-
-check_trace_entry()
-{
-	local expected_region="$1"
-	local expected_hpa="$2"
-
-	local trace_line
-	trace_line=$(grep "cxl_poison" /sys/kernel/tracing/trace | tail -n 1)
-	if [[ -z "$trace_line" ]]; then
-		echo "No cxl_poison trace event found"
-		err "$LINENO"
-	fi
-
-	local trace_region trace_hpa
-	trace_region=$(echo "$trace_line" | grep -o 'region=[^ ]*' | cut -d= -f2)
-	trace_hpa=$(echo "$trace_line" | grep -o 'hpa=0x[0-9a-fA-F]\+' | cut -d= -f2)
-
-	if [[ "$trace_region" != "$expected_region" ]]; then
-		echo "Expected region $expected_region not found in trace"
-		echo "$trace_line"
-		err "$LINENO"
-	fi
-
-	if [[ "$trace_hpa" != "$expected_hpa" ]]; then
-		echo "Expected HPA $expected_hpa not found in trace"
-		echo "$trace_line"
-		err "$LINENO"
-	fi
-}
-
-validate_poison_found()
-{
-	list_by="$1"
-	nr_expect="$2"
-
-	poison_list="$($CXL list "$list_by" --media-errors |
-		jq -r '.[].media_errors')"
-	if [[ ! $poison_list ]]; then
-		nr_found=0
-	else
-		nr_found=$(jq "length" <<< "$poison_list")
-	fi
-	if [ "$nr_found" -ne "$nr_expect" ]; then
-		echo "$nr_expect poison records expected, $nr_found found"
-		err "$LINENO"
-	fi
-}
-
-test_poison_by_memdev_by_dpa()
-{
-	find_memdev
-	inject_poison_sysfs "$memdev" "0x40000000"
-	inject_poison_sysfs "$memdev" "0x40001000"
-	inject_poison_sysfs "$memdev" "0x600"
-	inject_poison_sysfs "$memdev" "0x0"
-	validate_poison_found "-m $memdev" 4
-
-	clear_poison_sysfs "$memdev" "0x40000000"
-	clear_poison_sysfs "$memdev" "0x40001000"
-	clear_poison_sysfs "$memdev" "0x600"
-	clear_poison_sysfs "$memdev" "0x0"
-	validate_poison_found "-m $memdev" 0
-}
-
-test_poison_by_region_by_dpa()
-{
-	inject_poison_sysfs "$mem0" "0"
-	inject_poison_sysfs "$mem1" "0"
-	validate_poison_found "-r $region" 2
-
-	clear_poison_sysfs "$mem0" "0"
-	clear_poison_sysfs "$mem1" "0"
-	validate_poison_found "-r $region" 0
-}
-
-test_poison_by_region_offset()
-{
-	local base gran hpa1 hpa2
-	base=$(cat /sys/bus/cxl/devices/"$region"/resource)
-	gran=$(cat /sys/bus/cxl/devices/"$region"/interleave_granularity)
-
-	# Test two HPA addresses: base and base + granularity
-	# This hits the two memdevs in the region interleave.
-	hpa1=$(printf "0x%x" $((base)))
-	hpa2=$(printf "0x%x" $((base + gran)))
-
-	# Inject at the offset and check result using the hpa
-	# ABI takes an offset, but recall the hpa to check trace event
-
-	inject_poison_sysfs "$region" 0
-	check_trace_entry "$region" "$hpa1"
-	inject_poison_sysfs "$region" "$gran"
-	check_trace_entry "$region" "$hpa2"
-	validate_poison_found "-r $region" 2
-
-	clear_poison_sysfs "$region" 0
-	check_trace_entry "$region" "$hpa1"
-	clear_poison_sysfs "$region" "$gran"
-	check_trace_entry "$region" "$hpa2"
-	validate_poison_found "-r $region" 0
-}
-
-test_poison_by_region_offset_negative()
-{
-	local region_size cache_size cache_offset exceed_offset large_offset
-	region_size=$(cat /sys/bus/cxl/devices/"$region"/size)
-	cache_size=0
-
-	# This case is a no-op until cxl-test ELC mocking arrives
-	# Try to get cache_size if the attribute exists
-	if [ -f "/sys/bus/cxl/devices/$region/extended_linear_cache_size" ]; then
-		cache_size=$(cat /sys/bus/cxl/devices/"$region"/extended_linear_cache_size)
-	fi
-
-	# Offset within extended linear cache (if cache_size > 0)
-	if [[ $cache_size -gt 0 ]]; then
-		cache_offset=$((cache_size - 1))
-		echo "Testing offset within cache: $cache_offset (cache_size: $cache_size)"
-		inject_poison_sysfs "$region" "$cache_offset" true
-		clear_poison_sysfs "$region" "$cache_offset" true
-	else
-		echo "Skipping cache test - cache_size is 0"
-	fi
-
-	# Offset exceeds region size
-	exceed_offset=$((region_size))
-	inject_poison_sysfs "$region" "$exceed_offset" true
-	clear_poison_sysfs "$region" "$exceed_offset" true
-
-	# Offset exceeds region size by a lot
-	large_offset=$((region_size * 2))
-	inject_poison_sysfs "$region" "$large_offset" true
-	clear_poison_sysfs "$region" "$large_offset" true
-}
+. "$(dirname "$0")"/common-poison
 
 # Clear old trace events, enable cxl_poison, enable global tracing
 echo "" > /sys/kernel/tracing/trace
-- 
2.51.0

