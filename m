Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F2035CBA3
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962726; cv=none; b=GWvRgFAESGcLpWoTE3xx1X2sLmRy9VIC2VKCu9/8wJP77IyeYSspXhDt6P2e47fe41O4rZReAMQ98uZx9KGagOjxNc92pXguTgrsvfo3jdkeVFtylSGD8t/YREBTDn0E7Zl+DPO4dGRgvSILFDoCXzJakpaFYxWb74IkCIT5kAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962726; c=relaxed/simple;
	bh=Uw4WDfXuunKhJeP6S7dLXFRJgAapipZFPKLdVI0wU7Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=XPC10Dm8lS2h5Q+PzP6MPYHQHzF1VNFPbg+WqZ54Muf+qRmcv8R4YWKEfHV4TIuD0AsWWO0ilfWx43Uy8/t49l7ox7eH5TDlFGRAvlfSABSHr5YUp4/wkXOtseVOgkQr3ea5Hc1ibEVVQ0h8p5xnKNSDgbjCFkGfbdARn3hN/nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=BgfgAKXO; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="BgfgAKXO"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260109124522epoutp01bab15f4e63d7a63c30618db67d008178~JELqg8-Oi0815308153epoutp01f
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260109124522epoutp01bab15f4e63d7a63c30618db67d008178~JELqg8-Oi0815308153epoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767962722;
	bh=OlEn5fbnpL7fm6LPBp1hOH6sSNbq7MHBsml7Ep/to+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BgfgAKXO0Bu1Abz3+GcQomHmQN4/XzmQQwfjcwDsGNaqs5HFRfZ7VYsfoiLMtuqaW
	 Yl2u87T2LN9P6hmeISghDQzq1JqU0s3WYwvLbxQu3XM2kvWC7xCtJY/QRNXXSSsybY
	 De+hX7LGewSi7mPqJHRCon5pMran2MS3slgwZfw0=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260109124522epcas5p3c9f8177c358abe44f64a9412f2f1678b~JELqKJTlQ2082420824epcas5p3h;
	Fri,  9 Jan 2026 12:45:22 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.92]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dnhM52w8lz3hhT3; Fri,  9 Jan
	2026 12:45:21 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260109124519epcas5p44c534dd371d670f569277bd2eaa825a7~JELoJZBn51264312643epcas5p4C;
	Fri,  9 Jan 2026 12:45:19 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260109124518epsmtip1d2aeb5c6dfa3d0e28762b45a064896e1~JELnCvYyK0977009770epsmtip1c;
	Fri,  9 Jan 2026 12:45:18 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V5 07/17] nvdimm/label: Add region label delete support
Date: Fri,  9 Jan 2026 18:14:27 +0530
Message-Id: <20260109124437.4025893-8-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260109124437.4025893-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260109124519epcas5p44c534dd371d670f569277bd2eaa825a7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260109124519epcas5p44c534dd371d670f569277bd2eaa825a7
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124519epcas5p44c534dd371d670f569277bd2eaa825a7@epcas5p4.samsung.com>

Create export routine nd_region_label_delete() used for deleting
region label from LSA. It will be used later from CXL subsystem

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c          | 74 ++++++++++++++++++++++++++++++---
 drivers/nvdimm/label.h          |  1 +
 drivers/nvdimm/namespace_devs.c |  7 ++++
 drivers/nvdimm/nd.h             |  6 +++
 include/linux/libnvdimm.h       |  1 +
 5 files changed, 83 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 169692dfa12c..2ad148bfe40b 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -1229,7 +1229,8 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels,
 	return max(num_labels, old_num_labels);
 }
 
-static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
+static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid,
+		      enum label_type ltype)
 {
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 	struct nd_label_ent *label_ent, *e;
@@ -1248,11 +1249,24 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
 
 	mutex_lock(&nd_mapping->lock);
 	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
-		if (label_ent->label)
+		if ((ltype == NS_LABEL_TYPE && !label_ent->label) ||
+		    (ltype == RG_LABEL_TYPE && !label_ent->region_label))
 			continue;
 		active++;
-		if (!nsl_uuid_equal(ndd, label_ent->label, uuid))
-			continue;
+
+		switch (ltype) {
+		case NS_LABEL_TYPE:
+			if (!nsl_uuid_equal(ndd, label_ent->label, uuid))
+				continue;
+
+			break;
+		case RG_LABEL_TYPE:
+			if (!region_label_uuid_equal(label_ent->region_label, uuid))
+				continue;
+
+			break;
+		}
+
 		active--;
 		slot = to_slot(ndd, label_ent);
 		nd_label_free_slot(ndd, slot);
@@ -1261,10 +1275,12 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
 
 		if (uuid_equal(&cxl_namespace_uuid, &label_ent->label_uuid))
 			label_ent->label = NULL;
+		else
+			label_ent->region_label = NULL;
 	}
 	list_splice_tail_init(&list, &nd_mapping->labels);
 
