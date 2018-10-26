Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CD28E2117B575
 for <linux-nvdimm@lists.01.org>; Thu, 25 Oct 2018 17:37:49 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v3 2/2] nfit, mce: validate the mce->addr before using it
Date: Thu, 25 Oct 2018 18:37:29 -0600
Message-Id: <20181026003729.8420-2-vishal.l.verma@intel.com>
In-Reply-To: <20181026003729.8420-1-vishal.l.verma@intel.com>
References: <20181026003729.8420-1-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Tony Luck <tony.luck@intel.com>, stable@vger.kernel.org, Borislav Petkov <bp@alien8.de>, linux-edac@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The NFIT machine check handler uses the physical address from the 'mce'
structure, and compares it against information in the ACPI NFIT table to
determine whether that location lies on an NVDIMM. The mce->addr field
however may not always be valid, and this is indicated by the
MCI_STATUS_ADDRV bit in the status field.

Export mce_usable_address() which already performs validation for the
address, and use it in the NFIT handler.

Reported-by: Robert Elliott <elliott@hpe.com>
Fixes: 6839a6d96f4e ("nfit: do an ARS scrub on hitting a latent media error")
Cc: stable@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 arch/x86/include/asm/mce.h       | 1 +
 arch/x86/kernel/cpu/mcheck/mce.c | 3 ++-
 drivers/acpi/nfit/mce.c          | 4 ++++
 3 files changed, 7 insertions(+), 1 deletion(-)

v3: Add this patch to address the address validation (Robert)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 3111b3cee2ee..eb786f90f2d3 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -217,6 +217,7 @@ static inline int umc_normaddr_to_sysaddr(u64 norm_addr, u16 nid, u8 umc, u64 *s
 int mce_available(struct cpuinfo_x86 *c);
 bool mce_is_memory_error(struct mce *m);
 bool mce_is_correctable(struct mce *m);
+int mce_usable_address(struct mce *m);
 
 DECLARE_PER_CPU(unsigned, mce_exception_count);
 DECLARE_PER_CPU(unsigned, mce_poll_count);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 27015948bc41..cdbedeb3f3db 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -485,7 +485,7 @@ static void mce_report_event(struct pt_regs *regs)
  * be somewhat complicated (e.g. segment offset would require an instruction
  * parser). So only support physical addresses up to page granuality for now.
  */
-static int mce_usable_address(struct mce *m)
+int mce_usable_address(struct mce *m)
 {
 	if (!(m->status & MCI_STATUS_ADDRV))
 		return 0;
@@ -505,6 +505,7 @@ static int mce_usable_address(struct mce *m)
 
 	return 1;
 }
+EXPORT_SYMBOL_GPL(mce_usable_address);
 
 bool mce_is_memory_error(struct mce *m)
 {
diff --git a/drivers/acpi/nfit/mce.c b/drivers/acpi/nfit/mce.c
index 7a51707f87e9..d943ed50f0b4 100644
--- a/drivers/acpi/nfit/mce.c
+++ b/drivers/acpi/nfit/mce.c
@@ -29,6 +29,10 @@ static int nfit_handle_mce(struct notifier_block *nb, unsigned long val,
 	if (!mce_is_memory_error(mce) || mce_is_correctable(mce))
 		return NOTIFY_DONE;
 
+	/* Verify the address reported in the mce is valid */
+	if (!mce_usable_address(mce))
+		return NOTIFY_DONE;
+
 	/*
 	 * mce->addr contains the physical addr accessed that caused the
 	 * machine check. We need to walk through the list of NFITs, and see
-- 
2.17.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
