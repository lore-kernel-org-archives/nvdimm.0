Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A78E331A73
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763538823; cv=none; b=WDfSkKP9d2LeviOS+T8N5MfiYAvU+RpPjop5WCTjpi8klzNL1lBd6FjL6FaTEN38arlt6Z+bW0gGvXOOq1481Gs37BNo7vRjSspzX9USe2l/QpQPNsal0fYGZjOi2fxuwFrv0wzmVV/kgU+cUv9VTAnuEdFuot69tsYHzEaMe2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763538823; c=relaxed/simple;
	bh=jTMYQUiv8Am1QQGYwohPmbAwti7mjegWK51W92U8wCg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=K8DQhFnnE+9l18X5aFbM4vbBZ4yupv3B3ypsxB5khY5fDLQO3tC0C0RLWu5fbv240+HEb1sdBXJvVo2ciHs0j7WW1pzuIItjUvrfekhURrDGsn9v9ku1Z6pLYg9RhjCImM04jnb1hKZPh918jDc2wqxKCAPC+wp6oQK2y9kOAp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=HiH0zYwT; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="HiH0zYwT"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20251119075339epoutp02031a7aba161ac83aad88d8b5c1ca815e~5WTZ51-i32602426024epoutp02A
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20251119075339epoutp02031a7aba161ac83aad88d8b5c1ca815e~5WTZ51-i32602426024epoutp02A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1763538819;
	bh=TzalgRoEh+zoqHT1Bybxnd725dsC8LlneSqErpOEjAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HiH0zYwTmEfp5EJXIxzjUiSBjTMxNRQAhgF7HActWLbY3ghkwGrtkxd70DsTimLNR
	 t8glRd/m0flm9KEpRX25uVE2qaMSr9LkqlbhhtZZEwJ8KgO5OWRDPOrbnuAXuaEPXa
	 lNqQ1uzI/ANKH5rOREBtHX8sLDOhEhtfeV4LWZb8=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20251119075339epcas5p4cadadafe28c6e26a365f912052efe7de~5WTZqV2Lq3148931489epcas5p4h;
	Wed, 19 Nov 2025 07:53:39 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.89]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dBDJ224zFz3hhT7; Wed, 19 Nov
	2025 07:53:38 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20251119075337epcas5p2cb576137ca33d6304add4e1ba0b2bdc1~5WTYSKkoB1868418684epcas5p2B;
	Wed, 19 Nov 2025 07:53:37 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251119075335epsmtip18fb5b180f316c3e498067ad94ae78a22~5WTV48C1j2566025660epsmtip1h;
	Wed, 19 Nov 2025 07:53:35 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V4 15/17] cxl/pmem_region: Add sysfs attribute cxl region
 label updation/deletion
Date: Wed, 19 Nov 2025 13:22:53 +0530
Message-Id: <20251119075255.2637388-16-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251119075255.2637388-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251119075337epcas5p2cb576137ca33d6304add4e1ba0b2bdc1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075337epcas5p2cb576137ca33d6304add4e1ba0b2bdc1
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075337epcas5p2cb576137ca33d6304add4e1ba0b2bdc1@epcas5p2.samsung.com>

Using these attributes region label is added/deleted into LSA. These
attributes are called from userspace (ndctl) after region creation.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 Documentation/ABI/testing/sysfs-bus-cxl | 22 ++++++
 drivers/cxl/core/pmem_region.c          | 93 ++++++++++++++++++++++++-
 drivers/cxl/cxl.h                       |  7 ++
 3 files changed, 121 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index c80a1b5a03db..76d79c03dde4 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -624,3 +624,25 @@ Description:
 		The count is persistent across power loss and wraps back to 0
 		upon overflow. If this file is not present, the device does not
 		have the necessary support for dirty tracking.
