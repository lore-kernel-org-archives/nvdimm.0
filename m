Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CC81B87C0
	for <nvdimm@lists.linux.dev>; Wed, 22 Apr 2026 06:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776837878; cv=none; b=XpnzteBraOEZd+SMCpvYn9yJLSmWHltvXCyh4bb1IGvHDXdwb6L+ZcyALYNas1oxWR2AAjH6mHteJboO60Bmk6MnDzV4QLunBkg1E40KsZ6WjDbTssB8CvPxKPMDU1oaHbukfM3++UExEeHGhCMHK4tn8Srf9nG1k40RNz72vyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776837878; c=relaxed/simple;
	bh=4sdtm3kcfxi15Z1XpOSwj0brhn7USfL3qPuIppGv3xI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Fb+d/w9PnGX0UrHJ/cfAAZTevKuiE5qFxR/WItJ4Kfw//SkCMOKD6KnLOEFALoDA/NslaEbKdgJqVYF2Tmp71XREQi6zHdkU0V6rLHN+Z6RRV3/SsbTmb/aaV8/SV6Nf1jDkeuOtATeLlCttQep7H6N6JYLtWajoQQVZkLHTECk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 1a71d48a3e1111f1aa26b74ffac11d73-20260422
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME, IP_TRUSTED
	SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:d6568489-323b-4af7-92b5-7e5013d4f5f7,IP:15,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:35
X-CID-INFO: VERSION:1.3.12,REQID:d6568489-323b-4af7-92b5-7e5013d4f5f7,IP:15,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:35
X-CID-META: VersionHash:e7bac3a,CLOUDID:4ca9574ad7c8cd59317a3a5d7bb99fab,BulkI
	D:260422140421SPQYUZ2R,BulkQuantity:0,Recheck:0,SF:17|19|66|78|102|123|127
	|850|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1a71d48a3e1111f1aa26b74ffac11d73-20260422
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(39.156.73.13)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1030496338; Wed, 22 Apr 2026 14:04:20 +0800
From: liuqiqi@kylinos.cn
To: Dan Williams <djbw@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuqiqi <liuqiqi@kylinos.cn>
Subject: [PATCH] cxl/dax: assign target node to cxl memdev during dax region probe
Date: Wed, 22 Apr 2026 14:03:53 +0800
Message-Id: <20260422060353.200821-1-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: liuqiqi <liuqiqi@kylinos.cn>

When a cxl_dax_region is probed, set the numa_node of associated
cxl_memdev devices to match the target node derived from the region's
address range.
The cxl_dax_region_probe function computes the correct target node (nid)
via phys_to_target_node() but does not propagate this information to
the underlying cxl_memdev devices. This can cause memory allocations
to use an incorrect NUMA node.

Environment: node0/node1 = DRAM, node2 = CXL memory.
Before this fix:
  # cat /sys/bus/cxl/devices/mem0/numa_node
  1
After this fix:
  # cat /sys/bus/cxl/devices/mem0/numa_node
  2

Signed-off-by: liuqiqi <liuqiqi@kylinos.cn>
---
 drivers/dax/cxl.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 3ab39b77843d..a62af46ec31e 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -4,8 +4,27 @@
 #include <linux/dax.h>
 
 #include "../cxl/cxl.h"
+#include "../cxl/cxlmem.h"
 #include "bus.h"
 
+static void cxl_dax_set_numa_node(struct cxl_region *cxlr, int nid)
+{
+	struct cxl_region_params *p;
+	struct cxl_endpoint_decoder *cxled;
+	struct cxl_memdev *cxlmd;
+	int i;
+
+	p = &cxlr->params;
+	for (i = 0; i < p->nr_targets; i++) {
+		cxled = p->targets[i];
+		if (!cxled)
+			continue;
+
+		cxlmd = cxled_to_memdev(cxled);
+		set_dev_node(&cxlmd->dev, nid);
+	}
+}
+
 static int cxl_dax_region_probe(struct device *dev)
 {
 	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
@@ -28,6 +47,7 @@ static int cxl_dax_region_probe(struct device *dev)
 		.size = range_len(&cxlr_dax->hpa_range),
 		.memmap_on_memory = true,
 	};
+	cxl_dax_set_numa_node(cxlr, nid);
 
 	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
 }
-- 
2.25.1

