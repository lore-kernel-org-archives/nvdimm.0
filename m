Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58FEB645
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 01:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708652411; cv=none; b=T580tmcELXL3hQ34VVi9jzjph/iJRdpLkUzONCtJquxq40VAGczW41lh5z41AHfGRjVtR7AdxRhh534Z04NWD2OpE2bDiqs7JRDf2ckFUyAHen8GuevtTO6tzALbXEv1WcCLkqAzCB3HV7iQsCl0j/cXv2n1pSCCqSdRSOpyIfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708652411; c=relaxed/simple;
	bh=M9XuLyhHwwSBPkmpM4G5dLg95TCZrsHfV4iq/ycqVFk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p4zYFO+dULZiflS05Q4Y99jyqGzO/hsXSgMlF4qJWpZ74ptB0rYoiWgIfdkT5aPqeSnOWeLzTDAZWp8EWjChqv1uS3Z4n46hZrSbsnB0nnNjqqB3P2YkbwXZiF1PC29IWeBZzoudydaWBYB/ar41GEEFD7qBKTbkBpKyK9uKPUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kwG1K31R; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kwG1K31R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708652410; x=1740188410;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M9XuLyhHwwSBPkmpM4G5dLg95TCZrsHfV4iq/ycqVFk=;
  b=kwG1K31RmUtx68L/N8KlQajhLdcjFkn4f/znR9VCiMuTto4I/mMnUuht
   wp26cSBb1w7uKOAvUydxLO82lWwr//dlED8h7k8czMWME/FtlVr6c05EV
   9nw42246cLY8M/ZMsdeRLYcpoBMk1FolBQBgqgdyuJutspaNYVwqa82pI
   Bi7gG1bq4wptiq8fTSWmjoCg6qkOSUX20j4w6PEvboyvyyb/1W//ZdEDo
   AZ1RS2trALJ6cOlrdd/BNyOu/3/DDItKHXLR7aopz2nuh4syHDXORp+CI
   LCb71eHqbWl0KSUlYmMbQrVxFKflzgXdbrecHO43uMTBC4PRjHiVQQG5j
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10992"; a="3097986"
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="3097986"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 17:40:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="10482396"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.29.102])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 17:40:09 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v2 1/3] cxl/test: replace spaces with tabs in cxl-xor-region.sh
Date: Thu, 22 Feb 2024 17:40:03 -0800
Message-Id: <68d36fe3fffca4122bd54757fee546b077a8c1d5.1708650921.git.alison.schofield@intel.com>
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

Clean up the whitespace to follow ndctl coding style.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-xor-region.sh | 76 +++++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/test/cxl-xor-region.sh b/test/cxl-xor-region.sh
index 117e7a4bba61..5ab7ede11e56 100644
--- a/test/cxl-xor-region.sh
+++ b/test/cxl-xor-region.sh
@@ -35,55 +35,55 @@ create_and_destroy_region()
 
 setup_x1()
 {
-        # Find an x1 decoder
-        decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
-          select(.pmem_capable == true) |
-          select(.nr_targets == 1) |
-          .decoder")
+	# Find an x1 decoder
+	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+		select(.pmem_capable == true) |
+		select(.nr_targets == 1) |
+		.decoder")
 
-        # Find a memdev for this host-bridge
-        port_dev0=$($CXL list -T -d $decoder | jq -r ".[] |
-            .targets | .[] | select(.position == 0) | .target")
-        mem0=$($CXL list -M -p $port_dev0 | jq -r ".[0].memdev")
-        memdevs="$mem0"
+	# Find a memdev for this host-bridge
+	port_dev0=$($CXL list -T -d $decoder | jq -r ".[] |
+		.targets | .[] | select(.position == 0) | .target")
+	mem0=$($CXL list -M -p $port_dev0 | jq -r ".[0].memdev")
+	memdevs="$mem0"
 }
 
 setup_x2()
 {
-        # Find an x2 decoder
-        decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
-          select(.pmem_capable == true) |
-          select(.nr_targets == 2) |
-          .decoder")
+	# Find an x2 decoder
+	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+		select(.pmem_capable == true) |
+		select(.nr_targets == 2) |
+		.decoder")
 
-        # Find a memdev for each host-bridge interleave position
-        port_dev0=$($CXL list -T -d $decoder | jq -r ".[] |
-            .targets | .[] | select(.position == 0) | .target")
-        port_dev1=$($CXL list -T -d $decoder | jq -r ".[] |
-            .targets | .[] | select(.position == 1) | .target")
-        mem0=$($CXL list -M -p $port_dev0 | jq -r ".[0].memdev")
-        mem1=$($CXL list -M -p $port_dev1 | jq -r ".[0].memdev")
-        memdevs="$mem0 $mem1"
+	# Find a memdev for each host-bridge interleave position
+	port_dev0=$($CXL list -T -d $decoder | jq -r ".[] |
+		.targets | .[] | select(.position == 0) | .target")
+	port_dev1=$($CXL list -T -d $decoder | jq -r ".[] |
+		.targets | .[] | select(.position == 1) | .target")
+	mem0=$($CXL list -M -p $port_dev0 | jq -r ".[0].memdev")
+	mem1=$($CXL list -M -p $port_dev1 | jq -r ".[0].memdev")
+	memdevs="$mem0 $mem1"
 }
 
 setup_x4()
 {
-        # find an x2 decoder
-        decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
-          select(.pmem_capable == true) |
-          select(.nr_targets == 2) |
-          .decoder")
+	# find an x2 decoder
+	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+		select(.pmem_capable == true) |
+		select(.nr_targets == 2) |
+		.decoder")
 
-        # Find a memdev for each host-bridge interleave position
-        port_dev0=$($CXL list -T -d $decoder | jq -r ".[] |
-            .targets | .[] | select(.position == 0) | .target")
-        port_dev1=$($CXL list -T -d $decoder | jq -r ".[] |
-            .targets | .[] | select(.position == 1) | .target")
-        mem0=$($CXL list -M -p $port_dev0 | jq -r ".[0].memdev")
-        mem1=$($CXL list -M -p $port_dev1 | jq -r ".[0].memdev")
-        mem2=$($CXL list -M -p $port_dev0 | jq -r ".[1].memdev")
-        mem3=$($CXL list -M -p $port_dev1 | jq -r ".[1].memdev")
-        memdevs="$mem0 $mem1 $mem2 $mem3"
+	# Find a memdev for each host-bridge interleave position
+	port_dev0=$($CXL list -T -d $decoder | jq -r ".[] |
+		.targets | .[] | select(.position == 0) | .target")
+	port_dev1=$($CXL list -T -d $decoder | jq -r ".[] |
+		.targets | .[] | select(.position == 1) | .target")
+	mem0=$($CXL list -M -p $port_dev0 | jq -r ".[0].memdev")
+	mem1=$($CXL list -M -p $port_dev1 | jq -r ".[0].memdev")
+	mem2=$($CXL list -M -p $port_dev0 | jq -r ".[1].memdev")
+	mem3=$($CXL list -M -p $port_dev1 | jq -r ".[1].memdev")
+	memdevs="$mem0 $mem1 $mem2 $mem3"
 }
 
 setup_x1
-- 
2.37.3

