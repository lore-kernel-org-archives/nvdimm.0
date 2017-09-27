Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2592521F322BE
 for <linux-nvdimm@lists.01.org>; Wed, 27 Sep 2017 16:52:48 -0700 (PDT)
Subject: [PATCH 0/3] dax: require 'struct page' and other fixups
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 Sep 2017 16:49:38 -0700
Message-ID: <150655617774.700.5326522538400299973.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Prompted by a recent change to add more protection around setting up
'vm_flags' for a dax vma [1], rework the implementation to remove the
requirement to set VM_MIXEDMAP and VM_HUGEPAGE.

VM_MIXEDMAP is used by dax to direct mm paths like vm_normal_page() that
the memory page it is dealing with is not typical memory from the linear
map. The get_user_pages_fast() path, since it does not resolve the vma,
is already using {pte,pmd}_devmap() as a stand-in for VM_MIXEDMAP, so we
use that as a VM_MIXEDMAP replacement in some locations. In the cases
where there is no pte to consult we fallback to using vma_is_dax() to
detect the VM_MIXEDMAP special case.

This patch series passes a run of the ndctl unit test suite and the
'mmap.sh' [2] test in particular. 'mmap.sh' tries to catch dependencies
on VM_MIXEDMAP and {pte,pmd}_devmap().

[1]: https://lkml.org/lkml/2017/9/25/638
[2]: https://github.com/pmem/ndctl/blob/master/test/mmap.sh

---

Dan Williams (3):
      dax: disable filesystem dax on devices that do not map pages
      dax: stop using VM_MIXEDMAP for dax
      dax: stop using VM_HUGEPAGE for dax


 drivers/dax/device.c |    1 -
 drivers/dax/super.c  |    7 +++++++
 fs/ext2/file.c       |    1 -
 fs/ext4/file.c       |    1 -
 fs/xfs/xfs_file.c    |    2 --
 mm/huge_memory.c     |    8 ++++----
 mm/ksm.c             |    3 +++
 mm/madvise.c         |    2 +-
 mm/memory.c          |   20 ++++++++++++++++++--
 mm/migrate.c         |    3 ++-
 mm/mlock.c           |    3 ++-
 mm/mmap.c            |    5 +++--
 12 files changed, 40 insertions(+), 16 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
