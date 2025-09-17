Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020863195FE
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116498; cv=none; b=BLy6xCfNMk9MFSeDze6T/27eSOOJ2pHkLAzDqCNlUa0SIFfnq3qtwiezHA7oVre0F++u9Ax1xOSfbN6wk3OQTrO4Y+1sbr0ELRO+0Xlts+Oo+7mPh0MbZu6tuhnNKylwPy5OxrnMic+eJDcGNbO3yZFis050feoK3qwSIs2JSRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116498; c=relaxed/simple;
	bh=IHPKBKUHBCQv+vf6QHv35uUvAqo5mXtMFlwSA2YvK5c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=eCe27KkihQUsn5ITbJbYQQCQrqGNUa7WBGAH7LT5k35uB71K1UidAvNBa5T8v/eYZSaXeGuybcVCRicJ78UFtBjfNwY/yip8rDigmnUeSXd4WJN/u0VNswzvY1xbKjym2CDXU2Fo5z7AEg5YlzvLIQRMH28v5r1YixPdQRKwSWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=XcEIw/xp; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XcEIw/xp"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250917134134epoutp029a0e70606664a97b89b443c468716b14~mFaLuyzrn1575415754epoutp02D
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:41:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250917134134epoutp029a0e70606664a97b89b443c468716b14~mFaLuyzrn1575415754epoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758116494;
	bh=jc8FD7JXvWhCV/EAXTp2IPOjNKOfDlPIfA8NoFMX5Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XcEIw/xp0oyMbnimScQPpuRsjeA03GfwqkK+LH9ZBhuo1XIfIuyO/a2Lm7FK9Ngfr
	 75p+ttccMnbjfjP9nAbumZLu/D/TIspVDNUDwYAF+fIqQddm4uAxGk4U+9gfTkDslc
	 XhedDrS2zIPFUIul/uhpapapigLYK4oOz2s/YM2U=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250917134132epcas5p31b585c9eaf4dd2455d4deebaa8374b08~mFaKLqISg0180401804epcas5p3c;
	Wed, 17 Sep 2025 13:41:32 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.93]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cRg0W3N6sz2SSKY; Wed, 17 Sep
	2025 13:41:31 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250917134130epcas5p417d7c26bc564d64d1bcea6e04d55704d~mFaIm5Pk92411724117epcas5p49;
	Wed, 17 Sep 2025 13:41:30 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250917134129epsmtip29579ab0689edfb63670e6fd4f4a1c525~mFaHUVYzZ0862908629epsmtip2-;
	Wed, 17 Sep 2025 13:41:29 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com, Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 01/20] nvdimm/label: Introduce NDD_REGION_LABELING flag
 to set region label
Date: Wed, 17 Sep 2025 19:10:57 +0530
Message-Id: <20250917134116.1623730-2-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917134116.1623730-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917134130epcas5p417d7c26bc564d64d1bcea6e04d55704d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917134130epcas5p417d7c26bc564d64d1bcea6e04d55704d
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134130epcas5p417d7c26bc564d64d1bcea6e04d55704d@epcas5p4.samsung.com>

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

