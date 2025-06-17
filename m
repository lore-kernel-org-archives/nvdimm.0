Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1EC2EACE6
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750165211; cv=none; b=RZrITk8r5VC1fvlSdGwHYnpzmkD625b1kNatpfP7/BhaNaMAMWSAMMnVil5oXgqJqnIpDpNhyEugFT5Fc1cbeoxmAORlECs7LNJc3D20VgUxrwxzLb1qS8w6mMqcYtI7YU8HO2B0KZA3c3o8lRmJ7cSRAkBzt9crvQzsNLnXXqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750165211; c=relaxed/simple;
	bh=I1/26O7BK1YJ8NaIK6GiaXcr2qihocHs8vhRXjlAwmg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=U5fyJxxLHoH999dgQAxo2cAEq6tIKhdc29jbXM8t6WthDnRZMzHOzE39BllKF2Qp+ot9jf0I1PnFn8ruJ8FZ2QtRJ/fmjJyosfIGZ9Q1FiS8j7WIRu1BuWq8zJhdZx0TIWIA1Y+jnVwzTcPoXjZ+22Sf9mbU9YIbq2vz6RgWrIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=BOANkj/x; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="BOANkj/x"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250617130004epoutp032276a5d7bbd5115be27e72e620523f03~J1fsndXqD1779017790epoutp03c
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:00:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250617130004epoutp032276a5d7bbd5115be27e72e620523f03~J1fsndXqD1779017790epoutp03c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750165204;
	bh=WJeYdw9K0dxgn01/ih/38DAT8vkwYecu8XKADa2iBb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BOANkj/xOJQ7trJ4xiUyRQYxj5hgmXtXhXwmKmRpmJg9eJJID7Hve46YtLsGMxl5K
	 EO6r8v/ifwZxybcs2icDSk55Xn05PKJjU2MOfB0P99z+1n+ySYxA5vpRgoDDSTt4sZ
	 3JGfxk/AV+YUX8uZn9g7rulHEpLIesxdqAIatgd4=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250617130004epcas5p22a716707b2d3181f869356569bd44bb5~J1fsOosTK1917719177epcas5p2I;
	Tue, 17 Jun 2025 13:00:04 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4bM6R83DJpz2SSKg; Tue, 17 Jun
	2025 13:00:04 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250617124019epcas5p39815cc0f2b175aee40c194625166695c~J1OdBaCsb2101821018epcas5p3o;
	Tue, 17 Jun 2025 12:40:19 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124017epsmtip221b8dd74fef78767c3eaf18a6a286919~J1OaeuJA12545625456epsmtip2Y;
	Tue, 17 Jun 2025 12:40:17 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, s.neeraj@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: [RFC PATCH 05/20] nvdimm/region_label: Add region label updation
 routine
Date: Tue, 17 Jun 2025 18:09:29 +0530
Message-Id: <1690859824.141750165204442.JavaMail.epsvc@epcpadp1new>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250617123944.78345-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250617124019epcas5p39815cc0f2b175aee40c194625166695c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124019epcas5p39815cc0f2b175aee40c194625166695c
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124019epcas5p39815cc0f2b175aee40c194625166695c@epcas5p3.samsung.com>

Added __pmem_region_label_update region label update routine to update
region label

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c          | 142 ++++++++++++++++++++++++++++++++
 drivers/nvdimm/label.h          |   2 +
 drivers/nvdimm/namespace_devs.c |  12 +++
 drivers/nvdimm/nd.h             |  20 +++++
 include/linux/libnvdimm.h       |   8 ++
 5 files changed, 184 insertions(+)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index d5cfaa99f976..7f33d14ce0ef 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -381,6 +381,16 @@ static void nsl_calculate_checksum(struct nvdimm_drvdata *ndd,
 	nsl_set_checksum(ndd, nd_label, sum);
 }
 
