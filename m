Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B73637D10F
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769167904; cv=none; b=Ml3yJAEXYe3b/4K79WUtQypyUhQsESyDJUoVflI7dYgJFWZumHjuWXAjhnGP+UXhFnQJ+/yCc5ATj7VdWUwftrcVLIEcynQFbDSn8ocJS5/dDyYC2JdUFMcdwTQg4ErMWkyIZK+CLQ1cgRZLn89UJ16m8/os0k0ToNKP/zTJTaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769167904; c=relaxed/simple;
	bh=HMONvmV7Y1bknVkpYYOr9kqrOZElT5JD2Ggj4UUk5Us=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=cg3dDK3UABq5b6CNetdvhO6IoBJHh5vzbUAFx91A5vPIlJGiQkzmAiCgXySCa4RKIg9S+YcwwB7f4DPLrSZac8BTLctZBJjAegUHJFSYn+lZG+985rtDOY5CdFSEPUEgA+6IDUlltHMWbEMaOShD1pA/+GbwwxSvpfvmjO/PFGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=O/Hir2ae; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="O/Hir2ae"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260123113139epoutp021eddeeee5b18278c5c04da8ee82662d2~NWNTPIP-00069700697epoutp02g
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260123113139epoutp021eddeeee5b18278c5c04da8ee82662d2~NWNTPIP-00069700697epoutp02g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769167899;
	bh=KJnVVuFcZ2jV9iJ1V/KWC/G0+lhbD6YEhwRdoEULiMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/Hir2aev+Sya8O7vriHbscwNKUO1QZw5N0t7UwVqXVE8AY3AoAQuF9SiUxdpMTjE
	 YmTrnIzo/RiSADcRPaAYUwGWfz3zdruvRMOuh30diApUADChqPx2YREi3py/PI54t7
	 qog0s/TWxo92lsRK6ez6SnjloJJ0sU2IqAMrJvNM=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260123113139epcas5p134c15e58d816330aace7b939253c70f2~NWNS933Wm0724607246epcas5p1B;
	Fri, 23 Jan 2026 11:31:39 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.95]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dyG3Z4mCtz6B9m7; Fri, 23 Jan
	2026 11:31:38 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260123113138epcas5p4bc54ae41192dbc9c958c43ad8a80b5c6~NWNR7mAIy2258322583epcas5p4A;
	Fri, 23 Jan 2026 11:31:38 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260123113136epsmtip2c71518c1755ce62511b0fb888218ae44~NWNQmn8OZ2685726857epsmtip2V;
	Fri, 23 Jan 2026 11:31:36 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V6 10/18] cxl/mem: Refactor cxl pmem region auto-assembling
Date: Fri, 23 Jan 2026 17:01:04 +0530
Message-Id: <20260123113112.3488381-11-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260123113112.3488381-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260123113138epcas5p4bc54ae41192dbc9c958c43ad8a80b5c6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260123113138epcas5p4bc54ae41192dbc9c958c43ad8a80b5c6
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
	<CGME20260123113138epcas5p4bc54ae41192dbc9c958c43ad8a80b5c6@epcas5p4.samsung.com>

In 84ec985944ef3, devm_cxl_add_nvdimm() sequence was changed and called
before devm_cxl_add_endpoint(). It's because cxl pmem region auto-assembly
used to get called at last in cxl_endpoint_port_probe(), which requires
cxl_nvd presence.

For cxl region persistency, region creation happens during nvdimm_probe
which need the completion of endpoint probe.

In order to accommodate both cxl pmem region auto-assembly and cxl region
persistency, refactored following

1. Re-Sequence devm_cxl_add_nvdimm() after devm_cxl_add_endpoint(). This
   will be called only after successful completion of endpoint probe.

2. Create cxl_region_discovery() which performs pmem region
   auto-assembly and remove cxl pmem region auto-assembly from
   cxl_endpoint_port_probe()

3. Register cxl_region_discovery() with devm_cxl_add_memdev() which gets
   called during cxl_pci_probe() in context of cxl_mem_probe()

4. As cxlmd->attach->probe() calls registered cxl_region_discovery(), so
   move devm_cxl_add_nvdimm() before cxlmd->attach->probe(). It guarantees
   both the completion of endpoint probe and cxl_nvd presence before
   calling cxlmd->attach->probe().

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/core/region.c | 37 +++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h         |  5 +++++
 drivers/cxl/mem.c         | 18 +++++++++---------
 drivers/cxl/pci.c         |  4 +++-
 drivers/cxl/port.c        | 39 +--------------------------------------
 5 files changed, 55 insertions(+), 48 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index ae899f68551f..26238fb5e8cf 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -3727,6 +3727,43 @@ int cxl_add_to_region(struct cxl_endpoint_decoder *cxled)
 }
 EXPORT_SYMBOL_NS_GPL(cxl_add_to_region, "CXL");
 
