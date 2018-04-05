Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x244.google.com (mail-io0-x244.google.com
 [IPv6:2607:f8b0:4001:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 72858225264B7
 for <linux-nvdimm@lists.01.org>; Thu,  5 Apr 2018 00:15:14 -0700 (PDT)
Received: by mail-io0-x244.google.com with SMTP id x77so23110877ioi.2
 for <linux-nvdimm@lists.01.org>; Thu, 05 Apr 2018 00:15:14 -0700 (PDT)
From: Balbir Singh <bsingharora@gmail.com>
Subject: [PATCH v2 1/3] powerpc/mce: Bug fixes for MCE handling in kernel space
Date: Thu,  5 Apr 2018 17:14:58 +1000
Message-Id: <20180405071500.22320-2-bsingharora@gmail.com>
In-Reply-To: <20180405071500.22320-1-bsingharora@gmail.com>
References: <20180405071500.22320-1-bsingharora@gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linuxppc-dev@lists.ozlabs.org
Cc: mpe@ellerman.id.au, npiggin@gmail.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The code currently assumes PAGE_SHIFT as the shift value of
the pfn, this works correctly (mostly) for user space pages,
but the correct thing to do is

1. Extract the shift value returned via the pte-walk API's
2. Use the shift value to access the instruction address.

Note, the final physical address still use PAGE_SHIFT for
computation. handle_ierror() is not modified and handle_derror()
is modified just for extracting the correct instruction
address.

This is largely due to __find_linux_pte() returning pfn's
shifted by pdshift. The code is much more generic and can
handle shift values returned.

Fixes: ba41e1e1ccb9 ("powerpc/mce: Hookup derror (load/store) UE errors")

Signed-off-by: Balbir Singh <bsingharora@gmail.com>
---
 arch/powerpc/kernel/mce_power.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kernel/mce_power.c b/arch/powerpc/kernel/mce_power.c
index fe6fc63251fe..bd9754def479 100644
--- a/arch/powerpc/kernel/mce_power.c
+++ b/arch/powerpc/kernel/mce_power.c
@@ -36,7 +36,8 @@
  * Convert an address related to an mm to a PFN. NOTE: we are in real
  * mode, we could potentially race with page table updates.
  */
-static unsigned long addr_to_pfn(struct pt_regs *regs, unsigned long addr)
+static unsigned long addr_to_pfn(struct pt_regs *regs, unsigned long addr,
+		unsigned int *shift)
 {
 	pte_t *ptep;
 	unsigned long flags;
@@ -49,13 +50,15 @@ static unsigned long addr_to_pfn(struct pt_regs *regs, unsigned long addr)
 
 	local_irq_save(flags);
 	if (mm == current->mm)
-		ptep = find_current_mm_pte(mm->pgd, addr, NULL, NULL);
+		ptep = find_current_mm_pte(mm->pgd, addr, NULL, shift);
 	else
-		ptep = find_init_mm_pte(addr, NULL);
+		ptep = find_init_mm_pte(addr, shift);
 	local_irq_restore(flags);
 	if (!ptep || pte_special(*ptep))
 		return ULONG_MAX;
-	return pte_pfn(*ptep);
+	if (!*shift)
+		*shift = PAGE_SHIFT;
+	return (pte_val(*ptep) & PTE_RPN_MASK) >> *shift;
 }
 
 /* flush SLBs and reload */
@@ -353,15 +356,16 @@ static int mce_find_instr_ea_and_pfn(struct pt_regs *regs, uint64_t *addr,
 	unsigned long pfn, instr_addr;
 	struct instruction_op op;
 	struct pt_regs tmp = *regs;
+	unsigned int shift;
 
-	pfn = addr_to_pfn(regs, regs->nip);
+	pfn = addr_to_pfn(regs, regs->nip, &shift);
 	if (pfn != ULONG_MAX) {
-		instr_addr = (pfn << PAGE_SHIFT) + (regs->nip & ~PAGE_MASK);
+		instr_addr = (pfn << shift) + (regs->nip & ((1 << shift) - 1));
 		instr = *(unsigned int *)(instr_addr);
 		if (!analyse_instr(&op, &tmp, instr)) {
-			pfn = addr_to_pfn(regs, op.ea);
+			pfn = addr_to_pfn(regs, op.ea, &shift);
 			*addr = op.ea;
-			*phys_addr = (pfn << PAGE_SHIFT);
+			*phys_addr = (pfn << shift);
 			return 0;
 		}
 		/*
@@ -435,12 +439,14 @@ static int mce_handle_ierror(struct pt_regs *regs,
 			if (mce_err->severity == MCE_SEV_ERROR_SYNC &&
 				table[i].error_type == MCE_ERROR_TYPE_UE) {
 				unsigned long pfn;
+				unsigned int shift;
 
 				if (get_paca()->in_mce < MAX_MCE_DEPTH) {
-					pfn = addr_to_pfn(regs, regs->nip);
+					pfn = addr_to_pfn(regs, regs->nip,
+							&shift);
 					if (pfn != ULONG_MAX) {
 						*phys_addr =
-							(pfn << PAGE_SHIFT);
+							(pfn << shift);
 						handled = 1;
 					}
 				}
-- 
2.13.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
