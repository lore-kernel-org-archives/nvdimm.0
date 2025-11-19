Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5507311C3B
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 08:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763539395; cv=none; b=K0wvx5oULdJv3oT5IoveUTBQtbbLCp8+KI9olr9uVJLMrlGMlDgWtVyvLBxraTqBHKTM53gWy5b0+x7VBIVM6WZ38NQESUybpxeo/hpu1gcsQuvZJm09umh5WtzopanQ+g+v0FNHMz2uY9osTahFxBruSGLfuBsw0Q//iBKhdak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763539395; c=relaxed/simple;
	bh=Nrh3LJeASNPcmlmYLto8vp7K7VofCjI17u7FYsOih7U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Jk/mQMH97iajOpqFrS+yOUPcEDMDNeUjNLc6JXefVdVcPYsgo05s7+azV/Qx5zOwzpLk4jgq1N6o5C4o92P2tzJOmKcb14LgKfM+ceJ4+5cEr4cKuIhJAQjsv3hfKruiQ/zbNEbXP7zMdTiqIpO6FHiXqem/ZGUaTV87XzEcoFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=JmhbqC1V; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JmhbqC1V"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20251119075309epoutp0227b1c01ee681bcb5c1b9df40c4c6d53d~5WS99o6Lx2564225642epoutp027
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20251119075309epoutp0227b1c01ee681bcb5c1b9df40c4c6d53d~5WS99o6Lx2564225642epoutp027
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1763538789;
	bh=5xmz/B9yMfpkRTzrVcJYqxwlY+cbVHk6E47L8xjO2O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JmhbqC1VW2TeOmgGeFzFKBwQATHmGPaiHcZYb/8JNEPw15iGSSGvxyoKGRCsim5v/
	 CwhUTW7qWGjxcmP4Di3A/OhfH0NgFmcj6/1ls/g3sktwrileyze1dbRxeNww/EfjM9
	 1CKMA26mPHRr0z3qAzmo6NCyqKKLTWtViEm21Wsk=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20251119075309epcas5p10e66cd25a992f314cefde9c28ad930d5~5WS9ssSmC2205722057epcas5p1j;
	Wed, 19 Nov 2025 07:53:09 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.87]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dBDHS258Qz6B9m6; Wed, 19 Nov
	2025 07:53:08 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20251119075307epcas5p3007a9cb341efc3fa57b763e74caa35c4~5WS8RlJk31255112551epcas5p3_;
	Wed, 19 Nov 2025 07:53:07 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251119075306epsmtip1a4c04623af5019f52b81ea3bf23b14c9~5WS7LURsR2604526045epsmtip1G;
	Wed, 19 Nov 2025 07:53:06 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V4 01/17] nvdimm/label: Introduce NDD_REGION_LABELING flag
 to set region label
Date: Wed, 19 Nov 2025 13:22:39 +0530
Message-Id: <20251119075255.2637388-2-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251119075255.2637388-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251119075307epcas5p3007a9cb341efc3fa57b763e74caa35c4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075307epcas5p3007a9cb341efc3fa57b763e74caa35c4
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075307epcas5p3007a9cb341efc3fa57b763e74caa35c4@epcas5p3.samsung.com>

Prior to LSA 2.1 version, LSA contain only namespace labels. LSA 2.1
introduced in CXL 2.0 Spec, which contain region label along with
namespace label.

NDD_LABELING flag is used for namespace. Introduced NDD_REGION_LABELING
flag for region label. Based on these flags nvdimm driver performs
operation on namespace label or region label.

NDD_REGION_LABELING will be utilized by cxl driver to enable LSA 2.1
region label support

Accordingly updated label index version

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/dimm.c      |  1 +
 drivers/nvdimm/dimm_devs.c |  7 +++++++
 drivers/nvdimm/label.c     | 21 +++++++++++++++++----
 drivers/nvdimm/nd.h        |  1 +
 include/linux/libnvdimm.h  |  3 +++
 5 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
index 2f6c26cc6a3e..07f5c5d5e537 100644
--- a/drivers/nvdimm/dimm.c
+++ b/drivers/nvdimm/dimm.c
@@ -62,6 +62,7 @@ static int nvdimm_probe(struct device *dev)
 	if (rc < 0)
 		dev_dbg(dev, "failed to unlock dimm: %d\n", rc);
 
+	ndd->cxl = nvdimm_region_label_supported(ndd->dev);
 
 	/*
 	 * EACCES failures reading the namespace label-area-properties
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index e1349ef5f8fd..3363a97cc5b5 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -18,6 +18,13 @@
 
 static DEFINE_IDA(dimm_ida);
 
+bool nvdimm_region_label_supported(struct device *dev)
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
index b199eea3260e..f631bd84d6f0 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -522,6 +522,7 @@ void nvdimm_set_labeling(struct device *dev);
 void nvdimm_set_locked(struct device *dev);
 void nvdimm_clear_locked(struct device *dev);
 int nvdimm_security_setup_events(struct device *dev);
+bool nvdimm_region_label_supported(struct device *dev);
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

