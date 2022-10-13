Received: from hamster.birch.relay.mailchannels.net (hamster.birch.relay.mailchannels.net [23.83.209.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072A817C3
	for <nvdimm@lists.linux.dev>; Thu, 13 Oct 2022 00:50:39 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 8BD927E1F14;
	Thu, 13 Oct 2022 00:15:21 +0000 (UTC)
Received: from pdx1-sub0-mail-a209.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id F0FEA7E1E9F;
	Thu, 13 Oct 2022 00:15:20 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1665620121; a=rsa-sha256;
	cv=none;
	b=jGt7ZgUZ8l55WkMyTJ/mA7S6hfW7qc8zakB1/VOn6yOtQrBv+/fWAEYdXDVGJEig5TsztF
	yS9waCVEc/FFe9vjqvItp2ykJpsy+E7dRm4yOPXMzEYG5Ar0PO2yQ7tKZ82b+aiiJZzcT9
	DIe1F0/cIyDA3fuTuC8MV2kRR1aD9D0LOkfpId0NtcZNfBvwJE4mEcLQ4A27FdaCxwa+Bc
	YjNIsqWna2pMIBvzkX0KfF/Fl0k0VnROGQx3EOgR15IqfCDB5uRwCkinFryjF/8qgbYUmU
	Vv7XNC5MlVImgO4D2c84Wj1nRGKoE9O3IvxEh0IDkIcmpfWt30gX4LV1qPHjRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1665620121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mccInZid1y2fbzAu18MbsIybiyB6L6BtHqAAVmaf7r0=;
	b=3f9I5s0T1zjqGdQUuuAhrpiOvuxaaYuxgm8Q5bsNAcAjuG1ng0z3xrF8oDSKuMaT2OrC/H
	cuXKhmsBN2qkana+jdAZIidSyYYOvgB9md58Qtfby6wRgjVO79cjYE+y2AKAUKPHy8dfag
	7X73rrXy7Va7UQxHVX0ayXGHTzaMBoAIz3Wy45i2eoV39CiT3fLfnJoV9ToJ1Jc4/zQ/Dl
	JNjee3xonmuwlbZZU0jfpEQ0dF1fa3yWmcBsSwoUl4Fdq5mAzGRJI3gMBzOSZ1dKyEWJ79
	FT8/nDojrJscc3eGIj8t1+kd+0VHnFiNY5KzZXHn5dceq9qwAVQKtAgLo+Ig2Q==
ARC-Authentication-Results: i=1;
	rspamd-7c485dd8cf-5hmpg;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Obese-Tasty: 4bcb6b4029e7c7d3_1665620121315_2962082463
X-MC-Loop-Signature: 1665620121314:70668254
X-MC-Ingress-Time: 1665620121314
Received: from pdx1-sub0-mail-a209.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.116.63.144 (trex/6.7.1);
	Thu, 13 Oct 2022 00:15:21 +0000
Received: from offworld (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a209.dreamhost.com (Postfix) with ESMTPSA id 4Mnqlv3pwsz4f;
	Wed, 12 Oct 2022 17:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1665620120;
	bh=mccInZid1y2fbzAu18MbsIybiyB6L6BtHqAAVmaf7r0=;
	h=Date:From:To:Cc:Subject:Content-Type:Content-Transfer-Encoding;
	b=eWfPeyf+QdnXFJTW9nsrwuASyUxxej9EbufVVkCsAmj/PeBjSoKMAjht+1Jxam0j4
	 PquNq1dmw44BIil2SZct4Sg9eJP+K1G0y/kOX3FjiXQu4RAfbFAK6fhduuYPCs/9xX
	 sUFRi/ZP8tPuLrnqZHZYUVpqdtQZMNEVlIeG8QWYyYxPQreK+2FZtnIOQW0kV3NDJn
	 QrHf1Kmg2U5YS3WIhE9lkoNFwDlEqmHcGQh82/T1cyxe7jWIpxO3LUaXPEu/5kPsKf
	 0C3egXsfL94+KMRGVMBGo9LPVFqNQbDdQoa+8OMWSNQ/JWkywSjEum1nxckSBC0eZV
	 WzePTrVH1fCuA==
Date: Wed, 12 Oct 2022 17:14:51 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
	vishal.l.verma@intel.com, alison.schofield@intel.com,
	Jonathan.Cameron@huawei.com
Subject: [PATCH v3] memregion: Add cpu_cache_invalidate_memregion() interface
Message-ID: <20221013001451.6c6fo6sqzmaonu45@offworld>
References: <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
 <166377429297.430546.18244091321001267098.stgit@djiang5-desk3.ch.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <166377429297.430546.18244091321001267098.stgit@djiang5-desk3.ch.intel.com>
User-Agent: NeoMutt/20220429

With CXL security features, global CPU cache flushing nvdimm requirements
are no longer specific to that subsystem, even beyond the scope of
security_ops. CXL will need such semantics for features not necessarily
limited to persistent memory.

The functionality this is enabling is to be able to instantaneously
secure erase potentially terabytes of memory at once and the kernel
needs to be sure that none of the data from before the erase is still
present in the cache. It is also used when unlocking a memory device
where speculative reads and firmware accesses could have cached poison
=66rom before the device was unlocked.

This capability is typically only used once per-boot (for unlock), or
once per bare metal provisioning event (secure erase), like when handing
off the system to another tenant or decommissioning a device. It may
also be used for dynamic CXL region provisioning.

Users must first call cpu_cache_has_invalidate_memregion() to know whether
this functionality is available on the architecture. Only enable it on
x86-64 via the wbinvd() hammer. Hypervisors are not supported as TDX
guests may trigger a virtualization exception and may need proper handling
to recover. See:

    e2efb6359e62 ("ACPICA: Avoid cache flush inside virtual machines")

Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
Changes from https://lore.kernel.org/all/166377429297.430546.18244091321001=
267098.stgit@djiang5-desk3.ch.intel.com/
None of them are actually interface related, only a return code change and =
some
fixlets found by 0day:
   - use EOPNOTSUPP upon !cpu_cache_has_invalidate_memregion() (Dave)
   - set_memory.c includes memregion.h (0day)
   - memregion includes linux/bug.h (for WARN_ON_ONCE) and make
     cpu_cache_invalidate_memregion() stub static inline . (0day)

  arch/x86/Kconfig             |  1 +
  arch/x86/mm/pat/set_memory.c | 16 ++++++++++++++
  drivers/acpi/nfit/intel.c    | 41 ++++++++++++++++--------------------
  include/linux/memregion.h    | 36 +++++++++++++++++++++++++++++++
  lib/Kconfig                  |  3 +++
  5 files changed, 74 insertions(+), 23 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6d1879ef933a..d970215e7f8b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -69,6 +69,7 @@ config X86
	select ARCH_ENABLE_THP_MIGRATION if X86_64 && TRANSPARENT_HUGEPAGE
	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
	select ARCH_HAS_CACHE_LINE_SIZE
+	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION  if X86_64
	select ARCH_HAS_CURRENT_STACK_POINTER
	select ARCH_HAS_DEBUG_VIRTUAL
	select ARCH_HAS_DEBUG_VM_PGTABLE	if !X86_PAE
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 97342c42dda8..7a0fd2ba512e 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -16,6 +16,7 @@
  #include <linux/pci.h>
  #include <linux/vmalloc.h>
  #include <linux/libnvdimm.h>
+#include <linux/memregion.h>
  #include <linux/vmstat.h>
  #include <linux/kernel.h>
  #include <linux/cc_platform.h>
@@ -330,6 +331,21 @@ void arch_invalidate_pmem(void *addr, size_t size)
  EXPORT_SYMBOL_GPL(arch_invalidate_pmem);
  #endif

+#ifdef CONFIG_ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
+bool cpu_cache_has_invalidate_memregion(void)
+{
+	return !cpu_feature_enabled(X86_FEATURE_HYPERVISOR);
+}
+EXPORT_SYMBOL_GPL(cpu_cache_has_invalidate_memregion);
+
+int cpu_cache_invalidate_memregion(int res_desc)
+{
+	wbinvd_on_all_cpus();
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cpu_cache_invalidate_memregion);
+#endif
+
  static void __cpa_flush_all(void *arg)
  {
	unsigned long cache =3D (unsigned long)arg;
diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index 8dd792a55730..4c66fa5e475b 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -3,6 +3,7 @@
  #include <linux/libnvdimm.h>
  #include <linux/ndctl.h>
  #include <linux/acpi.h>
+#include <linux/memregion.h>
  #include <asm/smp.h>
  #include "intel.h"
  #include "nfit.h"
@@ -190,8 +191,6 @@ static int intel_security_change_key(struct nvdimm *nvd=
imm,
	}
  }

-static void nvdimm_invalidate_cache(void);
-
  static int __maybe_unused intel_security_unlock(struct nvdimm *nvdimm,
		const struct nvdimm_key_data *key_data)
  {
@@ -213,6 +212,9 @@ static int __maybe_unused intel_security_unlock(struct =
nvdimm *nvdimm,
	if (!test_bit(NVDIMM_INTEL_UNLOCK_UNIT, &nfit_mem->dsm_mask))
		return -ENOTTY;

+	if (!cpu_cache_has_invalidate_memregion())
+		return -EOPNOTSUPP;
+
	memcpy(nd_cmd.cmd.passphrase, key_data->data,
			sizeof(nd_cmd.cmd.passphrase));
	rc =3D nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
@@ -228,7 +230,7 @@ static int __maybe_unused intel_security_unlock(struct =
nvdimm *nvdimm,
	}

	/* DIMM unlocked, invalidate all CPU caches before we read it */
-	nvdimm_invalidate_cache();
+	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);

	return 0;
  }
@@ -297,8 +299,11 @@ static int __maybe_unused intel_security_erase(struct =
nvdimm *nvdimm,
	if (!test_bit(cmd, &nfit_mem->dsm_mask))
		return -ENOTTY;

+	if (!cpu_cache_has_invalidate_memregion())
+		return -EOPNOTSUPP;
+
	/* flush all cache before we erase DIMM */
-	nvdimm_invalidate_cache();
+	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
	memcpy(nd_cmd.cmd.passphrase, key->data,
			sizeof(nd_cmd.cmd.passphrase));
	rc =3D nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
@@ -318,7 +323,7 @@ static int __maybe_unused intel_security_erase(struct n=
vdimm *nvdimm,
	}

	/* DIMM erased, invalidate all CPU caches before we read it */
-	nvdimm_invalidate_cache();
+	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
	return 0;
  }

@@ -341,6 +346,9 @@ static int __maybe_unused intel_security_query_overwrit=
e(struct nvdimm *nvdimm)
	if (!test_bit(NVDIMM_INTEL_QUERY_OVERWRITE, &nfit_mem->dsm_mask))
		return -ENOTTY;

+	if (!cpu_cache_has_invalidate_memregion())
+		return -EINVAL;
+
	rc =3D nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
	if (rc < 0)
		return rc;
@@ -355,7 +363,7 @@ static int __maybe_unused intel_security_query_overwrit=
e(struct nvdimm *nvdimm)
	}

	/* flush all cache before we make the nvdimms available */
-	nvdimm_invalidate_cache();
+	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
	return 0;
  }

@@ -380,8 +388,11 @@ static int __maybe_unused intel_security_overwrite(str=
uct nvdimm *nvdimm,
	if (!test_bit(NVDIMM_INTEL_OVERWRITE, &nfit_mem->dsm_mask))
		return -ENOTTY;

+	if (!cpu_cache_has_invalidate_memregion())
+		return -EOPNOTSUPP;
+
	/* flush all cache before we erase DIMM */
-	nvdimm_invalidate_cache();
+	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
	memcpy(nd_cmd.cmd.passphrase, nkey->data,
			sizeof(nd_cmd.cmd.passphrase));
	rc =3D nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
@@ -401,22 +412,6 @@ static int __maybe_unused intel_security_overwrite(str=
uct nvdimm *nvdimm,
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
  static const struct nvdimm_security_ops __intel_security_ops =3D {
	.get_flags =3D intel_security_flags,
	.freeze =3D intel_security_freeze,
diff --git a/include/linux/memregion.h b/include/linux/memregion.h
index c04c4fd2e209..41070e722796 100644
--- a/include/linux/memregion.h
+++ b/include/linux/memregion.h
@@ -1,6 +1,7 @@
  /* SPDX-License-Identifier: GPL-2.0 */
  #ifndef _MEMREGION_H_
  #define _MEMREGION_H_
+#include <linux/bug.h>
  #include <linux/types.h>
  #include <linux/errno.h>

@@ -20,4 +21,39 @@ static inline void memregion_free(int id)
  {
  }
  #endif
+
+/**
+ * cpu_cache_invalidate_memregion - drop any CPU cached data for
+ *     memregions described by @res_desc
+ * @res_desc: one of the IORES_DESC_* types
+ *
+ * Perform cache maintenance after a memory event / operation that
+ * changes the contents of physical memory in a cache-incoherent manner.
+ * For example, device memory technologies like NVDIMM and CXL have
+ * device secure erase, or dynamic region provision features where such
+ * semantics.
+ *
+ * Limit the functionality to architectures that have an efficient way
+ * to writeback and invalidate potentially terabytes of memory at once.
+ * Note that this routine may or may not write back any dirty contents
+ * while performing the invalidation.
+ *
+ * Returns 0 on success or negative error code on a failure to perform
+ * the cache maintenance.
+ */
+#ifdef CONFIG_ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
+int cpu_cache_invalidate_memregion(int res_desc);
+bool cpu_cache_has_invalidate_memregion(void);
+#else
+static inline bool cpu_cache_has_invalidate_memregion(void)
+{
+	return false;
+}
+
+static inline int cpu_cache_invalidate_memregion(int res_desc)
+{
+	WARN_ON_ONCE("CPU cache invalidation required");
+	return -EINVAL;
+}
+#endif
  #endif /* _MEMREGION_H_ */
diff --git a/lib/Kconfig b/lib/Kconfig
index 9bbf8a4b2108..9eb514abcdec 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -672,6 +672,9 @@ config ARCH_HAS_PMEM_API
  config MEMREGION
	bool

+config ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
+	bool
+
  config ARCH_HAS_MEMREMAP_COMPAT_ALIGN
	bool

--
2.37.3
