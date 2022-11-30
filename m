Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9485F79C0
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 19:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669836205; x=1701372205;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HB2mu3vlQjvxETa6YGLhbaj71HlkoxbGVkNoisAHxLg=;
  b=gHsAmk+Dn6mGNaLDXmF+ZTL1NiXJS2SB9mJFcLCRsVkZp8xAnrcsvP5O
   TDpQ7MWjNElHz1kita0MORvhJxJOzTv1RzSsIqCHmEcEqBs+pHOtiB8vH
   prjco+H/vhj8jcNrr0LPOI0SLd2mOEnwepAn8SKMLNtxVJCRFnNHxL2r/
   9aK6U/l+jcJw1B7BWe851ObPpq9/EWjNuEQCN38tHh9m9MMTC+PAuwqla
   a+WqL+FANByfaiDVXFbdy5nnvMhP1JiZ0DIvS7YePrgsFFWGmmmOrprtN
   xgFbkM7lXhvMl6uJH8hQ5UwmoADmMHDxiBkteGn2bjMiDD5qmXEYMDkPR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="313118820"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="313118820"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:23:25 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="889415532"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="889415532"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:23:24 -0800
Subject: [PATCH v7 20/20] cxl: add dimm_id support for __nvdimm_create()
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Wed, 30 Nov 2022 12:23:24 -0700
Message-ID: 
 <166983620459.2734609.10175456773200251184.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166983606451.2734609.4050644229630259452.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166983606451.2734609.4050644229630259452.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Set the cxlds->serial as the dimm_id to be fed to __nvdimm_create(). The
security code uses that as the key description for the security key of the
memory device. The nvdimm unlock code cannot find the respective key
without the dimm_id.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/166863357043.80269.4337575149671383294.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/pmem.c |   10 ++++++++++
 drivers/cxl/cxl.h       |    3 +++
 drivers/cxl/pmem.c      |    3 ++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
index 36aa5070d902..f985d41f8f8e 100644
--- a/drivers/cxl/core/pmem.c
+++ b/drivers/cxl/core/pmem.c
@@ -224,6 +224,7 @@ static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
 {
 	struct cxl_nvdimm *cxl_nvd;
 	struct device *dev;
+	int rc;
 
 	cxl_nvd = kzalloc(sizeof(*cxl_nvd), GFP_KERNEL);
 	if (!cxl_nvd)
@@ -239,6 +240,15 @@ static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
 	dev->bus = &cxl_bus_type;
 	dev->type = &cxl_nvdimm_type;
 
+	rc = snprintf(cxl_nvd->dev_id, CXL_DEV_ID_LEN, "%llx",
+		      cxlmd->cxlds->serial);
+	if (rc <= 0) {
+		kfree(cxl_nvd);
+		if (rc == 0)
+			rc = -ENXIO;
+		return ERR_PTR(rc);
+	}
+
 	return cxl_nvd;
 }
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 7d07127eade3..b433e541a054 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -420,11 +420,14 @@ struct cxl_nvdimm_bridge {
 	enum cxl_nvdimm_brige_state state;
 };
 
+#define CXL_DEV_ID_LEN 19
+
 struct cxl_nvdimm {
 	struct device dev;
 	struct cxl_memdev *cxlmd;
 	struct cxl_nvdimm_bridge *bridge;
 	struct xarray pmem_regions;
+	u8 dev_id[CXL_DEV_ID_LEN]; /* for nvdimm, string of 'serial' */
 };
 
 struct cxl_pmem_region_mapping {
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 403e41bcbf2b..ab40c93c44e5 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -117,7 +117,8 @@ static int cxl_nvdimm_probe(struct device *dev)
 	set_bit(ND_CMD_SET_CONFIG_DATA, &cmd_mask);
 	nvdimm = __nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd,
 				 cxl_dimm_attribute_groups, flags,
-				 cmd_mask, 0, NULL, NULL, cxl_security_ops, NULL);
+				 cmd_mask, 0, NULL, cxl_nvd->dev_id,
+				 cxl_security_ops, NULL);
 	if (!nvdimm) {
 		rc = -ENOMEM;
 		goto out;


