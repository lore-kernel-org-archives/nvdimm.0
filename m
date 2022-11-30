Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD2479C0
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 19:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669836199; x=1701372199;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=88azzkZzbVlSHS6kW7zwXOr9B3rybc+KeSXbL0S7NOQ=;
  b=V1mSxkxs+b00Fe0mjrHKQRfT0m3tgv8m2hfN+xY0ezYmeVmx0UIswMtt
   XdK3TqxhN9C1Y2fIE+W3g0qW2Ij8AkHChDktV2Gh3dmKGy6ZXRPhSrWla
   lOte4YRmHpMWHgw9DsElyVg+IAySIX9+hzbnUlRGNWDLUA4g9SLjpTWRW
   lEB1ElKdrYhsqvsR9Rep2kbrW/xzB/UugEBUplnra5KAxehMD8RI5Y2M+
   Uox94E4DrLDiOs/lRpjdLJ1LkwISXCwygioYfYvptjN9MFPDGPcPhU6a9
   k7HZURJM526Csj9AFxn6Pw4Iz6EcKrKSwezYk0q3y8X1QUklpuLr8y8YF
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="313118777"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="313118777"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:23:19 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="889415487"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="889415487"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:23:19 -0800
Subject: [PATCH v7 19/20] acpi/nfit: bypass cpu_cache_invalidate_memregion()
 when in test config
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Wed, 30 Nov 2022 12:23:18 -0700
Message-ID: 
 <166983619896.2734609.7192339006218947870.stgit@djiang5-desk3.ch.intel.com>
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
cpu_cache_invalidate_memregion() is not needed for nfit_test security
testing.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/nfit/intel.c |   51 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index fa0e57e35162..38069f10c316 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -191,6 +191,39 @@ static int intel_security_change_key(struct nvdimm *nvdimm,
 	}
 }
 
+static bool intel_has_invalidate_memregion(struct nvdimm *nvdimm)
+{
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct acpi_nfit_desc *acpi_desc = nfit_mem->acpi_desc;
+	struct device *dev = acpi_desc->dev;
+
+	if (!cpu_cache_has_invalidate_memregion()) {
+		if (IS_ENABLED(CONFIG_NVDIMM_SECURITY_TEST)) {
+			dev_warn_once(dev,
+				      "Bypassing cpu_cache_has_invalidate_memregion() check for testing!\n");
+			return true;
+		}
+		return false;
+	}
+
+	return true;
+}
+
+static void intel_invalidate_memregion(struct nvdimm *nvdimm)
+{
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct acpi_nfit_desc *acpi_desc = nfit_mem->acpi_desc;
+	struct device *dev = acpi_desc->dev;
+
+	if (IS_ENABLED(CONFIG_NVDIMM_SECURITY_TEST)) {
+		dev_warn_once(dev,
+			      "Bypassing cpu_cache_invalidate_memergion() for testing!\n");
+		return;
+	}
+
+	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
+}
+
 static int __maybe_unused intel_security_unlock(struct nvdimm *nvdimm,
 		const struct nvdimm_key_data *key_data)
 {
@@ -212,7 +245,7 @@ static int __maybe_unused intel_security_unlock(struct nvdimm *nvdimm,
 	if (!test_bit(NVDIMM_INTEL_UNLOCK_UNIT, &nfit_mem->dsm_mask))
 		return -ENOTTY;
 
-	if (!cpu_cache_has_invalidate_memregion())
+	if (!intel_has_invalidate_memregion(nvdimm))
 		return -EINVAL;
 
 	memcpy(nd_cmd.cmd.passphrase, key_data->data,
@@ -230,7 +263,7 @@ static int __maybe_unused intel_security_unlock(struct nvdimm *nvdimm,
 	}
 
 	/* DIMM unlocked, invalidate all CPU caches before we read it */
-	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
+	intel_invalidate_memregion(nvdimm);
 
 	return 0;
 }
@@ -299,11 +332,11 @@ static int __maybe_unused intel_security_erase(struct nvdimm *nvdimm,
 	if (!test_bit(cmd, &nfit_mem->dsm_mask))
 		return -ENOTTY;
 
-	if (!cpu_cache_has_invalidate_memregion())
+	if (!intel_has_invalidate_memregion(nvdimm))
 		return -EINVAL;
 
 	/* flush all cache before we erase DIMM */
-	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
+	intel_invalidate_memregion(nvdimm);
 	memcpy(nd_cmd.cmd.passphrase, key->data,
 			sizeof(nd_cmd.cmd.passphrase));
 	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
@@ -323,7 +356,7 @@ static int __maybe_unused intel_security_erase(struct nvdimm *nvdimm,
 	}
 
 	/* DIMM erased, invalidate all CPU caches before we read it */
-	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
+	intel_invalidate_memregion(nvdimm);
 	return 0;
 }
 
@@ -346,7 +379,7 @@ static int __maybe_unused intel_security_query_overwrite(struct nvdimm *nvdimm)
 	if (!test_bit(NVDIMM_INTEL_QUERY_OVERWRITE, &nfit_mem->dsm_mask))
 		return -ENOTTY;
 
-	if (!cpu_cache_has_invalidate_memregion())
+	if (!intel_has_invalidate_memregion(nvdimm))
 		return -EINVAL;
 
 	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
@@ -363,7 +396,7 @@ static int __maybe_unused intel_security_query_overwrite(struct nvdimm *nvdimm)
 	}
 
 	/* flush all cache before we make the nvdimms available */
-	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
+	intel_invalidate_memregion(nvdimm);
 	return 0;
 }
 
@@ -388,11 +421,11 @@ static int __maybe_unused intel_security_overwrite(struct nvdimm *nvdimm,
 	if (!test_bit(NVDIMM_INTEL_OVERWRITE, &nfit_mem->dsm_mask))
 		return -ENOTTY;
 
-	if (!cpu_cache_has_invalidate_memregion())
+	if (!intel_has_invalidate_memregion(nvdimm))
 		return -EINVAL;
 
 	/* flush all cache before we erase DIMM */
-	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
+	intel_invalidate_memregion(nvdimm);
 	memcpy(nd_cmd.cmd.passphrase, nkey->data,
 			sizeof(nd_cmd.cmd.passphrase));
 	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);


