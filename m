Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02F63499
	for <nvdimm@lists.linux.dev>; Wed,  4 Aug 2021 04:32:42 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="299433071"
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="299433071"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:38 -0700
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="511702703"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:37 -0700
From: ira.weiny@intel.com
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH V7 12/18] x86/pks: Add PKS fault callbacks
Date: Tue,  3 Aug 2021 21:32:25 -0700
Message-Id: <20210804043231.2655537-13-ira.weiny@intel.com>
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

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Some PKS keys will want special handling on accesses that violate their
permissions. One of these is PMEM which will want to have a mode that
logs the access violation, disables protection, and continues rather
than oops the machine.

Since PKS faults do not provide the actual key that faulted, this
information needs to be recovered by walking the page tables and
extracting it from the leaf entry.

This infrastructure could be used to implement abandoned pkeys, but adds
support in a separate call such that abandoned pkeys are handled more
quickly by skipping the page table walk.

In pkeys.c, define a new api for setting callbacks for individual pkeys.

Co-developed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>

---
Changes for V7:
	New patch
---
 Documentation/core-api/protection-keys.rst | 27 +++++++++++-
 arch/x86/include/asm/pks.h                 |  7 +++
 arch/x86/mm/fault.c                        | 51 ++++++++++++++++++++++
 arch/x86/mm/pkeys.c                        | 13 ++++++
 include/linux/pkeys.h                      |  2 +
 5 files changed, 99 insertions(+), 1 deletion(-)

diff --git a/Documentation/core-api/protection-keys.rst b/Documentation/core-api/protection-keys.rst
index 8cf7eaaed3e5..bbf81b12e67d 100644
--- a/Documentation/core-api/protection-keys.rst
+++ b/Documentation/core-api/protection-keys.rst
@@ -113,7 +113,8 @@ Kernel API for PKS support
 
 Similar to user space pkeys, supervisor pkeys allow additional protections to
 be defined for a supervisor mappings.  Unlike user space pkeys, violations of
-these protections result in a a kernel oops.
+these protections result in a a kernel oops unless a PKS fault handler is
+provided which handles the fault.
 
 Supervisor Memory Protection Keys (PKS) is a feature which is found on Intel's
 Sapphire Rapids (and later) "Scalable Processor" Server CPUs.  It will also be
@@ -145,6 +146,30 @@ Disabled.
         consumer_defaults[PKS_KEY_MY_FEATURE]  = PKR_DISABLE_WRITE;
         ...
 
+
+Users may also provide a fault handler which can handle a fault differently
+than an oops.  Continuing our example from above if 'MY_FEATURE' wanted to
+define a handler they can do so by adding the coresponding entry to the
+pks_key_callbacks array.
+
+::
+
+        #ifdef CONFIG_MY_FEATURE
+        bool my_feature_pks_fault_callback(unsigned long address, bool write)
+        {
+                if (my_feature_fault_is_ok)
+                        return true;
+                return false;
+        }
+        #endif
+
+        static const pks_key_callback pks_key_callbacks[PKS_KEY_NR_CONSUMERS] = {
+                [PKS_KEY_DEFAULT]            = NULL,
+        #ifdef CONFIG_MY_FEATURE
+                [PKS_KEY_PGMAP_PROTECTION]   = my_feature_pks_fault_callback,
+        #endif
+        };
+
 The following interface is used to manipulate the 'protection domain' defined
 by a pkey within the kernel.  Setting a pkey value in a supervisor PTE adds
 this additional protection to the page.
diff --git a/arch/x86/include/asm/pks.h b/arch/x86/include/asm/pks.h
index e28413cc410d..3de5089d379d 100644
--- a/arch/x86/include/asm/pks.h
+++ b/arch/x86/include/asm/pks.h
@@ -23,6 +23,7 @@ static inline struct extended_pt_regs *extended_pt_regs(struct pt_regs *regs)
 
 void show_extended_regs_oops(struct pt_regs *regs, unsigned long error_code);
 int handle_abandoned_pks_value(struct pt_regs *regs);
+bool handle_pks_key_callback(unsigned long address, bool write, u16 key);
 
 #else /* !CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
 
