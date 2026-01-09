Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4356035F8A2
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962736; cv=none; b=mHv1HJLrAAT9/LmeGOKopsAo13oFR4XZKoyFz/2iavY4VEQNz5H8VjsW8yxl1jezH1ylipYqj11Psekp7AwEDULZ+9kuiU9v1b7YKe0OLz57/4H74m7QVkg6Omdtv5QLJRB3d6iT89sIqNUyUbLPBMvh6sSy4gy1U5Y02Mr72AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962736; c=relaxed/simple;
	bh=KHQP1Ri5R5r961NvMzWeFoCFfxmrNpKFaJKeimQ5gkg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=KensIc22nCHWd3pKkJBlPhOkl307yJpLGw2gaNnfO+N7J2xS5/SGHZbqO6Z6aRIZ5ud6xU6ChN5tWvZiGW9hOrVq4boy7Bm54FrNwNFfY3W2ZRS6nEtWaxWK6s9jrI5KSGzzmGbaKjamOlC52tt9THzREHClxzqiTZ1qb8RveLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=sMI1RfU7; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="sMI1RfU7"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260109124532epoutp049a63b2180c85936976eacca94b68658e~JEL0I1yrd0571205712epoutp04P
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260109124532epoutp049a63b2180c85936976eacca94b68658e~JEL0I1yrd0571205712epoutp04P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767962732;
	bh=+aRZfdCXYDuTDq7UU5fYBpXy51NIcZ3A0+f+Fnp4q50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sMI1RfU7Vo7PfmgMe9Sp5txggxWxaoSioAJk8aXuaubgMA3gr2s1IBw4LDGD6OiHS
	 xddyzEh0Zd+17pKq6eotjzH9wJH3t1EKvRMceegfap98NmyQR7qz6nD4m2ncAEkFwu
	 /hdhzA94Zgd+mC8KkyXh01cH/AaCjSN8BO9CfxtY=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260109124532epcas5p209cc71d77964df592675c691ef50bff0~JELz2XAlx0900009000epcas5p2i;
	Fri,  9 Jan 2026 12:45:32 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.87]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dnhMH5bR5z3hhT8; Fri,  9 Jan
	2026 12:45:31 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260109124531epcas5p118e7306860bcd57a0106948375df5c9c~JELyvgO8J1415414154epcas5p1x;
	Fri,  9 Jan 2026 12:45:31 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260109124530epsmtip1fce3c83ba6e0514b7825d9e5ae596b94~JELxpe4d50978109781epsmtip1X;
	Fri,  9 Jan 2026 12:45:30 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V5 15/17] cxl/pmem_region: Add sysfs attribute cxl region
 label updation/deletion
Date: Fri,  9 Jan 2026 18:14:35 +0530
Message-Id: <20260109124437.4025893-16-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260109124437.4025893-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260109124531epcas5p118e7306860bcd57a0106948375df5c9c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260109124531epcas5p118e7306860bcd57a0106948375df5c9c
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124531epcas5p118e7306860bcd57a0106948375df5c9c@epcas5p1.samsung.com>

Using these attributes region label is added/deleted into LSA. These
attributes are called from userspace (ndctl) after region creation.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 Documentation/ABI/testing/sysfs-bus-cxl | 22 +++++++
 drivers/cxl/core/pmem_region.c          | 88 +++++++++++++++++++++++++
 drivers/cxl/cxl.h                       |  7 ++
 3 files changed, 117 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index c80a1b5a03db..011a5e8d354f 100644
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
+KernelVersion:	v6.19
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
+KernelVersion:	v6.19
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

