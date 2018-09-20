Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2F7EC21148ECD
 for <linux-nvdimm@lists.01.org>; Thu, 20 Sep 2018 15:24:21 -0700 (PDT)
Subject: [PATCH v4 0/5] Address issues slowing persistent memory initialization
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Thu, 20 Sep 2018 15:24:09 -0700
Message-ID: <20180920215824.19464.8884.stgit@localhost.localdomain>
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

This patch set is meant to be a v4 to my earlier patch set "Address issues
slowing memory init"[1], and a follow-up to my earlier patch set "Address
issues slowing persistent memory initialization"[2].

Excluding any gains seen from using the vm_debug option to disable page
init poisoning I see a total reduction in file-system init time of about
two and a half minutes, or 65%, for a system initializing btrfs on a 12TB
block of persistent memory split evenly over 4 NUMA nodes.

Since the last patch set I have reworked the first patch to provide a more
generic disable implementation that can be extended in the future.

I tweaked the commit message for the second patch slightly to reflect why
we might want to use a non-atomic __set_bit versus the atomic set_bit.

I have modified the third patch to make it so that it can merge onto either
the linux git tree or the linux-next git tree. The patch set that Dan
Williams has outstanding may end up conflicting with this patch depending
on the merge order. If his are merged first I believe the code I changed
in mm/hmm.c could be dropped entirely.

The fourth patch has been split into two and focused more on the async
scheduling portion of the nvdimm code. The result is much cleaner than the
original approach in that instead of having two threads running we are now
getting the thread running where we wanted it to be.

The last change for all patches is that I have updated my email address to
alexander.h.duyck@linux.intel.com to reflect the fact that I have changed
teams within Intel. I will be trying to use that for correspondence going
forward instead of my gmail account.

[1]: https://lkml.org/lkml/2018/9/5/924
[2]: https://lkml.org/lkml/2018/9/11/10
[3]: https://lkml.org/lkml/2018/9/13/104

---

Alexander Duyck (5):
      mm: Provide kernel parameter to allow disabling page init poisoning
      mm: Create non-atomic version of SetPageReserved for init use
      mm: Defer ZONE_DEVICE page initialization to the point where we init pgmap
      async: Add support for queueing on specific node
      nvdimm: Schedule device registration on node local to the device


 Documentation/admin-guide/kernel-parameters.txt |   12 +++
 drivers/nvdimm/bus.c                            |   19 ++++
 include/linux/async.h                           |   20 ++++-
 include/linux/mm.h                              |    2 
 include/linux/page-flags.h                      |    9 ++
 kernel/async.c                                  |   36 ++++++--
 kernel/memremap.c                               |   24 ++---
 mm/debug.c                                      |   46 ++++++++++
 mm/hmm.c                                        |   12 ++-
 mm/memblock.c                                   |    5 -
 mm/page_alloc.c                                 |  101 ++++++++++++++++++++++-
 mm/sparse.c                                     |    4 -
 12 files changed, 243 insertions(+), 47 deletions(-)

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
