Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B3C210B
	for <nvdimm@lists.linux.dev>; Sat, 22 Oct 2022 22:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666478447; x=1698014447;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Pst2uhR2xvg/Znkt6nPeUuXcQVUI/8XVcItJooMuWHw=;
  b=Zs6LFcvFiSZourxAK/dPkMOGRteVP5sxs2osBj7ej7aRFlIIfOGhju+D
   +m7e29m8wH805WeuiPCX2MoDQ/ZWGK7++n9Ubc0maTmezdgOvkzgU8ETQ
   cx60A9H06ssh9SNH5pzMBu4j6Zzk41ClDvXfp4zXdHeiIEBXwLovw2Jps
   3zvDmNkGxYjzlXXnPnlBRGE94HzLsJcIf/J9DWCzF6R3bKprKEV11rG5W
   /wa9BBqEZO+ntCU0lH5HBPUVQVr7/Q6LCVUZEwXI48ZXNywP9TSRfrwvb
   TXlA42WV9wOyHyKSh5207OgppLbTruXbgABKl5WoR/pNUwj/WQqKsa6rD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10508"; a="307208843"
X-IronPort-AV: E=Sophos;i="5.95,206,1661842800"; 
   d="scan'208";a="307208843"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2022 15:40:39 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10508"; a="876060641"
X-IronPort-AV: E=Sophos;i="5.95,206,1661842800"; 
   d="scan'208";a="876060641"
Received: from rhabibul-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.235.98])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2022 15:40:38 -0700
Subject: [mm-unstable PATCH] mm/memremap: fix pgmap_request_folio() stub
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev
Date: Sat, 22 Oct 2022 15:40:38 -0700
Message-ID: <166647843799.1783549.13495269957811737203.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

0day robot reports:

include/linux/memremap.h:258:9: warning: expression which evaluates to zero treated as a null pointer constant of type 'struct folio *'

...because I failed to update the pgmap_request_folio() return value in
the CONFIG_ZONE_DEVICE=n case when changing the calling convention.

Fixes: e634e7e18f3b ("mm/memremap: Introduce pgmap_request_folio() using pgmap offsets")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/memremap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index f11f827883bb..4a6eadf0d1d8 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -255,7 +255,7 @@ static inline struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 static inline struct folio *pgmap_request_folio(struct dev_pagemap *pgmap,
 						pgoff_t pgmap_offset, int order)
 {
-	return false;
+	return NULL;
 }
 
 static inline bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn)

