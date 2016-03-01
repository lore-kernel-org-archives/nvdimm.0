Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 29F8A1A1E3C
 for <linux-nvdimm@lists.01.org>; Mon, 29 Feb 2016 18:56:52 -0800 (PST)
Subject: [PATCH 0/2] devm_memremap_pages vs section-misaligned pmem
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Feb 2016 18:56:20 -0800
Message-ID: <20160301025620.12812.87268.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Recent testing uncovered two bugs around the handling of section-misaligned
pmem regions:

1/ If the pmem section overlaps "System RAM" we need to fail the
   devm_memremap_pages() request.  Previously we would mis-detect a
   memory map like the following:

	100000000-37bffffff : System RAM
	37c000000-837ffffff : Persistent Memory

2/ If the pmem section is misaligned, but otherwise does not overlap
   memory from another zone, the altmap needs to be fixed up to add the
   alignment padding to the 'reserved ' pfns of the altmap.

---

Dan Williams (2):
      libnvdimm, pmem: fix 'pfn' support for section-misaligned namespaces
      mm: fix mixed zone detection in devm_memremap_pages


 drivers/nvdimm/pmem.c |   29 +++++++++++++++++++++++++++--
 kernel/memremap.c     |    9 ++++-----
 2 files changed, 31 insertions(+), 7 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
