Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F6B2FCC01
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769167890; cv=none; b=cw6SnyxTnfevd3m9Tf7xRbeyh0e55JPvx+SvNUefgTXch8WjeuuBPEeLlG5ez5+zCvIO1Sta7UJWN0Fc//ezw7HSml4dreZXZaZDtIH/SN4YSHWBu1oXRbdTYf7lNgMlwh4E+di0HraMLjJU1h1vT5bOUpMxyxE62QSn2b8+d4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769167890; c=relaxed/simple;
	bh=KM24CjqoMDDe8npGaVVcWzJfF1oRGcGBwVm4lwATVU0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=EOz+rPGc8VXmbtaW/Xi165YpH7EaxNKEHa2wBv2B6o8MSl5yw6aXJXSJJGSJCoCItWjv6K2uyMeMcRGidZWh1WdKS2YXS8rdXy+2gYjz/QaPDybAgyZxR+rpm/olrgKl/y2Hv05dJS+Sd8nDPYbX6sLoysKV67sNcR+LrP5EGiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=sZCszZMv; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="sZCszZMv"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260123113127epoutp04dfe7b9c8e346d271f50cbc3804538bb2~NWNHgoFzU0297002970epoutp04X
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260123113127epoutp04dfe7b9c8e346d271f50cbc3804538bb2~NWNHgoFzU0297002970epoutp04X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769167887;
	bh=XCGgkoYzmHDoS6RA8zyIHNIs3/xy9sGJph2JjO1aG/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZCszZMv3csjHpp93359S3O57dmnEPMGAXSYF7fgmnXed54IE8nVRY68LRRm1tdWB
	 Y9JuSSYuk5ofQ2H6lrncFQNexw95URuKC5Q12nC8KsV4Egoafb299TUeS45UKkl/cU
	 9itL62tNF0T0hQICgD0wRKAGWctTV1XfTHE7mnJU=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260123113126epcas5p313cae7f1d85a00b38e87ba641037513a~NWNHJvvno1446414464epcas5p3f;
	Fri, 23 Jan 2026 11:31:26 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.95]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dyG3L02S9z6B9m4; Fri, 23 Jan
	2026 11:31:26 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260123113125epcas5p2331d76ce8aee6d594dbdd5b3e75e7d6f~NWNF-I7Dz1670216702epcas5p2L;
	Fri, 23 Jan 2026 11:31:25 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260123113124epsmtip26c00a84ba699a3bb67c8331a9a2efb37~NWNExDnPz2685626856epsmtip2C;
	Fri, 23 Jan 2026 11:31:23 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V6 02/18] nvdimm/label: CXL labels skip the need for
 'interleave-set cookie'
Date: Fri, 23 Jan 2026 17:00:56 +0530
Message-Id: <20260123113112.3488381-3-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260123113112.3488381-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260123113125epcas5p2331d76ce8aee6d594dbdd5b3e75e7d6f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260123113125epcas5p2331d76ce8aee6d594dbdd5b3e75e7d6f
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
	<CGME20260123113125epcas5p2331d76ce8aee6d594dbdd5b3e75e7d6f@epcas5p2.samsung.com>

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

