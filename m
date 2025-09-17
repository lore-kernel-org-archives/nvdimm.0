Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750182EC572
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115857; cv=none; b=SArYbsFbNEVG6BnSqEettzpno5kH2U/dMCOTBwPUh+s3CwAs5c2tKCElmEZs4KDOFMY3ppbGvKyVRXi/tbL97YhiLn2tpeBHYPQmnCxE5lQTGqG/hQLXbevjAgeTTwzI3CDak772PcSXNTjIo9h91CKmXizYfi0aiFZIV7DTRsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115857; c=relaxed/simple;
	bh=QxgrxiYPyfgIgdcckKir9l5MmECb0kuUk85QadtiF30=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=NpJtNfz42ei5Z5N1fEA1A1eicr3aoMHv/K9wOk+sC2CZkja88urYOxPz8r27ola/7ElNMyQT7030WwUCkN5CQvVTy0Qzl915RxraPU7VfAotl4aUOmLw5dCHYnCgsYhUIekCRiyTWUlXB1gV2bxkQxYVIbWEf9Mnafrvl03/6rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=KDit7dYT; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KDit7dYT"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250917133053epoutp023eb21d403f26aa1eb41c402a748f9d03~mFQ2-lzKj0519905199epoutp02W
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250917133053epoutp023eb21d403f26aa1eb41c402a748f9d03~mFQ2-lzKj0519905199epoutp02W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758115853;
	bh=J/7DkBNdXlSoe7d+7pBkn1ckZK936GrNoSihihPioVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KDit7dYTbE0dQXYj5H2NP5NA0O1+biffePsN1Eyxm3QfGXTL4n3Nwuo25Y7aMQ0YA
	 mhB3XvPEA7qDGSPsw0H7VcH6EN4u8fqFz+o4oc8Q1b2S3Aa0aCBxDqVWCVb4XohUEB
	 SJw0doADesW5lCH2g9Fc9gOxmDYomjYRA440IWyY=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250917133053epcas5p2a2e7ee94016c20160f8511f1d1f1c1f4~mFQ2s2pw80979409794epcas5p2l;
	Wed, 17 Sep 2025 13:30:53 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.90]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cRfmC6rNqz3hhT8; Wed, 17 Sep
	2025 13:30:51 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250917133051epcas5p230bd96e4bad5f8608505d7a56a84f1c3~mFQ1TI4_U1088010880epcas5p2f;
	Wed, 17 Sep 2025 13:30:51 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250917133050epsmtip15e3b7e6d6345f1152ed8470fa5f77247~mFQ0P_e6x0457804578epsmtip1Z;
	Wed, 17 Sep 2025 13:30:50 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 15/20] cxl: Add a routine to find cxl root decoder on cxl
 bus using cxl port
Date: Wed, 17 Sep 2025 18:59:35 +0530
Message-Id: <20250917132940.1566437-16-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917132940.1566437-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917133051epcas5p230bd96e4bad5f8608505d7a56a84f1c3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917133051epcas5p230bd96e4bad5f8608505d7a56a84f1c3
References: <20250917132940.1566437-1-s.neeraj@samsung.com>
	<CGME20250917133051epcas5p230bd96e4bad5f8608505d7a56a84f1c3@epcas5p2.samsung.com>

Add cxl_find_root_decoder_by_port() to find root decoder on cxl bus.
It is used to find root decoder using cxl port.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/core/port.c | 27 +++++++++++++++++++++++++++
 drivers/cxl/cxl.h       |  1 +
 2 files changed, 28 insertions(+)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 8f36ff413f5d..647d9ce32b64 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -518,6 +518,33 @@ struct cxl_switch_decoder *to_cxl_switch_decoder(struct device *dev)
 }
 EXPORT_SYMBOL_NS_GPL(to_cxl_switch_decoder, "CXL");
 
+static int match_root_decoder(struct device *dev, const void *data)
+{
+	return is_root_decoder(dev);
+}
+
+/**
+ * cxl_find_root_decoder_by_port() - find a cxl root decoder on cxl bus
+ * @port: any descendant port in CXL port topology
+ */
+struct cxl_root_decoder *cxl_find_root_decoder_by_port(struct cxl_port *port)
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
+	/* Release device ref taken via device_find_child() */
+	put_device(dev);
+	return to_cxl_root_decoder(dev);
+}
+EXPORT_SYMBOL_NS_GPL(cxl_find_root_decoder_by_port, "CXL");
+
 static void cxl_ep_release(struct cxl_ep *ep)
 {
 	put_device(ep->ep);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 3abadc3dc82e..1eb1aca7c69f 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -866,6 +866,7 @@ struct cxl_nvdimm *to_cxl_nvdimm(struct device *dev);
 bool is_cxl_nvdimm(struct device *dev);
 int devm_cxl_add_nvdimm(struct cxl_port *parent_port, struct cxl_memdev *cxlmd);
 struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_port *port);
+struct cxl_root_decoder *cxl_find_root_decoder_by_port(struct cxl_port *port);
 
 #ifdef CONFIG_CXL_REGION
 bool is_cxl_pmem_region(struct device *dev);
-- 
2.34.1

