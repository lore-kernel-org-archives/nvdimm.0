Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0AB63823B7
 for <linux-nvdimm@lists.01.org>; Thu, 22 Dec 2016 13:19:05 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 0/4] Write protect DAX PMDs in *sync path
Date: Thu, 22 Dec 2016 14:18:52 -0700
Message-Id: <1482441536-14550-1-git-send-email-ross.zwisler@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Currently dax_mapping_entry_mkclean() fails to clean and write protect the
pmd_t of a DAX PMD entry during an *sync operation.  This can result in
data loss, as detailed in patch 4.

You can find a working tree here:

https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=dax_pmd_clean_v2

This series applies cleanly to mmotm-2016-12-19-16-31.

Changes since v1:
 - Included Dan's patch to kill DAX support for UML.
 - Instead of wrapping the DAX PMD code in dax_mapping_entry_mkclean() in
   an #ifdef, we now create a stub for pmdp_huge_clear_flush() for the case
   when CONFIG_TRANSPARENT_HUGEPAGE isn't defined. (Dan & Jan)

Dan Williams (1):
  dax: kill uml support

Ross Zwisler (3):
  dax: add stub for pmdp_huge_clear_flush()
  mm: add follow_pte_pmd()
  dax: wrprotect pmd_t in dax_mapping_entry_mkclean

 fs/Kconfig                    |  2 +-
 fs/dax.c                      | 49 ++++++++++++++++++++++++++++++-------------
 include/asm-generic/pgtable.h | 10 +++++++++
 include/linux/mm.h            |  4 ++--
 mm/memory.c                   | 41 ++++++++++++++++++++++++++++--------
 5 files changed, 79 insertions(+), 27 deletions(-)

-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
