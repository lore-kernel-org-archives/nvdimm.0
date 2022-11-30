Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3685579C0
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 19:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669836194; x=1701372194;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+BI7wK78Na9PeoP5VUI1v7KKJou7SzUnSCYvLchLZPM=;
  b=cXHt1ICYZSwDH/UYPnr+zP/IbWap7DYAOvhPXnGmClCLYfP+WqJn3jQf
   zCm3oUvE1KzfM9DdnPvy0l827B0rl3IuAfnYmogs3Z73lp3FEERaMPRVo
   PRTkdjarm0YRzAMjk36YgJRCEqD1Bp6lYfJrTBVKWqR1p1Ytm788cwGT3
   d5CdEXW9ueDshkrL3mRNncO3yGOcaRIGccnRGacH33sCTyMdNHKUJX7vA
   m77cUmeVsUuqmonnsuTCPln4YFleb6OexoDJ0q3IqzoRvlmXbx+rCmwgP
   5DhcvvYGda8vtWfk8Re9FimrpyD/+LKD+n/7mu+wyYYY2mqm10eFkMReW
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="313118743"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="313118743"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:23:13 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="889415452"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="889415452"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:23:13 -0800
Subject: [PATCH v7 18/20] cxl: bypass cpu_cache_invalidate_memregion() when in
 test config
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Wed, 30 Nov 2022 12:23:13 -0700
Message-ID: 
 <166983619332.2734609.2800078343178136915.stgit@djiang5-desk3.ch.intel.com>
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

Bypass cpu_cache_invalidate_memregion() and checks when doing testing
using CONFIG_NVDIMM_SECURITY_TEST flag. The bypass allows testing on
QEMU where cpu_cache_has_invalidate_memregion() fails. Usage of
cpu_cache_invalidate_memregion() is not needed for cxl_test security
testing.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/cxl/security.c |   35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
index cbd005ceb091..2b5088af8fc4 100644
--- a/drivers/cxl/security.c
+++ b/drivers/cxl/security.c
@@ -111,6 +111,31 @@ static int cxl_pmem_security_freeze(struct nvdimm *nvdimm)
 	return cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_FREEZE_SECURITY, NULL, 0, NULL, 0);
 }
 
+static bool cxl_has_invalidate_memregion(struct cxl_nvdimm *cxl_nvd)
+{
+	if (!cpu_cache_has_invalidate_memregion()) {
+		if (IS_ENABLED(CONFIG_NVDIMM_SECURITY_TEST)) {
+			dev_warn_once(&cxl_nvd->dev,
+				      "Bypassing cpu_cache_has_invalidate_memregion() check for testing!\n");
+			return true;
+		}
+		return false;
+	}
+
+	return true;
+}
+
+static void cxl_invalidate_memregion(struct cxl_nvdimm *cxl_nvd)
+{
+	if (IS_ENABLED(CONFIG_NVDIMM_SECURITY_TEST)) {
+		dev_warn_once(&cxl_nvd->dev,
+			      "Bypassing cpu_cache_invalidate_memergion() for testing!\n");
+		return;
+	}
+
+	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
+}
+
 static int cxl_pmem_security_unlock(struct nvdimm *nvdimm,
 				    const struct nvdimm_key_data *key_data)
 {
@@ -120,7 +145,7 @@ static int cxl_pmem_security_unlock(struct nvdimm *nvdimm,
 	u8 pass[NVDIMM_PASSPHRASE_LEN];
 	int rc;
 
-	if (!cpu_cache_has_invalidate_memregion())
+	if (!cxl_has_invalidate_memregion(cxl_nvd))
 		return -EINVAL;
 
 	memcpy(pass, key_data->data, NVDIMM_PASSPHRASE_LEN);
@@ -130,7 +155,7 @@ static int cxl_pmem_security_unlock(struct nvdimm *nvdimm,
 		return rc;
 
 	/* DIMM unlocked, invalidate all CPU caches before we read it */
-	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
+	cxl_invalidate_memregion(cxl_nvd);
 	return 0;
 }
 
@@ -144,21 +169,21 @@ static int cxl_pmem_security_passphrase_erase(struct nvdimm *nvdimm,
 	struct cxl_pass_erase erase;
 	int rc;
 
-	if (!cpu_cache_has_invalidate_memregion())
+	if (!cxl_has_invalidate_memregion(cxl_nvd))
 		return -EINVAL;
 
 	erase.type = ptype == NVDIMM_MASTER ?
 		CXL_PMEM_SEC_PASS_MASTER : CXL_PMEM_SEC_PASS_USER;
 	memcpy(erase.pass, key->data, NVDIMM_PASSPHRASE_LEN);
 	/* Flush all cache before we erase mem device */
-	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
+	cxl_invalidate_memregion(cxl_nvd);
 	rc = cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_PASSPHRASE_SECURE_ERASE,
 			       &erase, sizeof(erase), NULL, 0);
 	if (rc < 0)
 		return rc;
 
 	/* mem device erased, invalidate all CPU caches before data is read */
-	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
+	cxl_invalidate_memregion(cxl_nvd);
 	return 0;
 }
 