+static void rgl_calculate_checksum(struct nvdimm_drvdata *ndd,
+				   struct cxl_region_label *rg_label)
+{
+	u64 sum;
+
+	rgl_set_checksum(rg_label, 0);
+	sum = nd_fletcher64(rg_label, sizeof_namespace_label(ndd), 1);
+	rgl_set_checksum(rg_label, sum);
+}
+
 static bool slot_valid(struct nvdimm_drvdata *ndd,
 		struct nd_lsa_label *nd_label, u32 slot)
 {
@@ -1117,6 +1127,138 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 	return 0;
 }
 
+static int __pmem_region_label_update(struct nd_region *nd_region,
+		struct nd_mapping *nd_mapping, int pos, unsigned long flags)
+{
+	struct nd_interleave_set *nd_set = nd_region->nd_set;
+	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+	struct nd_lsa_label *nd_label;
+	struct cxl_region_label *rg_label;
+	struct nd_namespace_index *nsindex;
+	struct nd_label_ent *label_ent;
+	unsigned long *free;
+	u32 nslot, slot;
+	size_t offset;
+	int rc;
+	uuid_t tmp;
+
+	if (!preamble_next(ndd, &nsindex, &free, &nslot))
+		return -ENXIO;
+
+	/* allocate and write the label to the staging (next) index */
+	slot = nd_label_alloc_slot(ndd);
+	if (slot == UINT_MAX)
+		return -ENXIO;
+	dev_dbg(ndd->dev, "allocated: %d\n", slot);
+
+	nd_label = to_label(ndd, slot);
+
+	memset(nd_label, 0, sizeof_namespace_label(ndd));
+	rg_label = &nd_label->rg_label;
+
+	/* Set Region Label Format identification UUID */
+	uuid_parse(CXL_REGION_UUID, &tmp);
+	export_uuid(nd_label->rg_label.type, &tmp);
+
+	/* Set Current Region Label UUID */
+	export_uuid(nd_label->rg_label.uuid, &nd_set->uuid);
+
+	rg_label->flags = __cpu_to_le32(flags);
+	rg_label->nlabel = __cpu_to_le16(nd_region->ndr_mappings);
+	rg_label->position = __cpu_to_le16(pos);
+	rg_label->dpa = __cpu_to_le64(nd_mapping->start);
+	rg_label->rawsize = __cpu_to_le64(nd_mapping->size);
+	rg_label->hpa = __cpu_to_le64(nd_set->res->start);
+	rg_label->slot = __cpu_to_le32(slot);
+	rg_label->ig = __cpu_to_le32(nd_set->interleave_granularity);
+	rg_label->align = __cpu_to_le16(0);
+
+	/* Update fletcher64 Checksum */
+	rgl_calculate_checksum(ndd, rg_label);
+
+	/* update label */
+	offset = nd_label_offset(ndd, nd_label);
+	rc = nvdimm_set_config_data(ndd, offset, nd_label,
+			sizeof_namespace_label(ndd));
+	if (rc < 0) {
+		nd_label_free_slot(ndd, slot);
+		return rc;
+	}
+
+	/* Garbage collect the previous label */
+	mutex_lock(&nd_mapping->lock);
+	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
+		if (!label_ent->label)
+			continue;
+		if (rgl_uuid_equal(&label_ent->label->rg_label, &nd_set->uuid))
+			reap_victim(nd_mapping, label_ent);
+	}
+
+	/* update index */
+	rc = nd_label_write_index(ndd, ndd->ns_next,
+			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
+
+	if (rc == 0) {
+		list_for_each_entry(label_ent, &nd_mapping->labels, list)
+			if (!label_ent->label) {
+				label_ent->label = nd_label;
+				nd_label = NULL;
+				break;
+			}
+		dev_WARN_ONCE(&nd_region->dev, nd_label,
+				"failed to track label: %d\n",
+				to_slot(ndd, nd_label));
+		if (nd_label)
+			rc = -ENXIO;
+	}
+	mutex_unlock(&nd_mapping->lock);
+
+	return rc;
+}
+
+int nd_pmem_region_label_update(struct nd_region *nd_region)
+{
+	int i, rc;
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+
+		/* No need to update region label for non cxl format */
+		if (!ndd->cxl)
+			continue;
+
+		/* Init labels to include region label */
+		rc = init_labels(nd_mapping, 1);
+
+		if (rc < 0)
+			return rc;
+
+		rc = __pmem_region_label_update(nd_region, nd_mapping, i,
+					NSLABEL_FLAG_UPDATING);
+
+		if (rc)
+			return rc;
+	}
+
+	/* Clear the UPDATING flag per UEFI 2.7 expectations */
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+
+		/* No need to update region label for non cxl format */
+		if (!ndd->cxl)
+			continue;
+
+		rc = __pmem_region_label_update(nd_region, nd_mapping, i, 0);
+
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
index 4883b3a1320f..0f428695017d 100644
--- a/drivers/nvdimm/label.h
+++ b/drivers/nvdimm/label.h
@@ -190,6 +190,7 @@ struct nd_namespace_label {
 struct nd_lsa_label {
 	union {
 		struct nd_namespace_label ns_label;
+		struct cxl_region_label rg_label;
 	};
 };
 
@@ -233,4 +234,5 @@ struct nd_region;
 struct nd_namespace_pmem;
 int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 		struct nd_namespace_pmem *nspm, resource_size_t size);
