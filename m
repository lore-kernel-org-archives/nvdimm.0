Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0113496
	for <nvdimm@lists.linux.dev>; Wed,  4 Aug 2021 04:32:42 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="299433068"
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="299433068"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:37 -0700
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="511702698"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:37 -0700
From: ira.weiny@intel.com
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
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
Subject: [PATCH V7 11/18] x86/pks: Add PKS Test code
Date: Tue,  3 Aug 2021 21:32:24 -0700
Message-Id: <20210804043231.2655537-12-ira.weiny@intel.com>
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

The core PKS functionality provides an interface for kernel users to
reserve a key and set up page tables with that key.

Define test code under CONFIG_PKS_TEST which exercises the core
functionality of PKS via a debugfs entry.  Basic checks can be triggered
on boot with a kernel command line option while both basic and
preemption checks can be triggered with separate debugfs values.  [See
the comment at the top of pks_test.c for details on the values which can
be used and what tests they run.]

CONFIG_PKS_TEST enables ARCH_ENABLE_SUPERVISOR_PKEYS but can not
co-exist with any GENERAL_PKS_USER.  This is because the test code
iterates through all the keys and is pretty much not useful in general
kernel configs.  General PKS users should select GENERAL_PKS_USER which
will disable PKS_TEST as well as enable ARCH_ENABLE_SUPERVISOR_PKEYS.

A PKey is not reserved for this test and the test code defines its own
PKS_KEY_PKS_TEST.

To test pks_abandon_protections() each test requires the thread to be
re-run after resetting the abandoned mask value.  Do this by allowing
the test code access to the abandoned mask value.

Co-developed-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes for V7
	Add testing for pks_abandon_protections()
	Adjust pkrs_init_value
	Adjust for new defines
	Clean up comments
        Adjust test for static allocation of pkeys
        Use lookup_address() instead of follow_pte()
		follow_pte only works on IO and raw PFN mappings, use
		lookup_address() instead.  lookup_address() is
		constrained to architectures which support it.
---
 Documentation/core-api/protection-keys.rst |   6 +-
 arch/x86/include/asm/pks.h                 |  18 +
 arch/x86/mm/fault.c                        |   8 +
 arch/x86/mm/pkeys.c                        |  18 +-
 lib/Kconfig.debug                          |  13 +
 lib/Makefile                               |   3 +
 lib/pks/Makefile                           |   3 +
 lib/pks/pks_test.c                         | 864 +++++++++++++++++++++
 mm/Kconfig                                 |   5 +-
 tools/testing/selftests/x86/Makefile       |   2 +-
 tools/testing/selftests/x86/test_pks.c     | 157 ++++
 11 files changed, 1092 insertions(+), 5 deletions(-)
 create mode 100644 lib/pks/Makefile
 create mode 100644 lib/pks/pks_test.c
 create mode 100644 tools/testing/selftests/x86/test_pks.c

diff --git a/Documentation/core-api/protection-keys.rst b/Documentation/core-api/protection-keys.rst
index 202088634fa3..8cf7eaaed3e5 100644
--- a/Documentation/core-api/protection-keys.rst
+++ b/Documentation/core-api/protection-keys.rst
@@ -122,8 +122,8 @@ available in future non-server Intel parts.
 Also qemu has some support as well: https://www.qemu.org/2021/04/30/qemu-6-0-0/
 
 Kernel users intending to use PKS support should depend on
-ARCH_HAS_SUPERVISOR_PKEYS, and add their config to ARCH_ENABLE_SUPERVISOR_PKEYS
-to turn on this support within the core.
+ARCH_HAS_SUPERVISOR_PKEYS, and add their config to GENERAL_PKS_USER to turn on
+this support within the core.
 
 Users reserve a key value by adding an entry to the enum pks_pkey_consumers and
 defining the initial protections in the consumer_defaults[] array.
@@ -188,3 +188,5 @@ text:
 	affected by PKRU register will not execute (even transiently)
 	until all prior executions of WRPKRU have completed execution
 	and updated the PKRU register.
+
+Example code can be found in lib/pks/pks_test.c
diff --git a/arch/x86/include/asm/pks.h b/arch/x86/include/asm/pks.h
index ed293ef4509e..e28413cc410d 100644
--- a/arch/x86/include/asm/pks.h
+++ b/arch/x86/include/asm/pks.h
@@ -39,4 +39,22 @@ static inline int handle_abandoned_pks_value(struct pt_regs *regs)
 
 #endif /* CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
 
+
+#ifdef CONFIG_PKS_TEST
+
+#define __static_or_pks_test
+
+bool pks_test_callback(struct pt_regs *regs);
+
+#else /* !CONFIG_PKS_TEST */
+
+#define __static_or_pks_test static
+
+static inline bool pks_test_callback(struct pt_regs *regs)
+{
+	return false;
+}
+
+#endif /* CONFIG_PKS_TEST */
+
 #endif /* _ASM_X86_PKS_H */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index bf3353d8e011..3780ed0f9597 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1154,6 +1154,14 @@ do_kern_addr_fault(struct pt_regs *regs, unsigned long hw_error_code,
 		 */
 		WARN_ON_ONCE(!cpu_feature_enabled(X86_FEATURE_PKS));
 
+		/*
+		 * If a protection key exception occurs it could be because a PKS test
+		 * is running.  If so, pks_test_callback() will clear the protection
+		 * mechanism and return true to indicate the fault was handled.
+		 */
+		if (pks_test_callback(regs))
+			return;
+
 		if (handle_abandoned_pks_value(regs))
 			return;
 	}
