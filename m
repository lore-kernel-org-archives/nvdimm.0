Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEF713E02D
	for <nvdimm@lists.linux.dev>; Tue,  4 Mar 2025 00:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741048645; cv=none; b=KDIwBeSdHtz2dLR3Bd59wTKAriY1UO9O2boTYF/DOjOcRGm8Wn2jBx1vJKk5syCvOMKVbBuSLLi/jzocMM2rHSH/ivqvlhcXUPFV4b7AJmHucTD3E1H7uE7B+R/SbfC+Va5jolZ55JUHC0YBl4ctiVS24y4DS5ALdWo/lvqDClw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741048645; c=relaxed/simple;
	bh=mFTdXqISjNDGQofuD+xl/xWDd/yxgkztF8GuvkSXtVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhJeAUsIoB8pKhFGvdhFcUw/6rBH59tMq3Oastxiwl900OsIQ5oLRUBx7uRRCoVSBJrvX8Ww/wlFJJ59ow+r1OHO6GqAv79VrkkRvn11vt5d2w/ah9HVg2y5mYgatdHgvLTtbz/Wdh48MWDc2nvvpdr375UPqyEO7VRiNABhpe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lw2L0equ; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lw2L0equ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741048644; x=1772584644;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mFTdXqISjNDGQofuD+xl/xWDd/yxgkztF8GuvkSXtVM=;
  b=Lw2L0equEiVTyjW8HwDbivDjBzcBJZewrkA770eNZL1PpH4+8ohqMwDh
   hTSLLSRRrFTMg7FAWHzH3/wYOlIiloxopvVeJF1vQ54PCCX7MjHtM1yQo
   St+RsSrHJnXFY88+E4lphnhOUPyaq5EvoofSDQkLTY4VbNfv3yxgEuwOI
   LVVDWEembg3JPlro3pfp4aOa8tj4h0OmoK3czvy2zpvyj9KdXWRwBFJGi
   EjAE8V57xW4t8T9QWBfjGK9Bt1DdHkXSzm8BnzOpsYvYQLFpDRiZ9FEoF
   /oni/hXpUM5bLf1sczj20LVUwPnGxmLznCt9u8/7BEkpPPF+e73nz13lB
   w==;
X-CSE-ConnectionGUID: rqkvANi6T+mcp02PpGfaHg==
X-CSE-MsgGUID: Cywvul54RN25pMT+0PsLrQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="41975321"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="41975321"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 16:37:23 -0800
X-CSE-ConnectionGUID: qYuxdp8AQYePtZpAqpCVfA==
X-CSE-MsgGUID: n+bkgIIrRBWyfN1HGzr4iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="141427155"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.109.46])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 16:37:22 -0800
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH 4/5] ndctl/namespace: protect against overflow handling param.offset
Date: Mon,  3 Mar 2025 16:37:10 -0800
Message-ID: <065eb60a8255e44d73b5be963ba3a4a532ae1689.1741047738.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1741047738.git.alison.schofield@intel.com>
References: <cover.1741047738.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

A param.offset is parsed using parse_size64() but the result is
not checked for the error return ULLONG_MAX. If ULLONG_MAX is
returned, follow-on calculations will lead to overflow.

Add check for ULLONG_MAX upon return from parse_size64.
Add check for overflow in subsequent PFN_MODE offset calculation.

This issue was reported in a coverity scan.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 ndctl/namespace.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 5eb9e1e98e11..40bcf4ca65ac 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -1872,6 +1872,10 @@ static int write_pfn_sb(int fd, unsigned long long size, const char *sig,
 	int rc;
 
 	start = parse_size64(param.offset);
+	if (start == ULLONG_MAX) {
+		err("failed to parse offset option '%s'\n", param.offset);
+		return -EINVAL;
+	}
 	npfns = PHYS_PFN(size - SZ_8K);
 	pfn_align = parse_size64(param.align);
 	align = max(pfn_align, SUBSECTION_SIZE);
@@ -1913,6 +1917,10 @@ static int write_pfn_sb(int fd, unsigned long long size, const char *sig,
 		 * struct page size. But we also want to make sure we notice
 		 * when we end up adding new elements to struct page.
 		 */
+		if (start > ULLONG_MAX - (SZ_8K + MAX_STRUCT_PAGE_SIZE * npfns)) {
+			error("integer overflow in offset calculation\n");
+			return -EINVAL;
+		}
 		offset = ALIGN(start + SZ_8K + MAX_STRUCT_PAGE_SIZE * npfns, align)
 			- start;
 	} else
-- 
2.37.3

