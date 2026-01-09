Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD10B35B12B
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962731; cv=none; b=V4ORH145Iu704UKpwWiaj+WnAYqR5uqOKnJySMQexX40lXdRVALQzJk3Cpvh0sj7w9DSLDBenD69q+PQM0bhWA2weg0FI8XgR5eTaubwin7lbviYe3wspomSCCUUMwOKZuTf5IGSb6CjRm+Md2GD9HEy546jckz0ej7nIqj9lDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962731; c=relaxed/simple;
	bh=HD/gTB5kgM6SiK/HmvIIhivfkdDDsrZm2IXLN8y2248=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=jzYGPvVXNogglGt896RS3vxZNjT3RigbvPpG7NEH44xMzzAQyDRiCoQa/nGseY1+3XcVj7jGrlBfv99b+3u370aUipZePbdCuqjLs363cCiNTXHowhvI5+q5Mkb+6WCpqGOF+l693b15oJ4qgDGNEAGZiEyJGfBz5CUM+kKHYQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=tYDWq3DB; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="tYDWq3DB"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260109124527epoutp01e85f6166e89c7ccc0a1445978ed92814~JELuwagcJ0815508155epoutp01i
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260109124527epoutp01e85f6166e89c7ccc0a1445978ed92814~JELuwagcJ0815508155epoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767962727;
	bh=aO+ljYqEEsUGo4X69OdR2NXyQbVGtMyJXmVdd54fJ+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tYDWq3DBqSisC5H3Cxhuc9NASU58YUM32jTf4FhTBB/0/LEUwC7gcLIR6TNU33Klk
	 y7fa2MI6Qu7gcbzX1rT+GfkbyyJHm6rVRXM+4PHO9Yghb18EiRFKWcV6Mmjt/2/ivy
	 Hb7DAVqYBj1UYHxf4NvA6st8yxGmNS7juMx7sfnw=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260109124526epcas5p1a11f5188ac806435d97f9e9f82ffe92d~JELuixkgr2943229432epcas5p1e;
	Fri,  9 Jan 2026 12:45:26 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.87]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dnhMB0b2cz2SSKX; Fri,  9 Jan
	2026 12:45:26 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260109124525epcas5p103e2d6f32643e6cb07b7037155ef16e9~JELtdxcz82911929119epcas5p1n;
	Fri,  9 Jan 2026 12:45:25 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260109124524epsmtip157be96a874752c009205ec3be9e26c2a~JELsY3uy90977009770epsmtip1j;
	Fri,  9 Jan 2026 12:45:24 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V5 11/17] cxl/region: Add devm_cxl_pmem_add_region() for
 pmem region creation
Date: Fri,  9 Jan 2026 18:14:31 +0530
Message-Id: <20260109124437.4025893-12-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260109124437.4025893-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260109124525epcas5p103e2d6f32643e6cb07b7037155ef16e9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260109124525epcas5p103e2d6f32643e6cb07b7037155ef16e9
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124525epcas5p103e2d6f32643e6cb07b7037155ef16e9@epcas5p1.samsung.com>

devm_cxl_pmem_add_region() is used to create cxl region based on region
information scanned from LSA.

devm_cxl_add_region() is used to just allocate cxlr and its fields are
filled later by userspace tool using device attributes (*_store()).

Inspiration for devm_cxl_pmem_add_region() is taken from these device
attributes (_store*) calls. It allocates cxlr and fills information
parsed from LSA and calls device_add(&cxlr->dev) to initiate further
region creation porbes

Rename __create_region() to cxl_create_region(), which will be used
in later patch to create cxl region after fetching region information
from LSA.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/core/core.h   |  12 ++++
 drivers/cxl/core/region.c | 137 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 144 insertions(+), 5 deletions(-)

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
index 26238fb5e8cf..13779aeacd8e 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2621,6 +2621,127 @@ static struct cxl_region *devm_cxl_add_region(struct cxl_root_decoder *cxlrd,
 	return ERR_PTR(rc);
 }
 
