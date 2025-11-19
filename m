Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53C82F690B
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 08:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763539394; cv=none; b=ScUrDg5HjhUZ8/dUmHItj+qK2OLOJwlbDfcsTL3sBgOBxn5w5Jw1xLAZBVyNbmrH0ilCL56yIJJPVintZYNYaCzkKnqW74+6lpqSTC3wJn5/XzLWJUt4KQ9sLcm1jhJX1tfQfAKNbiejUq2EXPwNDbgsPJS9SIl//6m6d83PKPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763539394; c=relaxed/simple;
	bh=ShADinf0ceFNInXUC1/9ovwqsK/dzkjpi29FBCB4wyk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=kotbi5mhl6pdBGOO7KjWoYlH63dENOhKkqlJtXN+ahHbouCIO0FMI15h2zshOW34QDa4tqyHMfdRHVVT3WljHtPbX86W9kx1x/8rEWQUwwVYRdX7/wOsgd28R1ihNyIbKo6A0vvp/vwh9B4WzRliGE0m41jRZykmq8JgBK87Qz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=cpq6rKn7; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cpq6rKn7"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20251119075311epoutp0222ee539ec252df5e9a1bec89ba31a163~5WS-YPUBY2564225642epoutp029
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20251119075311epoutp0222ee539ec252df5e9a1bec89ba31a163~5WS-YPUBY2564225642epoutp029
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1763538791;
	bh=rPhEj1OYydDtYbq1YtLA0Z1jyn4oKHdktpA/8d10QHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cpq6rKn79nP/3K3BB/N3v5hfKurEBNtxfvu55Bo4OPaz9QjK9ywf+Ue8cHsqn+xNh
	 XIiroigY9ax5V0CsxM4rbTno4YPJuQhLi+MIZPilp3B2vL/b7QhRYfdT5hkDszWPTh
	 uU8o7VCjoKmo9OWykTggrRNTDyDbbEKPIKULYjjs=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251119075310epcas5p3e885d2478bbe2f44ed78876c8d06d948~5WS_-xyMd3101731017epcas5p3t;
	Wed, 19 Nov 2025 07:53:10 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.91]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dBDHT5K6jz6B9mD; Wed, 19 Nov
	2025 07:53:09 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20251119075309epcas5p204a699babdf635f11f4b97d3ab8e8a13~5WS9ueb7x0870808708epcas5p2x;
	Wed, 19 Nov 2025 07:53:09 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251119075308epsmtip1d5375b1ba801c57f79c7fc64d1c55939~5WS8gtAhz2605226052epsmtip1J;
	Wed, 19 Nov 2025 07:53:07 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V4 02/17] nvdimm/label: CXL labels skip the need for
 'interleave-set cookie'
Date: Wed, 19 Nov 2025 13:22:40 +0530
Message-Id: <20251119075255.2637388-3-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251119075255.2637388-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251119075309epcas5p204a699babdf635f11f4b97d3ab8e8a13
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075309epcas5p204a699babdf635f11f4b97d3ab8e8a13
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075309epcas5p204a699babdf635f11f4b97d3ab8e8a13@epcas5p2.samsung.com>

CXL LSA v2.1 utilizes the region labels stored in the LSA for interleave
set configuration instead of interleave-set cookie used in previous LSA
versions. As interleave-set cookie is not required for CXL LSA v2.1 format
so skip its usage for CXL LSA 2.1 format

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Acked-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/namespace_devs.c |  8 +++++++-
 drivers/nvdimm/region_devs.c    | 10 ++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index a5edcacfe46d..43fdb806532e 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1678,7 +1678,13 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
 	int rc = 0;
 	u16 i;
 
-	if (cookie == 0) {
+	/*
+	 * CXL LSA v2.1 utilizes the region label stored in the LSA for
+	 * interleave set configuration. Whereas EFI LSA v1.1 & v1.2
+	 * utilizes interleave-set cookie. i.e, CXL labels skip the
+	 * need for 'interleave-set cookie'
+	 */
+	if (!ndd->cxl && cookie == 0) {
 		dev_dbg(&nd_region->dev, "invalid interleave-set-cookie\n");
 		return ERR_PTR(-ENXIO);
 	}
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index a5ceaf5db595..269595e6321e 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -841,6 +841,16 @@ u64 nd_region_interleave_set_cookie(struct nd_region *nd_region,
 	if (!nd_set)
 		return 0;
 
+	/*
+	 * CXL LSA v2.1 utilizes the region label stored in the LSA for
+	 * interleave set configuration. Whereas EFI LSA v1.1 & v1.2
+	 * utilizes interleave-set cookie. i.e, CXL labels skip the
+	 * need for 'interleave-set cookie'
+	 */
+	if (nsindex && __le16_to_cpu(nsindex->major) == 2
+			&& __le16_to_cpu(nsindex->minor) == 1)
+		return 0;
+
 	if (nsindex && __le16_to_cpu(nsindex->major) == 1
 			&& __le16_to_cpu(nsindex->minor) == 1)
 		return nd_set->cookie1;
-- 
2.34.1

