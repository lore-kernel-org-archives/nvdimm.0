Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ED93D81ED4
 for <linux-nvdimm@lists.01.org>; Thu, 24 Nov 2016 01:16:30 -0800 (PST)
Date: Thu, 24 Nov 2016 10:16:26 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/6] dax: add tracepoint infrastructure, PMD tracing
Message-ID: <20161124091626.GC24138@quack2.suse.cz>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 23-11-16 11:44:19, Ross Zwisler wrote:
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
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Dave Chinner <david@fromorbit.com>

Looks good. Just one minor comment:

> +	TP_printk("%s mapping %s address %#lx vm_start %#lx vm_end %#lx "
> +		"pgoff %#lx max_pgoff %#lx %s",
> +		__entry->vm_flags & VM_SHARED ? "shared" : "private",
> +		__entry->flags & FAULT_FLAG_WRITE ? "write" : "read",
> +		__entry->address,
> +		__entry->vm_start,
> +		__entry->vm_end,
> +		__entry->pgoff,
> +		__entry->max_pgoff,
> +		__print_flags(__entry->result, "|", VM_FAULT_RESULT_TRACE)
> +	)
> +)

I think it may be useful to dump full 'flags', not just FAULT_FLAG_WRITE...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
