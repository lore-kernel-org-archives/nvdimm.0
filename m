Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980D237BE76
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769167902; cv=none; b=MpASNjdco9MNZth13k2oUcjaDuY/Zj25wh39fC5HDSwYNqs6v9BhhEUaE+ebbrl2h+++JKNH62xyvbxPg7VX8sqJ47TPcpOG8Hk9VIBBgFfHUTS1+kctTipiZdOV8qoscFwv3R+pzBXRn5qLZ9jpj6ITYQcvgdHA41Jvrd4v1Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769167902; c=relaxed/simple;
	bh=Tj2av5RqoLJvlZWfZOdgCwzuwvbjOh/yCFSztEmuyGM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Y7fzSQFgK0erzpZezybt0SpByq1cLzAUpYeB8kHh/09dUlnT47hvXrFuMRvDfoYABQfuSCaoupUt7xVf8iF0TeT3UvWZiDp3QNaMRAi00R5XmYaB6sLffzF2NXmZGCfnx7o6fOU7r6aam/LpWJlYR5S+PvsGmP7L7ZbA/HQ37Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=X0iAxVpW; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="X0iAxVpW"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260123113138epoutp01e6443347d737ed3f15e72ac9b396f72f~NWNSi4jOz1947019470epoutp01X
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260123113138epoutp01e6443347d737ed3f15e72ac9b396f72f~NWNSi4jOz1947019470epoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769167898;
	bh=/tl3ZBvPbTkm53eHYFgRfz0iSfaYWcp8OPuMCg1TaVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0iAxVpWCKsLXVk+4EnOwvi/eBWcme/RRyeqKKcUd+MEJ+O8mvsTZGLKn6e3+VhmF
	 I5XrLiBxgi0F8HFGEdl2m6TIYdtxBr35WiwVE48ggdSTxGzthMWA+kmQFVe0rWtWkp
	 a16/MG4KHqadxQajaL1uV9OS+DbHXfq9v6RnXQec=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260123113138epcas5p46133b97bb5fb3be9930f55c863283797~NWNSEG1C-1497514975epcas5p4e;
	Fri, 23 Jan 2026 11:31:38 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.92]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dyG3X6QGvz2SSKZ; Fri, 23 Jan
	2026 11:31:36 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260123113136epcas5p22683ce5ef04a3da50fbb319a43e331a6~NWNQSzbEa3116331163epcas5p2P;
	Fri, 23 Jan 2026 11:31:36 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260123113135epsmtip2535b1e68e0aad62fe2bc41eb73a4271e~NWNPL7vue2685626856epsmtip2Q;
	Fri, 23 Jan 2026 11:31:35 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V6 09/18] nvdimm/label: Export routine to fetch region
 information
Date: Fri, 23 Jan 2026 17:01:03 +0530
Message-Id: <20260123113112.3488381-10-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260123113112.3488381-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260123113136epcas5p22683ce5ef04a3da50fbb319a43e331a6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260123113136epcas5p22683ce5ef04a3da50fbb319a43e331a6
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
	<CGME20260123113136epcas5p22683ce5ef04a3da50fbb319a43e331a6@epcas5p2.samsung.com>

CXL region information preserved from the LSA needs to be exported for
use by the CXL driver for CXL region re-creation.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
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

