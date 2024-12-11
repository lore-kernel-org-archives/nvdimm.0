Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18DC22FAC3
	for <nvdimm@lists.linux.dev>; Wed, 11 Dec 2024 03:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733888552; cv=none; b=nl1YJtf+T12eI+dxhfMN0JvFwBNk5njD0RuXEZZ7yS7p5dG5uDrUM+1Knq4Ommif51zMgmLJfUubNcrblKKrE/W0gJeT0VGF/s4b1rnfCbpBuStKskqhfd4WYnTD1VeE+0pRaHRVemc55tclZciuAyIEuz6G61RNuyol6Uu2ql8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733888552; c=relaxed/simple;
	bh=psfRGmT/KuamRBxnfVwDlSVwkwknytkboYiwlsqwceU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZqJkuYJoo7zQHU5l7/jNi8gHfb1VmAxqOxEuZJKOzpmT+8AmBqEr9t7qBn/JGHZpytm184GOGThdHHnM/Qubxkzkjw4TXMiXohxiimDeCi/dYe5XqqjMlX7/Ge+9BcknysrqqgesLbbGJlOSF/zdDA2NUZy1aCPR5yJDwtk0eRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W8vAnkGC; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W8vAnkGC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733888551; x=1765424551;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=psfRGmT/KuamRBxnfVwDlSVwkwknytkboYiwlsqwceU=;
  b=W8vAnkGCsnOj9oDgROpD/VUK0t8LxumiPllwEs/mlYMCEaoaRUPfe/3K
   6D4CNhxGy67WXBA0ug+08Lq/XRTnRt0j892ZU3nk2Pv4kBw4a/ut+TcFa
   jSgV5zQMDBis1Nq9T2TsQgp9T1yxS71GT+v0UUZicoDsKpO0v4R/vXy7U
   24u4kcrJxDKTrANjNm4sgJnMPWTlwlfchypZNO2IiIXt6WAidZH9qWYj1
   QYsDRTmt+3vgWmK9CJPFxf9088jTwy1NSDAEX7AVDFHEE+VQQnaOs4M+2
   pSnOKT3k8GHZbdzM4bl+rklnD1jlfPR9y3NxVwVAUkNsgTJ9T/MstZBLI
   Q==;
X-CSE-ConnectionGUID: 99pGozTQT+mFbMuGYk9lug==
X-CSE-MsgGUID: sp+BVL4bT7Gw0ESo7XLemw==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="34395667"
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="34395667"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 19:42:31 -0800
X-CSE-ConnectionGUID: n2tY8NTDTRakfilagKWkog==
X-CSE-MsgGUID: Xkat7JRxSpOE2PbjKFIDNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="95696762"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO localhost) ([10.125.109.231])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 19:42:29 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Tue, 10 Dec 2024 21:42:19 -0600
Subject: [PATCH v8 04/21] cxl/region: Add dynamic capacity decoder and
 region modes
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241210-dcd-type2-upstream-v8-4-812852504400@intel.com>
References: <20241210-dcd-type2-upstream-v8-0-812852504400@intel.com>
In-Reply-To: <20241210-dcd-type2-upstream-v8-0-812852504400@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, 
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-hardening@vger.kernel.org, Li Ming <ming.li@zohomail.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733888537; l=3431;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=psfRGmT/KuamRBxnfVwDlSVwkwknytkboYiwlsqwceU=;
 b=yr9i9xzw/P6o7TwEl8on12KN7Pc/tAflIAbd4yP0oFiZ8wlAfILRuaxzkyKprZLI/qW8glIER
 eCdJ3pOPHJCCEJ93puT2NH0HYLfq/A0URtjNxL/bBa4n/yVRePGsWXZ
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

One or more decoders each pointing to a Dynamic Capacity (DC) partition
form a CXL software region.  The region mode reflects composition of
that entire software region.  Decoder mode reflects a specific DC
partition.  DC partitions are also known as DC regions per CXL
specification v3.1.

