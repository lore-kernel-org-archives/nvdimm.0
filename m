Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 24 May 2017 14:22:11 +0900
From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Subject: Re: [PATCH 0/3] add fallback reason strings to DAX PMD path
In-Reply-To: <20170523212600.26477-1-ross.zwisler@linux.intel.com>
References: <20170523212600.26477-1-ross.zwisler@linux.intel.com>
Message-Id: <20170524142156.3831.61FB500B@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, Matthew Wilcox <mawilcox@microsoft.com>, Steven Rostedt <rostedt@goodmis.org>, linux-nvdimm@lists.01.org, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Hi Ross,

On Tue, 23 May 2017 15:25:57 -0600 Ross Zwisler wrote:
> One of the primary motivations for adding tracepoints to the DAX PMD path
> was to allow the user to diagnose whether their system was actually using
> PMDs, and if not to help them understand why.  For me at least this has
> worked okay in some situations, but many times I find myself adding more
> debugging to diagnose fallback reasons that aren't immediately obvious, or
> situations where the current tracepoints are simply insufficient because
> they don't give you enough information.
> 
> This series adds short fallback reason strings to the tracepoints in the
> PMD path with the intention of giving the user better information about why
> their system is falling back to PTEs.
> 
> So, for example, the recent case on my system was that I forgot to move my
> namespace from "raw" mode to "memory" mode, which resulted in this output:
> 
> big-1046  [000] ....   103.930950: dax_pmd_fault: dev 259:0 ino 0xc shared
> WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10505000 vm_start 0x10200000
> vm_end 0x10700000 pgoff 0x305 max_pgoff 0x1400 
> 
> big-1046  [000] ....   103.931220: dax_pmd_insert_mapping_fallback: dev
> 259:0 ino 0xc shared write address 0x10505000 length 0x200000 pfn 0x24a200
> DEV radix_entry 0x0
> 
> big-1046  [000] ....   103.931222: dax_pmd_fault_done: dev 259:0 ino 0xc
> shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10505000 vm_start
> 0x10200000 vm_end 0x10700000 pgoff 0x305 max_pgoff 0x1400 FALLBACK
> 
> The issue is that the PFN_MAP flag isn't set because we're lacking struct
> page for our PMEM namespace.  It's not immediately obvious why this
> fallback happened, and actually you can't even diagnose it because we mask
> off the pfn_t flags before printing the PFN.  :(
> 
> This new output:
> 
> big-1011  [000] ....    36.164708: dax_pmd_fault: dev 259:0 ino 0xc shared
> WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10505000 vm_start 0x10200000
> vm_end 0x10700000 pgoff 0x305 max_pgoff 0x1400  
> 
> big-1011  [000] ....    36.165521: dax_pmd_insert_mapping_fallback: dev
> 259:0 ino 0xc shared write address 0x10505000 length 0x200000 pfn
> 0x2000000000249200 DEV radix_entry 0x0 pfn_t not devmap
> 
> big-1011  [000] ....    36.165524: dax_pmd_fault_done: dev 259:0 ino 0xc
> shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x10505000 vm_start
> 0x10200000 vm_end 0x10700000 pgoff 0x305 max_pgoff 0x1400 FALLBACK 
> 
> adds the "pfn_t not devmap" string to the second line, telling the user
> exactly what's going on.  I also stopped masking off the pfn_t flags so the
> output was more complete.

I think this idea is good. How about adding a suffix to be easy for grep?
For example the suffix, DAX_FAULT_.

And, to simplify the code, how about moving the string of fault reason
to include/trace/events/fs_dax.h, like as include/trace/events/kvm.h?

Regards,
Masayoshi Mizuma

> 
> My only concern is that somehow adding strings like this to tracepoint
> output, brief and useful though they may be, is somehow breaking what
> tracepoints are supposed to be doing.  If anyone feels strongly about this
> I guess I can just keep these changes locally and try to keep enhancing the
> existing output without adding strings.
> 
> Ross Zwisler (3):
>   dax: add fallback reason to dax_iomap_pmd_fault()
>   dax: add fallback reason to dax_pmd_insert_mapping()
>   dax: add fallback reason to dax_pmd_load_hole()
> 
>  fs/dax.c                      | 76 +++++++++++++++++++++++++++++++------------
>  include/trace/events/fs_dax.h | 50 +++++++++++++++++-----------
>  2 files changed, 86 insertions(+), 40 deletions(-)
> 
> -- 
> 2.9.4
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
