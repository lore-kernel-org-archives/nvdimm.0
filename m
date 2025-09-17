Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAB7331AF7
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116508; cv=none; b=nn6Of5QGiakprWzGopa9LlJk0Sfho+Q0A4PdYMS4yM7Jr983Qgob/djkbnzgaZgZNVbNygd59FyYu5+ubhdskYrC3KbB3xPGM89hvcgTOrP6hgj7fuObjCRNNgTTu9lG1IFmTSVwMVQzfhZx79Zp61Tpic8dBoQIl65u51nh9as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116508; c=relaxed/simple;
	bh=ObxFNjY3CDqZKiFtjzWuhPhDg4JW+Aar2f8yMQjHZoU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=OZ9qc3rvsJahELy4pFQEYrInALScuixwzaTK7HFWWjY9pIz/kLmY/iQ1QYYLhIpeM7ELfiLfOWeoG0beJkyhw92sN2x4JTCnhi1XX0riMdsCGHMv90W6QBbw4ZMQiyv+rz8gSFMVqnaIpG97HRZjz6yQvmrr3MCqMzRVNpm2cVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=pJTYRhQp; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="pJTYRhQp"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250917134144epoutp038f3272fc4ed31e09e616da9dcfd515b9~mFaVYjU5b0922309223epoutp03L
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:41:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250917134144epoutp038f3272fc4ed31e09e616da9dcfd515b9~mFaVYjU5b0922309223epoutp03L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758116504;
	bh=UJ9hFCDX6oRFE5yO/OJ6tbFOtoiVij+t/C+pJ0pqnUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pJTYRhQpNP+3GVB4KXwav19kjQ88rkiKfF7R1bJ+2BAexl6JfxfHV0/GqBpnfS8nd
	 wjyEKNz1E2dl+haD5mBudyoYKCYMGVFTzTrCZ3BrBU7WNtItOTQWcC05J3MBU2pWKr
	 30//9mZlP9IY3n+7L3lG9p/WCdI21/sNLWFMS2r0=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250917134144epcas5p39965d3dd0da5249034d52607471ef6f6~mFaU-DBT30180401804epcas5p30;
	Wed, 17 Sep 2025 13:41:44 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.95]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cRg0l0TMhz2SSKX; Wed, 17 Sep
	2025 13:41:43 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250917134142epcas5p49d85873cf3ea5f3166c63381ab668fc7~mFaTm8opi2411624116epcas5p4c;
	Wed, 17 Sep 2025 13:41:42 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250917134141epsmtip27a4a7bd0a74dacbc35e662da756e84ea~mFaSTAfEd0911709117epsmtip2T;
	Wed, 17 Sep 2025 13:41:40 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com, Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 07/20] nvdimm/region_label: Add region label delete
 support
Date: Wed, 17 Sep 2025 19:11:03 +0530
Message-Id: <20250917134116.1623730-8-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917134116.1623730-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917134142epcas5p49d85873cf3ea5f3166c63381ab668fc7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917134142epcas5p49d85873cf3ea5f3166c63381ab668fc7
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134142epcas5p49d85873cf3ea5f3166c63381ab668fc7@epcas5p4.samsung.com>

Added LSA v2.1 format region label deletion routine. This function is
used to delete region label from LSA

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c          | 79 ++++++++++++++++++++++++++++++---
 drivers/nvdimm/label.h          |  1 +
 drivers/nvdimm/namespace_devs.c | 12 +++++
 drivers/nvdimm/nd.h             |  6 +++
 include/linux/libnvdimm.h       |  1 +
 5 files changed, 92 insertions(+), 7 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 209c73f6b7e7..d33db96ba8ba 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -1126,11 +1126,13 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
 	return max(num_labels, old_num_labels);
 }
 
-static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
+static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid,
+		      enum label_type ltype)
 {
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 	struct nd_label_ent *label_ent, *e;
 	struct nd_namespace_index *nsindex;
+	union nd_lsa_label *nd_label;
 	unsigned long *free;
 	LIST_HEAD(list);
 	u32 nslot, slot;
@@ -1145,15 +1147,28 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
 
 	guard(mutex)(&nd_mapping->lock);
 	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
-		struct nd_namespace_label *nd_label = label_ent->label;
+		nd_label = (union nd_lsa_label *) label_ent->label;
 
 		if (!nd_label)
 			continue;
 		active++;
-		if (!nsl_uuid_equal(ndd, nd_label, uuid))
-			continue;
+
+		switch (ltype) {
+		case NS_LABEL_TYPE:
+			if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
+				continue;
+
+			break;
+		case RG_LABEL_TYPE:
+			if (!region_label_uuid_equal(&nd_label->region_label,
+			    uuid))
+				continue;
+
+			break;
+		}
+
 		active--;
-		slot = to_slot(ndd, nd_label);
+		slot = to_slot(ndd, &nd_label->ns_label);
 		nd_label_free_slot(ndd, slot);
 		dev_dbg(ndd->dev, "free: %d\n", slot);
 		list_move_tail(&label_ent->list, &list);
@@ -1161,7 +1176,7 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
 	}
 	list_splice_tail_init(&list, &nd_mapping->labels);
 
-	if (active == 0) {
+	if ((ltype == NS_LABEL_TYPE) && (active == 0)) {
 		nd_mapping_free_labels(nd_mapping);
 		dev_dbg(ndd->dev, "no more active labels\n");
 	}
@@ -1198,7 +1213,8 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 		int count = 0;
 
 		if (size == 0) {
-			rc = del_labels(nd_mapping, nspm->uuid);
+			rc = del_labels(nd_mapping, nspm->uuid,
+					NS_LABEL_TYPE);
 			if (rc)
 				return rc;
 			continue;
@@ -1281,6 +1297,55 @@ int nd_pmem_region_label_update(struct nd_region *nd_region)
 	return 0;
 }
 
+int nd_pmem_region_label_delete(struct nd_region *nd_region)
+{
+	struct nd_interleave_set *nd_set = nd_region->nd_set;
+	struct nd_label_ent *label_ent;
+	int ns_region_cnt = 0;
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
+						  &nd_set->uuid))
+				ns_region_cnt++;
+		}
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
index 284e2a763b49..276dd822e142 100644
--- a/drivers/nvdimm/label.h
+++ b/drivers/nvdimm/label.h
@@ -238,4 +238,5 @@ struct nd_namespace_pmem;
 int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 		struct nd_namespace_pmem *nspm, resource_size_t size);
 int nd_pmem_region_label_update(struct nd_region *nd_region);
+int nd_pmem_region_label_delete(struct nd_region *nd_region);
 #endif /* __LABEL_H__ */
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 559f822ef24f..564a73b1da41 100644
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
index f04c042dcfa9..046063ea08b6 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -331,6 +331,12 @@ static inline bool is_region_label(struct nvdimm_drvdata *ndd,
 	return uuid_equal(&region_type, ns_type);
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