Define the new modes and helper functions required to make the
association between these new modes.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Link: https://lore.kernel.org/all/663922b475e50_d54d72945b@dwillia2-xfh.jf.intel.com.notmuch/ [1]
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/cxl/core/region.c |  4 ++++
 drivers/cxl/cxl.h         | 23 +++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 1e9f8f2b4e28294fda5199bd1001225eec041ec0..6c1a63610f5ba79b1da57cc37df4e2b5b88588a6 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1877,6 +1877,8 @@ static bool cxl_modes_compatible(enum cxl_region_mode rmode,
 		return true;
 	if (rmode == CXL_REGION_PMEM && dmode == CXL_DECODER_PMEM)
 		return true;
+	if (rmode == CXL_REGION_DC && cxl_decoder_mode_is_dc(dmode))
+		return true;
 
 	return false;
 }
@@ -3234,6 +3236,8 @@ cxl_decoder_to_region_mode(enum cxl_decoder_mode mode)
 		return CXL_REGION_RAM;
 	case CXL_DECODER_PMEM:
 		return CXL_REGION_PMEM;
+	case CXL_DECODER_DC0 ... CXL_DECODER_DC7:
+		return CXL_REGION_DC;
 	case CXL_DECODER_MIXED:
 	default:
 		return CXL_REGION_MIXED;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 2c832ef1c62c2d7879ce944b599374b5fc70c3fc..e61d4e3830a5428f671f5fc61f9e522d51f3fb0c 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -379,6 +379,14 @@ enum cxl_decoder_mode {
 	CXL_DECODER_NONE,
 	CXL_DECODER_RAM,
 	CXL_DECODER_PMEM,
+	CXL_DECODER_DC0,
+	CXL_DECODER_DC1,
+	CXL_DECODER_DC2,
+	CXL_DECODER_DC3,
+	CXL_DECODER_DC4,
+	CXL_DECODER_DC5,
+	CXL_DECODER_DC6,
+	CXL_DECODER_DC7,
 	CXL_DECODER_MIXED,
 	CXL_DECODER_DEAD,
 };
@@ -389,6 +397,14 @@ static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
 		[CXL_DECODER_NONE] = "none",
 		[CXL_DECODER_RAM] = "ram",
 		[CXL_DECODER_PMEM] = "pmem",
+		[CXL_DECODER_DC0] = "dc0",
+		[CXL_DECODER_DC1] = "dc1",
+		[CXL_DECODER_DC2] = "dc2",
+		[CXL_DECODER_DC3] = "dc3",
+		[CXL_DECODER_DC4] = "dc4",
+		[CXL_DECODER_DC5] = "dc5",
+		[CXL_DECODER_DC6] = "dc6",
+		[CXL_DECODER_DC7] = "dc7",
 		[CXL_DECODER_MIXED] = "mixed",
 	};
 
@@ -397,10 +413,16 @@ static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
 	return "mixed";
 }
 
+static inline bool cxl_decoder_mode_is_dc(enum cxl_decoder_mode mode)
+{
+	return (mode >= CXL_DECODER_DC0 && mode <= CXL_DECODER_DC7);
+}
+
 enum cxl_region_mode {
 	CXL_REGION_NONE,
 	CXL_REGION_RAM,
 	CXL_REGION_PMEM,
+	CXL_REGION_DC,
 	CXL_REGION_MIXED,
 };
 
@@ -410,6 +432,7 @@ static inline const char *cxl_region_mode_name(enum cxl_region_mode mode)
 		[CXL_REGION_NONE] = "none",
 		[CXL_REGION_RAM] = "ram",
 		[CXL_REGION_PMEM] = "pmem",
+		[CXL_REGION_DC] = "dc",
 		[CXL_REGION_MIXED] = "mixed",
 	};
 

-- 
2.47.1

