Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34E43486
	for <nvdimm@lists.linux.dev>; Wed,  4 Aug 2021 04:32:39 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="299433059"
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="299433059"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:36 -0700
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="511702681"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:36 -0700
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
Subject: [PATCH V7 07/18] x86/pks: Preserve the PKRS MSR on context switch
Date: Tue,  3 Aug 2021 21:32:20 -0700
Message-Id: <20210804043231.2655537-8-ira.weiny@intel.com>
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

The PKRS MSR is defined as a per-logical-processor register.  This
isolates memory access by logical CPU.  Unfortunately, the MSR is not
managed by XSAVE.  Therefore, tasks must save/restore the MSR value on
context switch.

Define a saved PKRS value in the task struct.  Initialize all tasks with
the INIT_PKRS_VALUE and call pkrs_write_current() to set the MSR to the
saved task value on schedule in.

Co-developed-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes for V7
	Move definitions from asm/processor.h to asm/pks.h
	s/INIT_PKRS_VALUE/pkrs_init_value
	Change pks_init_task()/pks_sched_in() to functions
	s/pks_sched_in/pks_write_current to be used more generically
	later in the series
---
 arch/x86/include/asm/pks.h       |  4 ++++
 arch/x86/include/asm/processor.h | 19 ++++++++++++++++++-
 arch/x86/kernel/process.c        |  3 +++
 arch/x86/kernel/process_64.c     |  3 +++
 arch/x86/mm/pkeys.c              | 16 ++++++++++++++++
 5 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/pks.h b/arch/x86/include/asm/pks.h
index 5d7067ada8fb..e7727086cec2 100644
--- a/arch/x86/include/asm/pks.h
+++ b/arch/x86/include/asm/pks.h
@@ -5,10 +5,14 @@
 #ifdef CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS
 
 void setup_pks(void);
+void pkrs_write_current(void);
+void pks_init_task(struct task_struct *task);
 
 #else /* !CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
 
 static inline void setup_pks(void) { }
+static inline void pkrs_write_current(void) { }
+static inline void pks_init_task(struct task_struct *task) { }
 
 #endif /* CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index f3020c54e2cb..a6cb7d152c62 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -502,6 +502,12 @@ struct thread_struct {
 	unsigned long		cr2;
 	unsigned long		trap_nr;
 	unsigned long		error_code;
+
+#ifdef	CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS
+	/* Saved Protection key register for supervisor mappings */
+	u32			saved_pkrs;
+#endif
+
 #ifdef CONFIG_VM86
 	/* Virtual 86 mode info */
 	struct vm86		*vm86;
@@ -768,7 +774,18 @@ static inline void spin_lock_prefetch(const void *x)
 #define KSTK_ESP(task)		(task_pt_regs(task)->sp)
 
 #else
-#define INIT_THREAD { }
+
+#ifdef CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS
+/*
+ * Early task gets full permissions, the restrictive value is set in
+ * pks_init_task()
+ */
+#define INIT_THREAD  {					\
+	.saved_pkrs = 0,				\
+}
+#else
+#define INIT_THREAD  { }
+#endif
 
 extern unsigned long KSTK_ESP(struct task_struct *task);
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1d9463e3096b..c792ac5f33a2 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -43,6 +43,7 @@
 #include <asm/io_bitmap.h>
 #include <asm/proto.h>
 #include <asm/frame.h>
+#include <asm/pks.h>
 
 #include "process.h"
 
@@ -223,6 +224,8 @@ void flush_thread(void)
 
 	fpu_flush_thread();
 	pkru_flush_thread();
+
+	pks_init_task(tsk);
 }
 
 void disable_TSC(void)
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ec0d836a13b1..8bd1f039e5bf 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -59,6 +59,7 @@
 /* Not included via unistd.h */
 #include <asm/unistd_32_ia32.h>
 #endif
+#include <asm/pks.h>
 
 #include "process.h"
 
@@ -658,6 +659,8 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	/* Load the Intel cache allocation PQR MSR. */
 	resctrl_sched_in();
 
+	pkrs_write_current();
+
 	return prev_p;
 }
 
diff --git a/arch/x86/mm/pkeys.c b/arch/x86/mm/pkeys.c
index fbffbced81b5..eca01dc8d7ac 100644
--- a/arch/x86/mm/pkeys.c
+++ b/arch/x86/mm/pkeys.c
@@ -284,5 +284,21 @@ void setup_pks(void)
 	write_pkrs(pkrs_init_value);
 	cr4_set_bits(X86_CR4_PKS);
 }
+;
+
+/*
+ * PKRS is only temporarily changed during specific code paths.  Only a
+ * preemption during these windows away from the default value would
+ * require updating the MSR.  write_pkrs() handles this optimization.
+ */
+void pkrs_write_current(void)
+{
+	write_pkrs(current->thread.saved_pkrs);
+}
+
+void pks_init_task(struct task_struct *task)
+{
+	task->thread.saved_pkrs = pkrs_init_value;
+}
 
 #endif /* CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
-- 
2.28.0.rc0.12.gb6a658bd00c9

