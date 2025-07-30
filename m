Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDEC29C339
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753877841; cv=none; b=s5u7ftAipdKBNVzkagatnW72cZDFYRLk/jI/wMPOk5xWQbWr6Iy4yQpZLJXir57IX66q0suG3WYIuPLqAcwkzCEK3YjKF67iJ1FkEUrJ8+kYwpNM9FktS0o/QJyHanwehpnpe5hpOPF5WGJr/dN6ssofmKAYz2fPw84+kntCj1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753877841; c=relaxed/simple;
	bh=kiObqaaB3YAWAFqSGi2dJoJB80ZPZqs0R3lvn5fHKPw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=b8TO8/z0iL0PMmBjn9DfeFuk14TubyZ83zA5whkBmvJ2PaSIFBbA92hLc0DDIekvPMaatQj9GRlsd2se2EG+fwhkbq1dGQTfe6njUbYdm9Xv734gFuGmr0Jpqpaw43GK0VkUbWMuTEmFlYUPEjfOBQ31GRkuHO/a/wH0f0hBxhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=DuWnCPup; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="DuWnCPup"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250730121717epoutp013c0050e2c07f408f3a6d3a47dc410f2f~XBpnOLxes1994619946epoutp01E
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:17:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250730121717epoutp013c0050e2c07f408f3a6d3a47dc410f2f~XBpnOLxes1994619946epoutp01E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753877837;
	bh=D4kHdnvSSF7noi2R85t1OTWYsztwRfeLuIw7vZA4rNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DuWnCPupcwb8KgaEgYardck9nF3V3iI/rUyaqoHbcFjuqvwTW8HU6XlfbrLCiGQ6N
	 bJ9MX/fg8oUGmDTjfKNIaYYYx9wkvjEvAoXr8Vz0r3DbgfKm3EhRC5aKrjOZdySyoA
	 DLTWFKOwNAKKWRplv4Z8l97Rqc1l6JNe2rWJXi7c=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250730121717epcas5p245760fc7b270fb8c0c67eeceadd50485~XBpm_jwaf2417924179epcas5p25;
	Wed, 30 Jul 2025 12:17:17 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.91]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bsWRw2YBYz3hhT7; Wed, 30 Jul
	2025 12:17:16 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250730121241epcas5p3e5708a89d764d1de9322fd759f921de0~XBllr_RIg0107801078epcas5p34;
	Wed, 30 Jul 2025 12:12:41 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250730121239epsmtip1826f4524111adab28e1fc08512b5cac7~XBlknIbEO0440404404epsmtip1_;
	Wed, 30 Jul 2025 12:12:39 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V2 14/20] cxl/region: Add devm_cxl_pmem_add_region() for
 pmem region creation
Date: Wed, 30 Jul 2025 17:42:03 +0530
Message-Id: <20250730121209.303202-15-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250730121209.303202-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250730121241epcas5p3e5708a89d764d1de9322fd759f921de0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121241epcas5p3e5708a89d764d1de9322fd759f921de0
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121241epcas5p3e5708a89d764d1de9322fd759f921de0@epcas5p3.samsung.com>

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

Also created some helper routines and refactored dpa_size_store(),
commit_store() to avoid duplicate code usage in devm_cxl_pmem_add_region()

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/core/core.h   |   1 +
 drivers/cxl/core/port.c   |  29 ++++++----
 drivers/cxl/core/region.c | 118 +++++++++++++++++++++++++++++++++-----
 drivers/cxl/cxl.h         |  12 ++++
 4 files changed, 134 insertions(+), 26 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 2669f251d677..80c83e0117c6 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -94,6 +94,7 @@ int cxl_dpa_free(struct cxl_endpoint_decoder *cxled);
 resource_size_t cxl_dpa_size(struct cxl_endpoint_decoder *cxled);
 resource_size_t cxl_dpa_resource_start(struct cxl_endpoint_decoder *cxled);
 bool cxl_resource_contains_addr(const struct resource *res, const resource_size_t addr);
