Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 95F1B21A09139
 for <linux-nvdimm@lists.01.org>; Tue, 23 May 2017 14:26:09 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 0/3] add fallback reason strings to DAX PMD path
Date: Tue, 23 May 2017 15:25:57 -0600
Message-Id: <20170523212600.26477-1-ross.zwisler@linux.intel.com>
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
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, Matthew Wilcox <mawilcox@microsoft.com>, Steven Rostedt <rostedt@goodmis.org>, linux-nvdimm@lists.01.org, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

One of the primary motivations for adding tracepoints to the DAX PMD path
was to allow the user to diagnose whether their system was actually using
PMDs, and if not to help them understand why.  For me at least this has
worked okay in some situations, but many times I find myself adding more
debugging to diagnose fallback reasons that aren't immediately obvious, or
situations where the current tracepoints are simply insufficient because
they don't give you enough information.

This series adds short fallback reason strings to the tracepoints in the
PMD path with the intention of giving the user better information about why
their system is falling back to PTEs.

So, for example, the recent case on my system was that I forgot to move my
namespace from "raw" mode to "memory" mode, which resulted in this output:

big-1046  [000] ....   103.930950: dax_pmd_fault: dev 259:0 ino 0xc shared
WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10505000 vm_start 0x10200000
vm_end 0x10700000 pgoff 0x305 max_pgoff 0x1400 

big-1046  [000] ....   103.931220: dax_pmd_insert_mapping_fallback: dev
259:0 ino 0xc shared write address 0x10505000 length 0x200000 pfn 0x24a200
DEV radix_entry 0x0

big-1046  [000] ....   103.931222: dax_pmd_fault_done: dev 259:0 ino 0xc
shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10505000 vm_start
0x10200000 vm_end 0x10700000 pgoff 0x305 max_pgoff 0x1400 FALLBACK

The issue is that the PFN_MAP flag isn't set because we're lacking struct
page for our PMEM namespace.  It's not immediately obvious why this
fallback happened, and actually you can't even diagnose it because we mask
off the pfn_t flags before printing the PFN.  :(

This new output:

big-1011  [000] ....    36.164708: dax_pmd_fault: dev 259:0 ino 0xc shared
WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10505000 vm_start 0x10200000
vm_end 0x10700000 pgoff 0x305 max_pgoff 0x1400  

big-1011  [000] ....    36.165521: dax_pmd_insert_mapping_fallback: dev
259:0 ino 0xc shared write address 0x10505000 length 0x200000 pfn
0x2000000000249200 DEV radix_entry 0x0 pfn_t not devmap

big-1011  [000] ....    36.165524: dax_pmd_fault_done: dev 259:0 ino 0xc
shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10505000 vm_start
0x10200000 vm_end 0x10700000 pgoff 0x305 max_pgoff 0x1400 FALLBACK 

adds the "pfn_t not devmap" string to the second line, telling the user
exactly what's going on.  I also stopped masking off the pfn_t flags so the
output was more complete.

My only concern is that somehow adding strings like this to tracepoint
output, brief and useful though they may be, is somehow breaking what
tracepoints are supposed to be doing.  If anyone feels strongly about this
I guess I can just keep these changes locally and try to keep enhancing the
existing output without adding strings.

Ross Zwisler (3):
  dax: add fallback reason to dax_iomap_pmd_fault()
  dax: add fallback reason to dax_pmd_insert_mapping()
  dax: add fallback reason to dax_pmd_load_hole()

 fs/dax.c                      | 76 +++++++++++++++++++++++++++++++------------
 include/trace/events/fs_dax.h | 50 +++++++++++++++++-----------
 2 files changed, 86 insertions(+), 40 deletions(-)

-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
