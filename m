Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 277DF21127CC7
 for <linux-nvdimm@lists.01.org>; Mon, 10 Sep 2018 17:41:08 -0700 (PDT)
Date: Tue, 11 Sep 2018 08:40:16 +0800
From: kbuild test robot <fengguang.wu@intel.com>
Subject: [RFC PATCH] libnvdimm, region_devs: nd_region_detach_and_reset() can
 be static
Message-ID: <20180911004016.GA26156@lkp-wsm-ep1>
References: <1536560508-24564-4-git-send-email-oceanhehy@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1536560508-24564-4-git-send-email-oceanhehy@gmail.com>
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
To: Ocean He <oceanhehy@gmail.com>
Cc: linux-nvdimm@lists.01.org, Ocean He <hehy1@lenovo.com>, linux-kernel@vger.kernel.org, kbuild-all@01.org, zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>


Fixes: 39ac5d361db2 ("libnvdimm, region_devs: reset related seeds when fail to create namespace")
Signed-off-by: kbuild test robot <fengguang.wu@intel.com>
---
 region_devs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 4c46fb6..a2f667e 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -707,7 +707,7 @@ void nd_mapping_free_labels(struct nd_mapping *nd_mapping)
  * To ensure pfn_seed/dax_seed and namespace_seed are ready for
  * next namespace creation, here to do detach and reset.
  */
-void nd_region_detach_and_reset(struct device *dev,
+static void nd_region_detach_and_reset(struct device *dev,
 		struct nd_region *nd_region)
 {
 	/* Only nd_pmem has been verified, fix me for other dev type. */
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
