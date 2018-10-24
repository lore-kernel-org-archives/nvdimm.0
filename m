Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BC2F121959CB2
 for <linux-nvdimm@lists.01.org>; Wed, 24 Oct 2018 13:02:54 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] nfit, mce: only handle uncorrectable machine checks
Date: Wed, 24 Oct 2018 14:01:48 -0600
Message-Id: <20181024200148.12597-1-vishal.l.verma@intel.com>
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

We only want a machine check error to be added to libnvdimm's 'badblock'
if it was an uncorrectable error. Currently we insert both corrected and
uncorrectable errors. Add a check in the nfit mce handler to filter out
corrected mce events.

Reported-by: Omar Avelar <omar.avelar@intel.com>
Fixes: 6839a6d96f4e ("nfit: do an ARS scrub on hitting a latent media error")
Cc: stable@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 arch/x86/include/asm/mce.h       | 1 +
 arch/x86/kernel/cpu/mcheck/mce.c | 3 ++-
 drivers/acpi/nfit/mce.c          | 4 ++--
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 3a17107594c8..3111b3cee2ee 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -216,6 +216,7 @@ static inline int umc_normaddr_to_sysaddr(u64 norm_addr, u16 nid, u8 umc, u64 *s
 
 int mce_available(struct cpuinfo_x86 *c);
 bool mce_is_memory_error(struct mce *m);
+bool mce_is_correctable(struct mce *m);
 
 DECLARE_PER_CPU(unsigned, mce_exception_count);
 DECLARE_PER_CPU(unsigned, mce_poll_count);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 953b3ce92dcc..27015948bc41 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -534,7 +534,7 @@ bool mce_is_memory_error(struct mce *m)
 }
 EXPORT_SYMBOL_GPL(mce_is_memory_error);
 
-static bool mce_is_correctable(struct mce *m)
+bool mce_is_correctable(struct mce *m)
 {
 	if (m->cpuvendor == X86_VENDOR_AMD && m->status & MCI_STATUS_DEFERRED)
 		return false;
@@ -544,6 +544,7 @@ static bool mce_is_correctable(struct mce *m)
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(mce_is_correctable);
 
 static bool cec_add_mce(struct mce *m)
 {
diff --git a/drivers/acpi/nfit/mce.c b/drivers/acpi/nfit/mce.c
index e9626bf6ca29..7a51707f87e9 100644
--- a/drivers/acpi/nfit/mce.c
+++ b/drivers/acpi/nfit/mce.c
@@ -25,8 +25,8 @@ static int nfit_handle_mce(struct notifier_block *nb, unsigned long val,
 	struct acpi_nfit_desc *acpi_desc;
 	struct nfit_spa *nfit_spa;
 
-	/* We only care about memory errors */
-	if (!mce_is_memory_error(mce))
+	/* We only care about uncorrectable memory errors */
+	if (!mce_is_memory_error(mce) || mce_is_correctable(mce))
 		return NOTIFY_DONE;
 
 	/*
-- 
2.17.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
