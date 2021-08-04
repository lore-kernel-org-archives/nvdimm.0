Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843833492
	for <nvdimm@lists.linux.dev>; Wed,  4 Aug 2021 04:32:41 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="299433065"
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="299433065"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:37 -0700
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="511702693"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:37 -0700
From: ira.weiny@intel.com
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH V7 10/18] x86/pks: Introduce pks_abandon_protections()
Date: Tue,  3 Aug 2021 21:32:23 -0700
Message-Id: <20210804043231.2655537-11-ira.weiny@intel.com>
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

Unanticipated access to PMEM by otherwise working kernel code would be
very disruptive to otherwise working systems.  Such access could be
through valid uses such as kmap().  In this use case PMEM protections
will require the ability to abandon all protections of a pkey on all
threads system wide.

Introduce pks_abandon_protections() to allow a user to mask off
protection values.  This will filter through all the threads of the
system as they are scheduled in and in the immediate case override the
value should running threads PKS fault.

Update pkrs_write_current(), pks_init_task(), and
pkrs_{save|restore}_irq() to account for pkrs_pkey_allowed_mask.

Add handle_abandoned_pks_value() to adjust any already running threads
which may fault on an abandoned pkey.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes for V7
	New patch
	Significant internal review from Dan Williams and Rick Edgecombe
---
 Documentation/core-api/protection-keys.rst |  7 +++-
 arch/x86/entry/common.c                    |  6 ++-
 arch/x86/include/asm/pks.h                 |  5 +++
 arch/x86/mm/fault.c                        | 24 ++++++-----
 arch/x86/mm/pkeys.c                        | 49 ++++++++++++++++++++++
 include/linux/pkeys.h                      |  2 +
 6 files changed, 80 insertions(+), 13 deletions(-)

diff --git a/Documentation/core-api/protection-keys.rst b/Documentation/core-api/protection-keys.rst
index 6420a60666fc..202088634fa3 100644
--- a/Documentation/core-api/protection-keys.rst
+++ b/Documentation/core-api/protection-keys.rst
@@ -157,6 +157,7 @@ this additional protection to the page.
         void pks_mk_noaccess(int pkey);
         void pks_mk_readonly(int pkey);
         void pks_mk_readwrite(int pkey);
+        void pks_abandon_protections(int pkey);
 
 pks_enabled() allows users to know if PKS is configured and available on the
 current running system.
@@ -169,7 +170,11 @@ protections for the domain identified by the pkey parameter.  3 states are
 available: pks_mk_noaccess(), pks_mk_readonly(), and pks_mk_readwrite() which
 set the access to none, read, and read/write respectively.
 
-The interface sets (Access Disabled (AD=1)) for all keys not in use.
+The interface sets Access Disabled for all keys not in use.  The
+pks_abandon_protections() call reduces the protections for the specified key to
+be fully accessible thus abandoning the protections of the key.  There is no
+way to reverse this.  As such pks_abandon_protections() is intended to provide
+a 'relief valve' if the PKS protections should prove too restrictive.
 
 It should be noted that the underlying WRMSR(MSR_IA32_PKRS) is not serializing
 but still maintains ordering properties similar to WRPKRU.  Thus it is safe to
diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index a0d1d5519dba..717091910ebc 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -37,6 +37,8 @@
 #include <asm/irq_stack.h>
 #include <asm/pks.h>
 
+extern u32 pkrs_pkey_allowed_mask;
+
 #ifdef CONFIG_X86_64
 
 static __always_inline bool do_syscall_x64(struct pt_regs *regs, int nr)
@@ -287,7 +289,7 @@ void pkrs_save_irq(struct pt_regs *regs)
 
 	ept_regs = extended_pt_regs(regs);
 	ept_regs->thread_pkrs = current->thread.saved_pkrs;
-	write_pkrs(pkrs_init_value);
+	write_pkrs(pkrs_init_value & pkrs_pkey_allowed_mask);
 }
 
 void pkrs_restore_irq(struct pt_regs *regs)
@@ -298,8 +300,8 @@ void pkrs_restore_irq(struct pt_regs *regs)
 		return;
 
 	ept_regs = extended_pt_regs(regs);
-	write_pkrs(ept_regs->thread_pkrs);
 	current->thread.saved_pkrs = ept_regs->thread_pkrs;
+	pkrs_write_current();
 }
 
 #endif /* CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
diff --git a/arch/x86/include/asm/pks.h b/arch/x86/include/asm/pks.h
index 76960ec71b4b..ed293ef4509e 100644
--- a/arch/x86/include/asm/pks.h
+++ b/arch/x86/include/asm/pks.h
@@ -22,6 +22,7 @@ static inline struct extended_pt_regs *extended_pt_regs(struct pt_regs *regs)
 }
 
 void show_extended_regs_oops(struct pt_regs *regs, unsigned long error_code);
+int handle_abandoned_pks_value(struct pt_regs *regs);
 
 #else /* !CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
 
@@ -31,6 +32,10 @@ static inline void pks_init_task(struct task_struct *task) { }
 static inline void write_pkrs(u32 new_pkrs) { }
 static inline void show_extended_regs_oops(struct pt_regs *regs,
 					   unsigned long error_code) { }
