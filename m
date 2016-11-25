Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
 [150.101.137.143]) by ml01.01.org (Postfix) with ESMTP id CE56081EAB
 for <linux-nvdimm@lists.01.org>; Thu, 24 Nov 2016 19:01:09 -0800 (PST)
Date: Fri, 25 Nov 2016 14:00:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] dax: add tracepoint infrastructure, PMD tracing
Message-ID: <20161125030059.GY31101@dastard>
References: <1479926662-21718-1-git-send-email-ross.zwisler@linux.intel.com>
 <1479926662-21718-4-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1479926662-21718-4-git-send-email-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 23, 2016 at 11:44:19AM -0700, Ross Zwisler wrote:
> Tracepoints are the standard way to capture debugging and tracing
> information in many parts of the kernel, including the XFS and ext4
> filesystems.  Create a tracepoint header for FS DAX and add the first DAX
> tracepoints to the PMD fault handler.  This allows the tracing for DAX to
> be done in the same way as the filesystem tracing so that developers can
> look at them together and get a coherent idea of what the system is doing.
> 
> I added both an entry and exit tracepoint because future patches will add
> tracepoints to child functions of dax_iomap_pmd_fault() like
> dax_pmd_load_hole() and dax_pmd_insert_mapping(). We want those messages to
> be wrapped by the parent function tracepoints so the code flow is more
> easily understood.  Having entry and exit tracepoints for faults also
> allows us to easily see what filesystems functions were called during the
> fault.  These filesystem functions get executed via iomap_begin() and
> iomap_end() calls, for example, and will have their own tracepoints.
> 
> For PMD faults we primarily want to understand the faulting address and
> whether it fell back to 4k faults.  If it fell back to 4k faults the
> tracepoints should let us understand why.
> 
> I named the new tracepoint header file "fs_dax.h" to allow for device DAX
> to have its own separate tracing header in the same directory at some
> point.
> 
> Here is an example output for these events from a successful PMD fault:
> 
> big-2057  [000] ....   136.396855: dax_pmd_fault: shared mapping write
> address 0x10505000 vm_start 0x10200000 vm_end 0x10700000 pgoff 0x200
> max_pgoff 0x1400
> 
> big-2057  [000] ....   136.397943: dax_pmd_fault_done: shared mapping write
> address 0x10505000 vm_start 0x10200000 vm_end 0x10700000 pgoff 0x200
> max_pgoff 0x1400 NOPAGE

Can we make the output use the same format as most of the filesystem
code? i.e. the output starts with backing device + inode number like
so:

	xfs_ilock:            dev 8:96 ino 0x493 flags ILOCK_EXCL....

This way we can filter the output easily across both dax and
filesystem tracepoints with 'grep "ino 0x493"'...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
