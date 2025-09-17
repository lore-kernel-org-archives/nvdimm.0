Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8215332A52
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115859; cv=none; b=nazV3bw1vVsIBxwyKCOY/ZKBPDy9CXhFfErBIvkojU27JnOBnrJhTermjivVRKWhrw/M7DBDx9omc+moMgcdhPiGRw7qMqKYizT15Ym6pLPADnxbXAlkKvqbYH+fvSK5KP5puqV8BoWk/nqBvk3EJIlb0i4Vsn2u2XTAUROZvDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115859; c=relaxed/simple;
	bh=8QH1l6WhkxI25RXDqtdyvnQAdOa9RFZNwZRhHLcA25w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=cuG/sFZi1Rxezp4IA6x0Tc13n3exRtRtye3B25PeSR+ScOfP7+zXihDJmM/1Sz57vzcWghtCxzdxiqEkgZDKYbv+7t6sdp6Q8CMHQcpCsTnrE6PZkyTqWFloiiAo44yikzbEN0ba79qekkpap8W5Nye8+tYmphQmrYs7K0hpt1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=F6SppoQ6; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="F6SppoQ6"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250917133055epoutp0455c14a77b9f0768fa5db42d4d5e2e7d0~mFQ5Yq8ZE2406724067epoutp04h
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250917133055epoutp0455c14a77b9f0768fa5db42d4d5e2e7d0~mFQ5Yq8ZE2406724067epoutp04h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758115855;
	bh=Lrv2ikBf3O5NwJGep2hXkTk6Ovkh45U+lUMsg7E/HGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F6SppoQ6zqK3agmGzWaKHMVMb9sHSofdrRQCanM/urKsT4lbgLnLzskWgcYPl5NvB
	 /8Y6EXvgOWQkoP35cnWfdATGWb074O6MtUZ78tMZ08BzoYRHxxZ/X0PTbvl0iBmit/
	 JMTm0ErEJXdoxvbh9vbJeYsqt8aVzvE4jlaUBJGE=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250917133055epcas5p12adfdfeaf0d37c59ff3b72b73709b05f~mFQ5IIK430665206652epcas5p1T;
	Wed, 17 Sep 2025 13:30:55 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.86]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cRfmG4p6dz6B9m5; Wed, 17 Sep
	2025 13:30:54 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250917133054epcas5p2cd6ee7551c19bbf3aafcb27172703c59~mFQ32dm9y1088010880epcas5p2n;
	Wed, 17 Sep 2025 13:30:54 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250917133053epsmtip1fcd3c56786f6e2f54706fb9800d5f815~mFQ2zknsR0457804578epsmtip1b;
	Wed, 17 Sep 2025 13:30:53 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 17/20] cxl/pmem: Preserve region information into nd_set
Date: Wed, 17 Sep 2025 18:59:37 +0530
Message-Id: <20250917132940.1566437-18-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917132940.1566437-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917133054epcas5p2cd6ee7551c19bbf3aafcb27172703c59
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917133054epcas5p2cd6ee7551c19bbf3aafcb27172703c59
References: <20250917132940.1566437-1-s.neeraj@samsung.com>
	<CGME20250917133054epcas5p2cd6ee7551c19bbf3aafcb27172703c59@epcas5p2.samsung.com>

Save region information stored in cxlr to nd_set during
cxl_pmem_region_probe in nd_set. This saved region information is being
stored into LSA, which will be used for cxl region persistence

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/pmem.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index e197883690ef..38a5bcdc68ce 100644
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
+	nd_set->nr_targets =  p->nr_targets;
+
 	ndr_desc.nd_set = nd_set;
 
 	cxlr_pmem->nd_region =
-- 
2.34.1

