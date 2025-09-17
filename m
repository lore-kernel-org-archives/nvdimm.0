Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9670B32E732
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116525; cv=none; b=s+dt/1TvBXT/x7wJ6hkidVbtYspaDY4hdhSame9iVaCgtp/Nqvl/XUC+NdZ/zj7tqy3C+mLlhtOfiDCzyQS6w6OnlRaSq/Tcoy7O2AgK9TifuWT5QXti+PSU+aB4r2XJSZLS431H1lMB6pell/WQQZgOxV22oNHWoCFr+6k93Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116525; c=relaxed/simple;
	bh=6wBoep2iJJ3gbOo/sNXpIeAC6OyR+6x9/eGgpld/Vds=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=S/vK14z6hg2aGHn9K1bn2HBOaKlQJEQmU7JNOQAGjMSWH098BUolld3PFiOaN+7++FSoCl4qBEuiFa6Z/KPHO9zVtCBI7Ms5tGx/54CxvK6utg1HPisiMGCCJvDREGMwNpEOmqE3xsEn78v8qlcnSJDJHJ5fV5uqopbETiBLRNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=II7q4qSO; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="II7q4qSO"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250917134202epoutp0263833c798c7b51dc2b27e934369efe0f~mFalvzbl01575415754epoutp02M
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:42:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250917134202epoutp0263833c798c7b51dc2b27e934369efe0f~mFalvzbl01575415754epoutp02M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758116522;
	bh=ZcTfZKgynno2dRGhPfNpKZtAAtwys9IWfg2QaYJnRDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=II7q4qSO+s+IYak0r9AOh79ZO1Xwsl1szbTw4dCL6Ah79/bK2U03IegwzS9qgUidA
	 p4GIvUnF+tE6fqlj5OaOmUFdLlwM0aA+aoLaHcZ7CVcSkprfB7hX0m3gMediEr7oZF
	 9zW75khmAYcr7MkdnNIOzdLhlnBJkya0VVSor0/4=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250917134201epcas5p35769cb951694b153333ad6e0dee7ce6c~mFalZGfen2642526425epcas5p3e;
	Wed, 17 Sep 2025 13:42:01 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.88]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cRg144tmqz6B9m6; Wed, 17 Sep
	2025 13:42:00 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250917134159epcas5p37716c48d36c07aaffe70dafca2fa207b~mFaj2HfAX2692726927epcas5p3V;
	Wed, 17 Sep 2025 13:41:59 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250917134157epsmtip29938e9c7f2a4c8566aa2580e37d8f7db~mFahj8IOz0862908629epsmtip2N;
	Wed, 17 Sep 2025 13:41:57 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com, Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 14/20] cxl/region: Add devm_cxl_pmem_add_region() for
 pmem region creation
Date: Wed, 17 Sep 2025 19:11:10 +0530
Message-Id: <20250917134116.1623730-15-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917134116.1623730-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917134159epcas5p37716c48d36c07aaffe70dafca2fa207b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917134159epcas5p37716c48d36c07aaffe70dafca2fa207b
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134159epcas5p37716c48d36c07aaffe70dafca2fa207b@epcas5p3.samsung.com>

devm_cxl_pmem_add_region() is used to create cxl region based on region
information scanned from LSA.

devm_cxl_add_region() is used to just allocate cxlr and its fields are
filled later by userspace tool using device attributes (*_store()).

Inspiration for devm_cxl_pmem_add_region() is taken from these device
attributes (_store*) calls. It allocates cxlr and fills information
parsed from LSA and calls device_add(&cxlr->dev) to initiate further
region creation porbes

Renamed __create_region() to cxl_create_region() and make it an exported
routine. This will be used in later patch to create cxl region after
fetching region information from LSA.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/core/region.c | 127 ++++++++++++++++++++++++++++++++++++--
 drivers/cxl/cxl.h         |  12 ++++
 2 files changed, 134 insertions(+), 5 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index c325aa827992..d5c227ce7b09 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2573,6 +2573,116 @@ static struct cxl_region *devm_cxl_add_region(struct cxl_root_decoder *cxlrd,
 	return ERR_PTR(rc);
 }
 
