Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08D82980DB
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753877805; cv=none; b=hCZPFczThpjbkmcyzX17M7fmFxuX1ZiUzR7s8uJPSkssWN0t+SVrRLms0rjsa7iVrP2eUtp+3dhDbbskFIn5SZYaxguOQBIuvQAL3vB2an0g1I3m/zpyLaJ5pQfn+TdIjTxXHD2MTTcqzX8onxefOTv7XoQ9kPOinzoEMZThFJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753877805; c=relaxed/simple;
	bh=PCt3quU9M1bMqITbzUjyCWHXMynOhFNPGkUtd0R/X8A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=eJE+7cBZwVXlv27/IiPGhVUUx9X5SHbLxIWV0d3Ftxah3UU8g+S6pm9p7fOwPMg324BA4QdzUxuuo/JZQFt7ynaSTA2D2C/wusEv5X2xW4Tq1iWiyrSNrZGymnrkPAzUY8jVL0EIqOkiDAnjhXmoU6B4WajnHRyiQfALlMmsx+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=gFkaFoVb; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gFkaFoVb"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250730121640epoutp0174eae63c92daaf5d30ddda2197ec0ee4~XBpFFJ29l1980419804epoutp01A
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:16:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250730121640epoutp0174eae63c92daaf5d30ddda2197ec0ee4~XBpFFJ29l1980419804epoutp01A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753877800;
	bh=Zv4BsAGx+nBAPKuUHn4Qk2LKrOvNd4eiFSju1jaiFzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFkaFoVbUCxF8pOFJmseoSffvEPJMP+fHQoMJr8MMFAgUcwLgBOFcN5twPTd+4UAG
	 Ug/K468BEHuVhE5Vo2MQVpw9XzRbnolRUJd7QYmKLd9p4A+/RJeMj/yKwru6acpSf3
	 zBhLiTKDe3k3zUqviVjURKj3MsCEHnso17fpwkc4=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250730121640epcas5p3e4e016c15d698c9c69e18e02539c2886~XBpElrRjn3063230632epcas5p3o;
	Wed, 30 Jul 2025 12:16:40 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.95]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4bsWRC2Rchz6B9m6; Wed, 30 Jul
	2025 12:16:39 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250730121230epcas5p11650f090de55d0a2db541ee32e9a6fee~XBlblz8402385423854epcas5p1L;
	Wed, 30 Jul 2025 12:12:30 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250730121228epsmtip126796f2fb4772cc27086930f0f001d0a~XBlaV9Kf30450404504epsmtip1i;
	Wed, 30 Jul 2025 12:12:28 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V2 06/20] nvdimm/region_label: Add region label deletion
 routine
Date: Wed, 30 Jul 2025 17:41:55 +0530
Message-Id: <20250730121209.303202-7-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250730121209.303202-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250730121230epcas5p11650f090de55d0a2db541ee32e9a6fee
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121230epcas5p11650f090de55d0a2db541ee32e9a6fee
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121230epcas5p11650f090de55d0a2db541ee32e9a6fee@epcas5p1.samsung.com>

Added cxl v2.1 format region label deletion routine. This function is
used to delete region label from LSA

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c          | 77 ++++++++++++++++++++++++++++++---
 drivers/nvdimm/label.h          |  6 +++
 drivers/nvdimm/namespace_devs.c | 12 +++++
 drivers/nvdimm/nd.h             |  9 ++++
 include/linux/libnvdimm.h       |  1 +
 5 files changed, 100 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 94f2d0ba7aca..be18278d6cea 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -1044,7 +1044,8 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
 	return max(num_labels, old_num_labels);
 }
 
-static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
+static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid,
+		enum label_type ltype)
 {
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 	struct nd_label_ent *label_ent, *e;
@@ -1068,8 +1069,23 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
 		if (!nd_label)
 			continue;
 		active++;
-		if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
-			continue;
+
+		switch (ltype) {
+		case NS_LABEL_TYPE:
+			if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
+				continue;
+
+			break;
+		case RG_LABEL_TYPE:
+			if (!rgl_uuid_equal(&nd_label->rg_label, uuid))
+				continue;
+
+			break;
+		default:
+			dev_err(ndd->dev, "Invalid label type\n");
+			return 0;
+		}
+
 		active--;
 		slot = to_slot(ndd, nd_label);
 		nd_label_free_slot(ndd, slot);
@@ -1079,7 +1095,7 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
 	}
 	list_splice_tail_init(&list, &nd_mapping->labels);
 