+ssize_t resize_or_free_dpa(struct cxl_endpoint_decoder *cxled, u64 size);
 
 enum cxl_rcrb {
 	CXL_RCRB_DOWNSTREAM,
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 29197376b18e..ba743e31f721 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -243,16 +243,9 @@ static ssize_t dpa_size_show(struct device *dev, struct device_attribute *attr,
 	return sysfs_emit(buf, "%pa\n", &size);
 }
 
-static ssize_t dpa_size_store(struct device *dev, struct device_attribute *attr,
-			      const char *buf, size_t len)
+ssize_t resize_or_free_dpa(struct cxl_endpoint_decoder *cxled, u64 size)
 {
-	struct cxl_endpoint_decoder *cxled = to_cxl_endpoint_decoder(dev);
-	unsigned long long size;
-	ssize_t rc;
-
-	rc = kstrtoull(buf, 0, &size);
-	if (rc)
-		return rc;
+	int rc;
 
 	if (!IS_ALIGNED(size, SZ_256M))
 		return -EINVAL;
@@ -262,9 +255,23 @@ static ssize_t dpa_size_store(struct device *dev, struct device_attribute *attr,
 		return rc;
 
 	if (size == 0)
-		return len;
+		return 0;
+
+	return cxl_dpa_alloc(cxled, size);
+}
+
+static ssize_t dpa_size_store(struct device *dev, struct device_attribute *attr,
+			      const char *buf, size_t len)
+{
+	struct cxl_endpoint_decoder *cxled = to_cxl_endpoint_decoder(dev);
+	unsigned long long size;
+	ssize_t rc;
+
+	rc = kstrtoull(buf, 0, &size);
+	if (rc)
+		return rc;
 
-	rc = cxl_dpa_alloc(cxled, size);
+	rc = resize_or_free_dpa(cxled, size);
 	if (rc)
 		return rc;
 
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index eef501f3384c..8578e046aa78 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -703,6 +703,23 @@ static int free_hpa(struct cxl_region *cxlr)
 	return 0;
 }
 
+static ssize_t resize_or_free_region_hpa(struct cxl_region *cxlr, u64 size)
+{
+	int rc;
+
+	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
+	rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem);
+	if (rc)
+		return rc;
+
+	if (size)
+		rc = alloc_hpa(cxlr, size);
+	else
+		rc = free_hpa(cxlr);
+
+	return rc;
+}
+
 static ssize_t size_store(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t len)
 {
@@ -714,15 +731,7 @@ static ssize_t size_store(struct device *dev, struct device_attribute *attr,
 	if (rc)
 		return rc;
 
-	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
-	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem)))
-		return rc;
-
-	if (val)
-		rc = alloc_hpa(cxlr, val);
-	else
-		rc = free_hpa(cxlr);
-
+	rc = resize_or_free_region_hpa(cxlr, val);
 	if (rc)
 		return rc;
 
@@ -2569,6 +2578,76 @@ static struct cxl_region *devm_cxl_add_region(struct cxl_root_decoder *cxlrd,
 	return ERR_PTR(rc);
 }
 
