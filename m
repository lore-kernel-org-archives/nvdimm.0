Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1A135F8CA
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962739; cv=none; b=ZZBnH3FnoLgnQw/BsgDkk+W/lEPEKEU0rquKm9dtI7TQyp4s27TzUxOnEFbBdQWc7bpBj1LsqYTt2520gByX3DSx3G35wZbEO9RcUaeqZs+v2KuPs4RYzTgFI3k+Yz8lJrYesebvZoSwpQ5KdBnOuazARZtTxUvbjeZxJ6w6yZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962739; c=relaxed/simple;
	bh=EhYuxnRW3T+38D3RogRWydt55MzA3B0k4DPqzmHGf2s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=BDsCj++Bov+7e7ldMGkeWn8h0rekQMW3JpCDu1IF+wutRULnyoTMrFcrDceuwENEZC5PrpEpM3TIHdypqis7twt/L8lzMdlN8rsT4HE4np3ORGkh6BJds6w7rFIdUTp1oMX+2DYpp5Fz+d9BTmR3y5TNqYwftaXYnrsLcmJxuJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=LdlifuX2; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="LdlifuX2"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260109124536epoutp04f531d559cef449cd4e6eae7ae82b2228~JEL3P3jpX0411704117epoutp04U
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260109124536epoutp04f531d559cef449cd4e6eae7ae82b2228~JEL3P3jpX0411704117epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767962736;
	bh=c2KxUsO9ytOrBf7X4mfY7fSpb3M6uH0SntlKavJZqz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LdlifuX2DaCIWnCvJjI58YI0vAiYicA97CWRmB3RjbFnXwabXpjFftfn9VaX0Rxgn
	 rJNudBDNx81CBSJ2yFoBTImKqoZZiVJ8YSFoJy1dAXKF5AycarCVUAN4rw4TRWgrNL
	 C2VJcdk0bGnCwLKYJ4VF+lA82ZoqYb2J5AHf6GXs=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260109124535epcas5p2f9abcdcc26f7459a79e5d3020277dc8b~JEL27yUTL3051830518epcas5p2U;
	Fri,  9 Jan 2026 12:45:35 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.94]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dnhMM0n6Zz2SSKX; Fri,  9 Jan
	2026 12:45:35 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260109124534epcas5p47d59d746b77254f428735268d7731623~JEL1on_Kl0099900999epcas5p4a;
	Fri,  9 Jan 2026 12:45:34 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260109124532epsmtip1af04cb5e85158423bed17bbf6264adc0~JEL0TJlMG0977009770epsmtip1o;
	Fri,  9 Jan 2026 12:45:32 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V5 17/17] cxl/pmem: Add CXL LSA 2.1 support in cxl pmem
Date: Fri,  9 Jan 2026 18:14:37 +0530
Message-Id: <20260109124437.4025893-18-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260109124437.4025893-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260109124534epcas5p47d59d746b77254f428735268d7731623
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260109124534epcas5p47d59d746b77254f428735268d7731623
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124534epcas5p47d59d746b77254f428735268d7731623@epcas5p4.samsung.com>

Add support of CXL LSA 2.1 using NDD_REGION_LABELING flag. It creates
cxl region based on region information parsed from LSA

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/pmem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index a6eba3572090..5970d1792be8 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -135,6 +135,7 @@ static int cxl_nvdimm_probe(struct device *dev)
 		return rc;
 
 	set_bit(NDD_LABELING, &flags);
+	set_bit(NDD_REGION_LABELING, &flags);
 	set_bit(NDD_REGISTER_SYNC, &flags);
 	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
 	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
@@ -155,6 +156,7 @@ static int cxl_nvdimm_probe(struct device *dev)
 		return -ENOMEM;
 
 	dev_set_drvdata(dev, nvdimm);
+	create_pmem_region(nvdimm);
 	return devm_add_action_or_reset(dev, unregister_nvdimm, nvdimm);
 }
 
-- 
2.34.1

