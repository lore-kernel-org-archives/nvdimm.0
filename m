Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7062E06DB
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750165214; cv=none; b=pNaNGiCfWfGV542jg2Wjc+VkcQRttDzgRkBnSbOBu8KfjqVGTKdB6ePsegUjLlmTcHv52vprpcpV6h98nxA5qrAhqK3XUj47jBq2Xsoggw5SfwSfUSn9RDMtEDw0vQGIAzIg0mq8qp5zktkpVHpv3Hey603GVuaXmdSlZN6RJ4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750165214; c=relaxed/simple;
	bh=zslXoZS65WowKD/Lmd8f2Jv2WYswTyfYnNHk7HroDKo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=fuUbnuhXQiwJcU7VWz/elAAj71rn4QqF8Atlrodlx3x43zK/AwCtF8DkN1S3ppY5xdb0TFFbIKKgcc1S4q2PHky7R4NnJ6aclK0wFZiQVDfypeQMFKCNUMcm9oE8mzq0SuyQtGUxgopAIFC2dXFNuaEnLAkMpcGVBvQrl7+7i+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=d5sci6Gr; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="d5sci6Gr"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250617130005epoutp010246c33f39b24ce9166b80c55aaf9a68~J1fs9zm6d0669606696epoutp01c
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:00:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250617130005epoutp010246c33f39b24ce9166b80c55aaf9a68~J1fs9zm6d0669606696epoutp01c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750165205;
	bh=OvY7745ZkvZJo9kPQmH/YuGirR11M2CfV82KQ2zd+7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5sci6GraV9WuTpy/+8iioryTAeQDM9s+Aj4c/QcPzOvTtbT0kcG+6sbnO4s/Zsti
	 0bSpehcQKzd2sLjWbwWMowwnVjMdJhUqJuapW77qwGH9k9XsiPYcsLgiItpr0rfouz
	 8pD66c3c07HBohaUdGxQ4W7Xcvp/WuTBxdERBzK0=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250617130004epcas5p2ae51dba7832578d01602cb87b798db63~J1fsbVX0m1917719177epcas5p2K;
	Tue, 17 Jun 2025 13:00:04 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bM6R84bvqz3hhT7; Tue, 17 Jun
	2025 13:00:04 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124022epcas5p2441d6c5dfaeceb744b5fc00add7ceae0~J1Ofw4JBS0930409304epcas5p2a;
	Tue, 17 Jun 2025 12:40:22 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124020epsmtip2908d400eaf4a728bc05db24424442fe8~J1OdQ2LS32488624886epsmtip2T;
	Tue, 17 Jun 2025 12:40:20 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, s.neeraj@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: [RFC PATCH 06/20] nvdimm/region_label: Add region label deletion
 routine
Date: Tue, 17 Jun 2025 18:09:30 +0530
Message-Id: <1256440269.161750165204630.JavaMail.epsvc@epcpadp1new>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250617123944.78345-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250617124022epcas5p2441d6c5dfaeceb744b5fc00add7ceae0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124022epcas5p2441d6c5dfaeceb744b5fc00add7ceae0
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124022epcas5p2441d6c5dfaeceb744b5fc00add7ceae0@epcas5p2.samsung.com>

Added cxl v2.1 format region label deletion routine. This function is
used to delete region label from LSA

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c          | 75 ++++++++++++++++++++++++++++++---
 drivers/nvdimm/label.h          |  6 +++
 drivers/nvdimm/namespace_devs.c | 12 ++++++
 drivers/nvdimm/nd.h             |  9 ++++
 include/linux/libnvdimm.h       |  1 +
 5 files changed, 98 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 7f33d14ce0ef..9381c50086fc 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -1034,7 +1034,8 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
 	return max(num_labels, old_num_labels);
 }
 
-static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
+static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid,
+		enum label_type ltype)
 {
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 	struct nd_label_ent *label_ent, *e;
@@ -1058,8 +1059,18 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
 		if (!nd_label)
 			continue;
 		active++;
-		if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
-			continue;
+
+		if (ltype == NS_LABEL_TYPE) {
+			if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
+				continue;
+		} else if (ltype == RG_LABEL_TYPE) {
+			if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
+				continue;
+		} else {
+			dev_err(ndd->dev, "Invalid label type\n");
+			return 0;
+		}
+
 		active--;
 		slot = to_slot(ndd, nd_label);
 		nd_label_free_slot(ndd, slot);
@@ -1069,7 +1080,7 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
 	}
 	list_splice_tail_init(&list, &nd_mapping->labels);
 
-	if (active == 0) {
+	if ((ltype == NS_LABEL_TYPE) && (active == 0)) {
 		nd_mapping_free_labels(nd_mapping);
 		dev_dbg(ndd->dev, "no more active labels\n");
 	}
@@ -1091,7 +1102,8 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 		int count = 0;
 
 		if (size == 0) {
-			rc = del_labels(nd_mapping, nspm->uuid);
+			rc = del_labels(nd_mapping, nspm->uuid,
+					NS_LABEL_TYPE);
 			if (rc)
 				return rc;
 			continue;
@@ -1259,6 +1271,59 @@ int nd_pmem_region_label_update(struct nd_region *nd_region)
 	return 0;
 }
 
+int nd_pmem_region_label_delete(struct nd_region *nd_region)
+{
+	int i, rc;
+	struct nd_interleave_set *nd_set = nd_region->nd_set;
+	struct nd_label_ent *label_ent;
+	bool is_non_rgl = false;
+	int ns_region_cnt = 0;
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+
+		/* Find non cxl format supported ndr_mappings */
+		if (!ndd->cxl)
+			is_non_rgl = true;
+
+		/* Find if any NS label using this region */
+		mutex_lock(&nd_mapping->lock);
+		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
+			if (!label_ent->label)
+				continue;
+
+			/* Check if any available NS labels has same
+			 * region_uuid in LSA
+			 */
+			if (nsl_region_uuid_equal(&label_ent->label->ns_label,
+						  &nd_set->uuid))
+				ns_region_cnt++;
+		}
+		mutex_unlock(&nd_mapping->lock);
+	}
+
+	if (is_non_rgl) {
+		dev_dbg(&nd_region->dev, "Region label deletion unsupported\n");
+		return -EINVAL;
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
index 6cccb4d2fc7b..b081661b7aaa 100644
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
index 2fdc92b29e8a..1e5a68013735 100644
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


