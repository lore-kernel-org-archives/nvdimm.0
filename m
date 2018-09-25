Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 66C90211575C8
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 13:18:10 -0700 (PDT)
Subject: [PATCH v5 0/4] Address issues slowing persistent memory initialization
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Tue, 25 Sep 2018 13:18:08 -0700
Message-ID: <20180925200551.3576.18755.stgit@localhost.localdomain>
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
To: linux-mm@kvack.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: pavel.tatashin@microsoft.com, mhocko@suse.com, dave.hansen@intel.com, jglisse@redhat.com, rppt@linux.vnet.ibm.com, mingo@kernel.org, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

This patch set is meant to be a v5 of my earlier submission with the same
title[1].

The main changes from the previous version are that I have added a new
patch to address an issue that had disabled deferred memory init on my
system due to recent config changes related to CONFIG_NO_BOOTMEM. In
addition I dropped the original patches 4 and 5 from the previous set as
that is going to need to be a separate set of patches.

The main thing this patch set achieves is that it allows us to initialize
each node worth of persistent memory independently. As a result we reduce
page init time by about 2 minutes because instead of taking 30 to 40 seconds
per node and going through each node one at a time, we process all 4 nodes
in parallel in the case of a 12TB persistent memory setup spread evenly over
4 nodes.

[1]: https://lkml.org/lkml/2018/9/21/4
---

Alexander Duyck (4):
      mm: Remove now defunct NO_BOOTMEM from depends list for deferred init
      mm: Provide kernel parameter to allow disabling page init poisoning
      mm: Create non-atomic version of SetPageReserved for init use
      mm: Defer ZONE_DEVICE page initialization to the point where we init pgmap


 Documentation/admin-guide/kernel-parameters.txt |   12 +++
 arch/csky/Kconfig                               |    1 
 include/linux/mm.h                              |    2 
 include/linux/page-flags.h                      |    9 ++
 kernel/memremap.c                               |   24 ++---
 mm/Kconfig                                      |    1 
 mm/debug.c                                      |   46 ++++++++++
 mm/hmm.c                                        |   12 ++-
 mm/memblock.c                                   |    5 -
 mm/page_alloc.c                                 |  101 ++++++++++++++++++++++-
 mm/sparse.c                                     |    4 -
 11 files changed, 184 insertions(+), 33 deletions(-)

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
