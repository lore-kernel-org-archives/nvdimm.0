Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7242DE6FF
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763538815; cv=none; b=MR7G5eNMCH+h0GDr0O16qTuYWYB1pQ9dyIqWhPqF4tHTXLLkwXnOsKn3MGerevosChaJ1SI+DNGSmUl1PPrL8keGb3il5shpGgdAZCUt/qGYmoov7gpY3MdPjHtH4UdBVHwpXlQ5gPW8eiMzlTyWYrhNQ5Ut363QtmEb2+68ZiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763538815; c=relaxed/simple;
	bh=ESls8kczsiy757C1K/kgmyz7R8++FryTKTQjvShztDk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=WyifJXzSNu6XUOFQXi4rTIb1IXKfhyiCE9zDbbM2ovbszeB1Kb83dNG35nv4UG1pGTaxTNzorLS5LRFvVFonE4lwcgJmIUKVtnFl8fp3OptZ6GO3u1qWX5/K/YQKKhvXIbV0Y7m71POp3+5TFBeXyCK9QVp/rKdwPppbogTWvBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=lWNBzxYV; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="lWNBzxYV"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251119075331epoutp0369294f2002fb601a82b81a51d202ca4a~5WTSTnQK52947929479epoutp03n
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251119075331epoutp0369294f2002fb601a82b81a51d202ca4a~5WTSTnQK52947929479epoutp03n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1763538811;
	bh=IlJP9oSMjOblSzq1z4N3+ZlVhBcZJv4QELzYajuAbpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWNBzxYViYjm+2tIJV/of6TYr00mzciDU5/RBDTvA3HHUOQVjmyUZHYhgsDy/8Dls
	 F5ZhlfJt1jw51Q5g9uJIv7g/N/jGOJhvdeV/G6CAe7324KHEG/7Mi/1ooEwH7p+Vqg
	 kczGtye1Z/1p2outH5KBgo4vN19+FnCH9NMcDQNo=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20251119075331epcas5p2818ec9fdfbf39c78bea13810170fc9b9~5WTSDr0Fj0870708707epcas5p2c;
	Wed, 19 Nov 2025 07:53:31 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.92]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dBDHt0XSqz6B9mR; Wed, 19 Nov
	2025 07:53:30 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20251119075329epcas5p2e59df029313007c9adcf3a09ef0185cf~5WTQppWtC1868418684epcas5p2t;
	Wed, 19 Nov 2025 07:53:29 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251119075328epsmtip15b78488122daa96e7f27f1dd016a83c1~5WTPG3_V_2566025660epsmtip1R;
	Wed, 19 Nov 2025 07:53:27 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V4 12/17] cxl/pmem: Preserve region information into nd_set
Date: Wed, 19 Nov 2025 13:22:50 +0530
Message-Id: <20251119075255.2637388-13-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251119075255.2637388-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251119075329epcas5p2e59df029313007c9adcf3a09ef0185cf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075329epcas5p2e59df029313007c9adcf3a09ef0185cf
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075329epcas5p2e59df029313007c9adcf3a09ef0185cf@epcas5p2.samsung.com>

Save region information stored in cxlr to nd_set during
cxl_pmem_region_probe in nd_set. This saved region information is being
stored into LSA, which will be used for cxl region persistence

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

