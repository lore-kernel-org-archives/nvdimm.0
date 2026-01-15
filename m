Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EF317DE36
	for <nvdimm@lists.linux.dev>; Thu, 15 Jan 2026 05:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768455409; cv=none; b=MCLKKqwgjU3VlN89UuABJfu+E2kimNKWqNGCRS4RRfjjuyt1VRZRQFXDETqo1hu7fMkwamT0qfpeA1POLbylqUz6uVkp9ET5OTOZrMop7wHcZLSmsGTU/N8DxVwICpgOuqHeML8dg7ukun8FW/HXQ16O6NsNZM9dhluPvZsvVq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768455409; c=relaxed/simple;
	bh=t3Rfc0scyiLcZrTVt1GR9/2HhhPXJpRRagG35W8u840=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BT3A5aD+UPGZmNSTyiscPj0QYSyA3mX9i5b9pKXzVFi2rvjGgvjVQRr/UE/HjHbAT4qMpoekb3c8TbG3086czyMruhv3gKp/t0oR5d41R3ANtQy6S+8ccwtyoO5DS52jcD+AF01HbqpqaLJcNO0wpYc6k6rn1Qo1MToDvhPPXt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jd+BDdB5; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jd+BDdB5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768455408; x=1799991408;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=t3Rfc0scyiLcZrTVt1GR9/2HhhPXJpRRagG35W8u840=;
  b=jd+BDdB5khhCuUxSckQnuIPmEHfOxs+9Rtmir1B2X7R7W5ZvW9f1muzI
   ApNZ0DkNMCtWO8wvQVJuLMBfu1wdDS7SCJer0W6v9DTsc6ZyCNfojAMIg
   Dqdn/NDCFZiJzjEv923NT2yCOWSJoRKhWvj0eEdaohm1caHrYzJR1+YuO
   Sv97/cPZws7Yl0Urt/geaHD7pPH1WMiKfFuX87eZlzmog6YB/1AKnWV9a
   bnD/JKrbV9zaAr5E8WUYyXttw+v5ICTRdPGW9+8tTt82rES8a3OuUho3L
   prMASK5tEoA396vszjge8WFRPR1b7iluOdSDXycEamxST+Vqyhv/mSh3P
   g==;
X-CSE-ConnectionGUID: N1sVvLXsRIGnVe61ozuZLQ==
X-CSE-MsgGUID: VKINlMcuT7q99C86bEuLwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="73611493"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="73611493"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 21:36:47 -0800
X-CSE-ConnectionGUID: YNTUAWbbReu6d+zrs//V+w==
X-CSE-MsgGUID: s2en41xfRm+ahLzMomw5gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="204491460"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.188])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 21:36:47 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH] cxl/test: test unaligned address translations in cxl_poison events
Date: Wed, 14 Jan 2026 21:36:39 -0800
Message-ID: <20260115053641.512420-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Existing cxl-poison.sh test cases only exercise regions whose base
addresses are aligned to host-bridge interleave ways (HBIW) * 256MB,
and so do not validate unaligned address translations.

Add a test case that exercises unaligned address translation by
creating a 3-way HBIW region, which in the cxl_test environment
results in an unaligned region base address.

The test validates bidirectional address translation like this:
- Clear poison by memdev/DPA to generate a cxl_poison trace event
- Extract the region offset from the HPA field in that trace
- Clear poison by region offset to generate a second trace event
- Verify the second trace event maps back to the original memdev/DPA

Expand check_trace_entry() to optionally verify memdev and DPA fields
to support this new case.

This test case is added last in cxl-poison.sh and will result in a
SKIP result when run on pre-7.0 kernels that do not support unaligned
address translation.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-poison.sh | 145 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 126 insertions(+), 19 deletions(-)

diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
index 59e807ece932..7b23460fd352 100644
--- a/test/cxl-poison.sh
+++ b/test/cxl-poison.sh
@@ -72,30 +72,28 @@ clear_poison_sysfs()
 check_trace_entry()
 {
 	local expected_region="$1"
-	local expected_hpa="$2"
+	local expected_hpa="$2"		# decimal
+	local expected_memdev="$3"	# optional
+	local expected_dpa="$4"		# optional, decimal
+	local trace_line trace_region trace_memdev trace_hpa trace_dpa
 
-	local trace_line
-	trace_line=$(grep "cxl_poison" /sys/kernel/tracing/trace | tail -n 1)
-	if [[ -z "$trace_line" ]]; then
-		echo "No cxl_poison trace event found"
-		err "$LINENO"
-	fi
+	trace_line=$(tail -n 1 /sys/kernel/tracing/trace | grep "cxl_poison")
+	 [[ -n "$trace_line" ]] || err "$LINENO"
 
-	local trace_region trace_hpa
 	trace_region=$(echo "$trace_line" | grep -o 'region=[^ ]*' | cut -d= -f2)
-	trace_hpa=$(echo "$trace_line" | grep -o 'hpa=0x[0-9a-fA-F]\+' | cut -d= -f2)
+	trace_memdev=$(echo "$trace_line" | grep -o 'memdev=[^ ]*' | cut -d= -f2)
 
-	if [[ "$trace_region" != "$expected_region" ]]; then
-		echo "Expected region $expected_region not found in trace"
-		echo "$trace_line"
-		err "$LINENO"
-	fi
+	# Convert HPA and DPA from hex to decimal
+        trace_hpa=$(($(echo "$trace_line" | grep -o 'hpa=0x[0-9a-fA-F]\+' | cut -d= -f2)))
+        trace_dpa=$(($(echo "$trace_line" | grep -o 'dpa=0x[0-9a-fA-F]\+' | cut -d= -f2)))
 
-	if [[ "$trace_hpa" != "$expected_hpa" ]]; then
-		echo "Expected HPA $expected_hpa not found in trace"
-		echo "$trace_line"
-		err "$LINENO"
-	fi
+	# Required checks
+	[[ "$trace_region" == "$expected_region" ]] || err "$LINENO"
+	[[ "$trace_hpa" == "$expected_hpa" ]] || err "$LINENO"
+
+	# Optional checks only enforced if expected value is provided
+	[[ -z "$expected_memdev" || "$trace_memdev" == "$expected_memdev" ]] || err "$LINENO"
+	[[ -z "$expected_dpa" || "$trace_dpa" == "$expected_dpa" ]] || err "$LINENO"
 }
 
 validate_poison_found()
