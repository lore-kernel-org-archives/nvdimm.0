Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com
 [IPv6:2607:f8b0:4864:20::644])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8146221962301
 for <linux-nvdimm@lists.01.org>; Sun,  9 Sep 2018 23:24:05 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id ba4-v6so9235890plb.11
 for <linux-nvdimm@lists.01.org>; Sun, 09 Sep 2018 23:24:05 -0700 (PDT)
From: Ocean He <oceanhehy@gmail.com>
Subject: [PATCH 1/3] libnvdimm,
 claim: remove static attribute of nd_detach_and_reset
Date: Mon, 10 Sep 2018 02:21:46 -0400
Message-Id: <1536560508-24564-2-git-send-email-oceanhehy@gmail.com>
In-Reply-To: <1536560508-24564-1-git-send-email-oceanhehy@gmail.com>
References: <1536560508-24564-1-git-send-email-oceanhehy@gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com, zwisler@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com
Cc: Ocean He <hehy1@lenovo.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Ocean He <hehy1@lenovo.com>

The function nd_detach_and_reset needs to be called externally, so
remove the static attribute and declare it in nd-core.h.

Signed-off-by: Ocean He <hehy1@lenovo.com>
---
 drivers/nvdimm/claim.c   | 2 +-
 drivers/nvdimm/nd-core.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index fb667bf..46e56ecf 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -117,7 +117,7 @@ struct nd_pfn *to_nd_pfn_safe(struct device *dev)
 	return NULL;
 }
 
-static void nd_detach_and_reset(struct device *dev,
+void nd_detach_and_reset(struct device *dev,
 		struct nd_namespace_common **_ndns)
 {
 	/* detach the namespace and destroy / reset the device */
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index ac68072..7fd74d0 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -123,6 +123,7 @@ struct resource *nsblk_add_resource(struct nd_region *nd_region,
 resource_size_t __nvdimm_namespace_capacity(struct nd_namespace_common *ndns);
 void nd_detach_ndns(struct device *dev, struct nd_namespace_common **_ndns);
 void __nd_detach_ndns(struct device *dev, struct nd_namespace_common **_ndns);
+void nd_detach_and_reset(struct device *dev, struct nd_namespace_common **_ndns);
 bool nd_attach_ndns(struct device *dev, struct nd_namespace_common *attach,
 		struct nd_namespace_common **_ndns);
 bool __nd_attach_ndns(struct device *dev, struct nd_namespace_common *attach,
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
