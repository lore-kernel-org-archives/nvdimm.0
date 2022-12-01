Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A124C10782
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 22:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669932200; x=1701468200;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dnRIuLEriveayO8R/0nr9AYpHlcpe5HfsZbIs0rof2U=;
  b=h5ihDEASBYUl86qYxIPo0rmk2AvuAqKo3xQdaMd2SH9EfA9vKRKksmNc
   JTg4H39tzzgX4IKjqhPOn8EsDQzKo8fhrMO+apGxMOk4E/54mdV0O1H6c
   /4+y3cBdKwUz6E1QdLlfEY9Jq2RWltsaz1BUB9H6A+O6FsYWD/+WHiKhA
   a8Grmf+RRiuEp6sn3gbyti8SCddykdd6USpluvSkOejbcntsLsdH9QpVy
   raDnmWVRDrHzfAqIg3ekgcXIWfUx1XpzZh4AdwMLbx9tBlh1MGugdVs8p
   CRB7HuXrTbxR0sKdKLWzi7+kzTReitZ1AghmjBv15Lj5mUsKlfejnJ2Jc
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="342742076"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="342742076"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 14:03:19 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="622464526"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="622464526"
Received: from navarrof-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.177.235])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 14:03:19 -0800
Subject: [PATCH 1/5] cxl: add dimm_id support for __nvdimm_create()
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Dave Jiang <dave.jiang@intel.com>, Jonathan.Cameron@huawei.com,
 dave.jiang@intel.com, nvdimm@lists.linux.dev, dave@stgolabs.net
Date: Thu, 01 Dec 2022 14:03:19 -0800
Message-ID: <166993219918.1995348.10786511454826454601.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
References: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Jiang <dave.jiang@intel.com>

Set the cxlds->serial as the dimm_id to be fed to __nvdimm_create(). The
security code uses that as the key description for the security key of the
memory device. The nvdimm unlock code cannot find the respective key
without the dimm_id.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/166863357043.80269.4337575149671383294.stgit@djiang5-desk3.ch.intel.com
Link: https://lore.kernel.org/r/166983620459.2734609.10175456773200251184.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/pmem.c |    7 +++++++
 drivers/cxl/cxl.h       |    3 +++
 drivers/cxl/pmem.c      |    3 ++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
index 36aa5070d902..7b9a9573e6f2 100644
--- a/drivers/cxl/core/pmem.c
+++ b/drivers/cxl/core/pmem.c
@@ -238,6 +238,13 @@ static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
 	dev->parent = &cxlmd->dev;
 	dev->bus = &cxl_bus_type;
 	dev->type = &cxl_nvdimm_type;
+	/*
+	 * A "%llx" string is 17-bytes vs dimm_id that is max
+	 * NVDIMM_KEY_DESC_LEN
+	 */
+	BUILD_BUG_ON(sizeof(cxl_nvd->dev_id) < 17 ||
+		     sizeof(cxl_nvd->dev_id) > NVDIMM_KEY_DESC_LEN);
+	sprintf(cxl_nvd->dev_id, "%llx", cxlmd->cxlds->serial);
 
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

