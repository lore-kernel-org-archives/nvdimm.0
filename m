Return-Path: <owner-linux-mm@kvack.org>
Subject: [PATCH 0/2] device-dax: fix unaligned munmap handling
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 21 Nov 2017 14:42:55 -0800
Message-ID: <151130417573.4029.6745923267963684469.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Andrew,

Here is another device-dax fix that requires touching some mm code. When
device-dax is operating in huge-page mode we want it to behave like
hugetlbfs and fail attempts to split vmas into unaligned ranges. It
would be messy to teach the munmap path about device-dax alignment
constraints in the same (hstate) way that hugetlbfs communicates this
constraint. Instead, these patches introduce a new ->split() vm
operation.

---

Dan Williams (2):
      mm, hugetlbfs: introduce ->split() to vm_operations_struct
      device-dax: implement ->split() to catch invalid munmap attempts


 drivers/dax/device.c |   12 ++++++++++++
 include/linux/mm.h   |    1 +
 mm/hugetlb.c         |    8 ++++++++
 mm/mmap.c            |    8 +++++---
 4 files changed, 26 insertions(+), 3 deletions(-)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
