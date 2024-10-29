Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9D3207A05
	for <nvdimm@lists.linux.dev>; Tue, 29 Oct 2024 20:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730234125; cv=none; b=pTVs8wdDq3Z7n0sr++VADG43WRhUMd2H+G4Jr5ET9M1dHdbxAJDb+mfEJKBFFdBVXAgKI9ZD9yWCNxvZoDMkpRRxQk/uEdZAgyPYd0HQFAuc5iDU5rx9npWV7ZLjspi6N6EDRmHc9HenU7I/VF21M5gK5NvxjnSqXoTLAoeiSVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730234125; c=relaxed/simple;
	bh=0W7PckUdOHdlKakfEsQJqPNrQBXeYoIYrnVM82egnls=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cYvpx2aFApWhIPg6OWDKcHv1FkkWab1wqpIt4RcrqwPuw9Z55cYAAu5Vj+/X6ukn++S7+sH+Q7lq+H5A8roeFj0LYoQgm+qh8RrNhIMuAyfxKSEShSSZZURu/Iicthw27F267iRJ+22uN52ofrjzldatIhYAnS5gPBt/b5NAm4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X9vOedLs; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X9vOedLs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730234123; x=1761770123;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=0W7PckUdOHdlKakfEsQJqPNrQBXeYoIYrnVM82egnls=;
  b=X9vOedLsHsmSQG42PB6s4SXmfLY1Xk42roYTmwkGXpF0L1i854Xd1o6b
   BvcuphjYM3RKeBtVNt2tGuGesUVJRbA+QARy40m/gpmESM3xLoDrVck9U
   bY1gbEIVOZla3wyfG6jH7i4f9MyQ75u7RZugiYHAtA6YGWTfU4C7PDi59
   2DMsqCIESgZAuu+YzQX0bhqmIzw/nfHURDg95x6Zm61WKkJ5aGe9JNPNp
   GiFwogOLxTzRRYzTmB2iIOGQ6kF0PwZL6xGQeR2Hz5XH1YdqRUnvZAkQ3
   eAPZWbsXqHStzLE2TwWSzqXJgFEFOuwgMiOZi5MU/iSL2xy7+q8S78chX
   g==;
X-CSE-ConnectionGUID: K5TihcBiQReNwUWuIb8JcQ==
X-CSE-MsgGUID: bPgUamuJQpmDzLCmoCWYNw==
X-IronPort-AV: E=McAfee;i="6700,10204,11240"; a="40485359"
X-IronPort-AV: E=Sophos;i="6.11,243,1725346800"; 
   d="scan'208";a="40485359"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 13:35:23 -0700
X-CSE-ConnectionGUID: gV5cRTslTzy+FFxnwSIihg==
X-CSE-MsgGUID: /LPwbb7oSFCWCWvGBK/Tfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,243,1725346800"; 
   d="scan'208";a="82185209"
Received: from ldmartin-desk2.corp.intel.com (HELO localhost) ([10.125.108.77])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 13:35:21 -0700
From: Ira Weiny <ira.weiny@intel.com>
Date: Tue, 29 Oct 2024 15:34:40 -0500
Subject: [PATCH v5 05/27] cxl/hdm: Use guard() in cxl_dpa_set_mode()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241029-dcd-type2-upstream-v5-5-8739cb67c374@intel.com>
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
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730234086; l=2014;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=0W7PckUdOHdlKakfEsQJqPNrQBXeYoIYrnVM82egnls=;
 b=wiLvZ9f5uQkV6nnGbpflF0B4DKvRq7FqlCnT3SfRpnG7TPpI1aYKLv2IBUa/cBl9SfCknhbBQ
 ts+mrpCq9mfCZR7F8qLbjmW976oCKbyOzrWj42FiYqIEIlYAElzUb/v
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

Additional DCD functionality is being added to this call which will be
simplified by the use of guard() with the cxl_dpa_rwsem.

Convert the function to use guard() prior to adding DCD functionality.

Suggested-by: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[Jonathan: new patch]
---
 drivers/cxl/core/hdm.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 3df10517a3278f228c7535fcbdb607d7b75bc879..463ba2669cea55194e2be2c26d02af75dde8d145 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -424,7 +424,6 @@ int cxl_dpa_set_mode(struct cxl_endpoint_decoder *cxled,
 	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 	struct device *dev = &cxled->cxld.dev;
-	int rc;
 
 	switch (mode) {
 	case CXL_DECODER_RAM:
@@ -435,11 +434,9 @@ int cxl_dpa_set_mode(struct cxl_endpoint_decoder *cxled,
 		return -EINVAL;
 	}
 
-	down_write(&cxl_dpa_rwsem);
-	if (cxled->cxld.flags & CXL_DECODER_F_ENABLE) {
-		rc = -EBUSY;
-		goto out;
-	}
+	guard(rwsem_write)(&cxl_dpa_rwsem);
+	if (cxled->cxld.flags & CXL_DECODER_F_ENABLE)
+		return -EBUSY;
 
 	/*
 	 * Only allow modes that are supported by the current partition
@@ -447,21 +444,15 @@ int cxl_dpa_set_mode(struct cxl_endpoint_decoder *cxled,
 	 */
 	if (mode == CXL_DECODER_PMEM && !resource_size(&cxlds->pmem_res)) {
 		dev_dbg(dev, "no available pmem capacity\n");
-		rc = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 	if (mode == CXL_DECODER_RAM && !resource_size(&cxlds->ram_res)) {
 		dev_dbg(dev, "no available ram capacity\n");
-		rc = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 
 	cxled->mode = mode;
-	rc = 0;
-out:
-	up_write(&cxl_dpa_rwsem);
-
-	return rc;
+	return 0;
 }
 
 int cxl_dpa_alloc(struct cxl_endpoint_decoder *cxled, unsigned long long size)

-- 
2.47.0

