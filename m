Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231F53AD50B
	for <nvdimm@lists.linux.dev>; Fri,  4 Sep 2026 02:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788490388; cv=none; b=k//i15jBEPep4aNGitQ1zG/hSK9rgfYRKDGOfOQUpj6OcNlgEqswjc1lTd0kw9H1PwKRv/YPP10cXVJjWH3uf1FgWkBcVmhYPBTq+4yjtT9Ua80nyJrQWNMet4av5+ujJyIO2BYrx9nj9pA5KCKI4sVCDeh4xPoUYsqpCJ1Bh1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788490388; c=relaxed/simple;
	bh=ohqS6Wnwx75m4IQDTjCX4k2UhWyOyM+kGlTsHS1LQOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+XTNAFHVZrTdFdAU7IXe5/iPfhmDvkKNv2eifFyueNQVR/EQIsj19/qD9jEFPWcH012bi7EQtXUA7xjTXyMh02WxNgJN9H5fH4KJKe9FItfDS3C/XZFJLR3ZMbDTDxYflk3h02HVtZ1zZWLXGWhkZV2UMiGdvIf48dXw0UN1Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IdSlb8Zh; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IdSlb8Zh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788490385; x=1820026385;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ohqS6Wnwx75m4IQDTjCX4k2UhWyOyM+kGlTsHS1LQOA=;
  b=IdSlb8Zhvc2s/SYowVuuN3GISy1xldb6HRsRmGF6OP8VGwInd+NtvXsP
   NvnQSXaHaByB9ZIrWU3HM+1Jxl4jQMoPRePSD4u0pemZihQS10PaCjNRf
   fPjDQzfKBIeDpK1ZZCxrzNrVqR3/p61xG7ROJCTZwsJJ5yWnX8UZ2zDqC
   3SUEZ+eYZpQlexBDY4zmXPI/OHKGMYIh7a8u21GyByiMnZ6ipyMgGy3G4
   9IEZiSHBdpcGUXHD6/4Zh57VNGlH7zmPtKtnMKSAWN3gZjlF9d5fEAZGW
   0emNbb5g+Fuod7saQgPDlt07oMhsWNDWDeKUJOixZJUMUw6Bd01Px1P3j
   g==;
X-CSE-ConnectionGUID: q2twjXscRaeb7bNpt9EX3g==
X-CSE-MsgGUID: ACK51zutQ/+gku3eIZzfYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="88915036"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="88915036"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 19:53:03 -0700
X-CSE-ConnectionGUID: j7rE+Vb7SVKmPvpORenRMA==
X-CSE-MsgGUID: HZOr6vT4QvS8RoLunDAPow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="271865676"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.10])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 19:53:02 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH v2 3/3] test/cxl-create-region.sh: add passthrough >16K granularity test case
Date: Thu,  3 Sep 2026 19:52:57 -0700
Message-ID: <8e665c7498d673e2e406df2ca1c2e86569c6981e.1788489571.git.alison.schofield@intel.com>
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

The CXL driver region configuration used to reject valid topologies
containing passthrough decoders beneath a wide parent interleave.
A recent kernel patch fixed that issue and extended cxl-test with
a topology that exercises it.

Add a create-and-destroy region case spanning the two host bridges
beneath the new 2-way 16K root decoder to verify that such
configurations are accepted.

The test case is quietly skipped if the new cxl/test topology is
not found, which also means the kernel fix is not yet present.

Assisted-by: Claude:Opus-4-8
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-create-region.sh | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/test/cxl-create-region.sh b/test/cxl-create-region.sh
index 5941e18f338d..dca2d2a5d93f 100644
--- a/test/cxl-create-region.sh
+++ b/test/cxl-create-region.sh
@@ -170,10 +170,12 @@ setup_x1()
 
 setup_x2()
 {
-	# Find an x2 decoder
+	# Find an x2 decoder. Pin to the 256 granularity root to avoid
+	# the 16K root used by the passthrough granularity test.
 	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
 		select(.pmem_capable == true) |
 		select(.nr_targets == 2) |
+		select(.interleave_granularity == 256) |
 		.decoder")
 
 	# Find a memdev for each host-bridge interleave position
@@ -184,10 +186,12 @@ setup_x2()
 
 setup_x4()
 {
-	# find an x2 decoder
+	# find an x2 decoder. Pin to the 256 granularity root to avoid
+	# the 16K root used by the passthrough granularity test.
 	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
 		select(.pmem_capable == true) |
 		select(.nr_targets == 2) |
+		select(.interleave_granularity == 256) |
 		.decoder")
 
 	# Find a memdev for each host-bridge interleave position
@@ -198,6 +202,28 @@ setup_x4()
 	memdevs="$mem0 $mem1 $mem2 $mem3"
 }
 
+setup_passthru_gran()
+{
+	# Find the 2-way 16K root. A region spanning both host bridges
+	# places one endpoint under each. The intermediate switch decoders
+	# are passthrough decoders with 32K granularity.
+	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+		select(.pmem_capable == true) |
+		select(.nr_targets == 2) |
+		select(.interleave_granularity == 16384) |
+		.decoder")
+
+	if [[ ! $decoder ]]; then
+		echo "no 16K root found, skipping passthrough granularity test"
+		return
+	fi
+
+	# Find a memdev for each host-bridge interleave position
+	mem0=$(find_memdev "$decoder" 0 0)
+	mem1=$(find_memdev "$decoder" 1 0)
+	memdevs="$mem0 $mem1"
+}
+
 setup_x3()
 {
 	# find an x3 decoder
@@ -252,6 +278,11 @@ setup_x3
 if [[ $decoder ]]; then
 	create_and_destroy_region
 fi
+# 16K root may not be available in cxl/test topo yet
+setup_passthru_gran
+if [[ $decoder ]]; then
+	create_and_destroy_region
+fi
 
 check_dmesg "$LINENO"
 
-- 
2.37.3

