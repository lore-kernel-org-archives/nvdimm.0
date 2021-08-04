Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071B13481
	for <nvdimm@lists.linux.dev>; Wed,  4 Aug 2021 04:32:36 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="299433047"
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="299433047"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:35 -0700
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="511702659"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:35 -0700
From: ira.weiny@intel.com
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Andy Lutomirski <luto@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH V7 02/18] x86/fpu: Refactor arch_set_user_pkey_access()
Date: Tue,  3 Aug 2021 21:32:15 -0700
Message-Id: <20210804043231.2655537-3-ira.weiny@intel.com>
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

Both PKU and PKS update their register values in the same way.  They can
therefore share the update code.

Define a helper, update_pkey_val(), which will be used to support both
Protection Key User (PKU) and the new Protection Key for Supervisor
(PKS) in subsequent patches.

Use that helper in arch_set_user_pkey_access().

Co-developed-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 arch/x86/include/asm/pkeys.h |  2 ++
 arch/x86/kernel/fpu/xstate.c | 22 ++++------------------
 arch/x86/mm/pkeys.c          | 23 +++++++++++++++++++++++
 3 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/pkeys.h b/arch/x86/include/asm/pkeys.h
index 5c7bcaa79623..597f19e4525b 100644
--- a/arch/x86/include/asm/pkeys.h
+++ b/arch/x86/include/asm/pkeys.h
@@ -133,4 +133,6 @@ static inline int vma_pkey(struct vm_area_struct *vma)
 	return (vma->vm_flags & vma_pkey_mask) >> VM_PKEY_SHIFT;
 }
 
+u32 update_pkey_val(u32 pk_reg, int pkey, unsigned int flags);
+
 #endif /*_ASM_X86_PKEYS_H */
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 6af0c80ad425..4f95ab38a23c 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -915,8 +915,7 @@ EXPORT_SYMBOL_GPL(get_xsave_addr);
 int arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
 			      unsigned long init_val)
 {
-	u32 old_pkru, new_pkru_bits = 0;
-	int pkey_shift;
+	u32 pkru;
 
 	/*
 	 * This check implies XSAVE support.  OSPKE only gets
@@ -933,22 +932,9 @@ int arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
 	if (WARN_ON_ONCE(pkey >= arch_max_pkey()))
 		return -EINVAL;
 
-	/* Set the bits needed in PKRU:  */
-	if (init_val & PKEY_DISABLE_ACCESS)
-		new_pkru_bits |= PKR_AD_BIT;
-	if (init_val & PKEY_DISABLE_WRITE)
-		new_pkru_bits |= PKR_WD_BIT;
-
-	/* Shift the bits in to the correct place in PKRU for pkey: */
-	pkey_shift = pkey * PKRU_BITS_PER_PKEY;
-	new_pkru_bits <<= pkey_shift;
-
-	/* Get old PKRU and mask off any old bits in place: */
-	old_pkru = read_pkru();
-	old_pkru &= ~((PKR_AD_BIT|PKR_WD_BIT) << pkey_shift);
-
-	/* Write old part along with new part: */
-	write_pkru(old_pkru | new_pkru_bits);
+	pkru = read_pkru();
+	pkru = update_pkey_val(pkru, pkey, init_val);
+	write_pkru(pkru);
 
 	return 0;
 }
diff --git a/arch/x86/mm/pkeys.c b/arch/x86/mm/pkeys.c
index aa7042f272fb..ca2e20b18645 100644
--- a/arch/x86/mm/pkeys.c
+++ b/arch/x86/mm/pkeys.c
@@ -190,3 +190,26 @@ static __init int setup_init_pkru(char *opt)
 	return 1;
 }
 __setup("init_pkru=", setup_init_pkru);
+
+/*
+ * Replace disable bits for @pkey with values from @flags
+ *
+ * Kernel users use the same flags as user space:
+ *     PKEY_DISABLE_ACCESS
+ *     PKEY_DISABLE_WRITE
+ */
+u32 update_pkey_val(u32 pk_reg, int pkey, unsigned int flags)
+{
+	int pkey_shift = pkey * PKR_BITS_PER_PKEY;
+
+	/*  Mask out old bit values */
+	pk_reg &= ~(((1 << PKR_BITS_PER_PKEY) - 1) << pkey_shift);
+
+	/*  Or in new values */
+	if (flags & PKEY_DISABLE_ACCESS)
+		pk_reg |= PKR_AD_BIT << pkey_shift;
+	if (flags & PKEY_DISABLE_WRITE)
+		pk_reg |= PKR_WD_BIT << pkey_shift;
+
+	return pk_reg;
+}
-- 
2.28.0.rc0.12.gb6a658bd00c9