-	if (active == 0) {
+	if ((ltype == NS_LABEL_TYPE) && (active == 0)) {
 		nd_mapping_free_labels(nd_mapping);
 		dev_dbg(ndd->dev, "no more active labels\n");
 	}
@@ -1300,7 +1316,8 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 		int count = 0;
 
 		if (size == 0) {
-			rc = del_labels(nd_mapping, nspm->uuid);
+			rc = del_labels(nd_mapping, nspm->uuid,
+					NS_LABEL_TYPE);
 			if (rc)
 				return rc;
 			continue;
@@ -1385,6 +1402,51 @@ int nd_pmem_region_label_update(struct nd_region *nd_region)
 	return 0;
 }
 
+int nd_pmem_region_label_delete(struct nd_region *nd_region)
+{
+	struct nd_interleave_set *nd_set = nd_region->nd_set;
+	struct nd_label_ent *label_ent;
+	int i, rc;
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+
+		/* Find non cxl format supported ndr_mappings */
+		if (!ndd->cxl) {
+			dev_info(&nd_region->dev, "Unsupported region label\n");
+			return -EINVAL;
+		}
+
+		/* Find if any NS label using this region */
+		guard(mutex)(&nd_mapping->lock);
+		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
+			if (!label_ent->label)
+				continue;
+
+			/*
+			 * Check if any available NS labels has same
+			 * region_uuid in LSA
+			 */
+			if (nsl_region_uuid_equal(label_ent->label,
+						&nd_set->uuid)) {
+				dev_dbg(&nd_region->dev,
+					"Region/Namespace label in use\n");
+				return -EBUSY;
+			}
+		}
+	}
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		rc = del_labels(&nd_region->mapping[i], &nd_set->uuid,
+				RG_LABEL_TYPE);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
 int __init nd_label_init(void)
 {
 	WARN_ON(guid_parse(NVDIMM_BTT_GUID, &nvdimm_btt_guid));
diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
index f11f54056353..80a7f7dd8ba7 100644
--- a/drivers/nvdimm/label.h
+++ b/drivers/nvdimm/label.h
@@ -238,4 +238,5 @@ struct nd_namespace_pmem;
 int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 		struct nd_namespace_pmem *nspm, resource_size_t size);
 int nd_pmem_region_label_update(struct nd_region *nd_region);
+int nd_pmem_region_label_delete(struct nd_region *nd_region);
 #endif /* __LABEL_H__ */
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 8411f4152319..9047826138be 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -239,6 +239,13 @@ int nd_region_label_update(struct nd_region *nd_region)
 }
 EXPORT_SYMBOL_GPL(nd_region_label_update);
 
+int nd_region_label_delete(struct nd_region *nd_region)
+{
+	guard(nvdimm_bus)(&nd_region->dev);
+	return nd_pmem_region_label_delete(nd_region);
+}
+EXPORT_SYMBOL_GPL(nd_region_label_delete);
+
 static int nd_namespace_label_update(struct nd_region *nd_region,
 		struct device *dev)
 {
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 1b31eee3028e..92a8eabe0792 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -337,6 +337,12 @@ static inline bool is_region_label(struct nvdimm_drvdata *ndd,
 			  (uuid_t *)lsa_label->region_label.type);
 }
 
+static inline bool nsl_region_uuid_equal(struct nd_namespace_label *ns_label,
+					 const uuid_t *uuid)
+{
+	return uuid_equal((uuid_t *)ns_label->cxl.region_uuid, uuid);
+}
+
 static inline bool
 region_label_uuid_equal(struct cxl_region_label *region_label,
 			const uuid_t *uuid)
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 2c213b9dac66..bbf14a260c93 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -315,6 +315,7 @@ int nvdimm_has_cache(struct nd_region *nd_region);
 int nvdimm_in_overwrite(struct nvdimm *nvdimm);
 bool is_nvdimm_sync(struct nd_region *nd_region);
 int nd_region_label_update(struct nd_region *nd_region);
+int nd_region_label_delete(struct nd_region *nd_region);
 
 static inline int nvdimm_ctl(struct nvdimm *nvdimm, unsigned int cmd, void *buf,
 		unsigned int buf_len, int *cmd_rc)
-- 
2.34.1

