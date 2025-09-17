Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B346E316189
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115835; cv=none; b=Rc0LM9AREISjh6FLZbcQGoNzoeMiQA2WM/NdDnRQvN/VOgeR5yYOd0Ft3LMEVC0ig2SZmIbxXKAvrJt0LUUrSigGOPWf/0lBy/PTVwBcPp67y2rl/NZpVA3DhTL6oCTSOUhi6MYvp3kGNMIAYxNZK/oIn+3iPL71AizCGteR1PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115835; c=relaxed/simple;
	bh=IHPKBKUHBCQv+vf6QHv35uUvAqo5mXtMFlwSA2YvK5c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=WaCu3rfLKiBCf5fhNIikJoRLSHGm/xxqcj39AKVEgmQ2hn9ZItX/uA5+FV68egYrRAmo9BHSrZpKC2ga/PiJQjsH0uCxK3dZ17cUAsJP5YW29zupSaYRIpjDg5hdDW+Nm6gfm26F8Xn22T62FvTyo03kjWuUHA1AMfSIisbuZdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=P51RT7E7; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="P51RT7E7"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250917133030epoutp039101351fdb56424ec17082567c167d90~mFQhuNWlH2738627386epoutp03k
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250917133030epoutp039101351fdb56424ec17082567c167d90~mFQhuNWlH2738627386epoutp03k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758115830;
	bh=jc8FD7JXvWhCV/EAXTp2IPOjNKOfDlPIfA8NoFMX5Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P51RT7E7iSmStjEQmWZBWazXqDm6362jnv+wqenNic4mvzulPsHN1DwU9RZTUyL/n
	 q5qggymSLlxfpcRofq6kbBNfh8lyl8vytkkIC9o2b9GQKc2K/iDMsNHRLBu00HYDeO
	 vkIPyLJl3JzUf0Y0CzqJLQWpieI2UrPak/50jpp0=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250917133030epcas5p28a1db4b3bf38de9298a8b0df17dfcd67~mFQhbbN8E1088010880epcas5p2F;
	Wed, 17 Sep 2025 13:30:30 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.88]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cRfln1g85z6B9m7; Wed, 17 Sep
	2025 13:30:29 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250917133028epcas5p4ee7d30605213ca589de19b850898cc7b~mFQgFunr21259712597epcas5p4L;
	Wed, 17 Sep 2025 13:30:28 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250917133027epsmtip1dcec33e4c88b0644b65509e6c3a8a23e~mFQfCn9Md0527905279epsmtip1m;
	Wed, 17 Sep 2025 13:30:27 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 01/20] nvdimm/label: Introduce NDD_REGION_LABELING flag
 to set region label
Date: Wed, 17 Sep 2025 18:59:21 +0530
Message-Id: <20250917132940.1566437-2-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917132940.1566437-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917133028epcas5p4ee7d30605213ca589de19b850898cc7b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917133028epcas5p4ee7d30605213ca589de19b850898cc7b
References: <20250917132940.1566437-1-s.neeraj@samsung.com>
	<CGME20250917133028epcas5p4ee7d30605213ca589de19b850898cc7b@epcas5p4.samsung.com>

Prior to LSA 2.1 version, LSA contain only namespace labels. LSA 2.1
introduced in CXL 2.0 Spec, which contain region label along with
namespace label.

NDD_LABELING flag is used for namespace. Introduced NDD_REGION_LABELING
flag for region label. Based on these flags nvdimm driver performs
operation on namespace label or region label.

NDD_REGION_LABELING will be utilized by cxl driver to enable LSA 2.1
region label support

Accordingly updated label index version

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/dimm.c      |  1 +
 drivers/nvdimm/dimm_devs.c |  7 +++++++
 drivers/nvdimm/label.c     | 21 +++++++++++++++++----
 drivers/nvdimm/nd.h        |  1 +
 include/linux/libnvdimm.h  |  3 +++
 5 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
index 91d9163ee303..bda22cb94e5b 100644
--- a/drivers/nvdimm/dimm.c
+++ b/drivers/nvdimm/dimm.c
@@ -62,6 +62,7 @@ static int nvdimm_probe(struct device *dev)
 	if (rc < 0)
 		dev_dbg(dev, "failed to unlock dimm: %d\n", rc);
 
+	ndd->cxl = nvdimm_check_region_label_format(ndd->dev);
 
 	/*
 	 * EACCES failures reading the namespace label-area-properties
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 21498d461fde..918c3db93195 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -18,6 +18,13 @@
 
 static DEFINE_IDA(dimm_ida);
 
+bool nvdimm_check_region_label_format(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+
+	return test_bit(NDD_REGION_LABELING, &nvdimm->flags);
+}
+
 /*
  * Retrieve bus and dimm handle and return if this bus supports
  * get_config_data commands
diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 04f4a049599a..0a9b6c5cb2c3 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -688,11 +688,24 @@ static int nd_label_write_index(struct nvdimm_drvdata *ndd, int index, u32 seq,
 		- (unsigned long) to_namespace_index(ndd, 0);
 	nsindex->labeloff = __cpu_to_le64(offset);
 	nsindex->nslot = __cpu_to_le32(nslot);
-	nsindex->major = __cpu_to_le16(1);
-	if (sizeof_namespace_label(ndd) < 256)
+
+	/* Set LSA Label Index Version */
+	if (ndd->cxl) {
+		/* CXL r3.2: Table 9-9 Label Index Block Layout */
+		nsindex->major = __cpu_to_le16(2);
 		nsindex->minor = __cpu_to_le16(1);
-	else
-		nsindex->minor = __cpu_to_le16(2);
+	} else {
+		nsindex->major = __cpu_to_le16(1);
+		/*
+		 * NVDIMM Namespace Specification
+		 * Table 2: Namespace Label Index Block Fields
+		 */
+		if (sizeof_namespace_label(ndd) < 256)
+			nsindex->minor = __cpu_to_le16(1);
+		else /* UEFI 2.7: Label Index Block Definitions */
+			nsindex->minor = __cpu_to_le16(2);
+	}
+
 	nsindex->checksum = __cpu_to_le64(0);
 	if (flags & ND_NSINDEX_INIT) {
 		unsigned long *free = (unsigned long *) nsindex->free;
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index cc5c8f3f81e8..158809c2be9e 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -522,6 +522,7 @@ void nvdimm_set_labeling(struct device *dev);
 void nvdimm_set_locked(struct device *dev);
 void nvdimm_clear_locked(struct device *dev);
 int nvdimm_security_setup_events(struct device *dev);
+bool nvdimm_check_region_label_format(struct device *dev);
 #if IS_ENABLED(CONFIG_NVDIMM_KEYS)
 int nvdimm_security_unlock(struct device *dev);
 #else
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 28f086c4a187..5696715c33bb 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -44,6 +44,9 @@ enum {
 	/* dimm provider wants synchronous registration by __nvdimm_create() */
 	NDD_REGISTER_SYNC = 8,
 
+	/* dimm supports region labels (LSA Format 2.1) */
+	NDD_REGION_LABELING = 9,
+
 	/* need to set a limit somewhere, but yes, this is likely overkill */
 	ND_IOCTL_MAX_BUFLEN = SZ_4M,
 	ND_CMD_MAX_ELEM = 5,
-- 
2.34.1

