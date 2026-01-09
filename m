Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C6A3590C4
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962702; cv=none; b=ZobQiaizJFnK/F0p9bsh2Oy43KUcJscz1vrx6NpSwYqKTXEo+mT1boHkWPVUOXOuaX3LhAl0KRNDn49f0VntdFbuEm2PtJ8sdrUEFSWycAE81WxX8szHHWosfMnvfOrYJk3z63wdi8+lCTR7d62OPCZYW2+38PhzN4lzMylZfek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962702; c=relaxed/simple;
	bh=KM24CjqoMDDe8npGaVVcWzJfF1oRGcGBwVm4lwATVU0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=dWzuaYSwGNO6hVjm6lptr6FVCnw0BP20DvvfraJ/Uwz+iaTiffF0xFc7smlBmAGM6/7LJbXbI4Wx35jdT+2ETwbXTqdc474kJyT9/fBMXknOTJDC/qWLtnHVhlss3bTDPwecQldpmYjBlF2Oetm7qWbbOYhmD6rfVn+lvxcY+YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=rwzLuElc; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="rwzLuElc"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260109124459epoutp01fd8261e56fe7844ddfb34118a22519df~JELVFqMzD0794707947epoutp01V
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:44:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260109124459epoutp01fd8261e56fe7844ddfb34118a22519df~JELVFqMzD0794707947epoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767962699;
	bh=XCGgkoYzmHDoS6RA8zyIHNIs3/xy9sGJph2JjO1aG/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwzLuElchf4um3gbjXw2T0e7xhFzenW10+bmvcXK70aIZxCMyqkqQVa8PuwMIfQkc
	 rqLqVrqM4kFBZr9EGbwxjzN9SU+0+XtxHT/GdEE8yASSybgqWYPiXp7ppLQ+Mv6mxn
	 HYzgR0lm2ryC5pnPuDkaFX2xi5GUu+bq3R+NogEw=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260109124458epcas5p461ba1190da42dc4a5516dc925a4226da~JELUeBJdi1264312643epcas5p4e;
	Fri,  9 Jan 2026 12:44:58 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.88]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dnhLf0l8jz2SSKX; Fri,  9 Jan
	2026 12:44:58 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260109124457epcas5p2c2e8b5dfb9bfc0bc2aa0fcbe9e3122f3~JELTONU5c0900009000epcas5p2r;
	Fri,  9 Jan 2026 12:44:57 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260109124455epsmtip150b6494316438851410b875002b7c69a~JELRt94d50972509725epsmtip1P;
	Fri,  9 Jan 2026 12:44:55 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V5 02/17] nvdimm/label: CXL labels skip the need for
 'interleave-set cookie'
Date: Fri,  9 Jan 2026 18:14:22 +0530
Message-Id: <20260109124437.4025893-3-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260109124437.4025893-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260109124457epcas5p2c2e8b5dfb9bfc0bc2aa0fcbe9e3122f3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260109124457epcas5p2c2e8b5dfb9bfc0bc2aa0fcbe9e3122f3
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124457epcas5p2c2e8b5dfb9bfc0bc2aa0fcbe9e3122f3@epcas5p2.samsung.com>

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
index 1220530a23b6..77f36a585f13 100644
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

