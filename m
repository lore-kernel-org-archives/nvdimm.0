Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EB6A481F1A
 for <linux-nvdimm@lists.01.org>; Thu,  1 Dec 2016 07:39:41 -0800 (PST)
Date: Thu, 1 Dec 2016 08:39:40 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 3/6] dax: add tracepoint infrastructure, PMD tracing
Message-ID: <20161201153940.GC5160@linux.intel.com>
References: <1480549533-29038-1-git-send-email-ross.zwisler@linux.intel.com>
 <1480549533-29038-4-git-send-email-ross.zwisler@linux.intel.com>
 <20161201091628.7057580f@gandalf.local.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161201091628.7057580f@gandalf.local.home>
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
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 01, 2016 at 09:16:28AM -0500, Steven Rostedt wrote:
> On Wed, 30 Nov 2016 16:45:30 -0700
> Ross Zwisler <ross.zwisler@linux.intel.com> wrote:
> 
> 
> > --- /dev/null
> > +++ b/include/trace/events/fs_dax.h
> > @@ -0,0 +1,68 @@
> > +#undef TRACE_SYSTEM
> > +#define TRACE_SYSTEM fs_dax
> > +
> > +#if !defined(_TRACE_FS_DAX_H) || defined(TRACE_HEADER_MULTI_READ)
> > +#define _TRACE_FS_DAX_H
> > +
> > +#include <linux/tracepoint.h>
> > +
> > +DECLARE_EVENT_CLASS(dax_pmd_fault_class,
> > +	TP_PROTO(struct inode *inode, struct vm_area_struct *vma,
> > +		unsigned long address, unsigned int flags, pgoff_t pgoff,
> > +		pgoff_t max_pgoff, int result),
> > +	TP_ARGS(inode, vma, address, flags, pgoff, max_pgoff, result),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(unsigned long, ino)
> > +		__field(unsigned long, vm_start)
> > +		__field(unsigned long, vm_end)
> > +		__field(unsigned long, vm_flags)
> > +		__field(unsigned long, address)
> > +		__field(unsigned int, flags)
> > +		__field(pgoff_t, pgoff)
> > +		__field(pgoff_t, max_pgoff)
> > +		__field(int, result)
> 
> For better compaction, I would put flags and result together, as they
> are both ints. Otherwise, you'll probably have 4 empty bytes after
> flags.

Sure, will do for v3.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
