Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E3835CBBF
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962729; cv=none; b=k8G6Er69fGTs6KUaVT+8U7NR+AGb/QsZYar1O3XTCXtGPbnCPToiaRZhTWVj6/73hx10cng9HUKouiSW51IOPJg91Ry52i6cAhRQgX5yQnfcM8jsxfSgNby2ZIQdONlZ8/w+hfquOiavo+I2CAF0Vn2y1AdlqRlkWBulxz2Jct8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962729; c=relaxed/simple;
	bh=2Oi5A2UjUY179mivkwDPYpVWvRqXcm+rbcVcLWgLV+4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=ZH66Re3wEjgYDTuVZ8Y7Lhybei0P9eT/T8nJArgEXxdUTG8U9xlhg3YNM0MvpvAf8XlIs+khl4BBWhoTp8xaCAx7q/vEfzYKPb+MMdvdfQtawvfQtKFroZeXuKdV2g0dh0FtqRLA6UAMYijdERshc+e1nBzXEMtZLSA72oalaT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=MgG4RnQX; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MgG4RnQX"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260109124524epoutp02f1a921cb9a9bc4cdba662438347e6720~JELsbi9Rb1955219552epoutp02e
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:45:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260109124524epoutp02f1a921cb9a9bc4cdba662438347e6720~JELsbi9Rb1955219552epoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767962724;
	bh=AegceBCi2PG2uzv8C4DQpTppHKH8pfEM1iy7MZDMHz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MgG4RnQXrrYb82v2MzHRuwNrCjvIzu4Qzup0C+Mdgri9QwA0JMJPCi1EVQRS7l5xc
	 j6K8eleQ+BaguhV5fVvSAG1k4Gfqh5B54fsqD0JxDVssbr2yiv3uDAT+IW9007IdEh
	 Dgrfz2O3T/tjmyWyRnyeeSZxbYVVLtXQWl0DbDK4=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260109124523epcas5p1f32ee165a9243b45d34e89d9bc36335a~JELr6HTPc3012130121epcas5p1X;
	Fri,  9 Jan 2026 12:45:23 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.90]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dnhM722mWz6B9m6; Fri,  9 Jan
	2026 12:45:23 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260109124522epcas5p2ecae638cbd3211d7bdbecacba4ff89f3~JELqy5yfx2073820738epcas5p2c;
	Fri,  9 Jan 2026 12:45:22 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260109124521epsmtip1f23cf7209b7991dd8715da3d06b63191~JELpsgEtO0977809778epsmtip1n;
	Fri,  9 Jan 2026 12:45:21 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V5 09/17] nvdimm/label: Export routine to fetch region
 information
Date: Fri,  9 Jan 2026 18:14:29 +0530
Message-Id: <20260109124437.4025893-10-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260109124437.4025893-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260109124522epcas5p2ecae638cbd3211d7bdbecacba4ff89f3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260109124522epcas5p2ecae638cbd3211d7bdbecacba4ff89f3
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124522epcas5p2ecae638cbd3211d7bdbecacba4ff89f3@epcas5p2.samsung.com>

CXL region information preserved from the LSA needs to be exported for
use by the CXL driver for CXL region re-creation.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/dimm_devs.c | 12 ++++++++++++
 include/linux/libnvdimm.h  |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 3363a97cc5b5..e1c95da92fbf 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -280,6 +280,18 @@ void *nvdimm_provider_data(struct nvdimm *nvdimm)
 }
 EXPORT_SYMBOL_GPL(nvdimm_provider_data);
 
+bool nvdimm_has_cxl_region(struct nvdimm *nvdimm)
+{
+	return nvdimm->is_region_label;
+}
+EXPORT_SYMBOL_GPL(nvdimm_has_cxl_region);
+
+void *nvdimm_get_cxl_region_param(struct nvdimm *nvdimm)
+{
+	return &nvdimm->cxl_region_params;
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

