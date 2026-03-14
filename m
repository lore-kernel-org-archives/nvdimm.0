Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26991A704B
	for <nvdimm@lists.linux.dev>; Sat, 14 Mar 2026 06:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773469292; cv=none; b=qsC51yuGdhofeGWnUkXDb9hLIB7SqBhRJ/iHCUAAlNDv8tr3ngj3EgshWzEKkLZQ6HLAPb2kdc0lVu932vp2G28zD1YjjGt6KTERz3LsR9wXeC7cJdezM2/gB3prSYz2xs7z293eAarbKSmNAwZQW+/peEsAGP4aLJW2YQoWKJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773469292; c=relaxed/simple;
	bh=s8tpIovaoLc7rBW98Wra3MNJDJLxCz0TCKzHiMWF2d0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fpttBLLpmDKWQ9bpqeP22OQ8u8nSg104tfS/lDoWSez+aepiiH6YKudKmjWWGA3THPcbnRgG78mvtrUTBXfLaOH8Yd9MEpKv1o21YW8z99fBJ+md4vl1TqiqCMPtAfdsTO6+sDYR0+3ducVS1+CI6cwd+2lu7ytdJ6gsPS5Copg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DsaOSdNl; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DsaOSdNl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773469291; x=1805005291;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=s8tpIovaoLc7rBW98Wra3MNJDJLxCz0TCKzHiMWF2d0=;
  b=DsaOSdNlQvXGXA34YJBiZHIE22KKGc7TwaSrkwgGatga0KJutvysvX5b
   DYv1hYImmRSRjYVZ86NQRUGW6AbHttj0j7mtR3564nkUHIw+qK9yMqQ97
   eG2K4Oho1mEZNWKdocfMEDEsicNM9JjJcukPBXu6FmuQSPqyGbL5CEHdV
   n9SWlycOx3ipelNG0o0J/QC4tA9BNeqxdNu8AWupqR+N1kLdtdPXLum1a
   iT/hpBUpJphN8+vXuE7mknRRwSIAHegvD27DRp98z7qCNBN43jMLlKOAE
   u436NJ9tsCZKnse3G0vg/+4SjqBtRZdI6kZpqGQ9OuyOWByDmcV6ho9sk
   Q==;
X-CSE-ConnectionGUID: 8dpB8RmfReuENkRptJSdOg==
X-CSE-MsgGUID: fMP1UmXsQ4OGmEzfTsNb2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11728"; a="100030489"
X-IronPort-AV: E=Sophos;i="6.23,119,1770624000"; 
   d="scan'208";a="100030489"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2026 23:21:30 -0700
X-CSE-ConnectionGUID: zXMtIhkXR1SmUTeymk6Pog==
X-CSE-MsgGUID: rIf2QeRvQx+CfV6dZ0jySw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,119,1770624000"; 
   d="scan'208";a="220442091"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.223.6])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2026 23:21:29 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH 1/2] test/common: add helpers for CXL region replay testing
Date: Fri, 13 Mar 2026 23:21:23 -0700
Message-ID: <8646e0b11697e3adb4fc9a83fa486e68a4b9b5c5.1773466514.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add replay_regions() and supporting helpers to the CXL test common
library. The helpers capture the current region configuration, trigger
a region replay by unbinding and rebinding the cxl_acpi driver, and
verify that the regions reconstructed during enumeration match the
original configuration.

Replay is enabled by instructing the cxl_test module to preserve its
decoder registry across the driver unbind/bind cycle. This allows the
decoder programming associated with user-created regions to survive
topology teardown so that the regions are reconstructed during driver
initialization as auto-discovered regions.

Region signatures are derived from region attributes and memdev serial
numbers so that the replayed configuration can be compared independent
of topology enumeration order and device numbering.

These helpers provide a reusable mechanism for CXL tests that need to
exercise region replay behavior. A unit test, cxl-region-replay.sh, is
posted in a follow-on patch and demonstrates the workflow.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/common | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/test/common b/test/common
index 2eb11b7396d0..048f9680f277 100644
--- a/test/common
+++ b/test/common
@@ -168,3 +168,112 @@ check_dmesg()
 
 # CXL COMMON
 CXL_TEST_QOS_CLASS=42
