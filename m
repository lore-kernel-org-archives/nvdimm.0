Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E67F2E92C8
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750165388; cv=none; b=Diiiz1TeODDbIEq2VElCkBF3MU7OkGpg6r/onGtFL+A8TPXRCOw91aEXfDaeg+7yk92VdSUGSKQc+v4SdVktMFgWbpYp4BpUsO0njMvwt4ZVGj3KkEtjAp9v4cSEvUgnZcBU7thJXL4fjVS3gp26nXO8I0vJatlhIze2fsMk4l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750165388; c=relaxed/simple;
	bh=QoryzQU9ZaZNw5no26fcoFwSWIcW43TpsyyRTPdDl4w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=DhuTus2swJbk7DPschtZtzRXWDi43Vhxgt9zcFTiT9/lOPJng944Vv3P9MrSOwbbTOVrJhw74XVJvWtffTvqo+J4gZnL1a4W+C0m+yRvPqqAMAwtSdfnag5wgQ6/IimtW5cxhSUdtyiEOlSh/bJd/0cpSkVknvA0m1refJgABIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QGk9qn5/; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QGk9qn5/"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250617130303epoutp023ec1de37a7b4665ac45775a796bc28d9~J1iTClm802938129381epoutp02T
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:03:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250617130303epoutp023ec1de37a7b4665ac45775a796bc28d9~J1iTClm802938129381epoutp02T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750165383;
	bh=Y1FrLL3kBKaT0nZHAelCCeV3gNWk0xVBjij91SjrpmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGk9qn5/2u0jIUke07Ha9yYaP7EVxo7jQS/eqzFmaXpfh1m25TdM/34MrQ45LWRxo
	 9K3Cy4rpRv4HulufAmT1Y87rbd+qVSLEISpGyWmMi2B90aeFhUm9AHBSxPkMsKN7IW
	 Y9vh/L9a3QuaTnbnzB+p8hYIefeIkiU9MXNcqsdI=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250617130302epcas5p22d803bdcb2445ce90f981984a925047a~J1iSZstTT2148621486epcas5p2q;
	Tue, 17 Jun 2025 13:03:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4bM6VZ66r5z2SSKX; Tue, 17 Jun
	2025 13:03:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250617124104epcas5p41105ad63af456b5cdb041e174a99925e~J1PGSLaFV0803508035epcas5p4U;
	Tue, 17 Jun 2025 12:41:04 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124101epsmtip25a7babebf92621641244a6e856148cd7~J1PDxrhNU2545625456epsmtip2u;
	Tue, 17 Jun 2025 12:41:01 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, s.neeraj@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: [RFC PATCH 20/20] cxl/pmem_region: Add cxl region label updation
 and deletion device attributes
Date: Tue, 17 Jun 2025 18:09:44 +0530
Message-Id: <1371006431.81750165382853.JavaMail.epsvc@epcpadp2new>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250617123944.78345-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250617124104epcas5p41105ad63af456b5cdb041e174a99925e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124104epcas5p41105ad63af456b5cdb041e174a99925e
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124104epcas5p41105ad63af456b5cdb041e174a99925e@epcas5p4.samsung.com>

Using these attributes region label is added/deleted into LSA. These
attributes are called from userspace (ndctl) after region creation.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/core/pmem_region.c | 103 +++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h              |   1 +
 2 files changed, 104 insertions(+)

diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
index a29526c27d40..f582d796c21b 100644
--- a/drivers/cxl/core/pmem_region.c
+++ b/drivers/cxl/core/pmem_region.c
@@ -45,8 +45,111 @@ static void cxl_pmem_region_release(struct device *dev)
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
+	rc = down_write_killable(&cxl_region_rwsem);
+	if (rc)
+		return rc;
+
+	/* Region not yet committed */
+	if (update && p->state != CXL_CONFIG_COMMIT) {
+		dev_dbg(dev, "region not committed, can't update into LSA\n");
+		rc = -ENXIO;
+		goto out;
+	}
+
+	if (cxlr && cxlr->cxlr_pmem && cxlr->cxlr_pmem->nd_region) {
+		rc = nd_region_label_update(cxlr->cxlr_pmem->nd_region);
+
+		if (!rc)
+			p->region_label_state = 1;
+	}
+
+out:
+	up_write(&cxl_region_rwsem);
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
+	rc = down_read_interruptible(&cxl_region_rwsem);
+	if (rc)
+		return rc;
+	rc = sysfs_emit(buf, "%d\n", p->region_label_state);
+	up_read(&cxl_region_rwsem);
+
+	return rc;
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
+	rc = down_write_killable(&cxl_region_rwsem);
+	if (rc)
+		return rc;
+
+	if (cxlr && cxlr->cxlr_pmem && cxlr->cxlr_pmem->nd_region) {
+		rc = nd_region_label_delete(cxlr->cxlr_pmem->nd_region);
+		if (rc)
+			goto out;
+	}
+
+	if (!rc)
+		p->region_label_state = 0;
+
+out:
+	up_write(&cxl_region_rwsem);
+
+	if (rc)
+		return rc;
+
+	return len;
+}
+DEVICE_ATTR_WO(region_label_delete);
+
+static struct attribute *cxl_pmem_region_attrs[] = {
+	&dev_attr_region_label_update.attr,
+	&dev_attr_region_label_delete.attr,
+	NULL,
+};
+
+struct attribute_group cxl_pmem_region_group = {
+	.attrs = cxl_pmem_region_attrs,
+};
+
 static const struct attribute_group *cxl_pmem_region_attribute_groups[] = {
 	&cxl_base_attribute_group,
+	&cxl_pmem_region_group,
 	NULL,
 };
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index c6cd0c8d78a1..f67bf7df287a 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -498,6 +498,7 @@ enum cxl_config_state {
  */
 struct cxl_region_params {
 	enum cxl_config_state state;
+	int region_label_state;
 	uuid_t uuid;
 	int interleave_ways;
 	int interleave_granularity;
-- 
2.34.1


