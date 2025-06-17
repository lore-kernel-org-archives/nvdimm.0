Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632332E426C
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750165386; cv=none; b=N34xfZTT4HYSVF1emn4/qtw+HIAOhChKQA9zlnl+GHSviSgCBttT9SL0GtKB8J8vri5paX2djef96QlzxH8+L0NMwz7/teUt2/X2hGVFrF8d29VcsTxBxAOm89tkBTzuZWKM42ceBDrtP1/pUAWNN5qfhx7cYmhAFFKdpKLjwt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750165386; c=relaxed/simple;
	bh=ngiGZdHS8E72RNXvQRN6M+Ui4Kv9jmBIPG8wCKbQwFA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=b3vrZKQS1k/332xrNY+/W4wdvtPJb8FfDr1HbkbtE/LRshn02gLPbfP/EyztxJtlUTJRUB1RpyrjbugUIFMCzeNr/jp8KeO1eYmHqSWWi4UpFID/5gWT+/hkWfI7o/dVC6YMPB+9dhNHJIFLn/QMaOxpokcl94RFacKpbX2pZek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=od17VWWs; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="od17VWWs"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250617130302epoutp0136abfa823ef9edf71e42e9d4b0c3f608~J1iSKiTbm0862708627epoutp01C
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:03:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250617130302epoutp0136abfa823ef9edf71e42e9d4b0c3f608~J1iSKiTbm0862708627epoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750165382;
	bh=F5IBe9g49uE9iXoen1UDTjlWZYYseGQ+lsEscfDE+2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=od17VWWsms7v+CtXKbnm4MFVP9O9df/9NvBh794GIdRA+yGIrfT4YuPGY43lp+xVQ
	 /4i5tJ9A9XEHIFpi31pnMj3jIm+CKqXvqK85n5WLyCXI713anWDwgbnik2kIBpCxdn
	 7R3i4UvC4ZMOI50xrrRzX9Uut54UracRxNxftnNM=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250617130302epcas5p3cbb34c72a0f4cebe74e7793766374157~J1iRrNV3w0481704817epcas5p3n;
	Tue, 17 Jun 2025 13:03:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bM6VZ0ZGWz3hhT3; Tue, 17 Jun
	2025 13:03:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250617124049epcas5p1de7eeee3b5ddd12ea221ca3ebf22f6e8~J1O4gZOHQ1367713677epcas5p1m;
	Tue, 17 Jun 2025 12:40:49 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124046epsmtip2d632f094b89f5f4fece7b66a03afaac8~J1O1-5klY2555425554epsmtip2L;
	Tue, 17 Jun 2025 12:40:46 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, s.neeraj@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: [RFC PATCH 15/20] cxl: Add a routine to find cxl root decoder on
 cxl bus
Date: Tue, 17 Jun 2025 18:09:39 +0530
Message-Id: <1295226194.21750165382072.JavaMail.epsvc@epcpadp2new>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250617123944.78345-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250617124049epcas5p1de7eeee3b5ddd12ea221ca3ebf22f6e8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124049epcas5p1de7eeee3b5ddd12ea221ca3ebf22f6e8
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124049epcas5p1de7eeee3b5ddd12ea221ca3ebf22f6e8@epcas5p1.samsung.com>

Add cxl_find_root_decoder to find root decoder on cxl bus. It is used to
find root decoder during region creation

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/core/port.c | 26 ++++++++++++++++++++++++++
 drivers/cxl/cxl.h       |  1 +
 2 files changed, 27 insertions(+)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 2452f7c15b2d..94d9322b8e38 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -513,6 +513,32 @@ struct cxl_switch_decoder *to_cxl_switch_decoder(struct device *dev)
 }
 EXPORT_SYMBOL_NS_GPL(to_cxl_switch_decoder, "CXL");
 
+static int match_root_decoder(struct device *dev, void *data)
+{
+	return is_root_decoder(dev);
+}
+
+/**
+ * cxl_find_root_decoder() - find a cxl root decoder on cxl bus
+ * @port: any descendant port in root-cxl-port topology
+ */
+struct cxl_root_decoder *cxl_find_root_decoder(struct cxl_port *port)
+{
+	struct cxl_root *cxl_root __free(put_cxl_root) = find_cxl_root(port);
+	struct device *dev;
+
+	if (!cxl_root)
+		return NULL;
+
+	dev = device_find_child(&cxl_root->port.dev, NULL, match_root_decoder);
+
+	if (!dev)
+		return NULL;
+
+	return to_cxl_root_decoder(dev);
+}
+EXPORT_SYMBOL_NS_GPL(cxl_find_root_decoder, "CXL");
+
 static void cxl_ep_release(struct cxl_ep *ep)
 {
 	put_device(ep->ep);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 30c80e04cb27..2c6a782d0941 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -871,6 +871,7 @@ bool is_cxl_nvdimm_bridge(struct device *dev);
 int devm_cxl_add_nvdimm(struct cxl_port *parent_port, struct cxl_memdev *cxlmd);
 struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_port *port);
 void cxl_region_discovery(struct cxl_port *port);
+struct cxl_root_decoder *cxl_find_root_decoder(struct cxl_port *port);
 
 #ifdef CONFIG_CXL_REGION
 bool is_cxl_pmem_region(struct device *dev);
-- 
2.34.1


