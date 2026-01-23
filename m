Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C6C385519
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769167915; cv=none; b=YhramNoQY6Cdu3Nno4GD0bpBWXkLAoxX1UGG5GbjJVX4ciEsJx6pc76EA2Mhnem4k1AwFCw1EthWo7SoTf6Y/D6lQzzQ53RW/Yg1DYiNFUzdE9zVhQZSol1WSrYTzz2z6oJITif8BkpLJ7lvX3z2MDXnsLHnA3rQgQU3lF1wfns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769167915; c=relaxed/simple;
	bh=EWyTHIXRjnxuz5bMEmopbPulR+K5y7vgs2pkq5uFWKU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=LUfIFJ9ges2bi3HtIZXULjSbREeLdAzRYtBLAvZP0pjy53kbaYNQWBK3t84Uogj3QgcIyqUU0GICCHs/OBIh1uDAa6IL4itxQN5k2r0XgaMYBKgcrmJ27wKkYRzzSBddN6iQQXy75CKSd4kY9au+XXvEua+XNHyufEAKvyUbBXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=b3/2YtWV; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="b3/2YtWV"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260123113150epoutp0469f1b19db652416473a7b89cc5e6523e~NWNdyfJUU3228032280epoutp04X
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260123113150epoutp0469f1b19db652416473a7b89cc5e6523e~NWNdyfJUU3228032280epoutp04X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769167911;
	bh=oYoasi3H98eaABmP5XK/+MqgF3n0XTF/ldFpMP/hfUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3/2YtWVbesOxUIXkzF8HvWOvjN5lZvkvkW/boUOn+xVx37LXkJcGK4trYZX1X4Dr
	 PojEGPe8qZlEhorvWPMbRZ6rXwgQMVAtIDpnKRKJzMaD9no6EvFEQeopGpdblV65mP
	 cXM4yTpLzw87VUs2uUumOElgY9LWtoPEm29ldQro=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260123113150epcas5p26fb3bfbd2b99e86dcfa93b37d1da6c46~NWNdiK0PV2197121971epcas5p2f;
	Fri, 23 Jan 2026 11:31:50 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.86]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dyG3p08N7z6B9m5; Fri, 23 Jan
	2026 11:31:50 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260123113149epcas5p1884531875d9676391e7ccc66a0f314d4~NWNcWmWly2520225202epcas5p1l;
	Fri, 23 Jan 2026 11:31:49 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260123113148epsmtip2d45ba503047a434d45d85eb073c9865a~NWNbI8bRF2681126811epsmtip2o;
	Fri, 23 Jan 2026 11:31:48 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V6 17/18] cxl/pmem_region: Create pmem region using
 information parsed from LSA
Date: Fri, 23 Jan 2026 17:01:11 +0530
Message-Id: <20260123113112.3488381-18-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260123113112.3488381-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260123113149epcas5p1884531875d9676391e7ccc66a0f314d4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260123113149epcas5p1884531875d9676391e7ccc66a0f314d4
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
	<CGME20260123113149epcas5p1884531875d9676391e7ccc66a0f314d4@epcas5p1.samsung.com>

create_pmem_region() creates CXL region based on region information
parsed from the Label Storage Area (LSA). This routine requires cxl
endpoint decoder and root decoder. Add cxl_find_root_decoder_by_port()
and cxl_find_free_ep_decoder() to find the root decoder and a free
endpoint decoder respectively.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/core/core.h        |   5 ++
 drivers/cxl/core/pmem_region.c | 133 +++++++++++++++++++++++++++++++++
 drivers/cxl/core/region.c      |  21 ++++--
 drivers/cxl/cxl.h              |   5 ++
 4 files changed, 156 insertions(+), 8 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 5ae693269771..8421ea0ef834 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -46,6 +46,7 @@ struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
 				     struct cxl_pmem_region_params *pmem_params,
 				     struct cxl_endpoint_decoder *cxled);
 struct cxl_region *to_cxl_region(struct device *dev);
+bool is_free_decoder(struct device *dev);
 
 #else
 static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
@@ -87,6 +88,10 @@ static inline struct cxl_region *to_cxl_region(struct device *dev)
 {
 	return NULL;
 }
