Return-Path: <SRS0=ES6B=AZ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C8FC433FE
	for <linux-nvdimm@archiver.kernel.org>; Tue, 14 Jul 2020 07:04:08 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E1603221F7
	for <linux-nvdimm@archiver.kernel.org>; Tue, 14 Jul 2020 07:04:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1603221F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 9E2F210056B04;
	Tue, 14 Jul 2020 00:04:07 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=192.55.52.120; helo=mga04.intel.com; envelope-from=ira.weiny@intel.com; receiver=<UNKNOWN> 
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id EF71710056AF5
	for <linux-nvdimm@lists.01.org>; Tue, 14 Jul 2020 00:04:05 -0700 (PDT)
IronPort-SDR: 7tTwUmM99KpmV/RNyn1FQwRWuBcrAz875Dj6nc/czvR9HJL8Gr5VORAdxS5wJaY1cGYHFKFLg/
 xROpinZGIXxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="146304275"
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800";
   d="scan'208";a="146304275"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 00:04:05 -0700
IronPort-SDR: zCgGXEqBmYqnjzD5g1tvTYbJG8Sugsaqt04O3q+7B6aA9Rho2GxTyEUJZYn+eiJhFS/hLT1lYm
 76SjNBY0o0KQ==
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800";
   d="scan'208";a="307752705"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 00:04:05 -0700
From: ira.weiny@intel.com
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [RFC PATCH 03/15] x86/pks: Enable Protection Keys Supervisor (PKS)
Date: Tue, 14 Jul 2020 00:02:08 -0700
Message-Id: <20200714070220.3500839-4-ira.weiny@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200714070220.3500839-1-ira.weiny@intel.com>
References: <20200714070220.3500839-1-ira.weiny@intel.com>
MIME-Version: 1.0
Message-ID-Hash: CPR35JPCPZX7SZCHVXDCDYOS2YO4IAUC
X-Message-ID-Hash: CPR35JPCPZX7SZCHVXDCDYOS2YO4IAUC
X-MailFrom: ira.weiny@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Fenghua Yu <fenghua.yu@intel.com>, x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/CPR35JPCPZX7SZCHVXDCDYOS2YO4IAUC/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Fenghua Yu <fenghua.yu@intel.com>

Protection Keys for Supervisor pages (PKS) enables fast, hardware thread
specific, manipulation of permission restrictions on supervisor page
mappings.  It uses the same mechanism of Protection Keys as those on
User mappings but applies that mechanism to supervisor mappings using a
supervisor specific MSR.

Kernel users can thus defines 'domains' of page mappings which have an
extra level of protection beyond those specified in the supervisor page
table entries.

Define ARCH_HAS_SUPERVISOR_PKEYS to distinguish this functionality from
the existing ARCH_HAS_PKEYS and then enable PKS when configured and
indicated by the CPU instance.  While not strictly necessary in this
patch, ARCH_HAS_SUPERVISOR_PKEYS separates this functionality through
the patch series so it is introduced here.

Co-developed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/Kconfig                            |  1 +
 arch/x86/include/asm/cpufeatures.h          |  1 +
 arch/x86/include/uapi/asm/processor-flags.h |  2 ++
 arch/x86/kernel/cpu/common.c                | 15 +++++++++++++++
 mm/Kconfig                                  |  2 ++
 5 files changed, 21 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 883da0abf779..c3ecbed2cfa0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1872,6 +1872,7 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
 	depends on X86_64 && (CPU_SUP_INTEL || CPU_SUP_AMD)
 	select ARCH_USES_HIGH_VMA_FLAGS
 	select ARCH_HAS_PKEYS
+	select ARCH_HAS_SUPERVISOR_PKEYS
 	help
 	  Memory Protection Keys provides a mechanism for enforcing
 	  page-based protections, but without requiring modification of the
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 02dabc9e77b0..a832ed8820c0 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -351,6 +351,7 @@
 #define X86_FEATURE_CLDEMOTE		(16*32+25) /* CLDEMOTE instruction */
 #define X86_FEATURE_MOVDIRI		(16*32+27) /* MOVDIRI instruction */
 #define X86_FEATURE_MOVDIR64B		(16*32+28) /* MOVDIR64B instruction */
+#define X86_FEATURE_PKS			(16*32+31) /* Protection Keys for Supervisor pages */
 
 /* AMD-defined CPU features, CPUID level 0x80000007 (EBX), word 17 */
 #define X86_FEATURE_OVERFLOW_RECOV	(17*32+ 0) /* MCA overflow recovery support */
diff --git a/arch/x86/include/uapi/asm/processor-flags.h b/arch/x86/include/uapi/asm/processor-flags.h
index bcba3c643e63..191c574b2390 100644
--- a/arch/x86/include/uapi/asm/processor-flags.h
+++ b/arch/x86/include/uapi/asm/processor-flags.h
@@ -130,6 +130,8 @@
 #define X86_CR4_SMAP		_BITUL(X86_CR4_SMAP_BIT)
 #define X86_CR4_PKE_BIT		22 /* enable Protection Keys support */
 #define X86_CR4_PKE		_BITUL(X86_CR4_PKE_BIT)
+#define X86_CR4_PKS_BIT		24 /* enable Protection Keys for Supervisor */
+#define X86_CR4_PKS		_BITUL(X86_CR4_PKS_BIT)
 
 /*
  * x86-64 Task Priority Register, CR8
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 95c090a45b4b..f34bcefeda42 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1430,6 +1430,20 @@ static void validate_apic_and_package_id(struct cpuinfo_x86 *c)
 #endif
 }
 
+/*
+ * PKS is independent of PKU and either or both may be supported on a CPU.
+ * Configure PKS if the cpu supports the feature.
+ */
+static void setup_pks(void)
+{
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_SUPERVISOR_PKEYS))
+		return;
+	if (!cpu_feature_enabled(X86_FEATURE_PKS))
+		return;
+
+	cr4_set_bits(X86_CR4_PKS);
+}
+
 /*
  * This does the hard work of actually picking apart the CPU stuff...
  */
@@ -1521,6 +1535,7 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 
 	x86_init_rdrand(c);
 	setup_pku(c);
+	setup_pks();
 
 	/*
 	 * Clear/Set all flags overridden by options, need do it
diff --git a/mm/Kconfig b/mm/Kconfig
index f2104cc0d35c..e541d2c0dcac 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -826,6 +826,8 @@ config ARCH_USES_HIGH_VMA_FLAGS
 	bool
 config ARCH_HAS_PKEYS
 	bool
+config ARCH_HAS_SUPERVISOR_PKEYS
+	bool
 
 config PERCPU_STATS
 	bool "Collect percpu memory statistics"
-- 
2.25.1
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
