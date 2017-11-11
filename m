Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 82EEC21B00DE2
 for <linux-nvdimm@lists.01.org>; Fri, 10 Nov 2017 16:48:37 -0800 (PST)
Subject: [PATCH 0/4] fix device-dax pud crash and fixup {pte,pmd,pud}_write
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 10 Nov 2017 16:44:25 -0800
Message-ID: <151036106541.32713.16875776773735515483.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Dave Hansen <dave.hansen@intel.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-mm@kvack.org, =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, "David S. Miller" <davem@davemloft.net>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Andrew,

Here is a new version to the pud_write() fix [1], and some follow-on
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

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-November/013237.html

---

Dan Williams (4):
      mm: fix device-dax pud write-faults triggered by get_user_pages()
      mm: replace pud_write with pud_access_permitted in fault + gup paths
      mm: replace pmd_write with pmd_access_permitted in fault + gup paths
      mm: replace pte_write with pte_access_permitted in fault + gup paths


 arch/sparc/mm/gup.c            |    4 ++--
 arch/x86/include/asm/pgtable.h |    6 ++++++
 fs/dax.c                       |    3 ++-
 include/asm-generic/pgtable.h  |    9 +++++++++
 include/linux/hugetlb.h        |    8 --------
 mm/gup.c                       |    2 +-
 mm/hmm.c                       |    8 ++++----
 mm/huge_memory.c               |    6 +++---
 mm/memory.c                    |    8 ++++----
 9 files changed, 31 insertions(+), 23 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
