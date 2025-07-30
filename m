Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F326F299AB4
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753877860; cv=none; b=TAl3LsL+mnRzaf6HsGr7PTfNdfLcL7zkga7oAZM9FXUHuIyYI1jLM+QVzV7PAS7wVJ46MokKogBt6/rMLjZ1/RbQdhLKR6hKvHdrzW1fMenzxuEY6Cctjzryq2fsM/ZWN6wccb970Dc8vdueW1eBvo2DsBLvAd8fsffJ1gToCu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753877860; c=relaxed/simple;
	bh=n7S6173Wvg43YW3/hHyq/OikFOv+kxBGMnHlC7Hrf3Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=VWb0Gta0tWBEqbmjPqnEtC+RKXlILXX4p7bZfon/le+bnesaAyXP1z5m1XzRxx6lHYUezFHV4jJeP9ISDuDJc0BSnem5q8Jae+KjaXnHUuZpAUTSW1tm+YoypYteb6C7Essar+usPUJlomfOWPdci40SrP2k5Nh63gpKTLIOUgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=rtx2PvJG; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="rtx2PvJG"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250730121737epoutp024992a172eb9abb8865404a7a68004a2f~XBp5qcerv1800418004epoutp02s
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:17:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250730121737epoutp024992a172eb9abb8865404a7a68004a2f~XBp5qcerv1800418004epoutp02s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753877857;
	bh=GNSs4IpmCu7DuWpkli827LdaUNvrTv3KC5ruj10zYv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rtx2PvJGWhMG8+9V9HvA4ZEIErkbw5BsSji2ujwZW5BssPJig75AbzVFS9lnn8iEt
	 rqWbQEHrqxZFIjGmIO1DGDxUX5Jfk9BBFDCjHfg2xyReos2X/MyypA7rpWBH6kVqAe
	 3kh+3mcaRxDSNxd1zQ94w9zV4c8zxr47OllS2q7E=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250730121737epcas5p1b8fc3a8afa358470415afbd6e167e5db~XBp5XYWsH1762917629epcas5p1O;
	Wed, 30 Jul 2025 12:17:37 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.89]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4bsWSJ03KDz2SSKY; Wed, 30 Jul
	2025 12:17:36 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250730121246epcas5p48a2fd8e653f05a0282cbffc1f702f26f~XBlqxaWiO0910709107epcas5p4j;
	Wed, 30 Jul 2025 12:12:46 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250730121245epsmtip14f19240cbd39db281060e427fa204d36~XBlpuwWOi0450704507epsmtip1U;
	Wed, 30 Jul 2025 12:12:45 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V2 18/20] cxl/pmem: Add support of cxl lsa 2.1 support in
 cxl pmem
Date: Wed, 30 Jul 2025 17:42:07 +0530
Message-Id: <20250730121209.303202-19-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250730121209.303202-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250730121246epcas5p48a2fd8e653f05a0282cbffc1f702f26f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121246epcas5p48a2fd8e653f05a0282cbffc1f702f26f
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121246epcas5p48a2fd8e653f05a0282cbffc1f702f26f@epcas5p4.samsung.com>

Add support of cxl lsa 2.1 using NDD_CXL_LABEL flag. It also creates cxl
region based on region information parsed from LSA.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/core/region.c | 58 +++++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h         |  4 +++
 drivers/cxl/pmem.c        |  2 ++
 3 files changed, 64 insertions(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 8578e046aa78..19ccdd136da0 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2665,6 +2665,64 @@ static ssize_t create_ram_region_show(struct device *dev,
 	return __create_region_show(to_cxl_root_decoder(dev), buf);
 }
 
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
+	struct cxl_nvdimm_bridge *cxl_nvb;
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
+	cxl_nvb = cxlmd->cxl_nvb;
+	cxlrd = cxlmd->cxlrd;
+
+	/*
+	 * FIXME: Limitation: Region creation support only for
+	 * interleave way == 1
+	 */
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
+
 struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
 				     enum cxl_partition_mode mode, int id,
 				     struct cxl_pmem_region_params *params,
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index e249372b642d..51c56069f451 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -870,6 +870,7 @@ struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
 				     enum cxl_partition_mode mode, int id,
 				     struct cxl_pmem_region_params *params,
 				     struct cxl_decoder *cxld);
+void create_pmem_region(struct nvdimm *nvdimm);
 #else
 static inline bool is_cxl_pmem_region(struct device *dev)
 {
@@ -903,6 +904,9 @@ cxl_create_region(struct cxl_root_decoder *cxlrd,
 {
 	return NULL;
 }
+static inline void create_pmem_region(struct nvdimm *nvdimm)
+{
+}
 #endif
 
 void cxl_endpoint_parse_cdat(struct cxl_port *port);
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 38a5bcdc68ce..4a7428a5a82c 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -135,6 +135,7 @@ static int cxl_nvdimm_probe(struct device *dev)
 		return rc;
 
 	set_bit(NDD_LABELING, &flags);
+	set_bit(NDD_CXL_LABEL, &flags);
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