+static inline bool is_free_decoder(struct device *dev)
+{
+	return false;
+}
 #define CXL_REGION_ATTR(x) NULL
 #define CXL_REGION_TYPE(x) NULL
 #define SET_CXL_REGION_ATTR(x)
diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
index 53d3d81e9676..cdee2788fad8 100644
--- a/drivers/cxl/core/pmem_region.c
+++ b/drivers/cxl/core/pmem_region.c
@@ -287,3 +287,136 @@ int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
 	cxlr->cxl_nvb = NULL;
 	return rc;
 }
+
+static int match_root_decoder_by_dport(struct device *dev, const void *data)
+{
+	const struct cxl_port *ep_port = data;
+	struct cxl_root_decoder *cxlrd;
+	struct cxl_port *root_port;
+	struct cxl_decoder *cxld;
+	struct cxl_dport *dport;
+	int i;
+
+	if (!is_root_decoder(dev))
+		return 0;
+
+	cxld = to_cxl_decoder(dev);
+	if (!(cxld->flags & CXL_DECODER_F_PMEM))
+		return 0;
+
+	cxlrd = to_cxl_root_decoder(dev);
+
+	root_port = cxlrd_to_port(cxlrd);
+	dport = cxl_find_dport_by_dev(root_port, ep_port->host_bridge);
+	if (!dport)
+		return 0;
+
+	for (i = 0; i < cxlrd->cxlsd.nr_targets; i++)
+		if (dport == cxlrd->cxlsd.target[i])
+			break;
+
+	if (i == cxlrd->cxlsd.nr_targets)
+		return 0;
+
+	return is_root_decoder(dev);
+}
+
+/**
+ * cxl_find_root_decoder_by_port() - find a cxl root decoder on cxl bus
+ * @port: any descendant port in CXL port topology
+ * @cxled: endpoint decoder
+ *
+ * Caller of this function must call put_device() when done as a device ref
+ * is taken via device_find_child()
+ */
+static struct cxl_root_decoder *
+cxl_find_root_decoder_by_port(struct cxl_port *port,
+			      struct cxl_endpoint_decoder *cxled)
+{
+	struct cxl_root *cxl_root __free(put_cxl_root) = find_cxl_root(port);
+	struct cxl_port *ep_port = cxled_to_port(cxled);
+	struct device *dev;
+
+	if (!cxl_root)
+		return NULL;
+
+	dev = device_find_child(&cxl_root->port.dev, ep_port,
+				match_root_decoder_by_dport);
+	if (!dev)
+		return NULL;
+
+	return to_cxl_root_decoder(dev);
+}
+
+static int match_free_ep_decoder(struct device *dev, const void *data)
+{
+	if (!is_endpoint_decoder(dev))
+		return 0;
+
+	return is_free_decoder(dev);
+}
+
+/**
+ * cxl_find_free_ep_decoder() - find a cxl endpoint decoder using cxl port
+ * @port: any descendant port in CXL port topology
+ *
+ * Caller of this function must call put_device() when done as a device ref
+ * is taken via device_find_child()
+ */
+static struct cxl_decoder *cxl_find_free_ep_decoder(struct cxl_port *port)
+{
+	struct device *dev;
+
+	dev = device_find_child(&port->dev, NULL, match_free_ep_decoder);
+	if (!dev)
+		return NULL;
+
+	return to_cxl_decoder(dev);
+}
+
+void create_pmem_region(struct nvdimm *nvdimm)
+{
+	struct cxl_pmem_region_params *params;
+	struct cxl_endpoint_decoder *cxled;
+	struct cxl_nvdimm *cxl_nvd;
+	struct cxl_memdev *cxlmd;
+	struct cxl_region *cxlr;
+
+	if (!nvdimm_has_cxl_region(nvdimm))
+		return;
+
+	lockdep_assert_held(&cxl_rwsem.region);
+	cxl_nvd = nvdimm_provider_data(nvdimm);
+	params = nvdimm_get_cxl_region_param(nvdimm);
+	cxlmd = cxl_nvd->cxlmd;
+
+	/* TODO: Region creation support only for interleave way == 1 */
+	if (!(params->nlabel == 1)) {
+		dev_dbg(&cxlmd->dev,
+				"Region Creation is not supported with iw > 1\n");
+		return;
+	}
+
+	struct cxl_decoder *cxld __free(put_cxl_decoder) =
+		cxl_find_free_ep_decoder(cxlmd->endpoint);
+	if (!cxld) {
+		dev_err(&cxlmd->dev, "CXL endpoint decoder not found\n");
+		return;
+	}
+
+	cxled = to_cxl_endpoint_decoder(&cxld->dev);
+
+	struct cxl_root_decoder *cxlrd __free(put_cxl_root_decoder) =
+		cxl_find_root_decoder_by_port(cxlmd->endpoint, cxled);
+	if (!cxlrd) {
+		dev_err(&cxlmd->dev, "CXL root decoder not found\n");
+		return;
+	}
+
+	cxlr = cxl_create_region(cxlrd, CXL_PARTMODE_PMEM,
+				 atomic_read(&cxlrd->region_id),
+				 params, cxled);
+	if (IS_ERR(cxlr))
+		dev_warn(&cxlmd->dev, "Region Creation failed\n");
+}
+EXPORT_SYMBOL_NS_GPL(create_pmem_region, "CXL");
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index f9b3dd6cee50..37b88641b818 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -838,25 +838,22 @@ static int check_commit_order(struct device *dev, void *data)
 	return 0;
 }
 