+static struct cxl_region *
+devm_cxl_pmem_add_region(struct cxl_root_decoder *cxlrd,
+			 int id,
+			 enum cxl_partition_mode mode,
+			 enum cxl_decoder_type type,
+			 struct cxl_pmem_region_params *params,
+			 struct cxl_decoder *cxld)
+{
+	struct cxl_port *root_port;
+	struct cxl_region *cxlr;
+	struct cxl_endpoint_decoder *cxled;
+	struct cxl_region_params *p;
+	struct device *dev;
+	int rc;
+
+	cxlr = cxl_region_alloc(cxlrd, id);
+	if (IS_ERR(cxlr))
+		return cxlr;
+	cxlr->mode = mode;
+	cxlr->type = type;
+
+	dev = &cxlr->dev;
+	rc = dev_set_name(dev, "region%d", id);
+	if (rc)
+		goto err;
+
+	p = &cxlr->params;
+	p->uuid = params->uuid;
+	p->interleave_ways = params->nlabel;
+	p->interleave_granularity = params->ig;
+
+	if (resize_or_free_region_hpa(cxlr, params->rawsize))
+		goto err;
+
+	cxled = to_cxl_endpoint_decoder(&cxld->dev);
+	if (resize_or_free_dpa(cxled, 0))
+		goto err;
+
+	if (cxl_dpa_set_part(cxled, CXL_PARTMODE_PMEM))
+		goto err;
+
+	if (resize_or_free_dpa(cxled, params->rawsize))
+		goto err;
+
+	/* Attaching only one target due to interleave_way == 1 */
+	if (attach_target(cxlr, cxled, params->position, TASK_INTERRUPTIBLE))
+		goto err;
+
+	if (__commit(cxlr))
+		goto err;
+
+	rc = device_add(dev);
+	if (rc)
+		goto err;
+
+	root_port = to_cxl_port(cxlrd->cxlsd.cxld.dev.parent);
+	rc = devm_add_action_or_reset(root_port->uport_dev,
+			unregister_region, cxlr);
+	if (rc)
+		return ERR_PTR(rc);
+
+	dev_dbg(root_port->uport_dev, "%s: created %s\n",
+		dev_name(&cxlrd->cxlsd.cxld.dev), dev_name(dev));
+	return cxlr;
+
+err:
+	put_device(dev);
+	return ERR_PTR(rc);
+}
+
 static ssize_t __create_region_show(struct cxl_root_decoder *cxlrd, char *buf)
 {
 	return sysfs_emit(buf, "region%u\n", atomic_read(&cxlrd->region_id));
@@ -2586,8 +2665,10 @@ static ssize_t create_ram_region_show(struct device *dev,
 	return __create_region_show(to_cxl_root_decoder(dev), buf);
 }
 
-static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
-					  enum cxl_partition_mode mode, int id)
+struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
+				     enum cxl_partition_mode mode, int id,
+				     struct cxl_pmem_region_params *params,
+				     struct cxl_decoder *cxld)
 {
 	int rc;
 
@@ -2609,8 +2690,14 @@ static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
 		return ERR_PTR(-EBUSY);
 	}
 
-	return devm_cxl_add_region(cxlrd, id, mode, CXL_DECODER_HOSTONLYMEM);
+	if (params)
+		return devm_cxl_pmem_add_region(cxlrd, id, mode,
+				CXL_DECODER_HOSTONLYMEM, params, cxld);
+	else
+		return devm_cxl_add_region(cxlrd, id, mode,
+				CXL_DECODER_HOSTONLYMEM);
 }
+EXPORT_SYMBOL_NS_GPL(cxl_create_region, "CXL");
 
 static ssize_t create_region_store(struct device *dev, const char *buf,
 				   size_t len, enum cxl_partition_mode mode)
@@ -2623,7 +2710,7 @@ static ssize_t create_region_store(struct device *dev, const char *buf,
 	if (rc != 1)
 		return -EINVAL;
 
-	cxlr = __create_region(cxlrd, mode, id);
+	cxlr = cxl_create_region(cxlrd, mode, id, NULL, NULL);
 	if (IS_ERR(cxlr))
 		return PTR_ERR(cxlr);
 
@@ -3414,8 +3501,9 @@ static struct cxl_region *construct_region(struct cxl_root_decoder *cxlrd,
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
index 6edcec95e9ba..129db2e49aa7 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -865,6 +865,10 @@ int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
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
@@ -890,6 +894,14 @@ static inline u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint,
 static inline void cxl_region_discovery(struct cxl_port *port)
 {
 }
+static inline struct cxl_region *
+cxl_create_region(struct cxl_root_decoder *cxlrd,
+		  enum cxl_partition_mode mode, int id,
+		  struct cxl_pmem_region_params *params,
+		  struct cxl_decoder *cxld)
+{
+	return NULL;
+}
 #endif
 
 void cxl_endpoint_parse_cdat(struct cxl_port *port);
-- 
2.34.1

