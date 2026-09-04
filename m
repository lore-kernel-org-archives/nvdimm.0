Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B2E3AC0FB
	for <nvdimm@lists.linux.dev>; Fri,  4 Sep 2026 02:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788490388; cv=none; b=u2oeow77KOkGgDXiJvRcFiBQwN9zWxGYlsO+jToGPIQMbgsiF8FA7yXXrEmErH3k1WICrrLROGivoHNY6jy/Oh09onUTySwPueVn54grr4sC58E5KeOLKh1Pvmmz1+hWjdKoUoQIbJA8vnAYlbiJ6WBL1tMc0bUfxdxQoFJo8M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788490388; c=relaxed/simple;
	bh=5NfHHB1XexcAuvs06yfjoDisyrtOqg5KcGCXrerRxYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6nVgamUwaKWRxyg/wm+5tA/ezNpGpXXAKewhbvRUo1RuXEJDotSE6hADG7J7Qll8ifqICgUoVJcGbZnmVG/YahgjCuZMJ05uuBOkiuA+SL10aWqSTXl8Y49+sTaj/KZBSvI3EIu2yZBTJZtPK+VoW32vEMhNKU6RgIA0WPPxbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kNfmd/t2; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kNfmd/t2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788490384; x=1820026384;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5NfHHB1XexcAuvs06yfjoDisyrtOqg5KcGCXrerRxYQ=;
  b=kNfmd/t2p6ji8wVRfh2UFwfNLbw8XY0j9/WwpAERrM5QfoqCg6m5AxXF
   MQhD33R0AuJocgB3oQIMuBrmU/Pe0uD927Ejb/3Cx5pad1VtkwvSPRD56
   zgntBYnHbAUB2pLcIhYP+qhRmwYuvqXhjhuHyzjuWjrkqD2+5c2NPzaQR
   6voOF10chChIO/0fJWQOBMDdfwAP3RXZBzL0FfkYB4WkfSH9LrfaxaVWI
   8ohv3zBXQ6QS7IBMhzNSkP8jzQTM9mS8H+AcGnaimt2RTT7NbKbD+TPQP
   17T14Kb4HtICk+yvO3WFlyuFHpSfFgKKwezQUGp3cxi9qlVLKqucdwy1f
   g==;
X-CSE-ConnectionGUID: ylmBXqvsTQyXYF+LrTodWA==
X-CSE-MsgGUID: 5SBWzN2KRmGqUI0XJ/v74w==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="88915032"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="88915032"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 19:53:02 -0700
X-CSE-ConnectionGUID: jPCsXY/VSw+zQU5wk9iQhQ==
X-CSE-MsgGUID: xwmd2HDqQran6UggeOenBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="271865670"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.10])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 19:53:02 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH v2 2/3] test/cxl-create-region.sh: deduplicate decoder and memdev lookups
Date: Thu,  3 Sep 2026 19:52:56 -0700
Message-ID: <4ef6cdc279e12f61e2e7aa7363fb13d5fa023d29.1788489571.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1788489571.git.alison.schofield@intel.com>
References: <cover.1788489571.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several region setup helpers open-code the same decoder and memdev
lookups.

Factor the common queries into shared helpers. This reduces duplicate
logic and simplifies adding new region configuration tests.

No functional change.

Assisted-by: Claude:Opus-4-8
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-create-region.sh | 73 ++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 40 deletions(-)

diff --git a/test/cxl-create-region.sh b/test/cxl-create-region.sh
index d7a6840fed1a..5941e18f338d 100644
--- a/test/cxl-create-region.sh
+++ b/test/cxl-create-region.sh
@@ -25,17 +25,21 @@ destroy_regions()
 	fi
 }
 
+# Find the pmem capable single-target root decoder for a memdev
+find_x1_decoder()
+{
+	$CXL list -b cxl_test -D -d root -m "$1" |
+		  jq -r ".[] |
+		  select(.pmem_capable == true) |
+		  select(.nr_targets == 1) |
+		  .decoder"
+}
+
 create_x1_region()
 {
 	mem="$1"
 
-	# find a pmem capable root decoder for this mem
-	decoder=$($CXL list -b cxl_test -D -d root -m "$mem" |
-		  jq -r ".[] |
-		  select(.pmem_capable == true) |
-		  select(.nr_targets == 1) |
-		  .decoder")
-
+	decoder=$(find_x1_decoder "$mem")
 	if [[ ! $decoder ]]; then
 		echo "no suitable decoder found for $mem, skipping"
 		return
@@ -69,13 +73,7 @@ create_subregions()
 	slice=$((256 << 20))
 	mem="$1"
 
-	# find a pmem capable root decoder for this mem
-	decoder=$($CXL list -b cxl_test -D -d root -m "$mem" |
-		  jq -r ".[] |
-		  select(.pmem_capable == true) |
-		  select(.nr_targets == 1) |
-		  .decoder")
-
+	decoder=$(find_x1_decoder "$mem")
 	if [[ ! $decoder ]]; then
 		echo "no suitable decoder found for $mem, skipping"
 		return
@@ -133,6 +131,17 @@ create_single()
 	destroy_regions "$region"
 }
 
+# Find the index'th memdev behind the decoder's target at position
+find_memdev()
+{
+	local decoder="$1" position="$2" index="$3"
+	local port_dev
+
+	port_dev=$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == $position) | .target")
+	$CXL list -M -p "$port_dev" | jq -r ".[$index].memdev"
+}
+
 create_and_destroy_region()
 {
 	region=$($CXL create-region -d "$decoder" -m "$memdevs" |
@@ -155,9 +164,7 @@ setup_x1()
 		.decoder")
 
 	# Find a memdev for this host-bridge
-	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 0) | .target")
-	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
+	mem0=$(find_memdev "$decoder" 0 0)
 	memdevs="$mem0"
 }
 
@@ -170,12 +177,8 @@ setup_x2()
 		.decoder")
 
 	# Find a memdev for each host-bridge interleave position
-	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 0) | .target")
-	port_dev1=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 1) | .target")
-	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
-	mem1=$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")
+	mem0=$(find_memdev "$decoder" 0 0)
+	mem1=$(find_memdev "$decoder" 1 0)
 	memdevs="$mem0 $mem1"
 }
 
@@ -188,14 +191,10 @@ setup_x4()
 		.decoder")
 
 	# Find a memdev for each host-bridge interleave position
-	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 0) | .target")
-	port_dev1=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 1) | .target")
-	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
-	mem1=$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")
-	mem2=$($CXL list -M -p "$port_dev0" | jq -r ".[1].memdev")
-	mem3=$($CXL list -M -p "$port_dev1" | jq -r ".[1].memdev")
+	mem0=$(find_memdev "$decoder" 0 0)
+	mem1=$(find_memdev "$decoder" 1 0)
+	mem2=$(find_memdev "$decoder" 0 1)
+	mem3=$(find_memdev "$decoder" 1 1)
 	memdevs="$mem0 $mem1 $mem2 $mem3"
 }
 
@@ -213,15 +212,9 @@ setup_x3()
 	fi
 
 	# Find a memdev for each host-bridge interleave position
-	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 0) | .target")
-	port_dev1=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 1) | .target")
-	port_dev2=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 2) | .target")
-	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
-	mem1=$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")
-	mem2=$($CXL list -M -p "$port_dev2" | jq -r ".[0].memdev")
+	mem0=$(find_memdev "$decoder" 0 0)
+	mem1=$(find_memdev "$decoder" 1 0)
+	mem2=$(find_memdev "$decoder" 2 0)
 	memdevs="$mem0 $mem1 $mem2"
 }
 
-- 
2.37.3

