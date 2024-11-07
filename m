Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194C821A4C8
	for <nvdimm@lists.linux.dev>; Thu,  7 Nov 2024 20:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731013124; cv=none; b=jIw23KifieBxcusjmeMXyTvXzywU24MQ+TEANu4wANS1wwMH07zAJqC+td3B39m5nDEarv3hr2gn4qb7c5eHehYhXzfBAMd1BJ/rzwS/1UlURR987j//AJ7Ugb9/hUfAOiefGzWq+AY/+6RfcBIAJ404jg/8Y3E6hXO8tCmmbq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731013124; c=relaxed/simple;
	bh=75BXQWBlu1qm/IwTqsytAV/le/RP7NEqiwLIaFQMfE0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Kxlq2SX+cYURsBDUmRaqrFNc7sXkDOFxUYCvxV4ebAAZL+8t1LW9oC98AufkL59WipT7AH1Tfy87qoY6zNHHgEccVxma3BjgOVx835V0tzy31SYFYPYimlLeWgfZcJh7CHdBrjYftPkoas4kejp2L6r7FZ8tUZzxA3GpqoPxgW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gqVgx1dS; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gqVgx1dS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731013123; x=1762549123;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=75BXQWBlu1qm/IwTqsytAV/le/RP7NEqiwLIaFQMfE0=;
  b=gqVgx1dSF24W1Wd4BziQiyQ6ifF25qWdAg049iIX9THRlTsmf5Jhpcys
   0KtJE4DnCxoKs893m6UfnUaxJhwiL9sKaQM9YZDbOyOrTTqD9P13hdA0J
   QTDhapy+sj6vu+O7coRK1/oJ3TuFBkM9WUCLQKE3GTucsy4zy0GHCQ91/
   tetEY3VYFKAedHD6CHX+hfwqG/tHb3EDZ/E4asTiyOOTu0B+emMJXl8BE
   X5h7Iwj3cE06iVjjTfxjElQsz7J8sEbsVF04cUaxz4/QmoMzc+BRsI5AG
   SoKe2kcAWarZ1q/QQ79JGsBJqS3wvfByZnuJFjvIz8YDgq0GbktNqDz5K
   A==;
X-CSE-ConnectionGUID: Aeb/yIEuRkKaUqIjn2AFdA==
X-CSE-MsgGUID: chCi+42SS/GmidNBHlK1Aw==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="30300358"
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="30300358"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 12:58:43 -0800
X-CSE-ConnectionGUID: hoFw0JLpSWC846B5sSAceg==
X-CSE-MsgGUID: rMAG5OAnT4qyR3PChUGXxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="90093617"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.110.195])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 12:58:41 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Thu, 07 Nov 2024 14:58:24 -0600
Subject: [PATCH v7 06/27] cxl/region: Refactor common create region code
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-dcd-type2-upstream-v7-6-56a84e66bc36@intel.com>
References: <20241107-dcd-type2-upstream-v7-0-56a84e66bc36@intel.com>
In-Reply-To: <20241107-dcd-type2-upstream-v7-0-56a84e66bc36@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1731013104; l=2691;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=75BXQWBlu1qm/IwTqsytAV/le/RP7NEqiwLIaFQMfE0=;
 b=P5NFy810p+Mcoo9NX+SKYo309XX3Xmjk7p3ymUd6Quv56QnFprfYx05IGG0bGmqF24M1raZdI
 BKEtUDiNSOyBaedgIm/4KPvJD6X2etX62hn8Vc8XOSEOCsV2uzyt3Tj
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

