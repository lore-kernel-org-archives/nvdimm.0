Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 45C3621A07A92
 for <linux-nvdimm@lists.01.org>; Mon, 19 Nov 2018 08:42:28 -0800 (PST)
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.18 073/171] acpi/nfit,
 x86/mce: Handle only uncorrectable machine checks
Date: Mon, 19 Nov 2018 17:27:49 +0100
Message-Id: <20181119162631.442303192@linuxfoundation.org>
In-Reply-To: <20181119162618.909354448@linuxfoundation.org>
References: <20181119162618.909354448@linuxfoundation.org>
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
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <zwisler@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Omar Avelar <omar.avelar@intel.com>, linux-nvdimm@lists.01.org, x86-ml <x86@kernel.org>, linux-acpi@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Len Brown <lenb@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Tony Luck <tony.luck@intel.com>, linux-edac <linux-edac@vger.kernel.org>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, stable@vger.kernel.org, Yazen Ghannam <yazen.ghannam@amd.com>
List-ID: <linux-nvdimm@lists.01.org>

4.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishal Verma <vishal.l.verma@intel.com>

commit 5d96c9342c23ee1d084802dcf064caa67ecaa45b upstream.

The MCE handler for nfit devices is called for memory errors on a
Non-Volatile DIMM and adds the error location to a 'badblocks' list.
This list is used by the various NVDIMM drivers to avoid consuming known
poison locations during IO.

The MCE handler gets called for both corrected and uncorrectable errors.
Until now, both kinds of errors have been added to the badblocks list.
However, corrected memory errors indicate that the problem has already
been fixed by hardware, and the resulting interrupt is merely a
notification to Linux.

As far as future accesses to that location are concerned, it is
perfectly fine to use, and thus doesn't need to be included in the above
badblocks list.

Add a check in the nfit MCE handler to filter out corrected mce events,
and only process uncorrectable errors.

Fixes: 6839a6d96f4e ("nfit: do an ARS scrub on hitting a latent media error")
Reported-by: Omar Avelar <omar.avelar@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Dan Williams <dan.j.williams@intel.com>
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
Link: http://lkml.kernel.org/r/20181026003729.8420-1-vishal.l.verma@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/mce.h       |    1 +
 arch/x86/kernel/cpu/mcheck/mce.c |    3 ++-
 drivers/acpi/nfit/mce.c          |    4 ++--
 3 files changed, 5 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -216,6 +216,7 @@ static inline int umc_normaddr_to_sysadd
 
 int mce_available(struct cpuinfo_x86 *c);
 bool mce_is_memory_error(struct mce *m);
+bool mce_is_correctable(struct mce *m);
 
 DECLARE_PER_CPU(unsigned, mce_exception_count);
 DECLARE_PER_CPU(unsigned, mce_poll_count);
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -538,7 +538,7 @@ bool mce_is_memory_error(struct mce *m)
 }
 EXPORT_SYMBOL_GPL(mce_is_memory_error);
 
-static bool mce_is_correctable(struct mce *m)
+bool mce_is_correctable(struct mce *m)
 {
 	if (m->cpuvendor == X86_VENDOR_AMD && m->status & MCI_STATUS_DEFERRED)
 		return false;
@@ -548,6 +548,7 @@ static bool mce_is_correctable(struct mc
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(mce_is_correctable);
 
 static bool cec_add_mce(struct mce *m)
 {
--- a/drivers/acpi/nfit/mce.c
+++ b/drivers/acpi/nfit/mce.c
@@ -25,8 +25,8 @@ static int nfit_handle_mce(struct notifi
 	struct acpi_nfit_desc *acpi_desc;
 	struct nfit_spa *nfit_spa;
 
-	/* We only care about memory errors */
-	if (!mce_is_memory_error(mce))
+	/* We only care about uncorrectable memory errors */
+	if (!mce_is_memory_error(mce) || mce_is_correctable(mce))
 		return NOTIFY_DONE;
 
 	/*


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
