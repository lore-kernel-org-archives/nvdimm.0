Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 704032194EB7A
 for <linux-nvdimm@lists.01.org>; Thu, 20 Jun 2019 22:57:55 -0700 (PDT)
Subject: [-mm PATCH] docs/vm: Update ZONE_DEVICE memory model documentation
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 20 Jun 2019 22:43:37 -0700
Message-ID: <156109575458.1409767.1885676287099277666.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-mm@kvack.org, linux-nvdimm@lists.01.org, Mike Rapoport <rppt@linux.ibm.com>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
List-ID: <linux-nvdimm@lists.01.org>

Mike notes that Sphinx needs a newline before the start of a bulleted
list, and v10 of the subsection patch set changed the subsection size
from an arch-variable 'PMD_SIZE' to a constant 2MB.

Cc: Jonathan Corbet <corbet@lwn.net>
Reported-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Hi Andrew,

Another small fixup to fold on top of the subsection series. Thanks to
Mike for the build test, I also caught that the doc was out of date.

 Documentation/vm/memory-model.rst |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/vm/memory-model.rst b/Documentation/vm/memory-model.rst
index e0af47e02e78..58a12376b7df 100644
--- a/Documentation/vm/memory-model.rst
+++ b/Documentation/vm/memory-model.rst
@@ -205,10 +205,11 @@ subject to its memory ranges being exposed through the sysfs memory
 hotplug api on memory block boundaries. The implementation relies on
 this lack of user-api constraint to allow sub-section sized memory
 ranges to be specified to :c:func:`arch_add_memory`, the top-half of
-memory hotplug. Sub-section support allows for `PMD_SIZE` as the minimum
-alignment granularity for :c:func:`devm_memremap_pages`.
+memory hotplug. Sub-section support allows for 2MB as the cross-arch
+common alignment granularity for :c:func:`devm_memremap_pages`.
 
 The users of `ZONE_DEVICE` are:
+
 * pmem: Map platform persistent memory to be used as a direct-I/O target
   via DAX mappings.
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
