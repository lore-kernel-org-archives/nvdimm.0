Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669955381
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 21:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657919377; x=1689455377;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SiRuRk9Q3gpxaUHCA0EXScnQYKNtaFE65XGq4hLyZY4=;
  b=P60vhFpGoLDgGwDhinkmDFpBhN/DofEwQN+RK0GEb8AEne8I13wPIRHU
   zzonMHGfB6FgIQ56/Owaiifsz3hoJ8aKUQTIArGStOXTE+OY2jQwsgcMV
   9KTlyhXQNV7KdD1DxuQrUpkrmxQeSQMKnZXYZO6meUFXPVpg+R33VeNAd
   uiQ8vAG0nBR2Y5M71hGbIkuwoql/wTWmFxZEJxBYxTgS+DCvIwErohXZo
   nP/wrqhwoNzyXffnD65OkPBw+pdbKFYDX5Nmr9sPVWz5f1KoJF3hJKGrG
   xVSVwhoUfwz/HgNXhz1cOuB3eONV4ATOKT4+OVoS7OxNDwWLXp5LwPFDk
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="311568629"
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="311568629"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:09:36 -0700
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="699348781"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:09:36 -0700
Subject: [PATCH RFC 11/15] cxl/pmem: Add "Unlock" security command support
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com, dave@stgolabs.net
Date: Fri, 15 Jul 2022 14:09:36 -0700
Message-ID: 
 <165791937639.2491387.6281906434880014077.stgit@djiang5-desk3.ch.intel.com>
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

Create callback function to support the nvdimm_security_ops() ->unlock()
callback. Translate the operation to send "Unlock" security command for CXL
mem device.

When the mem device is unlocked, arch_invalidate_nvdimm_cache() is called
in order to invalidate all CPU caches before attempting to access the mem
device.

See CXL 2.0 spec section 8.2.9.5.6.4 for reference.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/cxl/cxlmem.h   |    1 +
 drivers/cxl/security.c |   21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index ced85be291f3..ae8ccd484491 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -253,6 +253,7 @@ enum cxl_opcode {
 	CXL_MBOX_OP_GET_SECURITY_STATE	= 0x4500,
 	CXL_MBOX_OP_SET_PASSPHRASE	= 0x4501,
 	CXL_MBOX_OP_DISABLE_PASSPHRASE	= 0x4502,
+	CXL_MBOX_OP_UNLOCK		= 0x4503,
 	CXL_MBOX_OP_FREEZE_SECURITY	= 0x4504,
 	CXL_MBOX_OP_MAX			= 0x10000
 };
diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
index 6399266a5908..d15520f280f0 100644
--- a/drivers/cxl/security.c
+++ b/drivers/cxl/security.c
@@ -114,11 +114,32 @@ static int cxl_pmem_security_freeze(struct nvdimm *nvdimm)
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
+	memcpy(pass, key_data->data, NVDIMM_PASSPHRASE_LEN);
+	rc = cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_UNLOCK,
+			       pass, NVDIMM_PASSPHRASE_LEN, NULL, 0);
+	if (rc < 0)
+		return rc;
+
+	/* DIMM unlocked, invalidate all CPU caches before we read it */
+	arch_invalidate_nvdimm_cache();
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


