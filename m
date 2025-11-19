Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4403321BF
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763538826; cv=none; b=gyzEMuScQo4qG5aJSnVrSQoxK4T4iLRE8xIqHbaRkbZ9cxF2sbNbn2L84anCqFooEuG0jESIxEIpDXgicXJscXwbc4kE30mXDI8RQmK4TgLr2N76Js+jhxJfJZJ6aVeZJ9nsOvUr1oMf/7z+VjUTrnEr9dLdHOck2iT/XsqkY48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763538826; c=relaxed/simple;
	bh=36BUp7N3TJ5x9YM//xTIELhreovBXHMMAZwu22ohaJk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=XFD4m345n2rZuYu0UNWpv1+NnK8et11SaT86rHbpVi65Dgwe4DNG99Ahkg6sf1oOXSosIsP+VZhMpn1GXjhvUX9d3jRVaM6qZQn1kF3NQQT4qK2G/ZCdfh2FJOikx/S4KRyQz9HpYplBG41lrVRd6z009FlIUXJ9RFH7k8OP65k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=W7liOqfM; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="W7liOqfM"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20251119075341epoutp0143eb4662f709339a1ee218facaeafa5d~5WTcE03ab3210332103epoutp01T
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20251119075341epoutp0143eb4662f709339a1ee218facaeafa5d~5WTcE03ab3210332103epoutp01T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1763538821;
	bh=QtgKPtRaF+g9hj163fkaFzL+e2IHQeT6w33mvY5sDrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7liOqfMrYIYC3zWROdyDhaT59r3hybN3Bm/EdPh2v7WmyXRNzZJ2lgfZrkq0fPGj
	 yjTZe88i2fX/SM3UeqdtdUwX4KkIJnXXEKj7BbcC1tNDsa/Czc7z/MvL98R/LbRG3p
	 37vgGwy8jTJLbX93FaHxDOKxjfKyNCGmgi0kkZNo=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251119075340epcas5p393a0ff565080928e3b548b5457b4a8d9~5WTbLE_Nh0354303543epcas5p3J;
	Wed, 19 Nov 2025 07:53:40 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.89]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dBDJ35f3sz3hhTC; Wed, 19 Nov
	2025 07:53:39 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20251119075339epcas5p3160bfa74362cc974e917fcc9b83ee112~5WTZsFM1m0829308293epcas5p3c;
	Wed, 19 Nov 2025 07:53:39 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251119075338epsmtip1f9aadad485c7447031067e3ea16ee03a~5WTYiLO2K2605226052epsmtip1a;
	Wed, 19 Nov 2025 07:53:38 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V4 16/17] cxl/pmem_region: Create pmem region using
 information parsed from LSA
Date: Wed, 19 Nov 2025 13:22:54 +0530
Message-Id: <20251119075255.2637388-17-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251119075255.2637388-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251119075339epcas5p3160bfa74362cc974e917fcc9b83ee112
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075339epcas5p3160bfa74362cc974e917fcc9b83ee112
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075339epcas5p3160bfa74362cc974e917fcc9b83ee112@epcas5p3.samsung.com>

create_pmem_region() creates cxl region based on region information
parsed from LSA. This routine required cxl root decoder and endpoint
decoder. Therefore added cxl_find_root_decoder_by_port() and
cxl_find_free_ep_decoder(). These routines find cxl root decoder and
free endpoint decoder on cxl bus using cxl port

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/core/core.h        |  4 ++
 drivers/cxl/core/pmem_region.c | 97 ++++++++++++++++++++++++++++++++++
 drivers/cxl/core/region.c      | 13 +++--
 drivers/cxl/cxl.h              |  5 ++
 4 files changed, 115 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index beeb9b7527b8..dd2efd3deb5e 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -35,6 +35,7 @@ int cxl_decoder_detach(struct cxl_region *cxlr,
 #define CXL_REGION_TYPE(x) (&cxl_region_type)
 #define SET_CXL_REGION_ATTR(x) (&dev_attr_##x.attr),
 #define CXL_DAX_REGION_TYPE(x) (&cxl_dax_region_type)
+int verify_free_decoder(struct device *dev);
 int cxl_region_init(void);
 void cxl_region_exit(void);
 int cxl_get_poison_by_endpoint(struct cxl_port *port);
@@ -88,6 +89,9 @@ static inline struct cxl_region *to_cxl_region(struct device *dev)
 {
 	return NULL;
 }
+static inline int verify_free_decoder(struct device *dev)
+{
+}
 #define CXL_REGION_ATTR(x) NULL
 #define CXL_REGION_TYPE(x) NULL
 #define SET_CXL_REGION_ATTR(x)
diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
index be4feb73aafc..06665937c180 100644
--- a/drivers/cxl/core/pmem_region.c
+++ b/drivers/cxl/core/pmem_region.c
@@ -291,3 +291,100 @@ int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
 	cxlr->cxl_nvb = NULL;
 	return rc;
 }