+
+# CXL region replay helpers
+#
+# replay_regions() snapshots the current region configuration, performs
+# a cxl_acpi driver unbind/bind cycle to trigger region replay, and
+# verifies that the regions reconstructed during enumeration match the
+# original configuration.
+#
+# This allows tests to create regions through the user interface and
+# then replay them as auto-discovered regions during driver
+# initialization.
+#
+# See example usage in test/cxl-region-replay.sh.
+
+CXL_EXPECTED_REGION_SIGS=""
+
+cxl_get_memdev_serial()
+{
+	local memdev="$1"
+
+	"$CXL" list -m "$memdev" | jq -r '.[0].serial'
+}
+
+cxl_emit_region_signature()
+{
+	local region="$1"
+	local region_json size type ways gran state
+	local entry pos memdev serial sig
+
+	region_json=$("$CXL" list -R --targets -r "$region")
+	[[ -n "$region_json" && "$region_json" != "[]" ]] || return 1
+
+	size=$(jq -r '.[0].size' <<<"$region_json")
+	type=$(jq -r '.[0].type' <<<"$region_json")
+	ways=$(jq -r '.[0].interleave_ways' <<<"$region_json")
+	gran=$(jq -r '.[0].interleave_granularity' <<<"$region_json")
+	state=$(jq -r '.[0].decode_state' <<<"$region_json")
+
+	sig="size=$size type=$type ways=$ways gran=$gran"
+
+	while IFS= read -r entry; do
+		pos=$(jq -r '.position' <<<"$entry")
+		memdev=$(jq -r '.memdev' <<<"$entry")
+		serial=$(cxl_get_memdev_serial "$memdev") || return 1
+		[[ -n "$serial" && "$serial" != "null" ]] || return 1
+		sig="$sig pos=$pos serial=$serial"
+	done < <(jq -c '.[0].mappings | sort_by(.position)[]' <<<"$region_json")
+
+	echo "$sig state=$state"
+}
+
+cxl_collect_region_signatures()
+{
+	local region
+	local -a regions=()
+
+	mapfile -t regions < <("$CXL" list -Ri | jq -r '.[].region' | sort) || return 1
+
+	for region in "${regions[@]}"; do
+		cxl_emit_region_signature "$region" || return 1
+	done | sort
+}
+
+cxl_capture_expected_region_signatures()
+{
+	CXL_EXPECTED_REGION_SIGS=$(cxl_collect_region_signatures) || return 1
+}
+
+cxl_verify_replayed_regions()
+{
+	local actual_region_sigs
+	local -a expected_lines=()
+	local -a actual_lines=()
+	local i
+	local expected_line actual_line
+	local expected_struct actual_struct
+	local expected_state actual_state
+
+	actual_region_sigs=$(cxl_collect_region_signatures) || return 1
+
+	mapfile -t expected_lines < <(printf '%s\n' "$CXL_EXPECTED_REGION_SIGS" | sed '/^$/d')
+	mapfile -t actual_lines < <(printf '%s\n' "$actual_region_sigs" | sed '/^$/d')
+
+	[ "${#expected_lines[@]}" -eq "${#actual_lines[@]}" ] || return 1
+
+	for ((i = 0; i < ${#expected_lines[@]}; i++)); do
+		expected_line=${expected_lines[i]}
+		actual_line=${actual_lines[i]}
+
+		expected_struct=${expected_line% state=*}
+		expected_state=${expected_line##* state=}
+		actual_struct=${actual_line% state=*}
+		actual_state=${actual_line##* state=}
+
+		[ "$expected_struct" = "$actual_struct" ] || return 1
+		[ "$expected_state" != "commit" ] || [ "$actual_state" = "commit" ] || return 1
+	done
+}
+
+replay_regions()
+{
+	echo "replaying existing regions"
+	cxl_capture_expected_region_signatures || return 1
+	echo 1 > /sys/bus/platform/devices/cxl_acpi.0/decoder_reset_preserve_registry
+	echo cxl_acpi.0 > /sys/bus/platform/drivers/cxl_acpi/unbind
+	echo cxl_acpi.0 > /sys/bus/platform/drivers/cxl_acpi/bind
+	echo 0 > /sys/bus/platform/devices/cxl_acpi.0/decoder_reset_preserve_registry
+	cxl_verify_replayed_regions || return 1
+}

base-commit: d6f32b0afba6c36fbde2aae67230b71f9e70cb07
-- 
2.37.3