+static ssize_t alloc_region_hpa(struct cxl_region *cxlr, u64 size)
+{
+	int rc;
+
+	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
+	rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem);
+	if (rc)
+		return rc;
+
+	if (!size)
+		return -EINVAL;
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
+devm_cxl_pmem_add_region(struct cxl_root_decoder *cxlrd, int id,
+			 enum cxl_partition_mode mode,
+			 enum cxl_decoder_type type,
+			 struct cxl_pmem_region_params *params,
+			 struct cxl_decoder *cxld)
+{
+	struct cxl_endpoint_decoder *cxled;
+	struct cxl_region_params *p;
+	struct cxl_port *root_port;
+	struct device *dev;
+	int rc;
+
+	struct cxl_region *cxlr __free(put_cxl_region) =
+		cxl_region_alloc(cxlrd, id);
+	if (IS_ERR(cxlr))
+		return cxlr;
+
+	cxlr->mode = mode;
+	cxlr->type = type;
+
+	dev = &cxlr->dev;
+	rc = dev_set_name(dev, "region%d", id);
+	if (rc)
+		return ERR_PTR(rc);
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
+	cxled = to_cxl_endpoint_decoder(&cxld->dev);
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
+		return ERR_PTR(-EINVAL);
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
+	root_port = to_cxl_port(cxlrd->cxlsd.cxld.dev.parent);
+	rc = devm_add_action_or_reset(root_port->uport_dev,
+			unregister_region, cxlr);
+	if (rc)
+		return ERR_PTR(rc);
+
+	dev_dbg(root_port->uport_dev, "%s: created %s\n",
+		dev_name(&cxlrd->cxlsd.cxld.dev), dev_name(dev));
+
+	return no_free_ptr(cxlr);
+}
+
 static ssize_t __create_region_show(struct cxl_root_decoder *cxlrd, char *buf)
 {
 	return sysfs_emit(buf, "region%u\n", atomic_read(&cxlrd->region_id));
@@ -2590,8 +2700,10 @@ static ssize_t create_ram_region_show(struct device *dev,
 	return __create_region_show(to_cxl_root_decoder(dev), buf);
 }
 
-static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
-					  enum cxl_partition_mode mode, int id)
+struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
+				     enum cxl_partition_mode mode, int id,
+				     struct cxl_pmem_region_params *pmem_params,
+				     struct cxl_decoder *cxld)
 {
 	int rc;
 
@@ -2613,8 +2725,12 @@ static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
 		return ERR_PTR(-EBUSY);
 	}
 
+	if (pmem_params)
+		return devm_cxl_pmem_add_region(cxlrd, id, mode,
+				CXL_DECODER_HOSTONLYMEM, pmem_params, cxld);
 	return devm_cxl_add_region(cxlrd, id, mode, CXL_DECODER_HOSTONLYMEM);
 }
+EXPORT_SYMBOL_NS_GPL(cxl_create_region, "CXL");
 
 static ssize_t create_region_store(struct device *dev, const char *buf,
 				   size_t len, enum cxl_partition_mode mode)
@@ -2627,7 +2743,7 @@ static ssize_t create_region_store(struct device *dev, const char *buf,
 	if (rc != 1)
 		return -EINVAL;
 
-	cxlr = __create_region(cxlrd, mode, id);
+	cxlr = cxl_create_region(cxlrd, mode, id, NULL, NULL);
 	if (IS_ERR(cxlr))
 		return PTR_ERR(cxlr);
 
@@ -3523,8 +3639,9 @@ static struct cxl_region *construct_region(struct cxl_root_decoder *cxlrd,
 	struct cxl_region *cxlr;
 
 	do {
-		cxlr = __create_region(cxlrd, cxlds->part[part].mode,
-				       atomic_read(&cxlrd->region_id));
+		cxlr = cxl_create_region(cxlrd, cxlds->part[part].mode,
+					 atomic_read(&cxlrd->region_id),
+					 NULL, NULL);
 	} while (IS_ERR(cxlr) && PTR_ERR(cxlr) == -EBUSY);
 
 	if (IS_ERR(cxlr)) {
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index b57597e55f7e..3abadc3dc82e 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -874,6 +874,10 @@ int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
 struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
 u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa);
 void cxl_region_discovery(struct cxl_port *port);
+struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
+				     enum cxl_partition_mode mode, int id,
+				     struct cxl_pmem_region_params *params,
+				     struct cxl_decoder *cxld);
 #else
 static inline bool is_cxl_pmem_region(struct device *dev)
 {
@@ -899,6 +903,14 @@ static inline u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint,
 static inline void cxl_region_discovery(struct cxl_port *port)
 {
 }
+static inline struct cxl_region *
+cxl_create_region(struct cxl_root_decoder *cxlrd,
+		  enum cxl_partition_mode mode, int id,
+		  struct cxl_pmem_region_params *params,
+		  struct cxl_decoder *cxld)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
 #endif
 
 void cxl_endpoint_parse_cdat(struct cxl_port *port);
-- 
2.34.1