diff --git a/arch/x86/mm/pkeys.c b/arch/x86/mm/pkeys.c
index 56d37840186b..c7358662ec07 100644
--- a/arch/x86/mm/pkeys.c
+++ b/arch/x86/mm/pkeys.c
@@ -218,7 +218,7 @@ u32 update_pkey_val(u32 pk_reg, int pkey, unsigned int flags)
 
 #ifdef CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS
 
-static DEFINE_PER_CPU(u32, pkrs_cache);
+__static_or_pks_test DEFINE_PER_CPU(u32, pkrs_cache);
 u32 __read_mostly pkrs_init_value;
 
 /*
@@ -289,6 +289,22 @@ static int __init create_initial_pkrs_value(void)
 	pkrs_init_value = 0;
 	pkrs_pkey_allowed_mask = PKRS_ALLOWED_MASK_DEFAULT;
 
+	/*
+	 * PKS_TEST is mutually exclusive to any real users of PKS so define a PKS_TEST
+	 * appropriate value.
+	 *
+	 * NOTE: PKey 0 must still be fully permissive for normal kernel mappings to
+	 * work correctly.
+	 */
+	if (IS_ENABLED(CONFIG_PKS_TEST)) {
+		pkrs_init_value = (PKR_AD_KEY(1) | PKR_AD_KEY(2) | PKR_AD_KEY(3) | \
+				   PKR_AD_KEY(4) | PKR_AD_KEY(5) | PKR_AD_KEY(6) | \
+				   PKR_AD_KEY(7) | PKR_AD_KEY(8) | PKR_AD_KEY(9) | \
+				   PKR_AD_KEY(10) | PKR_AD_KEY(11) | PKR_AD_KEY(12) | \
+				   PKR_AD_KEY(13) | PKR_AD_KEY(14) | PKR_AD_KEY(15));
+		return 0;
+	}
+
 	/* Fill the defaults for the consumers */
 	for (i = 0; i < PKS_NUM_PKEYS; i++)
 		pkrs_init_value |= PKR_VALUE(i, consumer_defaults[i]);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 831212722924..28579084649d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2650,6 +2650,19 @@ config HYPERV_TESTING
 	help
 	  Select this option to enable Hyper-V vmbus testing.
 
+config PKS_TEST
+	bool "PKey (S)upervisor testing"
+	depends on ARCH_HAS_SUPERVISOR_PKEYS
+	depends on !GENERAL_PKS_USER
+	help
+	  Select this option to enable testing of PKS core software and
+	  hardware.  The PKS core provides a mechanism to allocate keys as well
+	  as maintain the protection settings across context switches.
+
+	  Answer N if you don't know what supervisor keys are.
+
+	  If unsure, say N.
+
 endmenu # "Kernel Testing and Coverage"
 
 source "Documentation/Kconfig"
diff --git a/lib/Makefile b/lib/Makefile
index 5efd1b435a37..fc31f2d6d8e4 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -360,3 +360,6 @@ obj-$(CONFIG_CMDLINE_KUNIT_TEST) += cmdline_kunit.o
 obj-$(CONFIG_SLUB_KUNIT_TEST) += slub_kunit.o
 
 obj-$(CONFIG_GENERIC_LIB_DEVMEM_IS_ALLOWED) += devmem_is_allowed.o
