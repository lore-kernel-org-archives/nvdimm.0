Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9F22E92B2
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750165387; cv=none; b=QMNupNUwhDHCA0RHdpO491wtrc4zuFHHdve3i9epnM4L1hwdmpZgozuJVjyg6KgFMSI0O8Ujb/40CcZwiragwnAOQsZeokA2xK4mS4xm+1OzJAY/sf42b+VjxEtiVi8qmbLfZ/h9VJQ83A2/Tem7qCD52aZR51aSSBNOfB5TJV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750165387; c=relaxed/simple;
	bh=IJ2BGsq5yFYOXnRVvmbfvQkQ1RhwJtdF2mw0jLyfseU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=HLztK7zJL2RKGxqapFW/c7ISEd0daw1OHoi+hKHMHH1NSxAWwXVg/1um+BCTdWwV/rP9EiZLHOZLQlwwJ+JEy9Wad5P4IdsIZ5BNYdt8fSwPPPzlVpWLzosg7BVTIjwCMlpQ7oIuOYcb8T1xny86gwLbUaFZd2pedbIsU7HXx9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=r9M+huVM; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="r9M+huVM"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250617130303epoutp04073f3a25a97ee0e93a988a40af04a8f0~J1iS3hhQ92709227092epoutp04C
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:03:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250617130303epoutp04073f3a25a97ee0e93a988a40af04a8f0~J1iS3hhQ92709227092epoutp04C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750165383;
	bh=uK2NdU+m2E8iJyLxKvykmCqaOSyrYJ8SD6NKcrnVOwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9M+huVM7J5Ntyl2IKsiwmUs5zHSxDY/wxTky+maA1G5sLMqpRrCaMfPz8Frv1tfZ
	 cSyQeNLd0YzQYF5JtdbR/WESg9DO4jwVq3PGYREHXXx0H2upB35IxRkEO5nChEIQ/W
	 Dcc6sU1jMc0aPNnQLkyKCdkFpx0PWQWyUDBanqIo=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250617130302epcas5p10a2ed38d22f5a05fdec97a8940173f1e~J1iR3CSmH2236322363epcas5p1x;
	Tue, 17 Jun 2025 13:03:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4bM6VZ1zs2z6B9m6; Tue, 17 Jun
	2025 13:03:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250617124055epcas5p4978a3c139128bf5873c60ca0a10f5199~J1O_OAVZL0803508035epcas5p4J;
	Tue, 17 Jun 2025 12:40:55 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124052epsmtip2386dad618f1e9b576b69bc4f26e03508~J1O7em-Mj2558225582epsmtip2J;
	Tue, 17 Jun 2025 12:40:52 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, s.neeraj@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: [RFC PATCH 17/20] cxl/pmem: Preserve region information into nd_set
Date: Tue, 17 Jun 2025 18:09:41 +0530
Message-Id: <1147258851.41750165382275.JavaMail.epsvc@epcpadp2new>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250617123944.78345-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250617124055epcas5p4978a3c139128bf5873c60ca0a10f5199
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124055epcas5p4978a3c139128bf5873c60ca0a10f5199
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124055epcas5p4978a3c139128bf5873c60ca0a10f5199@epcas5p4.samsung.com>

Save region information stored in cxlr to nd_set during
cxl_pmem_region_probe in nd_set. This saved region information is being
stored into LSA, which will be used for cxl region persistence

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/pmem.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index f9c95996e937..ffcebb8d382f 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -308,6 +308,7 @@ static int cxl_pmem_region_probe(struct device *dev)
 	struct nd_mapping_desc mappings[CXL_DECODER_MAX_INTERLEAVE];
 	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
 	struct cxl_region *cxlr = cxlr_pmem->cxlr;
+	struct cxl_region_params *p = &cxlr->params;
 	struct cxl_nvdimm_bridge *cxl_nvb = cxlr->cxl_nvb;
 	struct cxl_pmem_region_info *info = NULL;
 	struct nd_interleave_set *nd_set;
@@ -388,12 +389,12 @@ static int cxl_pmem_region_probe(struct device *dev)
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


