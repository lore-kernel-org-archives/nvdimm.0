Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C256232BBF8
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115852; cv=none; b=rCbedM+b+TvDsEdBuH60eVMtPg1npWahXxEwBXNmV6iJw2CfFPkXIHefe2gWjwwKbivK69dO5Ei2p/Q0VoJ5TvVBRKHAl/Efnp96HYJuuyl34LUUo2mvA5E1QVhvol0IgZYiISU9CxA0j0CJbk9BNtiyYyAlfr23tmreVs1IOCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115852; c=relaxed/simple;
	bh=aAT36OD6sazighOfpzQSmftqbC9DnJOQdrbUq9T0Bvk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=P+Ab96DQE1gxb10CUnwhBBIARCwfwf/JMNIqYp85zbq4nLRtKWb45tYE/FAyJEqHqo8y4NTnMJ7Sx6BwhtChgbw68z6Sp5aiu2a+EPnO0Zes6Ao1wtkyJdYZD/z6X6+uYHCJDNCxxSQLgkI/w0J5ooDAP/HSFTMuzH6kR48+mZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=qdNOYOEp; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qdNOYOEp"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250917133049epoutp04394c97a733b9cd9be1fdb164cb9bd5b1~mFQzCMnRt2402124021epoutp04i
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250917133049epoutp04394c97a733b9cd9be1fdb164cb9bd5b1~mFQzCMnRt2402124021epoutp04i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758115849;
	bh=EvHiPrSCwDV9YFoLErNp7XwahEpYXRahMYHe/BeQwrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qdNOYOEp1Thn6fsF7IdpkqMnuwgsx+xzUaxPq/FO3Q8qoTvmq/4GU3Usj6SuUxoyq
	 uv38g4qwK7NIbv154rWKyY7xkZ5haQU/aZENNMisfaqoNY9w6+gu+MeG9Sayfdm4RC
	 u4fN8YBcpHXz5abItwwplAc83PmZECcPejrOtMnA=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250917133048epcas5p1cf5206589841fd30bd993e2a387cb89e~mFQyyOouk1535415354epcas5p1G;
	Wed, 17 Sep 2025 13:30:48 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.89]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cRfm75nvHz2SSKY; Wed, 17 Sep
	2025 13:30:47 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250917133047epcas5p254e1e6c6d4417e4cdd354abc86596c30~mFQxb2QCM0307503075epcas5p2o;
	Wed, 17 Sep 2025 13:30:47 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250917133046epsmtip15741b5782a5f134b38ea7d35a4dfd76e~mFQwXhioP0238602386epsmtip1Z;
	Wed, 17 Sep 2025 13:30:46 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 12/20] nvdimm/region_label: Export routine to fetch
 region information
Date: Wed, 17 Sep 2025 18:59:32 +0530
Message-Id: <20250917132940.1566437-13-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917132940.1566437-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917133047epcas5p254e1e6c6d4417e4cdd354abc86596c30
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917133047epcas5p254e1e6c6d4417e4cdd354abc86596c30
References: <20250917132940.1566437-1-s.neeraj@samsung.com>
	<CGME20250917133047epcas5p254e1e6c6d4417e4cdd354abc86596c30@epcas5p2.samsung.com>

CXL region information preserved from the LSA needs to be exported for
use by the CXL driver for CXL region re-creation.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/dimm_devs.c | 18 ++++++++++++++++++
 include/linux/libnvdimm.h  |  2 ++
 2 files changed, 20 insertions(+)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 918c3db93195..619c8ce56dce 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -280,6 +280,24 @@ void *nvdimm_provider_data(struct nvdimm *nvdimm)
 }
 EXPORT_SYMBOL_GPL(nvdimm_provider_data);
 
+bool nvdimm_has_cxl_region(struct nvdimm *nvdimm)
+{
+	if (nvdimm)
+		return nvdimm->is_region_label;
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(nvdimm_has_cxl_region);
+
+void *nvdimm_get_cxl_region_param(struct nvdimm *nvdimm)
+{
+	if (nvdimm)
+		return &nvdimm->cxl_region_params;
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(nvdimm_get_cxl_region_param);
+
 static ssize_t commands_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 07ea2e3f821a..3ffd50ab6ac4 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -330,6 +330,8 @@ int nvdimm_in_overwrite(struct nvdimm *nvdimm);
 bool is_nvdimm_sync(struct nd_region *nd_region);
 int nd_region_label_update(struct nd_region *nd_region);
 int nd_region_label_delete(struct nd_region *nd_region);
+bool nvdimm_has_cxl_region(struct nvdimm *nvdimm);
+void *nvdimm_get_cxl_region_param(struct nvdimm *nvdimm);
 
 static inline int nvdimm_ctl(struct nvdimm *nvdimm, unsigned int cmd, void *buf,
 		unsigned int buf_len, int *cmd_rc)
-- 
2.34.1

