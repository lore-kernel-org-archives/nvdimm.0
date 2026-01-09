Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B61935EDCD
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962735; cv=none; b=Ljrn8ZS3r4CnJD4iUm6dizBc8+tjnH1DjNN6ugVEMwD9rA0xtp2CmvA4iyvgdo6R0885AjtYcvC7/cx0zr3Cgr3ZzS0+e1ES72UO+xKIMHA9rGP4xPTCWe028LcjAgak3ZMZgXa36bi/2DFB26yQx9p/imJyoqcXBelnUqejZbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962735; c=relaxed/simple;
	bh=ZkKdwtiVXB/lWeF3AgZpQgdlWvHOCMpzKltTnKZFs2M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=iMeyZplnFsLKAYxxLu+//9Y01SUz/VNtSuC+P4fo/kIptm1lmSt9bOA1XMxka4mYolzmYMgAvcDFfOE/ZapIeq100Pp3hWTLmpBGaz05kDK1+BxAb7PFyabpuCsmWaRQSt/IuQJ5EBUaLQIbHy75T8LKTDs+Vf38YoAsPzlLZLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bzsnCXX9; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bzsnCXX9"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260109124531epoutp02f86dcd2b6626316a0dba7dbf2cfa8456~JELy-ojqU1955219552epoutp02j
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260109124531epoutp02f86dcd2b6626316a0dba7dbf2cfa8456~JELy-ojqU1955219552epoutp02j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767962731;
	bh=f/FHwXws18MmLB1jbXYZVDE1sctsfNmc5mK+mKONCIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bzsnCXX9gi/3cW/KFebSxluiE7/jM11LnBwGgaCxZp6jmMGgZISuCLTIoJd+aiQyz
	 b5ktPO6QyLINcaNonUhJg8VUB27FUgNnAJttOMlt0is4hLBfEI8ul0JtdNtDnCyWI3
	 /YiELsFXxdv9qkLlUhkM4Kb9WfldaD3G3osRVr1k=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260109124530epcas5p3da37884a6970d94b4ae5032e0a50507c~JELyb0ENA2090720907epcas5p3v;
	Fri,  9 Jan 2026 12:45:30 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.93]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dnhMG21s8z6B9m9; Fri,  9 Jan
	2026 12:45:30 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260109124529epcas5p1d740589383c6428ce53b454f8ed42307~JELxafwYA3012130121epcas5p1g;
	Fri,  9 Jan 2026 12:45:29 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260109124528epsmtip13c15696e4a06b358ebaf7bab08aeb3c5~JELwVqZnc0977809778epsmtip1q;
	Fri,  9 Jan 2026 12:45:28 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V5 14/17] cxl/pmem_region: Introduce CONFIG_CXL_PMEM_REGION
 for core/pmem_region.c
Date: Fri,  9 Jan 2026 18:14:34 +0530
Message-Id: <20260109124437.4025893-15-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260109124437.4025893-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260109124529epcas5p1d740589383c6428ce53b454f8ed42307
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260109124529epcas5p1d740589383c6428ce53b454f8ed42307
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124529epcas5p1d740589383c6428ce53b454f8ed42307@epcas5p1.samsung.com>

As pmem region label update/delete has hard dependency on libnvdimm.
It is therefore put core/pmem_region.c under CONFIG_CXL_PMEM_REGION
control. It handles the dependency by selecting CONFIG_LIBNVDIMM
if not enabled.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/Kconfig       | 15 +++++++++++++++
 drivers/cxl/core/Makefile |  3 ++-
 drivers/cxl/core/core.h   | 18 +++++++++++-------
 drivers/cxl/cxl.h         | 24 ++++++++++++++----------
 tools/testing/cxl/Kbuild  |  3 ++-
 5 files changed, 44 insertions(+), 19 deletions(-)

diff --git a/drivers/cxl/Kconfig b/drivers/cxl/Kconfig
index f1361ed6a0d4..307fed8f1f56 100644
--- a/drivers/cxl/Kconfig
+++ b/drivers/cxl/Kconfig
@@ -211,6 +211,21 @@ config CXL_REGION
 
 	  If unsure say 'y'
 
+config CXL_PMEM_REGION
+	bool "CXL: Pmem Region Support"
+	default CXL_BUS
+	depends on CXL_REGION
+	depends on ARCH_HAS_PMEM_API
+	depends on PHYS_ADDR_T_64BIT
+	depends on BLK_DEV
+	select LIBNVDIMM
+	help
+	   Enable the CXL core to enumerate and provision CXL pmem regions.
+	   A CXL pmem region need to update region label into LSA. For LSA
+	   update/delete libnvdimm is required.
+
+	   If unsure say 'y'
+
 config CXL_REGION_INVALIDATION_TEST
 	bool "CXL: Region Cache Management Bypass (TEST)"
 	depends on CXL_REGION
diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
index fe0fcab6d730..399157beb917 100644
--- a/drivers/cxl/core/Makefile
+++ b/drivers/cxl/core/Makefile
@@ -16,7 +16,8 @@ cxl_core-y += pmu.o
 cxl_core-y += cdat.o
 cxl_core-y += ras.o
 cxl_core-$(CONFIG_TRACING) += trace.o