+
+# PKS test
+obj-y += pks/
diff --git a/lib/pks/Makefile b/lib/pks/Makefile
new file mode 100644
index 000000000000..9daccba4f7c4
--- /dev/null
+++ b/lib/pks/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_PKS_TEST) += pks_test.o
diff --git a/lib/pks/pks_test.c b/lib/pks/pks_test.c
new file mode 100644
index 000000000000..679edd487360
--- /dev/null
+++ b/lib/pks/pks_test.c
@@ -0,0 +1,864 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright(c) 2020 Intel Corporation. All rights reserved.
+ *
+ * Implement PKS testing
+ * Access to run this test can be with a command line parameter
+ * ("pks-test-on-boot") or more detailed tests can be triggered through:
+ *
+ *    /sys/kernel/debug/x86/run_pks
+ *
+ *  debugfs controls are:
+ *
+ *  '0' -- Run access tests with a single pkey
+ *  '1' -- Set up the pkey register with no access for the pkey allocated to
+ *         this fd
+ *  '2' -- Check that the pkey register updated in '1' is still the same.
+ *         (To be used after a forced context switch.)
+ *  '3' -- Allocate all pkeys possible and run tests on each pkey allocated.
+ *         DEFAULT when run at boot.
+ *  '4' -- The same as '0' with additional kernel debugging
+ *  '5' -- The same as '3' with additional kernel debugging
+ *  '6' -- Test abandoning a pkey
+ *  '9' -- Set up and fault on a PKS protected page.  This will crash the
+ *         kernel and requires the option to be specified 2 times in a row.
+ *
+ *  Closing the fd will cleanup and release the pkey, to exercise context
+ *  switch testing a user space program is provided in:
+ *
+ *          .../tools/testing/selftests/x86/test_pks.c
+ *
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/entry-common.h>
+#include <linux/fs.h>
+#include <linux/list.h>
+#include <linux/mman.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/percpu-defs.h>
+#include <linux/pgtable.h>
+#include <linux/pkeys.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+
+#include <asm/ptrace.h>       /* for struct pt_regs */
+#include <asm/pkeys_common.h>
+#include <asm/processor.h>
+#include <asm/pks.h>
+
+/*
+ * PKS testing uses all pkeys but define 1 key to use for some tests.  Any
+ * value from [1-PKS_NUM_PKEYS) will work.
+ */
+#define PKS_KEY_PKS_TEST 1
+#define PKS_TEST_MEM_SIZE (PAGE_SIZE)
+
+#define RUN_ALLOCATE            "0"
+#define ARM_CTX_SWITCH          "1"
+#define CHECK_CTX_SWITCH        "2"
+#define RUN_ALLOCATE_ALL        "3"
+#define RUN_ALLOCATE_DEBUG      "4"
+#define RUN_ALLOCATE_ALL_DEBUG  "5"
+#define RUN_DISABLE_TEST        "6"
+#define RUN_CRASH_TEST          "9"
+
+/* The testing needs some knowledge of the internals */
+DECLARE_PER_CPU(u32, pkrs_cache);
+extern u32 pkrs_pkey_allowed_mask;
+
+/*
+ * run_on_boot default '= false' which checkpatch complains about initializing;
+ * so don't
+ */
+static bool run_on_boot;
+static struct dentry *pks_test_dentry;
+static bool run_9;
+
+/*
+ * The following globals must be protected for brief periods while the fault
+ * handler checks/updates them.
+ */
+static DEFINE_SPINLOCK(test_lock);
+static int test_armed_key;
+static unsigned long prev_cnt;
+static unsigned long fault_cnt;
+
+struct pks_test_ctx {
+	bool pass;
+	bool pks_cpu_enabled;
+	bool debug;
+	int pkey;
+	char data[64];
+};
+static struct pks_test_ctx *test_exception_ctx;
+
+static bool check_pkey_val(u32 pk_reg, int pkey, u32 expected)
+{
+	pk_reg = (pk_reg & PKR_PKEY_MASK(pkey)) >> PKR_PKEY_SHIFT(pkey);
+	return (pk_reg == expected);
+}
+
+/*
+ * Check if the register @pkey value matches @expected value
+ *
+ * Both the cached and actual MSR must match.
+ */
+static bool check_pkrs(int pkey, u32 expected)
+{
+	bool ret = true;
+	u64 pkrs;
+	u32 *tmp_cache;
+
+	tmp_cache = get_cpu_ptr(&pkrs_cache);
+	if (!check_pkey_val(*tmp_cache, pkey, expected))
+		ret = false;
+	put_cpu_ptr(tmp_cache);
+
+	rdmsrl(MSR_IA32_PKRS, pkrs);
+	if (!check_pkey_val(pkrs, pkey, expected))
+		ret = false;
+
+	return ret;
+}
+
+static void check_exception(u32 thread_pkrs)
+{
+	/* Check the thread saved state */
+	if (!check_pkey_val(thread_pkrs, test_armed_key, PKEY_DISABLE_WRITE)) {
+		pr_err("     FAIL: checking ept_regs->thread_pkrs\n");
+		test_exception_ctx->pass = false;
+	}
+
+	/* Check the exception state */
+	if (!check_pkrs(test_armed_key, PKEY_DISABLE_ACCESS)) {
+		pr_err("     FAIL: PKRS cache and MSR\n");
+		test_exception_ctx->pass = false;
+	}
+
+	/*
+	 * Ensure an update can occur during exception without affecting the
+	 * interrupted thread.  The interrupted thread is checked after
+	 * exception...
+	 */
+	pks_mk_readwrite(test_armed_key);
+	if (!check_pkrs(test_armed_key, 0)) {
+		pr_err("     FAIL: exception did not change register to 0\n");
+		test_exception_ctx->pass = false;
+	}
+	pks_mk_noaccess(test_armed_key);
+	if (!check_pkrs(test_armed_key, PKEY_DISABLE_ACCESS)) {
+		pr_err("     FAIL: exception did not change register to 0x%x\n",
+			PKEY_DISABLE_ACCESS);
+		test_exception_ctx->pass = false;
+	}
+}
+
+/**
+ * pks_test_callback() is exported so that the fault handler can detect
+ * and report back status of intentional faults.
+ *
+ * NOTE: It clears the protection key from the page such that the fault handler
+ * will not re-trigger.
+ */
+bool pks_test_callback(struct pt_regs *regs)
+{
+	struct extended_pt_regs *ept_regs = extended_pt_regs(regs);
+	bool armed = (test_armed_key != 0);
+
+	if (test_exception_ctx) {
+		check_exception(ept_regs->thread_pkrs);
+		/*
+		 * Stop this check directly within the exception because the
+		 * fault handler clean up code will call again while checking
+		 * the PMD entry and there is no need to check this again.
+		 */
+		test_exception_ctx = NULL;
+	}
+
+	if (armed) {
+		/* Enable read and write to stop faults */
+		ept_regs->thread_pkrs = update_pkey_val(ept_regs->thread_pkrs,
+							test_armed_key, 0);
+		fault_cnt++;
+	}
+
+	return armed;
+}
+
+static bool exception_caught(void)
+{
+	bool ret = (fault_cnt != prev_cnt);
+
+	prev_cnt = fault_cnt;
+	return ret;
+}
+
+static void report_pkey_settings(void *info)
+{
+	u8 pkey;
+	unsigned long long msr = 0;
+	unsigned int cpu = smp_processor_id();
+	struct pks_test_ctx *ctx = info;
+
+	rdmsrl(MSR_IA32_PKRS, msr);
+
+	pr_info("for CPU %d : 0x%llx\n", cpu, msr);
+
+	if (ctx->debug) {
+		for (pkey = 0; pkey < PKS_NUM_PKEYS; pkey++) {
+			int ad, wd;
+
+			ad = (msr >> PKR_PKEY_SHIFT(pkey)) & PKEY_DISABLE_ACCESS;
+			wd = (msr >> PKR_PKEY_SHIFT(pkey)) & PKEY_DISABLE_WRITE;
+			pr_info("   %u: A:%d W:%d\n", pkey, ad, wd);
+		}
+	}
+}
+
+enum pks_access_mode {
+	PKS_TEST_NO_ACCESS,
+	PKS_TEST_RDWR,
+	PKS_TEST_RDONLY
+};
+
+static char *get_mode_str(enum pks_access_mode mode)
+{
+	switch (mode) {
+	case PKS_TEST_NO_ACCESS:
+		return "No Access";
+	case PKS_TEST_RDWR:
+		return "Read Write";
+	case PKS_TEST_RDONLY:
+		return "Read Only";
+	default:
+		pr_err("BUG in test invalid mode\n");
+		break;
+	}
+
+	return "";
+}
+
+struct pks_access_test {
+	enum pks_access_mode mode;
+	bool write;
+	bool exception;
+};
+
+static struct pks_access_test pkey_test_ary[] = {
+	/*  disable both */
+	{ PKS_TEST_NO_ACCESS, true,  true },
+	{ PKS_TEST_NO_ACCESS, false, true },
+
+	/*  enable both */
+	{ PKS_TEST_RDWR, true,  false },
+	{ PKS_TEST_RDWR, false, false },
+
+	/*  enable read only */
+	{ PKS_TEST_RDONLY, true,  true },
+	{ PKS_TEST_RDONLY, false, false },
+};
+
+static int test_it(struct pks_test_ctx *ctx, struct pks_access_test *test,
+		   void *ptr, bool forced_sched)
+{
+	bool exception;
+	int ret = 0;
+
+	spin_lock(&test_lock);
+	WRITE_ONCE(test_armed_key, ctx->pkey);
+
+	if (test->write)
+		memcpy(ptr, ctx->data, 8);
+	else
+		memcpy(ctx->data, ptr, 8);
+
+	exception = exception_caught();
+
+	WRITE_ONCE(test_armed_key, 0);
+	spin_unlock(&test_lock);
+
+	/*
+	 * After a forced schedule the allowed mask should be applied on
+	 * sched_in and therefore no exception should ever be seen.
+	 */
+	if (forced_sched && exception) {
+		pr_err("pkey test FAILED: mode %s; write %s; exception %s != %s; sched TRUE\n",
+			get_mode_str(test->mode),
+			test->write ? "TRUE" : "FALSE",
+			test->exception ? "TRUE" : "FALSE",
+			exception ? "TRUE" : "FALSE");
+		ret = -EFAULT;
+	} else if (test->exception != exception) {
+		pr_err("pkey test FAILED: mode %s; write %s; exception %s != %s\n",
+			get_mode_str(test->mode),
+			test->write ? "TRUE" : "FALSE",
+			test->exception ? "TRUE" : "FALSE",
+			exception ? "TRUE" : "FALSE");
+		ret = -EFAULT;
+	}
+
+	return ret;
+}
+
+static int run_access_test(struct pks_test_ctx *ctx,
+			   struct pks_access_test *test,
+			   void *ptr,
+			   bool forced_sched)
+{
+	switch (test->mode) {
+	case PKS_TEST_NO_ACCESS:
+		pks_mk_noaccess(ctx->pkey);
+		break;
+	case PKS_TEST_RDWR:
+		pks_mk_readwrite(ctx->pkey);
+		break;
+	case PKS_TEST_RDONLY:
+		pks_mk_readonly(ctx->pkey);
+		break;
+	default:
+		pr_err("BUG in test invalid mode\n");
+		break;
+	}
+
+	return test_it(ctx, test, ptr, forced_sched);
+}
+
+static void *alloc_test_page(int pkey)
+{
+	return __vmalloc_node_range(PKS_TEST_MEM_SIZE, 1, VMALLOC_START, VMALLOC_END,
+				    GFP_KERNEL, PAGE_KERNEL_PKEY(pkey), 0,
+				    NUMA_NO_NODE, __builtin_return_address(0));
+}
+
+static void test_mem_access(struct pks_test_ctx *ctx)
+{
+	int i, rc;
+	u8 pkey;
+	void *ptr = NULL;
+	pte_t *ptep = NULL;
+	unsigned int level;
+
+	ptr = alloc_test_page(ctx->pkey);
+	if (!ptr) {
+		pr_err("Failed to vmalloc page???\n");
+		ctx->pass = false;
+		return;
+	}
+
+	ptep = lookup_address((unsigned long)ptr, &level);
+	if (!ptep) {
+		pr_err("Failed to lookup address???\n");
+		ctx->pass = false;
+		goto done;
+	}
+
+	pr_info("lookup address ptr %p ptep %p\n",
+		ptr, ptep);
+
+	pkey = pte_flags_pkey(ptep->pte);
+	pr_info("ptep flags 0x%lx pkey %u\n",
+		(unsigned long)ptep->pte, pkey);
+
+	if (pkey != ctx->pkey) {
+		pr_err("invalid pkey found: %u, test_pkey: %u\n",
+			pkey, ctx->pkey);
+		ctx->pass = false;
+		goto done;
+	}
+
+	if (!ctx->pks_cpu_enabled) {
+		pr_err("not CPU enabled; skipping access tests...\n");
+		ctx->pass = true;
+		goto done;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(pkey_test_ary); i++) {
+		rc = run_access_test(ctx, &pkey_test_ary[i], ptr, false);
+
+		/*  only save last error is fine */
+		if (rc)
+			ctx->pass = false;
+	}
+
+done:
+	vfree(ptr);
+}
+
+static void pks_run_test(struct pks_test_ctx *ctx)
+{
+	ctx->pass = true;
+
+	pr_info("\n");
+	pr_info("\n");
+	pr_info("     ***** BEGIN: Testing (CPU enabled : %s) *****\n",
+		ctx->pks_cpu_enabled ? "TRUE" : "FALSE");
+
+	if (ctx->pks_cpu_enabled)
+		on_each_cpu(report_pkey_settings, ctx, 1);
+
+	pr_info("           BEGIN: pkey %d Testing\n", ctx->pkey);
+	test_mem_access(ctx);
+	pr_info("           END: PAGE_KERNEL_PKEY Testing : %s\n",
+		ctx->pass ? "PASS" : "FAIL");
+
+	pr_info("     ***** END: Testing *****\n");
+	pr_info("\n");
+	pr_info("\n");
+}
+
+static ssize_t pks_read_file(struct file *file, char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	struct pks_test_ctx *ctx = file->private_data;
+	char buf[32];
+	unsigned int len;
+
+	if (!ctx)
+		len = sprintf(buf, "not run\n");
+	else
+		len = sprintf(buf, "%s\n", ctx->pass ? "PASS" : "FAIL");
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static struct pks_test_ctx *alloc_ctx(u8 pkey)
+{
+	struct pks_test_ctx *ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+
+	if (!ctx) {
+		pr_err("Failed to allocate memory for test context\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	ctx->pkey = pkey;
+	ctx->pks_cpu_enabled = cpu_feature_enabled(X86_FEATURE_PKS);
+	sprintf(ctx->data, "%s", "DEADBEEF");
+	return ctx;
+}
+
+static void free_ctx(struct pks_test_ctx *ctx)
+{
+	kfree(ctx);
+}
+
+static void run_exception_test(void)
+{
+	void *ptr = NULL;
+	bool pass = true;
+	struct pks_test_ctx *ctx;
+
+	pr_info("     ***** BEGIN: exception checking\n");
+
+	ctx = alloc_ctx(PKS_KEY_PKS_TEST);
+	if (IS_ERR(ctx)) {
+		pr_err("     FAIL: no context\n");
+		pass = false;
+		goto result;
+	}
+	ctx->pass = true;
+
+	ptr = alloc_test_page(ctx->pkey);
+	if (!ptr) {
+		pr_err("     FAIL: no vmalloc page\n");
+		pass = false;
+		goto free_context;
+	}
+
+	pks_mk_readonly(ctx->pkey);
+
+	spin_lock(&test_lock);
+	WRITE_ONCE(test_exception_ctx, ctx);
+	WRITE_ONCE(test_armed_key, ctx->pkey);
+
+	memcpy(ptr, ctx->data, 8);
+
+	if (!exception_caught()) {
+		pr_err("     FAIL: did not get an exception\n");
+		pass = false;
+	}
+
+	/*
+	 * NOTE The exception code has to enable access (b00) to keep the fault
+	 * from looping forever.  Therefore full access is seen here rather
+	 * than write disabled.
+	 *
+	 * Furthermore, check_exception() disabled access during the exception
+	 * so this is testing that the thread value was restored back to the
+	 * thread value.
+	 */
+	if (!check_pkrs(test_armed_key, 0)) {
+		pr_err("     FAIL: PKRS not restored\n");
+		pass = false;
+	}
+
+	if (!ctx->pass)
+		pass = false;
+
+	WRITE_ONCE(test_armed_key, 0);
+	spin_unlock(&test_lock);
+
+	vfree(ptr);
+free_context:
+	free_ctx(ctx);
+result:
+	pr_info("     ***** END: exception checking : %s\n",
+		 pass ? "PASS" : "FAIL");
+}
+
+static struct pks_access_test abandon_test_ary[] = {
+	/*  disable both */
+	{ PKS_TEST_NO_ACCESS, true,  false },
+	{ PKS_TEST_NO_ACCESS, false, false },
+
+	/*  enable both */
+	{ PKS_TEST_RDWR, true,  false },
+	{ PKS_TEST_RDWR, false, false },
+
+	/*  enable read only */
+	{ PKS_TEST_RDONLY, true,  false },
+	{ PKS_TEST_RDONLY, false, false },
+};
+
+static DEFINE_SPINLOCK(abandoned_test_lock);
+struct shared_data {
+	struct pks_test_ctx *ctx;
+	void *kmap_addr;
+	struct pks_access_test *test;
+	bool thread_running;
+	bool sched_thread;
+};
+
+static int abandoned_test_main(void *d)
+{
+	struct shared_data *data = d;
+	struct pks_test_ctx *ctx = data->ctx;
+
+	spin_lock(&abandoned_test_lock);
+	data->thread_running = true;
+	spin_unlock(&abandoned_test_lock);
+
+	while (!kthread_should_stop()) {
+		spin_lock(&abandoned_test_lock);
+		if (data->kmap_addr) {
+			pr_info("     Thread ->saved_pkrs Before 0x%x (%d)\n",
+				current->thread.saved_pkrs, ctx->pkey);
+			if (data->sched_thread)
+				msleep(20);
+			if (run_access_test(ctx, data->test, data->kmap_addr,
+					    data->sched_thread))
+				ctx->pass = false;
+			pr_info("     Thread Remote ->saved_pkrs After 0x%x (%d)\n",
+				current->thread.saved_pkrs, ctx->pkey);
+			data->kmap_addr = NULL;
+		}
+		spin_unlock(&abandoned_test_lock);
+	}
+
+	return 0;
+}
+
+static void run_abandon_pkey_test(struct pks_test_ctx *ctx,
+				  struct pks_access_test *test,
+				  void *ptr,
+				  bool sched_thread)
+{
+	struct task_struct *other_task;
+	struct shared_data data;
+	bool running = false;
+
+	pr_info("checking...  mode %s; write %s\n",
+			get_mode_str(test->mode), test->write ? "TRUE" : "FALSE");
+
+	pkrs_pkey_allowed_mask = 0xffffffff;
+
+	memset(&data, 0, sizeof(data));
+	data.ctx = ctx;
+	data.thread_running = false;
+	data.sched_thread = sched_thread;
+	other_task = kthread_run(abandoned_test_main, &data, "PKRS abandoned test");
+	if (IS_ERR(other_task)) {
+		pr_err("     FAIL: Failed to start thread\n");
+		ctx->pass = false;
+		return;
+	}
+
+	while (!running) {
+		spin_lock(&abandoned_test_lock);
+		running = data.thread_running;
+		spin_unlock(&abandoned_test_lock);
+	}
+
+	spin_lock(&abandoned_test_lock);
+	pr_info("Local ->saved_pkrs Before 0x%x (%d)\n",
+		current->thread.saved_pkrs, ctx->pkey);
+	pks_abandon_protections(ctx->pkey);
+	data.test = test;
+	data.kmap_addr = ptr;
+	spin_unlock(&abandoned_test_lock);
+
+	while (data.kmap_addr)
+		msleep(20);
+
+	pr_info("Local ->saved_pkrs After 0x%x (%d)\n",
+		current->thread.saved_pkrs, ctx->pkey);
+
+	kthread_stop(other_task);
+}
+
+static void run_abandoned_test(void)
+{
+	struct pks_test_ctx *ctx;
+	bool pass = true;
+	void *ptr;
+	int i;
+
+	pr_info("     ***** BEGIN: abandoned pkey checking\n");
+
+	ctx = alloc_ctx(PKS_KEY_PKS_TEST);
+	if (IS_ERR(ctx)) {
+		pr_err("     FAIL: no context\n");
+		pass = false;
+		goto result;
+	}
+
+	ptr = alloc_test_page(ctx->pkey);
+	if (!ptr) {
+		pr_err("     FAIL: no vmalloc page\n");
+		pass = false;
+		goto free_context;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(abandon_test_ary); i++) {
+		ctx->pass = true;
+		run_abandon_pkey_test(ctx, &abandon_test_ary[i], ptr, false);
+		/* sticky fail */
+		if (!ctx->pass)
+			pass = ctx->pass;
+
+		ctx->pass = true;
+		run_abandon_pkey_test(ctx, &abandon_test_ary[i], ptr, true);
+		/* sticky fail */
+		if (!ctx->pass)
+			pass = ctx->pass;
+	}
+
+	/* Force re-enable all keys */
+	pkrs_pkey_allowed_mask = 0xffffffff;
+
+	vfree(ptr);
+free_context:
+	free_ctx(ctx);
+result:
+	pr_info("     ***** END: abandoned pkey checking : %s\n",
+		 pass ? "PASS" : "FAIL");
+}
+
+static void run_all(bool debug)
+{
+	struct pks_test_ctx *ctx[PKS_NUM_PKEYS];
+	static char name[PKS_NUM_PKEYS][64];
+	int i;
+
+	for (i = 1; i < PKS_NUM_PKEYS; i++) {
+		sprintf(name[i], "pks ctx %d", i);
+		ctx[i] = alloc_ctx(i);
+		if (!IS_ERR(ctx[i]))
+			ctx[i]->debug = debug;
+	}
+
+	for (i = 1; i < PKS_NUM_PKEYS; i++) {
+		if (!IS_ERR(ctx[i]))
+			pks_run_test(ctx[i]);
+	}
+
+	for (i = 1; i < PKS_NUM_PKEYS; i++) {
+		if (!IS_ERR(ctx[i]))
+			free_ctx(ctx[i]);
+	}
+
+	run_exception_test();
+
+	run_abandoned_test();
+}
+
+static void crash_it(void)
+{
+	struct pks_test_ctx *ctx;
+	void *ptr;
+
+	pr_warn("     ***** BEGIN: Unhandled fault test *****\n");
+
+	ctx = alloc_ctx(PKS_KEY_PKS_TEST);
+	if (IS_ERR(ctx)) {
+		pr_err("Failed to allocate context???\n");
+		return;
+	}
+
+	ptr = alloc_test_page(ctx->pkey);
+	if (!ptr) {
+		pr_err("Failed to vmalloc page???\n");
+		ctx->pass = false;
+		return;
+	}
+
+	pks_mk_noaccess(ctx->pkey);
+
+	spin_lock(&test_lock);
+	WRITE_ONCE(test_armed_key, 0);
+	/* This purposely faults */
+	memcpy(ptr, ctx->data, 8);
+	spin_unlock(&test_lock);
+
+	vfree(ptr);
+	free_ctx(ctx);
+}
+
+static ssize_t pks_write_file(struct file *file, const char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+	char buf[2];
+	struct pks_test_ctx *ctx = file->private_data;
+
+	if (copy_from_user(buf, user_buf, 1))
+		return -EFAULT;
+	buf[1] = '\0';
+
+	/*
+	 * WARNING: Test "9" will crash the kernel.
+	 *
+	 * Arm the test and print a warning.  A second "9" will run the test.
+	 */
+	if (!strcmp(buf, RUN_CRASH_TEST)) {
+		if (run_9) {
+			crash_it();
+			run_9 = false;
+		} else {
+			pr_warn("CAUTION: Test 9 will crash in the kernel.\n");
+			pr_warn("         Specify 9 a second time to run\n");
+			pr_warn("         run any other test to clear\n");
+			run_9 = true;
+		}
+	} else {
+		run_9 = false;
+	}
+
+	/*
+	 * Test "3" will test allocating all keys. Do it first without
+	 * using "ctx".
+	 */
+	if (!strcmp(buf, RUN_ALLOCATE_ALL))
+		run_all(false);
+	if (!strcmp(buf, RUN_ALLOCATE_ALL_DEBUG))
+		run_all(true);
+
+	if (!strcmp(buf, RUN_DISABLE_TEST))
+		run_abandoned_test();
+
+	/*
+	 * This context is only required if the file is held open for the below
+	 * tests.  Otherwise the context just get's freed in pks_release_file.
+	 */
+	if (!ctx) {
+		ctx = alloc_ctx(PKS_KEY_PKS_TEST);
+		if (IS_ERR(ctx))
+			return -ENOMEM;
+		file->private_data = ctx;
+	}
+
+	if (!strcmp(buf, RUN_ALLOCATE)) {
+		ctx->debug = false;
+		pks_run_test(ctx);
+	}
+	if (!strcmp(buf, RUN_ALLOCATE_DEBUG)) {
+		ctx->debug = true;
+		pks_run_test(ctx);
+	}
+
+	/* start of context switch test */
+	if (!strcmp(buf, ARM_CTX_SWITCH)) {
+		unsigned long reg_pkrs;
+		int access;
+
+		/* Ensure a known state to test context switch */
+		pks_mk_readwrite(ctx->pkey);
+
+		rdmsrl(MSR_IA32_PKRS, reg_pkrs);
+
+		access = (reg_pkrs >> PKR_PKEY_SHIFT(ctx->pkey)) &
+			  PKEY_ACCESS_MASK;
+		pr_info("Context switch armed : pkey %d: 0x%x reg: 0x%lx\n",
+			ctx->pkey, access, reg_pkrs);
+	}
+
+	/* After context switch msr should be restored */
+	if (!strcmp(buf, CHECK_CTX_SWITCH) && ctx->pks_cpu_enabled) {
+		unsigned long reg_pkrs;
+		int access;
+
+		rdmsrl(MSR_IA32_PKRS, reg_pkrs);
+
+		access = (reg_pkrs >> PKR_PKEY_SHIFT(ctx->pkey)) &
+			  PKEY_ACCESS_MASK;
+		if (access != 0) {
+			ctx->pass = false;
+			pr_err("Context switch check failed: pkey %d: 0x%x reg: 0x%lx\n",
+				ctx->pkey, access, reg_pkrs);
+		} else {
+			pr_err("Context switch check passed: pkey %d: 0x%x reg: 0x%lx\n",
+				ctx->pkey, access, reg_pkrs);
+		}
+	}
+
+	return count;
+}
+
+static int pks_release_file(struct inode *inode, struct file *file)
+{
+	struct pks_test_ctx *ctx = file->private_data;
+
+	if (!ctx)
+		return 0;
+
+	free_ctx(ctx);
+	return 0;
+}
+
+static const struct file_operations fops_init_pks = {
+	.read = pks_read_file,
+	.write = pks_write_file,
+	.llseek = default_llseek,
+	.release = pks_release_file,
+};
+
+static int __init parse_pks_test_options(char *str)
+{
+	run_on_boot = true;
+
+	return 0;
+}
+early_param("pks-test-on-boot", parse_pks_test_options);
+
+static int __init pks_test_init(void)
+{
+	if (cpu_feature_enabled(X86_FEATURE_PKS)) {
+		if (run_on_boot)
+			run_all(true);
+
+		pks_test_dentry = debugfs_create_file("run_pks", 0600, arch_debugfs_dir,
+						      NULL, &fops_init_pks);
+	}
+
+	return 0;
+}
+late_initcall(pks_test_init);
+
+static void __exit pks_test_exit(void)
+{
+	debugfs_remove(pks_test_dentry);
+	pr_info("test exit\n");
+}
diff --git a/mm/Kconfig b/mm/Kconfig
index e0d29c655ade..ea6ffee69f55 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -820,8 +820,11 @@ config ARCH_HAS_PKEYS
 	bool
 config ARCH_HAS_SUPERVISOR_PKEYS
 	bool
+config GENERAL_PKS_USER
+	def_bool n
 config ARCH_ENABLE_SUPERVISOR_PKEYS
-	bool
+	def_bool y
+	depends on PKS_TEST || GENERAL_PKS_USER
 
 config PERCPU_STATS
 	bool "Collect percpu memory statistics"
diff --git a/tools/testing/selftests/x86/Makefile b/tools/testing/selftests/x86/Makefile
index b4142cd1c5c2..b2f852f0e7e1 100644
--- a/tools/testing/selftests/x86/Makefile
+++ b/tools/testing/selftests/x86/Makefile
@@ -13,7 +13,7 @@ CAN_BUILD_WITH_NOPIE := $(shell ./check_cc.sh $(CC) trivial_program.c -no-pie)
 TARGETS_C_BOTHBITS := single_step_syscall sysret_ss_attrs syscall_nt test_mremap_vdso \
 			check_initial_reg_state sigreturn iopl ioperm \
 			test_vsyscall mov_ss_trap \
-			syscall_arg_fault fsgsbase_restore sigaltstack
+			syscall_arg_fault fsgsbase_restore sigaltstack test_pks
 TARGETS_C_32BIT_ONLY := entry_from_vm86 test_syscall_vdso unwind_vdso \
 			test_FCMOV test_FCOMI test_FISTTP \
 			vdso_restorer
diff --git a/tools/testing/selftests/x86/test_pks.c b/tools/testing/selftests/x86/test_pks.c
new file mode 100644
index 000000000000..c12b38760c9c
--- /dev/null
+++ b/tools/testing/selftests/x86/test_pks.c
@@ -0,0 +1,157 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright(c) 2020 Intel Corporation. All rights reserved.
+ *
+ * User space tool to test PKS operations.  Accesses test code through
+ * <debugfs>/x86/run_pks when CONFIG_PKS_TEST is enabled.
+ *
+ */
+
+#define _GNU_SOURCE
+#include <sched.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <unistd.h>
+#include <assert.h>
+#include <stdio.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <string.h>
+#include <stdbool.h>
+
+#define PKS_TEST_FILE "/sys/kernel/debug/x86/run_pks"
+
+#define RUN_ALLOCATE            "0"
+#define SETUP_CTX_SWITCH        "1"
+#define CHECK_CTX_SWITCH        "2"
+#define RUN_ALLOCATE_ALL        "3"
+#define RUN_ALLOCATE_DEBUG      "4"
+#define RUN_ALLOCATE_ALL_DEBUG  "5"
+#define RUN_DISABLE_TEST        "6"
+#define RUN_CRASH_TEST          "9"
+
+int main(int argc, char *argv[])
+{
+	cpu_set_t cpuset;
+	char result[32];
+	pid_t pid;
+	int fd;
+	int setup_done[2];
+	int switch_done[2];
+	int cpu = 0;
+	int rc = 0;
+	int c;
+	bool debug = false;
+
+	while (1) {
+		int option_index = 0;
+		static struct option long_options[] = {
+			{"debug",  no_argument,	  0,  0 },
+			{0,	   0,		  0,  0 }
+		};
+
+		c = getopt_long(argc, argv, "", long_options, &option_index);
+		if (c == -1)
+			break;
+
+		switch (c) {
+		case 0:
+			debug = true;
+			break;
+		}
+	}
+
+	if (optind < argc)
+		cpu = strtoul(argv[optind], NULL, 0);
+
+	if (cpu >= sysconf(_SC_NPROCESSORS_ONLN)) {
+		printf("CPU %d is invalid\n", cpu);
+		cpu = sysconf(_SC_NPROCESSORS_ONLN) - 1;
+		printf("   running on max CPU: %d\n", cpu);
+	}
+
+	CPU_ZERO(&cpuset);
+	CPU_SET(cpu, &cpuset);
+	/* Two processes run on CPU 0 so that they go through context switch. */
+	sched_setaffinity(getpid(), sizeof(cpu_set_t), &cpuset);
+
+	if (pipe(setup_done))
+		printf("Failed to create pipe\n");
+	if (pipe(switch_done))
+		printf("Failed to create pipe\n");
+
+	pid = fork();
+	if (pid == 0) {
+		char done = 'y';
+
+		fd = open(PKS_TEST_FILE, O_RDWR);
+		if (fd < 0) {
+			printf("cannot open %s\n", PKS_TEST_FILE);
+			return -1;
+		}
+
+		cpu = sched_getcpu();
+		printf("Child running on cpu %d...\n", cpu);
+
+		/* Allocate test_pkey1 and run test. */
+		if (debug)
+			write(fd, RUN_ALLOCATE_DEBUG, 1);
+		else
+			write(fd, RUN_ALLOCATE, 1);
+
+		/* Arm for context switch test */
+		write(fd, SETUP_CTX_SWITCH, 1);
+
+		printf("   tell parent to go\n");
+		write(setup_done[1], &done, sizeof(done));
+
+		/* Context switch out... */
+		printf("   Waiting for parent...\n");
+		read(switch_done[0], &done, sizeof(done));
+
+		/* Check msr restored */
+		printf("Checking result\n");
+		write(fd, CHECK_CTX_SWITCH, 1);
+
+		read(fd, result, 10);
+		printf("   #PF, context switch, pkey allocation and free tests: %s\n", result);
+		if (!strncmp(result, "PASS", 10)) {
+			rc = -1;
+			done = 'F';
+		}
+
+		/* Signal result */
+		write(setup_done[1], &done, sizeof(done));
+	} else {
+		char done = 'y';
+
+		read(setup_done[0], &done, sizeof(done));
+		cpu = sched_getcpu();
+		printf("Parent running on cpu %d\n", cpu);
+
+		fd = open(PKS_TEST_FILE, O_RDWR);
+		if (fd < 0) {
+			printf("cannot open %s\n", PKS_TEST_FILE);
+			return -1;
+		}
+
+		/* run test with alternate pkey */
+		if (debug)
+			write(fd, RUN_ALLOCATE_DEBUG, 1);
+		else
+			write(fd, RUN_ALLOCATE, 1);
+
+		printf("   Signaling child.\n");
+		write(switch_done[1], &done, sizeof(done));
+
+		/* Wait for result */
+		read(setup_done[0], &done, sizeof(done));
+		if (done == 'F')
+			rc = -1;
+	}
+
+	close(fd);
+
+	return rc;
+}
-- 
2.28.0.rc0.12.gb6a658bd00c9

