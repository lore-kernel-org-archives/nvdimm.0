Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4879430506C
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115846; cv=none; b=jquuuIYRCe851BKIYz9d3Q21uIbILJYbt9r9/cYng3HaKtLNmo40l1jKM7kCrvStmvS5uNcX5k+UvFokxW4K/lHNBfVQqUY02N7FFDc8s/pCwlJen5UstvyKelDh0o56SXbiKvZa9EcMwu5F0LHnWHrvQe6kIQ4Y0/jvAQHpS2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115846; c=relaxed/simple;
	bh=ObxFNjY3CDqZKiFtjzWuhPhDg4JW+Aar2f8yMQjHZoU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=qoGcf6Wh8WGNIkKai7cHjGMnvqxSbWNdYMGwT6ayL4XqgrvSKQ2yIUvCJMf78gYVqzHvVtjvDhlYFc58Cn4w0QoIEpbR3iD2jiiRMlvrnaU2U56zP1qttLqA36fYq61LN37mf7Pzt7fL+ld4mQ5InThuvz3SyJwMSeikgSFHDlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=k3TAnrkp; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="k3TAnrkp"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250917133042epoutp04d81305336f13d4c434d3b31eae9acbf5~mFQsombpl2401824018epoutp04g
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250917133042epoutp04d81305336f13d4c434d3b31eae9acbf5~mFQsombpl2401824018epoutp04g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758115842;
	bh=UJ9hFCDX6oRFE5yO/OJ6tbFOtoiVij+t/C+pJ0pqnUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k3TAnrkpGupL+E3XfL/TpmA+rqHpbPBSp+N3FAx0mvwRK5gHP+RZagsCsUhBII1gQ
	 JzWSBgikXsCxf9J4WqFba+fZVq9q8ReEvGHHqv4qeY1mZHFvIxIdARb93g6QYPGL+H
	 ZJtQJxoKff0LU9ixJdpHH4m351mPTz60a+FYByzg=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250917133041epcas5p27db1a98795b1cbbb85c46309fcbae39d~mFQsQACMH0995709957epcas5p2W;
	Wed, 17 Sep 2025 13:30:41 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.92]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cRfm05HY2z2SSKX; Wed, 17 Sep
	2025 13:30:40 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250917133040epcas5p4f3c15978b14ffd901afac423889f4877~mFQq5Ecqp1723417234epcas5p4K;
	Wed, 17 Sep 2025 13:30:40 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250917133039epsmtip132d39cb0d283bb2f6a32e137f4f65938~mFQp1kqVj0522305223epsmtip1c;
	Wed, 17 Sep 2025 13:30:39 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 07/20] nvdimm/region_label: Add region label delete
 support
Date: Wed, 17 Sep 2025 18:59:27 +0530
Message-Id: <20250917132940.1566437-8-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917132940.1566437-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917133040epcas5p4f3c15978b14ffd901afac423889f4877
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917133040epcas5p4f3c15978b14ffd901afac423889f4877
References: <20250917132940.1566437-1-s.neeraj@samsung.com>
	<CGME20250917133040epcas5p4f3c15978b14ffd901afac423889f4877@epcas5p4.samsung.com>

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

