Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609F92EA489
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750165210; cv=none; b=Lmzw/220OSaLBk8VXZw8LV5CRnfmT6UiK1Qe1lo0ZMBBWBSARywd8p1IZzVMfg+Qb71Jc4j7/zfagqsEW6mcPottXc8IKumfChPtKFRUp1MUm/i3DR8tLNfMT0mRv3IXUD5rqncVGiJVmBm47syHUf1E/PZb1Fw6U2aEa3u4k5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750165210; c=relaxed/simple;
	bh=l6YO+OHmFrev9DiqXKy6uGyucXVU0xnvbeCiudX4yqU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=WZ0l37RNETmfcKPUgkQKbXWoL+Ns98bguy3RSBxiYCzWtO186ffRIYTDuoGmnUKQ06yFmSKYsssMmVbkzY5VLLif4EOSpcb6sgrSzOlDS6+21IJmv6+czUudHGhHAxaRdwNQvkpTU7BW/jBiPSlr6a5TKz1L/OIaNy1j1QPPOSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=TbN8XNSi; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="TbN8XNSi"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250617130004epoutp04677c8def1f733e42417911151071fe1e~J1fsapoOo2167821678epoutp04K
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:00:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250617130004epoutp04677c8def1f733e42417911151071fe1e~J1fsapoOo2167821678epoutp04K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750165204;
	bh=Vau9+DNMkM4KJInV2Qf7GXiT4TEu9rPCdl/nHaJ4lss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TbN8XNSiI5BrDmUhBUccmyQGn5+uCn9ycByDwBnIo9OBWmIqaj2+GM2R9f9CJB84m
	 Q6hNYWfgxEXizDOTgJY/YixpDrJVTbp1PxITtf5b8MTLgAH3cXAkGCV67DYVfjuXeY
	 PEkmlR1PJKc/ji+RFlzjTEFPFcS5ATXkmN1QlIao=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250617130004epcas5p1d1e07370aba44ba4410d80a7b06ebc32~J1fr3Iue22452824528epcas5p1i;
	Tue, 17 Jun 2025 13:00:04 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4bM6R80HRjz6B9mD; Tue, 17 Jun
	2025 13:00:04 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124016epcas5p20b04482f41a58c7f83484aa2b8b0c33c~J1OaPQy0V0929709297epcas5p2Q;
	Tue, 17 Jun 2025 12:40:16 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124014epsmtip25bc02e4226c883edacc8b6bcd6cce5d1~J1OXuA9yM2543925439epsmtip2k;
	Tue, 17 Jun 2025 12:40:14 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, s.neeraj@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: [RFC PATCH 04/20] nvdimm/label: CXL labels skip the need for
 'interleave-set cookie'
Date: Tue, 17 Jun 2025 18:09:28 +0530
Message-Id: <439928219.101750165204036.JavaMail.epsvc@epcpadp1new>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250617123944.78345-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250617124016epcas5p20b04482f41a58c7f83484aa2b8b0c33c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124016epcas5p20b04482f41a58c7f83484aa2b8b0c33c
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124016epcas5p20b04482f41a58c7f83484aa2b8b0c33c@epcas5p2.samsung.com>

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
index f180f0068c15..23b9def71012 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1686,7 +1686,8 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
 	int rc = 0;
 	u16 i;
 
-	if (cookie == 0) {
+	/* CXL labels skip the need for 'interleave-set cookie' */
+	if (!ndd->cxl && cookie == 0) {
 		dev_dbg(&nd_region->dev, "invalid interleave-set-cookie\n");
 		return ERR_PTR(-ENXIO);
 	}
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 37417ce5ec7b..0481fc3fb627 100644
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


