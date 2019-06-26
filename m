Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 04278212A36DD
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jun 2019 23:05:32 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x5Q63e7R058195
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jun 2019 02:05:31 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2tc1gf35k5-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jun 2019 02:05:31 -0400
Received: from localhost
 by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <alastair@au1.ibm.com>;
 Wed, 26 Jun 2019 07:05:29 +0100
From: "Alastair D'Silva" <alastair@au1.ibm.com>
Subject: [PATCH] nvdimm: remove prototypes for nonexistent functions
Date: Wed, 26 Jun 2019 16:03:50 +1000
MIME-Version: 1.0
Message-Id: <20190626060350.15715-1-alastair@au1.ibm.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: alastair@d-silva.org
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Alastair D'Silva <alastair@d-silva.org>

These functions don't exist, so remove the prototypes for them.

Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
---
 drivers/nvdimm/nd-core.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 391e88de3a29..57d162dbefaa 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -136,11 +136,7 @@ void nd_region_disable(struct nvdimm_bus *nvdimm_bus, struct device *dev);
 int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus);
 void nvdimm_bus_destroy_ndctl(struct nvdimm_bus *nvdimm_bus);
 void nd_synchronize(void);
-int nvdimm_bus_register_dimms(struct nvdimm_bus *nvdimm_bus);
-int nvdimm_bus_register_regions(struct nvdimm_bus *nvdimm_bus);
-int nvdimm_bus_init_interleave_sets(struct nvdimm_bus *nvdimm_bus);
 void __nd_device_register(struct device *dev);
-int nd_match_dimm(struct device *dev, void *data);
 struct nd_label_id;
 char *nd_label_gen_id(struct nd_label_id *label_id, u8 *uuid, u32 flags);
 bool nd_is_uuid_unique(struct device *dev, u8 *uuid);
-- 
2.21.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
