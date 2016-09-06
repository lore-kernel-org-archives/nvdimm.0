Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 625BC1A1E63
 for <linux-nvdimm@lists.01.org>; Tue,  6 Sep 2016 09:52:19 -0700 (PDT)
Subject: [PATCH 0/5] device-dax and huge-page dax fixes for 4.8-rc6
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 06 Sep 2016 09:49:20 -0700
Message-ID: <147318056046.30325.5100892122988191500.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Nilesh Choudhury <nilesh.choudhury@oracle.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Kai Zhang <kai.ka.zhang@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

Kai and Toshi reported poor performance with huge-page dax mappings and
while debugging a few more bugs were discovered in the device-dax driver
and mm.  The following fixes target 4.8-rc6 and are tagged for -stable:

- device-dax incorrectly translates the file offset to a physical
  resource address

- show_smap() crashes on huge-page dax mappings

- huge-page dax mappings are inadvertently being marked as
  _PAGE_CACHE_MODE_UC instead of _PAGE_CACHE_MODE_WB

I would like to take this set through nvdimm.git with acks from mm folks
as there is 4.9 device-dax development that depends on these changes.

---

Dan Williams (5):
      dax: fix mapping size check
      dax: fix offset to physical address translation
      mm: fix show_smap() for zone_device-pmd ranges
      mm: fix cache mode of dax pmd mappings
      mm: cleanup pfn_t usage in track_pfn_insert()


 arch/x86/mm/pat.c             |    4 ++--
 drivers/dax/dax.c             |   12 +++++++-----
 fs/proc/task_mmu.c            |    2 ++
 include/asm-generic/pgtable.h |    4 ++--
 mm/huge_memory.c              |    6 ++----
 mm/memory.c                   |    2 +-
 6 files changed, 16 insertions(+), 14 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
