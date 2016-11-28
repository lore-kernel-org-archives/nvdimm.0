Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8AE8381D16
 for <linux-nvdimm@lists.01.org>; Mon, 28 Nov 2016 14:46:52 -0800 (PST)
Date: Mon, 28 Nov 2016 15:46:51 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 3/6] dax: add tracepoint infrastructure, PMD tracing
Message-ID: <20161128224651.GA1243@linux.intel.com>
References: <1479926662-21718-1-git-send-email-ross.zwisler@linux.intel.com>
 <1479926662-21718-4-git-send-email-ross.zwisler@linux.intel.com>
 <20161125030059.GY31101@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161125030059.GY31101@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 25, 2016 at 02:00:59PM +1100, Dave Chinner wrote:
> On Wed, Nov 23, 2016 at 11:44:19AM -0700, Ross Zwisler wrote:
> > Tracepoints are the standard way to capture debugging and tracing
> > information in many parts of the kernel, including the XFS and ext4
> > filesystems.  Create a tracepoint header for FS DAX and add the first DAX
> > tracepoints to the PMD fault handler.  This allows the tracing for DAX to
> > be done in the same way as the filesystem tracing so that developers can
> > look at them together and get a coherent idea of what the system is doing.
> > 
> > I added both an entry and exit tracepoint because future patches will add
> > tracepoints to child functions of dax_iomap_pmd_fault() like
> > dax_pmd_load_hole() and dax_pmd_insert_mapping(). We want those messages to
> > be wrapped by the parent function tracepoints so the code flow is more
> > easily understood.  Having entry and exit tracepoints for faults also
> > allows us to easily see what filesystems functions were called during the
> > fault.  These filesystem functions get executed via iomap_begin() and
> > iomap_end() calls, for example, and will have their own tracepoints.
> > 
> > For PMD faults we primarily want to understand the faulting address and
> > whether it fell back to 4k faults.  If it fell back to 4k faults the
> > tracepoints should let us understand why.
> > 
> > I named the new tracepoint header file "fs_dax.h" to allow for device DAX
> > to have its own separate tracing header in the same directory at some
> > point.
> > 
> > Here is an example output for these events from a successful PMD fault:
> > 
> > big-2057  [000] ....   136.396855: dax_pmd_fault: shared mapping write
> > address 0x10505000 vm_start 0x10200000 vm_end 0x10700000 pgoff 0x200
> > max_pgoff 0x1400
> > 
> > big-2057  [000] ....   136.397943: dax_pmd_fault_done: shared mapping write
> > address 0x10505000 vm_start 0x10200000 vm_end 0x10700000 pgoff 0x200
> > max_pgoff 0x1400 NOPAGE
> 
> Can we make the output use the same format as most of the filesystem
> code? i.e. the output starts with backing device + inode number like
> so:
> 
> 	xfs_ilock:            dev 8:96 ino 0x493 flags ILOCK_EXCL....
> 
> This way we can filter the output easily across both dax and
> filesystem tracepoints with 'grep "ino 0x493"'...

I think I can include the inode number, which I have via mapping->host.  Am I
correct in assuming "struct inode.i_ino" will always be the same as
"struct xfs_inode.i_ino"?

Unfortunately I don't have access to the major/minor (the dev_t) until I call
iomap_begin().  Currently we call iomap_begin() only after we've done most of
our sanity checking that would cause us to fall back to PTEs.

I don't think we want to reorder things so that we start with an iomap_begin()
- that would mean that we would begin by asking the filesystem for a block
allocation, when in many cases we would then do an alignment check or
something similar and then fall back to PTEs.

I'll add "ino" to the output so it looks something like this:

big-2057  [000] ....   136.397943: dax_pmd_fault_done: ino 0x493 shared
mapping write address 0x10505000 vm_start 0x10200000 vm_end 0x10700000 pgoff
0x200 max_pgoff 0x1400 NOPAGE
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
