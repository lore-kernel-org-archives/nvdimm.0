Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B8A299A87
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753877845; cv=none; b=fnOzQukTlKBB/HVh967uwsNaAMKFVXeFBlU71sVt9OJYk6eL8fd9I6zzCevZrGxJ+ZGmgOy64ynKSir2/ev010zzkQ5nm8/ikthXaNA3iBvDeQWo1z3HxPoJazT7MjaTycb3ajkkeiP6RWiQ/JveIxTdkHhrrjEWVuTNDiJ+3MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753877845; c=relaxed/simple;
	bh=q1RmwaSaCoJg9QiVsr2SuLf+Y7cGNrt8HcIXbs0sgVg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=h4649g15VLjJSAZlgcTl+PEdo07kqqPkGCw+pGGHqZso2uuqq5ArmD8rrlhqsqM9BFPfINrffvLNGtFL+f6XkBNEI1VPVrxMIy2A/w3Bg2XArrnsvwFZl3DGj/l2X+smI4KvVlhtBIgLUQhp31pcIuMN9IVV7UAJBHQCWpHiswc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=P3CwSO3r; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="P3CwSO3r"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250730121722epoutp0428acb60a99543a192f64097f7ea838a2~XBpreStme1462314623epoutp04P
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:17:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250730121722epoutp0428acb60a99543a192f64097f7ea838a2~XBpreStme1462314623epoutp04P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753877842;
	bh=woh8MWM/hYWGLrYWFxwEtkhOewpOSHKHgy16jC5/KuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3CwSO3rm+vlAdDGC+ZgRApAQciup4Ehkq64+z6tZVRuPUz2z7BkXBsqvhIA21Q5R
	 PeC0I2PG/8Ppp8yxjRDE7TEOzK0YC/J76Kmsp76ayky7Ul/vICaPq56xbLh4FAEAY/
	 +XTCEJqrSm7PQOI/lo6SO49frT48KwQkGsvfF/wQ=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250730121721epcas5p2be3201bf2bd0ea23e0676d645d807b04~XBpq0CDXD1340713407epcas5p2D;
	Wed, 30 Jul 2025 12:17:21 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.87]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4bsWS03GH3z6B9m5; Wed, 30 Jul
	2025 12:17:20 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250730121242epcas5p4bdfc11e82e28d525364262fb2b6d8feb~XBlnEHh4N2430924309epcas5p4p;
	Wed, 30 Jul 2025 12:12:42 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250730121241epsmtip1f1f2c514fb546bf544978d7f9523112e~XBll6uwfN0426504265epsmtip1A;
	Wed, 30 Jul 2025 12:12:41 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V2 15/20] cxl: Add a routine to find cxl root decoder on cxl
 bus using cxl port
Date: Wed, 30 Jul 2025 17:42:04 +0530
Message-Id: <20250730121209.303202-16-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250730121209.303202-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250730121242epcas5p4bdfc11e82e28d525364262fb2b6d8feb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121242epcas5p4bdfc11e82e28d525364262fb2b6d8feb
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121242epcas5p4bdfc11e82e28d525364262fb2b6d8feb@epcas5p4.samsung.com>

Add cxl_find_root_decoder_by_port() to find root decoder on cxl bus.
It is used to find root decoder using cxl port.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/core/port.c | 27 +++++++++++++++++++++++++++
 drivers/cxl/cxl.h       |  1 +
 2 files changed, 28 insertions(+)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index ba743e31f721..c1bb0e0286ed 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -524,6 +524,33 @@ struct cxl_switch_decoder *to_cxl_switch_decoder(struct device *dev)
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
index 129db2e49aa7..e249372b642d 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -857,6 +857,7 @@ struct cxl_nvdimm *to_cxl_nvdimm(struct device *dev);
 bool is_cxl_nvdimm(struct device *dev);
 int devm_cxl_add_nvdimm(struct cxl_port *parent_port, struct cxl_memdev *cxlmd);
 struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_port *port);
+struct cxl_root_decoder *cxl_find_root_decoder_by_port(struct cxl_port *port);
 
 #ifdef CONFIG_CXL_REGION
 bool is_cxl_pmem_region(struct device *dev);
-- 
2.34.1

