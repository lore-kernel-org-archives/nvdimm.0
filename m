Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAB7194C96
	for <nvdimm@lists.linux.dev>; Fri, 24 Apr 2026 23:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777073798; cv=none; b=AXVx8X3deOQjdRSz3y5XZPcs+sWi44Y9B78Vvq1AxpWYJSlFxrQt5dVFNuzZSDNvcyR8NM4LBRmgLA5skKVT4tluqpdnitF4OBKiBsEoQK51aEJ5CMhiUFTFGn7MV2HwNwwv5kmD/Y/8uJNHFQcAFqyNq3TSh/yzhc69IBDRfVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777073798; c=relaxed/simple;
	bh=ZWknLbou99hTlcWH7w1BgXoEaa+OzeYCfx7ZxHjN4ls=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b4lMxLSoy9fzOTw3tt9w4RZnyAVWmbwCEZxYOayTfuF82NZWS+x1aWOeum4sODznwEvc8fsRVvpvh9l9QTu6Pejzqx1kwtETR+gBRtyhaf5tibT4gMfmptMOBeVRKxguUOQ6pwd48NwpiucWeY4wd7RPTWTN3k5RzoG++384hLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cMK5YluL; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cMK5YluL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777073796; x=1808609796;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZWknLbou99hTlcWH7w1BgXoEaa+OzeYCfx7ZxHjN4ls=;
  b=cMK5YluL2P5XWKKJZ3Vb05RtC7AhmjfQ7uixpSrR55HNpZgy+fErhHOG
   BXW+1PeQ4KpgA7nBTyR2p0dETrsm2iSCQLuHrSOSJScTWJtK5ygrQ0gMu
   VvcxrCE5FKyiS3SGC88u4BHpd4lQJGru88N0DEGZcCFCpxurBkRhmqDF9
   uvLYnb1rBP/vecmE407ICLz+oaSpz7rtb56q0Qa0FC0v66XDaelQzgaTD
   kEEcsJtFyH9/O8mAL1DeQ4+lxh4hLzlOzHu6FrpiJntW7PNIrhpzd5Wst
   Xt5PZlXyqzv/3837vQVF2yXaulJpf+3GIrMDeJw/f+Iyf/XswuHrg65sA
   A==;
X-CSE-ConnectionGUID: Xl/6O7WUTge43RALiXsk4A==
X-CSE-MsgGUID: 0KGzsg7SQ6qGMScWJTnyqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11766"; a="95473387"
X-IronPort-AV: E=Sophos;i="6.23,197,1770624000"; 
   d="scan'208";a="95473387"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 16:36:36 -0700
X-CSE-ConnectionGUID: MLK44oTpRHisox5K78gDDg==
X-CSE-MsgGUID: vj4ARa9dTIyerGb7CPSPyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,197,1770624000"; 
   d="scan'208";a="232921995"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.229])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 16:36:35 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH] test/btt-stress.sh: add stress test for BTT lane race
Date: Fri, 24 Apr 2026 16:36:31 -0700
Message-ID: <20260424233633.3762217-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The btt-check unit test exposed data mismatches during BTT I/O in a
CI environment, indicating a race in lane acquisition that can lead
to silent data corruption. The failure was not reliably reproduced
under typical test conditions.

Add a targeted stress test that repeatedly writes, reads, and verifies
data on a BTT namespace while background readers contend for BTT lanes
and CPU loops increase preemption pressure.

The test reproduces the race on an unfixed kernel and passes with the
lane ownership fix applied.

Assisted-By: Claude Sonnet 4.5
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/btt-stress.sh | 111 +++++++++++++++++++++++++++++++++++++++++++++
 test/meson.build   |   2 +
 2 files changed, 113 insertions(+)
 create mode 100755 test/btt-stress.sh

