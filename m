Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D5B2D207DF2AA
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 14:51:08 -0700 (PDT)
Subject: [PATCH v5 09/11] x86/mm/pat: Prepare {reserve,
 free}_memtype() for "decoy" addresses
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 04 Jul 2018 14:41:11 -0700
Message-ID: <153074047123.27838.4050356397245428561.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153074042316.27838.17319837331947007626.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <153074042316.27838.17319837331947007626.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Tony Luck <tony.luck@intel.com>, jack@suse.cz, x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, hch@lst.de, linux-edac@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for using set_memory_uc() instead set_memory_np() for
isolating poison from speculation, teach the memtype code to sanitize
physical addresses vs __PHYSICAL_MASK.

The motivation for using set_memory_uc() for this case is to allow
ongoing access to persistent memory pages via the pmem-driver +
memcpy_mcsafe() until the poison is repaired.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: <linux-edac@vger.kernel.org>
Cc: <x86@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/mm/pat.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 1555bd7d3449..6788ffa990f8 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -512,6 +512,17 @@ static int free_ram_pages_type(u64 start, u64 end)
 	return 0;
 }
 
+static u64 sanitize_phys(u64 address)
+{
+	/*
+	 * When changing the memtype for pages containing poison allow
+	 * for a "decoy" virtual address (bit 63 clear) passed to
+	 * set_memory_X(). __pa() on a "decoy" address results in a
+	 * physical address with it 63 set.
+	 */
+	return address & __PHYSICAL_MASK;
+}
+
 /*
  * req_type typically has one of the:
  * - _PAGE_CACHE_MODE_WB
@@ -533,6 +544,8 @@ int reserve_memtype(u64 start, u64 end, enum page_cache_mode req_type,
 	int is_range_ram;
 	int err = 0;
 
+	start = sanitize_phys(start);
+	end = sanitize_phys(end);
 	BUG_ON(start >= end); /* end is exclusive */
 
 	if (!pat_enabled()) {
@@ -609,6 +622,9 @@ int free_memtype(u64 start, u64 end)
 	if (!pat_enabled())
 		return 0;
 
+	start = sanitize_phys(start);
+	end = sanitize_phys(end);
+
 	/* Low ISA region is always mapped WB. No need to track */
 	if (x86_platform.is_untracked_pat_range(start, end))
 		return 0;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
