Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8BC32E75F
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763538820; cv=none; b=ZKtMpn5GoYM29Ddl3uVAlVOIGMvEiV+QUPkp2MZvrH0sXr807ZsWWch8Z+NTyZNWtSGAfgZyvPi0GJOsWXx35HXQZfpnMQpZiAes0KAL33HZJRHYaPDbm+9OW0TZc/RmVCIvhySTbSZ+N8UMmrhCrZcCMQusLPqhhoBbr5UVegs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763538820; c=relaxed/simple;
	bh=VQWxKAopaeO60DUBcEMSdVQoa1prMpXpDOwUpLcLDLQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=uL1M+sB+flhTTdeHGXz9jxmrzoNpQwgzTr3Gn1n2eIce+MJd+VkV6+u94M6AlQnOAu7MSOnSmmpW64AJsWZOx2dqugnj1rMnRDBCj5R5C6F5oPeNrOdRfekMiVJNXX8Jx3cZHxur20BjnZRCo8695SMO3l3TfUy3uCF8r10zYK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=VCE+29Yf; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="VCE+29Yf"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20251119075336epoutp049cbb3d8b044fec0c96cf1f7126dd193a~5WTXalWwh1676816768epoutp04Z
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20251119075336epoutp049cbb3d8b044fec0c96cf1f7126dd193a~5WTXalWwh1676816768epoutp04Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1763538816;
	bh=nRmk4CyFkpvjGxbn2pi4XQTyhVHs86/ZbxOiVLXLGKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCE+29YfJVrqKI6OAO4HBla3faffmq3PbNf7m37Uaz2RcJbx06KKtWd2C2FEEJsbC
	 2EQpRp1zLNZSph/w5xAWyI/tDIx52m0e8Rx3pbcRx4Qz5Phq8U10QxrKM9zOowF+CD
	 A+p86b4Jsgn+9sHt6AuJKVhIuBSJWX9+pSDqKrbw=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251119075336epcas5p3bfd918b9cb28d764dd04aacef9f3554f~5WTXGnxia0829208292epcas5p3X;
	Wed, 19 Nov 2025 07:53:36 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.90]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dBDHz33G9z2SSKd; Wed, 19 Nov
	2025 07:53:35 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20251119075335epcas5p3a8fdc68301233f899d9041a300309fa2~5WTVpryIm0406004060epcas5p3k;
	Wed, 19 Nov 2025 07:53:35 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251119075333epsmtip1ad0c9c9bc13dc254306e6c791530c2f3~5WTTzWIX92573225732epsmtip1-;
	Wed, 19 Nov 2025 07:53:32 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V4 14/17] cxl/pmem_region: Introduce CONFIG_CXL_PMEM_REGION
 for core/pmem_region.c
Date: Wed, 19 Nov 2025 13:22:52 +0530
Message-Id: <20251119075255.2637388-15-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251119075255.2637388-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251119075335epcas5p3a8fdc68301233f899d9041a300309fa2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075335epcas5p3a8fdc68301233f899d9041a300309fa2
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075335epcas5p3a8fdc68301233f899d9041a300309fa2@epcas5p3.samsung.com>

As pmem region label update/delete has hard dependency on libnvdimm.
It is therefore put core/pmem_region.c under CONFIG_CXL_PMEM_REGION
control. It handles the dependency by selecting CONFIG_LIBNVDIMM
if not enabled.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/Kconfig       | 15 +++++++++++++++
 drivers/cxl/core/Makefile |  3 ++-
 drivers/cxl/core/core.h   | 17 +++++++++++------
 drivers/cxl/core/region.c |  2 ++
 drivers/cxl/cxl.h         | 24 ++++++++++++++----------
 tools/testing/cxl/Kbuild  |  3 ++-
 6 files changed, 46 insertions(+), 18 deletions(-)

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
index 5ebbc3d3dde5..beeb9b7527b8 100644
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
@@ -89,17 +88,23 @@ static inline struct cxl_region *to_cxl_region(struct device *dev)
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
+	return 0;
+}
+#endif
+
 struct cxl_send_command;
 struct cxl_mem_query_commands;
 int cxl_query_cmd(struct cxl_mailbox *cxl_mbox,
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 9798120b208e..408e139718f1 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -3918,6 +3918,8 @@ static int cxl_region_probe(struct device *dev)
 			dev_dbg(&cxlr->dev, "CXL EDAC registration for region_id=%d failed\n",
 				cxlr->id);
 
+		if (!IS_ENABLED(CONFIG_CXL_PMEM_REGION))
+			return -EINVAL;
 		return devm_cxl_add_pmem_region(cxlr);
 	case CXL_PARTMODE_RAM:
 		rc = devm_cxl_region_edac_register(cxlr);
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

