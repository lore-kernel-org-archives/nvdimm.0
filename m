Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3781FB4
	for <nvdimm@lists.linux.dev>; Sat,  3 Jun 2023 02:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685758175; x=1717294175;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=5MB3BKWckl+By6dAOaDRIYtbC3hmRt8XrTwn1/3TCYE=;
  b=XIcEUnKhE9G9wr3c+mHq2Xp/EXSWXH4RBAR3laSKxIm4scmEdfzWng4u
   e+cJ1+sGt6p8JIs2YRM3A7Acu5vMD/sTuC0hlZY9RS5DakHpG4MDKYP1G
   w0x+FZXltoe2oIStt0eMLlB8KhqWaLU7pE5WKDiterZBPvBJaoA94tTGv
   MqIVnT0acRlmDWWuK8hmHbY9RCNG928D+7BeuvzWMbsr3lu4lXPbqf/sL
   AfW7QagmtdbxUqfyomIh394kmyOFIklzf1dsLhg0mT/swpbQMtV7Mg+Lw
   zm8Xz8NsxHb5uPh9hJefHIye8AAb+JNL5KdRk16SOgtAGWS4dDTQMm8sD
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="340649451"
X-IronPort-AV: E=Sophos;i="6.00,214,1681196400"; 
   d="scan'208";a="340649451"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 19:09:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="852354418"
X-IronPort-AV: E=Sophos;i="6.00,214,1681196400"; 
   d="scan'208";a="852354418"
Received: from iweiny-mobl.amr.corp.intel.com (HELO localhost) ([10.212.97.230])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 19:09:33 -0700
From: Ira Weiny <ira.weiny@intel.com>
Date: Fri, 02 Jun 2023 19:09:23 -0700
Subject: [PATCH RFC 3/4] dax/cxl: Fix refcount leak in
 cxl_dax_region_probe()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230602-dax-region-put-v1-3-d8668f335d45@intel.com>
References: <20230602-dax-region-put-v1-0-d8668f335d45@intel.com>
In-Reply-To: <20230602-dax-region-put-v1-0-d8668f335d45@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Joao Martins <joao.m.martins@oracle.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Yongqiang Liu <liuyongqiang13@huawei.com>, 
 Paul Cassella <cassella@hpe.com>, linux-kernel@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
 Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.13-dev-9a8cd
X-Developer-Signature: v=1; a=ed25519-sha256; t=1685758165; l=1320;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=5MB3BKWckl+By6dAOaDRIYtbC3hmRt8XrTwn1/3TCYE=;
 b=k5/U4wkR3Cb4EoT4bw2Hlb0zJYm/GlDWxKX1NPtJA+QIb7WIyxP9oweVP1LvxCBhDYX9UpvRE
 lYDzxPnnzypCpx7kifOzdjSQ9VerVqMdNuihxC1zPm9rKcO0zeMM94U
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

alloc_dax_region() returns a reference protected dax_region.  Regardless
of the success of the devm_create_dev_dax() the reference returned from
alloc_dax_region() needs to be released.

Drop the dax_region reference regardless of the success of dev_dax
creation.  Clean up comments.

Fixes: 09d09e04d2fc ("cxl/dax: Create dax devices for CXL RAM regions")
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
This work was inspired by Yongqiang Liu here:

https://lore.kernel.org/all/20221203095858.612027-1-liuyongqiang13@huawei.com/
---
 drivers/dax/cxl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index ccdf8de85bd5..bbfe71cf4325 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -29,12 +29,11 @@ static int cxl_dax_region_probe(struct device *dev)
 		.size = range_len(&cxlr_dax->hpa_range),
 	};
 	dev_dax = devm_create_dev_dax(&data);
-	if (IS_ERR(dev_dax))
-		return PTR_ERR(dev_dax);
 
 	/* child dev_dax instances now own the lifetime of the dax_region */
 	dax_region_put(dax_region);
-	return 0;
+
+	return IS_ERR(dev_dax) ? PTR_ERR(dev_dax) : 0;
 }
 
 static struct cxl_driver cxl_dax_region_driver = {

-- 
2.40.0

