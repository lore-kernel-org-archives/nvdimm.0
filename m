Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 333DF2117FD58
 for <linux-nvdimm@lists.01.org>; Mon,  5 Nov 2018 13:19:26 -0800 (PST)
Subject: [mm PATCH v5 0/7] Deferred page init improvements
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Mon, 05 Nov 2018 13:19:25 -0800
Message-ID: <154145268025.30046.11742652345962594283.stgit@ahduyck-desk1.jf.intel.com>
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
To: akpm@linux-foundation.org, linux-mm@kvack.org
Cc: pavel.tatashin@microsoft.com, mhocko@suse.com, linux-nvdimm@lists.01.org, alexander.h.duyck@linux.intel.com, linux-kernel@vger.kernel.org, willy@infradead.org, mingo@kernel.org, khalid.aziz@oracle.com, rppt@linux.vnet.ibm.com, vbabka@suse.cz, sparclinux@vger.kernel.org, ldufour@linux.vnet.ibm.com, mgorman@techsingularity.net, davem@davemloft.net, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

This patchset is essentially a refactor of the page initialization logic
that is meant to provide for better code reuse while providing a
significant improvement in deferred page initialization performance.

In my testing on an x86_64 system with 384GB of RAM and 3TB of persistent
memory per node I have seen the following. In the case of regular memory
initialization the deferred init time was decreased from 3.75s to 1.06s on
average. For the persistent memory the initialization time dropped from
24.17s to 19.12s on average. This amounts to a 253% improvement for the
deferred memory initialization performance, and a 26% improvement in the
persistent memory initialization performance.

I have called out the improvement observed with each patch.

v1->v2:
    Fixed build issue on PowerPC due to page struct size being 56
    Added new patch that removed __SetPageReserved call for hotplug
v2->v3:
    Rebased on latest linux-next
    Removed patch that had removed __SetPageReserved call from init
    Added patch that folded __SetPageReserved into set_page_links
    Tweaked __init_pageblock to use start_pfn to get section_nr instead of pfn
v3->v4:
    Updated patch description and comments for mm_zero_struct_page patch
        Replaced "default" with "case 64"
        Removed #ifndef mm_zero_struct_page
    Fixed typo in comment that ommited "_from" in kerneldoc for iterator
    Added Reviewed-by for patches reviewed by Pavel
    Added Acked-by from Michal Hocko
    Added deferred init times for patches that affect init performance
    Swapped patches 5 & 6, pulled some code/comments from 4 into 5
v4->v5:
    Updated Acks/Reviewed-by
    Rebased on latest linux-next
    Split core bits of zone iterator patch from MAX_ORDER_NR_PAGES init

---

Alexander Duyck (7):
      mm: Use mm_zero_struct_page from SPARC on all 64b architectures
      mm: Drop meminit_pfn_in_nid as it is redundant
      mm: Implement new zone specific memblock iterator
      mm: Initialize MAX_ORDER_NR_PAGES at a time instead of doing larger sections
      mm: Move hot-plug specific memory init into separate functions and optimize
      mm: Add reserved flag setting to set_page_links
      mm: Use common iterator for deferred_init_pages and deferred_free_pages


 arch/sparc/include/asm/pgtable_64.h |   30 --
 include/linux/memblock.h            |   38 ++
 include/linux/mm.h                  |   50 +++
 mm/memblock.c                       |   63 ++++
 mm/page_alloc.c                     |  567 +++++++++++++++++++++--------------
 5 files changed, 492 insertions(+), 256 deletions(-)

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
