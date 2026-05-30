Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA66A19B5B1
	for <nvdimm@lists.linux.dev>; Sat, 30 May 2026 00:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780100337; cv=none; b=DfUx+6KRX5FpoBL5ZpVPqPmc1alP6hm9Ghn5jvAW36H2pqEHQqcBycmpcbO8ufpDPSaQvqEVEE1LQ5MeNPa0pW1Nf8d4aAthL+9jADW/5HP3G+9wH+noHdcwfyAHIo5kqYSKELnepTbxci6DiEWrDLe0HPAGeaauUdI1EZOOzfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780100337; c=relaxed/simple;
	bh=ZIhbPLRAHBSR6MzQO2ziLr+PYlcCP3hFw9C3qfXiVis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mFSY6jBP8n9IRNLDOg/rV1SK6XMfDUoZosU1PBUzmXvYqxhXvCvKi2w1Jw//o+JQoS4lNIP5TT8pfJl3DHDi7HM1XS6+1UFuRfVjBualQ4uPPjHgrlA4ITv6XEgqbipp2ph/WiGDfZXC0kaHgRBCWFsnT68nXKX9Az6pWX3xsy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Snlz38sI; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Snlz38sI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780100335; x=1811636335;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZIhbPLRAHBSR6MzQO2ziLr+PYlcCP3hFw9C3qfXiVis=;
  b=Snlz38sIyNCoQRo3qyvZ+q0x4dIZz57J1FscLZnex0PDxR9Q662HDMDQ
   zzUOeiubKT6GAmaz7XMO0vLoTGis297rH6AozH7id5L63K6doRlRMv8k5
   Ops5cz+Y/OIBi2lMdkrKDZAi893fPY3YXj3FNH9OE3QbR4VKTlOnN3Peb
   QjZ1nVc1v4sSdrFyYAsiUq/qNDLVUTzvGIsqpKPIsk/kuVC82+1OA0311
   zXgD+TcHpGixynZNzR5K1OLrh6sDu7v4/lo/gal42fEo3Dj4uEA4KEtTj
   hW4J1VsjVOtXiuLzkEmL174JR32kJZE8MhZEH2vQL0WWjfxrR7MC71E1s
   A==;
X-CSE-ConnectionGUID: RRp+fe6XQPaESGObepqznQ==
X-CSE-MsgGUID: oeaM3wJfRdG/MB81w3hBCw==
X-IronPort-AV: E=McAfee;i="6800,10657,11801"; a="92339075"
X-IronPort-AV: E=Sophos;i="6.24,176,1774335600"; 
   d="scan'208";a="92339075"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 17:18:53 -0700
X-CSE-ConnectionGUID: RMh+HU4zSN2o0VA8uFkJuQ==
X-CSE-MsgGUID: UOZz7+1mSIebW2jeU/Nj7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,176,1774335600"; 
   d="scan'208";a="247264556"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.60])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 17:18:53 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH 2/2] test/cxl-region-mixed.sh: test mixed-granularity region creation
Date: Fri, 29 May 2026 17:18:47 -0700
Message-ID: <7cc5ae46d895bf9e1bdf54b93a10a5c46b0c3488.1780099216.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <fa5c109f08824180f58341ebd9055545a2ff3142.1780099216.git.alison.schofield@intel.com>
References: <fa5c109f08824180f58341ebd9055545a2ff3142.1780099216.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Exercise mixed-granularity region configurations against the
mixed_gran_regions=1 cxl_test topology.

The mixed_gran_regions topology presents two root decoders over a
12-endpoint pool:
  - 2-way @ 4KB across 2 host bridges
  - 3-way @ 512B across 3 host bridges

Positive cases run replay_regions to round-trip through the auto
create path. The auto path reads decoder values back from the
topology and runs them through the same selector walk and position
arithmetic the user-create path uses. A region that creates
successfully but fails replay usually indicates a position
arithmetic bug, so replay coverage is the strongest correctness
check we have at this layer.

The test cases are listed near the top of the script.

Assisted-by: Claude Opus 4.7
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-region-mixed.sh | 297 +++++++++++++++++++++++++++++++++++++++
 test/meson.build         |   2 +
 2 files changed, 299 insertions(+)
 create mode 100644 test/cxl-region-mixed.sh

