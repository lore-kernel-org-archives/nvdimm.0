Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6901B3F1047
	for <nvdimm@lists.linux.dev>; Tue, 29 Sep 2026 05:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790660229; cv=none; b=vCBYfYPiq53JibjWIKIF31HFz5WpIZCfnsoTIhxUD1064A2LYYmC9E/e8pZbXJxiO7RtTq3BM7dv7hXjsN6GOglS5WV+cc3p8uVpVhQuvaXr0zlECNUKDHJtaA5/6V0iB8NiYknZRQxrtjnPNYlZNwAlKAcwfFhUMDbd9TUWHJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790660229; c=relaxed/simple;
	bh=akPW6QcWvYQ3rYJrs5PmBfxjUpmjYLrGdX8Eo0tt1eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JM+3JHQxsxcfEmeAJexPa6MqSC8kQk1sggPiqOqr104nrXJ1tHUR3pfGfiWuUe/M4oxO7i+jhMzuh/TAXDuE0i991lwQiCcMo4zRCH7JMU0guf/Pitajn1EkHzFTzacm9XheW6D/xljhxzTJT+cdzkrRG4VN0mQotT2dB9OVAbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=joi6xh3f; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="joi6xh3f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790660227; x=1822196227;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=akPW6QcWvYQ3rYJrs5PmBfxjUpmjYLrGdX8Eo0tt1eM=;
  b=joi6xh3fVfEOKSyEVV0QBVLJxcwDMf+1X2BwugYtw7THIG0IHaxV8yp1
   BFJ9Ckc38dZL5/N11Vxi1EoYbK81zXlV5M6QbgF2k790DdFzOG4iPU/Ms
   WKEiifqGTC4XzoTRoKiXbmFNL8yXXx50eEovO67HBB9YtpVsULII7VZj4
   xd5ZU3PTZatYt6bx85iVw2n1exBn8M7ZfD7gD8Xu5d/3h//TY4c2+Kddw
   hdSo3Z3xCU53fo2pRVmkpKoiZgA2fTxtvjfL33q1+6lNCccYJDp98hCrZ
   ZYHWMvBARz4uViY2eLldOY4P4ol2YkNLU6srXFXkOM0F5AO0z4p54UtbW
   w==;
X-CSE-ConnectionGUID: j0XaB5jiScqr/TIE8YXszQ==
X-CSE-MsgGUID: J3JWuB8OTNWyYJWwdreHzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="100700065"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="100700065"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 22:37:05 -0700
X-CSE-ConnectionGUID: 4XLNEfbLRvGzot+yGG94AA==
X-CSE-MsgGUID: abXAW3HfQLe06GG7zOQ2Hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="304767468"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.222.149])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 22:37:05 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH 2/7] test/cxl-create-region.sh: deduplicate topology lookups
Date: Mon, 28 Sep 2026 22:36:54 -0700
Message-ID: <ed6de56a24c092b8ce6d3a260754d33552db4c1f.1790658549.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1790658549.git.alison.schofield@intel.com>
References: <cover.1790658549.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several region setup paths repeat the same decoder and memdev lookups.

Factor them into shared helpers and centralize cxl_test reload and
memdev discovery. No functional change.

Assisted-by: LLM
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-create-region.sh | 99 +++++++++++++++++++--------------------
 1 file changed, 48 insertions(+), 51 deletions(-)

diff --git a/test/cxl-create-region.sh b/test/cxl-create-region.sh
index fcfcea0594bb..927edf4c17d4 100644
--- a/test/cxl-create-region.sh
+++ b/test/cxl-create-region.sh
@@ -12,8 +12,14 @@ trap 'err $LINENO' ERR
 
 check_prereq "jq"
 
-modprobe -r cxl_test
-modprobe cxl_test
+load_cxl_test()
+{
+	modprobe -r cxl_test
+	modprobe cxl_test "$@"
+	readarray -t mems < <("$CXL" list -b cxl_test -M | jq -r '.[].memdev')
+}
+
+load_cxl_test
 rc=1
 
 destroy_regions()
@@ -25,17 +31,27 @@ destroy_regions()
 	fi
 }
 
+# List x1 root decoders for a memdev matching the jq predicate.
+find_x1_decoders()
+{
+	$CXL list -b cxl_test -D -d root -m "$1" |
+		  jq -r ".[] |
+		  select($2) |
+		  select(.nr_targets == 1) |
+		  .decoder"
+}
+
+# Pick the first pmem-capable x1 root decoder for a memdev.
+find_x1_decoder()
+{
+	find_x1_decoders "$1" ".pmem_capable == true" | head -n1
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
@@ -69,13 +85,7 @@ create_subregions()
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
@@ -133,6 +143,17 @@ create_single()
 	destroy_regions "$region"
 }
 
+# Return memdev @index behind root target @position.
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
@@ -154,10 +175,7 @@ setup_x1()
 		select(.nr_targets == 1) |
 		.decoder")
 
-	# Find a memdev for this host-bridge
-	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
-		.targets | .[] | select(.position == 0) | .target")
-	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
+	mem0=$(find_memdev "$decoder" 0 0)
 	memdevs="$mem0"
 }
 
@@ -169,13 +187,8 @@ setup_x2()
 		select(.nr_targets == 2) |
 		.decoder")
 
-	# Find a memdev for each host-bridge interleave position
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
 
@@ -187,15 +200,10 @@ setup_x4()
 		select(.nr_targets == 2) |
 		.decoder")
 
-	# Find a memdev for each host-bridge interleave position
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
 
@@ -212,25 +220,15 @@ setup_x3()
 		return
 	fi
 
-	# Find a memdev for each host-bridge interleave position
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
 
 # test region creation on devices behind a single-port host-bridge
 create_single
 
-# test reading labels directly through cxl-cli
-readarray -t mems < <("$CXL" list -b cxl_test -M | jq -r '.[].memdev')
-
 for mem in ${mems[@]}; do
 	create_x1_region "$mem"
 done
@@ -242,8 +240,7 @@ for mem in ${mems[@]}; do
 done
 
 # Repeat x1/x2/x3/x4 region creation with XOR interleave arithmetic.
-modprobe -r cxl_test
-modprobe cxl_test interleave_arithmetic=1
+load_cxl_test interleave_arithmetic=1
 
 setup_x1
 create_and_destroy_region
-- 
2.37.3

