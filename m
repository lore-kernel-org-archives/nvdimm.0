Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35275382
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 21:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657919389; x=1689455389;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L/mYFlodFVBIt1ciLDhpJOinYXzfR4o+44dbw4W6rrc=;
  b=f5fr/gASPSlanICpGdCnok/xWksETT9YMaZkmYKQ/VI6iJOfmT+4/IsO
   AX7P5UyaQqiN3iayRoalPqczT+k1hpKp1iMWFNtyO8ilGCpu9uUTbfn8b
   EKivPJ/Sh24mkVnb8l5ytP6gOBWHY0dpbdOJLuSyxVPZ9VCuH8YshNZbL
   WcqhNIT8by2O/nuNXYs+bBF9se/GoeWyLYrGpzA39gDaSsSNVSsBfL8Ah
   656Av9yMuIvkGyA6crlus7ofaSK2F1Yr/oYeb/PD7aCG+goxGLYefB9c6
   eyy2hGSz0mQL9nxMbYd/DpCFY9pL0yPcwFWaztGQmwhN1auWYpY3sSni8
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="268921590"
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="268921590"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:09:49 -0700
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="571680911"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:09:48 -0700
Subject: [PATCH RFC 13/15] cxl/pmem: Add "Passphrase Secure Erase" security
 command support
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com, dave@stgolabs.net
Date: Fri, 15 Jul 2022 14:09:48 -0700
Message-ID: 
 <165791938847.2491387.8701829648751368015.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
References: 
 <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.1
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

When the mem device is secure erased, arch_invalidate_nvdimm_cache() is
called in order to invalidate all CPU caches before attempting to access
the mem device again.

See CXL 2.0 spec section 8.2.9.5.6.6 for reference.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/cxl/cxlmem.h   |    8 ++++++++
 drivers/cxl/security.c |   29 +++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index ae8ccd484491..4bcb02f625b4 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -255,6 +255,7 @@ enum cxl_opcode {
 	CXL_MBOX_OP_DISABLE_PASSPHRASE	= 0x4502,
 	CXL_MBOX_OP_UNLOCK		= 0x4503,
 	CXL_MBOX_OP_FREEZE_SECURITY	= 0x4504,
+	CXL_MBOX_OP_PASSPHRASE_ERASE	= 0x4505,
 	CXL_MBOX_OP_MAX			= 0x10000
 };
 
@@ -369,6 +370,13 @@ struct cxl_disable_pass {
 	u8 pass[NVDIMM_PASSPHRASE_LEN];
 } __packed;
 
+/* passphrase erase payload */
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
index d15520f280f0..4add7f62e758 100644
--- a/drivers/cxl/security.c
+++ b/drivers/cxl/security.c
@@ -134,12 +134,41 @@ static int cxl_pmem_security_unlock(struct nvdimm *nvdimm,
 	return 0;
 }
 
+static int cxl_pmem_security_passphrase_erase(struct nvdimm *nvdimm,
+					      const struct nvdimm_key_data *key,
+					      enum nvdimm_passphrase_type ptype)
+{
+	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
+	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	struct cxl_pass_erase *erase;
+	int rc;
+
+	erase = kzalloc(sizeof(*erase), GFP_KERNEL);
+	if (!erase)
+		return -ENOMEM;
+
+	erase->type = ptype == NVDIMM_MASTER ?
+		CXL_PMEM_SEC_PASS_MASTER : CXL_PMEM_SEC_PASS_USER;
+	memcpy(erase->pass, key->data, NVDIMM_PASSPHRASE_LEN);
+	rc =  cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_PASSPHRASE_ERASE,
+				erase, sizeof(*erase), NULL, 0);
+	kfree(erase);
+	if (rc < 0)
+		return rc;
+
+	/* DIMM erased, invalidate all CPU caches before we read it */
+	arch_invalidate_nvdimm_cache();
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


