Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEB6329E46
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763538808; cv=none; b=dkLAcmoPN9O4+88tyG65qjSDz0UxvHk6YWVYVFMPxVQhFh5GdNsO6nBdvTDSzl+8M6RuBRgVYxXQxVT9WedEU0jJooXMfPn8kL9poIU+k+ihmMwQy+RGQB9JLXoUuHg4YFB6ec/kIcFrkuvKJ+VqupO07008Fw9tbvwOsG3Awu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763538808; c=relaxed/simple;
	bh=i1FI22B+24KIAZ+Y/EUtwTheSp2SKHQG5cukeITglik=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=GiMxoA08vLiXGyFvUhw2DT8inlldIn8aAFME8Fq1N3ftEnYqaV4h8BSZUxoD+ssd4PgtAl+YplKROUtqi9Dio6cJNf4VWQqiW9Ot8824e56VFhFT5I2sy9KdFD5kCU7cL0bgyKAHuWUGsKCTCmcqzEFDXjRoQuBy95u+ca+8Kas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=cFjhzVva; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cFjhzVva"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251119075324epoutp03af498ce742e9cbfc24c369280d5654a9~5WTMMTNVx3003630036epoutp03m
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251119075324epoutp03af498ce742e9cbfc24c369280d5654a9~5WTMMTNVx3003630036epoutp03m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1763538804;
	bh=XgdTodktIe2yEqaotEXyfE/JNHfS6ZzRHo/QULupwQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cFjhzVvaRqWaE4tuUMMaHo+Ap6jzGdSTvNK9pwMhmqYoqxbnSnWWrbdfBklOg5hW+
	 HcEcR1nT9IQchETyBMdoz513nGrsB4XKPouePOHbOBbIqlo4DWQTfWMN5c4xksBSd+
	 5GOiLxQFmn/cT62He93ThDD8Smaw83JCgathtNRM=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20251119075324epcas5p24b78bc8b647adcda3d94983f04767d88~5WTL9o2mX1868418684epcas5p2c;
	Wed, 19 Nov 2025 07:53:24 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.86]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dBDHl4TGfz6B9m5; Wed, 19 Nov
	2025 07:53:23 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20251119075323epcas5p369dea15a390bea0b3690e2a19533f956~5WTKm-Y8O0364303643epcas5p3W;
	Wed, 19 Nov 2025 07:53:23 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251119075321epsmtip1ab2e1ccf16e014d177c3485c3cf833f1~5WTI6SQn32573625736epsmtip1l;
	Wed, 19 Nov 2025 07:53:21 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V4 09/17] nvdimm/label: Export routine to fetch region
 information
Date: Wed, 19 Nov 2025 13:22:47 +0530
Message-Id: <20251119075255.2637388-10-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251119075255.2637388-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251119075323epcas5p369dea15a390bea0b3690e2a19533f956
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075323epcas5p369dea15a390bea0b3690e2a19533f956
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075323epcas5p369dea15a390bea0b3690e2a19533f956@epcas5p3.samsung.com>

CXL region information preserved from the LSA needs to be exported for
use by the CXL driver for CXL region re-creation.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/dimm_devs.c | 18 ++++++++++++++++++
 include/linux/libnvdimm.h  |  2 ++
 2 files changed, 20 insertions(+)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 3363a97cc5b5..1474b4e45fcc 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -280,6 +280,24 @@ void *nvdimm_provider_data(struct nvdimm *nvdimm)
 }
 EXPORT_SYMBOL_GPL(nvdimm_provider_data);
 
+bool nvdimm_has_cxl_region(struct nvdimm *nvdimm)
+{
+	if (!nvdimm)
+		return false;
+
+	return nvdimm->is_region_label;
+}
+EXPORT_SYMBOL_GPL(nvdimm_has_cxl_region);
+
+void *nvdimm_get_cxl_region_param(struct nvdimm *nvdimm)
+{
+	if (!nvdimm)
+		return NULL;
+
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

