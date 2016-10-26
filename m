Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8B4E51A1DEB
 for <linux-nvdimm@lists.01.org>; Wed, 26 Oct 2016 05:34:34 -0700 (PDT)
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 082/112] x86/e820: Dont merge consecutive E820_PRAM ranges
Date: Wed, 26 Oct 2016 14:23:05 +0200
Message-Id: <20161026122308.235422020@linuxfoundation.org>
In-Reply-To: <20161026122304.797016625@linuxfoundation.org>
References: <20161026122304.797016625@linuxfoundation.org>
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
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, linux-nvdimm@lists.01.org, Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Dave Chinner <david@fromorbit.com>, stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Brian Gerst <brgerst@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

4.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 23446cb66c073b827779e5eb3dec301623299b32 upstream.

Commit:

  917db484dc6a ("x86/boot: Fix kdump, cleanup aborted E820_PRAM max_pfn manipulation")

... fixed up the broken manipulations of max_pfn in the presence of
E820_PRAM ranges.

However, it also broke the sanitize_e820_map() support for not merging
E820_PRAM ranges.

Re-introduce the enabling to keep resource boundaries between
consecutive defined ranges. Otherwise, for example, an environment that
boots with memmap=2G!8G,2G!10G will end up with a single 4G /dev/pmem0
device instead of a /dev/pmem0 and /dev/pmem1 device 2G in size.

Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Zhang Yi <yizhan@redhat.com>
Cc: linux-nvdimm@lists.01.org
Fixes: 917db484dc6a ("x86/boot: Fix kdump, cleanup aborted E820_PRAM max_pfn manipulation")
Link: http://lkml.kernel.org/r/147629530854.10618.10383744751594021268.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/e820.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -347,7 +347,7 @@ int __init sanitize_e820_map(struct e820
 		 * continue building up new bios map based on this
 		 * information
 		 */
-		if (current_type != last_type) {
+		if (current_type != last_type || current_type == E820_PRAM) {
 			if (last_type != 0)	 {
 				new_bios[new_bios_entry].size =
 					change_point[chgidx]->addr - last_addr;


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