@@ -36,6 +37,12 @@ static inline int handle_abandoned_pks_value(struct pt_regs *regs)
 {
 	return 0;
 }
+static inline bool handle_pks_key_fault(struct pt_regs *regs,
+					unsigned long hw_error_code,
+					unsigned long address)
+{
+	return false;
+}
 
 #endif /* CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 3780ed0f9597..7a8c807006c7 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1134,6 +1134,54 @@ bool fault_in_kernel_space(unsigned long address)
 	return address >= TASK_SIZE_MAX;
 }
 
+#ifdef CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS
+bool handle_pks_key_fault(struct pt_regs *regs, unsigned long hw_error_code,
+			  unsigned long address)
+{
+	bool write = (hw_error_code & X86_PF_WRITE);
+	pgd_t pgd;
+	p4d_t p4d;
+	pud_t pud;
+	pmd_t pmd;
+	pte_t pte;
+
+	pgd = READ_ONCE(*(init_mm.pgd + pgd_index(address)));
+	if (!pgd_present(pgd))
+		return false;
+
+	p4d = READ_ONCE(*p4d_offset(&pgd, address));
+	if (!p4d_present(p4d))
+		return false;
+
+	if (p4d_large(p4d))
+		return handle_pks_key_callback(address, write,
+					       pte_flags_pkey(p4d_val(p4d)));
+
+	pud = READ_ONCE(*pud_offset(&p4d, address));
+	if (!pud_present(pud))
+		return false;
+
+	if (pud_large(pud))
+		return handle_pks_key_callback(address, write,
+					      pte_flags_pkey(pud_val(pud)));
+
+	pmd = READ_ONCE(*pmd_offset(&pud, address));
+	if (!pmd_present(pmd))
+		return false;
+
+	if (pmd_large(pmd))
+		return handle_pks_key_callback(address, write,
+					      pte_flags_pkey(pmd_val(pmd)));
+
+	pte = READ_ONCE(*pte_offset_kernel(&pmd, address));
+	if (!pte_present(pte))
+		return false;
+
+	return handle_pks_key_callback(address, write,
+				      pte_flags_pkey(pte_val(pte)));
+}
+#endif
+
 /*
  * Called for all faults where 'address' is part of the kernel address
  * space.  Might get called for faults that originate from *code* that
@@ -1164,6 +1212,9 @@ do_kern_addr_fault(struct pt_regs *regs, unsigned long hw_error_code,
 
 		if (handle_abandoned_pks_value(regs))
 			return;
+
+		if (handle_pks_key_fault(regs, hw_error_code, address))
+			return;
 	}
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/mm/pkeys.c b/arch/x86/mm/pkeys.c
index c7358662ec07..f0166725a128 100644
--- a/arch/x86/mm/pkeys.c
+++ b/arch/x86/mm/pkeys.c
@@ -241,6 +241,19 @@ int handle_abandoned_pks_value(struct pt_regs *regs)
 	return (ept_regs->thread_pkrs != old);
 }
 
+static const pks_key_callback pks_key_callbacks[PKS_KEY_NR_CONSUMERS] = { 0 };
+
+bool handle_pks_key_callback(unsigned long address, bool write, u16 key)
+{
+	if (key > PKS_KEY_NR_CONSUMERS)
+		return false;
+
+	if (pks_key_callbacks[key])
+		return pks_key_callbacks[key](address, write);
+
+	return false;
+}
+
 /*
  * write_pkrs() optimizes MSR writes by maintaining a per cpu cache which can
  * be checked quickly.
diff --git a/include/linux/pkeys.h b/include/linux/pkeys.h
index 4d22ccd971fc..549fa01d7da3 100644
--- a/include/linux/pkeys.h
+++ b/include/linux/pkeys.h
@@ -62,6 +62,8 @@ void pks_mk_readonly(int pkey);
 void pks_mk_readwrite(int pkey);
 void pks_abandon_protections(int pkey);
 
+typedef bool (*pks_key_callback)(unsigned long address, bool write);
+
 #else /* !CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
 
 static inline void pkrs_save_irq(struct pt_regs *regs) { }
-- 
2.28.0.rc0.12.gb6a658bd00c9