diff --git a/test/btt-stress.sh b/test/btt-stress.sh
new file mode 100755
index 000000000000..c1892f536d75
--- /dev/null
+++ b/test/btt-stress.sh
@@ -0,0 +1,111 @@
+#!/bin/bash -E
+# SPDX-License-Identifier: GPL-2.0
+
+dev=""
+mode=""
+size=""
+sector_size=""
+blockdev=""
+rc=77
+
+. $(dirname $0)/common
+
+trap 'err $LINENO' ERR
+
+check_min_kver "7.1" || do_skip "known BTT lane race before fix"
+
+# Stress BTT I/O under contention to exercise lane acquisition races.
+# Background readers contend for lanes while CPU loops increase
+# preemption pressure.
+
+create() {
+	json=$($NDCTL create-namespace -b "$NFIT_TEST_BUS0" -t pmem -m sector)
+	rc=2
+	eval "$(echo "$json" | json2var)"
+	[ -n "$dev" ] || err "$LINENO"
+	[ "$mode" = "sector" ] || err "$LINENO"
+	[ -n "$size" ] || err "$LINENO"
+	[ -n "$sector_size" ] || err "$LINENO"
+	[ -n "$blockdev" ] || err "$LINENO"
+	[ "$size" -gt 0 ] || err "$LINENO"
+}
+
+# Start background workers:
+#   - readers contend for lanes
+#   - CPU loops increase preemption
+start_bg_workers() {
+	local ncpus
+	ncpus=$(nproc)
+	local nworkers=$((ncpus / 2))
+
+	# Ensure at least one worker, cap to limit runtime noise
+	[ $nworkers -lt 1 ] && nworkers=1
+	[ $nworkers -gt 8 ] && nworkers=8
+
+	BG_PIDS=()
+	local i
+	for i in $(seq 1 $nworkers); do
+		# Reader: contends for lanes (use O_DIRECT to avoid page cache)
+		(while :; do
+			dd if=/dev/"$blockdev" of=/dev/null \
+				bs="$sector_size" count=256 \
+				iflag=direct >/dev/null 2>&1 || true
+		done) &
+		BG_PIDS+=($!)
+
+		# CPU hog: increase preemption
+		(while :; do :; done) &
+		BG_PIDS+=($!)
+	done
+	echo "started $nworkers readers + $nworkers CPU hogs"
+}
+
+stop_bg_workers() {
+	local pid
+	for pid in "${BG_PIDS[@]}"; do
+		kill "$pid" 2>/dev/null || true
+	done
+	wait "${BG_PIDS[@]}" 2>/dev/null || true
+	BG_PIDS=()
+}
+
+# Write, read, and verify data
+do_io_verify() {
+	dd if=/dev/urandom of=test-bin \
+		bs="$sector_size" count=$((size / sector_size)) >/dev/null 2>&1
+	dd if=test-bin of=/dev/"$blockdev" \
+		bs="$sector_size" count=$((size / sector_size)) >/dev/null 2>&1
+	dd if=/dev/"$blockdev" of=test-bin-read \
+		bs="$sector_size" count=$((size / sector_size)) >/dev/null 2>&1
+	diff test-bin test-bin-read
+	rm -f test-bin*
+}
+
+# Run verification under contention
+test_io_stress() {
+	local iterations=${1:-20}
+	echo "=== ${FUNCNAME[0]} ($iterations iterations) ==="
+
+	start_bg_workers
+	trap 'stop_bg_workers; err $LINENO' ERR
+
+	local i
+	for i in $(seq 1 "$iterations"); do
+		echo "--- iteration $i/$iterations ---"
+		do_io_verify
+	done
+
+	stop_bg_workers
+	trap 'err $LINENO' ERR
+}
+
+modprobe nfit_test
+rc=1
+reset && create
+
+# 30 iterations balances runtime and reproduction probability
+test_io_stress 30
+
+reset
+_cleanup
+exit 0
diff --git a/test/meson.build b/test/meson.build
index e0e2193bfd51..ee6a18762a17 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -150,6 +150,7 @@ sector_mode = find_program('sector-mode.sh')
 inject_error = find_program('inject-error.sh')
 btt_errors = find_program('btt-errors.sh')
 btt_pad_compat = find_program('btt-pad-compat.sh')
+btt_stress = find_program('btt-stress.sh')
 firmware_update = find_program('firmware-update.sh')
 rescan_partitions = find_program('rescan-partitions.sh')
 inject_smart = find_program('inject-smart.sh')
@@ -185,6 +186,7 @@ tests = [
   [ 'sector-mode.sh',         sector_mode,        'ndctl' ],
   [ 'inject-error.sh',        inject_error,	  'ndctl' ],
   [ 'btt-errors.sh',          btt_errors,	  'ndctl' ],
+  [ 'btt-stress.sh',          btt_stress,	  'ndctl' ],
   [ 'hugetlb',                hugetlb,		  'ndctl' ],
   [ 'btt-pad-compat.sh',      btt_pad_compat,	  'ndctl' ],
   [ 'ack-shutdown-count-set', ack_shutdown_count, 'ndctl' ],
-- 
2.37.3

