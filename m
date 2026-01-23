Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A4434A3AC
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769167912; cv=none; b=b5mmf0TXllI26JIchB5u5WT7xP3Ujq3RdmLZYsVYZ5ADzQz+dmo8yrb0Qv5Z5LezEP64bp7iLzCsg45diTY+sX6c13Sjam/E538yj1HJFSLdY1jUSbWY7Y3VusZ/CkRH2rD8PLvIkR8TFFN1nq3aXa7GTc1rbUYo+6jRaGzMIdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769167912; c=relaxed/simple;
	bh=T6Le4Sw56pSLJy+oCkhg4Y5NnmDD7d0n7ueM5l1OuLU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=NsXlk/hxJswN6YXWvb1Zvw9gOeZN74ARpfdcjmBwDDVR3yxzw4wGy7Z8mbB9HIMifX9MQlDF25zw8P+hW3qd1gnDg73aPRcvu+wDcOndfq3fVptWWcox4jUXwgGjIo56GM1buPTTQbnJdCDR+cvH0Aw9U8vp/SKjA4iyQb5ShrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=AtVGXnbe; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="AtVGXnbe"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260123113147epoutp04521821aeae5cedfde7f4e6f9ad971585~NWNavni2K0116501165epoutp04s
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260123113147epoutp04521821aeae5cedfde7f4e6f9ad971585~NWNavni2K0116501165epoutp04s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769167907;
	bh=3BcurE+TS4eJN7ewQ/AnjErQapQmb8iQp1p6oIuMtMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AtVGXnbeVDKbT3nPNHQ+UmohoQgyz8AKre7vCgUh1Gv7hjvvidGuwa1KRKkZDn2g1
	 zx7XoO5PusvmPbUqsXpv6ZtpgOibtLHb0yP+hWiB5WS+MCISOfLmKV7J69OaRKSDiT
	 L1tbdtBM0gPTQDyFUd1oHj/zrLH5nWmi4VkQfMZM=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260123113147epcas5p3ab7e0a04394763a32228728a13817aa9~NWNaZGXiK2902429024epcas5p3V;
	Fri, 23 Jan 2026 11:31:47 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.93]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dyG3k4cWNz6B9mB; Fri, 23 Jan
	2026 11:31:46 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260123113146epcas5p3d267b8d1aed388debac761ebf5f143d4~NWNZX_jzu2168121681epcas5p3U;
	Fri, 23 Jan 2026 11:31:46 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260123113145epsmtip20e51ca817a199039faf62ef5e8132738~NWNYNqhXE2685626856epsmtip2X;
	Fri, 23 Jan 2026 11:31:44 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V6 15/18] cxl/pmem_region: Introduce CONFIG_CXL_PMEM_REGION
 for core/pmem_region.c
Date: Fri, 23 Jan 2026 17:01:09 +0530
Message-Id: <20260123113112.3488381-16-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260123113112.3488381-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260123113146epcas5p3d267b8d1aed388debac761ebf5f143d4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260123113146epcas5p3d267b8d1aed388debac761ebf5f143d4
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
	<CGME20260123113146epcas5p3d267b8d1aed388debac761ebf5f143d4@epcas5p3.samsung.com>

As pmem region label update/delete has hard dependency on libnvdimm.
It is therefore put core/pmem_region.c under CONFIG_CXL_PMEM_REGION
control. It handles the dependency by selecting CONFIG_LIBNVDIMM
if not enabled.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
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
index 86efcc4fb963..296411be1c36 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -901,21 +901,11 @@ int devm_cxl_add_nvdimm(struct cxl_port *parent_port, struct cxl_memdev *cxlmd);
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
@@ -935,6 +925,20 @@ static inline int cxl_region_discovery(struct cxl_memdev *cxlmd)
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

