Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5889A211575CA
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 16:37:57 -0700 (PDT)
Subject: [PATCH v9 02/12] libnvdimm: create keyring to store security keys
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 25 Sep 2018 16:37:56 -0700
Message-ID: <153791867602.70158.13975246148609079037.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153791805740.70158.12896535066689316343.stgit@djiang5-desk3.ch.intel.com>
References: <153791805740.70158.12896535066689316343.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
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
To: dan.j.williams@intel.com
Cc: alison.schofield@intel.com, keescook@chromium.org, linux-nvdimm@lists.01.org, ebiggers3@gmail.com, dhowells@redhat.com, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Prepping the libnvdimm to support security management by adding a keyring
in order to provide passphrase management through the kernel key management
APIs.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/Kconfig     |    1 +
 drivers/nvdimm/core.c      |    7 ++++++-
 drivers/nvdimm/dimm_devs.c |   29 ++++++++++++++++++++++++++++-
 drivers/nvdimm/nd-core.h   |    1 +
 include/linux/libnvdimm.h  |    3 +++
 5 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 9d36473dc2a2..830a7a5342e1 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -3,6 +3,7 @@ menuconfig LIBNVDIMM
 	depends on PHYS_ADDR_T_64BIT
 	depends on HAS_IOMEM
 	depends on BLK_DEV
+	depends on KEYS
 	help
 	  Generic support for non-volatile memory devices including
 	  ACPI-6-NFIT defined resources.  On platforms that define an
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index acce050856a8..3cd33d5c7cf0 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -437,9 +437,12 @@ static __init int libnvdimm_init(void)
 {
 	int rc;
 
-	rc = nvdimm_bus_init();
+	rc = nvdimm_devs_init();
 	if (rc)
 		return rc;
+	rc = nvdimm_bus_init();
+	if (rc)
+		goto err_bus;
 	rc = nvdimm_init();
 	if (rc)
 		goto err_dimm;
@@ -454,6 +457,8 @@ static __init int libnvdimm_init(void)
 	nvdimm_exit();
  err_dimm:
 	nvdimm_bus_exit();
+ err_bus:
+	nvdimm_devs_exit();
 	return rc;
 }
 
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 863cabc35215..d058078a82aa 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -18,12 +18,15 @@
 #include <linux/io.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/cred.h>
+#include <linux/key.h>
 #include "nd-core.h"
 #include "label.h"
 #include "pmem.h"
 #include "nd.h"
 
 static DEFINE_IDA(dimm_ida);
+static struct key *nvdimm_keyring;
 
 /*
  * Retrieve bus and dimm handle and return if this bus supports
@@ -699,7 +702,31 @@ int nvdimm_bus_check_dimm_count(struct nvdimm_bus *nvdimm_bus, int dimm_count)
 }
 EXPORT_SYMBOL_GPL(nvdimm_bus_check_dimm_count);
 
-void __exit nvdimm_devs_exit(void)
+static int nvdimm_register_keyring(void)
 {
+	nvdimm_keyring = keyring_alloc(".nvdimm",
+			GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, current_cred(),
+			(KEY_POS_ALL & ~KEY_POS_SETATTR),
+			KEY_ALLOC_NOT_IN_QUOTA, NULL, NULL);
+	if (IS_ERR(nvdimm_keyring))
+		return PTR_ERR(nvdimm_keyring);
+
+	return 0;
+}
+
+static void nvdimm_unregister_keyring(void)
+{
+	key_put(nvdimm_keyring);
+	key_revoke(nvdimm_keyring);
+}
+
+int __init nvdimm_devs_init(void)
+{
+	return nvdimm_register_keyring();
+}
+
+void  nvdimm_devs_exit(void)
+{
+	nvdimm_unregister_keyring();
 	ida_destroy(&dimm_ida);
 }
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index ac68072fb8cd..711eaf055455 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -76,6 +76,7 @@ static inline bool is_memory(struct device *dev)
 struct nvdimm_bus *walk_to_nvdimm_bus(struct device *nd_dev);
 int __init nvdimm_bus_init(void);
 void nvdimm_bus_exit(void);
+int nvdimm_devs_init(void);
 void nvdimm_devs_exit(void);
 void nd_region_devs_exit(void);
 void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus, struct device *dev);
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 472171af7f60..51084043915c 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -155,6 +155,9 @@ static inline struct nd_blk_region_desc *to_blk_region_desc(
 
 }
 
+#define NVDIMM_PASSPHRASE_LEN		32
+#define NVDIMM_KEY_DESC_LEN		22
+
 void badrange_init(struct badrange *badrange);
 int badrange_add(struct badrange *badrange, u64 addr, u64 length);
 void badrange_forget(struct badrange *badrange, phys_addr_t start,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