-	if (active == 0) {
+	if ((ltype == NS_LABEL_TYPE) && (active == 0)) {
 		nd_mapping_free_labels(nd_mapping);
 		dev_dbg(ndd->dev, "no more active labels\n");
 	}
@@ -1101,7 +1117,8 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 		int count = 0;
 
 		if (size == 0) {
-			rc = del_labels(nd_mapping, nspm->uuid);
+			rc = del_labels(nd_mapping, nspm->uuid,
+					NS_LABEL_TYPE);
 			if (rc)
 				return rc;
 			continue;
@@ -1268,6 +1285,56 @@ int nd_pmem_region_label_update(struct nd_region *nd_region)
 	return 0;
 }
 
+int nd_pmem_region_label_delete(struct nd_region *nd_region)
+{
+	int i, rc;
+	struct nd_interleave_set *nd_set = nd_region->nd_set;
+	struct nd_label_ent *label_ent;
+	int ns_region_cnt = 0;
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+
+		/* Find non cxl format supported ndr_mappings */
+		if (!ndd->cxl) {
+			dev_info(&nd_region->dev, "Region label unsupported\n");
+			return -EINVAL;
+		}
+
+		/* Find if any NS label using this region */
+		mutex_lock(&nd_mapping->lock);
+		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
+			if (!label_ent->label)
+				continue;
+
+			/*
+			 * Check if any available NS labels has same
+			 * region_uuid in LSA
+			 */
+			if (nsl_region_uuid_equal(&label_ent->label->ns_label,
+						  &nd_set->uuid))
+				ns_region_cnt++;
+		}
+		mutex_unlock(&nd_mapping->lock);
+	}
+
+	if (ns_region_cnt) {
+		dev_dbg(&nd_region->dev, "Region/Namespace label in use\n");
+		return -EBUSY;
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
index 0f428695017d..cc14068511cf 100644
--- a/drivers/nvdimm/label.h
+++ b/drivers/nvdimm/label.h
@@ -30,6 +30,11 @@ enum {
 	ND_NSINDEX_INIT = 0x1,
 };
 
+enum label_type {
+	RG_LABEL_TYPE,
+	NS_LABEL_TYPE,
+};
+
 /**
  * struct nd_namespace_index - label set superblock
  * @sig: NAMESPACE_INDEX\0
@@ -235,4 +240,5 @@ struct nd_namespace_pmem;
 int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 		struct nd_namespace_pmem *nspm, resource_size_t size);
 int nd_pmem_region_label_update(struct nd_region *nd_region);
+int nd_pmem_region_label_delete(struct nd_region *nd_region);
 #endif /* __LABEL_H__ */
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 02ae8162566c..e5c2f78ca7dd 100644
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
index 15d94e3937f0..6585747154c2 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -322,6 +322,15 @@ static inline void nsl_set_region_uuid(struct nvdimm_drvdata *ndd,
 		export_uuid(ns_label->cxl.region_uuid, uuid);
 }
 
+static inline bool nsl_region_uuid_equal(struct nd_namespace_label *ns_label,
+				  const uuid_t *uuid)
+{
+	uuid_t tmp;
+
+	import_uuid(&tmp, ns_label->cxl.region_uuid);
+	return uuid_equal(&tmp, uuid);
+}
+
 static inline bool rgl_uuid_equal(struct cxl_region_label *rg_label,
 				  const uuid_t *uuid)
 {
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index b06bd45373f4..b2e16914ab52 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -310,6 +310,7 @@ int nvdimm_has_cache(struct nd_region *nd_region);
 int nvdimm_in_overwrite(struct nvdimm *nvdimm);
 bool is_nvdimm_sync(struct nd_region *nd_region);
 int nd_region_label_update(struct nd_region *nd_region);
+int nd_region_label_delete(struct nd_region *nd_region);
 
 static inline int nvdimm_ctl(struct nvdimm *nvdimm, unsigned int cmd, void *buf,
 		unsigned int buf_len, int *cmd_rc)
-- 
2.34.1

