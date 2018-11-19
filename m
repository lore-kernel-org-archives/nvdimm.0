Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2A4AA2118F79F
 for <linux-nvdimm@lists.01.org>; Mon, 19 Nov 2018 03:06:50 -0800 (PST)
Subject: Patch "acpi/nfit,
 x86/mce: Validate a MCE's address before using it" has been added to
 the 4.18-stable tree
From: <gregkh@linuxfoundation.org>
Date: Mon, 19 Nov 2018 12:05:15 +0100
Message-ID: <154262551558181@kroah.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: 20181026003729.8420-2-vishal.l.verma@intel.com, arnd@arndb.de, bp@suse.de, dan.j.williams@intel.com, dave.jiang@intel.com, elliott@hpe.com, gregkh@linuxfoundation.org, hpa@zytor.com, lenb@kernel.org, linux-nvdimm@lists.01.org, mingo@redhat.com, qiuxu.zhuo@intel.com, rjw@rjwysocki.net, tglx@linutronix.de, tony.luck@intel.comvishal.l.verma@intel.com, x86@kernel.org, yazen.ghannam@amd.com, zwisler@kernel.org
Cc: stable-commits@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>


This is a note to let you know that I've just added the patch titled

    acpi/nfit, x86/mce: Validate a MCE's address before using it

to the 4.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     acpi-nfit-x86-mce-validate-a-mce-s-address-before-using-it.patch
and it can be found in the queue-4.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From e8a308e5f47e545e0d41d0686c00f5f5217c5f61 Mon Sep 17 00:00:00 2001
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Thu, 25 Oct 2018 18:37:29 -0600
Subject: acpi/nfit, x86/mce: Validate a MCE's address before using it

From: Vishal Verma <vishal.l.verma@intel.com>

commit e8a308e5f47e545e0d41d0686c00f5f5217c5f61 upstream.

The NFIT machine check handler uses the physical address from the mce
structure, and compares it against information in the ACPI NFIT table
to determine whether that location lies on an NVDIMM. The mce->addr
field however may not always be valid, and this is indicated by the
MCI_STATUS_ADDRV bit in the status field.

Export mce_usable_address() which already performs validation for the
address, and use it in the NFIT handler.

Fixes: 6839a6d96f4e ("nfit: do an ARS scrub on hitting a latent media error")
Reported-by: Robert Elliott <elliott@hpe.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
CC: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Williams <dan.j.williams@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>
CC: elliott@hpe.com
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: Len Brown <lenb@kernel.org>
CC: linux-acpi@vger.kernel.org
CC: linux-edac <linux-edac@vger.kernel.org>
CC: linux-nvdimm@lists.01.org
CC: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Ross Zwisler <zwisler@kernel.org>
CC: stable <stable@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Tony Luck <tony.luck@intel.com>
CC: x86-ml <x86@kernel.org>
CC: Yazen Ghannam <yazen.ghannam@amd.com>
Link: http://lkml.kernel.org/r/20181026003729.8420-2-vishal.l.verma@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/mce.h       |    1 +
 arch/x86/kernel/cpu/mcheck/mce.c |    3 ++-
 drivers/acpi/nfit/mce.c          |    4 ++++
 3 files changed, 7 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -217,6 +217,7 @@ static inline int umc_normaddr_to_sysadd
 int mce_available(struct cpuinfo_x86 *c);
 bool mce_is_memory_error(struct mce *m);
 bool mce_is_correctable(struct mce *m);
+int mce_usable_address(struct mce *m);
 
 DECLARE_PER_CPU(unsigned, mce_exception_count);
 DECLARE_PER_CPU(unsigned, mce_poll_count);
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -489,7 +489,7 @@ static void mce_report_event(struct pt_r
  * be somewhat complicated (e.g. segment offset would require an instruction
  * parser). So only support physical addresses up to page granuality for now.
  */
-static int mce_usable_address(struct mce *m)
+int mce_usable_address(struct mce *m)
 {
 	if (!(m->status & MCI_STATUS_ADDRV))
 		return 0;
@@ -509,6 +509,7 @@ static int mce_usable_address(struct mce
 
 	return 1;
 }
+EXPORT_SYMBOL_GPL(mce_usable_address);
 
 bool mce_is_memory_error(struct mce *m)
 {
--- a/drivers/acpi/nfit/mce.c
+++ b/drivers/acpi/nfit/mce.c
@@ -29,6 +29,10 @@ static int nfit_handle_mce(struct notifi
 	if (!mce_is_memory_error(mce) || mce_is_correctable(mce))
 		return NOTIFY_DONE;
 
+	/* Verify the address reported in the MCE is valid. */
+	if (!mce_usable_address(mce))
+		return NOTIFY_DONE;
+
 	/*
 	 * mce->addr contains the physical addr accessed that caused the
 	 * machine check. We need to walk through the list of NFITs, and see


Patches currently in stable-queue which might be from vishal.l.verma@intel.com are

queue-4.18/acpi-nfit-x86-mce-validate-a-mce-s-address-before-using-it.patch
queue-4.18/acpi-nfit-x86-mce-handle-only-uncorrectable-machine-checks.patch
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
