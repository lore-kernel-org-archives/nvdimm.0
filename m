Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9D64B2CCE
	for <nvdimm@lists.linux.dev>; Thu,  3 Sep 2026 21:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788471280; cv=none; b=nLnHbPtQ/sdnzHanFJPGBxTw6qwUu32XdMSaYFHSGM94fZ3rS4qgP4HlWLu7bPSbuv+G2vw8XwO51DQZHwNVzIk9Omx0JU7NGuoKRswYZObPU2OYqkhS23f162HdB6cJBR5XFqE/RHHu5p+AHwn3wV1tVQbS5KNSl1RMJ0ALVNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788471280; c=relaxed/simple;
	bh=dzrfLzZJfIrojEC8HScMibM/5gR463sx37BsKzLEuZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hWCao9+Xh5kYY848YPkRLTnQGe0/4QSIzNr5+u0sh7Cv75Uh1NU9SIX/Lb/qoXY3vYImI3u7S229ZnTK1KqVM338aml7t51AAlEPMvtMaAYkv+BJEOpvq26ndaBT9BoxpjkTsuJumgS9zQGQkoZj2IG81SlfatzhtcHsYxNWyDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XiBCTntG; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XiBCTntG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788471278; x=1820007278;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dzrfLzZJfIrojEC8HScMibM/5gR463sx37BsKzLEuZA=;
  b=XiBCTntGMAaTIVmtUnZut1RpkqXVLuCwgOogQvqaa2wXesE73sG05PiQ
   DZSOibGcrKj+o0yEhk0Y3iHy1xN/jMvux+QihS/JrTMlABWKaA9cOF71J
   SzE3+XMfLtEN56tzL4Rmd91EjvrOMSSLuU4m5iDpi/E0FC3ewg7q8UBsA
   Qp1Ay25PNkcTo61esSmRzvjWRyR8r9lZyh2acD7fbjhX7j199IB31eybO
   mOuK0zqGVRcziXLeZlJdlVHu+AcuKT0J6Ag52W4citZtp0nGe8zSy7Tix
   +0597nnPIAD+/0dNfgwyj5UZVqFKZEg08amkx1LZmSOhiQ1ywOutyWEe3
   w==;
X-CSE-ConnectionGUID: xQ67C1TKSFSXH4k9SncFIg==
X-CSE-MsgGUID: q+OZoR9QSLapiDn7HD9sOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="76523240"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="76523240"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 14:34:36 -0700
X-CSE-ConnectionGUID: cXY/FeDcQbuqobKNshQjrQ==
X-CSE-MsgGUID: e8bbHuLCSPKsifhO7JXkRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="263657958"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.10])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 14:34:36 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH v2 3/3] test/cxl-region-mixed.sh: test mixed-granularity region creation
Date: Thu,  3 Sep 2026 14:34:18 -0700
Message-ID: <38953b1cd1fd7a2df3978f489e59ab29469ef417.1788469004.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1788469004.git.alison.schofield@intel.com>
References: <cover.1788469004.git.alison.schofield@intel.com>
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

The mixed_gran_regions topology presents three root decoders over a
12-endpoint pool:
  - 2-way @ 4KB across 2 host bridges
  - 3-way @ 512B across 3 host bridges
  - 3-way @ 1KB across 3 host bridges

Positive cases run replay_regions to round-trip through the auto
create path. The auto path reads decoder values back from the
topology and runs them through the same position arithmetic the
user-create path uses. A region that creates successfully but
fails replay usually indicates a position arithmetic bug, so replay
coverage is the strongest correctness check we have at this layer.

The test cases are listed near the top of the script.


Assisted-by: Claude Opus 4.7
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-region-mixed.sh | 413 +++++++++++++++++++++++++++++++++++++++
 test/meson.build         |   2 +
 2 files changed, 415 insertions(+)
 create mode 100644 test/cxl-region-mixed.sh

