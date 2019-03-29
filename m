Return-Path: <owner-linux-mm@kvack.org>
Subject: [PATCH 0/6] mm/devm_memremap_pages: Fix page release race
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 29 Mar 2019 08:27:24 -0700
Message-ID: <155387324370.2443841.574715745262628837.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: akpm@linux-foundation.org
Cc: Ira Weiny <ira.weiny@intel.com>, Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe <logang@deltatee.com>, Christoph Hellwig <hch@lst.de>, =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Logan audited the devm_memremap_pages() shutdown path and noticed that
it was possible to proceed to arch_remove_memory() before all
potential page references have been reaped.

Introduce a new ->cleanup() callback to do the work of waiting for any
straggling page references and then perform the percpu_ref_exit() in
devm_memremap_pages_release() context.

For p2pdma this involves some deeper reworks to reference count
resources on a per-instance basis rather than a per pci-device basis. A
modified genalloc api is introduced to convey a driver-private pointer
through gen_pool_{alloc,free}() interfaces. Also, a
devm_memunmap_pages() api is introduced since p2pdma does not
auto-release resources on a setup failure.

The dax and pmem changes pass the nvdimm unit tests, but the hmm and
p2pdma changes are compile-tested only.

Thoughts on the api changes?

I'm targeting to land this through Andrew's tree. 0day has chewed on
this for a day and reported no issues so far.

---

Dan Williams (6):
      drivers/base/devres: Introduce devm_release_action()
      mm/devm_memremap_pages: Introduce devm_memunmap_pages
      pci/p2pdma: Fix the gen_pool_add_virt() failure path
      lib/genalloc: Introduce chunk owners
      pci/p2pdma: Track pgmap references per resource, not globally
      mm/devm_memremap_pages: Fix final page put race


 drivers/base/devres.c             |   24 ++++++++
 drivers/dax/device.c              |   13 +----
 drivers/nvdimm/pmem.c             |   17 +++++-
 drivers/pci/p2pdma.c              |  105 +++++++++++++++++++++++--------------
 include/linux/device.h            |    1 
 include/linux/genalloc.h          |   55 +++++++++++++++++--
 include/linux/memremap.h          |    8 +++
 kernel/memremap.c                 |   23 ++++++--
 lib/genalloc.c                    |   51 +++++++++---------
 mm/hmm.c                          |   14 +----
 tools/testing/nvdimm/test/iomap.c |    2 +
 11 files changed, 209 insertions(+), 104 deletions(-)
