Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE5927F4CA
	for <nvdimm@lists.linux.dev>; Thu,  6 Mar 2025 23:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741305025; cv=none; b=i5m5lwSSfrxD3MilZz6CEzfcxyVzEZQGRN24CmMBfj9LQvC3IgwXXr4ikq4D2vNy+yn7onHi2Zn5F5NPOSBKF+JYLES4iGjUY4D5u4N8zuT39DqMZGqY/+JQRJcXlG6hoLilyZCJq1bzbb9cd5x7vHlQ0wTnmQH1urFCVXdsy4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741305025; c=relaxed/simple;
	bh=i1+JxnIc/xMnOV5MOZrRzQTpHllEhaNFEo98JQN0xU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELvdiELwe/t3WD4SKpM7KGpWzSmynGskkALfIzGHGFs1dMMvhsfeKmIOsJTQQiI9930WPAxuXGs9mHGSRneK6m+2PieiYg7m0GDwuGFyr0JpCwcx0RflVQDz/n9Ttgsz79XS/UMGF5fUNh6DsOomy8/9mPuQbQZ5UqNCu6k1aoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RjNwzL+I; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RjNwzL+I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741305024; x=1772841024;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i1+JxnIc/xMnOV5MOZrRzQTpHllEhaNFEo98JQN0xU0=;
  b=RjNwzL+IHxqSH/VlSBxhKJ2NQ6yQB4WSh8heSrCkDVv2OAz45Wv9d1M1
   6b8u2PZjdhMNOJHoK5VDyY3VZMHEIba4qFXLaF6FwN+8+YXF5Bm+G87Ph
   v2qbI3nZmJTvzQc5KeLdVp6iDZ+vGsIoj2hJq2Q+HajxfJ8TcGcRSmSTE
   pKP2gl+77l1m19mxCqwd570GJS0zRBE4Pf4zgIGVYKZTvDHb/q55FblMk
   DVWPN5J80BbwXj/ND03zRtykkAXERrr+9hPOZ/u52k0t4DhaPezqSBA0o
   JOMMO9oR/lo2O+6h7dPFnRydYvCNzRAk9TWl1fvSYrcsgf9bEhN3Sxeih
   Q==;
X-CSE-ConnectionGUID: l6kDolRFSXylFiOSAD0wwA==
X-CSE-MsgGUID: MA32rO0eR6S8v8fPON6G7w==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="45150086"
X-IronPort-AV: E=Sophos;i="6.14,227,1736841600"; 
   d="scan'208";a="45150086"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 15:50:23 -0800
X-CSE-ConnectionGUID: XtGiUUTJTEyfkc+PkmSo2g==
X-CSE-MsgGUID: 4gEX3l0HR2mMPxfMIq961w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="123358728"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.110.63])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 15:50:22 -0800
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v2 4/5] ndctl/namespace: protect against overflow handling param.offset
Date: Thu,  6 Mar 2025 15:50:13 -0800
Message-ID: <fd9b0fa9091490c71791ebd695ee48f8da12e5ec.1741304303.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1741304303.git.alison.schofield@intel.com>
References: <cover.1741304303.git.alison.schofield@intel.com>
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
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/namespace.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 6c86eadcad69..2cee1c4c1451 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -1873,6 +1873,10 @@ static int write_pfn_sb(int fd, unsigned long long size, const char *sig,
 	int rc;
 
 	start = parse_size64(param.offset);
+	if (start == ULLONG_MAX) {
+		err("failed to parse offset option '%s'\n", param.offset);
+		return -EINVAL;
+	}
 	npfns = PHYS_PFN(size - SZ_8K);
 	pfn_align = parse_size64(param.align);
 	align = max(pfn_align, SUBSECTION_SIZE);
@@ -1914,6 +1918,10 @@ static int write_pfn_sb(int fd, unsigned long long size, const char *sig,
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