+int nd_pmem_region_label_update(struct nd_region *nd_region);
 #endif /* __LABEL_H__ */
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 23b9def71012..6cccb4d2fc7b 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -232,6 +232,18 @@ static ssize_t __alt_name_store(struct device *dev, const char *buf,
 	return rc;
 }
 
+int nd_region_label_update(struct nd_region *nd_region)
+{
+	int rc;
+
+	nvdimm_bus_lock(&nd_region->dev);
+	rc = nd_pmem_region_label_update(nd_region);
+	nvdimm_bus_unlock(&nd_region->dev);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(nd_region_label_update);
+
 static int nd_namespace_label_update(struct nd_region *nd_region,
 		struct device *dev)
 {
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 07d665f18bf6..2fdc92b29e8a 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -322,6 +322,26 @@ static inline void nsl_set_region_uuid(struct nvdimm_drvdata *ndd,
 		export_uuid(ns_label->cxl.region_uuid, uuid);
 }
 
+static inline bool rgl_uuid_equal(struct cxl_region_label *rg_label,
+				  const uuid_t *uuid)
+{
+	uuid_t tmp;
+
+	import_uuid(&tmp, rg_label->uuid);
+	return uuid_equal(&tmp, uuid);
+}
+
+static inline u64 rgl_get_checksum(struct cxl_region_label *rg_label)
+{
+	return __le64_to_cpu(rg_label->checksum);
+}
+
+static inline void rgl_set_checksum(struct cxl_region_label *rg_label,
+				    u64 checksum)
+{
+	rg_label->checksum = __cpu_to_le64(checksum);
+}
+
 bool nsl_validate_type_guid(struct nvdimm_drvdata *ndd,
 			    struct nd_namespace_label *nd_label, guid_t *guid);
 enum nvdimm_claim_class nsl_get_claim_class(struct nvdimm_drvdata *ndd,
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 0a55900842c8..b06bd45373f4 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -115,6 +115,13 @@ struct nd_interleave_set {
 	u64 altcookie;
 
 	guid_t type_guid;
+
+	/* v2.1 region label info */
+	uuid_t uuid;
+	int interleave_ways;
+	int interleave_granularity;
+	struct resource *res;
+	int nr_targets;
 };
 
 struct nd_mapping_desc {
@@ -302,6 +309,7 @@ int nvdimm_has_flush(struct nd_region *nd_region);
 int nvdimm_has_cache(struct nd_region *nd_region);
 int nvdimm_in_overwrite(struct nvdimm *nvdimm);
 bool is_nvdimm_sync(struct nd_region *nd_region);
+int nd_region_label_update(struct nd_region *nd_region);
 
 static inline int nvdimm_ctl(struct nvdimm *nvdimm, unsigned int cmd, void *buf,
 		unsigned int buf_len, int *cmd_rc)
-- 
2.34.1


