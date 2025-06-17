Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205DD2EAD0F
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750165213; cv=none; b=AgpNCD/D+xTtZpeb94xsrv7Jx9AcZ/Zt6syU2Wii75Ga8hpXtcvBaklcjeU6ktW291brG7WkLXw66rR0Dx6rvKNFZWv4HzUn8cL5ZUgY4JW7nvKN7cAKkQRABIvnIhRtlkcqsoCZvhMY4OTO3uNzCNikJ3rbf8dR4M2KHxoGC5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750165213; c=relaxed/simple;
	bh=gPcip00Ae9V1ypW8c5qjbHBMdcj6s1GbFJnfwCwA9Kw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=JrlNSBjxKcJuY5+caQQAxiPd7rDGjHRaxzX8uposBVUw571VvImFvVgzIZ+mGmpT5UV6EJRIj3vw5kBY7D0qm93JKYFlWNrTaBUtugl80MM4IOJvzlrducUsa3JHuZpbEsWXG1W91s7HV8/hnLoDhMCmrqywDYrci92XV4gggAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QuHjcdaQ; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QuHjcdaQ"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250617130006epoutp04c457c66308cbb2887bcfb7b1a65594ab~J1fuS1CGO2139921399epoutp04g
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:00:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250617130006epoutp04c457c66308cbb2887bcfb7b1a65594ab~J1fuS1CGO2139921399epoutp04g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750165206;
	bh=A/Cy3T56QlQXjfksu3OwaCf4ASliC35sKPe6O/G+gfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QuHjcdaQVH6ojD1vR8rQKmkBs7qUTPgTWmS/V019cSO3KlqJfbMb1b15BTw+lJcNN
	 laC3j/or/XirME4EPiR7+96sfbFpvZaqP0X7sgv/PqKcpUOYqPa+ybFHZhEVhLiBzp
	 Q4FZu8ODdXj0M1Ls3wDDyDKcJttVQC1FqqNvUBzM=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250617130006epcas5p1030a231b30efa5e63a1fe92830fe9d6c~J1ftrEfe52452824528epcas5p1t;
	Tue, 17 Jun 2025 13:00:06 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4bM6R970gnz6B9m7; Tue, 17 Jun
	2025 13:00:05 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124043epcas5p21e5b77aa3a6acfa7e01847ffd58350ed~J1Oy-3VE70929809298epcas5p2u;
	Tue, 17 Jun 2025 12:40:43 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124040epsmtip2828309c22b13ef864a4e8c99c0fd132f~J1Owe5a7q2543925439epsmtip2o;
	Tue, 17 Jun 2025 12:40:40 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, s.neeraj@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: [RFC PATCH 13/20] cxl/mem: Refactor cxl pmem region auto-assembling
Date: Tue, 17 Jun 2025 18:09:37 +0530
Message-Id: <1213349904.281750165205974.JavaMail.epsvc@epcpadp1new>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250617123944.78345-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250617124043epcas5p21e5b77aa3a6acfa7e01847ffd58350ed
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124043epcas5p21e5b77aa3a6acfa7e01847ffd58350ed
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124043epcas5p21e5b77aa3a6acfa7e01847ffd58350ed@epcas5p2.samsung.com>

In 84ec985944ef3, For cxl pmem region auto-assembly after endpoint port
probing, cxl_nvd presence was required. And for cxl region persistency,
region creation happens during nvdimm_probe which need the completion
of endpoint probe.

It is therefore refactored cxl pmem region auto-assembly after endpoint
probing to cxl mem probing

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/core/port.c | 38 ++++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h       |  1 +
 drivers/cxl/mem.c       | 27 ++++++++++++++++++---------
 drivers/cxl/port.c      | 38 --------------------------------------
 4 files changed, 57 insertions(+), 47 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 78a5c2c25982..bca668193c49 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1038,6 +1038,44 @@ void put_cxl_root(struct cxl_root *cxl_root)
 }
 EXPORT_SYMBOL_NS_GPL(put_cxl_root, "CXL");
 
