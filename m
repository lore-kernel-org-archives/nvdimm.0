Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E24E3705B7
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116538; cv=none; b=Cs4Ho5WGTzeFIohPfmSXeCaokCDGDJeMlu+g7TDE5RODb0NiotdtOh7MdHjAgeliR1zBQLgX+DP0hZctxdDcV5SoroJcotkPeKrOwLdv2whCiHP3bWEsSN6Cm2AlcaWcLDWndhYGtE3ArNeDzCDXMpWz4Q1gOyVlMl0jOYbcYxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116538; c=relaxed/simple;
	bh=bBNRVqm0xNP2bUegYaeeW1aFmcjZpJaGNmJt5fBNr4k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=a6giaSCS0znmHAQWtz0tbVQl+vcJjcR3Cm/FgOkMcYIrmZo+hMDVxiW2sCllKEZNsg2TkGfhV/GKh55nzFlwjQjFuXw5YJo/qrTfWW2BTJzXKwREtEcuBzdbJfDsrazkrG7sE9uPcTjblpR1osfQPT2c5QI8vz5YS4lpM4eufdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=NjJfTOyw; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NjJfTOyw"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250917134215epoutp0492e6d9b93d7f073809db18523636b6c3~mFayJcLVz0417704177epoutp04B
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:42:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250917134215epoutp0492e6d9b93d7f073809db18523636b6c3~mFayJcLVz0417704177epoutp04B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758116535;
	bh=47MZ+V0NL7IUSooPzfSTYCMJEyy6bhIfvUpbYlXE654=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NjJfTOywhvVtgdV3eRZnWqlx3a+J3GUZGZI+F9sUu/ahIk/LcRVbQFzX4yXtGa/Qy
	 E2l2xa6ooK9aUyQ2iec4JkHb6bta5sTUfdfous+i4DY8L3fZehX6FLsYl4dttOEQRe
	 bxEqPUR2KRXcn7kmwxjtMgrk6FruWS30Ne3Z0JZs=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250917134214epcas5p102f95878dcffde6551eff24b69ddeb95~mFaxy6AHd1744017440epcas5p16;
	Wed, 17 Sep 2025 13:42:14 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.89]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cRg1K75dHz6B9m6; Wed, 17 Sep
	2025 13:42:13 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250917134213epcas5p139ba10deb2f4361f9bbab8e8490c4720~mFawftC-y3219032190epcas5p1o;
	Wed, 17 Sep 2025 13:42:13 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250917134211epsmtip219794a6baeaefdd01da7969c3905321b~mFautZlRJ0952109521epsmtip2F;
	Wed, 17 Sep 2025 13:42:11 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com, Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 20/20] cxl/pmem: Add CXL LSA 2.1 support in cxl pmem
Date: Wed, 17 Sep 2025 19:11:16 +0530
Message-Id: <20250917134116.1623730-21-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917134116.1623730-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917134213epcas5p139ba10deb2f4361f9bbab8e8490c4720
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917134213epcas5p139ba10deb2f4361f9bbab8e8490c4720
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134213epcas5p139ba10deb2f4361f9bbab8e8490c4720@epcas5p1.samsung.com>

Add support of CXL LSA 2.1 using NDD_REGION_LABELING flag. It creates
cxl region based on region information parsed from LSA.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/core/pmem_region.c | 53 ++++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h              |  4 +++
 drivers/cxl/pmem.c             |  2 ++
 3 files changed, 59 insertions(+)

diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
index 665b603c907b..3ef9c7d15041 100644
--- a/drivers/cxl/core/pmem_region.c
+++ b/drivers/cxl/core/pmem_region.c
@@ -290,3 +290,56 @@ int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
 	return rc;
 }
 EXPORT_SYMBOL_NS_GPL(devm_cxl_add_pmem_region, "CXL");
+
+static int match_free_ep_decoder(struct device *dev, const void *data)
+{
+	struct cxl_decoder *cxld = to_cxl_decoder(dev);
+
+	return !cxld->region;
+}
+
+static struct cxl_decoder *cxl_find_free_ep_decoder(struct cxl_port *port)
+{
+	struct device *dev;
+
+	dev = device_find_child(&port->dev, NULL, match_free_ep_decoder);
+	if (!dev)
+		return NULL;
+
+	/* Release device ref taken via device_find_child() */
+	put_device(dev);
+	return to_cxl_decoder(dev);
+}
+
+void create_pmem_region(struct nvdimm *nvdimm)
+{
+	struct cxl_nvdimm *cxl_nvd;
+	struct cxl_memdev *cxlmd;
+	struct cxl_pmem_region_params *params;
+	struct cxl_root_decoder *cxlrd;
+	struct cxl_decoder *cxld;
+	struct cxl_region *cxlr;
+
+	if (!nvdimm_has_cxl_region(nvdimm))
+		return;
+
+	lockdep_assert_held(&cxl_rwsem.region);
+	cxl_nvd = nvdimm_provider_data(nvdimm);
+	params = nvdimm_get_cxl_region_param(nvdimm);
+	cxlmd = cxl_nvd->cxlmd;
+	cxlrd = cxlmd->cxlrd;
+
+	 /* TODO: Region creation support only for interleave way == 1 */
+	if (!(params->nlabel == 1))
+		dev_info(&cxlmd->dev,
+			 "Region Creation is not supported with iw > 1\n");
+	else {
+		cxld = cxl_find_free_ep_decoder(cxlmd->endpoint);
+		cxlr = cxl_create_region(cxlrd, CXL_PARTMODE_PMEM,
+					 atomic_read(&cxlrd->region_id),
+					 params, cxld);
+		if (IS_ERR(cxlr))
+			dev_info(&cxlmd->dev, "Region Creation failed\n");
+	}
+}
+EXPORT_SYMBOL_NS_GPL(create_pmem_region, "CXL");
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index f01f8c942fdf..0a87ea79742a 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -910,6 +910,7 @@ cxl_create_region(struct cxl_root_decoder *cxlrd,
 bool is_cxl_pmem_region(struct device *dev);
 struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
 int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
+void create_pmem_region(struct nvdimm *nvdimm);
 #else
 static inline bool is_cxl_pmem_region(struct device *dev)
 {
@@ -923,6 +924,9 @@ static inline int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
 {
 	return 0;
 }
+static inline void create_pmem_region(struct nvdimm *nvdimm)
+{
+}
 #endif
 
 void cxl_endpoint_parse_cdat(struct cxl_port *port);
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 38a5bcdc68ce..0cdef01dbc68 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -135,6 +135,7 @@ static int cxl_nvdimm_probe(struct device *dev)
 		return rc;
 
 	set_bit(NDD_LABELING, &flags);
+	set_bit(NDD_REGION_LABELING, &flags);
 	set_bit(NDD_REGISTER_SYNC, &flags);
 	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
 	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
@@ -155,6 +156,7 @@ static int cxl_nvdimm_probe(struct device *dev)
 		return -ENOMEM;
 
 	dev_set_drvdata(dev, nvdimm);
+	create_pmem_region(nvdimm);
 	return devm_add_action_or_reset(dev, unregister_nvdimm, nvdimm);
 }
 
-- 
2.34.1