diff --git a/test/cxl-region-mixed.sh b/test/cxl-region-mixed.sh
new file mode 100644
index 000000000000..ea208b7e048e
--- /dev/null
+++ b/test/cxl-region-mixed.sh
@@ -0,0 +1,413 @@
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
+
+# Replay support is exposed by cxl_acpi after cxl_test loads. Without it
+# replay_regions() would unbind and rebind cxl_acpi anyway and the test
+# would fail rather than skip.
+if [ ! -e /sys/bus/platform/devices/cxl_acpi.0/decoder_reset_preserve_registry ]; then
+	do_skip "test requires decoder registry replay support"
+fi
+
+rc=1
+
+expect_fail() {
+	"$@" || true
+}
+
+# Test mixed-granularity region configurations
+#
+# Topology: modprobe cxl_test mixed_gran_regions=1
+#   Three host bridges, two root ports each, one switch per root port,
+#   and two endpoints per switch, for twelve endpoints total. A region
+#   interleaves at the host bridge, at the switch, or at both, depending
+#   on which endpoints it is built from.
+#
+#   Three pmem windows:
+#     - 2-way @ 4096 across 2 host bridges
+#     - 3-way @ 512 across 3 host bridges
+#     - 3-way @ 1024 across 3 host bridges
+#
+# Cases (in execution order). Positive cases assert the interleave
+# programmed into the host bridge and switch decoders below the region,
+# then replay through the auto-create path to round-trip the
+# configuration; a region that creates but fails replay indicates a
+# position bug. Negative cases verify rejection at the first target
+# write, which is where the kernel applies the span identity.
+#
+# Positive:
+#   1. 3-way same-gran @512, 3-way root, every level below passthrough
+#   2. 4-way mixed-gran @2048, 2-way root, switch interleaves
+#   3. 4-way mixed-gran @2048, 2-way root, host bridge interleaves
+#   4. 6-way mixed-gran @256, 3-way root, CXL 4.0 Table 9-7 row 3
+#   5. 6-way mixed-gran @256, 3-way root, CXL 4.0 Table 9-7 row 2
+#   6. 8-way mixed-gran @1024, 2-way root, both levels interleave
+#   7. 12-way mixed-gran @256, 3-way root, CXL 4.0 Table 9-6 row 7
+# Negative:
+#   8. 6-way same-gran on 3-way root
+#   9. 8-way @512 on 2-way root @4096
+#  10. region_gran > root_gran rejected at sysfs write
+#
+# Table 9-6 row 6 has no case here. It is the one legal composition Linux
+# does not support, and a user cannot ask for it: each level below the
+# root takes its parent granularity divided by its own ways, so row 7 is
+# what gets programmed for a 12-way region on a 3-way root at 4*IGB.
+
+create_region() {
+	[[ $decoder && $ways && $region_ig && $memdevs ]] || err "$LINENO"
+	region=$($CXL create-region -d "$decoder" -w "$ways" -g "$region_ig" \
+		-m "$memdevs" | jq -r ".region")
+	[[ $region ]] || err "$LINENO"
+}
+
+# Locate a pmem root decoder by its ways and granularity.
+# Usage: find_root <ways> <granularity>
+find_root() {
+	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+		select(.pmem_capable == true) |
+		select(.nr_targets == $1) |
+		select(.interleave_granularity == $2) |
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
+# Return the switch ports below a host bridge port. Host bridge ports are
+# depth 1 and the switches below them are depth 2.
+# Usage: switch_ports <host_bridge_port>
+switch_ports() {
+	"$CXL" list -P -p "$1" |
+		jq -r '.. | objects | select(.depth == 2) | .host' | sort -V
+}
+
+# Return the memdevs below a port. Usage: port_memdevs <port>
+port_memdevs() {
+	"$CXL" list -M -p "$1" | jq -r '.[].memdev' | sort -V
+}
+
+# Build a position-ordered memdev list and set $ways to match.
+# Usage: select_memdevs <nr_host_bridges> <switches_per_hb> <endpoints_per_switch>
+#
+# Walk the root decoder targets in position order, then the switches below
+# each host bridge, then the endpoints below each switch, taking the
+# requested count at every level. That walk visits endpoints in region
+# position order, coarsest level first, which is the order create-region
+# assigns positions in. Taking fewer than the available count at a level
+# leaves that level passthrough, which is how a case selects whether the
+# host bridge or the switch does the interleaving.
+#
+# Endpoint selection has to go through the hierarchy: memdev names are
+# assigned in probe order and say nothing about topology.
+select_memdevs() {
+	local nr_hb=$1 nr_sw=$2 nr_ep=$3
+	local -a mems=()
+	local hb sw mem
+	local i nsw nep
+
+	# Force each case to restate what it expects below the root
+	hb_iw='' hb_ig='' sw_iw='' sw_ig=''
+
+	for ((i = 0; i < nr_hb; i++)); do
+		hb=$(target_port "$decoder" "$i")
+		[[ $hb ]] || err "$LINENO"
+
+		nsw=0
+		while read -r sw; do
+			[[ $nsw -lt $nr_sw ]] || break
+
+			nep=0
+			while read -r mem; do
+				[[ $nep -lt $nr_ep ]] || break
+				mems+=("$mem")
+				nep=$((nep + 1))
+			done < <(port_memdevs "$sw")
+			[[ $nep -eq $nr_ep ]] || err "$LINENO"
+
+			nsw=$((nsw + 1))
+		done < <(switch_ports "$hb")
+		[[ $nsw -eq $nr_sw ]] || err "$LINENO"
+	done
+
+	memdevs="${mems[*]}"
+	ways=$((nr_hb * nr_sw * nr_ep))
+	sel_hb=$nr_hb
+	sel_sw=$nr_sw
+}
+
+# Return the decoders at @1 that are attached to $region, one per line.
+# Host bridge ports are depth 1 and the switches below them are depth 2.
+#
+# "-d switch" is required, not just tidy: an endpoint's decoders are
+# reported inside the array of the port above it, so without the filter
+# a depth 2 switch port hands back its own decoder plus the endpoint
+# decoders below it.
+# Usage: region_decoders <depth>
+region_decoders() {
+	"$CXL" list -b cxl_test -P -D -d switch | jq -r --argjson depth "$1" \
+		--arg region "$region" '.. | objects | select(.depth? == $depth) |
+		to_entries[] | select(.key | startswith("decoders:")) |
+		.value[] | select(.region? == $region) | .decoder'
+}
+
+# Assert the interleave programmed at one level below the root.
+# Usage: check_level <depth> <nr_decoders> <ways> <granularity>
+check_level() {
+	local depth=$1 nr=$2 exp_iw=$3 exp_ig=$4
+	local -a decoders=()
+	local dec iw ig
+
+	mapfile -t decoders < <(region_decoders "$depth" | sort -V)
+	[[ ${#decoders[@]} -eq $nr ]] || {
+		echo "depth $depth: expected $nr decoders, got ${#decoders[@]}" >&2
+		err "$LINENO"
+	}
+
+	for dec in "${decoders[@]}"; do
+		iw=$(cat "/sys/bus/cxl/devices/$dec/interleave_ways")
+		ig=$(cat "/sys/bus/cxl/devices/$dec/interleave_granularity")
+		[[ $iw -eq $exp_iw && $ig -eq $exp_ig ]] || {
+			echo "$dec: expected iw $exp_iw ig $exp_ig, got iw $iw ig $ig" >&2
+			err "$LINENO"
+		}
+	done
+}
+
+# Assert the interleave the region programmed into the host bridge and
+# switch decoders beneath it.
+#
+# The region attributes and the replay signature both describe the region
+# as a whole, so neither says anything about how the interleave was
+# divided up on the way down to the endpoints. A divisor that is wrong
+# the same way everywhere satisfies both. These are the numbers CXL 4.0
+# Section 9.13.1.1 tabulates, taken from the case comments rather than
+# recomputed here.
+check_region_decoders() {
+	[[ $hb_iw && $hb_ig && $sw_iw && $sw_ig ]] || err "$LINENO"
+
+	check_level 1 "$sel_hb" "$hb_iw" "$hb_ig"
+	check_level 2 "$((sel_hb * sel_sw))" "$sw_iw" "$sw_ig"
+}
+
+# Sanity check on the mixed_gran_regions topology.
+test_mix_gran_topology_sanity() {
+	local nr_mem hb nr_sw nr_ep
+
+	nr_mem=$($CXL list -b cxl_test -M | jq length)
+	[[ $nr_mem -eq 12 ]] || {
+		echo "expected 12 memdevs, got $nr_mem" >&2
+		err "$LINENO"
+	}
+
+	# One root decoder per window
+	find_root 2 4096
+	find_root 3 512
+	find_root 3 1024
+
+	# Two switches below each host bridge, two endpoints below each
+	# switch. Without two switches the host bridge could never
+	# interleave and cases 3, 5, and 7 would silently test something
+	# else.
+	hb=$(target_port "$decoder" 0)
+	nr_sw=$(switch_ports "$hb" | wc -l)
+	[[ $nr_sw -eq 2 ]] || {
+		echo "expected 2 switches below $hb, got $nr_sw" >&2
+		err "$LINENO"
+	}
+	nr_ep=$(port_memdevs "$(switch_ports "$hb" | head -1)" | wc -l)
+	[[ $nr_ep -eq 2 ]] || {
+		echo "expected 2 endpoints below the switch, got $nr_ep" >&2
+		err "$LINENO"
+	}
+}
+
+# Positive: 3-way same-gran on the 3-way root, every level below
+# passthrough. One endpoint per host bridge.
+setup_x3_same_gran_passthrough() {
+	find_root 3 512
+	select_memdevs 3 1 1
+	region_ig=512
+	hb_iw=1 hb_ig=512
+	sw_iw=1 sw_ig=512
+}
+
+# Positive: 4-way mixed-gran on the 2-way root @4096, switch interleaves.
+# Both endpoints below one switch per host bridge, so the host bridge
+# passes through at 4096 and the switch interleaves 2-way at 2048.
+setup_x4_switch_interleave() {
+	find_root 2 4096
+	select_memdevs 2 1 2
+	region_ig=2048
+	hb_iw=1 hb_ig=4096
+	sw_iw=2 sw_ig=2048
+}
+
+# Positive: 4-way mixed-gran on the 2-way root @4096, host bridge
+# interleaves. One endpoint below each of the two switches per host
+# bridge, so the host bridge interleaves 2-way at 2048 and the switch
+# passes through.
+setup_x4_hb_interleave() {
+	find_root 2 4096
+	select_memdevs 2 2 1
+	region_ig=2048
+	hb_iw=2 hb_ig=2048
+	sw_iw=1 sw_ig=2048
+}
+
+# Positive: 6-way mixed-gran on the 3-way root @512.
+# CXL 4.0 Section 9.13.1.1 Table 9-7 row 3: host bridge passthrough,
+# switch 2-way at the region granularity.
+setup_x6_switch_interleave() {
+	find_root 3 512
+	select_memdevs 3 1 2
+	region_ig=256
+	hb_iw=1 hb_ig=512
+	sw_iw=2 sw_ig=256
+}
+
+# Positive: 6-way mixed-gran on the 3-way root @512.
+# CXL 4.0 Section 9.13.1.1 Table 9-7 row 2: host bridge 2-way at the
+# region granularity, switch passthrough.
+setup_x6_hb_interleave() {
+	find_root 3 512
+	select_memdevs 3 2 1
+	region_ig=256
+	hb_iw=2 hb_ig=256
+	sw_iw=1 sw_ig=256
+}
+
+# Positive: 8-way mixed-gran on the 2-way root @4096, interleaving at
+# every level. Root @4096, host bridge 2-way @2048, switch 2-way @1024.
+setup_x8_all_levels() {
+	find_root 2 4096
+	select_memdevs 2 2 2
+	region_ig=1024
+	hb_iw=2 hb_ig=2048
+	sw_iw=2 sw_ig=1024
+}
+
+# Positive: 12-way mixed-gran on the 3-way root @1024, interleaving at
+# every level. CXL 4.0 Section 9.13.1.1 Table 9-6 row 7: root 3-way
+# @4*IGB, host bridge 2-way @2*IGB, switch 2-way @IGB. This is the
+# composition Linux supports in place of the unsupported row 6.
+setup_x12_row7() {
+	find_root 3 1024
+	select_memdevs 3 2 2
+	region_ig=256
+	hb_iw=2 hb_ig=512
+	sw_iw=2 sw_ig=256
+}
+
+# Negative: 6-way same-gran on the 3-way root.
+# 6*512 != 3*512 — span identity violated
+setup_x6_same_gran_span_violation() {
+	find_root 3 512
+	select_memdevs 3 1 2
+	region_ig=512
+}
+
+# Negative: 8-way @512 on the 2-way root @4096.
+# 8*512 != 2*4096 — span identity violated
+setup_gran_too_small() {
+	find_root 2 4096
+	select_memdevs 2 2 2
+	region_ig=512
+}
+
+# Negative: region_gran > root_gran rejected at sysfs write.
+# Bypasses CLI to confirm the kernel gate, not the CLI, is the rejector.
+test_ig_gt_root_rejected() {
+	find_root 2 4096
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
+# Create, replay, and destroy a region. Usage: run_positive <setup_func>
+run_positive() {
+	"$1"
+	create_region
+	check_region_decoders
+	replay_regions || err "$LINENO"
+	$CXL destroy-region -f -b cxl_test "$region"
+}
+
+# Confirm a configuration is rejected, and that the kernel is what
+# rejected it. Usage: run_negative <setup_func>
+#
+# Exit status alone cannot tell a real rejection from a case that never
+# reached the kernel. create-region reserves DPA on each endpoint as it
+# goes and only deletes the region when a target write fails, so the
+# reservation made for target 0 outlives the case; enough negative cases
+# sharing an endpoint and create-region starts failing on the size it
+# cannot determine instead, which looks the same from here. Require the
+# failure to come from the first target write, and require no region to
+# be left behind.
+run_negative() {
+	local out nr_regions
+
+	"$1"
+	out=$(expect_fail "$CXL" create-region -d "$decoder" -w "$ways" \
+		-g "$region_ig" -m "$memdevs" 2>&1)
+	grep -q "failed to set target0" <<<"$out" || {
+		echo "expected rejection at the first target write, got:" >&2
+		echo "$out" >&2
+		err "$LINENO"
+	}
+
+	nr_regions=$($CXL list -b cxl_test -R | jq -r '.[].region' | wc -l)
+	[[ $nr_regions -eq 0 ]] || {
+		echo "rejected create left $nr_regions region(s) behind" >&2
+		err "$LINENO"
+	}
+	region=''
+}
+
+# Execution
+
+test_mix_gran_topology_sanity
+
+run_positive setup_x3_same_gran_passthrough
+run_positive setup_x4_switch_interleave
+run_positive setup_x4_hb_interleave
+run_positive setup_x6_switch_interleave
+run_positive setup_x6_hb_interleave
+run_positive setup_x8_all_levels
+run_positive setup_x12_row7
+
+run_negative setup_x6_same_gran_span_violation
+run_negative setup_gran_too_small
+
+test_ig_gt_root_rejected
+
+check_dmesg "$LINENO"
+
+modprobe -r cxl_test
diff --git a/test/meson.build b/test/meson.build
index 07c8618cbc6e..492e5b062eb5 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -173,6 +173,7 @@ cxl_elc = find_program('cxl-elc.sh')
 cxl_dax_hmem = find_program('cxl-dax-hmem.sh')
 cxl_region_replay = find_program('cxl-region-replay.sh')
 cxl_type2 = find_program('cxl-type2.sh')
+cxl_region_mixed = find_program('cxl-region-mixed.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -211,6 +212,7 @@ tests = [
   [ 'cxl-dax-hmem.sh',        cxl_dax_hmem,       'cxl'   ],
   [ 'cxl-region-replay.sh',   cxl_region_replay,  'cxl'   ],
   [ 'cxl-type2.sh',           cxl_type2,          'cxl'   ],
+  [ 'cxl-region-mixed.sh',    cxl_region_mixed,   'cxl'   ],
 ]
 
 if get_option('destructive').enabled()
-- 
2.37.3