+
+
+What:		/sys/bus/cxl/devices/regionZ/pmem_regionZ/region_label_update
+Date:		Nov, 2025
+KernelVersion:	v6.19
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RW) Write a boolean 'true' string value to this attribute to
+		update cxl region information into LSA as region label. It
+		uses nvdimm nd_region_label_update() to update cxl region
+		information saved during cxl region creation into LSA. This
+		attribute must be called at last during cxl region creation.
+
+
+What:		/sys/bus/cxl/devices/regionZ/pmem_regionZ/region_label_delete
+Date:		Nov, 2025
+KernelVersion:	v6.19
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(WO) When a boolean 'true' is written to this attribute then
+		pmem_region driver deletes cxl region label from LSA using
+		nvdimm nd_region_label_delete()
diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
index b45e60f04ff4..be4feb73aafc 100644
--- a/drivers/cxl/core/pmem_region.c
+++ b/drivers/cxl/core/pmem_region.c
@@ -30,9 +30,100 @@ static void cxl_pmem_region_release(struct device *dev)
 	kfree(cxlr_pmem);
 }
 
+static ssize_t region_label_update_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t len)
+{
+	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
+	struct cxl_region *cxlr = cxlr_pmem->cxlr;
+	ssize_t rc;
+	bool update;
+
+	rc = kstrtobool(buf, &update);
+	if (rc)
+		return rc;
+
+	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
+	rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem);
+	if (rc)
+		return rc;
+
+	/* Region not yet committed */
+	if (update && cxlr && cxlr->params.state != CXL_CONFIG_COMMIT) {
+		dev_dbg(dev, "region not committed, can't update into LSA\n");
+		return -ENXIO;
+	}
+
+	if (!cxlr || !cxlr->cxlr_pmem || !cxlr->cxlr_pmem->nd_region)
+		return 0;
+
+	rc = nd_region_label_update(cxlr->cxlr_pmem->nd_region);
+	if (rc)
+		return rc;
+
+	cxlr->params.state_region_label = CXL_REGION_LABEL_ACTIVE;
+
+	return len;
+}
+
+static ssize_t region_label_update_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
+	struct cxl_region *cxlr = cxlr_pmem->cxlr;
+	struct cxl_region_params *p = &cxlr->params;
+	ssize_t rc;
+
+	ACQUIRE(rwsem_read_intr, rwsem)(&cxl_rwsem.region);
+	rc = ACQUIRE_ERR(rwsem_read_intr, &rwsem);
+	if (rc)
+		return rc;
+
+	return sysfs_emit(buf, "%d\n", p->state_region_label);
+}
+static DEVICE_ATTR_RW(region_label_update);
+
+static ssize_t region_label_delete_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t len)
+{
+	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
+	struct cxl_region *cxlr = cxlr_pmem->cxlr;
+	ssize_t rc;
+
+	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
+	rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem);
+	if (rc)
+		return rc;
+
+	if (!cxlr && !cxlr->cxlr_pmem && !cxlr->cxlr_pmem->nd_region)
+		return 0;
+
+	rc = nd_region_label_delete(cxlr->cxlr_pmem->nd_region);
+	if (rc)
+		return rc;
+
+	cxlr->params.state_region_label = CXL_REGION_LABEL_INACTIVE;
+
+	return len;
+}
+static DEVICE_ATTR_WO(region_label_delete);
+
+static struct attribute *cxl_pmem_region_attrs[] = {
+	&dev_attr_region_label_update.attr,
+	&dev_attr_region_label_delete.attr,
+	NULL
+};
+
+static struct attribute_group cxl_pmem_region_group = {
+	.attrs = cxl_pmem_region_attrs,
+};
+
 static const struct attribute_group *cxl_pmem_region_attribute_groups[] = {
 	&cxl_base_attribute_group,
-	NULL,
+	&cxl_pmem_region_group,
+	NULL
 };
 
 const struct device_type cxl_pmem_region_type = {
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 6ac3b40cb5ff..8c76c4a981bf 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -473,9 +473,15 @@ enum cxl_config_state {
 	CXL_CONFIG_COMMIT,
 };
 
+enum region_label_state {
+	CXL_REGION_LABEL_INACTIVE,
+	CXL_REGION_LABEL_ACTIVE,
+};
+
 /**
  * struct cxl_region_params - region settings
  * @state: allow the driver to lockdown further parameter changes
+ * @state: region label state
  * @uuid: unique id for persistent regions
  * @interleave_ways: number of endpoints in the region
  * @interleave_granularity: capacity each endpoint contributes to a stripe
@@ -488,6 +494,7 @@ enum cxl_config_state {
  */
 struct cxl_region_params {
 	enum cxl_config_state state;
+	enum region_label_state state_region_label;
 	uuid_t uuid;
 	int interleave_ways;
 	int interleave_granularity;
-- 
2.34.1

