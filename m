Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA84348C
	for <nvdimm@lists.linux.dev>; Wed,  4 Aug 2021 04:32:40 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="299433063"
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="299433063"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:37 -0700
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="511702690"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:37 -0700
From: ira.weiny@intel.com
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH V7 09/18] x86/pks: Add PKS kernel API
Date: Tue,  3 Aug 2021 21:32:22 -0700
Message-Id: <20210804043231.2655537-10-ira.weiny@intel.com>
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

From: Fenghua Yu <fenghua.yu@intel.com>

PKS allows kernel users to define domains of page mappings which have
additional protections beyond the paging protections.  Violating those
protections creates a fault which by default will oops.

Each kernel user defines a PKS_KEY_* key value which identifies a PKS
domain to be used exclusively by that kernel user.  This API is then
used to control which pages are part of that domain and the current
threads protection of those pages.

4 new functions are added pks_enabled(), pks_mk_noaccess(),
pks_mk_readonly(), and pks_mk_readwrite().  2 new macros are added
PAGE_KERNEL_PKEY(key) and _PAGE_PKEY(pkey).

Update the protection key documentation to cover pkeys on supervisor
pages.  This includes how to reserve a key and set the default
permissions on that key.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Co-developed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---
Change for V7
	Add pks_enabled() to allow users more dynamic choice on PKS use.
	Update documentation for key allocation
	Remove dynamic key allocation, keys will be allocated statically
	now.
	Add expected CPU generation support to documentation
---
 Documentation/core-api/protection-keys.rst | 121 ++++++++++++++++++---
 arch/x86/include/asm/pgtable_types.h       |  12 ++
 arch/x86/mm/pkeys.c                        |  66 +++++++++++
 include/linux/pgtable.h                    |   4 +
 include/linux/pkeys.h                      |  14 +++
 5 files changed, 199 insertions(+), 18 deletions(-)

diff --git a/Documentation/core-api/protection-keys.rst b/Documentation/core-api/protection-keys.rst
index ec575e72d0b2..6420a60666fc 100644
--- a/Documentation/core-api/protection-keys.rst
+++ b/Documentation/core-api/protection-keys.rst
@@ -4,25 +4,30 @@
 Memory Protection Keys
 ======================
 
-Memory Protection Keys for Userspace (PKU aka PKEYs) is a feature
-which is found on Intel's Skylake (and later) "Scalable Processor"
-Server CPUs. It will be available in future non-server Intel parts
-and future AMD processors.
+Memory Protection Keys provide a mechanism for enforcing page-based
+protections, but without requiring modification of the page tables
+when an application changes protection domains.
 
-For anyone wishing to test or use this feature, it is available in
-Amazon's EC2 C5 instances and is known to work there using an Ubuntu
-17.04 image.
+PKeys Userspace (PKU) is a feature which is found on Intel's Skylake "Scalable
+Processor" Server CPUs and later.  And it will be available in future
+non-server Intel parts and future AMD processors.
 
-Memory Protection Keys provides a mechanism for enforcing page-based
-protections, but without requiring modification of the page tables
-when an application changes protection domains.  It works by
-dedicating 4 previously ignored bits in each page table entry to a
-"protection key", giving 16 possible keys.
+Protection Keys for Supervisor pages (PKS) is available in the SDM since May
+2020.
+
+pkeys work by dedicating 4 previously Reserved bits in each page table entry to
+a "protection key", giving 16 possible keys.  User and Supervisor pages are
+treated separately.
+
+Protections for each page are controlled with per-CPU registers for each type
+of page User and Supervisor.  Each of these 32-bit register stores two separate
+bits (Access Disable and Write Disable) for each key.
 
-There is also a new user-accessible register (PKRU) with two separate
-bits (Access Disable and Write Disable) for each key.  Being a CPU
-register, PKRU is inherently thread-local, potentially giving each
-thread a different set of protections from every other thread.
+For Userspace the register is user-accessible (rdpkru/wrpkru).  For
+Supervisor, the register (MSR_IA32_PKRS) is accessible only to the kernel.
+
+Being a CPU register, pkeys are inherently thread-local, potentially giving
+each thread an independent set of protections from every other thread.
 
 There are two new instructions (RDPKRU/WRPKRU) for reading and writing
 to the new register.  The feature is only available in 64-bit mode,
@@ -30,8 +35,11 @@ even though there is theoretically space in the PAE PTEs.  These
 permissions are enforced on data access only and have no effect on
 instruction fetches.
 
-Syscalls
-========
+For kernel space rdmsr/wrmsr are used to access the kernel MSRs.
+
+
+Syscalls for user space keys
+============================
 
 There are 3 system calls which directly interact with pkeys::
 
