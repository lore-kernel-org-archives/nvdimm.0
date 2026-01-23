Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D39C385506
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769167915; cv=none; b=LClHTuNwTiD2C+h+JOXxYJQXVUT2Fm/UXqSnuGqnK1J/8/GezUdBYCUERAl0xpPRuIlgb2J6zEXadDwTCNlHGJTZXvt+yGTBsAdF8rM3wwJ77lxpmxYBT6qNiijZhyZ+XmPsi9LgnVk6dn5vLUMPtrfXOKm1qSEVtCeEPSrG4Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769167915; c=relaxed/simple;
	bh=+2siN0dvDCPFtNbIgNZBKQyzkTRL5yXcRjVlmdA43c0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Pj5eZLqa+Vkb72yqfJOSKd8uex62hnPLeKY1vnQXPbUs5LI2NazS7UeUYOSWTlCbMYBuVAQbjNtZxLJEjyt/GNzwiMz7nlcfZxJlBiFXm9f9RSc72PBC2E8494j60Oo59cD5BMYTDPtfy3ztq9LLb/oe/aFVObAmN2Y6PBLyxGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=B1BbQbEE; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="B1BbQbEE"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260123113150epoutp02c978f0e803d40b9c7cbd7c4a8bfd6b57~NWNdDgmpT0069700697epoutp02m
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260123113150epoutp02c978f0e803d40b9c7cbd7c4a8bfd6b57~NWNdDgmpT0069700697epoutp02m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769167910;
	bh=2nCu0F8Ca6ps/usVx8k0KaFrFchNzhmkBjKX5T8KSmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1BbQbEEoFmThB7+FrzRHkahWh3GH40kmaoR20HYCpUnRSKaxGjVheM2U/6kPlZPk
	 C9j5kS99uQlq8SjLhxi6dzlm0ls3zpkrV12JnlxjfGAlpmxFAil/Ka/eZYxs3tO3Uh
	 an5zQphmkzZZALOvwQBUz7MrxKs0DAKQiOs+lqN0=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260123113149epcas5p1a63df62daa60bc997338a40cfd33ac1b~NWNcvMVoz2764227642epcas5p1W;
	Fri, 23 Jan 2026 11:31:49 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.87]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dyG3n1D2lz6B9m7; Fri, 23 Jan
	2026 11:31:49 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260123113147epcas5p39e1e5e148faaf7e47b40516cfef3de61~NWNa2W5_E2902429024epcas5p3X;
	Fri, 23 Jan 2026 11:31:47 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260123113146epsmtip23168efe14701d25905f4744d91f4d715~NWNZoJbaA2681126811epsmtip2n;
	Fri, 23 Jan 2026 11:31:46 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V6 16/18] cxl/pmem_region: Add sysfs attribute cxl region
 label updation/deletion
Date: Fri, 23 Jan 2026 17:01:10 +0530
Message-Id: <20260123113112.3488381-17-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260123113112.3488381-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260123113147epcas5p39e1e5e148faaf7e47b40516cfef3de61
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260123113147epcas5p39e1e5e148faaf7e47b40516cfef3de61
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
	<CGME20260123113147epcas5p39e1e5e148faaf7e47b40516cfef3de61@epcas5p3.samsung.com>

Using these attributes region label is added/deleted into LSA. These
attributes are called from userspace (ndctl) after region creation.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 Documentation/ABI/testing/sysfs-bus-cxl | 22 +++++++
 drivers/cxl/core/pmem_region.c          | 88 +++++++++++++++++++++++++
 drivers/cxl/cxl.h                       |  7 ++
 3 files changed, 117 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index c80a1b5a03db..e42213c9b030 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -624,3 +624,25 @@ Description:
 		The count is persistent across power loss and wraps back to 0
 		upon overflow. If this file is not present, the device does not
 		have the necessary support for dirty tracking.
+
+
+What:		/sys/bus/cxl/devices/regionZ/pmem_regionZ/region_label_update
+Date:		Jan, 2026
+KernelVersion:	v7.0
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RW) Write a boolean 'true' string value to this attribute to
+		update cxl region information into LSA as region label. It is
+		used to update cxl region information saved during cxl region
+		creation into LSA. This attribute must be written last during
+		cxl region creation. Reading this attribute indicates whether
+		the region label is active or not.
+
+
+What:		/sys/bus/cxl/devices/regionZ/pmem_regionZ/region_label_delete
+Date:		Jan, 2026
+KernelVersion:	v7.0
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(WO) When a boolean 'true' is written to this attribute then
+		pmem_region driver deletes cxl region label from LSA.
diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
index dcaab59108fd..53d3d81e9676 100644
--- a/drivers/cxl/core/pmem_region.c
+++ b/drivers/cxl/core/pmem_region.c
@@ -29,8 +29,96 @@ static void cxl_pmem_region_release(struct device *dev)
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
+	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem)))
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
+	if ((rc = ACQUIRE_ERR(rwsem_read_intr, &rwsem)))
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
+	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem)))
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
+	&cxl_pmem_region_group,
 	NULL
 };
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 296411be1c36..32a8296a833a 100644
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
+ * @state_region_label: region label state information
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

