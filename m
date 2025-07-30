Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72C529C326
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753877836; cv=none; b=IgTFI5cDntiVY/Ro9uBgHSgbZ6QmF2CTRQZHj6vTXtKxr/yM8DsQn8EjJdPEa+C8PoR3FEaVxEHDOrLo7wQnEAcsrwdoexufdg6c8y+h4Jh0+4dmgqARXuwBpmJIhOce8/OKhtGl/o9tkOsDHrcNFhBCS6WS8C8kNy2FMj9dF6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753877836; c=relaxed/simple;
	bh=qAdC9aBkJUKNnO/g/nLFH61iWN+OJOKFuuCCFMAv+b8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=GMKW99qLxPdHgX8WEOHN+F54QkrwLRGHRbBI42s/FTRdAhqwtP8xVl7fl4NCRr4NO/TvOeExyqHes3GeKgn2nbdjq0sHQqTr4tUfcv3e6B+YfoTp5dFYSLj2C67uhJdWGO35DCk/zk3u5afbjvVT3jgHU0eD/2lk3SBXT1SngAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=GoHt2t2X; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="GoHt2t2X"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250730121713epoutp020c651a20f8dcb2263b9b83945860f564~XBpjX_hBe1755417554epoutp027
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:17:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250730121713epoutp020c651a20f8dcb2263b9b83945860f564~XBpjX_hBe1755417554epoutp027
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753877833;
	bh=NcNBY58XXp4tN3EyfSbWSefHOyeLtL5pkjnA0GKmKv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GoHt2t2X1zdp1Ow4+DH77iPubFmzoWzrKfefjiY8jAvKx3u99jDwXeFWKpW5wUY5X
	 q0gaRB16UhN91kALq9bopSwF+CTGA8FKR+Y7FS3sluxCl9jYej/Ol4SZBwWHA7IlwI
	 Ggl/hAF+DYuEXuNonH5/am9ylbV2zoOGcTnZtDRs=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250730121712epcas5p4c447dac428dabc841ee545c5ffa25b2f~XBpi91v_90041000410epcas5p4k;
	Wed, 30 Jul 2025 12:17:12 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.91]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4bsWRq6rv5z2SSKZ; Wed, 30 Jul
	2025 12:17:11 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250730121239epcas5p37956b2999f61e17e8dbfbde7972cef35~XBlkYIl8g0107401074epcas5p33;
	Wed, 30 Jul 2025 12:12:39 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250730121238epsmtip1d0dabb4d91af0fa30a476a6c70c1325c~XBljUKzdA0450704507epsmtip1T;
	Wed, 30 Jul 2025 12:12:38 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V2 13/20] cxl/mem: Refactor cxl pmem region auto-assembling
Date: Wed, 30 Jul 2025 17:42:02 +0530
Message-Id: <20250730121209.303202-14-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250730121209.303202-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250730121239epcas5p37956b2999f61e17e8dbfbde7972cef35
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121239epcas5p37956b2999f61e17e8dbfbde7972cef35
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121239epcas5p37956b2999f61e17e8dbfbde7972cef35@epcas5p3.samsung.com>

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

2. Moved cxl pmem region auto-assembly from cxl_endpoint_port_probe() to
   cxl_mem_probe() after devm_cxl_add_nvdimm(). It gurantees both the
   completion of endpoint probe and cxl_nvd presence before its call.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/core/region.c | 33 +++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h         |  4 ++++
 drivers/cxl/mem.c         | 24 +++++++++++++++---------
 drivers/cxl/port.c        | 39 +--------------------------------------
 4 files changed, 53 insertions(+), 47 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index e9bf42d91689..eef501f3384c 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -3497,6 +3497,39 @@ int cxl_add_to_region(struct cxl_endpoint_decoder *cxled)
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
+void cxl_region_discovery(struct cxl_port *port)
+{
+	device_for_each_child(&port->dev, NULL, discover_region);
+}
+EXPORT_SYMBOL_NS_GPL(cxl_region_discovery, "CXL");
+
 u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa)
 {
 	struct cxl_region_ref *iter;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index b7111e3568d0..6edcec95e9ba 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -864,6 +864,7 @@ struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
 int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
 struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
 u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa);
+void cxl_region_discovery(struct cxl_port *port);
 #else
 static inline bool is_cxl_pmem_region(struct device *dev)
 {
@@ -886,6 +887,9 @@ static inline u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint,
 {
 	return 0;
 }
+static inline void cxl_region_discovery(struct cxl_port *port)
+{
+}
 #endif
 
 void cxl_endpoint_parse_cdat(struct cxl_port *port);
diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index 6e6777b7bafb..54501616ff09 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -152,15 +152,6 @@ static int cxl_mem_probe(struct device *dev)
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
@@ -184,6 +175,21 @@ static int cxl_mem_probe(struct device *dev)
 	if (rc)
 		dev_dbg(dev, "CXL memdev EDAC registration failed rc=%d\n", rc);
 
+	if (cxl_pmem_size(cxlds) && IS_ENABLED(CONFIG_CXL_PMEM)) {
+		rc = devm_cxl_add_nvdimm(parent_port, cxlmd);
+		if (rc) {
+			if (rc == -ENODEV)
+				dev_info(dev, "PMEM disabled by platform\n");
+			return rc;
+		}
+	}
+
+	/*
+	 * Now that all endpoint decoders are successfully enumerated, try to
+	 * assemble region autodiscovery from committed decoders.
+	 */
+	cxl_region_discovery(cxlmd->endpoint);
+
 	/*
 	 * The kernel may be operating out of CXL memory on this device,
 	 * there is no spec defined way to determine whether this device
diff --git a/drivers/cxl/port.c b/drivers/cxl/port.c
index fe4b593331da..090ae3577f32 100644
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
 	struct cxl_hdm *cxlhdm;
@@ -121,17 +94,7 @@ static int cxl_endpoint_port_probe(struct cxl_port *port)
 	if (rc)
 		return rc;
 
-	rc = devm_cxl_enumerate_decoders(cxlhdm, &info);
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
+	return devm_cxl_enumerate_decoders(cxlhdm, &info);
 }
 
 static int cxl_port_probe(struct device *dev)
-- 
2.34.1

