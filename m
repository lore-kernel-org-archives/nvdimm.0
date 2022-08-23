Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5FFA5B
	for <nvdimm@lists.linux.dev>; Tue, 23 Aug 2022 07:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661240733; x=1692776733;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/9z/gQg3nRurW7/yKCKgoDtKwuWnKKZassG/KM8FQgQ=;
  b=g/VQuU2j4Tl8l82OiuF5DAawXywUyyl8xsLFQJ4UY/G3NrnxTNobfHZU
   ap9a4bn7l9vM1QrwRznJy6UQGAoFHtSBHNs6xPvhJ2WdZUobrvqlwBz8F
   69ddWNqkWv9QGAPaYLNPB94oHBHCxRF/aIB4PMoWCCLPbiqnVcFY5Spla
   WwigEqqfePe7b+FoPJCvMaNbzCQ/Ed9l35DMSawtnVRVBu1WRBdVsT4iH
   COe8yXgpYpg8pEuHLjWql8AkoAunCe6YSCx4IVy0UhUjXTRx8HSGxSyZG
   G+S1t/HT+5oRXIwPcEOghJtY0h9hkd++Z96qM+1MR4MVDzOYxKIAL8mf6
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="294901759"
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="294901759"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 00:45:32 -0700
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="609254286"
Received: from skummith-mobl1.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.54.206])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 00:45:31 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 2/3] libcxl: fox a resource leak and a forward NULL check
Date: Tue, 23 Aug 2022 01:45:26 -0600
Message-Id: <20220823074527.404435-3-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823074527.404435-1-vishal.l.verma@intel.com>
References: <20220823074527.404435-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1260; h=from:subject; bh=/9z/gQg3nRurW7/yKCKgoDtKwuWnKKZassG/KM8FQgQ=; b=owGbwMvMwCXGf25diOft7jLG02pJDMksrdOaby6tVC0KOGu4b4ntucdlXALP7nBtN6q5pzJl+mOt tNlJHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZjI7DcM/1QSxKbuucf87o6XxbNA7R fvZG04avl/BjFai5k5X+Bvz2dkWCd/bL96nHE/D1s0q9DlnGV3onwXbHi1qSXi6HOF3xvn8gAA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Static analysis reports a couple of issues in add_cxl_region(). Firstly,
'path' wasn't freed in the success case, only in the error case.
Secondly, the error handling after 'calloc()'ing the region object
erroneously jumped to the error path which tried to free the region object.

Add anew error label to just free 'path' and return for this exit case.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/lib/libcxl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 021d59f..e8c5d44 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -482,7 +482,7 @@ static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
 
 	region = calloc(1, sizeof(*region));
 	if (!region)
-		goto err;
+		goto err_path;
 
 	region->id = id;
 	region->ctx = ctx;
@@ -551,11 +551,13 @@ static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
 
 	list_add_sorted(&decoder->regions, region, list, region_start_cmp);
 
+	free(path);
 	return region;
 err:
 	free(region->dev_path);
 	free(region->dev_buf);
 	free(region);
+err_path:
 	free(path);
 	return NULL;
 }
-- 
2.37.2