@@ -98,3 +106,80 @@ with a read()::
 The kernel will send a SIGSEGV in both cases, but si_code will be set
 to SEGV_PKERR when violating protection keys versus SEGV_ACCERR when
 the plain mprotect() permissions are violated.
+
+
+Kernel API for PKS support
+==========================
+
+Similar to user space pkeys, supervisor pkeys allow additional protections to
+be defined for a supervisor mappings.  Unlike user space pkeys, violations of
+these protections result in a a kernel oops.
+
+Supervisor Memory Protection Keys (PKS) is a feature which is found on Intel's
+Sapphire Rapids (and later) "Scalable Processor" Server CPUs.  It will also be
+available in future non-server Intel parts.
+
+Also qemu has some support as well: https://www.qemu.org/2021/04/30/qemu-6-0-0/
+
+Kernel users intending to use PKS support should depend on
+ARCH_HAS_SUPERVISOR_PKEYS, and add their config to ARCH_ENABLE_SUPERVISOR_PKEYS
+to turn on this support within the core.
+
+Users reserve a key value by adding an entry to the enum pks_pkey_consumers and
+defining the initial protections in the consumer_defaults[] array.
+
+For example to configure a key for 'MY_FEATURE' with a default of Write
+Disabled.
+
+::
+
+        enum pks_pkey_consumers
+        {
+	        PKS_KEY_DEFAULT,
+	        PKS_KEY_MY_FEATURE,
+	        PKS_KEY_NR_CONSUMERS
+        }
+
+        ...
+        consumer_defaults[PKS_KEY_DEFAULT]     = 0;
+        consumer_defaults[PKS_KEY_MY_FEATURE]  = PKR_DISABLE_WRITE;
+        ...
+
+The following interface is used to manipulate the 'protection domain' defined
+by a pkey within the kernel.  Setting a pkey value in a supervisor PTE adds
+this additional protection to the page.
+
+::
+
+        #define PAGE_KERNEL_PKEY(pkey)
+        #define _PAGE_KEY(pkey)
+        bool pks_enabled(void);
+        void pks_mk_noaccess(int pkey);
+        void pks_mk_readonly(int pkey);
+        void pks_mk_readwrite(int pkey);
+
+pks_enabled() allows users to know if PKS is configured and available on the
+current running system.
+
+Kernel users must set the pkey in the page table entries for the mappings they
+want to protect.  This can be done with PAGE_KERNEL_PKEY() or _PAGE_KEY().
+
+The pks_mk*() family of calls allow indinvidual threads to change the
+protections for the domain identified by the pkey parameter.  3 states are
+available: pks_mk_noaccess(), pks_mk_readonly(), and pks_mk_readwrite() which
+set the access to none, read, and read/write respectively.
+
+The interface sets (Access Disabled (AD=1)) for all keys not in use.
+
+It should be noted that the underlying WRMSR(MSR_IA32_PKRS) is not serializing
+but still maintains ordering properties similar to WRPKRU.  Thus it is safe to
+immediately use a mapping when the pks_mk*() functions return.
+
+Older versions of the SDM on PKRS may be wrong with regard to this
+serialization.  The text should be the same as that of WRPKRU.  From the WRPKRU
+text:
+
+	WRPKRU will never execute transiently. Memory accesses
+	affected by PKRU register will not execute (even transiently)
+	until all prior executions of WRPKRU have completed execution
+	and updated the PKRU register.
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 40497a9020c6..3f866e730456 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -71,6 +71,12 @@
 			 _PAGE_PKEY_BIT2 | \
 			 _PAGE_PKEY_BIT3)
 
+#ifdef CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS
+#define _PAGE_PKEY(pkey)	(_AT(pteval_t, pkey) << _PAGE_BIT_PKEY_BIT0)
+#else
+#define _PAGE_PKEY(pkey)	(_AT(pteval_t, 0))
+#endif
+
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 #define _PAGE_KNL_ERRATUM_MASK (_PAGE_DIRTY | _PAGE_ACCESSED)
 #else
