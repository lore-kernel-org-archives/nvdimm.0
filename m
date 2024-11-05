Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B571F1303
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 18:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730831922; cv=none; b=Wtv5hNgz2UCQYcgcnneafosSqYABZGn0H2ByRwEpcy5AIazYPa2zrhw9+hS9Ff1N+Ff1AVK1o2Gni3cXtiVSIlFRmQOgpSiqLKfMp5ins9t+XxyhnC6c76/wz/iHg8h64jF8UlVLa1MG7/PwRRUq48z83/Xy5SZ2WIp/7UnB3TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730831922; c=relaxed/simple;
	bh=mckG9hGdbe+Q9VANL/xOmF5U5406CzkpRpgmdDfWEW0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BET+sb+SUGfifYnAxxJfqmw7jVSdxEa1qdgaz13DWnTXTVotj4k73r0ho/qOXvrK1Mqo0exIVzF+DLZVuXv0nMNSVG1cPHVTpIoiGaZUH5QatSTzPnw7iZrEcg1a5gWCuEupVL/nIMqjYWj5W4XsJ+mgBTfVfyn9CUIIqy9dsJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ANET5WWQ; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ANET5WWQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730831921; x=1762367921;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=mckG9hGdbe+Q9VANL/xOmF5U5406CzkpRpgmdDfWEW0=;
  b=ANET5WWQzwO+ic9og7X3sULUf9WZI6752ia6u73AA32RnJynOf9kPcJO
   CBJHOe+tMipZuhvqQdgVEcQCuyj6D8RiRw+sixCrchQ0oK0I62nT3olVi
   O1xmlO4RqzzRhINpq3dBly0CeNEESk5w/TlfxMncf0zE1sz1669iL7abj
   K7eXS4au6gUtHMwOz3YVz1JjAsmJCQwwm3aE7OQWVxfacXfX6lX4BQVg8
   l9qYsUA+Pzdzp9X3X0WLXSRkARGRgBvx2FqYjxkLYn/HRUgGrviYYJjpI
   O/BkpgdOEyKQx/Q5Mwt2y0RqWQcmCKUXE59QJFk3Bx6lrWlkdyoieSRZJ
   w==;
X-CSE-ConnectionGUID: LZLdTbVcTZWXgsgNp8EbyQ==
X-CSE-MsgGUID: IIot6YrhTnOoCuo0/SlhSQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="30708426"
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="30708426"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 10:38:40 -0800
X-CSE-ConnectionGUID: hd1oERv5SGSRhiIt8fuQbw==
X-CSE-MsgGUID: SahEqXiXS4SzigDSYiFbaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="84948755"
Received: from spandruv-mobl4.amr.corp.intel.com (HELO localhost) ([10.125.109.247])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 10:38:40 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Tue, 05 Nov 2024 12:38:27 -0600
Subject: [PATCH v6 05/27] cxl/hdm: Use guard() in cxl_dpa_set_mode()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241105-dcd-type2-upstream-v6-5-85c7fa2140fe@intel.com>
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
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730831904; l=1974;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=mckG9hGdbe+Q9VANL/xOmF5U5406CzkpRpgmdDfWEW0=;
 b=iEpx6htte6MUMKOgWgpjT5d8nXu/u4MeaBLxTn2pkwbXOHoBA3/8b1PhM7mJCG7ZiXosCX0Rw
 yxbFxIbOR6bCBD88r0YB0ZsZADbt0FJxlvuS1HVbF7+l1yEEUxtmBtJ
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

Additional DCD functionality is being added to this call which will be
simplified by the use of guard() with the cxl_dpa_rwsem.

Convert the function to use guard() prior to adding DCD functionality.

Suggested-by: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
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

