Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424733ACA41
	for <nvdimm@lists.linux.dev>; Fri, 17 Apr 2026 19:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776455794; cv=none; b=pkAhDRAaJao5wvF5H4DuiddOoLTGL1pF8dhDlenqQIx0lRZ67gE6loUQSoN+vkI0MCDGtRQ5LEnK3lYFdVqbA8lQf+ZqIneIs7z6cZ4kdCrAQk0L42GmCOyGi8RaDf28mOyL870z6vl31LYNW6aLtZJRGwLl1SCLwD3pnpqjbfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776455794; c=relaxed/simple;
	bh=O71hqBeZQPpqnHmMrSdWvCdrTPwJvmuxC3tejCkTBI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kggZcq58yXqbXM0HnIpvp6/tUoSFtCHxsAP2Q6R+mZ5RfztWTqbK3yH+WF/4JAJ/KPt+wUlrCQZO3axMC9YPcJT2vCsaC31Kc7Qd1zp2hGxo712Dku0yrzeoBVeDn2d14gfb4FOFLkae86xaaVHq9k2JMHHYmDUzwtXDFAb9CxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dRn6lXDP; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dRn6lXDP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776455792; x=1807991792;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O71hqBeZQPpqnHmMrSdWvCdrTPwJvmuxC3tejCkTBI8=;
  b=dRn6lXDP75sxI813NREhi3rjVmENUHsRpDIjUvAMZxnioDnVowAE1xjb
   8Ig53MENPuIuI9EWEkjYqEMPxE+MnQJxi+UJQzT/YxeMAGGTIasavAaO5
   TMcoKQXh4sOQ2TLAlYGLgA+gLKzWiyCVO+3cypm4eoePcV3GqodhX2R2n
   Ns9Mv2rE7VI39HRjz0GdotvOqMGHc0YmUFwuVdrOeYudUq2vd1B3x6liU
   C0sd99PZYajgIRLnSKZt94g08zhiNWAVtVIEhIaCINB3pUDjJoU0onLQk
   sBd42VPxWYkZOUFz1Qsi8d0iCQGGhLij/mvTmCmOLRfUS5+xPYx9e0szw
   Q==;
X-CSE-ConnectionGUID: bGwIYb9BQeyo103wspFpcQ==
X-CSE-MsgGUID: tsBY274PTtWTwH3mbDR8lQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11762"; a="77548550"
X-IronPort-AV: E=Sophos;i="6.23,184,1770624000"; 
   d="scan'208";a="77548550"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2026 12:56:32 -0700
X-CSE-ConnectionGUID: yuq24cs+SGyHZj8+RpE3kQ==
X-CSE-MsgGUID: 1tAdxqeERjmxGjacXoq45w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,184,1770624000"; 
   d="scan'208";a="224620545"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.223.71])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2026 12:56:31 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	"Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>
Subject: [ndctl PATCH v2 2/2] test/cxl-region-replay.sh: add test of region replay workflow
Date: Fri, 17 Apr 2026 12:56:24 -0700
Message-ID: <81c7cdd6cbcb4f1f77870ff02d8dd86298036f58.1776454849.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <ccc1955b697f7b74e16924bff1b1e262eb52fba0.1776454849.git.alison.schofield@intel.com>
References: <ccc1955b697f7b74e16924bff1b1e262eb52fba0.1776454849.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a CXL unit test that exercises the replay_regions() helpers
introduced in test/common.

The test creates regions through the user interface, captures the
resulting region configuration, performs a cxl_acpi driver unbind/bind
cycle, and verifies that the regions reconstructed during enumeration
match the original configuration.

This validates the decoder replay mechanism implemented in the kernel
cxl_test module by replaying user-created regions as auto-discovered
regions during driver initialization.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: "Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>
Tested-by: "Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>
Link: https://lore.kernel.org/r/7ec630ea29675b57c052e9606b1d33177e989a2a.1773466514.git.alison.schofield@intel.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

Changes in v2:
- Rebase onto latest ndctl/pending
- Add Fabio's Tags


 test/cxl-region-replay.sh | 148 ++++++++++++++++++++++++++++++++++++++
 test/meson.build          |   2 +
 2 files changed, 150 insertions(+)
 create mode 100644 test/cxl-region-replay.sh