-static int match_free_decoder(struct device *dev, const void *data)
+bool is_free_decoder(struct device *dev)
 {
 	struct cxl_port *port = to_cxl_port(dev->parent);
 	struct cxl_decoder *cxld;
 	int rc;
 
-	if (!is_switch_decoder(dev))
-		return 0;
-
 	cxld = to_cxl_decoder(dev);
 
 	if (cxld->id != port->commit_end + 1)
-		return 0;
+		return false;
 
 	if (cxld->region) {
 		dev_dbg(dev->parent,
 			"next decoder to commit (%s) is already reserved (%s)\n",
 			dev_name(dev), dev_name(&cxld->region->dev));
-		return 0;
+		return false;
 	}
 
 	rc = device_for_each_child_reverse_from(dev->parent, dev, NULL,
@@ -865,9 +862,17 @@ static int match_free_decoder(struct device *dev, const void *data)
 		dev_dbg(dev->parent,
 			"unable to allocate %s due to out of order shutdown\n",
 			dev_name(dev));
-		return 0;
+		return false;
 	}
-	return 1;
+	return true;
+}
+
+static int match_free_decoder(struct device *dev, const void *data)
+{
+	if (!is_switch_decoder(dev))
+		return 0;
+
+	return is_free_decoder(dev);
 }
 
 static bool spa_maps_hpa(const struct cxl_region_params *p,
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 32a8296a833a..1fc3e6260a00 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -794,6 +794,7 @@ struct cxl_root *find_cxl_root(struct cxl_port *port);
 DEFINE_FREE(put_cxl_root, struct cxl_root *, if (_T) put_device(&_T->port.dev))
 DEFINE_FREE(put_cxl_port, struct cxl_port *, if (!IS_ERR_OR_NULL(_T)) put_device(&_T->dev))
 DEFINE_FREE(put_cxl_root_decoder, struct cxl_root_decoder *, if (!IS_ERR_OR_NULL(_T)) put_device(&_T->cxlsd.cxld.dev))
+DEFINE_FREE(put_cxl_decoder, struct cxl_decoder *, if (!IS_ERR_OR_NULL(_T)) put_device(&_T->dev))
 DEFINE_FREE(put_cxl_region, struct cxl_region *, if (!IS_ERR_OR_NULL(_T)) put_device(&_T->dev))
 
 int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd);
@@ -935,6 +936,7 @@ static inline int cxl_region_discovery(struct cxl_memdev *cxlmd)
 #ifdef CONFIG_CXL_PMEM_REGION
 bool is_cxl_pmem_region(struct device *dev);
 struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
+void create_pmem_region(struct nvdimm *nvdimm);
 #else
 static inline bool is_cxl_pmem_region(struct device *dev)
 {
@@ -944,6 +946,9 @@ static inline struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev)
 {
 	return NULL;
 }
+static inline void create_pmem_region(struct nvdimm *nvdimm)
+{
+}
 #endif
 
 void cxl_endpoint_parse_cdat(struct cxl_port *port);
-- 
2.34.1

