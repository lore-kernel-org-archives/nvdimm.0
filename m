Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B17349F
	for <nvdimm@lists.linux.dev>; Wed,  4 Aug 2021 04:32:43 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="299433075"
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="299433075"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:38 -0700
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="511702711"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:38 -0700
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
Subject: [PATCH V7 14/18] memremap_pages: Add memremap.pks_fault_mode
Date: Tue,  3 Aug 2021 21:32:27 -0700
Message-Id: <20210804043231.2655537-15-ira.weiny@intel.com>
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

Some systems may be using pmem in unanticipated ways.  As such it is
possible a code path may violation the restrictions of the PMEM PKS
protections.

In order to provide a more seamless integration of the PMEM PKS feature
provide a pks_fault_mode that allows for a relaxed mode should a
previously working feature start to fault on PKS protected PMEM.

2 modes are available:

	'relaxed' (default) -- WARN_ONCE, abandon the protections, and
	continuing to operate.

	'strict' -- BUG_ON/or fault indicating the error.  This is the
	most protective of the PMEM memory but may be undesirable in
	some configurations.

NOTE: There was some debate about if a 3rd mode called 'silent' should
be available.  'silent' would be the same as 'relaxed' but not print any
output.  While 'silent' is nice for admins to reduce console/log output
it would result in less motivation to fix invalid access to the
protected pmem pages.  Therefore, 'silent' is left out.

In addition, kmap() is known to not work with this protection.  Provide
a new call; pgmap_protection_flag_invalid().  This gives better
debugging for missed kmap() users.  This call also respects the
pks_fault_mode settings.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes for V7
	Leverage Rick Edgecombe's fault callback infrastructure to relax invalid
		uses and prevent crashes
	From Dan Williams
		Use sysfs_* calls for parameter
		Make pgmap_disable_protection inline
		Remove pfn from warn output
	Remove silent parameter option
---
 .../admin-guide/kernel-parameters.txt         | 14 +++
 arch/x86/mm/pkeys.c                           |  8 +-
 include/linux/mm.h                            | 26 ++++++
 mm/memremap.c                                 | 85 +++++++++++++++++++
 4 files changed, 132 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index bdb22006f713..7902fce7f1da 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4081,6 +4081,20 @@
 	pirq=		[SMP,APIC] Manual mp-table setup
 			See Documentation/x86/i386/IO-APIC.rst.
 
+	memremap.pks_fault_mode=	[X86] Control the behavior of page map
+			protection violations.  Violations may not be an actual
+			use of the memory but simply an attempt to map it in an
+			incompatible way.
+			(depends on CONFIG_DEVMAP_ACCESS_PROTECTION
+
+			Format: { relaxed | strict }
+
+			relaxed - Print a warning, disable the protection and
+				  continue execution.
+			strict - Stop kernel execution via BUG_ON or fault
+
+			default: relaxed
+
 	plip=		[PPT,NET] Parallel port network link
 			Format: { parport<nr> | timid | 0 }
 			See also Documentation/admin-guide/parport.rst.
diff --git a/arch/x86/mm/pkeys.c b/arch/x86/mm/pkeys.c
index cdebc2018888..201004586c2b 100644
--- a/arch/x86/mm/pkeys.c
+++ b/arch/x86/mm/pkeys.c
@@ -9,6 +9,7 @@
 #include <linux/debugfs.h>		/* debugfs_create_u32()		*/
 #include <linux/mm_types.h>             /* mm_struct, vma, etc...       */
 #include <linux/pkeys.h>                /* PKEY_*                       */
+#include <linux/mm.h>                   /* fault callback               */
 #include <uapi/asm-generic/mman-common.h>
 
 #include <asm/cpufeature.h>             /* boot_cpu_has, ...            */
@@ -241,7 +242,12 @@ int handle_abandoned_pks_value(struct pt_regs *regs)
 	return (ept_regs->thread_pkrs != old);
 }
 
-static const pks_key_callback pks_key_callbacks[PKS_KEY_NR_CONSUMERS] = { 0 };
+static const pks_key_callback pks_key_callbacks[PKS_KEY_NR_CONSUMERS] = {
+	[PKS_KEY_DEFAULT]            = NULL,
+#ifdef CONFIG_DEVMAP_ACCESS_PROTECTION
+	[PKS_KEY_PGMAP_PROTECTION]   = pgmap_pks_fault_callback,
+#endif
+};
 
 bool handle_pks_key_callback(unsigned long address, bool write, u16 key)
 {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index d3c1a3ecca87..c13c7af7cad3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1216,6 +1216,7 @@ static inline bool devmap_protected(struct page *page)
 	return false;
 }
 
+void __pgmap_protection_flag_invalid(struct dev_pagemap *pgmap);
 void __pgmap_mk_readwrite(struct dev_pagemap *pgmap);
 void __pgmap_mk_noaccess(struct dev_pagemap *pgmap);
 
@@ -1232,6 +1233,27 @@ static inline bool pgmap_check_pgmap_prot(struct page *page)
 	return true;
 }
 
