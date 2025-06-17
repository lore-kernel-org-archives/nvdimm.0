Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAF5199947
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750165385; cv=none; b=KQ4IFbRVrhi9FNv6YMai35HkIySs4aQv7emTGD73pj1n6luGv6SXl4kAlf7YyDWR7X39U8jZfNa3GrDo7CZyVJR5H1Ej6YW5pP3kkiYd0FOrdw0ZkkBIT0ZCz1fVFI99AgV/tveTOyO4GALxVAu82g60md0653dxDtrz/jojIo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750165385; c=relaxed/simple;
	bh=QlXSwNKK08xmJmbJKsSJdjUq1otE++eQi2O18jgIVVc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=O4Tpsy538rlmjIGfcB4o3trAVT1gUuGAbDmwxF9DIdwzBNunYQNRDGbP9iBCc5G5HVQvmH2oilUIRNOA6vMSWwJVbJUboA8dTl+cBkM+XpsUg4845PrJXrs7A22SkkCSOYOBJoY9RfkQi5NaFV9dq9x3GhhpykJs9u6bpiCppos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=kwOm1azn; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="kwOm1azn"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250617130302epoutp044b2e316f1078761d5b4be0cc5c641248~J1iR9_BTM2639726397epoutp04W
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:03:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250617130302epoutp044b2e316f1078761d5b4be0cc5c641248~J1iR9_BTM2639726397epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750165382;
	bh=AUkScCfP+dPARUHxdCDWVovECz1k/Y3SmiSq/nmHrz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kwOm1aznuWuuoUx312HOBUeF9uBuytBZGFN8KF8PZFdVagTQjnSgNoRVvu8ofbDB4
	 vRYS0MkN14TuRBRf7elyg18DnbmCtt/TvFEHkjFyPooNvUVPMmPkOoz3/N1d4nQzni
	 Ny9E1rUNf8AT4kvL48/MjY9bFAiPQ790AkONK/6c=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250617130301epcas5p1c19d3a1ccf2ebc19a1e3c9aae64b04fc~J1iRWfUWR2026620266epcas5p1r;
	Tue, 17 Jun 2025 13:03:01 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4bM6VY59J5z6B9mB; Tue, 17 Jun
	2025 13:03:01 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124052epcas5p24aace8321ed09af8bdd1e8c30c20cd84~J1O7O-EtA0675106751epcas5p27;
	Tue, 17 Jun 2025 12:40:52 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124049epsmtip2a2768a01124f4f18381a9da429110c7c~J1O4vZIJO2488624886epsmtip2Z;
	Tue, 17 Jun 2025 12:40:49 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, s.neeraj@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: [RFC PATCH 16/20] cxl/mem: Preserve cxl root decoder during mem
 probe
Date: Tue, 17 Jun 2025 18:09:40 +0530
Message-Id: <1891546521.01750165381712.JavaMail.epsvc@epcpadp2new>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250617123944.78345-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250617124052epcas5p24aace8321ed09af8bdd1e8c30c20cd84
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124052epcas5p24aace8321ed09af8bdd1e8c30c20cd84
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124052epcas5p24aace8321ed09af8bdd1e8c30c20cd84@epcas5p2.samsung.com>

Saved root decoder info is required for cxl region persistency

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/cxlmem.h | 1 +
 drivers/cxl/mem.c    | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 2a25d1957ddb..a14e82d4c9aa 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -54,6 +54,7 @@ struct cxl_memdev {
 	struct cxl_nvdimm_bridge *cxl_nvb;
 	struct cxl_nvdimm *cxl_nvd;
 	struct cxl_port *endpoint;
+	struct cxl_root_decoder *cxlrd;
 	int id;
 	int depth;
 };
diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index aaea4eb178ef..c2e5d0e6b96b 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -152,6 +152,8 @@ static int cxl_mem_probe(struct device *dev)
 		return -ENXIO;
 	}
 
+	cxlmd->cxlrd = cxl_find_root_decoder(parent_port);
+
 	if (dport->rch)
 		endpoint_parent = parent_port->uport_dev;
 	else
-- 
2.34.1


