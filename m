Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.13])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A55701A1E57
 for <linux-nvdimm@lists.01.org>; Tue, 25 Oct 2016 08:53:11 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] nvdimm: make CONFIG_NVDIMM_DAX 'bool'
Date: Tue, 25 Oct 2016 17:52:04 +0200
Message-Id: <20161025155246.4174413-1-arnd@arndb.de>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

A bugfix just tried to address a randconfig build problem and introduced
a variant of the same problem: with CONFIG_LIBNVDIMM=y and
CONFIG_NVDIMM_DAX=m, the nvdimm module now fails to link:

drivers/nvdimm/built-in.o: In function `to_nd_device_type':
bus.c:(.text+0x1b5d): undefined reference to `is_nd_dax'
drivers/nvdimm/built-in.o: In function `nd_region_notify_driver_action.constprop.2':
region_devs.c:(.text+0x6b6c): undefined reference to `is_nd_dax'
region_devs.c:(.text+0x6b8c): undefined reference to `to_nd_dax'
drivers/nvdimm/built-in.o: In function `nd_region_probe':
region.c:(.text+0x70f3): undefined reference to `nd_dax_create'
drivers/nvdimm/built-in.o: In function `mode_show':
namespace_devs.c:(.text+0xa196): undefined reference to `is_nd_dax'
drivers/nvdimm/built-in.o: In function `nvdimm_namespace_common_probe':
(.text+0xa55f): undefined reference to `is_nd_dax'
drivers/nvdimm/built-in.o: In function `nvdimm_namespace_common_probe':
(.text+0xa56e): undefined reference to `to_nd_dax'

This reverts the earlier fix, making NVDIMM_DAX a 'bool' option again
as it should be (it gets linked into the libnvdimm module). To fix
the original problem, I'm adding a dependency on LIBNVDIMM to
DEV_DAX_PMEM, which ensures we can't have that one built-in if the
rest is a module.

Fixes: 4e65e9381c7a ("/dev/dax: fix Kconfig dependency build breakage")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/dax/Kconfig    | 2 +-
 drivers/nvdimm/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index daadd20aa936..3e2ab3b14eea 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -14,7 +14,7 @@ if DEV_DAX
 
 config DEV_DAX_PMEM
 	tristate "PMEM DAX: direct access to persistent memory"
-	depends on NVDIMM_DAX
+	depends on LIBNVDIMM && NVDIMM_DAX
 	default DEV_DAX
 	help
 	  Support raw access to persistent memory.  Note that this
diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 8b2b740d6679..124c2432ac9c 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -89,7 +89,7 @@ config NVDIMM_PFN
 	  Select Y if unsure
 
 config NVDIMM_DAX
-	tristate "NVDIMM DAX: Raw access to persistent memory"
+	bool "NVDIMM DAX: Raw access to persistent memory"
 	default LIBNVDIMM
 	depends on NVDIMM_PFN
 	help
-- 
2.9.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
