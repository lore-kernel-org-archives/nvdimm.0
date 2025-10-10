Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED410285C8B
	for <nvdimm@lists.linux.dev>; Fri, 10 Oct 2025 11:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760097082; cv=none; b=hmmooLsl0ZnKhNEOPDGCezHEMEEF2w5ntoU/y3dbTq9HtE6Xg/4Py1mmn+ttevhKMyGgIsspFJ4DZkfhmSJBtZVJzWSnZSvJapxLCOvM+zIKdZE8ucWOMiGlGdnQ/9wAqVK+ZdiM0vP3JSCfPaC2sRKUpwUwCewUgBq0Qnx86Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760097082; c=relaxed/simple;
	bh=Z39dAPdW4rbVZy7MJTFNaU6wYq7IX8AjW69XJdzUlYI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=llLMd2sCSd4px8VpstgDOWX1jD8XhVeMpkMG0XZUQyZCQOiIM52bjlxNpzMh1Z0gn8K/R0T9D/TRkjHyCcOQ9aLcIdA8VYv8mXPGIfsH/ICYpjIdlDWJCeu+gaNw/yRAPAMRp3dbFg1r2604zFE8Ym9DZC3PqLJ6cgbgYcJBKVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=CHAzt0RN; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CHAzt0RN"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20251010115116epoutp0201ae042d4850affb0199a58bc4255aba~tHvdC4dnr1115511155epoutp02c
	for <nvdimm@lists.linux.dev>; Fri, 10 Oct 2025 11:51:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20251010115116epoutp0201ae042d4850affb0199a58bc4255aba~tHvdC4dnr1115511155epoutp02c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760097076;
	bh=HrMj0CRzEtpxo80hcTrDDLBMR6R/NkcRQy4gn+i9Nsg=;
	h=From:To:Cc:Subject:Date:References:From;
	b=CHAzt0RNGa/s73rEkYauAdgwNFpQ3wvGjEnJXe9wpr1ZVwKUuupyQqsz+9tyOkMw4
	 NfwnbTJ5icyzZdvpkBnDHfYnfMx8A45XpVThI7J3kM29k7ATRa4hBpB1W87t72SSAz
	 CGmeqJkUy+4f9ebVkJNeFgBXITRiusb4OMBmE2aY=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20251010115116epcas5p422983637fcffe114a51f6e0bee1cabc7~tHvctAwim1849518495epcas5p4J;
	Fri, 10 Oct 2025 11:51:16 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.92]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4cjlSg4Jr9z6B9m6; Fri, 10 Oct
	2025 11:51:15 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20251010115115epcas5p38e28cf5f049b021abaf0b56ffff89788~tHvbm5ldI1456214562epcas5p3U;
	Fri, 10 Oct 2025 11:51:15 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20251010115111epsmtip2e221883439db73e27df6eef0cc7e73ba~tHvYCaFb30528905289epsmtip2M;
	Fri, 10 Oct 2025 11:51:10 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: nvdimm@lists.linux.dev, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH] nvdimm/label: Modify nd_label_base() signature
Date: Fri, 10 Oct 2025 17:19:38 +0530
Message-Id: <20251010114938.3683830-1-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251010115115epcas5p38e28cf5f049b021abaf0b56ffff89788
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251010115115epcas5p38e28cf5f049b021abaf0b56ffff89788
References: <CGME20251010115115epcas5p38e28cf5f049b021abaf0b56ffff89788@epcas5p3.samsung.com>

nd_label_base() was being used after typecasting with 'unsigned long'. Thus
modified nd_label_base() to return 'unsigned long' instead of 'struct
nd_namespace_label *'

Link: https://lore.kernel.org/linux-cxl/aNRccteuoHH0oPw4@aschofie-mobl2.lan/
Suggested-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Acked-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 04f4a049599a..bf5aeee97bb8 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -271,11 +271,11 @@ static void nd_label_copy(struct nvdimm_drvdata *ndd,
 	memcpy(dst, src, sizeof_namespace_index(ndd));
 }
 
-static struct nd_namespace_label *nd_label_base(struct nvdimm_drvdata *ndd)
+static unsigned long nd_label_base(struct nvdimm_drvdata *ndd)
 {
 	void *base = to_namespace_index(ndd, 0);
 
-	return base + 2 * sizeof_namespace_index(ndd);
+	return (unsigned long) (base + 2 * sizeof_namespace_index(ndd));
 }
 
 static int to_slot(struct nvdimm_drvdata *ndd,
@@ -284,7 +284,7 @@ static int to_slot(struct nvdimm_drvdata *ndd,
 	unsigned long label, base;
 
 	label = (unsigned long) nd_label;
-	base = (unsigned long) nd_label_base(ndd);
+	base = nd_label_base(ndd);
 
 	return (label - base) / sizeof_namespace_label(ndd);
 }
@@ -293,7 +293,7 @@ static struct nd_namespace_label *to_label(struct nvdimm_drvdata *ndd, int slot)
 {
 	unsigned long label, base;
 
-	base = (unsigned long) nd_label_base(ndd);
+	base = nd_label_base(ndd);
 	label = base + sizeof_namespace_label(ndd) * slot;
 
 	return (struct nd_namespace_label *) label;
@@ -684,7 +684,7 @@ static int nd_label_write_index(struct nvdimm_drvdata *ndd, int index, u32 seq,
 			nd_label_next_nsindex(index))
 		- (unsigned long) to_namespace_index(ndd, 0);
 	nsindex->otheroff = __cpu_to_le64(offset);
-	offset = (unsigned long) nd_label_base(ndd)
+	offset = nd_label_base(ndd)
 		- (unsigned long) to_namespace_index(ndd, 0);
 	nsindex->labeloff = __cpu_to_le64(offset);
 	nsindex->nslot = __cpu_to_le32(nslot);

base-commit: 46037455cbb748c5e85071c95f2244e81986eb58
-- 
2.34.1

