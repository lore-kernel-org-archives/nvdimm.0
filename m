Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1C08482
	for <nvdimm@lists.linux.dev>; Mon, 14 Nov 2022 20:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668458002; x=1699994002;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gQFJmEm1yIbBU/UMPn3C7QK40hgp66lqohrvDqJoOXE=;
  b=Wm9SMmqLIAzT8Uik2EzTPbg9Qydms12gckPdurcEhZ+kcn0WwrOsrEk5
   b19AJ4ix1RAh7b2usFuHq2Hn0hCl1oCz51jqbyG9QvOFTaBered5V0j+9
   BKDKenJiAXElGkrTX0ZVJlQZSEOuufWHjWL5zvr3vbyoUs7HJVtSKOq6q
   4+T/YX2HONa0SJZfJVwZXiCFoFfULbylroYDxRlGufKiFjELFvFOObUBK
   bG9fjXHuG+3CJNqK2nx6Bi3Y3TDoD1XuLSdSyBwXUhssbJ+XoF4w1bGCx
   K+owMD6WQt74RKAdTYR9EVgPJwPvI5VRpST9Kz+GgYT/kU27sp1Gd0Z4o
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="374205996"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="374205996"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 12:33:22 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="671711559"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="671711559"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 12:33:22 -0800
Subject: [PATCH v4 03/18] cxl/pmem: Add "Set Passphrase" security command
 support
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Mon, 14 Nov 2022 13:33:21 -0700
Message-ID: 
 <166845800170.2496228.1755789156116478584.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166845791969.2496228.8357488385523295841.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166845791969.2496228.8357488385523295841.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Create callback function to support the nvdimm_security_ops ->change_key()
callback. Translate the operation to send "Set Passphrase" security command
for CXL memory device. The operation supports setting a passphrase for the
CXL persistent memory device. It also supports the changing of the
currently set passphrase. The operation allows manipulation of a user
passphrase or a master passphrase.

See CXL rev3.0 spec section 8.2.9.8.6.2 for reference.

However, the spec leaves a gap WRT master passphrase usages. The spec does
not define any ways to retrieve the status of if the support of master
passphrase is available for the device, nor does the commands that utilize
master passphrase will return a specific error that indicates master
passphrase is not supported. If using a device does not support master
passphrase and a command is issued with a master passphrase, the error
message returned by the device will be ambiguos.

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/cxl/core/mbox.c      |    1 +
 drivers/cxl/cxlmem.h         |   15 +++++++++++++++
 drivers/cxl/security.c       |   22 ++++++++++++++++++++++
 include/uapi/linux/cxl_mem.h |    1 +
 4 files changed, 39 insertions(+)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 8f4be61a76b5..cc08383499e6 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -66,6 +66,7 @@ static struct cxl_mem_command cxl_mem_commands[CXL_MEM_COMMAND_ID_MAX] = {
 	CXL_CMD(SCAN_MEDIA, 0x11, 0, 0),
 	CXL_CMD(GET_SCAN_MEDIA, 0, CXL_VARIABLE_PAYLOAD, 0),
 	CXL_CMD(GET_SECURITY_STATE, 0, 0x4, 0),
+	CXL_CMD(SET_PASSPHRASE, 0x60, 0, 0),
 };
 
 /*
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 25d1d8fa7d1e..725b08148524 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -274,6 +274,7 @@ enum cxl_opcode {
 	CXL_MBOX_OP_SCAN_MEDIA		= 0x4304,
 	CXL_MBOX_OP_GET_SCAN_MEDIA	= 0x4305,
 	CXL_MBOX_OP_GET_SECURITY_STATE	= 0x4500,
+	CXL_MBOX_OP_SET_PASSPHRASE	= 0x4501,
 	CXL_MBOX_OP_MAX			= 0x10000
 };
 
@@ -380,6 +381,20 @@ struct cxl_mem_command {
 #define CXL_PMEM_SEC_STATE_USER_PLIMIT		0x10
 #define CXL_PMEM_SEC_STATE_MASTER_PLIMIT	0x20
 
+/* set passphrase input payload */
+struct cxl_set_pass {
+	u8 type;
+	u8 reserved[31];
+	/* CXL field using NVDIMM define, same length */
+	u8 old_pass[NVDIMM_PASSPHRASE_LEN];
+	u8 new_pass[NVDIMM_PASSPHRASE_LEN];
+} __packed;
+
+enum {
+	CXL_PMEM_SEC_PASS_MASTER = 0,
+	CXL_PMEM_SEC_PASS_USER,
+};
+
 int cxl_mbox_send_cmd(struct cxl_dev_state *cxlds, u16 opcode, void *in,
 		      size_t in_size, void *out, size_t out_size);
 int cxl_dev_state_identify(struct cxl_dev_state *cxlds);
diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
index 806173084216..5365646230c3 100644
--- a/drivers/cxl/security.c
+++ b/drivers/cxl/security.c
@@ -49,8 +49,30 @@ static unsigned long cxl_pmem_get_security_flags(struct nvdimm *nvdimm,
 	return security_flags;
 }
 
+static int cxl_pmem_security_change_key(struct nvdimm *nvdimm,
+					const struct nvdimm_key_data *old_data,
+					const struct nvdimm_key_data *new_data,
+					enum nvdimm_passphrase_type ptype)
+{
+	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
+	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	struct cxl_set_pass set_pass;
+	int rc;
+
+	set_pass.type = ptype == NVDIMM_MASTER ?
+		CXL_PMEM_SEC_PASS_MASTER : CXL_PMEM_SEC_PASS_USER;
+	memcpy(set_pass.old_pass, old_data->data, NVDIMM_PASSPHRASE_LEN);
+	memcpy(set_pass.new_pass, new_data->data, NVDIMM_PASSPHRASE_LEN);
+
+	rc = cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_SET_PASSPHRASE,
+			       &set_pass, sizeof(set_pass), NULL, 0);
+	return rc;
+}
+
 static const struct nvdimm_security_ops __cxl_security_ops = {
 	.get_flags = cxl_pmem_get_security_flags,
+	.change_key = cxl_pmem_security_change_key,
 };
 
 const struct nvdimm_security_ops *cxl_security_ops = &__cxl_security_ops;
diff --git a/include/uapi/linux/cxl_mem.h b/include/uapi/linux/cxl_mem.h
index cdc6049683ce..9da047e9b038 100644
--- a/include/uapi/linux/cxl_mem.h
+++ b/include/uapi/linux/cxl_mem.h
@@ -42,6 +42,7 @@
 	___C(SCAN_MEDIA, "Scan Media"),                                   \
 	___C(GET_SCAN_MEDIA, "Get Scan Media Results"),                   \
 	___C(GET_SECURITY_STATE, "Get Security State"),			  \
+	___C(SET_PASSPHRASE, "Set Passphrase"),				  \
 	___C(MAX, "invalid / last command")
 
 #define ___C(a, b) CXL_MEM_COMMAND_ID_##a


