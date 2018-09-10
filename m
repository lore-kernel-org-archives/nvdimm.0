Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com
 [IPv6:2607:f8b0:4864:20::542])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A968321B02822
 for <linux-nvdimm@lists.01.org>; Mon, 10 Sep 2018 16:43:37 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 2-v6so11259657pgo.4
 for <linux-nvdimm@lists.01.org>; Mon, 10 Sep 2018 16:43:37 -0700 (PDT)
Subject: [PATCH 0/4] Address issues slowing persistent memory initialization
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Mon, 10 Sep 2018 16:43:35 -0700
Message-ID: <20180910232615.4068.29155.stgit@localhost.localdomain>
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
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: pavel.tatashin@microsoft.com, mhocko@suse.com, dave.hansen@intel.com, jglisse@redhat.com, akpm@linux-foundation.org, mingo@kernel.org, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

This patch set is meant to be a v3 to my earlier patch set "Address issues
slowing memory init"[1]. However I have added 2 additional patches to
address issues seen in which NVDIMM memory was slow to initialize
especially on systems with multiple NUMA nodes.

Since v2 of the patch set I have replaced the config option to work around
the page init poisoning with a kernel parameter. I also updated one comment
based on input from Michal.

The third patch in this set is new and is meant to address the need to
defer some page initialization to outside of the hot-plug lock. It is
loosely based on the original patch set by Dan Williams to perform
asynchronous page init for ZONE_DEVICE pages[2]. However, it is  based
more around the deferred page init model where memory init is deferred to a
fixed point, which in this case is to just outside of the hot-plug lock.

The fourth patch allows nvdimm init to be more node specific where
possible. I basically just copy/pasted the approach used in
pci_call_probe to allow for us to get the initialization code on the node
as close to the memory as possible. Doing so allows us to save considerably
on init time.

[1]: https://lkml.org/lkml/2018/9/5/924
[2]: https://lkml.org/lkml/2018/7/16/828

---

Alexander Duyck (4):
      mm: Provide kernel parameter to allow disabling page init poisoning
      mm: Create non-atomic version of SetPageReserved for init use
      mm: Defer ZONE_DEVICE page initialization to the point where we init pgmap
      nvdimm: Trigger the device probe on a cpu local to the device


 Documentation/admin-guide/kernel-parameters.txt |    8 ++
 drivers/nvdimm/bus.c                            |   45 ++++++++++
 include/linux/mm.h                              |    2 
 include/linux/page-flags.h                      |    9 ++
 kernel/memremap.c                               |   24 ++---
 mm/debug.c                                      |   16 +++
 mm/hmm.c                                        |   12 ++-
 mm/memblock.c                                   |    5 -
 mm/page_alloc.c                                 |  106 ++++++++++++++++++++++-
 mm/sparse.c                                     |    4 -
 10 files changed, 200 insertions(+), 31 deletions(-)

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
