Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BF72E173B
	for <nvdimm@lists.linux.dev>; Thu,  8 Jan 2026 05:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767849974; cv=none; b=i41MIDkwvgBMUEXK2cPDpG8IABr96P8/0JnmT5AMYvyZv+2MYyVR0K4Q5IIAC7xBK4O45T26TiFOW26EM6jxWkwvTbdMH1OSTkcYEuBX3cnLuG3URhR6F/aZOlm88sVGw3SSoXj4VXZY6T5K6NAzkcOOGhzyNwiTdg4yEjV/mjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767849974; c=relaxed/simple;
	bh=iMAfquDAsWNysHIibZRWcVXdUCtue/Fes0XTKgCjE5c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SLDeG3vQm4x3vERBxd580y8ARnpu4fqKPFMDFoDuP2mBPj60wC5G4bq8mo4EJbbMEPjann3t+nBqYJV09RCgZl+0/yQj3DMJUmWjhnfFpummVngxZgj0ZStlftPWX4p6eOE27WvYvuXxDFap41k/N4/O5S+2eWrX6YrbFLjHpqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PD7S0XvV; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PD7S0XvV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767849964; x=1799385964;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iMAfquDAsWNysHIibZRWcVXdUCtue/Fes0XTKgCjE5c=;
  b=PD7S0XvV8IVJ3MJePQdH1LA/SMw6LyDPVw+epKSrJYfpnECS4qrtRREo
   XwwMZzUYX4Vn9Hk2N8uIsKSVSzPEXIQyCtyt7QuizphL6ti8AJUUkr0Su
   xBr/a1E1zEXDTJyR0/kCJRbimoLfyPYMQlQimwsz12z+PwsAJENxo91Au
   nnYheoR3y4/f6XMsYUHHW4K6imvYk7uXeTcZlS63oM9mvlJwfyKjn7pwK
   5jPE+v2lp37SFU7N6b8LhFz5VUEY3/VgL8KXPjzzfpGntSp+NP86UfFMP
   mzZ3kVZ5T2m8lJYZoADxvuELrbeq92woTd1INyaJmSxPMSGqH0P2+7LOO
   g==;
X-CSE-ConnectionGUID: pqs3ofLtSgCgtBE3QnJQXg==
X-CSE-MsgGUID: VCnO8/GsSFWjej3jspuWZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="86812415"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="86812415"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 21:25:58 -0800
X-CSE-ConnectionGUID: bUA527e2R/eNtgOpsBaIUQ==
X-CSE-MsgGUID: Nvr6DJbdRvWPIfj/gfJ1OQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="202894044"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.222.193])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 21:25:59 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH] test/cxl-topology.sh: test switch port target
Date: Wed,  7 Jan 2026 21:25:48 -0800
Message-ID: <20260108052552.395896-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a test case to validate that all switch port decoders sharing
downstream ports, dports, have target lists properly enumerated.

This test catches the regression fixed by a recent kernel patch[1]
where only one decoder per switch port has targets populated while
others have nr_targets=0, even when dports are available.

This test is based on the current cxl_test topology which provides
multiple switch ports with 8 decoders each. Like other testcases in
cxl-topology.sh, if the cxl_test topology changes (number of switches,
decoders per port, or hierarchy), this test will need corresponding
updates.

This new case is quietly skipped with kernel version 6.18 where it
is known broken.

[1] https://lore.kernel.org/linux-cxl/20260107100356.389490-1-rrichter@amd.com/

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

 test/common          | 12 +++++++++++
 test/cxl-topology.sh | 51 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/test/common b/test/common
index 2d076402ef7c..2eb11b7396d0 100644
--- a/test/common
+++ b/test/common
@@ -101,6 +101,18 @@ check_min_kver()
 	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
 }
 
+# check_eq_kver
+# $1: Kernel version to match. format: X.Y
+#
+check_eq_kver()
+{
+        local ver="$1"
+        : "${KVER:=$(uname -r)}"
+
+        [ -n "$ver" ] || return 1
+        [[ "$KVER" == "$ver"* ]]
+}
+
 # do_skip
 # $1: Skip message
 #
diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
index b68cb8b262b6..d9475b1bae9c 100644
--- a/test/cxl-topology.sh
+++ b/test/cxl-topology.sh
@@ -151,6 +151,57 @@ count=$(jq "map(select(.pmem_size == $pmem_size)) | length" <<< $json)
 ((bridges == 2 && count == 8 || bridges == 3 && count == 10 ||
   bridges == 4 && count == 11)) || err "$LINENO"
 
+# Test that switch port decoders have complete target list enumeration
+# Validates a fix for multiple decoders sharing the same dport.
+# Based on the cxl_test topology expectation of switch ports at depth 2
+# with 8 decoders each. Adjust if that expectation changes.
+test_switch_decoder_target_enumeration() {
+
+	# Get verbose output to see targets arrays
+	json=$($CXL list -b cxl_test -vvv)
+
+	switch_port_issues=$(jq '
+	# Find all switch ports (depth 2)
+	[.. | objects | select(.depth == 2 and has("decoders:" + .port))] |
+
+	# For each switch port, analyze its decoder target pattern
+	map({
+		port: .port,
+		nr_dports: .nr_dports,
+
+		# Count non-endpoint decoders (no "mode" field)
+		total: ([to_entries[] | select(.key | startswith("decoders:"))
+			| .value[] | select(has("mode") == false)] |
+			length),
+
+		# Count how many have targets
+		with_targets: ([to_entries[] | select(.key |
+			startswith("decoders:")) | .value[] |
+			select(has("mode") == false and .nr_targets > 0)] |
+			length),
+
+		# Count how many explicitly have no targets
+		without_targets: ([to_entries[] | select(.key |
+			startswith("decoders:")) | .value[] |
+			select(has("mode") == false and .nr_targets == 0)] |
+			length)
+		}) |
+
+		# Filter for the expected pattern and count them
+		map(select(.nr_dports > 0 and
+			   .with_targets == 1 and
+			   .without_targets >= 7)) |
+			   length
+	' <<<"$json")
+
+	((switch_port_issues == 0)) || {
+		echo "Found $switch_port_issues switch ports with incomplete target enumeration"
+		echo "Only 1 decoder has targets while 7+ have nr_targets=0"
+		err "$LINENO"
+	}
+}
+# Skip the target enumeration test where known broken
+check_eq_kver 6.18 || test_switch_decoder_target_enumeration
 
 # check that switch ports disappear after all of their memdevs have been
 # disabled, and return when the memdevs are enabled.
-- 
2.37.3