diff --git a/test/cxl-region-mixed.sh b/test/cxl-region-mixed.sh
new file mode 100644
index 000000000000..ffc3f86919af
--- /dev/null
+++ b/test/cxl-region-mixed.sh
@@ -0,0 +1,297 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2026 Intel Corporation. All rights reserved.
+
+# shellcheck disable=SC1091,SC2034
+. "$(dirname "$0")"/common
+rc=77
+set -ex
+trap 'err $LINENO' ERR
+check_prereq "jq"
+
+modinfo cxl_test | grep -q '^parm:.*mixed_gran_regions' ||
+	do_skip "cxl_test mixed_gran_regions module param not available"
+
+modprobe -r cxl_test
+modprobe cxl_test mixed_gran_regions=1
+rc=1
+
+expect_fail() {
+	"$@" || true
+}
+
+# Test mixed-granularity region configurations
+#
+# Topology: modprobe cxl_test mixed_gran_regions=1
+#   - 2-way pmem @ 4KB across 2 HBs (cfmws9)
+#   - 3-way pmem @ 512B across 3 HBs (cfmws10)
+#   with 12 endpoints total.
+#
+# Cases (in execution order). Positive cases also replay through
+# the auto-create path to round-trip the configuration; a region that
+# creates but fails replay indicates a position bug. Negative cases
+# verify rejection.
+#
+# Positive:
+#   1. 3-way same-gran on 3-way root, all switches passthrough
+#   2. 4-way p2 mixed-gran on 2-way root @ 4KB
+#   3. 4-way mixed-gran, L2 switches passthrough on 2-way root
+#   4. 6-way mixed-gran on 3-way root @ 512B
+#   5. 8-way multi-level mixed-gran on 2-way root @ 4KB
+# Negative:
+#   6. 6-way same-gran on 3-way root
+#   7. 8-way @ 512B on 2-way root @ 4KB
+#   8. region_gran > root_gran rejected at sysfs write
+
+create_region() {
+	[[ $decoder && $ways && $region_ig && $memdevs ]] || err "$LINENO"
+	region=$($CXL create-region -d "$decoder" -w "$ways" -g "$region_ig" \
+		-m "$memdevs" | jq -r ".region")
+	[[ $region ]] || err "$LINENO"
+}
+
+find_x2_root() {
+	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+		select(.pmem_capable == true) |
+		select(.nr_targets == 2) |
+		select(.interleave_granularity == 4096) |
+		.decoder")
+	[[ $decoder ]] || err "$LINENO"
+}
+
+find_x3_root() {
+	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+		select(.pmem_capable == true) |
+		select(.nr_targets == 3) |
+		select(.interleave_granularity == 512) |
+		.decoder")
+	[[ $decoder ]] || err "$LINENO"
+}
+
+# Return the port device that backs the given target position of a root
+# decoder. Usage: target_port <decoder> <position>
+target_port() {
+	"$CXL" list -T -d "$1" |
+		jq -r ".[] | .targets | .[] | select(.position == $2) | .target"
+}
+
+# Sanity check on the mixed_gran_regions topology.
+test_mix_gran_topology_sanity() {
+	local nr_mem
+	local x2 x3
+
+	nr_mem=$($CXL list -b cxl_test -M | jq length)
+	[[ $nr_mem -eq 12 ]] || {
+		echo "expected 12 memdevs, got $nr_mem" >&2
+		err "$LINENO"
+	}
+
+	x2=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+		select(.pmem_capable == true) |
+		select(.nr_targets == 2) |
+		select(.interleave_granularity == 4096) | .decoder")
+	[[ $x2 ]] || {
+		echo "expected x2 @ 4KB pmem root decoder" >&2
+		err "$LINENO"
+	}
+
+	x3=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+		select(.pmem_capable == true) |
+		select(.nr_targets == 3) |
+		select(.interleave_granularity == 512) | .decoder")
+	[[ $x3 ]] || {
+		echo "expected x3 @ 512B pmem root decoder" >&2
+		err "$LINENO"
+	}
+}
+
+# 3-way root setup: discover the 3 ports beneath it and the memdevs
+# visible under each. Each HB hosts a 3-level switch tree (L1 + L2)
+# but for the 3-way tests only L1 (or no level) interleaves; tests
+# select endpoints accordingly.
+setup_x3_topology() {
+	find_x3_root
+
+	port_dev0=$(target_port "$decoder" 0)
+	port_dev1=$(target_port "$decoder" 1)
+	port_dev2=$(target_port "$decoder" 2)
+
+	readarray -t hb0 < <("$CXL" list -M -p "$port_dev0" | jq -r '.[].memdev')
+	readarray -t hb1 < <("$CXL" list -M -p "$port_dev1" | jq -r '.[].memdev')
+	readarray -t hb2 < <("$CXL" list -M -p "$port_dev2" | jq -r '.[].memdev')
+}
+
+# 2-way root setup: discover the 2 ports beneath the x2 @ 4KB pmem
+# root and the memdevs visible under each. Used by all 2-way root
+# tests including multi-level cases.
+setup_x2_topology() {
+	find_x2_root
+
+	root_ig=$(cat "/sys/bus/cxl/devices/$decoder/interleave_granularity")
+	port_dev0=$(target_port "$decoder" 0)
+	port_dev1=$(target_port "$decoder" 1)
+
+	readarray -t hb0 < <("$CXL" list -M -p "$port_dev0" | jq -r '.[].memdev')
+	readarray -t hb1 < <("$CXL" list -M -p "$port_dev1" | jq -r '.[].memdev')
+}
+
+# Positive: 3-way same-gran on 3-way root, all switches passthrough
+setup_x3_same_gran_passthrough() {
+	setup_x3_topology
+
+	memdevs="${hb0[0]} ${hb1[0]} ${hb2[0]}"
+	ways=3
+	region_ig=512
+}
+
+# Positive: 4-way p2 mixed-gran on 2-way root @ 4KB.
+setup_x4_p2_mixed_gran() {
+	setup_x2_topology
+
+	region_ig=$((root_ig / 2))
+	[[ $region_ig -ge 256 ]] || err "$LINENO"
+
+	memdevs="${hb0[0]} ${hb0[1]} ${hb1[0]} ${hb1[1]}"
+	ways=4
+}
+
+# Positive: 4-way mixed-gran, L2 switches passthrough on 2-way root.
+setup_x4_l2_passthrough() {
+	setup_x2_topology
+
+	region_ig=2048
+
+	local -a l2_ports_hb0 l2_ports_hb1
+	readarray -t l2_ports_hb0 < <("$CXL" list -P -p "$port_dev0" |
+		jq -r '.. | objects | select(.depth == 3) | .host')
+	readarray -t l2_ports_hb1 < <("$CXL" list -P -p "$port_dev1" |
+		jq -r '.. | objects | select(.depth == 3) | .host')
+
+	local m0 m1 m2 m3
+	m0=$("$CXL" list -M -p "${l2_ports_hb0[0]}" | jq -r ".[0].memdev")
+	m1=$("$CXL" list -M -p "${l2_ports_hb0[1]}" | jq -r ".[0].memdev")
+	m2=$("$CXL" list -M -p "${l2_ports_hb1[0]}" | jq -r ".[0].memdev")
+	m3=$("$CXL" list -M -p "${l2_ports_hb1[1]}" | jq -r ".[0].memdev")
+	memdevs="$m0 $m1 $m2 $m3"
+	ways=4
+}
+
+# Positive: 6-way mixed-gran on 3-way root @ 512B.
+# Section 9.13.1.1 Table 9-7 row 2: 2-way HB beneath each root target
+setup_x6_mixed_gran() {
+	setup_x3_topology
+
+	memdevs="${hb0[0]} ${hb0[1]} ${hb1[0]} ${hb1[1]} ${hb2[0]} ${hb2[1]}"
+	ways=6
+	region_ig=256
+}
+
+# Positive: 8-way multi-level mixed-gran on 2-way root @ 4KB.
+# Root @ 4KB, L1 @ 2KB, L2 @ 1KB. Positions 0..3 under HB[0], 4..7
+# under HB[1]. Memdev order follows position math requirements.
+setup_x8_multi_level() {
+	setup_x2_topology
+
+	region_ig=$((root_ig / 4))
+	[[ $region_ig -ge 256 ]] || err "$LINENO"
+
+	local -a l2_ports_hb0 l2_ports_hb1
+	readarray -t l2_ports_hb0 < <("$CXL" list -P -p "$port_dev0" |
+		jq -r '.. | objects | select(.depth == 3) | .host')
+	readarray -t l2_ports_hb1 < <("$CXL" list -P -p "$port_dev1" |
+		jq -r '.. | objects | select(.depth == 3) | .host')
+
+	local -a br0 br1 br2 br3
+	readarray -t br0 < <("$CXL" list -M -p "${l2_ports_hb0[0]}" | jq -r '.[].memdev')
+	readarray -t br1 < <("$CXL" list -M -p "${l2_ports_hb0[1]}" | jq -r '.[].memdev')
+	readarray -t br2 < <("$CXL" list -M -p "${l2_ports_hb1[0]}" | jq -r '.[].memdev')
+	readarray -t br3 < <("$CXL" list -M -p "${l2_ports_hb1[1]}" | jq -r '.[].memdev')
+
+	memdevs="${br0[0]} ${br1[0]} ${br0[1]} ${br1[1]} ${br2[0]} ${br3[0]} ${br2[1]} ${br3[1]}"
+	ways=8
+}
+
+# Negative: 6-way same-gran on 3-way root
+# 6*512 != 3*512 — span identity violated
+setup_x6_same_gran_span_violation() {
+	setup_x3_topology
+
+	memdevs="${hb0[0]} ${hb0[1]} ${hb1[0]} ${hb1[1]} ${hb2[0]} ${hb2[1]}"
+	ways=6
+	region_ig=512
+}
+
+# Negative: 8-way @ 512B on 2-way root @ 4KB.
+# Selector walk rejects: root selector bit lands outside the region
+# selector mask (containment fails).
+setup_gran_too_small() {
+	setup_x2_topology
+
+	region_ig=512
+	memdevs="${hb0[*]} ${hb1[*]}"
+	ways=8
+}
+
+# Negative: region_gran > root_gran rejected at sysfs write.
+# Bypasses CLI to confirm the kernel gate, not the CLI, is the rejector.
+test_ig_gt_root_rejected() {
+	find_x2_root
+
+	root_ig=$(cat "/sys/bus/cxl/devices/$decoder/interleave_granularity")
+	bad_ig=$((root_ig * 2))
+
+	region=$(cat "/sys/bus/cxl/devices/$decoder/create_pmem_region")
+	echo "$region" >"/sys/bus/cxl/devices/$decoder/create_pmem_region"
+
+	if echo "$bad_ig" >"/sys/bus/cxl/devices/$region/interleave_granularity" \
+		2>/dev/null; then
+		err "$LINENO"
+	fi
+
+	echo "$region" >"/sys/bus/cxl/devices/$decoder/delete_region"
+}
+
+# Execution
+
+test_mix_gran_topology_sanity
+
+setup_x3_same_gran_passthrough
+create_region
+replay_regions || err "$LINENO"
+$CXL destroy-region -f -b cxl_test "$region"
+
+setup_x4_p2_mixed_gran
+create_region
+replay_regions || err "$LINENO"
+$CXL destroy-region -f -b cxl_test "$region"
+
+setup_x4_l2_passthrough
+create_region
+replay_regions || err "$LINENO"
+$CXL destroy-region -f -b cxl_test "$region"
+
+setup_x6_mixed_gran
+create_region
+replay_regions || err "$LINENO"
+$CXL destroy-region -f -b cxl_test "$region"
+
+setup_x8_multi_level
+create_region
+replay_regions || err "$LINENO"
+$CXL destroy-region -f -b cxl_test "$region"
+
+setup_x6_same_gran_span_violation
+region=$(expect_fail "$CXL" create-region -d "$decoder" -w "$ways" \
+	-g "$region_ig" -m "$memdevs" | jq -r ".region")
+[[ ! $region ]] || err "$LINENO"
+
+setup_gran_too_small
+region=$(expect_fail "$CXL" create-region -d "$decoder" -w "$ways" \
+	-g "$region_ig" -m "$memdevs" | jq -r ".region")
+[[ ! $region ]] || err "$LINENO"
+
+test_ig_gt_root_rejected
+
+check_dmesg "$LINENO"
+
+modprobe -r cxl_test
diff --git a/test/meson.build b/test/meson.build
index e0e2193bfd51..67eb815db529 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -171,6 +171,7 @@ cxl_translate = find_program('cxl-translate.sh')
 cxl_elc = find_program('cxl-elc.sh')
 cxl_dax_hmem = find_program('cxl-dax-hmem.sh')
 cxl_region_replay = find_program('cxl-region-replay.sh')
+cxl_region_mixed = find_program('cxl-region-mixed.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -207,6 +208,7 @@ tests = [
   [ 'cxl-elc.sh',             cxl_elc,            'cxl'   ],
   [ 'cxl-dax-hmem.sh',        cxl_dax_hmem,       'cxl'   ],
   [ 'cxl-region-replay.sh',   cxl_region_replay,  'cxl'   ],
+  [ 'cxl-region-mixed.sh',    cxl_region_mixed,   'cxl'   ],
 ]
 
 if get_option('destructive').enabled()
-- 
2.37.3

