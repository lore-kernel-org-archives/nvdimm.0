Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFD2328B70
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763538807; cv=none; b=Vr+qospbdPu4Kx7SvZwejiwlYljALGmG1Hpz6X7t/orDwtRpI2BeztLxu2n85pjRYw3zBu9UkQjDfhgm3mDN53b6OcO3QVilzkqumN+mG3XMZt+YIygca8+q+k9E2DL06NNUJXzJQo0pMvLzDWa4YxLSAGaHSa5rT0noOvNItgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763538807; c=relaxed/simple;
	bh=l5r1bvh6LDoBeIcHYiJgNcCRv0EOwPTUgben6xc9GAU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=J/9FF42q0EVsijpvIpGYEHfo3j624amnj9/vF4Wcd8oav2zwNpnHRzEP0Iu82umn4l8EWrcLxAJpTLsOzAwRizIb7MM0C6cCHlAAEFZyPOlpdNeMnD0x8q6Ecfq2arHKNxshtlWixPZRAKT1whQYFE8rLx98ovqY0p1v6hWIIKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Ws1NumQx; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Ws1NumQx"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20251119075321epoutp04e44d94c7014108fd49d15e65bb5af04e~5WTJFZnx61680216802epoutp04I
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20251119075321epoutp04e44d94c7014108fd49d15e65bb5af04e~5WTJFZnx61680216802epoutp04I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1763538801;
	bh=w26qsRHcIfkdliipZ7xkb7xoi4LnA7c+2pfJfJorvqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ws1NumQxILMvrLCIYdFkJX8JHUpCOqXjpF0jr93HIwG3DWfY/h5qiqjou8OrROiBP
	 K6l4bhZlcbjo5aj7UNLbF+WrPKyuGQr+M+2c5pxH+t4qrFMxkkKg0krZ1LaFiJ5OA5
	 KR2vLutusAwEg3i7zdrNodPOP37WrS8/FsYhkoH0=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251119075321epcas5p3017fa4bb2e4751c7604151e7cacbb118~5WTIoeyB73101731017epcas5p3b;
	Wed, 19 Nov 2025 07:53:21 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.91]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dBDHh0NP0z6B9m9; Wed, 19 Nov
	2025 07:53:20 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20251119075319epcas5p2374c721a42a68cfb6f2b17b17c51c0ea~5WTHPhK3W0912909129epcas5p29;
	Wed, 19 Nov 2025 07:53:19 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251119075317epsmtip13d23869e6dd2400f1a9bb9aa89423cf7~5WTFihqNt2566025660epsmtip1I;
	Wed, 19 Nov 2025 07:53:17 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V4 07/17] nvdimm/label: Add region label delete support
Date: Wed, 19 Nov 2025 13:22:45 +0530
Message-Id: <20251119075255.2637388-8-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251119075255.2637388-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251119075319epcas5p2374c721a42a68cfb6f2b17b17c51c0ea
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075319epcas5p2374c721a42a68cfb6f2b17b17c51c0ea
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075319epcas5p2374c721a42a68cfb6f2b17b17c51c0ea@epcas5p2.samsung.com>

Create export routine nd_region_label_delete() used for deleting
region label from LSA. It will be used later from CXL subsystem

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c          | 76 ++++++++++++++++++++++++++++++---
 drivers/nvdimm/label.h          |  1 +
 drivers/nvdimm/namespace_devs.c | 12 ++++++
 drivers/nvdimm/nd.h             |  6 +++
 include/linux/libnvdimm.h       |  1 +
 5 files changed, 90 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index e90e48672da3..da55ecd95e2f 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -1225,7 +1225,8 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels,
 	return max(num_labels, old_num_labels);
 }
 
-static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
+static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid,
+		      enum label_type ltype)
 {
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 	struct nd_label_ent *label_ent, *e;
@@ -1244,11 +1245,25 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
 
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
+			if (!region_label_uuid_equal(label_ent->region_label,
+			    uuid))
+				continue;
+
+			break;
+		}
+
 		active--;
 		slot = to_slot(ndd, label_ent);
 		nd_label_free_slot(ndd, slot);
@@ -1257,10 +1272,12 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
 
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
@@ -1296,7 +1313,8 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 		int count = 0;
 
 		if (size == 0) {
-			rc = del_labels(nd_mapping, nspm->uuid);
+			rc = del_labels(nd_mapping, nspm->uuid,
+					NS_LABEL_TYPE);
 			if (rc)
 				return rc;
 			continue;
@@ -1381,6 +1399,52 @@ int nd_pmem_region_label_update(struct nd_region *nd_region)
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
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+
+		rc = del_labels(nd_mapping, &nd_set->uuid, RG_LABEL_TYPE);
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
index 9450200b4470..9299a586bfce 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -244,6 +244,18 @@ int nd_region_label_update(struct nd_region *nd_region)
 }
 EXPORT_SYMBOL_GPL(nd_region_label_update);
 
+int nd_region_label_delete(struct nd_region *nd_region)
+{
+	int rc;
+
+	nvdimm_bus_lock(&nd_region->dev);
+	rc = nd_pmem_region_label_delete(nd_region);
+	nvdimm_bus_unlock(&nd_region->dev);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(nd_region_label_delete);
+
 static int nd_namespace_label_update(struct nd_region *nd_region,
 		struct device *dev)
 {
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 30c7262d8a26..b241a0b2e314 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -339,6 +339,12 @@ static inline bool is_region_label(struct nvdimm_drvdata *ndd,
 	return uuid_equal(&cxl_region_uuid, region_type);
 }
 
+static inline bool nsl_region_uuid_equal(struct nd_namespace_label *ns_label,
+					 const uuid_t *uuid)
+{
+	return uuid_equal((uuid_t *) ns_label->cxl.region_uuid, uuid);
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

