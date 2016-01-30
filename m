Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 0/3] libnvdimm: fix memmap in pmem support
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 30 Jan 2016 10:42:03 -0800
Message-ID: <20160130184203.17558.30413.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Thanks to Jeff for pointing out a thinko in the ndctl implementation of
create-namespace.  That bug was covering up the fact that vmem_altmap
handling broke when 'pgmap_radix' was introduced to replace the list
based method [1].

The other two fixes fell out from further expanding the unit tests.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-December/003608.html

---

Dan Williams (3):
      libnvdimm: fix mode determination for e820 devices
      libnvdimm, pfn: fix restoring memmap location
      devm_memremap_pages: fix vmem_altmap lifetime + alignment handling


 drivers/nvdimm/namespace_devs.c |    8 +++++---
 drivers/nvdimm/pfn_devs.c       |    4 +---
 kernel/memremap.c               |   18 +++++++++++-------
 3 files changed, 17 insertions(+), 13 deletions(-)
