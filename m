Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7422B32ED53
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763538813; cv=none; b=mi8EAOYFaQ4f/c7Me44bUO+ADKfmJXrXIIzWrJIzYagW2+FIGKv/Y/GYN2nKZVE4HvYZnEJpdj6s+GqxGFDsyym1ODwwi0hjcTnHJSp2IN2NMW5E8FRhHVLURIixJLjuqkklf0ap9XJB48/kpowWwxrxZC6qsz9D20BOkGaCs64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763538813; c=relaxed/simple;
	bh=ddqsAoildU29bgw12poMrTNGEm2wd9LLl2mU0azwNTg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=QHJRksqV5a/90MGHj7KjAjyj1uUDdcSGaHj5MBdVMVi6qwPNw88vOoBcMNyN5z2bLfPwfq0/Ifbs1no0QyAq+2I9BGkG/oXe4gpbf7hAVbEz3glUfzq+c7NqBY5pRkqaL5C9LK/lNs9HzMfomX9ts+HQAFTRvP/qIi732jNXoWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=CGHgo/Fg; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CGHgo/Fg"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20251119075329epoutp01452207959cc3d87f557ad99afbcd9bbe~5WTQX_31i3209832098epoutp01m
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20251119075329epoutp01452207959cc3d87f557ad99afbcd9bbe~5WTQX_31i3209832098epoutp01m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1763538809;
	bh=TMmzIrOMVYX+K4e/SmF/lOkxVcUq2FEcYqKgyP4Jo8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGHgo/FgpbaE4QG4qhRscSo9+EvMBhd9nC9QadmLBlvrd9ncCkXvgfdGNbmNyNt9Z
	 g9hhUdLRNXL2P/O+ZUFR6AIuskkBtx0G0ZwI3sRCV0dO5xSZWxybRL0F3+bKwiIO0w
	 zeV/yLAKlQOMHIZX+H99EMuMQ5oCT2uSKVaQY+ps=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251119075329epcas5p3c6477e07762f44b8abd3a3f81c007aa9~5WTQHsSXc0364303643epcas5p3n;
	Wed, 19 Nov 2025 07:53:29 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.94]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dBDHr0Cdhz2SSKf; Wed, 19 Nov
	2025 07:53:28 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20251119075327epcas5p29991fec95ca8a26503f457a30bb2429a~5WTOgFtar0912909129epcas5p2Q;
	Wed, 19 Nov 2025 07:53:27 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251119075325epsmtip11383e765cc6ba195188097c155d01016~5WTMdV8iq2573225732epsmtip16;
	Wed, 19 Nov 2025 07:53:25 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V4 11/17] cxl/region: Add devm_cxl_pmem_add_region() for
 pmem region creation
Date: Wed, 19 Nov 2025 13:22:49 +0530
Message-Id: <20251119075255.2637388-12-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251119075255.2637388-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251119075327epcas5p29991fec95ca8a26503f457a30bb2429a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075327epcas5p29991fec95ca8a26503f457a30bb2429a
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075327epcas5p29991fec95ca8a26503f457a30bb2429a@epcas5p2.samsung.com>

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

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/core/core.h   |  12 ++++
 drivers/cxl/core/region.c | 124 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 131 insertions(+), 5 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 1fb66132b777..fde96507cb75 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -42,6 +42,10 @@ int cxl_get_poison_by_endpoint(struct cxl_port *port);
 struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa);
 u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
 		   u64 dpa);
+struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
+				     enum cxl_partition_mode mode, int id,
+				     struct cxl_pmem_region_params *params,
+				     struct cxl_decoder *cxld);
 
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
+		  struct cxl_decoder *cxld)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
 #define CXL_REGION_ATTR(x) NULL
 #define CXL_REGION_TYPE(x) NULL
 #define SET_CXL_REGION_ATTR(x)
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 3c868c4de4ec..06a75f0a8e9b 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2618,6 +2618,114 @@ static struct cxl_region *devm_cxl_add_region(struct cxl_root_decoder *cxlrd,
 	return ERR_PTR(rc);
 }
 
+static ssize_t alloc_region_hpa(struct cxl_region *cxlr, u64 size)
+{
+	int rc;
+
+	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
+	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem)))
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
+			 struct cxl_pmem_region_params *params,
+			 struct cxl_decoder *cxld,
+			 enum cxl_decoder_type type)
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
+	cxlr->mode = CXL_PARTMODE_PMEM;
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
@@ -2635,8 +2743,10 @@ static ssize_t create_ram_region_show(struct device *dev,
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
 
@@ -2658,6 +2768,9 @@ static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
 		return ERR_PTR(-EBUSY);
 	}
 
+	if (pmem_params)
+		return devm_cxl_pmem_add_region(cxlrd, id, pmem_params, cxld,
+						CXL_DECODER_HOSTONLYMEM);
 	return devm_cxl_add_region(cxlrd, id, mode, CXL_DECODER_HOSTONLYMEM);
 }
 
@@ -2672,7 +2785,7 @@ static ssize_t create_region_store(struct device *dev, const char *buf,
 	if (rc != 1)
 		return -EINVAL;
 
-	cxlr = __create_region(cxlrd, mode, id);
+	cxlr = cxl_create_region(cxlrd, mode, id, NULL, NULL);
 	if (IS_ERR(cxlr))
 		return PTR_ERR(cxlr);
 
@@ -3641,8 +3754,9 @@ static struct cxl_region *construct_region(struct cxl_root_decoder *cxlrd,
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

