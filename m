Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C1835EDA4
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962733; cv=none; b=AUAc1toW4VwmlpXuqzkkFdoUOKY7p7j6imQ8i89ySX0PGqcMiZeUXmSuUnzRGcKrlD/dKo56aYAExLCZ9d8jY0qQQVbATE1fgnSZ/umLil8ET8jy8FoU1ZkOOMiJcHTTURItcq5p8UsDSd/WbSM6gRqZ46QWrtSb/HhX836SaIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962733; c=relaxed/simple;
	bh=c1tNPjnzy8cwC5zXLAhFqZAtMoA7a9S6XuLJvj+KHsQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=ifG99jY60ZwWwVRM56HYe1su/6uNT532elTVzniSa055WE/usuuDaTBdXv/sF/d4CwwVWqu34pjxeH4VqLov7sup66e681BcliRzvp/yYM4hBi0kEybkXM7+EfyCL+/mFhXAIzvuAo0FcmM7jExWutz98/6nP6IAnEAXo8fzetM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=mLXff4KK; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mLXff4KK"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260109124529epoutp0448bc7d1158c742bcfd795743818bdc13~JELw8wQcU0570905709epoutp04P
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260109124529epoutp0448bc7d1158c742bcfd795743818bdc13~JELw8wQcU0570905709epoutp04P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767962729;
	bh=UPmNW62pq6lNkIZnJ4v0XRR9hHjaYlJjfZ+/jEJsjTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mLXff4KKlkPHKFo/kZYDVesTjoyDEYwrutDijMMP27zlfXXUMqcqGNHuTFPCfld99
	 bPCrZ2EN7RASIqTO5FhCm+RkvCivEDzgnVO9Rq76ksTmkhVY2sbr3hQIgJaVsfj8yQ
	 necUww76G/yq7nPjZhCbIt3dtuREBY9/6shD19Wo=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260109124528epcas5p25dc032c0ba5485ef17185187e4c2613f~JELwku-ro3051830518epcas5p2I;
	Fri,  9 Jan 2026 12:45:28 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.91]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dnhMD210Nz6B9m4; Fri,  9 Jan
	2026 12:45:28 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260109124527epcas5p1bd7390304b8b6c99a75b0cf4e74b6c12~JELu_Dt4U3073830738epcas5p1T;
	Fri,  9 Jan 2026 12:45:27 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260109124525epsmtip128477fa5873395ef0651927b773b17c1~JELtsxLpm0978109781epsmtip1V;
	Fri,  9 Jan 2026 12:45:25 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V5 12/17] cxl/pmem: Preserve region information into nd_set
Date: Fri,  9 Jan 2026 18:14:32 +0530
Message-Id: <20260109124437.4025893-13-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260109124437.4025893-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260109124527epcas5p1bd7390304b8b6c99a75b0cf4e74b6c12
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260109124527epcas5p1bd7390304b8b6c99a75b0cf4e74b6c12
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124527epcas5p1bd7390304b8b6c99a75b0cf4e74b6c12@epcas5p1.samsung.com>

Save region information stored in cxlr to nd_set during
cxl_pmem_region_probe in nd_set. This saved region information is being
stored into LSA, which will be used for cxl region persistence

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/pmem.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index e197883690ef..a6eba3572090 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -377,6 +377,7 @@ static int cxl_pmem_region_probe(struct device *dev)
 	struct nd_mapping_desc mappings[CXL_DECODER_MAX_INTERLEAVE];
 	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
 	struct cxl_region *cxlr = cxlr_pmem->cxlr;
+	struct cxl_region_params *p = &cxlr->params;
 	struct cxl_nvdimm_bridge *cxl_nvb = cxlr->cxl_nvb;
 	struct cxl_pmem_region_info *info = NULL;
 	struct nd_interleave_set *nd_set;
@@ -465,12 +466,12 @@ static int cxl_pmem_region_probe(struct device *dev)
 	ndr_desc.num_mappings = cxlr_pmem->nr_mappings;
 	ndr_desc.mapping = mappings;
 
-	/*
-	 * TODO enable CXL labels which skip the need for 'interleave-set cookie'
-	 */
-	nd_set->cookie1 =
-		nd_fletcher64(info, sizeof(*info) * cxlr_pmem->nr_mappings, 0);
-	nd_set->cookie2 = nd_set->cookie1;
+	nd_set->uuid = p->uuid;
+	nd_set->interleave_ways = p->interleave_ways;
+	nd_set->interleave_granularity = p->interleave_granularity;
+	nd_set->res = p->res;
+	nd_set->nr_targets = p->nr_targets;
+
 	ndr_desc.nd_set = nd_set;
 
 	cxlr_pmem->nd_region =
-- 
2.34.1

