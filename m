Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859502580F3
	for <nvdimm@lists.linux.dev>; Thu, 18 Sep 2025 04:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758169688; cv=none; b=NHfEWBHggIqBYTXx1dZPvwXkEkjpQGNHwhkG5wMQLOwqQVVjtkA3LcjnNW/whcePQ+dYbzZXirwY0a7IqEEWG/v/EV3QdeF4pR6RnwkyNND7bxPotJzntViSTeRwme7vA3gwihox3p6uJntby9gbUi8FQW7Lu5jQkaB7DjfCzKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758169688; c=relaxed/simple;
	bh=huzLLkBs3Vk5ryeeSJ5VZUBZGOCp4kS3cFAiVMmu5JQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=hPDFjMObfphRrQlaog/34EFea6Z6hGjWi5PepyQww/kgwaWW/OToAVf2lOPYS+e9/fFAIqAqAG709MevUWKbVA4hJmqg2G61OM5aiMFgQ+07MBdJjeayh+wjCwwJVnlepJHy+/sZumCo/rZ6+NRv43BB4i9N4u8ZlqRQM8pEoE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=YQbA0kRA; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YQbA0kRA"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250918042803epoutp0120b1274e51b1bdde0fa3e933658fabd4~mRgMC9MrS1657016570epoutp01p
	for <nvdimm@lists.linux.dev>; Thu, 18 Sep 2025 04:28:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250918042803epoutp0120b1274e51b1bdde0fa3e933658fabd4~mRgMC9MrS1657016570epoutp01p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758169683;
	bh=VfTKt+9cya/Xi6xKXtJ2s6w+UyV0o12N66zYmXYF2Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQbA0kRABPa4qazJNmP0w0ncK1iF3Ho0j+8cn/pFxfHuwfpUP5GydFeH4Pnas5fhJ
	 UOF7IaB6Ry8XYdV49c/d8ZJBqKoyFrEBOPc23bTC2k7BwHK7uziZaMIe7JeMCQe8c8
	 tyxpNJAf2oVJ/kOLr9nqPivFviuhLYJyi17XXucU=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250918042802epcas5p395734330ce89f122c2e1396d1fbb2f29~mRgLfUQX02834428344epcas5p3J;
	Thu, 18 Sep 2025 04:28:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cS2gQ4dgJz2SSKd; Thu, 18 Sep
	2025 04:28:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250917134132epcas5p192c031691ab4cbb905f2b2313bb79dee~mFaKh1Xvt1744617446epcas5p1D;
	Wed, 17 Sep 2025 13:41:32 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250917134131epsmtip2b3ec6fcf599b4b2f199f60c0dc1c8878~mFaI_cDaX0779307793epsmtip2_;
	Wed, 17 Sep 2025 13:41:30 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com, Neeraj Kumar <s.neeraj@samsung.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH V3 02/20] nvdimm/label: CXL labels skip the need for
 'interleave-set cookie'
Date: Wed, 17 Sep 2025 19:10:58 +0530
Message-Id: <1891546521.01758169682623.JavaMail.epsvc@epcpadp2new>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917134116.1623730-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917134132epcas5p192c031691ab4cbb905f2b2313bb79dee
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250917134132epcas5p192c031691ab4cbb905f2b2313bb79dee
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134132epcas5p192c031691ab4cbb905f2b2313bb79dee@epcas5p1.samsung.com>

CXL LSA v2.1 utilizes the region labels stored in the LSA for interleave
set configuration instead of interleave-set cookie used in previous LSA
versions. As interleave-set cookie is not required for CXL LSA v2.1 format
so skip its usage for CXL LSA 2.1 format

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Acked-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/nvdimm/namespace_devs.c |  8 +++++++-
 drivers/nvdimm/region_devs.c    | 10 ++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 55cfbf1e0a95..3271b1c8569a 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1684,7 +1684,13 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
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
index de1ee5ebc851..88275f352240 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -858,6 +858,16 @@ u64 nd_region_interleave_set_cookie(struct nd_region *nd_region,
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