+static inline int handle_abandoned_pks_value(struct pt_regs *regs)
+{
+	return 0;
+}
 
 #endif /* CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index a4ce7cef0260..bf3353d8e011 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1143,16 +1143,20 @@ static void
 do_kern_addr_fault(struct pt_regs *regs, unsigned long hw_error_code,
 		   unsigned long address)
 {
-	/*
-	 * X86_PF_PK (Protection key exceptions) may occur on kernel addresses
-	 * when PKS (PKeys Supervisor) is enabled.
-	 *
-	 * However, if PKS is not enabled WARN if this exception is seen
-	 * because there are no user pages in the kernel portion of the address
-	 * space.
-	 */
-	WARN_ON_ONCE(!cpu_feature_enabled(X86_FEATURE_PKS) &&
-		     (hw_error_code & X86_PF_PK));
+	if (hw_error_code & X86_PF_PK) {
+		/*
+		 * X86_PF_PK (Protection key exceptions) may occur on kernel
+		 * addresses when PKS (PKeys Supervisor) is enabled.
+		 *
+		 * However, if PKS is not enabled WARN if this exception is
+		 * seen because there are no user pages in the kernel portion
+		 * of the address space.
+		 */
+		WARN_ON_ONCE(!cpu_feature_enabled(X86_FEATURE_PKS));
+
+		if (handle_abandoned_pks_value(regs))
+			return;
+	}
 
 #ifdef CONFIG_X86_32
 	/*
diff --git a/arch/x86/mm/pkeys.c b/arch/x86/mm/pkeys.c
index 146a665d1bf3..56d37840186b 100644
--- a/arch/x86/mm/pkeys.c
+++ b/arch/x86/mm/pkeys.c
@@ -221,6 +221,26 @@ u32 update_pkey_val(u32 pk_reg, int pkey, unsigned int flags)
 static DEFINE_PER_CPU(u32, pkrs_cache);
 u32 __read_mostly pkrs_init_value;
 
+/*
+ * Define a mask of pkeys which are allowed, ie have not been abandoned.
+ * Default is all keys are allowed.
+ */
+#define PKRS_ALLOWED_MASK_DEFAULT 0xffffffff
+u32 __read_mostly pkrs_pkey_allowed_mask;
+
+int handle_abandoned_pks_value(struct pt_regs *regs)
+{
+	struct extended_pt_regs *ept_regs;
+	u32 old;
+
+	ept_regs = extended_pt_regs(regs);
+	old = ept_regs->thread_pkrs;
+	ept_regs->thread_pkrs &= pkrs_pkey_allowed_mask;
+
+	/* If something changed retry the fault */
+	return (ept_regs->thread_pkrs != old);
+}
+
 /*
  * write_pkrs() optimizes MSR writes by maintaining a per cpu cache which can
  * be checked quickly.
@@ -267,6 +287,7 @@ static int __init create_initial_pkrs_value(void)
 	BUILD_BUG_ON(PKS_KEY_NR_CONSUMERS > PKS_NUM_PKEYS);
 
 	pkrs_init_value = 0;
+	pkrs_pkey_allowed_mask = PKRS_ALLOWED_MASK_DEFAULT;
 
 	/* Fill the defaults for the consumers */
 	for (i = 0; i < PKS_NUM_PKEYS; i++)
@@ -297,12 +318,14 @@ void setup_pks(void)
  */
 void pkrs_write_current(void)
 {
+	current->thread.saved_pkrs &= pkrs_pkey_allowed_mask;
 	write_pkrs(current->thread.saved_pkrs);
 }
 
 void pks_init_task(struct task_struct *task)
 {
 	task->thread.saved_pkrs = pkrs_init_value;
+	task->thread.saved_pkrs &= pkrs_pkey_allowed_mask;
 }
 
 bool pks_enabled(void)
@@ -367,4 +390,30 @@ void pks_mk_readwrite(int pkey)
 }
 EXPORT_SYMBOL_GPL(pks_mk_readwrite);
 
+/**
+ * pks_abandon_protections() - Force readwrite (no protections) for the
+ *                             specified pkey
+ * @pkey The pkey to force
+ *
+ * Force the value of the pkey to readwrite (no protections) thus abandoning
+ * protections for this key.  This is a permanent change and has no
+ * coresponding reversal function.
+ *
+ * This also updates the current running thread.
+ */
+void pks_abandon_protections(int pkey)
+{
+	u32 old_mask, new_mask;
+
+	do {
+		old_mask = READ_ONCE(pkrs_pkey_allowed_mask);
+		new_mask = update_pkey_val(old_mask, pkey, 0);
+	} while (unlikely(
+		 cmpxchg(&pkrs_pkey_allowed_mask, old_mask, new_mask) != old_mask));
+
+	/* Update the local thread as well. */
+	pks_update_protection(pkey, 0);
+}
+EXPORT_SYMBOL_GPL(pks_abandon_protections);
+
 #endif /* CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
diff --git a/include/linux/pkeys.h b/include/linux/pkeys.h
index b9919ed4d300..4d22ccd971fc 100644
--- a/include/linux/pkeys.h
+++ b/include/linux/pkeys.h
@@ -60,6 +60,7 @@ bool pks_enabled(void);
 void pks_mk_noaccess(int pkey);
 void pks_mk_readonly(int pkey);
 void pks_mk_readwrite(int pkey);
+void pks_abandon_protections(int pkey);
 
 #else /* !CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
 
@@ -74,6 +75,7 @@ static inline bool pks_enabled(void)
 static inline void pks_mk_noaccess(int pkey) {}
 static inline void pks_mk_readonly(int pkey) {}
 static inline void pks_mk_readwrite(int pkey) {}
+static inline void pks_abandon_protections(int pkey) {}
 
 #endif /* CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
 
-- 
2.28.0.rc0.12.gb6a658bd00c9