-cxl_core-$(CONFIG_CXL_REGION) += region.o pmem_region.o
+cxl_core-$(CONFIG_CXL_REGION) += region.o
+cxl_core-$(CONFIG_CXL_PMEM_REGION) += pmem_region.o
 cxl_core-$(CONFIG_CXL_MCE) += mce.o
 cxl_core-$(CONFIG_CXL_FEATURES) += features.o
 cxl_core-$(CONFIG_CXL_EDAC_MEM_FEATURES) += edac.o
diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 4eed243c0d7d..5ae693269771 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -34,7 +34,6 @@ int cxl_decoder_detach(struct cxl_region *cxlr,
 #define CXL_REGION_ATTR(x) (&dev_attr_##x.attr)
 #define CXL_REGION_TYPE(x) (&cxl_region_type)
 #define SET_CXL_REGION_ATTR(x) (&dev_attr_##x.attr),
-#define CXL_PMEM_REGION_TYPE(x) (&cxl_pmem_region_type)
 #define CXL_DAX_REGION_TYPE(x) (&cxl_dax_region_type)
 int cxl_region_init(void);
 void cxl_region_exit(void);
@@ -47,7 +46,6 @@ struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
 				     struct cxl_pmem_region_params *pmem_params,
 				     struct cxl_endpoint_decoder *cxled);
 struct cxl_region *to_cxl_region(struct device *dev);
-int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
 
 #else
 static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
@@ -89,17 +87,23 @@ static inline struct cxl_region *to_cxl_region(struct device *dev)
 {
 	return NULL;
 }
-static inline int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
-{
-	return 0;
-}
 #define CXL_REGION_ATTR(x) NULL
 #define CXL_REGION_TYPE(x) NULL
 #define SET_CXL_REGION_ATTR(x)
-#define CXL_PMEM_REGION_TYPE(x) NULL
 #define CXL_DAX_REGION_TYPE(x) NULL
 #endif
 
+#ifdef CONFIG_CXL_PMEM_REGION
+#define CXL_PMEM_REGION_TYPE(x) (&cxl_pmem_region_type)
+int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
+#else
+#define CXL_PMEM_REGION_TYPE(x) NULL
+static inline int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
+{
+	return -EINVAL;
+}
+#endif
+
 struct cxl_send_command;
 struct cxl_mem_query_commands;
 int cxl_query_cmd(struct cxl_mailbox *cxl_mbox,
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 684a0d1b441a..6ac3b40cb5ff 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -899,21 +899,11 @@ int devm_cxl_add_nvdimm(struct cxl_port *parent_port, struct cxl_memdev *cxlmd);
 struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_port *port);
 
 #ifdef CONFIG_CXL_REGION
-bool is_cxl_pmem_region(struct device *dev);
-struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
 int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
 struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
 u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa);
 int cxl_region_discovery(struct cxl_memdev *cxlmd);
 #else
-static inline bool is_cxl_pmem_region(struct device *dev)
-{
-	return false;
-}
-static inline struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev)
-{
-	return NULL;
-}
 static inline int cxl_add_to_region(struct cxl_endpoint_decoder *cxled)
 {
 	return 0;
@@ -933,6 +923,20 @@ static inline int cxl_region_discovery(struct cxl_memdev *cxlmd)
 }
 #endif
 
+#ifdef CONFIG_CXL_PMEM_REGION
+bool is_cxl_pmem_region(struct device *dev);
+struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
+#else
+static inline bool is_cxl_pmem_region(struct device *dev)
+{
+	return false;
+}
+static inline struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev)
+{
+	return NULL;
+}
+#endif
+
 void cxl_endpoint_parse_cdat(struct cxl_port *port);
 void cxl_switch_parse_cdat(struct cxl_dport *dport);
 
diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
index ad2496b38fdd..024922326a6b 100644
--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -59,7 +59,8 @@ cxl_core-y += $(CXL_CORE_SRC)/pmu.o
 cxl_core-y += $(CXL_CORE_SRC)/cdat.o
 cxl_core-y += $(CXL_CORE_SRC)/ras.o
 cxl_core-$(CONFIG_TRACING) += $(CXL_CORE_SRC)/trace.o
-cxl_core-$(CONFIG_CXL_REGION) += $(CXL_CORE_SRC)/region.o $(CXL_CORE_SRC)/pmem_region.o
+cxl_core-$(CONFIG_CXL_REGION) += $(CXL_CORE_SRC)/region.o
+cxl_core-$(CONFIG_CXL_PMEM_REGION) += $(CXL_CORE_SRC)/pmem_region.o
 cxl_core-$(CONFIG_CXL_MCE) += $(CXL_CORE_SRC)/mce.o
 cxl_core-$(CONFIG_CXL_FEATURES) += $(CXL_CORE_SRC)/features.o
 cxl_core-$(CONFIG_CXL_EDAC_MEM_FEATURES) += $(CXL_CORE_SRC)/edac.o
-- 
2.34.1

