Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD222C80
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 00:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642984183; x=1674520183;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TaTisyWuoxRLmiGPcwAI2dgDtm81CmqqUNNAU1GKD3U=;
  b=fvyakNnMH0OLGM68Q8xP+JlBqgtcevyIFZK/2zLs7DO9Ug6UsJYbZffq
   fLEoWXrKbp65VjwIVX3M9/o9B5sTTf/4mFMmloOcRnOGCNcECDnLzwaFg
   Cqzz7R/22vBAHLzsj6pjq4xx3Zz1wkeJ5LP1IdFGRr5gXJKQnoe3oRBc5
   CtR5bI+UyNEaFj4Dt3ILBw4aKcx1v3UuqsJrw4rcub8PxzW2880BsB+Cy
   E+ao6axQSvDjfV57sbu925jEIRydqqWg0gjnQLPWL6dKo3WzD0Ea3b43D
   HkOr9ludnTXBozT4uE7nC3rXsKzlGIJOZysRKPgwuPG9PpAeOnL62rTaw
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="244766540"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="244766540"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:29:43 -0800
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="476536669"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:29:42 -0800
Subject: [PATCH v3 12/40] cxl/core: Fix cxl_probe_component_regs() error
 message
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: linux-pci@vger.kernel.org, nvdimm@lists.linux.dev
Date: Sun, 23 Jan 2022 16:29:42 -0800
Message-ID: <164298418268.3018233.17790073375430834911.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Fix a '\n' vs '/n' typo.

Fixes: 08422378c4ad ("cxl/pci: Add HDM decoder capabilities")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/regs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/regs.c b/drivers/cxl/core/regs.c
index 0d63758e2605..12a6cbddf110 100644
--- a/drivers/cxl/core/regs.c
+++ b/drivers/cxl/core/regs.c
@@ -50,7 +50,7 @@ void cxl_probe_component_regs(struct device *dev, void __iomem *base,
 
 	if (FIELD_GET(CXL_CM_CAP_HDR_ID_MASK, cap_array) != CM_CAP_HDR_CAP_ID) {
 		dev_err(dev,
-			"Couldn't locate the CXL.cache and CXL.mem capability array header./n");
+			"Couldn't locate the CXL.cache and CXL.mem capability array header.\n");
 		return;
 	}
 

