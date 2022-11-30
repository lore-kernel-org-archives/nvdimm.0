Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B3779C0
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 19:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669836120; x=1701372120;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rxlI0fPaUF0ZOVsq6EdN124JtOgRy2v+wAKvebYGMg0=;
  b=CuRk5TNMxgQRaqcyOSxp9i+jA0IErFbdBlZksXT8dxUGq7klDBUJ+6nq
   27hE/ErbHuCUCH5Zc3MlnJUyhSW9NKLMqjvDD//W7btlzm3amCQ6/Q/kV
   zBvz+kZhwiEUe95UBCTLPGtsteV4uJj1rG/JyCeYrqkaorkhtLSvrfGqH
   FP8i/dMUFgJj02ak1kk0nlLkGFDVId9zeyZ4smrBleNmS0bagkcJuC5c0
   5V9t/dvIcKT2z7MMU+sOY41V1GIlZE0fVvy6HtKmS2BYPCgKP3/tEp4wA
   lZ3L2PXGM0C/doqo580zPf6f5aQX90c4ezfagp8S4zV6xSzE0QrEW5c9M
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="295853818"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="295853818"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:21:59 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="707768937"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="707768937"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:21:59 -0800
Subject: [PATCH v7 05/20] cxl/pmem: Add Disable Passphrase security command
 support
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Wed, 30 Nov 2022 12:21:58 -0700
Message-ID: 
 <166983611878.2734609.10602135274526390127.stgit@djiang5-desk3.ch.intel.com>
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

Create callback function to support the nvdimm_security_ops ->disable()
callback. Translate the operation to send "Disable Passphrase" security
command for CXL memory device. The operation supports disabling a
passphrase for the CXL persistent memory device. In the original
implementation of nvdimm_security_ops, this operation only supports
disabling of the user passphrase. This is due to the NFIT version of
disable passphrase only supported disabling of user passphrase. The CXL
spec allows disabling of the master passphrase as well which
nvidmm_security_ops does not support yet. In this commit, the callback
function will only support user passphrase.

See CXL rev3.0 spec section 8.2.9.8.6.3 for reference.

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/166863349311.80269.236166040458200044.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/mbox.c      |    1 +
 drivers/cxl/cxlmem.h         |    8 ++++++++
 drivers/cxl/security.c       |   18 ++++++++++++++++++
 include/uapi/linux/cxl_mem.h |    1 +
 4 files changed, 28 insertions(+)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 2fdafa697e6a..890db291c6bf 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -67,6 +67,7 @@ static struct cxl_mem_command cxl_mem_commands[CXL_MEM_COMMAND_ID_MAX] = {
 	CXL_CMD(GET_SCAN_MEDIA, 0, CXL_VARIABLE_PAYLOAD, 0),
 	CXL_CMD(GET_SECURITY_STATE, 0, 0x4, 0),
 	CXL_CMD(SET_PASSPHRASE, 0x60, 0, 0),
+	CXL_CMD(DISABLE_PASSPHRASE, 0x40, 0, 0),
 };
 
 /*
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 725b08148524..9ad92f975b78 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -275,6 +275,7 @@ enum cxl_opcode {
 	CXL_MBOX_OP_GET_SCAN_MEDIA	= 0x4305,
 	CXL_MBOX_OP_GET_SECURITY_STATE	= 0x4500,
 	CXL_MBOX_OP_SET_PASSPHRASE	= 0x4501,
+	CXL_MBOX_OP_DISABLE_PASSPHRASE	= 0x4502,
 	CXL_MBOX_OP_MAX			= 0x10000
 };
 
@@ -390,6 +391,13 @@ struct cxl_set_pass {
 	u8 new_pass[NVDIMM_PASSPHRASE_LEN];
 } __packed;
 
+/* disable passphrase input payload */
+struct cxl_disable_pass {
+	u8 type;
+	u8 reserved[31];
+	u8 pass[NVDIMM_PASSPHRASE_LEN];
+} __packed;
+
 enum {
 	CXL_PMEM_SEC_PASS_MASTER = 0,
 	CXL_PMEM_SEC_PASS_USER,
diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
index 5365646230c3..5a8e852ecadb 100644
--- a/drivers/cxl/security.c
+++ b/drivers/cxl/security.c
@@ -70,9 +70,27 @@ static int cxl_pmem_security_change_key(struct nvdimm *nvdimm,
 	return rc;
 }
 
+static int cxl_pmem_security_disable(struct nvdimm *nvdimm,
+				     const struct nvdimm_key_data *key_data)
+{
+	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
+	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	struct cxl_disable_pass dis_pass;
+	int rc;
+
+	dis_pass.type = CXL_PMEM_SEC_PASS_USER;
+	memcpy(dis_pass.pass, key_data->data, NVDIMM_PASSPHRASE_LEN);
+
+	rc = cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_DISABLE_PASSPHRASE,
+			       &dis_pass, sizeof(dis_pass), NULL, 0);
+	return rc;
+}
+
 static const struct nvdimm_security_ops __cxl_security_ops = {
 	.get_flags = cxl_pmem_get_security_flags,
 	.change_key = cxl_pmem_security_change_key,
+	.disable = cxl_pmem_security_disable,
 };
 
 const struct nvdimm_security_ops *cxl_security_ops = &__cxl_security_ops;
diff --git a/include/uapi/linux/cxl_mem.h b/include/uapi/linux/cxl_mem.h
index 9da047e9b038..f6d383a80f22 100644
--- a/include/uapi/linux/cxl_mem.h
+++ b/include/uapi/linux/cxl_mem.h
@@ -43,6 +43,7 @@
 	___C(GET_SCAN_MEDIA, "Get Scan Media Results"),                   \
 	___C(GET_SECURITY_STATE, "Get Security State"),			  \
 	___C(SET_PASSPHRASE, "Set Passphrase"),				  \
+	___C(DISABLE_PASSPHRASE, "Disable Passphrase"),			  \
 	___C(MAX, "invalid / last command")
 
 #define ___C(a, b) CXL_MEM_COMMAND_ID_##a


