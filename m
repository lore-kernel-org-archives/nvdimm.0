Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E895381
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 21:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657919371; x=1689455371;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rtukhubC3aqh2vkOnHVty67vv9kxu5Rbgw6dYyDe7CQ=;
  b=eIG3uvN8l0WH8WslDGDZFdMsx4h3nOiCdJ2zkCCjOJP2tNIdlleP8WVT
   EqoMQ6LPxGWUBiTnAIH9N2g+CZzoZp5JBy9EYPNM+yrR4WFZAz+D7EVdq
   qotHyuxaly3/eyBdxbzNDTURNfqevE/QbCuZbThn60OPS4vlrwkv+noaz
   WOSDij0m6TPXOwO5VFgnkBoZmC4NxdjSo9zFmGlu64fa1WcDG5+9GgwWn
   ZntkSfgtXuzVNrcLVDBVSF/FNDzQ0+j7Z0TgIo3BIDgbPPpyRm+YXZutO
   GhHFptdIGitStwPF/I9O6Zw8PdEH/fuEHSq6D/zZAVLNarZLJc70Cc82V
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="265689817"
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="265689817"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:09:31 -0700
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="699348764"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:09:31 -0700
Subject: [PATCH RFC 10/15] x86: add an arch helper function to invalidate all
 cache for nvdimm
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com, dave@stgolabs.net
Date: Fri, 15 Jul 2022 14:09:30 -0700
Message-ID: 
 <165791937063.2491387.15277418618265930924.stgit@djiang5-desk3.ch.intel.com>
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

The original implementation to flush all cache after unlocking the nvdimm
resides in drivers/acpi/nfit/intel.c. This is a temporary stop gap until
nvdimm with security operations arrives on other archs. With support CXL
pmem supporting security operations, specifically "unlock" dimm, the need
for an arch supported helper function to invalidate all CPU cache for
nvdimm has arrived. Remove original implementation from acpi/nfit and add
cross arch support for this operation.

Add CONFIG_ARCH_HAS_NVDIMM_INVAL_CACHE Kconfig and allow x86_64 to opt in
and provide the support via wbinvd_on_all_cpus() call.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 arch/x86/Kconfig             |    1 +
 arch/x86/mm/pat/set_memory.c |    8 ++++++++
 drivers/acpi/nfit/intel.c    |   28 +++++-----------------------
 include/linux/libnvdimm.h    |    8 ++++++++
 lib/Kconfig                  |    3 +++
 5 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index be0b95e51df6..8dbe89eba639 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -83,6 +83,7 @@ config X86
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_PMEM_API		if X86_64
+	select ARCH_HAS_NVDIMM_INVAL_CACHE	if X86_64
 	select ARCH_HAS_PTE_DEVMAP		if X86_64
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_UACCESS_FLUSHCACHE	if X86_64
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 1abd5438f126..e4cd1286deef 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -330,6 +330,14 @@ void arch_invalidate_pmem(void *addr, size_t size)
 EXPORT_SYMBOL_GPL(arch_invalidate_pmem);
 #endif
 
+#ifdef CONFIG_ARCH_HAS_NVDIMM_INVAL_CACHE
+void arch_invalidate_nvdimm_cache(void)
+{
+	wbinvd_on_all_cpus();
+}
+EXPORT_SYMBOL_GPL(arch_invalidate_nvdimm_cache);
+#endif
+
 static void __cpa_flush_all(void *arg)
 {
 	unsigned long cache = (unsigned long)arg;
diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index 8dd792a55730..242d2e9203e9 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -190,8 +190,6 @@ static int intel_security_change_key(struct nvdimm *nvdimm,
 	}
 }
 
-static void nvdimm_invalidate_cache(void);
-
 static int __maybe_unused intel_security_unlock(struct nvdimm *nvdimm,
 		const struct nvdimm_key_data *key_data)
 {
@@ -228,7 +226,7 @@ static int __maybe_unused intel_security_unlock(struct nvdimm *nvdimm,
 	}
 
 	/* DIMM unlocked, invalidate all CPU caches before we read it */
-	nvdimm_invalidate_cache();
+	arch_invalidate_nvdimm_cache();
 
 	return 0;
 }
@@ -298,7 +296,7 @@ static int __maybe_unused intel_security_erase(struct nvdimm *nvdimm,
 		return -ENOTTY;
 
 	/* flush all cache before we erase DIMM */
-	nvdimm_invalidate_cache();
+	arch_invalidate_nvdimm_cache();
 	memcpy(nd_cmd.cmd.passphrase, key->data,
 			sizeof(nd_cmd.cmd.passphrase));
 	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
@@ -318,7 +316,7 @@ static int __maybe_unused intel_security_erase(struct nvdimm *nvdimm,
 	}
 
 	/* DIMM erased, invalidate all CPU caches before we read it */
-	nvdimm_invalidate_cache();
+	arch_invalidate_nvdimm_cache();
 	return 0;
 }
 
@@ -355,7 +353,7 @@ static int __maybe_unused intel_security_query_overwrite(struct nvdimm *nvdimm)
 	}
 
 	/* flush all cache before we make the nvdimms available */
-	nvdimm_invalidate_cache();
+	arch_invalidate_nvdimm_cache();
 	return 0;
 }
 
@@ -381,7 +379,7 @@ static int __maybe_unused intel_security_overwrite(struct nvdimm *nvdimm,
 		return -ENOTTY;
 
 	/* flush all cache before we erase DIMM */
-	nvdimm_invalidate_cache();
+	arch_invalidate_nvdimm_cache();
 	memcpy(nd_cmd.cmd.passphrase, nkey->data,
 			sizeof(nd_cmd.cmd.passphrase));
 	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
@@ -401,22 +399,6 @@ static int __maybe_unused intel_security_overwrite(struct nvdimm *nvdimm,
 	}
 }
 
-/*
- * TODO: define a cross arch wbinvd equivalent when/if
- * NVDIMM_FAMILY_INTEL command support arrives on another arch.
- */
-#ifdef CONFIG_X86
-static void nvdimm_invalidate_cache(void)
-{
-	wbinvd_on_all_cpus();
-}
-#else
-static void nvdimm_invalidate_cache(void)
-{
-	WARN_ON_ONCE("cache invalidation required after unlock\n");
-}
-#endif
-
 static const struct nvdimm_security_ops __intel_security_ops = {
 	.get_flags = intel_security_flags,
 	.freeze = intel_security_freeze,
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 0d61e07b6827..455d54ec3c86 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -308,4 +308,12 @@ static inline void arch_invalidate_pmem(void *addr, size_t size)
 }
 #endif
 
+#ifdef CONFIG_ARCH_HAS_NVDIMM_INVAL_CACHE
+void arch_invalidate_nvdimm_cache(void);
+#else
+static inline void arch_invalidate_nvdimm_cache(void)
+{
+}
+#endif
+
 #endif /* __LIBNVDIMM_H__ */
diff --git a/lib/Kconfig b/lib/Kconfig
index eaaad4d85bf2..d4bc48eea635 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -652,6 +652,9 @@ config ARCH_NO_SG_CHAIN
 config ARCH_HAS_PMEM_API
 	bool
 
+config ARCH_HAS_NVDIMM_INVAL_CACHE
+	bool
+
 config MEMREGION
 	bool
 


