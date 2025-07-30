Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710F7299944
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753877794; cv=none; b=dsvhI9ZoQmPuJRTEK1l7+r07ocsFdDV7kr3Iw89lNIIflg6Bku2vFxxDfSGlnYdLsY4JZjlPMis+3rtv1rog61Z/XuZdba91TvCTNiu8pYs5vKsY3DSTWCmAmmS9X2+Qj73NEjkydh9AcPBs8PbG13ji3FjyMthvagGYCavC75E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753877794; c=relaxed/simple;
	bh=zn4NOTkwp+h3xoVMvp30hFs1i1RbeisLUTFs8/hzIlQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=alx1qqd9h7Utq83WCm2zUIbdP/I5M1ALh6d7/+QR+Zq+wAZmwYCiqP1tRM7wD9KnW+3rhXsWtRsVYDHXGUJ3Wc4B7qpjhJ4q5lgRNh0cnT3xAlxDbnflS6bIgmoInq5Hd8qPxDIYlp70s//fZc81oQI+DAiWDtejzUznciEs5yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=T6zn9Ygq; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="T6zn9Ygq"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250730121630epoutp02347f02da9263febd596c8f83844526c0~XBo7lJBMP1754817548epoutp02g
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:16:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250730121630epoutp02347f02da9263febd596c8f83844526c0~XBo7lJBMP1754817548epoutp02g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753877790;
	bh=BttaISXrqn94mI8uvdYxAiX0AH1BrbHd+2Cs74QyGL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6zn9YgqU8qHS9XFMBx7jxNar1UHjDAAukcW79RJ9J0fhGSzCnz75vcfZg81JcRtg
	 0tKvNlQnfMDY+QWMg1wDwiuiS2XFYYmJBHrdY0UX3QTJl9X1Sge8uudGY29Jen/kn5
	 PBOK2z1z30Gcci7v7T+Hme7kLJFz8Fe6MMgAm/1Q=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250730121630epcas5p34683f3f9ebf67030bc81d71cc54d953f~XBo7H46ve2694726947epcas5p3x;
	Wed, 30 Jul 2025 12:16:30 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.86]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4bsWR11R4Vz6B9m5; Wed, 30 Jul
	2025 12:16:29 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250730121227epcas5p4675fdb3130de49cd99351c5efd09e29e~XBlYzWctL2430924309epcas5p4R;
	Wed, 30 Jul 2025 12:12:27 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250730121226epsmtip153824ac64b0f5fd47646b248cf298b48~XBlXwxs220197501975epsmtip14;
	Wed, 30 Jul 2025 12:12:25 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V2 04/20] nvdimm/label: CXL labels skip the need for
 'interleave-set cookie'
Date: Wed, 30 Jul 2025 17:41:53 +0530
Message-Id: <20250730121209.303202-5-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250730121209.303202-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250730121227epcas5p4675fdb3130de49cd99351c5efd09e29e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121227epcas5p4675fdb3130de49cd99351c5efd09e29e
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121227epcas5p4675fdb3130de49cd99351c5efd09e29e@epcas5p4.samsung.com>

CXL LSA v2.1 utilizes the region labels stored in the LSA for interleave
set configuration instead of interleave-set cookie used in previous LSA
versions. As interleave-set cookie is not required for CXL LSA v2.1 format
so skip its usage for CXL LSA 2.1 format

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/namespace_devs.c | 3 ++-
 drivers/nvdimm/region_devs.c    | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index bdf1ed6f23d8..5b73119dc8fd 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1692,7 +1692,8 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
 	int rc = 0;
 	u16 i;
 
-	if (cookie == 0) {
+	/* CXL labels skip the need for 'interleave-set cookie' */
+	if (!ndd->cxl && cookie == 0) {
 		dev_dbg(&nd_region->dev, "invalid interleave-set-cookie\n");
 		return ERR_PTR(-ENXIO);
 	}
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index de1ee5ebc851..2debe60f8bf0 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -858,6 +858,11 @@ u64 nd_region_interleave_set_cookie(struct nd_region *nd_region,
 	if (!nd_set)
 		return 0;
 
+	/* CXL labels skip the need for 'interleave-set cookie' */
+	if (nsindex && __le16_to_cpu(nsindex->major) == 2
+			&& __le16_to_cpu(nsindex->minor) == 1)
+		return 0;
+
 	if (nsindex && __le16_to_cpu(nsindex->major) == 1
 			&& __le16_to_cpu(nsindex->minor) == 1)
 		return nd_set->cookie1;
-- 
2.34.1

