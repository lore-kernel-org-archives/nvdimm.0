Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BC4209F22
	for <nvdimm@lists.linux.dev>; Tue, 29 Oct 2024 20:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730234128; cv=none; b=IhT/MugAj0SwOfF4kZ5vy9ejhEwPt/UVwBmgaV3qXrOu7YFwj8qpwmWTifHUtjXIV6jTv/BsKUdxPS7On6i0amgL6gbEogMJcuyLXDyoSxpSF4QEKRnQKTYc28uBtmCEHJRzPrJ796y5V9qoFFbtg9oOV4aG9SlKjfJXhoSzdms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730234128; c=relaxed/simple;
	bh=fA1/oyi8EaDVFfmo2mj6+i8KPBvzmfuwn749NS2ABxc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oeZQLfSpkxmYHYrOuJVk4Unb3smYxapXhvA4maesbSJWwm2HLpWBODow6A5wEOUS36FOlSCcH7mxbuUmmAtB6IVQHM2hPr46LDkiuJbGTAK6FWu7yF7lwlDyH3Vrdv3ga2BL1iY/kt1gqJErvqA5lb8D0+Z6vLmMhzuBbP9Z6g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kikcFVwE; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kikcFVwE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730234127; x=1761770127;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=fA1/oyi8EaDVFfmo2mj6+i8KPBvzmfuwn749NS2ABxc=;
  b=kikcFVwEH4aFdtS4PCZVwe6vNg4YkO4B3CXqqhQWIelakZgePglBvzC5
   0wgK7SEtb3a/J6cLv1EhPEG7WetDyvTDQMcpHytmGMe5ciSfqum5k9L+d
   O/M02qEsTa6ZnW46i9NDh9eBCW+dmAtdP68pvaDsti3CjMbBqm6RkIjOg
   bVJgT9nzMdSF2ltvOBG0Xzl3pX/O0/F4bWsMD8ZP2C8Uv3Wju8p4YB8XS
   TrvveZfpQ6/O0Rf+VdEjNDbm5U0/LOBUTY4d591myGsyACo+TFOZ4/yNO
   +71LgFTV3dggM1K2HlmCa5HfGsztjlkQb5/vOBSAt84K+Hlu1H3r2/tuy
   g==;
X-CSE-ConnectionGUID: Xaj5eILBQY2qyLXlAw9FeA==
X-CSE-MsgGUID: fw1zdbkbQ6ir0bL2nkdbdQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11240"; a="40485369"
X-IronPort-AV: E=Sophos;i="6.11,243,1725346800"; 
   d="scan'208";a="40485369"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 13:35:26 -0700
X-CSE-ConnectionGUID: Huj2rGozTj6LKhuvKuX8yQ==
X-CSE-MsgGUID: 9C/AkTshRMS65o21ZRkgDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,243,1725346800"; 
   d="scan'208";a="82185227"
Received: from ldmartin-desk2.corp.intel.com (HELO localhost) ([10.125.108.77])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 13:35:24 -0700
From: Ira Weiny <ira.weiny@intel.com>
Date: Tue, 29 Oct 2024 15:34:41 -0500
Subject: [PATCH v5 06/27] cxl/region: Refactor common create region code
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241029-dcd-type2-upstream-v5-6-8739cb67c374@intel.com>
References: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
In-Reply-To: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730234086; l=2944;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=fA1/oyi8EaDVFfmo2mj6+i8KPBvzmfuwn749NS2ABxc=;
 b=r7C/SkEtjuzA5zXdwo7CPhkvA6LM5lgKGPzXnTZPUoQQ4gaOP5HS22W7qRFKp8F52q4/iS5/D
 QrRvb1TTgHMCFs0pzeuh2RlMWlMDHGlz8nRmyj3EJwe0VhL8qgYbid2
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
NOTE: the tags were kept even though the region/decoder mode had to be
adjusted to move the patch earlier in the series.

Changes:
[Jonathan: Move forward in series to pick up early]
[iweiny: Adjust to be ahead of region/decoder mode change]
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