@@ -226,6 +232,12 @@ enum page_cache_mode {
 #define PAGE_KERNEL_IO		__pgprot_mask(__PAGE_KERNEL_IO)
 #define PAGE_KERNEL_IO_NOCACHE	__pgprot_mask(__PAGE_KERNEL_IO_NOCACHE)
 
+#ifdef CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS
+#define PAGE_KERNEL_PKEY(pkey)	__pgprot_mask(__PAGE_KERNEL | _PAGE_PKEY(pkey))
+#else
+#define PAGE_KERNEL_PKEY(pkey) PAGE_KERNEL
+#endif
+
 #endif	/* __ASSEMBLY__ */
 
 /*         xwr */
diff --git a/arch/x86/mm/pkeys.c b/arch/x86/mm/pkeys.c
index eca01dc8d7ac..146a665d1bf3 100644
--- a/arch/x86/mm/pkeys.c
+++ b/arch/x86/mm/pkeys.c
@@ -3,6 +3,9 @@
  * Intel Memory Protection Keys management
  * Copyright (c) 2015, Intel Corporation.
  */
+#undef pr_fmt
+#define pr_fmt(fmt) "x86/pkeys: " fmt
+
 #include <linux/debugfs.h>		/* debugfs_create_u32()		*/
 #include <linux/mm_types.h>             /* mm_struct, vma, etc...       */
 #include <linux/pkeys.h>                /* PKEY_*                       */
@@ -10,6 +13,7 @@
 
 #include <asm/cpufeature.h>             /* boot_cpu_has, ...            */
 #include <asm/mmu_context.h>            /* vma_pkey()                   */
+#include <asm/pks.h>
 
 int __execute_only_pkey(struct mm_struct *mm)
 {
@@ -301,4 +305,66 @@ void pks_init_task(struct task_struct *task)
 	task->thread.saved_pkrs = pkrs_init_value;
 }
 
+bool pks_enabled(void)
+{
+	return cpu_feature_enabled(X86_FEATURE_PKS);
+}
+
+/*
+ * Do not call this directly, see pks_mk*() below.
+ *
+ * @pkey: Key for the domain to change
+ * @protection: protection bits to be used
+ *
+ * Protection utilizes the same protection bits specified for User pkeys
+ *     PKEY_DISABLE_ACCESS
+ *     PKEY_DISABLE_WRITE
+ *
+ */
+static inline void pks_update_protection(int pkey, unsigned long protection)
+{
+	current->thread.saved_pkrs = update_pkey_val(current->thread.saved_pkrs,
+						     pkey, protection);
+	pkrs_write_current();
+}
+
+/**
+ * pks_mk_noaccess() - Disable all access to the domain
+ * @pkey the pkey for which the access should change.
+ *
+ * Disable all access to the domain specified by pkey.  This is not a global
+ * update and only affects the current running thread.
+ */
+void pks_mk_noaccess(int pkey)
+{
+	pks_update_protection(pkey, PKEY_DISABLE_ACCESS);
+}
+EXPORT_SYMBOL_GPL(pks_mk_noaccess);
+
+/**
+ * pks_mk_readonly() - Make the domain Read only
+ * @pkey the pkey for which the access should change.
+ *
+ * Allow read access to the domain specified by pkey.  This is not a global
+ * update and only affects the current running thread.
+ */
+void pks_mk_readonly(int pkey)
+{
+	pks_update_protection(pkey, PKEY_DISABLE_WRITE);
+}
+EXPORT_SYMBOL_GPL(pks_mk_readonly);
+
+/**
+ * pks_mk_readwrite() - Make the domain Read/Write
+ * @pkey the pkey for which the access should change.
+ *
+ * Allow all access, read and write, to the domain specified by pkey.  This is
+ * not a global update and only affects the current running thread.
+ */
+void pks_mk_readwrite(int pkey)
+{
+	pks_update_protection(pkey, 0);
+}
+EXPORT_SYMBOL_GPL(pks_mk_readwrite);
+
 #endif /* CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index d147480cdefc..eba1a9f9d124 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1526,6 +1526,10 @@ static inline bool arch_has_pfn_modify_check(void)
 # define PAGE_KERNEL_EXEC PAGE_KERNEL
 #endif
 
+#ifndef PAGE_KERNEL_PKEY
+#define PAGE_KERNEL_PKEY(pkey) PAGE_KERNEL
+#endif
+
 /*
  * Page Table Modification bits for pgtbl_mod_mask.
  *
diff --git a/include/linux/pkeys.h b/include/linux/pkeys.h
index 76eb19a37942..b9919ed4d300 100644
--- a/include/linux/pkeys.h
+++ b/include/linux/pkeys.h
@@ -56,11 +56,25 @@ extern u32 pkrs_init_value;
 void pkrs_save_irq(struct pt_regs *regs);
 void pkrs_restore_irq(struct pt_regs *regs);
 
+bool pks_enabled(void);
+void pks_mk_noaccess(int pkey);
+void pks_mk_readonly(int pkey);
+void pks_mk_readwrite(int pkey);
+
 #else /* !CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
 
 static inline void pkrs_save_irq(struct pt_regs *regs) { }
 static inline void pkrs_restore_irq(struct pt_regs *regs) { }
 
+static inline bool pks_enabled(void)
+{
+	return false;
+}
+
+static inline void pks_mk_noaccess(int pkey) {}
+static inline void pks_mk_readonly(int pkey) {}
+static inline void pks_mk_readwrite(int pkey) {}
+
 #endif /* CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
 
 #endif /* _LINUX_PKEYS_H */
-- 
2.28.0.rc0.12.gb6a658bd00c9

