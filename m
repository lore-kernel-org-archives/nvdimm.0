Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 79F5821B00DC1
 for <linux-nvdimm@lists.01.org>; Tue, 21 Nov 2017 11:11:36 -0800 (PST)
Subject: [PATCH v3 0/5] fix device-dax pud crash and fixup {pte, pmd,
 pud}_write
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 21 Nov 2017 11:07:36 -0800
Message-ID: <151129125625.37405.15953656230804875212.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Dave Hansen <dave.hansen@intel.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Chris Metcalf <cmetcalf@mellanox.com>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, x86@kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Ralf Baechle <ralf@linux-mips.org>, linux-mm@kvack.org, =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Ingo Molnar <mingo@redhat.com>, stable@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, "David S. Miller" <davem@davemloft.net>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v2 [1]:
* Switch from the "#define __HAVE_ARCH_PUD_WRITE" to "#define
  pud_write". This incidentally fixes a powerpc compile error.
  (Stephen)

* Add a cleanup patch to align pmd_write to the pud_write definition
  scheme.

---

Andrew,

Here is another attempt at the pud_write() fix [2], and some follow-on
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

These have received a build success notification from the 0day robot.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-November/013254.html
[2]: https://lists.01.org/pipermail/linux-nvdimm/2017-November/013237.html

---

Dan Williams (5):
      mm: fix device-dax pud write-faults triggered by get_user_pages()
      mm: switch to 'define pmd_write' instead of __HAVE_ARCH_PMD_WRITE
      mm: replace pud_write with pud_access_permitted in fault + gup paths
      mm: replace pmd_write with pmd_access_permitted in fault + gup paths
      mm: replace pte_write with pte_access_permitted in fault + gup paths


 arch/arm/include/asm/pgtable-3level.h        |    1 -
 arch/arm64/include/asm/pgtable.h             |    1 -
 arch/mips/include/asm/pgtable.h              |    2 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h |    1 -
 arch/s390/include/asm/pgtable.h              |    8 +++++++-
 arch/sparc/include/asm/pgtable_64.h          |    2 +-
 arch/sparc/mm/gup.c                          |    4 ++--
 arch/tile/include/asm/pgtable.h              |    1 -
 arch/x86/include/asm/pgtable.h               |    8 +++++++-
 fs/dax.c                                     |    3 ++-
 include/asm-generic/pgtable.h                |   12 ++++++++++--
 include/linux/hugetlb.h                      |    8 --------
 mm/gup.c                                     |    2 +-
 mm/hmm.c                                     |    8 ++++----
 mm/huge_memory.c                             |    6 +++---
 mm/memory.c                                  |    8 ++++----
 16 files changed, 42 insertions(+), 33 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
