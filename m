Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86022847F
	for <nvdimm@lists.linux.dev>; Sat,  3 Jun 2023 06:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685772852; x=1717308852;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=anoCLzAQHGKj4E1ooztF/6oS3YPq1Jjo7+U1nX0UMKY=;
  b=nro1Vh74MMONWtUQnwoovpS62TsJ8KumZcwc0F4nvGAnKKymWKdhLSBO
   xOZi/2uv7qWEtU+JhyoRXqbzFWYYDkPGHlfZgXfJqpO3AZqsnTifD1XJN
   LoxNWzCUF69NXzAVD6N+HFzgfaNTQveqfnhMMrbqReElOUeAXjcoC36MK
   FfaO2wT9W7caFzSFxXYgfjbQS9u5rNMzMpvhu6K0FoDl7w3F+CAoLoadz
   GXdAiWbgs0XmySQX/duFdZlC3vFHOe9W81fgyVf0BbjaMq+/DSv8Ax19A
   1E68FgHoh5c3QN/kjCnZNeyiASbnmAM8j9uMWN8kpCEbF3ePExbpZJR9l
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="442417643"
X-IronPort-AV: E=Sophos;i="6.00,215,1681196400"; 
   d="scan'208";a="442417643"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 23:14:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="711211579"
X-IronPort-AV: E=Sophos;i="6.00,215,1681196400"; 
   d="scan'208";a="711211579"
Received: from rjkoval-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.230.247])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 23:14:12 -0700
Subject: [PATCH 4/4] dax: Cleanup extra dax_region references
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: Ira Weiny <ira.weiny@intel.com>, linux-cxl@vger.kernel.org
Date: Fri, 02 Jun 2023 23:14:11 -0700
Message-ID: <168577285161.1672036.8111253437794419696.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <168577282846.1672036.13848242151310480001.stgit@dwillia2-xfh.jf.intel.com>
References: <168577282846.1672036.13848242151310480001.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Now that free_dev_dax_id() internally manages the references it needs
the extra references taken by the dax_region drivers are not needed.

Reported-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/bus.c       |    4 +---
 drivers/dax/bus.h       |    1 -
 drivers/dax/cxl.c       |    8 +-------
 drivers/dax/hmem/hmem.c |    8 +-------
 drivers/dax/pmem.c      |    7 +------
 5 files changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index a4cc3eca774f..0ee96e6fc426 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -454,11 +454,10 @@ static void dax_region_free(struct kref *kref)
 	kfree(dax_region);
 }
 
-void dax_region_put(struct dax_region *dax_region)
+static void dax_region_put(struct dax_region *dax_region)
 {
 	kref_put(&dax_region->kref, dax_region_free);
 }
-EXPORT_SYMBOL_GPL(dax_region_put);
 
 /* a return value >= 0 indicates this invocation invalidated the id */
 static int __free_dev_dax_id(struct dev_dax *dev_dax)
@@ -641,7 +640,6 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 		return NULL;
 	}
 
-	kref_get(&dax_region->kref);
 	if (devm_add_action_or_reset(parent, dax_region_unregister, dax_region))
 		return NULL;
 	return dax_region;
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index 8cd79ab34292..bdbf719df5c5 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -9,7 +9,6 @@ struct dev_dax;
 struct resource;
 struct dax_device;
 struct dax_region;
-void dax_region_put(struct dax_region *dax_region);
 
 /* dax bus specific ioresource flags */
 #define IORESOURCE_DAX_STATIC BIT(0)
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index ccdf8de85bd5..8bc9d04034d6 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -13,7 +13,6 @@ static int cxl_dax_region_probe(struct device *dev)
 	struct cxl_region *cxlr = cxlr_dax->cxlr;
 	struct dax_region *dax_region;
 	struct dev_dax_data data;
-	struct dev_dax *dev_dax;
 
 	if (nid == NUMA_NO_NODE)
 		nid = memory_add_physaddr_to_nid(cxlr_dax->hpa_range.start);
@@ -28,13 +27,8 @@ static int cxl_dax_region_probe(struct device *dev)
 		.id = -1,
 		.size = range_len(&cxlr_dax->hpa_range),
 	};
-	dev_dax = devm_create_dev_dax(&data);
-	if (IS_ERR(dev_dax))
-		return PTR_ERR(dev_dax);
 
-	/* child dev_dax instances now own the lifetime of the dax_region */
-	dax_region_put(dax_region);
-	return 0;
+	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
 }
 
 static struct cxl_driver cxl_dax_region_driver = {
diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index e5fe8b39fb94..5d2ddef0f8f5 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -16,7 +16,6 @@ static int dax_hmem_probe(struct platform_device *pdev)
 	struct dax_region *dax_region;
 	struct memregion_info *mri;
 	struct dev_dax_data data;
-	struct dev_dax *dev_dax;
 
 	/*
 	 * @region_idle == true indicates that an administrative agent
@@ -38,13 +37,8 @@ static int dax_hmem_probe(struct platform_device *pdev)
 		.id = -1,
 		.size = region_idle ? 0 : range_len(&mri->range),
 	};
-	dev_dax = devm_create_dev_dax(&data);
-	if (IS_ERR(dev_dax))
-		return PTR_ERR(dev_dax);
 
-	/* child dev_dax instances now own the lifetime of the dax_region */
-	dax_region_put(dax_region);
-	return 0;
+	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
 }
 
 static struct platform_driver dax_hmem_driver = {
diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index f050ea78bb83..ae0cb113a5d3 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -13,7 +13,6 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
 	int rc, id, region_id;
 	resource_size_t offset;
 	struct nd_pfn_sb *pfn_sb;
-	struct dev_dax *dev_dax;
 	struct dev_dax_data data;
 	struct nd_namespace_io *nsio;
 	struct dax_region *dax_region;
@@ -65,12 +64,8 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
 		.pgmap = &pgmap,
 		.size = range_len(&range),
 	};
-	dev_dax = devm_create_dev_dax(&data);
 
-	/* child dev_dax instances now own the lifetime of the dax_region */
-	dax_region_put(dax_region);
-
-	return dev_dax;
+	return devm_create_dev_dax(&data);
 }
 
 static int dax_pmem_probe(struct device *dev)

