Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9D16B203B99C2
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jul 2018 15:34:08 -0700 (PDT)
Subject: [PATCH v3 02/11] libnvdimm: create keyring to store security keys
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 11 Jul 2018 15:33:59 -0700
Message-ID: <153134843975.41955.12787061715880506684.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153134823290.41955.817023337662647245.stgit@djiang5-desk3.ch.intel.com>
References: <153134823290.41955.817023337662647245.stgit@djiang5-desk3.ch.intel.com>
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
Cc: dhowells@redhat.com, alison.schofield@intel.com, keyrings@vger.kernel.org, keescook@chromium.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Prepping the libnvdimm to support security management by adding a keyring
in order to provide passphrase management through the kernel key management
APIs.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/core.c      |    7 +++
 drivers/nvdimm/dimm_devs.c |   96 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd-core.h   |    1 
 include/linux/libnvdimm.h  |    5 ++
 4 files changed, 107 insertions(+), 2 deletions(-)

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
index 8d348b22ba45..1dcbb653455b 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -18,12 +18,54 @@
 #include <linux/io.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/cred.h>
+#include <keys/user-type.h>
+#include <linux/key-type.h>
+#include <linux/keyctl.h>
 #include "nd-core.h"
 #include "label.h"
 #include "pmem.h"
 #include "nd.h"
 
 static DEFINE_IDA(dimm_ida);
+static const struct cred *nvdimm_cred;
+
+static int nvdimm_key_instantiate(struct key *key,
+		struct key_preparsed_payload *prep);
+static void nvdimm_key_destroy(struct key *key);
+
+struct key_type nvdimm_key_type = {
+	.name = "nvdimm",
+	.instantiate = nvdimm_key_instantiate,
+	.destroy = nvdimm_key_destroy,
+	.describe = user_describe,
+	/*
+	 * The reason to have default data length to be len*2 is to
+	 * accomodate the payload when we are doing a key change where
+	 * the we stuff the old key and new key in the same payload.
+	 */
+	.def_datalen = NVDIMM_PASSPHRASE_LEN * 2,
+};
+
+static int nvdimm_key_instantiate(struct key *key,
+		struct key_preparsed_payload *prep)
+{
+	char *payload;
+
+	payload = kzalloc(nvdimm_key_type.def_datalen, GFP_KERNEL);
+	if (!payload)
+		return -ENOMEM;
+
+	key->datalen = min(nvdimm_key_type.def_datalen, prep->datalen);
+	memcpy(payload, prep->data, key->datalen);
+	key->payload.data[0] = payload;
+	return 0;
+}
+
+static void nvdimm_key_destroy(struct key *key)
+{
+	kfree(key->payload.data[0]);
+}
 
 /*
  * Retrieve bus and dimm handle and return if this bus supports
@@ -668,7 +710,59 @@ int nvdimm_bus_check_dimm_count(struct nvdimm_bus *nvdimm_bus, int dimm_count)
 }
 EXPORT_SYMBOL_GPL(nvdimm_bus_check_dimm_count);
 
-void __exit nvdimm_devs_exit(void)
+static int nvdimm_register_keyring(void)
+{
+	struct cred *cred;
+	struct key *keyring;
+	int rc;
+
+	rc = register_key_type(&nvdimm_key_type);
+	if (rc < 0)
+		return rc;
+
+	cred = prepare_kernel_cred(NULL);
+	if (!cred) {
+		rc = -ENOMEM;
+		goto failed_cred;
+	}
+
+	keyring = keyring_alloc(".nvdimm",
+			GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, cred,
+			(KEY_POS_ALL & ~KEY_POS_SETATTR) |
+			(KEY_USR_ALL & ~KEY_USR_SETATTR),
+			KEY_ALLOC_NOT_IN_QUOTA, NULL, NULL);
+	if (IS_ERR(keyring)) {
+		rc = PTR_ERR(keyring);
+		goto failed_keyring;
+	}
+
+	set_bit(KEY_FLAG_ROOT_CAN_CLEAR, &keyring->flags);
+	cred->thread_keyring = keyring;
+	cred->jit_keyring = KEY_REQKEY_DEFL_THREAD_KEYRING;
+	nvdimm_cred = cred;
+	return 0;
+
+ failed_cred:
+	unregister_key_type(&nvdimm_key_type);
+ failed_keyring:
+	put_cred(cred);
+	return rc;
+}
+
+static void nvdimm_unregister_keyring(void)
+{
+	key_revoke(nvdimm_cred->thread_keyring);
+	unregister_key_type(&nvdimm_key_type);
+	put_cred(nvdimm_cred);
+}
+
+int __init nvdimm_devs_init(void)
+{
+	return nvdimm_register_keyring();
+}
+
+void  nvdimm_devs_exit(void)
 {
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
index 472171af7f60..09dd06f96f95 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -155,6 +155,11 @@ static inline struct nd_blk_region_desc *to_blk_region_desc(
 
 }
 
+extern struct key_type nvdimm_key_type;
+
+#define NVDIMM_PASSPHRASE_LEN		32
+#define NVDIMM_KEY_DESC_LEN		25
+
 void badrange_init(struct badrange *badrange);
 int badrange_add(struct badrange *badrange, u64 addr, u64 length);
 void badrange_forget(struct badrange *badrange, phys_addr_t start,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
