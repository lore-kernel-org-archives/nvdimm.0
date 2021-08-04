Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B442F70
	for <nvdimm@lists.linux.dev>; Wed,  4 Aug 2021 04:32:38 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="299433054"
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="299433054"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:36 -0700
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="511702673"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:36 -0700
From: ira.weiny@intel.com
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Fenghua Yu <fenghua.yu@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Andy Lutomirski <luto@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH V7 05/18] x86/pks: Add PKS setup code
Date: Tue,  3 Aug 2021 21:32:18 -0700
Message-Id: <20210804043231.2655537-6-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
In-Reply-To: <20210804043231.2655537-1-ira.weiny@intel.com>
References: <20210804043231.2655537-1-ira.weiny@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

Protection Keys for Supervisor pages (PKS) enables fast, hardware thread
specific, manipulation of permission restrictions on supervisor page
mappings.  It uses the same mechanism of Protection Keys as those on
User mappings but applies that mechanism to supervisor mappings using a
supervisor specific MSR.

Add setup code and the lowest level of PKS MSR write support.  Pkeys
values are allocated statically via the pks_pkey_consumers enumeration.
create_initial_pkrs_value() builds the initial protection values for
each pkey.  Users who need a default value other than Access Disabled
should update consumer_defaults[].

The PKRS value is cached per-cpu to avoid the overhead of the MSR write
if the value has not changed.

That said, it should be noted that the underlying WRMSR(MSR_IA32_PKRS)
is not serializing but still maintains ordering properties similar to
WRPKRU.  The current SDM section on PKRS needs updating but should be
the same as that of WRPKRU.  So to quote from the WRPKRU text:

	WRPKRU will never execute transiently. Memory accesses affected
	by PKRU register will not execute (even transiently) until all
	prior executions of WRPKRU have completed execution and updated
	the PKRU register.

write_pkrs() contributed by Peter Zijlstra.
create_initial_pkrs_value() contributed by Dave Hansen

setup_pks() is an internal x86 function call.  Introduce asm/pks.h to
declare functions and internal structures such as this.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Co-developed-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Co-developed-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Co-developed-by: "Hansen, Dave" <dave.hansen@intel.com>
Signed-off-by: "Hansen, Dave" <dave.hansen@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes for V7
	Create a dynamic pkrs_initial_value in early init code.
	Clean up comments
	Add comment to macro guard
---
 arch/x86/include/asm/msr-index.h    |  1 +
 arch/x86/include/asm/pkeys_common.h |  4 ++
 arch/x86/include/asm/pks.h          | 15 ++++++
 arch/x86/kernel/cpu/common.c        |  2 +
 arch/x86/mm/pkeys.c                 | 75 +++++++++++++++++++++++++++++
 include/linux/pkeys.h               |  8 +++
 6 files changed, 105 insertions(+)
 create mode 100644 arch/x86/include/asm/pks.h

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index a7c413432b33..c986eb1f36a9 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -767,6 +767,7 @@
 
 #define MSR_IA32_TSC_DEADLINE		0x000006E0
 
+#define MSR_IA32_PKRS			0x000006E1
 
 #define MSR_TSX_FORCE_ABORT		0x0000010F
 
diff --git a/arch/x86/include/asm/pkeys_common.h b/arch/x86/include/asm/pkeys_common.h
index 8a3c6d2e6a8a..079a8be9686b 100644
--- a/arch/x86/include/asm/pkeys_common.h
+++ b/arch/x86/include/asm/pkeys_common.h
@@ -2,14 +2,18 @@
 #ifndef _ASM_X86_PKEYS_COMMON_H
 #define _ASM_X86_PKEYS_COMMON_H
 
+#define PKR_RW_BIT 0x0
 #define PKR_AD_BIT 0x1
 #define PKR_WD_BIT 0x2
 #define PKR_BITS_PER_PKEY 2
 
+#define PKS_NUM_PKEYS 16
+
 #define PKR_PKEY_SHIFT(pkey) (pkey * PKR_BITS_PER_PKEY)
 #define PKR_PKEY_MASK(pkey)  (((1 << PKR_BITS_PER_PKEY) - 1) << PKR_PKEY_SHIFT(pkey))
 
 #define PKR_AD_KEY(pkey)     (PKR_AD_BIT << PKR_PKEY_SHIFT(pkey))
 #define PKR_WD_KEY(pkey)     (PKR_WD_BIT << PKR_PKEY_SHIFT(pkey))
+#define PKR_VALUE(pkey, val) (val << PKR_PKEY_SHIFT(pkey))
 
 #endif /*_ASM_X86_PKEYS_COMMON_H */
