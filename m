Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D394033B48D
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116529; cv=none; b=bS0OVF+di93wRszYnV+zLQorpkv0ug30qcn849TSfW51dqUgR+GH+nbYOMB392/Ac5KX3clDY5T/Sl7bcIjHSor6GX5ZydEXPnj4pUm/xTWN/dYS0n0yqBbbWy9zDAq2H3VSKHmY9PrdMHr0tjGgPFED6NNrd00WP9spdGS7X8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116529; c=relaxed/simple;
	bh=KFoRj9mZvTUE6PPXaSVUQhJJ9OCKEsjumD8QM6HYavM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=LJMKpfOGcYHlOo3G+NmOlpZMXbme8fRIyUj+WRmMYlYG/+UmImP66kemBMGw6XbwkCAihC3ty9mVVyTJu+l/Jat9vYoDRB7w6fTlgeGn/pRBuokfLU+ZC1HLsSY7AghOfiBrfy3/vYAHynJ+ccx2ij9ApeKuf6TKl+6k3qdZ0Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=RcZfuKjJ; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RcZfuKjJ"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250917134206epoutp027a0ca3a11985d7abd10c6589ba0f7b2b~mFapn00UQ1575415754epoutp02N
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:42:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250917134206epoutp027a0ca3a11985d7abd10c6589ba0f7b2b~mFapn00UQ1575415754epoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758116526;
	bh=ruMW/DmvKo1W3pEP4KsORZ6lIfMB2xwID5AWAJCvEL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RcZfuKjJm4RBuGQ6J7sXvTW2S4akw7wQqEGGD4os2lCOqfoszZzBd/EVie0M99tQZ
	 MpwBKBqxxD8put3nD3Jia4GXti38/5gLvJIczRO3ddfwHMAthLBfZJYu9hhAKGmrG3
	 7MVvO9AU5XmPmOMz0mmwGt3G7RXNSb2o2Om8SURw=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250917134205epcas5p25b79e0aa6a59b88e4543f5ab86f85bcd~mFapKanKK0928509285epcas5p2q;
	Wed, 17 Sep 2025 13:42:05 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.90]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cRg184rsSz6B9m6; Wed, 17 Sep
	2025 13:42:04 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250917134203epcas5p3819aee1deecdeaed95bd92d19d3b1910~mFanhE-OD2659126591epcas5p3i;
	Wed, 17 Sep 2025 13:42:03 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250917134202epsmtip282c537362371aad97c61d5f3447d005f~mFamSz2Aa0911709117epsmtip2W;
	Wed, 17 Sep 2025 13:42:02 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com, Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 16/20] cxl/mem: Preserve cxl root decoder during mem
 probe
Date: Wed, 17 Sep 2025 19:11:12 +0530
Message-Id: <20250917134116.1623730-17-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917134116.1623730-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917134203epcas5p3819aee1deecdeaed95bd92d19d3b1910
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917134203epcas5p3819aee1deecdeaed95bd92d19d3b1910
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134203epcas5p3819aee1deecdeaed95bd92d19d3b1910@epcas5p3.samsung.com>

Saved root decoder info is required for cxl region persistency

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/cxlmem.h | 1 +
 drivers/cxl/mem.c    | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 434031a0c1f7..25cb115b72bd 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -59,6 +59,7 @@ struct cxl_memdev {
 	struct cxl_nvdimm_bridge *cxl_nvb;
 	struct cxl_nvdimm *cxl_nvd;
 	struct cxl_port *endpoint;
+	struct cxl_root_decoder *cxlrd;
 	int id;
 	int depth;
 	u8 scrub_cycle;
diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index 54501616ff09..1a0da7253a24 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -152,6 +152,8 @@ static int cxl_mem_probe(struct device *dev)
 		return -ENXIO;
 	}
 
+	cxlmd->cxlrd = cxl_find_root_decoder_by_port(parent_port);
+
 	if (dport->rch)
 		endpoint_parent = parent_port->uport_dev;
 	else
-- 
2.34.1