+static ssize_t alloc_region_hpa(struct cxl_region *cxlr, u64 size)
+{
+	int rc;
+
+	if (!size)
+		return -EINVAL;
+
+	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
+	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem)))
+		return rc;
+
+	return alloc_hpa(cxlr, size);
+}
+
+static ssize_t alloc_region_dpa(struct cxl_endpoint_decoder *cxled, u64 size)
+{
+	int rc;
+
+	if (!size)
+		return -EINVAL;
+
+	if (!IS_ALIGNED(size, SZ_256M))
+		return -EINVAL;
+
+	rc = cxl_dpa_free(cxled);
+	if (rc)
+		return rc;
+
+	return cxl_dpa_alloc(cxled, size);
+}
+
+static struct cxl_region *
+cxl_pmem_region_prep(struct cxl_root_decoder *cxlrd, int id,
+		     struct cxl_pmem_region_params *params,
+		     struct cxl_endpoint_decoder *cxled,
+		     enum cxl_decoder_type type)
+{
+	struct cxl_region_params *p;
+	struct device *dev;
+	int rc;
+
+	struct cxl_region *cxlr __free(put_cxl_region) =
+		cxl_region_alloc(cxlrd, id);
+	if (IS_ERR(cxlr))
+		return cxlr;
+
+	dev = &cxlr->dev;
+	rc = dev_set_name(dev, "region%d", id);
+	if (rc)
+		return ERR_PTR(rc);
+
+	cxlr->mode = CXL_PARTMODE_PMEM;
+	cxlr->type = type;
+
+	p = &cxlr->params;
+	p->uuid = params->uuid;
+	p->interleave_ways = params->nlabel;
+	p->interleave_granularity = params->ig;
+
+	rc = alloc_region_hpa(cxlr, params->rawsize);
+	if (rc)
+		return ERR_PTR(rc);
+
+	rc = cxl_dpa_set_part(cxled, CXL_PARTMODE_PMEM);
+	if (rc)
+		return ERR_PTR(rc);
+
+	rc = alloc_region_dpa(cxled, params->rawsize);
+	if (rc)
+		return ERR_PTR(rc);
+
+	/*
+	 * TODO: Currently we have support of interleave_way == 1, where
+	 * we can only have one region per mem device. It means mem device
+	 * position (params->position) will always be 0. It is therefore
+	 * attaching only one target at params->position
+	 */
+	if (params->position)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	rc = attach_target(cxlr, cxled, params->position, TASK_INTERRUPTIBLE);
+	if (rc)
+		return ERR_PTR(rc);
+
+	rc = __commit(cxlr);
+	if (rc)
+		return ERR_PTR(rc);
+
+	rc = device_add(dev);
+	if (rc)
+		return ERR_PTR(rc);
+
+	return no_free_ptr(cxlr);
+}
+
+static struct cxl_region *
+devm_cxl_pmem_add_region(struct cxl_root_decoder *cxlrd, int id,
+			 struct cxl_pmem_region_params *params,
+			 struct cxl_endpoint_decoder *cxled,
+			 enum cxl_decoder_type type)
+{
+	struct cxl_port *root_port;
+	struct cxl_region *cxlr;
+	int rc;
+
+	cxlr = cxl_pmem_region_prep(cxlrd, id, params, cxled, type);
+	if (IS_ERR(cxlr))
+		return cxlr;
+
+	root_port = to_cxl_port(cxlrd->cxlsd.cxld.dev.parent);
+	rc = devm_add_action_or_reset(root_port->uport_dev,
+				      unregister_region, cxlr);
+	if (rc)
+		return ERR_PTR(rc);
+
+	dev_dbg(root_port->uport_dev, "%s: created %s\n",
+		dev_name(&cxlrd->cxlsd.cxld.dev), dev_name(&cxlr->dev));
+
+	return cxlr;
+}
+
 static ssize_t __create_region_show(struct cxl_root_decoder *cxlrd, char *buf)
 {
 	return sysfs_emit(buf, "region%u\n", atomic_read(&cxlrd->region_id));
@@ -2638,8 +2759,10 @@ static ssize_t create_ram_region_show(struct device *dev,
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
 
@@ -2661,6 +2784,9 @@ static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
 		return ERR_PTR(-EBUSY);
 	}
 
+	if (pmem_params)
+		return devm_cxl_pmem_add_region(cxlrd, id, pmem_params, cxled,
+						CXL_DECODER_HOSTONLYMEM);
 	return devm_cxl_add_region(cxlrd, id, mode, CXL_DECODER_HOSTONLYMEM);
 }
 
@@ -2675,7 +2801,7 @@ static ssize_t create_region_store(struct device *dev, const char *buf,
 	if (rc != 1)
 		return -EINVAL;
 
-	cxlr = __create_region(cxlrd, mode, id);
+	cxlr = cxl_create_region(cxlrd, mode, id, NULL, NULL);
 	if (IS_ERR(cxlr))
 		return PTR_ERR(cxlr);
 
@@ -3644,8 +3770,9 @@ static struct cxl_region *construct_region(struct cxl_root_decoder *cxlrd,
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

