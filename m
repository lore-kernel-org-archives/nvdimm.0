Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 85D061A1DEC
 for <linux-nvdimm@lists.01.org>; Mon, 12 Sep 2016 09:15:15 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2] /dev/dax: fix Kconfig dependency build breakage
Date: Mon, 12 Sep 2016 10:15:07 -0600
Message-Id: <20160912161507.24311-1-ross.zwisler@linux.intel.com>
In-Reply-To: <CAPcyv4g-KQDpxduXTokJMKvqKTDUnx4X3Ashiq02Cc6xhTc+DA@mail.gmail.com>
References: <CAPcyv4g-KQDpxduXTokJMKvqKTDUnx4X3Ashiq02Cc6xhTc+DA@mail.gmail.com>
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
To: linux-kernel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The function dax_pmem_probe() in drivers/dax/pmem.c is compiled under the
CONFIG_DEV_DAX_PMEM tri-state config option.  This config option currently
only depends on CONFIG_NVDIMM_DAX, a bool, which means that the following
configuration is possible:

CONFIG_LIBNVDIMM=m
...
CONFIG_NVDIMM_DAX=y
CONFIG_DEV_DAX=y
CONFIG_DEV_DAX_PMEM=y

With this config LIBNVDIMM is compiled as a module with NVDIMM_DAX=y just
meaning that we will compile drivers/nvdimm/dax_devs.c into that module.
However, dax_pmem_probe() depends on several symbols defined in
drivers/nvdimm/dax_devs.c, which results in the following build errors:

drivers/built-in.o: In function `dax_pmem_probe':
linux/drivers/dax/pmem.c:70: undefined reference to `to_nd_dax'
linux/drivers/dax/pmem.c:74: undefined reference to
`nvdimm_namespace_common_probe'
linux/drivers/dax/pmem.c:80: undefined reference to `devm_nsio_enable'
linux/drivers/dax/pmem.c:81: undefined reference to `nvdimm_setup_pfn'
linux/drivers/dax/pmem.c:84: undefined reference to `devm_nsio_disable'
linux/drivers/dax/pmem.c:122: undefined reference to `to_nd_region'
drivers/built-in.o: In function `dax_pmem_init':
linux/drivers/dax/pmem.c:147: undefined reference to `__nd_driver_register'

Fix this by making NVDIMM_DAX a tristate.  DEV_DAX_PMEM depends on
NVDIMM_DAX which depends on LIBNVDIMM.  Since they are all now tristates,
if LIBNVDIMM is built as a kernel module DEV_DAX_PMEM will be as well.
This prevents dax_devs.c from being built as a built-in while its
dependencies are in the libnvdimm.ko module.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
---

Change from v1:
 - Made NVDIMM_DAX a tristate instead of adding an extra dependency. (djbw)

---
 drivers/nvdimm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 124c243..8b2b740 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -89,7 +89,7 @@ config NVDIMM_PFN
 	  Select Y if unsure
 
 config NVDIMM_DAX
-	bool "NVDIMM DAX: Raw access to persistent memory"
+	tristate "NVDIMM DAX: Raw access to persistent memory"
 	default LIBNVDIMM
 	depends on NVDIMM_PFN
 	help
-- 
2.9.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
