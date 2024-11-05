Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F233A1F4736
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 18:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730831925; cv=none; b=Ma/2bjVhoGqznsqgbuYTwaReojP/LGhfJA9dQCzHEZx90tf1/LTzMerFTcZhEYrqaEtUzh15b1eMSj3boTizDblKvMrQyMlgHQaGcg9O7pcFEwmUQ2Fa9tBYZ5pxaClwOtDG2zc3D+Cf91Ce2PKjhH7g7TFhK0Rv3b2qlOpdGCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730831925; c=relaxed/simple;
	bh=75BXQWBlu1qm/IwTqsytAV/le/RP7NEqiwLIaFQMfE0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=W8wKHe5jDotW12B43XRqxiS8dUHEEU8bNjZglv/HejOBsl1BsGiiDpso0pbXhJKFMWbcE7Px46By3N3Jw5irm+g5cQacSxKQNzEZCmv5PD6OEO7MMPbUIKaA8Bv84hhDRZ+kK5loJYmc7lPd5IVdaeIyKAqmjMXj7/M0CoF78aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jg7Xlx0q; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jg7Xlx0q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730831925; x=1762367925;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=75BXQWBlu1qm/IwTqsytAV/le/RP7NEqiwLIaFQMfE0=;
  b=Jg7Xlx0q2DFaasfESVcRdgl94dzPXcAXU8UxXk0iSIPxbudli7OxpyCK
   WnGuy3NN5ZHJxnWpMd1324p2ATTgU69YirxJF+eamjwxhFxRSYDGTWxWe
   2xQFwdUyzEgu9YxXPcD5VqbRmQULBVoPWCj3KWFBr5BywM6+96hl0QsPk
   fvXupx4mw+Ro0fwZN3R0myrKv6nWGG9iz9XZ67i3wcRxqTFC9BzeBgTP7
   3tkIPYjnf9J+V3ArmJNvAR9EiCybWrEVDbXPHxf6NPL68HeEZ0oFNckxL
   tWLxXFYnQfU6IHSSms9vFU/C9fmkc5uDXaTjH74t1Ie3T22HPDCZsUaoO
   g==;
X-CSE-ConnectionGUID: iwGt96NOTTOoAysHbMQTGA==
X-CSE-MsgGUID: T661+LuCQhKUbIdAbPKjXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41153121"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41153121"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 10:38:44 -0800
X-CSE-ConnectionGUID: 8QPtAFruTISacKlLAoB7Yg==
X-CSE-MsgGUID: cCfp5t7nQcS/PGkyM1EiAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="84235664"
Received: from spandruv-mobl4.amr.corp.intel.com (HELO localhost) ([10.125.109.247])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 10:38:41 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Tue, 05 Nov 2024 12:38:28 -0600
Subject: [PATCH v6 06/27] cxl/region: Refactor common create region code
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241105-dcd-type2-upstream-v6-6-85c7fa2140fe@intel.com>
References: <20241105-dcd-type2-upstream-v6-0-85c7fa2140fe@intel.com>
In-Reply-To: <20241105-dcd-type2-upstream-v6-0-85c7fa2140fe@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Navneet Singh <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Li Ming <ming4.li@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730831904; l=2691;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=75BXQWBlu1qm/IwTqsytAV/le/RP7NEqiwLIaFQMfE0=;
 b=k29Apd4ClqH1JuVDrDNnd9iMT8uzD+HyCz7SeFbm3JzphFlM1PK7HQedNNwUUc0AYP5psaYch
 V5Cyxus/0GPDU9lj4cn/5NHisJL5Go4SEvJvLLdDrvo6rhE6sfZjZbb
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

create_pmem_region_store() and create_ram_region_store() are identical
with the exception of the region mode.  With the addition of DC region
mode this would end up being 3 copies of the same code.

Refactor create_pmem_region_store() and create_ram_region_store() to use
a single common function to be used in subsequent DC code.

Suggested-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Li Ming <ming4.li@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/cxl/core/region.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index e701e4b0403282a06bccfbca6bf212fd35e3a64c..02437e716b7e04493bb7a2b7d14649a2414c1cb7 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2536,9 +2536,8 @@ static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
 	return devm_cxl_add_region(cxlrd, id, mode, CXL_DECODER_HOSTONLYMEM);
 }
 
-static ssize_t create_pmem_region_store(struct device *dev,
-					struct device_attribute *attr,
-					const char *buf, size_t len)
+static ssize_t create_region_store(struct device *dev, const char *buf,
+				   size_t len, enum cxl_decoder_mode mode)
 {
 	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(dev);
 	struct cxl_region *cxlr;
@@ -2548,31 +2547,26 @@ static ssize_t create_pmem_region_store(struct device *dev,
 	if (rc != 1)
 		return -EINVAL;
 
-	cxlr = __create_region(cxlrd, CXL_DECODER_PMEM, id);
+	cxlr = __create_region(cxlrd, mode, id);
 	if (IS_ERR(cxlr))
 		return PTR_ERR(cxlr);
 
 	return len;
 }
+
+static ssize_t create_pmem_region_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t len)
+{
+	return create_region_store(dev, buf, len, CXL_DECODER_PMEM);
+}
 DEVICE_ATTR_RW(create_pmem_region);
 
 static ssize_t create_ram_region_store(struct device *dev,
 				       struct device_attribute *attr,
 				       const char *buf, size_t len)
 {
-	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(dev);
-	struct cxl_region *cxlr;
-	int rc, id;
-
-	rc = sscanf(buf, "region%d\n", &id);
-	if (rc != 1)
-		return -EINVAL;
-
-	cxlr = __create_region(cxlrd, CXL_DECODER_RAM, id);
-	if (IS_ERR(cxlr))
-		return PTR_ERR(cxlr);
-
-	return len;
+	return create_region_store(dev, buf, len, CXL_DECODER_RAM);
 }
 DEVICE_ATTR_RW(create_ram_region);
 

-- 
2.47.0

