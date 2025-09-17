Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646BF337E80
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115864; cv=none; b=G5BRZhjYuZKfv79lgvbpXbiuU/qwmFLQj0Te9Vpnx16SDz6AnFYyMGzIGQNQ1RNDJeMgd2c15zOwFTruFyQlla9RRKstPj4GmnJeQYohnYKRLxwRS0eylLmdhWHgoirTU2QkVSy0/xkL21nPtLb0mMmF4ttjD5yf7HvO7XRrbLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115864; c=relaxed/simple;
	bh=bBNRVqm0xNP2bUegYaeeW1aFmcjZpJaGNmJt5fBNr4k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=eD3CDnoU54f00KBGSiVPQ3dLnioIkkhlSRxdsMi2xDt4+rZapMXEvd856W++2T8GcvIs3gL23GKv2X10hXGEwUus87F0noRcZTn9DWMmLLAx/aO0Y2YYInHxUnlkVhxM0/W7IlsKiyEVsNt3Wf30TaddPqz0t4gArcV8iHuuBrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=XtU4Ii6g; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XtU4Ii6g"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250917133100epoutp0205e7f2d632917654a84368b4463bf75e~mFQ9vkM0-0519205192epoutp02i
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:31:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250917133100epoutp0205e7f2d632917654a84368b4463bf75e~mFQ9vkM0-0519205192epoutp02i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758115860;
	bh=47MZ+V0NL7IUSooPzfSTYCMJEyy6bhIfvUpbYlXE654=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XtU4Ii6gEkq3cyherUoMp08oJJU1mSIB8eGsFC01rzVXVTdCPFjHo6qgVYSxU5WGF
	 NQGYDA4G3rpHYM6XD8u4tOw29EPqlCV/ZecOhtFALG+W36lgS6NhzEVkcyU33MJ8uw
	 CDkmpo57HJxZAl2N31TBKF3J0+vtRv1r46pcsgp8=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250917133100epcas5p15b7f82eba259bafd644edd73bfd21166~mFQ9eHgPs0664606646epcas5p1i;
	Wed, 17 Sep 2025 13:31:00 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.92]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cRfmM238jz3hhT3; Wed, 17 Sep
	2025 13:30:59 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250917133058epcas5p33af456c574a095b53001521358bae67a~mFQ7yAc3P3265832658epcas5p31;
	Wed, 17 Sep 2025 13:30:58 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250917133057epsmtip1baab1e8cb410c08fbf3884b7465c5bea~mFQ6ti_NF0528605286epsmtip1v;
	Wed, 17 Sep 2025 13:30:57 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 20/20] cxl/pmem: Add CXL LSA 2.1 support in cxl pmem
Date: Wed, 17 Sep 2025 18:59:40 +0530
Message-Id: <20250917132940.1566437-21-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917132940.1566437-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917133058epcas5p33af456c574a095b53001521358bae67a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917133058epcas5p33af456c574a095b53001521358bae67a
References: <20250917132940.1566437-1-s.neeraj@samsung.com>
	<CGME20250917133058epcas5p33af456c574a095b53001521358bae67a@epcas5p3.samsung.com>

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