@@ -211,6 +209,105 @@ test_poison_by_region_offset_negative()
 	clear_poison_sysfs "$region" "$large_offset" true
 }
 
+is_unaligned() {
+	local region=$1
+	local hbiw=$2
+	local align addr
+	local unit=$((256 * 1024 * 1024))	# 256MB
+
+	# Unaligned regions resources start at addresses that are
+	# not aligned to Host Bridge Interleave Ways * 256MB.
+
+	[[ -n "$region" && -n "$hbiw" ]] || err "$LINENO"
+	addr="$($CXL list -r "$region" | jq -r '.[0].resource')"
+	[[ -n "$addr" && "$addr" != "null" ]] || err "$LINENO"
+
+	align=$((hbiw * unit))
+	((addr % align != 0))
+}
+
+create_3way_interleave_region()
+{
+	# find an x3 decoder
+	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+		select(.pmem_capable == true) |
+		select(.nr_targets == 3) |
+		.decoder")
+	[[ $decoder ]] || err "$LINENO"
+
+	# Find a memdev for each host-bridge interleave position
+	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == 0) | .target")
+	port_dev1=$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == 1) | .target")
+	port_dev2=$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == 2) | .target")
+	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
+	mem1=$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")
+	mem2=$($CXL list -M -p "$port_dev2" | jq -r ".[0].memdev")
+	memdevs="$mem0 $mem1 $mem2"
+
+	region=$($CXL create-region -d "$decoder" -m "$memdevs" |
+		jq -r ".region")
+	[[ $region ]] || err "$LINENO"
+}
+
+verify_offset_translation()
+{
+    local region="$1"
+    local region_resource="$2"
+
+	# Verify that clearing by region offset maps to the same memdev/DPA
+	# as a previous clear by memdev/DPA
+
+	# Extract HPA, DPA, and memdev from the previous clear trace event
+	local trace_line memdev hpa dpa
+	trace_line=$(tail -n 1 /sys/kernel/tracing/trace | grep "cxl_poison")
+	[[ -n "$trace_line" ]] || err "$LINENO"
+
+	memdev=$(echo "$trace_line" | grep -o 'memdev=[^ ]*' | cut -d= -f2)
+	# Convert HPA and DPA to decimal
+	hpa=$(($(echo "$trace_line" | grep -o 'hpa=0x[0-9a-fA-F]\+' |cut -d= -f2)))
+	dpa=$(($(echo "$trace_line" | grep -o 'dpa=0x[0-9a-fA-F]\+' | cut -d= -f2)))
+	[[ -n "$memdev" && -n "$hpa" && -n "$dpa" ]] || err "$LINENO"
+
+	# Issue a clear poison using the found region offset
+	local region_offset=$((hpa - region_resource))
+	clear_poison_sysfs "$region" "$region_offset"
+
+	# Verify the trace event produces the same memdev/DPA for region HPA
+	check_trace_entry "$region" "$hpa" "$memdev" "$dpa"
+}
+
+run_unaligned_poison_test()
+{
+	create_3way_interleave_region
+	is_unaligned "$region" 3 ||
+		do_skip "unaligned region not available for testing"
+
+	# Get region start address and interleave granularity
+	read -r region_resource region_gran <<< "$($CXL list -r "$region" |
+		jq -r '.[0] | "\(.resource) \(.interleave_granularity)"')"
+
+	# Loop over the 3 memdevs in the region
+	for pos in 0 1 2; do
+		# Get memdev and decoder
+		memdev=$($CXL list -r "$region" --targets |
+			jq -r ".[0].mappings[$pos].memdev")
+		decoder=$($CXL list -r "$region" --targets |
+			jq -r ".[0].mappings[$pos].decoder")
+
+		# Get decoder DPA start
+		base_dpa=$($CXL list -d "$decoder" | jq -r '.[0].dpa_resource')
+
+		# Two samples: base and base + interleave granularity
+		for offset in 0 "$region_gran"; do
+			clear_poison_sysfs "$memdev" $((base_dpa + offset))
+			verify_offset_translation "$region" "$region_resource"
+		done
+	done
+}
+
 run_poison_test()
 {
 	# Clear old trace events, enable cxl_poison, enable global tracing
@@ -244,6 +341,16 @@ if check_min_kver "6.19"; then
 	run_poison_test
 fi
 
+# Unaligned address translation first appears in the CXL driver in 7.0
+if check_min_kver "7.0"; then
+	modprobe -r cxl_test
+	# HBIW of 3 happens to only be available w XOR at the moment
+	modprobe cxl_test interleave_arithmetic=1
+
+	rc=1
+	run_unaligned_poison_test
+fi
+
 check_dmesg "$LINENO"
 
 modprobe -r cxl_test
-- 
2.37.3

