Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E0E2E62A8
	for <nvdimm@lists.linux.dev>; Thu, 15 Jan 2026 20:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768507368; cv=none; b=LwFDL9WtsodFmNRvlBp8Aeb6lJB6nUBfEOIZ4WI1xcQNsBbXCNdWklWCP+q0CBy25InxgCM5509iCSDVqpg9454buA9/shKLk6gF2kh8z6jhAxseASgeS6UuFKqiiWtjG962ErebDXGOpzYC+7dgiSk+u6ga7429aypGbyYF0mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768507368; c=relaxed/simple;
	bh=dOcVtKM1QTq0vPHTyP/XBs3/as6e+g1/nfJcBX7hNzw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ujsq8nmlS1bTucEptKnmkpYrRaVpmdxQGTxEybUjLmc3N3/pgtEG/WZ4JXWobuTs78jbZUvoTPpvOAAzd3+SI4m7Hiy0q+NltlO0iMfovhXjbSjXoSiNVKv9Gf6NxZVAJdA/B+iAPtArecUgdUZmjAO8/aCAleybr8JvELF4fSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NNDvn2QS; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NNDvn2QS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768507365; x=1800043365;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dOcVtKM1QTq0vPHTyP/XBs3/as6e+g1/nfJcBX7hNzw=;
  b=NNDvn2QSXErFf5WygnZmUDkcYI/MdjJb78FvBihyme4tACEahPsMwP/i
   lhNDw/9n4az4jSCf83oFmwhrt2sPA4XoZIreTJe8POthQPtFN8f2n4aQN
   TjpvZophe3UmdPAf2QVTgXarb4qyTKNgeJQX2fiHa4Pp2o9zgbHHclt7a
   eQiPQ+xdK2Pt5ocnIxC3zmhLBAMgScFclUAyncOAEPKiozNTbzEtfId8g
   A6Xb3AdI4WiUwJ+S+FSQ/0YeAX8eXYeWoZtTx0lwqX4NURmFVShqGng3O
   Pp03tcKJSYsPOKnYaz4K15uap51+n5OAPy7x/fePHpEddi256VVosptw1
   g==;
X-CSE-ConnectionGUID: JaPLEFrmQ/KxeVjjitbjaA==
X-CSE-MsgGUID: PSTjqaFbSKmESpwOeuCu6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69735033"
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="69735033"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 12:02:45 -0800
X-CSE-ConnectionGUID: zG5W9ZJ/Tl+tRGi/HU4Cmw==
X-CSE-MsgGUID: f9LzAUxXSdy6dR+kUV4SMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="204178291"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.9])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 12:02:44 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v2] cxl/test: test unaligned address translations in cxl_poison events
Date: Thu, 15 Jan 2026 12:02:32 -0800
Message-ID: <20260115200241.522809-1-alison.schofield@intel.com>
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

Changes in v2:
- Make check_trace_entry() handle both hex and decimal HPA/DPA inputs
  Fixes breakage in pre-existing test case.


 test/cxl-poison.sh | 153 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 132 insertions(+), 21 deletions(-)

diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
index 59e807ece932..58cf132b613b 100644
--- a/test/cxl-poison.sh
+++ b/test/cxl-poison.sh
@@ -72,30 +72,32 @@ clear_poison_sysfs()
 check_trace_entry()
 {
 	local expected_region="$1"
-	local expected_hpa="$2"
+	local expected_hpa="$2"		# hex or decimal
+	local expected_memdev="$3"	# optional
+	local expected_dpa="$4"		# optional, hex or decimal
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
+	trace_memdev=$(echo "$trace_line" | grep -o 'memdev=[^ ]*' | cut -d= -f2)
+
+	# Convert HPA and DPA from hex to decimal
+        trace_hpa=$(($(echo "$trace_line" | grep -o 'hpa=0x[0-9a-fA-F]\+' | cut -d= -f2)))
+        trace_dpa=$(($(echo "$trace_line" | grep -o 'dpa=0x[0-9a-fA-F]\+' | cut -d= -f2)))
+
+	# Convert expected values to decimal
+	expected_hpa=$((expected_hpa))
+	[[ -n "$expected_dpa" ]] && expected_dpa=$((expected_dpa))
+
+	# Required checks
+	[[ "$trace_region" == "$expected_region" ]] || err "$LINENO"
+	[[ "$trace_hpa" == "$expected_hpa" ]] || err "$LINENO"
+
+	# Optional checks only enforced if expected value is provided
+	[[ -z "$expected_memdev" || "$trace_memdev" == "$expected_memdev" ]] || err "$LINENO"
+	[[ -z "$expected_dpa" || "$trace_dpa" == "$expected_dpa" ]] || err "$LINENO"
 }
 
 validate_poison_found()
@@ -211,6 +213,105 @@ test_poison_by_region_offset_negative()
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
@@ -244,6 +345,16 @@ if check_min_kver "6.19"; then
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

