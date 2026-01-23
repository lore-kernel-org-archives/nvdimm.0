Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B9037D101
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769167906; cv=none; b=OS/Gvom+kXSqoIqmZhEATxybxWwh4Fg+xwjTZUgU1F67ds9v/X9mYpyYa5XJEatnpS6yYm+De3jdOPAekrvXBXOeyxjGh0wpwIF8CD1I0CvGTcP/mXCeFkzW7ZNay/UyFTBxeY8A8fxEt++3NtipSFyexBe8uFlThTPxXFeIa34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769167906; c=relaxed/simple;
	bh=12SjqgG/2au2W2dkYs+WPLEpvuaVcGNq0Yr5ctgp+TY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=shWJW4lRxr0VqMQMqATJNfSow/v0utcTDdOFgtA9ZvjzeiwWt2J4EQjC+e+TzNs/wacbamnVxFSf0CVN47OIFjRgQF4p/MAZRyY4A5blLocPqEBYnLNVuqva2wdvuF7XM0Kij9fX/zX9H3ExucaxvpnAHpXJorUkrfVkkycM+T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=MWKrpT51; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MWKrpT51"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260123113141epoutp03372ea064e3f0127cc226fda621c7c946~NWNVFEKcG2124621246epoutp03D
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260123113141epoutp03372ea064e3f0127cc226fda621c7c946~NWNVFEKcG2124621246epoutp03D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769167901;
	bh=h42lregPaaxWlPA3ZNxkhidw5R9qr+oDNtum6fVurAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWKrpT51B1KDcShGw7UEC1hhwLEvpM2uWIvwr+vCc19RpFSTyA77OINHL/BoDDjUw
	 fLq5WGzvdiYll78nOaP48xw+kmehz9c+9gda2c7Vpz9vo+2tFspYSTxmAtNWSEg5NZ
	 pujBxEMFPxPTSv0DdJqTcZzDhfGkpb+CR4lfg4TY=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260123113141epcas5p45a1c656d0625186910879ca0781cab78~NWNUzAdLz1479614796epcas5p4o;
	Fri, 23 Jan 2026 11:31:41 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.94]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dyG3c48c2z6B9m9; Fri, 23 Jan
	2026 11:31:40 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260123113140epcas5p4bc7a864d4a717b96afcb863e3200b3a2~NWNTue00c1464914649epcas5p4m;
	Fri, 23 Jan 2026 11:31:40 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260123113138epsmtip2c8f269e388fc1d8648b4c40766119bac~NWNSKvlTm2681126811epsmtip2g;
	Fri, 23 Jan 2026 11:31:38 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V6 11/18] cxl/region: Rename __create_region() to
 cxl_create_region()
Date: Fri, 23 Jan 2026 17:01:05 +0530
Message-Id: <20260123113112.3488381-12-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260123113112.3488381-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260123113140epcas5p4bc7a864d4a717b96afcb863e3200b3a2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260123113140epcas5p4bc7a864d4a717b96afcb863e3200b3a2
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
	<CGME20260123113140epcas5p4bc7a864d4a717b96afcb863e3200b3a2@epcas5p4.samsung.com>

Currently __create_region() is a static routine used within region.c
So to use it from another file rename it to cxl_create_region().

Later patch will create cxl region after fetching region information
from LSA using cxl_create_region() along with two extra function
parameters.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/core/core.h   | 12 ++++++++++++
 drivers/cxl/core/region.c | 13 ++++++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 1fb66132b777..268f6d19ab9d 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -42,6 +42,10 @@ int cxl_get_poison_by_endpoint(struct cxl_port *port);
 struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa);
 u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
 		   u64 dpa);
+struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
+				     enum cxl_partition_mode mode, int id,
+				     struct cxl_pmem_region_params *pmem_params,
+				     struct cxl_endpoint_decoder *cxled);
 
 #else
 static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
@@ -71,6 +75,14 @@ static inline int cxl_region_init(void)
 static inline void cxl_region_exit(void)
 {
 }
+static inline struct cxl_region *
+cxl_create_region(struct cxl_root_decoder *cxlrd,
+		  enum cxl_partition_mode mode, int id,
+		  struct cxl_pmem_region_params *params,
+		  struct cxl_endpoint_decoder *cxled)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
 #define CXL_REGION_ATTR(x) NULL
 #define CXL_REGION_TYPE(x) NULL
 #define SET_CXL_REGION_ATTR(x)
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 26238fb5e8cf..2e60e5e72551 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2638,8 +2638,10 @@ static ssize_t create_ram_region_show(struct device *dev,
 	return __create_region_show(to_cxl_root_decoder(dev), buf);
 }
 
-static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
-					  enum cxl_partition_mode mode, int id)
+struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
+				     enum cxl_partition_mode mode, int id,
+				     struct cxl_pmem_region_params *pmem_params,
+				     struct cxl_endpoint_decoder *cxled)
 {
 	int rc;
 
@@ -2675,7 +2677,7 @@ static ssize_t create_region_store(struct device *dev, const char *buf,
 	if (rc != 1)
 		return -EINVAL;
 
-	cxlr = __create_region(cxlrd, mode, id);
+	cxlr = cxl_create_region(cxlrd, mode, id, NULL, NULL);
 	if (IS_ERR(cxlr))
 		return PTR_ERR(cxlr);
 
@@ -3644,8 +3646,9 @@ static struct cxl_region *construct_region(struct cxl_root_decoder *cxlrd,
 	struct cxl_region *cxlr;
 
 	do {
-		cxlr = __create_region(cxlrd, cxlds->part[part].mode,
-				       atomic_read(&cxlrd->region_id));
+		cxlr = cxl_create_region(cxlrd, cxlds->part[part].mode,
+					 atomic_read(&cxlrd->region_id),
+					 NULL, NULL);
 	} while (IS_ERR(cxlr) && PTR_ERR(cxlr) == -EBUSY);
 
 	if (IS_ERR(cxlr)) {
-- 
2.34.1

