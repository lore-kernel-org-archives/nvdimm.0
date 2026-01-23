Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301BC36C0DB
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769167899; cv=none; b=H9gzFk+DK1X7CIqA2n+WAh1LSxmi+wiEuf+iCPC//G0nxDZvTN1dB6gnkghH3WUTPEkkV+Rf+eskHN8i3PRPQ++zhjG993AqTsbSa9LOvjp1t4n1z/RFVE6V6VBnCoEXpBgZEgqJkKnr+BY5dWus3bLmZBMV878m0rVooE8jW3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769167899; c=relaxed/simple;
	bh=EgMNhzC7a2IW9P1C/1Z2fXCMpTWugBXn80XMjtR5JqQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=E6HylSkl2ytFcfUZjOVk8s6BBbD8TDyH91rr7PbkXwkcDesfnRyXp/RYuXCM7CdMf8FB19VapTF1guLOL5Si8yOoLe6F6Kti3nP/+ZLSIBfgpKfP+4A3lTU5GcYA9JaxLVdnQZovbYQkRhOvrNt2CT7iQ3879URqGI45a07+kvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=MInHJBuK; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MInHJBuK"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260123113135epoutp03f21a9a3df56ffac43e83cb578a02247a~NWNPZlcRL2124621246epoutp03-
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260123113135epoutp03f21a9a3df56ffac43e83cb578a02247a~NWNPZlcRL2124621246epoutp03-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769167895;
	bh=HlHjWUX/NwX1kOa8NWAPwT8k2Y+IDbU92VMZ2fTe4rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MInHJBuKfKzP5oDhsQJ0yVHwotdr6wrA2cTds5ee5gTKzTjlRrcvaY05sdn2qum2H
	 cgCeM5gzuYD2tQlTYu++5ZT8NkuJOO6i90tsL+61WVkv6e2UpnZc99wwTS1kJ61Mgv
	 m0dIeAU2Grs/4xn2ylPrz7chaB5VQxGJqiaUteRA=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260123113134epcas5p1b3914dce86dc87a6257fb05ed881b932~NWNO3IdKc2520225202epcas5p1F;
	Fri, 23 Jan 2026 11:31:34 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.91]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dyG3V1X7bz2SSKd; Fri, 23 Jan
	2026 11:31:34 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260123113133epcas5p4989af8ca6a75569b2b47d80514e62c57~NWNNuYA202258722587epcas5p40;
	Fri, 23 Jan 2026 11:31:33 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260123113132epsmtip2f2132afbe5e1d32a42d5d46c47f1a237~NWNMatGI82685726857epsmtip2T;
	Fri, 23 Jan 2026 11:31:32 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V6 07/18] nvdimm/label: Add region label delete support
Date: Fri, 23 Jan 2026 17:01:01 +0530
Message-Id: <20260123113112.3488381-8-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260123113112.3488381-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260123113133epcas5p4989af8ca6a75569b2b47d80514e62c57
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260123113133epcas5p4989af8ca6a75569b2b47d80514e62c57
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
	<CGME20260123113133epcas5p4989af8ca6a75569b2b47d80514e62c57@epcas5p4.samsung.com>

Create export routine nd_region_label_delete() used for deleting
region label from LSA. It will be used later from CXL subsystem

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
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
index f18b04f63dcc..014af60d68a1 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -1230,7 +1230,8 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels,
 	return max(num_labels, old_num_labels);
 }
 
-static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
+static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid,
+		      enum label_type ltype)
 {
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 	struct nd_label_ent *label_ent, *e;
@@ -1249,11 +1250,24 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
 
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
@@ -1262,10 +1276,12 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
 
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
@@ -1301,7 +1317,8 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 		int count = 0;
 
 		if (size == 0) {
-			rc = del_labels(nd_mapping, nspm->uuid);
+			rc = del_labels(nd_mapping, nspm->uuid,
+					NS_LABEL_TYPE);
 			if (rc)
 				return rc;
 			continue;
@@ -1386,6 +1403,51 @@ int nd_pmem_region_label_update(struct nd_region *nd_region)
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
index 14cdc3e927b4..ec856601fda0 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -339,6 +339,12 @@ static inline bool is_region_label(struct nvdimm_drvdata *ndd,
 	return uuid_equal(&tmp, &cxl_region_uuid);
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

