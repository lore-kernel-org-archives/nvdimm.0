Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F5F3815EF
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769167910; cv=none; b=fRSOmeUwYJTxi2xPbxmWR7eH7quzeHE0ujIRjkBuXtvvOj1Ev5BVRWqBo33LEUCGL5SRPdrvJk2C8+Z3itYJi+oqjWtPkaEoUVARrXWGhEsc6pThDpgccyEiH8RWz8Z8uy2kq7dKjaCx8L1dfyMp+hz94lKPHGmwQdowyCf7Fks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769167910; c=relaxed/simple;
	bh=ACjr2okpiFzwOb4tqPK7mla9DKYQFdfGvBOMtuUJ9s8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=BO+ocEjik6vCQRMe7FTAhshqxVB5mQdshjYqmT+gXrx6wEDIueU9+BYHdIcTsJ9/e19QXECaywYh0clCFBSAa/b+h7Yye3C43ahxbc5++TZKVVUaVxHjYFgT01icsd5cbNnrpkjR9sAeBJx+pZnVu3nmSQqgD3qOwM0tAZ/rQAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=c6AP/Fp5; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="c6AP/Fp5"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260123113145epoutp0490850af13992b5ff6dda8e80545dfa7c~NWNYeuVr90297002970epoutp04g
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260123113145epoutp0490850af13992b5ff6dda8e80545dfa7c~NWNYeuVr90297002970epoutp04g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769167905;
	bh=4SmBPbCv6RQLjMURvQxmA1uVIrUH8weGaJhrbxLOigc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6AP/Fp5JoVzaCRLcr3xzL7nTdy0n9ZZxEAZzrlqtbMDN4P//1ko1HlMuPnkVhOko
	 7FiAS9JRhLD8j4aJlLOgX2yc92QwexeRYwl7om/Gyu6Xrow4qZktCshJwc0fpw4DUX
	 Vg7DUihxLLXDJ4a+u7ZHAGVif70ey4+yY7TS88Pg=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260123113144epcas5p1cb548210263df17c4109796db61e8291~NWNXn_byA0266802668epcas5p1p;
	Fri, 23 Jan 2026 11:31:44 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.86]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dyG3g4rclz6B9m7; Fri, 23 Jan
	2026 11:31:43 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260123113143epcas5p1f056205feaa11092be91be6f74ccc0be~NWNWhUEH72762827628epcas5p1F;
	Fri, 23 Jan 2026 11:31:43 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260123113141epsmtip24c4b7c5badb0981613dfb74aa1bfc660~NWNVO2xE32685626856epsmtip2V;
	Fri, 23 Jan 2026 11:31:41 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V6 13/18] cxl/pmem: Preserve region information into nd_set
Date: Fri, 23 Jan 2026 17:01:07 +0530
Message-Id: <20260123113112.3488381-14-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260123113112.3488381-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260123113143epcas5p1f056205feaa11092be91be6f74ccc0be
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260123113143epcas5p1f056205feaa11092be91be6f74ccc0be
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
	<CGME20260123113143epcas5p1f056205feaa11092be91be6f74ccc0be@epcas5p1.samsung.com>

Save region information stored in cxlr to nd_set during
cxl_pmem_region_probe in nd_set. This saved region information is being
stored into LSA, which will be used for cxl region persistence

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
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