diff --git a/arch/x86/include/asm/pks.h b/arch/x86/include/asm/pks.h
new file mode 100644
index 000000000000..5d7067ada8fb
--- /dev/null
+++ b/arch/x86/include/asm/pks.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_PKS_H
+#define _ASM_X86_PKS_H
+
+#ifdef CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS
+
+void setup_pks(void);
+
+#else /* !CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
+
+static inline void setup_pks(void) { }
+
+#endif /* CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
+
+#endif /* _ASM_X86_PKS_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 64b805bd6a54..abb32bd32f53 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -59,6 +59,7 @@
 #include <asm/cpu_device_id.h>
 #include <asm/uv/uv.h>
 #include <asm/sigframe.h>
+#include <asm/pks.h>
 
 #include "cpu.h"
 
@@ -1590,6 +1591,7 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 
 	x86_init_rdrand(c);
 	setup_pku(c);
+	setup_pks();
 
 	/*
 	 * Clear/Set all flags overridden by options, need do it
diff --git a/arch/x86/mm/pkeys.c b/arch/x86/mm/pkeys.c
index 75437aa8fc56..fbffbced81b5 100644
--- a/arch/x86/mm/pkeys.c
+++ b/arch/x86/mm/pkeys.c
@@ -211,3 +211,78 @@ u32 update_pkey_val(u32 pk_reg, int pkey, unsigned int flags)
 
 	return pk_reg;
 }
+
+#ifdef CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS
+
+static DEFINE_PER_CPU(u32, pkrs_cache);
+u32 __read_mostly pkrs_init_value;
+
+/*
+ * write_pkrs() optimizes MSR writes by maintaining a per cpu cache which can
+ * be checked quickly.
+ *
+ * It should also be noted that the underlying WRMSR(MSR_IA32_PKRS) is not
+ * serializing but still maintains ordering properties similar to WRPKRU.
+ * The current SDM section on PKRS needs updating but should be the same as
+ * that of WRPKRU.  So to quote from the WRPKRU text:
+ *
+ *     WRPKRU will never execute transiently. Memory accesses
+ *     affected by PKRU register will not execute (even transiently)
+ *     until all prior executions of WRPKRU have completed execution
+ *     and updated the PKRU register.
+ */
+void write_pkrs(u32 new_pkrs)
+{
+	u32 *pkrs;
+
+	if (!static_cpu_has(X86_FEATURE_PKS))
+		return;
+
+	pkrs = get_cpu_ptr(&pkrs_cache);
+	if (*pkrs != new_pkrs) {
+		*pkrs = new_pkrs;
+		wrmsrl(MSR_IA32_PKRS, new_pkrs);
+	}
+	put_cpu_ptr(pkrs);
+}
+
+/*
+ * Build a default PKRS value from the array specified by consumers
+ */
+static int __init create_initial_pkrs_value(void)
+{
+	/* All users get Access Disabled unless changed below */
+	u8 consumer_defaults[PKS_NUM_PKEYS] = {
+		[0 ... PKS_NUM_PKEYS-1] = PKR_AD_BIT
+	};
+	int i;
+
+	consumer_defaults[PKS_KEY_DEFAULT] = PKR_RW_BIT;
+
+	/* Ensure the number of consumers is less than the number of keys */
+	BUILD_BUG_ON(PKS_KEY_NR_CONSUMERS > PKS_NUM_PKEYS);
+
+	pkrs_init_value = 0;
+
+	/* Fill the defaults for the consumers */
+	for (i = 0; i < PKS_NUM_PKEYS; i++)
+		pkrs_init_value |= PKR_VALUE(i, consumer_defaults[i]);
+
+	return 0;
+}
+early_initcall(create_initial_pkrs_value);
+
+/*
+ * PKS is independent of PKU and either or both may be supported on a CPU.
+ * Configure PKS if the CPU supports the feature.
+ */
+void setup_pks(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_PKS))
+		return;
+
+	write_pkrs(pkrs_init_value);
+	cr4_set_bits(X86_CR4_PKS);
+}
+
+#endif /* CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
diff --git a/include/linux/pkeys.h b/include/linux/pkeys.h
index 6beb26b7151d..580238388f0c 100644
--- a/include/linux/pkeys.h
+++ b/include/linux/pkeys.h
@@ -46,4 +46,12 @@ static inline bool arch_pkeys_enabled(void)
 
 #endif /* ! CONFIG_ARCH_HAS_PKEYS */
 
+#ifdef CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS
+enum pks_pkey_consumers {
+	PKS_KEY_DEFAULT = 0, /* Must be 0 for default PTE values */
+	PKS_KEY_NR_CONSUMERS
+};
+extern u32 pkrs_init_value;
+#endif
+
 #endif /* _LINUX_PKEYS_H */
-- 
2.28.0.rc0.12.gb6a658bd00c9

