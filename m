Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A232BD032
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753877869; cv=none; b=EkHZrio8DeytNjdj3iELGh8RTeWl9ZAnJ9ZQEijrPa2sMwm4nHfiQ7JF1CiDKUtu5OXg2G3ucljQswDDvm16UtUG73hg2jw8WiWGuIm0jQRYh8gBxlD+TvodA+ZMeCaoQXRWeL3wtRJzP+pLh+Gpu1iNxRlFXXKiPJBX+zzdhC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753877869; c=relaxed/simple;
	bh=+tfJ6kmI5TyWd3CwPGoTz3jWuNKpu0Bg1vj5zTULf+c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=i07eEhEOdQTGzsnBTDoixOVHG1mkONo6tfd3ONcbXOfgTu+20o2D/btQ5Sw/IIoEeeN5UHo/WILDDghm1/k0QQ04BEruYBVx2Bxiocj2+O++GmzQHtoCfEkXog5FHBI28BgbAv8EcjMDXZnd/wuUa8B1woSoVQEsCJlXz0h+008=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=k9mAIX15; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="k9mAIX15"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250730121746epoutp0179a4a959e66bb4e152e8423152fe9983~XBqBu0KUq1994619946epoutp01N
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:17:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250730121746epoutp0179a4a959e66bb4e152e8423152fe9983~XBqBu0KUq1994619946epoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753877866;
	bh=tr+z8UkyvssMX2E0j//VujZShPXWDtOnp74X2w/XQTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9mAIX15KGIBncZOsXLfylxopm9B1mCLXn/PvCmTAqOJfdn07qAlwF3BK6sV4qXZc
	 omG4ZkPaFXtlO8yYMSXQVezPRNZ9IgQJvqv4fGYKAs+H7BlQtG5YZbytuW8FXB4WKZ
	 ZFiyzBF4cu5TXimcQXUY5RwvcQvu/ua8+C+tgVC8=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250730121742epcas5p320273f99e305038dc6257047c093693f~XBp_ylszK2824128241epcas5p3w;
	Wed, 30 Jul 2025 12:17:42 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.89]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bsWSP6Rg5z3hhT3; Wed, 30 Jul
	2025 12:17:41 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250730121249epcas5p249c2e3fec3464cfea3a1c84bc285cd49~XBltWzLs70097800978epcas5p2p;
	Wed, 30 Jul 2025 12:12:49 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250730121248epsmtip1b44e851ee72a608296b27f03b1168fdd~XBlsUBEkq0450704507epsmtip1V;
	Wed, 30 Jul 2025 12:12:48 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V2 20/20] cxl/pmem_region: Add sysfs attribute cxl region
 label updation/deletion
Date: Wed, 30 Jul 2025 17:42:09 +0530
Message-Id: <20250730121209.303202-21-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250730121209.303202-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250730121249epcas5p249c2e3fec3464cfea3a1c84bc285cd49
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121249epcas5p249c2e3fec3464cfea3a1c84bc285cd49
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121249epcas5p249c2e3fec3464cfea3a1c84bc285cd49@epcas5p2.samsung.com>

Using these attributes region label is added/deleted into LSA. These
attributes are called from userspace (ndctl) after region creation.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 Documentation/ABI/testing/sysfs-bus-cxl | 22 ++++++
 drivers/cxl/core/pmem_region.c          | 94 ++++++++++++++++++++++++-
 drivers/cxl/cxl.h                       |  1 +
 3 files changed, 116 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 6b4e8c7a963d..5b47a02a99ef 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -615,3 +615,25 @@ Description:
 		The count is persistent across power loss and wraps back to 0
 		upon overflow. If this file is not present, the device does not
 		have the necessary support for dirty tracking.
+
+
+What:		/sys/bus/cxl/devices/regionZ/pmem_regionZ/region_label_update
+Date:		July, 2025
+KernelVersion:	v6.16
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
+Date:		July, 2025
+KernelVersion:	v6.16
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(WO) When a boolean 'true' is written to this attribute then
+		pmem_region driver deletes cxl region label from LSA using
+		nvdimm nd_region_label_delete()
diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
index cd1177d345e6..cc9ef2f9a2b3 100644
--- a/drivers/cxl/core/pmem_region.c
+++ b/drivers/cxl/core/pmem_region.c
@@ -45,9 +45,101 @@ static void cxl_pmem_region_release(struct device *dev)
 	kfree(cxlr_pmem);
 }
 
+static ssize_t region_label_update_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t len)
+{
+	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
+	struct cxl_region *cxlr = cxlr_pmem->cxlr;
+	struct cxl_region_params *p = &cxlr->params;
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
+	if (update && p->state != CXL_CONFIG_COMMIT) {
+		dev_dbg(dev, "region not committed, can't update into LSA\n");
+		return -ENXIO;
+	}
+
+	if (cxlr && cxlr->cxlr_pmem && cxlr->cxlr_pmem->nd_region) {
+		rc = nd_region_label_update(cxlr->cxlr_pmem->nd_region);
+		if (!rc)
+			p->region_label_state = 1;
+	}
+
+	if (rc)
+		return rc;
+
+	return len;
+}
+
+static ssize_t region_label_update_show(struct device *dev,
+		struct device_attribute *attr,
+		char *buf)
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
+	return sysfs_emit(buf, "%d\n", p->region_label_state);
+}
+static DEVICE_ATTR_RW(region_label_update);
+
+static ssize_t region_label_delete_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t len)
+{
+	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
+	struct cxl_region *cxlr = cxlr_pmem->cxlr;
+	struct cxl_region_params *p = &cxlr->params;
+	ssize_t rc;
+
+	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
+	rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem);
+	if (rc)
+		return rc;
+
+	if (cxlr && cxlr->cxlr_pmem && cxlr->cxlr_pmem->nd_region) {
+		rc = nd_region_label_delete(cxlr->cxlr_pmem->nd_region);
+		if (rc)
+			return rc;
+	}
+
+	p->region_label_state = 0;
+
+	return len;
+}
+DEVICE_ATTR_WO(region_label_delete);
+
+static struct attribute *cxl_pmem_region_attrs[] = {
+	&dev_attr_region_label_update.attr,
+	&dev_attr_region_label_delete.attr,
+	NULL
+};
+
+struct attribute_group cxl_pmem_region_group = {
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
index b7592cc76192..f3faa419ddc5 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -475,6 +475,7 @@ enum cxl_config_state {
  */
 struct cxl_region_params {
 	enum cxl_config_state state;
+	int region_label_state;
 	uuid_t uuid;
 	int interleave_ways;
 	int interleave_granularity;
-- 
2.34.1

