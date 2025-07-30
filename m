Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D62229E10C
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753877855; cv=none; b=LCUiWDRTzYlHVAsXjTP1zLT551/oizPGATa6SWTwTiQeVDYEMTy09F645LOP11bshoP4+as4twaIKSv98z3fnbu8ZVaxytfDSXdW28PWqTMDvf6y4unpA4Hp0NGLKpJOmPSDMdf8Bo0iqJeUvyoDxsLNgJ6QzN2GkyMK4ni0wL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753877855; c=relaxed/simple;
	bh=8QH1l6WhkxI25RXDqtdyvnQAdOa9RFZNwZRhHLcA25w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Oya3iedq8e7+to4Tzg6f9avf5woWNy4VC7in/XjeM28TcyMZtkD0F5ubu416+urDUw2Bh812PgwPp0Q0TnX8RwNShTVijfRMiBF4SXYKDXoad1feZedVH3TSZl1JCrrfcEH2BiyCPBhjFmBh4abWy5hWL4HCviedw9YgiVbzNTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bRr9xTR7; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bRr9xTR7"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250730121731epoutp030972a985439ee93c96cb8b5a8d00aaa3~XBp0Sbr9V3086730867epoutp03c
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:17:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250730121731epoutp030972a985439ee93c96cb8b5a8d00aaa3~XBp0Sbr9V3086730867epoutp03c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753877851;
	bh=Lrv2ikBf3O5NwJGep2hXkTk6Ovkh45U+lUMsg7E/HGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bRr9xTR7qelx+n4LxKrchhFwJ3xIKKtbB64AKjY4gA0Qjpqt3kQAnp7zcb2HZPni7
	 xzXKoEUhTYwYFo+tEQ2mqfhG4MeexSQmRoiHR6qdqZkIilFLSZX8x/JThrHz7p9qdy
	 t4NVu+t/r+7WgJ9lgCoFVfetq6gLz0FXWBVCVDq4=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250730121731epcas5p39f30ca6d1fa55a3224409a0fe355505e~XBpz2kEGk3063230632epcas5p3n;
	Wed, 30 Jul 2025 12:17:31 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.91]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4bsWSB1MtCz6B9m5; Wed, 30 Jul
	2025 12:17:30 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250730121245epcas5p247b6675350f4f7e70e9b3c8465340e84~XBlpgDSSn0097600976epcas5p2e;
	Wed, 30 Jul 2025 12:12:45 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250730121243epsmtip10e9407f2877d1987b16f9f76abb0061f~XBlodhg7h0426504265epsmtip1B;
	Wed, 30 Jul 2025 12:12:43 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V2 17/20] cxl/pmem: Preserve region information into nd_set
Date: Wed, 30 Jul 2025 17:42:06 +0530
Message-Id: <20250730121209.303202-18-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250730121209.303202-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250730121245epcas5p247b6675350f4f7e70e9b3c8465340e84
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121245epcas5p247b6675350f4f7e70e9b3c8465340e84
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121245epcas5p247b6675350f4f7e70e9b3c8465340e84@epcas5p2.samsung.com>

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

