Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA3CB65F
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 01:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708652412; cv=none; b=R0CO+ua8lit4KqMeZOrWOOqpO8KLLLCsiCh7VyzSgG6njfXlhEKjRX33Ky7SaUl3YNCisEAVPFHMmj2az8xsXNDmj1XhcHujbG+vhenkvfEuqHtifhxIaYsApoeoYGz++y3Tpaw0tdOXSiqzbPSh2HLwKPicYYznKkqmGVURAhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708652412; c=relaxed/simple;
	bh=C0acIhZXZ19r4+2Ck6zrPdB+BGsU1UZYOsQiTxFl65A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rck7v1xsKKSnnEbtrCzarMbYQpO7PQDbBjqUk+Snnq2mddZNxYOZWSBZM6qy4Vt4Cm0MUd5okg3q7uMmC6oAc7IbzS1FUgFYktBKDvP4Dv/JapbyaTTJdpsk92hVlmqBBBBus+4lns/wzkFUHr6dRzdeHs1BaVz+PR5oj8r5u+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N+uM8kGH; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N+uM8kGH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708652411; x=1740188411;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C0acIhZXZ19r4+2Ck6zrPdB+BGsU1UZYOsQiTxFl65A=;
  b=N+uM8kGHaeIXOwGCGDbjcaUY+aFCza204fhR05GAWwZqG/sGPxS4+69+
   plBtlQabXzLd9Q6rdqQXrtyOcpILtpvnAKp04qSED0WQYpKsAXc1G/IGu
   KcjuX+zvFoIIly261H6P1ZL30YaMYVjGnvSzOOYBgxgcEzWr0RtvJyZJo
   tbH3NtpNccruKMRC5xliiyV6hWJVuqSvpfmvBoWXZRJLjw9xxtmUyk9Z0
   zfHCg0k0KmfDxwh+qa7dr+9FuBr1TBzUTGY+KhWmSH5dfO2tdtE1wUWNg
   SkZapMtNjTSDq0tsEA+yjIVAf3b/xIr3Opril848PhLF4zg5Dfaq5mPH4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10992"; a="3097989"
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="3097989"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 17:40:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="10482402"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.29.102])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 17:40:09 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v2 2/3] cxl/test: add double quotes in cxl-xor-region.sh
Date: Thu, 22 Feb 2024 17:40:04 -0800
Message-Id: <0738a7a0148a24a40e1ff863a51dfc2806e2fdfd.1708650921.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1708650921.git.alison.schofield@intel.com>
References: <cover.1708650921.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Add double quotes to prevent globbing and word splitting.
Found using shellcheck.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-xor-region.sh | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/test/cxl-xor-region.sh b/test/cxl-xor-region.sh
index 5ab7ede11e56..e536f0256202 100644
--- a/test/cxl-xor-region.sh
+++ b/test/cxl-xor-region.sh
@@ -23,7 +23,8 @@ rc=1
 
 create_and_destroy_region()
 {
-	region=$($CXL create-region -d $decoder -m $memdevs | jq -r ".region")
+	region=$($CXL create-region -d "$decoder" -m "$memdevs" |
+		jq -r ".region")
 
 	if [[ ! $region ]]; then
 		echo "create-region failed for $decoder"
@@ -42,9 +43,9 @@ setup_x1()
 		.decoder")
 
 	# Find a memdev for this host-bridge
-	port_dev0=$($CXL list -T -d $decoder | jq -r ".[] |
+	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
 		.targets | .[] | select(.position == 0) | .target")
-	mem0=$($CXL list -M -p $port_dev0 | jq -r ".[0].memdev")
+	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
 	memdevs="$mem0"
 }
 
@@ -57,12 +58,12 @@ setup_x2()
 		.decoder")
 
 	# Find a memdev for each host-bridge interleave position
-	port_dev0=$($CXL list -T -d $decoder | jq -r ".[] |
+	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
 		.targets | .[] | select(.position == 0) | .target")
-	port_dev1=$($CXL list -T -d $decoder | jq -r ".[] |
+	port_dev1=$($CXL list -T -d "$decoder" | jq -r ".[] |
 		.targets | .[] | select(.position == 1) | .target")
-	mem0=$($CXL list -M -p $port_dev0 | jq -r ".[0].memdev")
-	mem1=$($CXL list -M -p $port_dev1 | jq -r ".[0].memdev")
+	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
+	mem1=$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")
 	memdevs="$mem0 $mem1"
 }
 
@@ -75,14 +76,14 @@ setup_x4()
 		.decoder")
 
 	# Find a memdev for each host-bridge interleave position
-	port_dev0=$($CXL list -T -d $decoder | jq -r ".[] |
+	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
 		.targets | .[] | select(.position == 0) | .target")
-	port_dev1=$($CXL list -T -d $decoder | jq -r ".[] |
+	port_dev1=$($CXL list -T -d "$decoder" | jq -r ".[] |
 		.targets | .[] | select(.position == 1) | .target")
-	mem0=$($CXL list -M -p $port_dev0 | jq -r ".[0].memdev")
-	mem1=$($CXL list -M -p $port_dev1 | jq -r ".[0].memdev")
-	mem2=$($CXL list -M -p $port_dev0 | jq -r ".[1].memdev")
-	mem3=$($CXL list -M -p $port_dev1 | jq -r ".[1].memdev")
+	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
+	mem1=$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")
+	mem2=$($CXL list -M -p "$port_dev0" | jq -r ".[1].memdev")
+	mem3=$($CXL list -M -p "$port_dev1" | jq -r ".[1].memdev")
 	memdevs="$mem0 $mem1 $mem2 $mem3"
 }
 
-- 
2.37.3