+static int discover_region(struct device *dev, void *root)
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
+	rc = cxl_add_to_region(root, cxled);
+	if (rc)
+		dev_dbg(dev, "failed to add to region: %#llx-%#llx\n",
+			cxled->cxld.hpa_range.start, cxled->cxld.hpa_range.end);
+
+	return 0;
+}
+
+void cxl_region_discovery(struct cxl_port *port)
+{
+	struct cxl_port *root;
+	struct cxl_root *cxl_root __free(put_cxl_root) = find_cxl_root(port);
+
+	root = &cxl_root->port;
+
+	device_for_each_child(&port->dev, root, discover_region);
+}
+EXPORT_SYMBOL_NS_GPL(cxl_region_discovery, "CXL");
+
 static struct cxl_dport *find_dport(struct cxl_port *port, int id)
 {
 	struct cxl_dport *dport;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index dcf2a127efc7..9423ea3509ad 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -869,6 +869,7 @@ bool is_cxl_nvdimm(struct device *dev);
 bool is_cxl_nvdimm_bridge(struct device *dev);
 int devm_cxl_add_nvdimm(struct cxl_port *parent_port, struct cxl_memdev *cxlmd);
 struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_port *port);
+void cxl_region_discovery(struct cxl_port *port);
 
 #ifdef CONFIG_CXL_REGION
 bool is_cxl_pmem_region(struct device *dev);
diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index 2f03a4d5606e..aaea4eb178ef 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -152,15 +152,6 @@ static int cxl_mem_probe(struct device *dev)
 		return -ENXIO;
 	}
 
-	if (resource_size(&cxlds->pmem_res) && IS_ENABLED(CONFIG_CXL_PMEM)) {
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
@@ -180,6 +171,24 @@ static int cxl_mem_probe(struct device *dev)
 			return rc;
 	}
 
+	if (resource_size(&cxlds->pmem_res) && IS_ENABLED(CONFIG_CXL_PMEM)) {
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
+	 * Earlier it was part of cxl_endpoint_port_probe, So moved it here
+	 * as cxl_nvd of the memdev needs to be available during the pmem
+	 * region auto-assembling
+	 */
+	cxl_region_discovery(cxlmd->endpoint);
+
 	/*
 	 * The kernel may be operating out of CXL memory on this device,
 	 * there is no spec defined way to determine whether this device
diff --git a/drivers/cxl/port.c b/drivers/cxl/port.c
index d2bfd1ff5492..361544760a4c 100644
--- a/drivers/cxl/port.c
+++ b/drivers/cxl/port.c
@@ -30,33 +30,6 @@ static void schedule_detach(void *cxlmd)
 	schedule_cxl_memdev_detach(cxlmd);
 }
 
-static int discover_region(struct device *dev, void *root)
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
-	rc = cxl_add_to_region(root, cxled);
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
@@ -95,7 +68,6 @@ static int cxl_endpoint_port_probe(struct cxl_port *port)
 	struct cxl_memdev *cxlmd = to_cxl_memdev(port->uport_dev);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 	struct cxl_hdm *cxlhdm;
-	struct cxl_port *root;
 	int rc;
 
 	rc = cxl_dvsec_rr_decode(cxlds, &info);
@@ -125,20 +97,10 @@ static int cxl_endpoint_port_probe(struct cxl_port *port)
 	rc = devm_cxl_enumerate_decoders(cxlhdm, &info);
 	if (rc)
 		return rc;
-
 	/*
 	 * This can't fail in practice as CXL root exit unregisters all
 	 * descendant ports and that in turn synchronizes with cxl_port_probe()
 	 */
-	struct cxl_root *cxl_root __free(put_cxl_root) = find_cxl_root(port);
-
-	root = &cxl_root->port;
-
-	/*
-	 * Now that all endpoint decoders are successfully enumerated, try to
-	 * assemble regions from committed decoders
-	 */
-	device_for_each_child(&port->dev, root, discover_region);
 
 	return 0;
 }
-- 
2.34.1


