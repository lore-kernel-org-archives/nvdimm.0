Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F1F7320954B94
 for <linux-nvdimm@lists.01.org>; Sat, 24 Mar 2018 21:22:24 -0700 (PDT)
Date: Sun, 25 Mar 2018 12:28:12 +0800
From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH] libnvdimm: bus_desc can be static
Message-ID: <20180325042812.GA28332@lkp-ib03.lkp.intel.com>
References: <20180323081209.31387-3-oohall@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180323081209.31387-3-oohall@gmail.com>
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
To: Oliver O'Halloran <oohall@gmail.com>
Cc: devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kbuild-all@01.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>


Fixes: 6cb2b51b9b76 ("libnvdimm: Add device-tree based driver")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 of_nvdimm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/of_nvdimm.c b/drivers/nvdimm/of_nvdimm.c
index 79c2829..4ed373d 100644
--- a/drivers/nvdimm/of_nvdimm.c
+++ b/drivers/nvdimm/of_nvdimm.c
@@ -15,7 +15,7 @@
  * for dispatching regions into the correct bus type, but this is useful
  * for now.
  */
-struct nvdimm_bus_descriptor bus_desc;
+static struct nvdimm_bus_descriptor bus_desc;
 struct nvdimm_bus *bus;
 
 /* region driver */
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
