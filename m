Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFE58BF5
	for <nvdimm@lists.linux.dev>; Tue,  8 Nov 2022 17:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667928374; x=1699464374;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ArEBJRqluQxIXbJ0kEcWUlXVansImUJdkEv18Dor6Hg=;
  b=Fm0DDDorC4wuts8YEM9IoZ1heo+C2w3gS//2hC0HhU6hfWron1wOFHks
   DJlKPsNp/XKPjTHRtY5j1jSITP3CWcKo9U1xbgOCCbWxavzFIbYbMSAk4
   XH3okDdz9vlF970oaPEATAav7nEK5T3IwkAD8cdJzDK/SU8vPC01xh2k6
   QANQOPvt68aGquPYJpUZudFa6vFN8wtyhDKjEzJvQwaDzVybcnSDWsUtS
   WDvKmWg+LRmg9EO/P4MhNwoTPiwtZLOz62NEqrU6iaw5XJsvVEHLpgX4B
   T7TZLYMblioCMwXl9j5/dWegjLhBxR8NH9v60aN3/Zsnw18zfrYopLnEb
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="397051955"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="397051955"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 09:26:13 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="669629774"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="669629774"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 09:26:13 -0800
Subject: [PATCH v3 09/18] cxl/pmem: Add "Unlock" security command support
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Tue, 08 Nov 2022 10:26:12 -0700
Message-ID: 
 <166792837285.3767969.18401966325989182361.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166792815961.3767969.2621677491424623673.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166792815961.3767969.2621677491424623673.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Create callback function to support the nvdimm_security_ops() ->unlock()
callback. Translate the operation to send "Unlock" security command for CXL
mem device.

When the mem device is unlocked, cpu_cache_invalidate_memregion() is called
in order to invalidate all CPU caches before attempting to access the mem
device.

See CXL rev3.0 spec section 8.2.9.8.6.4 for reference.

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/cxl/core/mbox.c      |    1 +
 drivers/cxl/cxlmem.h         |    1 +
 drivers/cxl/security.c       |   27 +++++++++++++++++++++++++++
 include/uapi/linux/cxl_mem.h |    1 +
 4 files changed, 30 insertions(+)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 6b8f118b2604..243b01e2de85 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -69,6 +69,7 @@ static struct cxl_mem_command cxl_mem_commands[CXL_MEM_COMMAND_ID_MAX] = {
 	CXL_CMD(SET_PASSPHRASE, 0x60, 0, 0),
 	CXL_CMD(DISABLE_PASSPHRASE, 0x40, 0, 0),
 	CXL_CMD(FREEZE_SECURITY, 0, 0, 0),
+	CXL_CMD(UNLOCK, 0x20, 0, 0),
 };
 
 /*
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 9007158969fe..4e6897e8eb7d 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -276,6 +276,7 @@ enum cxl_opcode {
 	CXL_MBOX_OP_GET_SECURITY_STATE	= 0x4500,
 	CXL_MBOX_OP_SET_PASSPHRASE	= 0x4501,
 	CXL_MBOX_OP_DISABLE_PASSPHRASE	= 0x4502,
+	CXL_MBOX_OP_UNLOCK		= 0x4503,
 	CXL_MBOX_OP_FREEZE_SECURITY	= 0x4504,
 	CXL_MBOX_OP_MAX			= 0x10000
 };
diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
index d991cbee3531..cf20d58ac1b3 100644
--- a/drivers/cxl/security.c
+++ b/drivers/cxl/security.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>
 #include <linux/async.h>
 #include <linux/slab.h>
+#include <linux/memregion.h>
 #include "cxlmem.h"
 #include "cxl.h"
 
@@ -104,11 +105,37 @@ static int cxl_pmem_security_freeze(struct nvdimm *nvdimm)
 	return cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_FREEZE_SECURITY, NULL, 0, NULL, 0);
 }
 
+static int cxl_pmem_security_unlock(struct nvdimm *nvdimm,
+				    const struct nvdimm_key_data *key_data)
+{
+	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
+	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	u8 pass[NVDIMM_PASSPHRASE_LEN];
+	int rc;
+
+	if (!cpu_cache_has_invalidate_memregion())
+		return -EINVAL;
+
+	memcpy(pass, key_data->data, NVDIMM_PASSPHRASE_LEN);
+	rc = cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_UNLOCK,
+			       pass, NVDIMM_PASSPHRASE_LEN, NULL, 0);
+	if (rc < 0)
+		return rc;
+
+	/* DIMM unlocked, invalidate all CPU caches before we read it */
+	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
+	return 0;
+}
+
 static const struct nvdimm_security_ops __cxl_security_ops = {
 	.get_flags = cxl_pmem_get_security_flags,
 	.change_key = cxl_pmem_security_change_key,
 	.disable = cxl_pmem_security_disable,
 	.freeze = cxl_pmem_security_freeze,
+	.unlock = cxl_pmem_security_unlock,
 };
 
 const struct nvdimm_security_ops *cxl_security_ops = &__cxl_security_ops;
+
+MODULE_IMPORT_NS(DEVMEM);
diff --git a/include/uapi/linux/cxl_mem.h b/include/uapi/linux/cxl_mem.h
index 7c0adcd68f4c..95dca8d4584f 100644
--- a/include/uapi/linux/cxl_mem.h
+++ b/include/uapi/linux/cxl_mem.h
@@ -45,6 +45,7 @@
 	___C(SET_PASSPHRASE, "Set Passphrase"),				  \
 	___C(DISABLE_PASSPHRASE, "Disable Passphrase"),			  \
 	___C(FREEZE_SECURITY, "Freeze Security"),			  \
+	___C(UNLOCK, "Unlock"),						  \
 	___C(MAX, "invalid / last command")
 
 #define ___C(a, b) CXL_MEM_COMMAND_ID_##a


