Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9EC9D1A1F35
 for <linux-nvdimm@lists.01.org>; Wed,  7 Sep 2016 15:29:07 -0700 (PDT)
Subject: [PATCH v2 0/2] fix cache mode tracking for pmem + dax
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 07 Sep 2016 15:26:08 -0700
Message-ID: <147328716869.35069.16311932814998156819.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Matthew Wilcox <mawilcox@microsoft.com>, David Airlie <airlied@linux.ie>, Nilesh Choudhury <nilesh.choudhury@oracle.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-mm@kvack.org, dri-devel@lists.freedesktop.org, akpm@linux-foundation.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Kai Zhang <kai.ka.zhang@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

While writing an improved changelog, as prompted by Andrew, for v1 of
"mm: fix cache mode of dax pmd mappings" [1], it struck me that
vmf_insert_pfn_pmd() is implemented correctly.  Instead, it is the
memtype tree that is missing a memtype reservation for
devm_memremap_pages() ranges.

vmf_insert_pfn_pmd() is correct to validate the memtype before inserting
a mapping, but this highlights that vm_insert_mixed() is missing this
validation.

I would still like to take patch 1 through the nvdimm.git tree, with -mm
acks, along with the device-dax fixes for v4.8-rc6.  Patch 2 can go the
typical -mm route for v4.9 since it has potential to change behavior in
its DRI usages, needs soak time in -next, and there no known memtype
conflict problems it would fix.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2016-September/006781.html

---

Dan Williams (2):
      mm: fix cache mode of dax pmd mappings
      mm: fix cache mode tracking in vm_insert_mixed()


 arch/x86/mm/pat.c |   17 ++++++++++-------
 kernel/memremap.c |    9 +++++++++
 mm/memory.c       |    8 ++++++--
 3 files changed, 25 insertions(+), 9 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
