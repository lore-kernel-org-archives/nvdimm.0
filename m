Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A1A0F2194D387
 for <linux-nvdimm@lists.01.org>; Mon,  3 Dec 2018 11:25:21 -0800 (PST)
Subject: [PATCH RFC 0/3] Fix KVM misinterpreting Reserved page as an MMIO page
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Mon, 03 Dec 2018 11:25:20 -0800
Message-ID: <154386493754.27193.1300965403157243427.stgit@ahduyck-desk1.amr.corp.intel.com>
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
To: dan.j.williams@intel.com, pbonzini@redhat.com, yi.z.zhang@linux.intel.com, brho@google.com, kvm@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: yu.c.zhang@intel.com, david@redhat.com, rkrcmar@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, jglisse@redhat.com, jack@suse.cz, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

I have loosely based this patch series off of the following patch series
from Zhang Yi:
https://lore.kernel.org/lkml/cover.1536342881.git.yi.z.zhang@linux.intel.com

The original set had attempted to address the fact that DAX pages were
treated like MMIO pages which had resulted in reduced performance. It
attempted to address this by ignoring the PageReserved flag if the page
was either a DEV_DAX or FS_DAX page.

I am proposing this as an alternative to that set. The main reason for this
is because I believe there are a few issues that were overlooked with that
original set. Specifically KVM seems to have two different uses for the
PageReserved flag. One being whether or not we can pin the memory, the other
being if we should be marking the pages as dirty or accessed. I believe
only the pinning really applies so I have split the uses of
kvm_is_reserved_pfn and updated the function uses to determine support for
page pinning to include a check of the pgmap to see if it supports pinning.

---

Alexander Duyck (3):
      kvm: Split use cases for kvm_is_reserved_pfn to kvm_is_refcounted_pfn
      mm: Add support for exposing if dev_pagemap supports refcount pinning
      kvm: Add additional check to determine if a page is refcounted


 arch/x86/kvm/mmu.c        |    6 +++---
 drivers/nvdimm/pfn_devs.c |    2 ++
 include/linux/kvm_host.h  |    2 +-
 include/linux/memremap.h  |    5 ++++-
 include/linux/mm.h        |   11 +++++++++++
 virt/kvm/kvm_main.c       |   34 +++++++++++++++++++++++++---------
 6 files changed, 46 insertions(+), 14 deletions(-)

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
