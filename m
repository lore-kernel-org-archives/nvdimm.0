Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB7F330D2E
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115856; cv=none; b=pIC0RboHBjO9toT2ZtAwEliPTj2ARIpz4h+ZWZX2xfL4amME5r7Kt6R0mdi1D4cm1zami9pEMnhjF7Leru5O6jwzB88oZ2m6cP/28MO19FhWXO1Rst1BHd0XMwqxPGk7KfsqdsvLa1l8xDhBC6gYiTXQZCPLqgIiKuNYxxtegxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115856; c=relaxed/simple;
	bh=6wBoep2iJJ3gbOo/sNXpIeAC6OyR+6x9/eGgpld/Vds=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=RpJi5dpmrFie460360goR1+VVs8mOFBU4YsZxOYszdptuDNUfTHOOO87M42tUUijMEbXi7PyyU5ocwEwd/JFqr/9sFKS4IAzTDasFrDviwDcq2AsdWUNaYELo5nmLr35/Ny2BAo/4skLfZBEj6TJ7HFtMOIXGy8mVXPk0h1cq34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=pgbf050K; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="pgbf050K"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250917133051epoutp0466d086d66ea07c43b875bc60d19b95b2~mFQ1tr8Dr2372623726epoutp04c
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250917133051epoutp0466d086d66ea07c43b875bc60d19b95b2~mFQ1tr8Dr2372623726epoutp04c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758115851;
	bh=ZcTfZKgynno2dRGhPfNpKZtAAtwys9IWfg2QaYJnRDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgbf050KZQEJBwFVkZkYTvTlKo2WmaVLMWlCfXj00aZHPa54xNohlS0H6zIpYi3q2
	 zcBC7NyA7pYYCBsJhLaZHPpVnbLckQIUlYaxQpy1iDLelvyS4vE9A7si99tPgYl/xM
	 Klc4pQ4W7W5WIEaWcaYCuGR8HHOPhDULwlzNKhMk=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250917133051epcas5p250fb6e2d79537b0fc4ebf3be81489b4b~mFQ1ev6W70362603626epcas5p2f;
	Wed, 17 Sep 2025 13:30:51 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.90]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cRfmB4qzNz6B9m6; Wed, 17 Sep
	2025 13:30:50 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250917133050epcas5p3979792644e47ee94956bcf00c84a832e~mFQ0Gjzi-0741707417epcas5p3C;
	Wed, 17 Sep 2025 13:30:50 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250917133048epsmtip1e96b0fe78c94b22966194e070ca740ea~mFQy9SBwc0528305283epsmtip1l;
	Wed, 17 Sep 2025 13:30:48 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 14/20] cxl/region: Add devm_cxl_pmem_add_region() for
 pmem region creation
Date: Wed, 17 Sep 2025 18:59:34 +0530
Message-Id: <20250917132940.1566437-15-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917132940.1566437-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917133050epcas5p3979792644e47ee94956bcf00c84a832e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917133050epcas5p3979792644e47ee94956bcf00c84a832e
References: <20250917132940.1566437-1-s.neeraj@samsung.com>
	<CGME20250917133050epcas5p3979792644e47ee94956bcf00c84a832e@epcas5p3.samsung.com>

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

