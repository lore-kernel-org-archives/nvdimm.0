Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBCD32ED23
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763538812; cv=none; b=JJVrihJDaYM3P7TYyzT+6TvqZXIaECAxh1PcrI+s3Ryjfa0Om2j9JcvNYtYkus/Tqts7dhOwWSiI65ZDHJuxbUnL2b1gdXLHHi6/fqBHPDHGGd4ISSy+1OXUc2BtWTyiVf+VoYuArkWbv984pFMUNtVp2Vyq9WEVKCRzVeOp7g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763538812; c=relaxed/simple;
	bh=rCnFs+wTFiUzB8dwDWhtT0JfRAiF5oUhvonJGQ9Bzws=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=rBXuFY5I424wFCkc5h/MGMQxWqz+W6PVPM5LHSfAUw+luLnCCWOuRY5d5HzobYlLA5mfsOFY+nXV8lipg37p/dbvBu/SOfnYoldrX/CULCT0v/Q1aMBoxd+b5VG/0ccDmu6ARlbDtUGPXDTEJsypVmAzMhxv+qQO4ZZz3Ammf8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=kcxQOhVH; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="kcxQOhVH"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20251119075326epoutp02e3f1da1f035c02cdb382a2155f605765~5WTODPwHd2602426024epoutp028
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20251119075326epoutp02e3f1da1f035c02cdb382a2155f605765~5WTODPwHd2602426024epoutp028
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1763538806;
	bh=g71o0PINWhr1xwvhb/lFkayQCIafgmrL7rI+AkDSi7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kcxQOhVHa47TnJY+YHN7pj27wim8+CxB7jx4XkViN5n9OFmvcb5hbpHuegJ2NaL9E
	 Os3RNWKotjnnD/+Dnw8Ya6zESI4G8x5SZETc0d0fcvt8WKOgWxSg+K34G0EyLvAVOX
	 hvYTfXk50VqkILDocCQ7dwqvJtyJjbJbEZx/O8Oo=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251119075326epcas5p3c6a45700cffb798e2a79999acc8b4137~5WTNvkL3a0829208292epcas5p3B;
	Wed, 19 Nov 2025 07:53:26 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.89]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dBDHn39xNz6B9m8; Wed, 19 Nov
	2025 07:53:25 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20251119075324epcas5p1b0a7149ede962491e6be2d72d33f77eb~5WTMOZS7o1599915999epcas5p1a;
	Wed, 19 Nov 2025 07:53:24 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251119075323epsmtip1298d30dc1c8595c3634129f813fc0c23~5WTLHh0VD2604526045epsmtip1Y;
	Wed, 19 Nov 2025 07:53:23 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V4 10/17] cxl/mem: Refactor cxl pmem region auto-assembling
Date: Wed, 19 Nov 2025 13:22:48 +0530
Message-Id: <20251119075255.2637388-11-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251119075255.2637388-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251119075324epcas5p1b0a7149ede962491e6be2d72d33f77eb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075324epcas5p1b0a7149ede962491e6be2d72d33f77eb
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075324epcas5p1b0a7149ede962491e6be2d72d33f77eb@epcas5p1.samsung.com>

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

4. As cxlmd->ops->probe() calls registered cxl_region_discovery(), so
   move devm_cxl_add_nvdimm() before cxlmd->ops->probe(). It gurantees
   both the completion of endpoint probe and cxl_nvd presence before
   calling cxlmd->ops->probe().

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/core/region.c | 37 +++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h         |  5 +++++
 drivers/cxl/mem.c         | 18 +++++++++---------
 drivers/cxl/pci.c         |  4 +++-
 drivers/cxl/port.c        | 39 +--------------------------------------
 5 files changed, 55 insertions(+), 48 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 2cf5b29cefd2..3c868c4de4ec 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -3724,6 +3724,43 @@ int cxl_add_to_region(struct cxl_endpoint_decoder *cxled)
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
index ba17fa86d249..684a0d1b441a 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -904,6 +904,7 @@ struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
 int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
 struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
 u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa);
+int cxl_region_discovery(struct cxl_memdev *cxlmd);
 #else
 static inline bool is_cxl_pmem_region(struct device *dev)
 {
@@ -926,6 +927,10 @@ static inline u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint,
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
index 13d9e089ecaf..f5e3e2fca86c 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -115,15 +115,6 @@ static int cxl_mem_probe(struct device *dev)
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
@@ -143,6 +134,15 @@ static int cxl_mem_probe(struct device *dev)
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
 	if (cxlmd->ops) {
 		rc = cxlmd->ops->probe(cxlmd);
 		if (rc)
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index e21051d79b25..d56fdfe4b43b 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -907,6 +907,7 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct cxl_memdev_state *mds;
 	struct cxl_dev_state *cxlds;
 	struct cxl_register_map map;
+	struct cxl_memdev_ops ops;
 	struct cxl_memdev *cxlmd;
 	int rc, pmu_count;
 	unsigned int i;
@@ -1006,7 +1007,8 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc)
 		dev_dbg(&pdev->dev, "No CXL Features discovered\n");
 
-	cxlmd = devm_cxl_add_memdev(&pdev->dev, cxlds, NULL);
+	ops.probe = cxl_region_discovery;
+	cxlmd = devm_cxl_add_memdev(&pdev->dev, cxlds, &ops);
 	if (IS_ERR(cxlmd))
 		return PTR_ERR(cxlmd);
 
diff --git a/drivers/cxl/port.c b/drivers/cxl/port.c
index d5fd0c5ae49b..ad98b2881fed 100644
--- a/drivers/cxl/port.c
+++ b/drivers/cxl/port.c
@@ -31,33 +31,6 @@ static void schedule_detach(void *cxlmd)
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
@@ -83,17 +56,7 @@ static int cxl_endpoint_port_probe(struct cxl_port *port)
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