+
+static int match_root_decoder(struct device *dev, const void *data)
+{
+	return is_root_decoder(dev);
+}
+
+/**
+ * cxl_find_root_decoder_by_port() - find a cxl root decoder on cxl bus
+ * @port: any descendant port in CXL port topology
+ *
+ * Caller of this function must call put_device() when done as a device ref
+ * is taken via device_find_child()
+ */
+static struct cxl_root_decoder *cxl_find_root_decoder_by_port(struct cxl_port *port)
+{
+	struct cxl_root *cxl_root __free(put_cxl_root) = find_cxl_root(port);
+	struct device *dev;
+
+	if (!cxl_root)
+		return NULL;
+
+	dev = device_find_child(&cxl_root->port.dev, NULL, match_root_decoder);
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
+	return verify_free_decoder(dev);
+}
+
+/**
+ * cxl_find_endpoint_decoder_by_port() - find a cxl root decoder on cxl bus
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
+	struct cxl_nvdimm *cxl_nvd;
+	struct cxl_memdev *cxlmd;
+	struct cxl_pmem_region_params *params;
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
+	struct cxl_root_decoder *cxlrd __free(put_cxl_root_decoder) =
+		cxl_find_root_decoder_by_port(cxlmd->endpoint);
+	if (!cxlrd) {
+		dev_err(&cxlmd->dev, "CXL root decoder not found\n");
+		return;
+	}
+
+	struct cxl_decoder *cxld __free(put_cxl_decoder) =
+		cxl_find_free_ep_decoder(cxlmd->endpoint);
+	if (!cxlrd) {
+		dev_err(&cxlmd->dev, "CXL endpoint decoder not found\n");
+		return;
+	}
+
+	cxlr = cxl_create_region(cxlrd, CXL_PARTMODE_PMEM,
+			atomic_read(&cxlrd->region_id),
+			params, cxld);
+	if (IS_ERR(cxlr))
+		dev_warn(&cxlmd->dev, "Region Creation failed\n");
+}
+EXPORT_SYMBOL_NS_GPL(create_pmem_region, "CXL");
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 408e139718f1..96f3cf4143b8 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -835,15 +835,12 @@ static int check_commit_order(struct device *dev, void *data)
 	return 0;
 }
 
-static int match_free_decoder(struct device *dev, const void *data)
+int verify_free_decoder(struct device *dev)
 {
 	struct cxl_port *port = to_cxl_port(dev->parent);
 	struct cxl_decoder *cxld;
 	int rc;
 
-	if (!is_switch_decoder(dev))
-		return 0;
-
 	cxld = to_cxl_decoder(dev);
 
 	if (cxld->id != port->commit_end + 1)
@@ -867,6 +864,14 @@ static int match_free_decoder(struct device *dev, const void *data)
 	return 1;
 }
 
+static int match_free_decoder(struct device *dev, const void *data)
+{
+	if (!is_switch_decoder(dev))
+		return 0;
+
+	return verify_free_decoder(dev);
+}
+
 static bool spa_maps_hpa(const struct cxl_region_params *p,
 			 const struct range *range)
 {
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 8c76c4a981bf..088841a3e238 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -792,6 +792,7 @@ struct cxl_root *find_cxl_root(struct cxl_port *port);
 DEFINE_FREE(put_cxl_root, struct cxl_root *, if (_T) put_device(&_T->port.dev))
 DEFINE_FREE(put_cxl_port, struct cxl_port *, if (!IS_ERR_OR_NULL(_T)) put_device(&_T->dev))
 DEFINE_FREE(put_cxl_root_decoder, struct cxl_root_decoder *, if (!IS_ERR_OR_NULL(_T)) put_device(&_T->cxlsd.cxld.dev))
+DEFINE_FREE(put_cxl_decoder, struct cxl_decoder *, if (!IS_ERR_OR_NULL(_T)) put_device(&_T->dev))
 DEFINE_FREE(put_cxl_region, struct cxl_region *, if (!IS_ERR_OR_NULL(_T)) put_device(&_T->dev))
 
 int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd);
@@ -933,6 +934,7 @@ static inline int cxl_region_discovery(struct cxl_memdev *cxlmd)
 #ifdef CONFIG_CXL_PMEM_REGION
 bool is_cxl_pmem_region(struct device *dev);
 struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
+void create_pmem_region(struct nvdimm *nvdimm);
 #else
 static inline bool is_cxl_pmem_region(struct device *dev)
 {
@@ -942,6 +944,9 @@ static inline struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev)
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