+/*
+ * pgmap_protection_flag_invalid - Check and flag an invalid use of a pgmap
+ *                                 protected page
+ *
+ * There are code paths which are known to not be compatible with pgmap
+ * protections.  pgmap_protection_flag_invalid() is provided as a 'relief
+ * valve' to be used in those functions which are known to be incompatible.
+ *
+ * Thus an invalid code path can be flag more precisely what code contains the
+ * bug vs just flagging a fault.  Like the fault handler code this abandons the
+ * use of the PKS key and optionally allows the calling code path to continue
+ * based on the configuration of the memremap.pks_fault_mode command line
+ * (and/or sysfs) option.
+ */
+static inline void pgmap_protection_flag_invalid(struct page *page)
+{
+	if (!pgmap_check_pgmap_prot(page))
+		return;
+	__pgmap_protection_flag_invalid(page->pgmap);
+}
+
 static inline void pgmap_mk_readwrite(struct page *page)
 {
 	if (!pgmap_check_pgmap_prot(page))
@@ -1247,10 +1269,14 @@ static inline void pgmap_mk_noaccess(struct page *page)
 
 bool pgmap_protection_enabled(void);
 
+bool pgmap_pks_fault_callback(unsigned long address, bool write);
+
 #else
 
 static inline void __pgmap_mk_readwrite(struct dev_pagemap *pgmap) { }
 static inline void __pgmap_mk_noaccess(struct dev_pagemap *pgmap) { }
+
+static inline void pgmap_protection_flag_invalid(struct page *page) { }
 static inline void pgmap_mk_readwrite(struct page *page) { }
 static inline void pgmap_mk_noaccess(struct page *page) { }
 static inline bool pgmap_protection_enabled(void)
diff --git a/mm/memremap.c b/mm/memremap.c
index a05de8714916..930b360bad86 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -95,6 +95,91 @@ static void devmap_protection_disable(void)
 	static_branch_dec(&dev_pgmap_protection_static_key);
 }
 
+/*
+ * Ignore the checkpatch warning because the typedef allows
+ * param_check_pks_fault_modes to automatically check the passed value.
+ */
+typedef enum {
+	PKS_MODE_STRICT  = 0,
+	PKS_MODE_RELAXED = 1,
+} pks_fault_modes;
+
+pks_fault_modes pks_fault_mode = PKS_MODE_RELAXED;
+
+static int param_set_pks_fault_mode(const char *val, const struct kernel_param *kp)
+{
+	int ret = -EINVAL;
+
+	if (!sysfs_streq(val, "relaxed")) {
+		pks_fault_mode = PKS_MODE_RELAXED;
+		ret = 0;
+	} else if (!sysfs_streq(val, "strict")) {
+		pks_fault_mode = PKS_MODE_STRICT;
+		ret = 0;
+	}
+
+	return ret;
+}
+
+static int param_get_pks_fault_mode(char *buffer, const struct kernel_param *kp)
+{
+	int ret = 0;
+
+	switch (pks_fault_mode) {
+	case PKS_MODE_STRICT:
+		ret = sysfs_emit(buffer, "strict\n");
+		break;
+	case PKS_MODE_RELAXED:
+		ret = sysfs_emit(buffer, "relaxed\n");
+		break;
+	default:
+		ret = sysfs_emit(buffer, "<unknown>\n");
+		break;
+	}
+
+	return ret;
+}
+
+static const struct kernel_param_ops param_ops_pks_fault_modes = {
+	.set = param_set_pks_fault_mode,
+	.get = param_get_pks_fault_mode,
+};
+
+#define param_check_pks_fault_modes(name, p) \
+	__param_check(name, p, pks_fault_modes)
+module_param(pks_fault_mode, pks_fault_modes, 0644);
+
+static void pgmap_abandon_protection(void)
+{
+	static bool protections_abandoned = false;
+
+	if (!protections_abandoned) {
+		protections_abandoned = true;
+		pks_abandon_protections(PKS_KEY_PGMAP_PROTECTION);
+	}
+}
+
+void __pgmap_protection_flag_invalid(struct dev_pagemap *pgmap)
+{
+	BUG_ON(pks_fault_mode == PKS_MODE_STRICT);
+
+	WARN_ONCE(1, "Page map protection disabled");
+	pgmap_abandon_protection();
+}
+EXPORT_SYMBOL_GPL(__pgmap_protection_flag_invalid);
+
+bool pgmap_pks_fault_callback(unsigned long address, bool write)
+{
+	/* In strict mode just let the fault handler oops */
+	if (pks_fault_mode == PKS_MODE_STRICT)
+		return false;
+
+	WARN_ONCE(1, "Page map protection disabled");
+	pgmap_abandon_protection();
+	return true;
+}
+EXPORT_SYMBOL_GPL(pgmap_pks_fault_callback);
+
 void __pgmap_mk_readwrite(struct dev_pagemap *pgmap)
 {
 	if (!current->pgmap_prot_count++)
-- 
2.28.0.rc0.12.gb6a658bd00c9

