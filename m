Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6521624E1
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753878256; cv=none; b=ATPKSpefmTUxaxkJDWR9EF7DW58N1KyA5CkKtOFvQ+qjcp5PKevf3KUaPsu2uP8YOyTkTdYOseJPOEW2TjFdrAEoAovT+ZQBIXfcxky6y4bGhnYKoLs9WzjF/sBDDXDAiyAHMKpbonAN9wKcU9lKWine2NtlUuSyIDUaD/ufio0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753878256; c=relaxed/simple;
	bh=Rzr3QPpFd375//AXann9f66aucF7VKu6W1prHE7ybQs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=jIa6mKrOHTXbnqpv69hwC9eaBfwwZUeMml1rsOMgbHztUe3QfF9Fe+68TFy5ksKGmGMhbeH2Y6hxD5o26XdXIftINU9cb+3HGJXRs6/JvbnXiMrnkWlC/XCmtNrESv8o78apArQWa/gQbsaIiH2vCJWsA6NGPeoKWBKbpwhBjJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Wlmb1ECs; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Wlmb1ECs"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250730121617epoutp03efb04655b0ffbe83f549d829aef5f4c3~XBovSgqfd3204132041epoutp03b
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:16:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250730121617epoutp03efb04655b0ffbe83f549d829aef5f4c3~XBovSgqfd3204132041epoutp03b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753877777;
	bh=1l/wPiUpNSi4o0asMtc7DuFhzofL0nAWqqEmJuQjjpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wlmb1ECs9+kJUHi3ZyzhVCPTUue4dIqsjFL7O56getAJF/DDdq1Q5/ggyEi7qHEUv
	 wL9sokejSobSiN24kPjGHFGyMW/CejmsHkBtYWq489z/HDOlr4Ef60HjUPLTKra8OA
	 WKdsbhtQ1rxb+At0i7EEJnNnUV3iBqF5ao/fRm+M=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250730121617epcas5p4fc490e311e714f2a5218628746092d18~XBou6ma0T0400404004epcas5p4E;
	Wed, 30 Jul 2025 12:16:17 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.88]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4bsWQm1685z6B9m6; Wed, 30 Jul
	2025 12:16:16 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250730121223epcas5p1386bdf99a0af820dd4411fbdbd413cd5~XBlU7d_G42385823858epcas5p19;
	Wed, 30 Jul 2025 12:12:23 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250730121221epsmtip1a0ca696b3768d52d37c61ba151ce7ab8~XBlT4uD9Z0450404504epsmtip1f;
	Wed, 30 Jul 2025 12:12:21 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V2 01/20] nvdimm/label: Introduce NDD_CXL_LABEL flag to set
 cxl label format
Date: Wed, 30 Jul 2025 17:41:50 +0530
Message-Id: <20250730121209.303202-2-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250730121209.303202-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250730121223epcas5p1386bdf99a0af820dd4411fbdbd413cd5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121223epcas5p1386bdf99a0af820dd4411fbdbd413cd5
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121223epcas5p1386bdf99a0af820dd4411fbdbd413cd5@epcas5p1.samsung.com>

Prior to LSA 2.1 version, LSA contain only namespace labels. LSA 2.1
introduced in CXL 2.0 Spec, which contain region label along with
namespace label.

NDD_LABELING flag is used for namespace. Introduced NDD_CXL_LABEL
flag for region label. Based on these flags nvdimm driver performs
operation on namespace label or region label.

NDD_CXL_LABEL will be utilized by cxl driver to enable LSA2.1 region
label support

Accordingly updated label index version

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/dimm.c      |  1 +
 drivers/nvdimm/dimm_devs.c |  7 +++++++
 drivers/nvdimm/label.c     | 22 ++++++++++++++++++----
 drivers/nvdimm/nd.h        |  1 +
 include/linux/libnvdimm.h  |  3 +++
 5 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
index 91d9163ee303..8753b5cd91cc 100644
--- a/drivers/nvdimm/dimm.c
+++ b/drivers/nvdimm/dimm.c
@@ -62,6 +62,7 @@ static int nvdimm_probe(struct device *dev)
 	if (rc < 0)
 		dev_dbg(dev, "failed to unlock dimm: %d\n", rc);
 
+	ndd->cxl = nvdimm_check_cxl_label_format(ndd->dev);
 
 	/*
 	 * EACCES failures reading the namespace label-area-properties
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 21498d461fde..6149770c1b27 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -18,6 +18,13 @@
 
 static DEFINE_IDA(dimm_ida);
 
+bool nvdimm_check_cxl_label_format(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+
+	return test_bit(NDD_CXL_LABEL, &nvdimm->flags);
+}
+
 /*
  * Retrieve bus and dimm handle and return if this bus supports
  * get_config_data commands
diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 04f4a049599a..7a011ee02d79 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -688,11 +688,25 @@ static int nd_label_write_index(struct nvdimm_drvdata *ndd, int index, u32 seq,
 		- (unsigned long) to_namespace_index(ndd, 0);
 	nsindex->labeloff = __cpu_to_le64(offset);
 	nsindex->nslot = __cpu_to_le32(nslot);
-	nsindex->major = __cpu_to_le16(1);
-	if (sizeof_namespace_label(ndd) < 256)
+
+	/* Set LSA Label Index Version */
+	if (ndd->cxl) {
+		/* CXL r3.2 Spec: Table 9-9 Label Index Block Layout */
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
+		else
+		 /* UEFI Specification 2.7: Label Index Block Definitions */
+			nsindex->minor = __cpu_to_le16(2);
+	}
+
 	nsindex->checksum = __cpu_to_le64(0);
 	if (flags & ND_NSINDEX_INIT) {
 		unsigned long *free = (unsigned long *) nsindex->free;
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index cc5c8f3f81e8..1cc06cc58d14 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -522,6 +522,7 @@ void nvdimm_set_labeling(struct device *dev);
 void nvdimm_set_locked(struct device *dev);
 void nvdimm_clear_locked(struct device *dev);
 int nvdimm_security_setup_events(struct device *dev);
+bool nvdimm_check_cxl_label_format(struct device *dev);
 #if IS_ENABLED(CONFIG_NVDIMM_KEYS)
 int nvdimm_security_unlock(struct device *dev);
 #else
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index e772aae71843..0a55900842c8 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -44,6 +44,9 @@ enum {
 	/* dimm provider wants synchronous registration by __nvdimm_create() */
 	NDD_REGISTER_SYNC = 8,
 
+	/* dimm supports region labels (LSA Format 2.1) */
+	NDD_CXL_LABEL = 9,
+
 	/* need to set a limit somewhere, but yes, this is likely overkill */
 	ND_IOCTL_MAX_BUFLEN = SZ_4M,
 	ND_CMD_MAX_ELEM = 5,
-- 
2.34.1

