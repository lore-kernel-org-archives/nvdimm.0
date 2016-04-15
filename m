Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 093981A22E8
 for <linux-nvdimm@lists.01.org>; Thu, 14 Apr 2016 19:41:38 -0700 (PDT)
Subject: [PATCH] libnvdimm, pmem: clarify the write+clear_poison+write flow
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Apr 2016 19:40:47 -0700
Message-ID: <146068804768.24085.7722589204633361307.stgit@dwillia2-desk3.jf.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The ACPI specification does not specify the state of data after a clear
poison operation.  Potential future libnvdimm bus implementations for
other architectures also might not specify or disagree on the state of
data after clear poison.  Clarify why we write twice.

Reported-by: Jeff Moyer <jmoyer@redhat.com>
Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index c6befaa9c708..d9a0dbc2d023 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -86,6 +86,20 @@ static int pmem_do_bvec(struct pmem_device *pmem, struct page *page,
 			flush_dcache_page(page);
 		}
 	} else {
+		/*
+		 * Note that we write the data both before and after
+		 * clearing poison.  The write before clear poison
+		 * handles situations where the latest written data is
+		 * preserved and the clear poison operation simply marks
+		 * the address range as valid without changing the data.
+		 * In this case application software can assume that an
+		 * interrupted write will either return the new good
+		 * data or an error.
+		 *
+		 * However, if pmem_clear_poison() leaves the data in an
+		 * indeterminate state we need to perform the write
+		 * after clear poison.
+		 */
 		flush_dcache_page(page);
 		memcpy_to_pmem(pmem_addr, mem + off, len);
 		if (unlikely(bad_pmem)) {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