diff --git a/test/cxl-region-replay.sh b/test/cxl-region-replay.sh
new file mode 100644
index 000000000000..3049ca9f34b5
--- /dev/null
+++ b/test/cxl-region-replay.sh
@@ -0,0 +1,148 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2022 Intel Corporation. All rights reserved.
+
+. $(dirname $0)/common
+
+rc=77
+
+set -ex
+
+trap 'err $LINENO' ERR
+
+check_prereq "jq"
+
+modprobe -r cxl_test
+modprobe cxl_test
+
+# Replay support is exposed by cxl_acpi after cxl_test loads
+if [ ! -e /sys/bus/platform/devices/cxl_acpi.0/decoder_reset_preserve_registry ]; then
+	do_skip "test requires decoder registry replay support"
+fi
+
+rc=1
+
+# Demonstrate and validate CXL region replay support in cxl_test.
+#
+# Replay helpers in test/common snapshot the current region topology,
+# replay the configuration, and verify that the reconstructed regions
+# match the original configuration.
+#
+# Tests should use the common helper:
+#   replay_regions
+#
+# This test serves as both a sanity check for replay support and an
+# example of how other cxl_test unit tests can use replay_regions().
+
+destroy_regions() {
+	$CXL destroy-region -f -b cxl_test all
+}
+
+create_region() {
+	region=$($CXL create-region -d "$decoder" -m "$memdevs" |
+		jq -r ".region")
+
+	if [[ ! $region ]]; then
+		echo "create-region failed for $decoder"
+		err "$LINENO"
+	fi
+}
+
+create_x2_pmem_region() {
+	# Find a pmem-capable x2 decoder
+	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+		select(.pmem_capable == true) |
+		select(.nr_targets == 2) |
+		.decoder")
+
+	# Select one memdev for each host-bridge interleave position
+	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == 0) | .target")
+	port_dev1=$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == 1) | .target")
+	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
+	mem1=$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")
+	memdevs="$mem0 $mem1"
+	create_region
+}
+
+create_x4_ram_region() {
+	# Find a volatile-capable x2 decoder
+	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+		select(.volatile_capable == true) |
+		select(.nr_targets == 2) |
+		.decoder")
+
+	# Select two memdevs for each host-bridge interleave position
+	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == 0) | .target")
+	port_dev1=$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == 1) | .target")
+	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
+	mem1=$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")
+	mem2=$($CXL list -M -p "$port_dev0" | jq -r ".[1].memdev")
+	mem3=$($CXL list -M -p "$port_dev1" | jq -r ".[1].memdev")
+	memdevs="$mem0 $mem1 $mem2 $mem3"
+	create_region
+}
+
+AUTO_MEMDEVS=""
+AUTO_ROOT_DECODER=""
+
+capture_auto_region() {
+	local region_json dec_json
+
+	region_json=$($CXL list -R --targets)
+
+	# Expect exactly one auto region
+	[ "$(jq 'length' <<<"$region_json")" -eq 1 ] || err "$LINENO"
+
+	AUTO_MEMDEVS=$(jq -r '.[0].mappings | sort_by(.position) | .[].memdev' \
+		<<<"$region_json" | xargs)
+	[[ $AUTO_MEMDEVS ]] || err "$LINENO"
+
+	dec_json=$($CXL list -R --decoders)
+	AUTO_ROOT_DECODER=$(jq -r '.[0]["root decoders"][0].decoder' <<<"$dec_json")
+	[[ $AUTO_ROOT_DECODER ]] || err "$LINENO"
+}
+
+create_user_region_in_auto_region_space() {
+	decoder="$AUTO_ROOT_DECODER"
+	memdevs="$AUTO_MEMDEVS"
+	create_region
+}
+
+# To remove the auto region, destroy and recreate in user space.
+# With that action, there will be no 'auto' decoders and it will not be
+# preserved across acpi rebind.
+#
+# This is done here as example if test wants the resources freed
+remove_auto_region() {
+	capture_auto_region
+	destroy_regions
+	create_user_region_in_auto_region_space
+	destroy_regions
+	replay_regions || err "$LINENO"
+}
+
+# Replay the built-in auto region
+[ "$($CXL list -R | jq 'length')" -ne 0 ] || err "$LINENO"
+replay_regions || err "$LINENO"
+
+# Remove the built-in auto region to free up resources
+remove_auto_region
+[ "$($CXL list -R | jq 'length')" -eq 0 ] || err "$LINENO"
+
+# Create and replay a volatile region
+create_x4_ram_region
+replay_regions || err "$LINENO"
+
+# Add-on a pmem region
+create_x2_pmem_region
+
+# Replay both the x4_ram and x2_pmem
+replay_regions || err "$LINENO"
+
+check_dmesg "$LINENO"
+
+modprobe -r cxl_test
diff --git a/test/meson.build b/test/meson.build
index 4260a3fa4448..e0e2193bfd51 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -170,6 +170,7 @@ cxl_qos_class = find_program('cxl-qos-class.sh')
 cxl_translate = find_program('cxl-translate.sh')
 cxl_elc = find_program('cxl-elc.sh')
 cxl_dax_hmem = find_program('cxl-dax-hmem.sh')
+cxl_region_replay = find_program('cxl-region-replay.sh')
 
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
@@ -205,6 +206,7 @@ tests = [
   [ 'cxl-translate.sh',       cxl_translate,      'cxl'   ],
   [ 'cxl-elc.sh',             cxl_elc,            'cxl'   ],
   [ 'cxl-dax-hmem.sh',        cxl_dax_hmem,       'cxl'   ],
+  [ 'cxl-region-replay.sh',   cxl_region_replay,  'cxl'   ],
 ]
 
 if get_option('destructive').enabled()
-- 
2.37.3

