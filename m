Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0147434DCF3
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116531; cv=none; b=fL2YzVyxcp9IXJcwZtHsDk+DBd8VtJs//pEgKjlxNabmL5TD4QIvYtBebiyDvk7cjP9vj6Aw4nfrYCwUeSsSsdLArSyHX8zbQETDXnzhfS5j2pw9LukmOniB3B4sn6e8AwZfNGWMlv5LuyLhVE3jxdWXOBiuryUt6FfwM4MYF/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116531; c=relaxed/simple;
	bh=8QH1l6WhkxI25RXDqtdyvnQAdOa9RFZNwZRhHLcA25w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=ecUJsErsacJF1gD+l4UZSkqOHIsrllKFUjbFoDuYJjFCY6f7vZHdC4+U2NlSTn+ROR0m+XnrVk9oN0sodbRx8Xzh5n1gCGakvdkewAfZbpM2IbO/kL3DSs4GJdLq8gKVmrsGA64x+L0wONZCUST7zK2HxDy8qYqlFG67yAmOAYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bQG+sR/9; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bQG+sR/9"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250917134208epoutp02d7baee952164ac565e3ff30454893b83~mFarq83R71575415754epoutp02O
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:42:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250917134208epoutp02d7baee952164ac565e3ff30454893b83~mFarq83R71575415754epoutp02O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758116528;
	bh=Lrv2ikBf3O5NwJGep2hXkTk6Ovkh45U+lUMsg7E/HGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bQG+sR/9ClRpTq9IGaBEdH4eW56kzxqVeSvkd4QLAhK5fPb05Cn3scKKH+LgKCqWH
	 M/ICJxlOu2VQWmTtrzGfYHZwvLbLbZk4Gd98glQcHR4+o8jczNS5myVMlNsyVzQ6Yz
	 u25zIXRqwb7HPm4sRsu6+iQFbtcQtjIqPCNUik5E=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250917134208epcas5p29ad13559962480c1a5dce18ddb43a182~mFarYiSeu1139711397epcas5p2s;
	Wed, 17 Sep 2025 13:42:08 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.88]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cRg1C0Yn7z3hhT7; Wed, 17 Sep
	2025 13:42:07 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250917134206epcas5p346640447ba36a00e33ec98c4d35f063b~mFap8lNWO2768527685epcas5p3k;
	Wed, 17 Sep 2025 13:42:06 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250917134204epsmtip20246a2e57d4cd53b18015193f6fc4e7a~mFaoAf7b20967109671epsmtip2e;
	Wed, 17 Sep 2025 13:42:04 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com, Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 17/20] cxl/pmem: Preserve region information into nd_set
Date: Wed, 17 Sep 2025 19:11:13 +0530
Message-Id: <20250917134116.1623730-18-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917134116.1623730-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917134206epcas5p346640447ba36a00e33ec98c4d35f063b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917134206epcas5p346640447ba36a00e33ec98c4d35f063b
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134206epcas5p346640447ba36a00e33ec98c4d35f063b@epcas5p3.samsung.com>

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

