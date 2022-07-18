Received: from donkey.elm.relay.mailchannels.net (donkey.elm.relay.mailchannels.net [23.83.212.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F2CA46
	for <nvdimm@lists.linux.dev>; Mon, 18 Jul 2022 05:30:51 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 82C83122596;
	Mon, 18 Jul 2022 05:30:44 +0000 (UTC)
Received: from pdx1-sub0-mail-a220.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id DC2C1122467;
	Mon, 18 Jul 2022 05:30:43 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1658122244; a=rsa-sha256;
	cv=none;
	b=FAhL6ZPGK1e2fOwZ01Ni+EpN5qqOhnuoPBeHuz5coKnARC039mrWwKk/qfmpwHCjiyuYlL
	S3CDKK/CZMS38GFIO78oJjudeKSs79YLvQTqk+MYkElffCHIDpHcNDQYauUfAAe/VthM2/
	VYchx2xAbWs3t8E3897KH5Ojm22zpEq95tVV5Rj264Nea4aBJwn78xhxaqn3nih4i/DDF7
	AiTw/WdeKpH1BfrPi8+VCmSpSH2sbI0sfNILwcmUn3gorCA7n3dXRamztnab2rvxGliibo
	a3YVWHdP6f6CNgS1Yjp29rx5b/l/DXiAwZImSuyoiLRQYDck+QZm7apDFOBiFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1658122244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ysrdnv4gsdJ38wTwlp+WPUAiE1WNg4OrORYUkATxBi0=;
	b=6iIhVxsniIROCWt8gFxnAS5ay4cmt8HYBC68Buz0a2aA9IeDfaaQG2KNWljP4qIxbk8mW1
	4WDZdoRFRuqA69FzGUjFJgao9Nxw2XH6IQFWepKbl9/lqDbKNTEdWjNO3vIp3heNWgRWL7
	K4hNfEcMyG+ww+t8pBU9hncXa/YVAQeFwr37sfoBM/LplVng9r7K74TBz4oudXW92D9p7r
	HGrl/BOfEGFWMNemvIsWXbnsOd09x/Fy6gTLbZDUU0pXkZan7wTKp83HYXZbRbrbsSjjYW
	o+i8Rymv4K2dk67dLKdniouOKDsWftJXPuscJsJhwxGR7LloNiimRLswmbZWzw==
ARC-Authentication-Results: i=1;
	rspamd-674ffb986c-8xzmz;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Celery-Bubble: 77d09f483179833c_1658122244279_2660748520
X-MC-Loop-Signature: 1658122244279:4034585512
X-MC-Ingress-Time: 1658122244278
Received: from pdx1-sub0-mail-a220.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.108.161.109 (trex/6.7.1);
	Mon, 18 Jul 2022 05:30:44 +0000
Received: from offworld (unknown [104.36.25.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a220.dreamhost.com (Postfix) with ESMTPSA id 4LmVtB5pyQz4C;
	Sun, 17 Jul 2022 22:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1658122243;
	bh=ysrdnv4gsdJ38wTwlp+WPUAiE1WNg4OrORYUkATxBi0=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=kpHcPE32HA65ELmQA3M5EFyS76/k5jBdMLjQQnzfy7TEG76IlstRvIneyjcr5dfHu
	 Av2l8CYK3RTMEvPSDxrOYKJmBihoagcC/SbGeGK4zN7CqWPENW7RGG6qzR1bM1xu45
	 NXdLEo2J6iGKMdijai3HvIIqke3m/LvI7W+Noz6UP5ZclBeZ6d+R/MEtPGXgix9UeA
	 AkXMfJ1gERbp1w5YSp/aHURlgRSGU4PcQqTxhKb4P0ss11IyQEkKl0ZD/ZBHwUl5fC
	 sTHrJOMnh+U7cA078sqTyoPsMrSHUlvDW2DiZbhCX3LudrJYIsQTIkGBsWW/+hf9Zg
	 YIlM3bGsRDdZA==
Date: Sun, 17 Jul 2022 22:30:39 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
	vishal.l.verma@intel.com, alison.schofield@intel.com,
	Jonathan.Cameron@huawei.com, a.manzanares@samsung.com
Subject: Re: [PATCH RFC 10/15] x86: add an arch helper function to invalidate
 all cache for nvdimm
Message-ID: <20220718053039.5whjdcxynukildlo@offworld>
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
 <165791937063.2491387.15277418618265930924.stgit@djiang5-desk3.ch.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <165791937063.2491387.15277418618265930924.stgit@djiang5-desk3.ch.intel.com>
User-Agent: NeoMutt/20220429

On Fri, 15 Jul 2022, Dave Jiang wrote:

>The original implementation to flush all cache after unlocking the nvdimm
>resides in drivers/acpi/nfit/intel.c. This is a temporary stop gap until
>nvdimm with security operations arrives on other archs. With support CXL
>pmem supporting security operations, specifically "unlock" dimm, the need
>for an arch supported helper function to invalidate all CPU cache for
>nvdimm has arrived. Remove original implementation from acpi/nfit and add
>cross arch support for this operation.
>
>Add CONFIG_ARCH_HAS_NVDIMM_INVAL_CACHE Kconfig and allow x86_64 to opt in
>and provide the support via wbinvd_on_all_cpus() call.

So the 8.2.9.5.5 bits will also need wbinvd - and I guess arm64 will need
its own semantics (iirc there was a flush all call in the past). Cc'ing
Jonathan as well.

Anyway, I think this call should not be defined in any place other than core
kernel headers, and not in pat/nvdimm. I was trying to make it fit in smp.h,
for example, but conviniently we might be able to hijack flush_cache_all()
for our purposes as of course neither x86-64 arm64 uses it :)

And I see this as safe (wrt not adding a big hammer on unaware drivers) as
the 32bit archs that define the call are mostly contained thin their arch/,
and the few in drivers/ are still specific to those archs.

Maybe something like the below.

Thanks,
Davidlohr

------8<----------------------------------------
Subject: [PATCH] arch/x86: define flush_cache_all as global wbinvd

With CXL security features, global CPU cache flushing nvdimm
requirements are no longer specific to that subsystem, even
beyond the scope of security_ops. CXL will need such semantics
for features not necessarily limited to persistent memory.

So use the flush_cache_all() for the wbinvd across all
CPUs on x86. arm64, which is another platform to have CXL
support can also define its own semantics here.

Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
  arch/x86/Kconfig                  |  1 -
  arch/x86/include/asm/cacheflush.h |  5 +++++
  arch/x86/mm/pat/set_memory.c      |  8 --------
  drivers/acpi/nfit/intel.c         | 11 ++++++-----
  drivers/cxl/security.c            |  5 +++--
  include/linux/libnvdimm.h         |  9 ---------
  6 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8dbe89eba639..be0b95e51df6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -83,7 +83,6 @@ config X86
	select ARCH_HAS_MEMBARRIER_SYNC_CORE
	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
	select ARCH_HAS_PMEM_API		if X86_64
-	select ARCH_HAS_NVDIMM_INVAL_CACHE	if X86_64
	select ARCH_HAS_PTE_DEVMAP		if X86_64
	select ARCH_HAS_PTE_SPECIAL
	select ARCH_HAS_UACCESS_FLUSHCACHE	if X86_64
diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index b192d917a6d0..05c79021665d 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -10,4 +10,9 @@

  void clflush_cache_range(void *addr, unsigned int size);

+#define flush_cache_all()		\
+do {					\
+	wbinvd_on_all_cpus();		\
+} while (0)
+
  #endif /* _ASM_X86_CACHEFLUSH_H */
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index e4cd1286deef..1abd5438f126 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -330,14 +330,6 @@ void arch_invalidate_pmem(void *addr, size_t size)
  EXPORT_SYMBOL_GPL(arch_invalidate_pmem);
  #endif

-#ifdef CONFIG_ARCH_HAS_NVDIMM_INVAL_CACHE
-void arch_invalidate_nvdimm_cache(void)
-{
-	wbinvd_on_all_cpus();
-}
-EXPORT_SYMBOL_GPL(arch_invalidate_nvdimm_cache);
-#endif
-
  static void __cpa_flush_all(void *arg)
  {
	unsigned long cache = (unsigned long)arg;
diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index 242d2e9203e9..1b0ecb4d67e6 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -1,6 +1,7 @@
  // SPDX-License-Identifier: GPL-2.0
  /* Copyright(c) 2018 Intel Corporation. All rights reserved. */
  #include <linux/libnvdimm.h>
+#include <linux/cacheflush.h>
  #include <linux/ndctl.h>
  #include <linux/acpi.h>
  #include <asm/smp.h>
@@ -226,7 +227,7 @@ static int __maybe_unused intel_security_unlock(struct nvdimm *nvdimm,
	}

	/* DIMM unlocked, invalidate all CPU caches before we read it */
-	arch_invalidate_nvdimm_cache();
+	flush_cache_all();

	return 0;
  }
@@ -296,7 +297,7 @@ static int __maybe_unused intel_security_erase(struct nvdimm *nvdimm,
		return -ENOTTY;

	/* flush all cache before we erase DIMM */
-	arch_invalidate_nvdimm_cache();
+	flush_cache_all();
	memcpy(nd_cmd.cmd.passphrase, key->data,
			sizeof(nd_cmd.cmd.passphrase));
	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
@@ -316,7 +317,7 @@ static int __maybe_unused intel_security_erase(struct nvdimm *nvdimm,
	}

	/* DIMM erased, invalidate all CPU caches before we read it */
-	arch_invalidate_nvdimm_cache();
+	flush_cache_all();
	return 0;
  }

@@ -353,7 +354,7 @@ static int __maybe_unused intel_security_query_overwrite(struct nvdimm *nvdimm)
	}

	/* flush all cache before we make the nvdimms available */
-	arch_invalidate_nvdimm_cache();
+	flush_cache_all();
	return 0;
  }

@@ -379,7 +380,7 @@ static int __maybe_unused intel_security_overwrite(struct nvdimm *nvdimm,
		return -ENOTTY;

	/* flush all cache before we erase DIMM */
-	arch_invalidate_nvdimm_cache();
+	flush_cache_all();
	memcpy(nd_cmd.cmd.passphrase, nkey->data,
			sizeof(nd_cmd.cmd.passphrase));
	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
index 3dc04b50afaf..e2977872bf2f 100644
--- a/drivers/cxl/security.c
+++ b/drivers/cxl/security.c
@@ -6,6 +6,7 @@
  #include <linux/ndctl.h>
  #include <linux/async.h>
  #include <linux/slab.h>
+#include <linux/cacheflush.h>
  #include "cxlmem.h"
  #include "cxl.h"

@@ -137,7 +138,7 @@ static int cxl_pmem_security_unlock(struct nvdimm *nvdimm,
		return rc;

	/* DIMM unlocked, invalidate all CPU caches before we read it */
-	arch_invalidate_nvdimm_cache();
+	flush_cache_all();
	return 0;
  }

@@ -165,7 +166,7 @@ static int cxl_pmem_security_passphrase_erase(struct nvdimm *nvdimm,
		return rc;

	/* DIMM erased, invalidate all CPU caches before we read it */
-	arch_invalidate_nvdimm_cache();
+	flush_cache_all();
	return 0;
  }

diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 07e4e7572089..0769afb73380 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -309,13 +309,4 @@ static inline void arch_invalidate_pmem(void *addr, size_t size)
  {
  }
  #endif
-
-#ifdef CONFIG_ARCH_HAS_NVDIMM_INVAL_CACHE
-void arch_invalidate_nvdimm_cache(void);
-#else
-static inline void arch_invalidate_nvdimm_cache(void)
-{
-}
-#endif
-
  #endif /* __LIBNVDIMM_H__ */
--
2.36.1