+static int discover_region(struct device *dev, void *unused)
+{
+	struct cxl_endpoint_decoder *cxled;
+	int rc;
+
+	if (!is_endpoint_decoder(dev))
+		return 0;
+
+	cxled = to_cxl_endpoint_decoder(dev);
+	if ((cxled->cxld.flags & CXL_DECODER_F_ENABLE) == 0)
+		return 0;
+
+	if (cxled->state != CXL_DECODER_STATE_AUTO)
+		return 0;
+
+	/*
+	 * Region enumeration is opportunistic, if this add-event fails,
+	 * continue to the next endpoint decoder.
+	 */
+	rc = cxl_add_to_region(cxled);
+	if (rc)
+		dev_dbg(dev, "failed to add to region: %#llx-%#llx\n",
+			cxled->cxld.hpa_range.start, cxled->cxld.hpa_range.end);
+
+	return 0;
+}
+
+int cxl_region_discovery(struct cxl_memdev *cxlmd)
+{
+	struct cxl_port *port = cxlmd->endpoint;
+
+	device_for_each_child(&port->dev, NULL, discover_region);
+
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(cxl_region_discovery, "CXL");
+
 u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa)
 {
 	struct cxl_region_ref *iter;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index c796c3db36e0..86efcc4fb963 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -906,6 +906,7 @@ struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
 int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
 struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
 u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa);
+int cxl_region_discovery(struct cxl_memdev *cxlmd);
 #else
 static inline bool is_cxl_pmem_region(struct device *dev)
 {
@@ -928,6 +929,10 @@ static inline u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint,
 {
 	return 0;
 }
+static inline int cxl_region_discovery(struct cxl_memdev *cxlmd)
+{
+	return 0;
+}
 #endif
 
 void cxl_endpoint_parse_cdat(struct cxl_port *port);
diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index 333c366b69e7..7d19528d9b55 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -114,15 +114,6 @@ static int cxl_mem_probe(struct device *dev)
 		return -ENXIO;
 	}
 
-	if (cxl_pmem_size(cxlds) && IS_ENABLED(CONFIG_CXL_PMEM)) {
-		rc = devm_cxl_add_nvdimm(parent_port, cxlmd);
-		if (rc) {
-			if (rc == -ENODEV)
-				dev_info(dev, "PMEM disabled by platform\n");
-			return rc;
-		}
-	}
-
 	if (dport->rch)
 		endpoint_parent = parent_port->uport_dev;
 	else
@@ -142,6 +133,15 @@ static int cxl_mem_probe(struct device *dev)
 			return rc;
 	}
 
+	if (cxl_pmem_size(cxlds) && IS_ENABLED(CONFIG_CXL_PMEM)) {
+		rc = devm_cxl_add_nvdimm(parent_port, cxlmd);
+		if (rc) {
+			if (rc == -ENODEV)
+				dev_info(dev, "PMEM disabled by platform\n");
+			return rc;
+		}
+	}
+
 	if (cxlmd->attach) {
 		rc = cxlmd->attach->probe(cxlmd);
 		if (rc)
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 549368a9c868..70b40a10be7a 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -903,6 +903,7 @@ __ATTRIBUTE_GROUPS(cxl_rcd);
 static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct pci_host_bridge *host_bridge = pci_find_host_bridge(pdev->bus);
+	struct cxl_memdev_attach memdev_attach = { 0 };
 	struct cxl_dpa_info range_info = { 0 };
 	struct cxl_memdev_state *mds;
 	struct cxl_dev_state *cxlds;
@@ -1006,7 +1007,8 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc)
 		dev_dbg(&pdev->dev, "No CXL Features discovered\n");
 
-	cxlmd = devm_cxl_add_memdev(cxlds, NULL);
+	memdev_attach.probe = cxl_region_discovery;
+	cxlmd = devm_cxl_add_memdev(cxlds, &memdev_attach);
 	if (IS_ERR(cxlmd))
 		return PTR_ERR(cxlmd);
 
diff --git a/drivers/cxl/port.c b/drivers/cxl/port.c
index 7937e7e53797..fbeff1978bfb 100644
--- a/drivers/cxl/port.c
+++ b/drivers/cxl/port.c
@@ -30,33 +30,6 @@ static void schedule_detach(void *cxlmd)
 	schedule_cxl_memdev_detach(cxlmd);
 }
 
-static int discover_region(struct device *dev, void *unused)
-{
-	struct cxl_endpoint_decoder *cxled;
-	int rc;
-
-	if (!is_endpoint_decoder(dev))
-		return 0;
-
-	cxled = to_cxl_endpoint_decoder(dev);
-	if ((cxled->cxld.flags & CXL_DECODER_F_ENABLE) == 0)
-		return 0;
-
-	if (cxled->state != CXL_DECODER_STATE_AUTO)
-		return 0;
-
-	/*
-	 * Region enumeration is opportunistic, if this add-event fails,
-	 * continue to the next endpoint decoder.
-	 */
-	rc = cxl_add_to_region(cxled);
-	if (rc)
-		dev_dbg(dev, "failed to add to region: %#llx-%#llx\n",
-			cxled->cxld.hpa_range.start, cxled->cxld.hpa_range.end);
-
-	return 0;
-}
-
 static int cxl_switch_port_probe(struct cxl_port *port)
 {
 	/* Reset nr_dports for rebind of driver */
@@ -82,17 +55,7 @@ static int cxl_endpoint_port_probe(struct cxl_port *port)
 	if (rc)
 		return rc;
 
-	rc = devm_cxl_endpoint_decoders_setup(port);
-	if (rc)
-		return rc;
-
-	/*
-	 * Now that all endpoint decoders are successfully enumerated, try to
-	 * assemble regions from committed decoders
-	 */
-	device_for_each_child(&port->dev, NULL, discover_region);
-
-	return 0;
+	return devm_cxl_endpoint_decoders_setup(port);
 }
 
 static int cxl_port_probe(struct device *dev)
-- 
2.34.1

