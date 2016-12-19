Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2A936820D8
 for <linux-nvdimm@lists.01.org>; Mon, 19 Dec 2016 08:46:02 -0800 (PST)
Date: Mon, 19 Dec 2016 09:46:00 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v3 0/5] introduce DAX tracepoint support
Message-ID: <20161219164600.GA21334@linux.intel.com>
References: <1480610271-23699-1-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1480610271-23699-1-git-send-email-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 01, 2016 at 09:37:46AM -0700, Ross Zwisler wrote:
> Tracepoints are the standard way to capture debugging and tracing
> information in many parts of the kernel, including the XFS and ext4
> filesystems.  This series creates a tracepoint header for FS DAX and add
> the first few DAX tracepoints to the PMD fault handler.  This allows the
> tracing for DAX to be done in the same way as the filesystem tracing so
> that developers can look at them together and get a coherent idea of what
> the system is doing.
> 
> I do intend to add tracepoints to the normal 4k DAX fault path and to the
> DAX I/O path, but I wanted to get feedback on the PMD tracepoints before I
> went any further.
> 
> This series is based on Jan Kara's "dax: Clear dirty bits after flushing
> caches" series:
> 
> https://lists.01.org/pipermail/linux-nvdimm/2016-November/007864.html
> 
> I've pushed a git tree with this work here:
> 
> https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=dax_tracepoints_v3
> 
> Changes since v2:
>  - Dropped "dax: remove leading space from labels" patch. (Jan)
>  - Reordered TP_STRUCT__entry() fields so that all the 64 bit entries (for
>    64 bit machines) come first, followed by the 32 bit entries.  This
>    allows for optimal packing of the entires. (Steve)
>  - Fixed 'mask' in trace_print_flags_seq_u64() to be an unsigned long long.
>    (Steve)
> 
> Ross Zwisler (5):
>   tracing: add __print_flags_u64()
>   dax: add tracepoint infrastructure, PMD tracing
>   dax: update MAINTAINERS entries for FS DAX
>   dax: add tracepoints to dax_pmd_load_hole()
>   dax: add tracepoints to dax_pmd_insert_mapping()
> 
>  MAINTAINERS                   |   5 +-
>  fs/dax.c                      |  56 ++++++++++-----
>  include/linux/mm.h            |  25 +++++++
>  include/linux/pfn_t.h         |   6 ++
>  include/linux/trace_events.h  |   4 ++
>  include/trace/events/fs_dax.h | 161 ++++++++++++++++++++++++++++++++++++++++++
>  include/trace/trace_events.h  |  11 +++
>  kernel/trace/trace_output.c   |  38 ++++++++++
>  8 files changed, 288 insertions(+), 18 deletions(-)
>  create mode 100644 include/trace/events/fs_dax.h

Ping on this series - Dave, were you planning on sending this for v4.10-rc1?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
