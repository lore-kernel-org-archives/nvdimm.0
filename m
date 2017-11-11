Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A28E420356876
 for <linux-nvdimm@lists.01.org>; Sat, 11 Nov 2017 12:15:45 -0800 (PST)
Subject: [PATCH v2 0/4] fix device-dax pud crash and fixup {pte, pmd,
 pud}_write
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 11 Nov 2017 12:11:34 -0800
Message-ID: <151043109403.2842.11607911965674122836.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: akpm@linux-foundation.org
Cc: Arnd Bergmann <arnd@arndb.de>, Dave Hansen <dave.hansen@intel.com>, Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>, linux-mm@kvack.org, =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Ingo Molnar <mingo@redhat.com>, stable@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, "David S. Miller" <davem@davemloft.net>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Changes since v1 [1]:
* fix arm64 compilation, add __HAVE_ARCH_PUD_WRITE
* fix sparc64 compilation, add __HAVE_ARCH_PUD_WRITE
* fix s390 compilation, add a pud_write() helper

---

Andrew,

Here is a third version to the pud_write() fix [2], and some follow-on
patches to use the '_access_permitted' helpers in fault and
get_user_pages() paths where we are checking if the thread has access to
write. I explicitly omit conversions for places where the kernel is
checking the _PAGE_RW flag for kernel purposes, not for userspace
access.

Beyond fixing the crash, this series also fixes get_user_pages() and
fault paths to honor protection keys in the same manner as
get_user_pages_fast(). Only the crash fix is tagged for -stable as the
protection key check is done just for consistency reasons since
userspace can change protection keys at will.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-November/013249.html
[2]: https://lists.01.org/pipermail/linux-nvdimm/2017-November/013237.html

---

Dan Williams (4):
      mm: fix device-dax pud write-faults triggered by get_user_pages()
      mm: replace pud_write with pud_access_permitted in fault + gup paths
      mm: replace pmd_write with pmd_access_permitted in fault + gup paths
      mm: replace pte_write with pte_access_permitted in fault + gup paths


 arch/arm64/include/asm/pgtable.h    |    1 +
 arch/s390/include/asm/pgtable.h     |    6 ++++++
 arch/sparc/include/asm/pgtable_64.h |    1 +
 arch/sparc/mm/gup.c                 |    4 ++--
 arch/x86/include/asm/pgtable.h      |    6 ++++++
 fs/dax.c                            |    3 ++-
 include/asm-generic/pgtable.h       |    9 +++++++++
 include/linux/hugetlb.h             |    8 --------
 mm/gup.c                            |    2 +-
 mm/hmm.c                            |    8 ++++----
 mm/huge_memory.c                    |    6 +++---
 mm/memory.c                         |    8 ++++----
 12 files changed, 39 insertions(+), 23 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
