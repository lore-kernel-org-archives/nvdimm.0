Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EA48A210C2780
 for <linux-nvdimm@lists.01.org>; Wed, 25 Jul 2018 13:58:54 -0700 (PDT)
Subject: [PATCH v6 02/11] libnvdimm: create keyring to store security keys
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 25 Jul 2018 13:58:41 -0700
Message-ID: <153255232187.51274.1933376251981949492.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153255001863.51274.11308713958786222873.stgit@djiang5-desk3.ch.intel.com>
References: <153255001863.51274.11308713958786222873.stgit@djiang5-desk3.ch.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: alison.schofield@intel.com, keescook@chromium.org, ebiggers3@gmail.com, dhowells@redhat.com, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Prepping the libnvdimm to support security management by adding a keyring
in order to provide passphrase management through the kernel key management
APIs.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/core.c      |    7 ++++++-
 drivers/nvdimm/dimm_devs.c |   29 ++++++++++++++++++++++++++++-
 drivers/nvdimm/nd-core.h   |    1 +
 include/linux/libnvdimm.h  |    3 +++
 kernel/cred.c              |    1 +
 5 files changed, 39 insertions(+), 2 deletions(-)

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
index 8d348b22ba45..586432450c82 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -18,12 +18,15 @@
 #include <linux/io.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/key.h>
+#include <linux/init_task.h>
 #include "nd-core.h"
 #include "label.h"
 #include "pmem.h"
 #include "nd.h"
 
 static DEFINE_IDA(dimm_ida);
+static struct key *nvdimm_keyring;
 
 /*
  * Retrieve bus and dimm handle and return if this bus supports
@@ -668,7 +671,31 @@ int nvdimm_bus_check_dimm_count(struct nvdimm_bus *nvdimm_bus, int dimm_count)
 }
 EXPORT_SYMBOL_GPL(nvdimm_bus_check_dimm_count);
 
-void __exit nvdimm_devs_exit(void)
+static int nvdimm_register_keyring(void)
 {
+	nvdimm_keyring = keyring_alloc(".nvdimm",
+			GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, &init_cred,
+			(KEY_POS_ALL & ~KEY_POS_SETATTR) |
+			(KEY_USR_ALL & ~KEY_USR_SETATTR),
+			KEY_ALLOC_NOT_IN_QUOTA, NULL, NULL);
+	if (IS_ERR(nvdimm_keyring))
+		return PTR_ERR(nvdimm_keyring);
+
+	return 0;
+}
+
+static void nvdimm_unregister_keyring(void)
+{
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
index 79274ead54fb..2af0f89c4010 100644
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
diff --git a/kernel/cred.c b/kernel/cred.c
index ecf03657e71c..3a161b78a0a4 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -64,6 +64,7 @@ struct cred init_cred = {
 	.user_ns		= &init_user_ns,
 	.group_info		= &init_groups,
 };
+EXPORT_SYMBOL(init_cred);
 
 static inline void set_cred_subscribers(struct cred *cred, int n)
 {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
