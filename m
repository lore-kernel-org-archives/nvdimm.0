Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74F679C0
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 19:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669836154; x=1701372154;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qJ5/lBpS30M80PKAX4DhOrdEuORPWqjhzjjMtJPEmWY=;
  b=nLnQ4/jVmMZvqOzeOgvyvw6wud5vChudvd7DQJQrjZadWz0Rjsc+aEJc
   OpahaOEyFiZh69j0kHej8lJBRoA0nO888VuVsTt25A+Tm9VTUKReXoq8h
   sTYOFmexP0MxRU4toZkoJlby61dj7Xc22EsXmPnYiFjXff4mjtJdtntIE
   6bRC0YfEUE5k9xIDmhVY3ZTPdnO4dk5mvJMvFHq2OkFjeqIF17qiaeOyw
   IWGePFXGIrlXVK1zEsrwNtKxyQmLZ8KqfxxS0Z3W9L3o/Frz9ObmEOuCJ
   FhGWy71uNSZ3YR20M0jnkSH/mvRszSTkKAqELOgRS1h7WOW/n6LGebEYr
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="401765285"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="401765285"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:22:34 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="818746896"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="818746896"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:22:33 -0800
Subject: [PATCH v7 11/20] cxl/pmem: Add "Passphrase Secure Erase" security
 command support
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Wed, 30 Nov 2022 12:22:32 -0700
Message-ID: 
 <166983615293.2734609.10358657600295932156.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166983606451.2734609.4050644229630259452.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166983606451.2734609.4050644229630259452.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Create callback function to support the nvdimm_security_ops() ->erase()
callback. Translate the operation to send "Passphrase Secure Erase"
security command for CXL memory device.

When the mem device is secure erased, cpu_cache_invalidate_memregion() is
called in order to invalidate all CPU caches before attempting to access
the mem device again.

See CXL 3.0 spec section 8.2.9.8.6.6 for reference.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/166863352881.80269.10617962967662917503.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/mbox.c      |    1 +
 drivers/cxl/cxlmem.h         |    8 ++++++++
 drivers/cxl/security.c       |   29 +++++++++++++++++++++++++++++
 include/uapi/linux/cxl_mem.h |    1 +
 4 files changed, 39 insertions(+)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 4f84d3962fb1..8747db329087 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -70,6 +70,7 @@ static struct cxl_mem_command cxl_mem_commands[CXL_MEM_COMMAND_ID_MAX] = {
 	CXL_CMD(DISABLE_PASSPHRASE, 0x40, 0, 0),
 	CXL_CMD(FREEZE_SECURITY, 0, 0, 0),
 	CXL_CMD(UNLOCK, 0x20, 0, 0),
+	CXL_CMD(PASSPHRASE_SECURE_ERASE, 0x40, 0, 0),
 };
 
 /*
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 4e6897e8eb7d..75baeb0bbe57 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -278,6 +278,7 @@ enum cxl_opcode {
 	CXL_MBOX_OP_DISABLE_PASSPHRASE	= 0x4502,
 	CXL_MBOX_OP_UNLOCK		= 0x4503,
 	CXL_MBOX_OP_FREEZE_SECURITY	= 0x4504,
+	CXL_MBOX_OP_PASSPHRASE_SECURE_ERASE	= 0x4505,
 	CXL_MBOX_OP_MAX			= 0x10000
 };
 
@@ -400,6 +401,13 @@ struct cxl_disable_pass {
 	u8 pass[NVDIMM_PASSPHRASE_LEN];
 } __packed;
 
+/* passphrase secure erase payload */
+struct cxl_pass_erase {
+	u8 type;
+	u8 reserved[31];
+	u8 pass[NVDIMM_PASSPHRASE_LEN];
+} __packed;
+
 enum {
 	CXL_PMEM_SEC_PASS_MASTER = 0,
 	CXL_PMEM_SEC_PASS_USER,
diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
index 32b9e279e74b..4a8132559a96 100644
--- a/drivers/cxl/security.c
+++ b/drivers/cxl/security.c
@@ -120,12 +120,41 @@ static int cxl_pmem_security_unlock(struct nvdimm *nvdimm,
 	return 0;
 }
 
+static int cxl_pmem_security_passphrase_erase(struct nvdimm *nvdimm,
+					      const struct nvdimm_key_data *key,
+					      enum nvdimm_passphrase_type ptype)
+{
+	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
+	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	struct cxl_pass_erase erase;
+	int rc;
+
+	if (!cpu_cache_has_invalidate_memregion())
+		return -EINVAL;
+
+	erase.type = ptype == NVDIMM_MASTER ?
+		CXL_PMEM_SEC_PASS_MASTER : CXL_PMEM_SEC_PASS_USER;
+	memcpy(erase.pass, key->data, NVDIMM_PASSPHRASE_LEN);
+	/* Flush all cache before we erase mem device */
+	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
+	rc = cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_PASSPHRASE_SECURE_ERASE,
+			       &erase, sizeof(erase), NULL, 0);
+	if (rc < 0)
+		return rc;
+
+	/* mem device erased, invalidate all CPU caches before data is read */
+	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
+	return 0;
+}
+
 static const struct nvdimm_security_ops __cxl_security_ops = {
 	.get_flags = cxl_pmem_get_security_flags,
 	.change_key = cxl_pmem_security_change_key,
 	.disable = cxl_pmem_security_disable,
 	.freeze = cxl_pmem_security_freeze,
 	.unlock = cxl_pmem_security_unlock,
+	.erase = cxl_pmem_security_passphrase_erase,
 };
 
 const struct nvdimm_security_ops *cxl_security_ops = &__cxl_security_ops;
diff --git a/include/uapi/linux/cxl_mem.h b/include/uapi/linux/cxl_mem.h
index 95dca8d4584f..82bdad4ce5de 100644
--- a/include/uapi/linux/cxl_mem.h
+++ b/include/uapi/linux/cxl_mem.h
@@ -46,6 +46,7 @@
 	___C(DISABLE_PASSPHRASE, "Disable Passphrase"),			  \
 	___C(FREEZE_SECURITY, "Freeze Security"),			  \
 	___C(UNLOCK, "Unlock"),						  \
+	___C(PASSPHRASE_SECURE_ERASE, "Passphrase Secure Erase"),	  \
 	___C(MAX, "invalid / last command")
 
 #define ___C(a, b) CXL_MEM_COMMAND_ID_##a


