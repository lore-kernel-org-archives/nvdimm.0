Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 154A4821E6
 for <linux-nvdimm@lists.01.org>; Wed, 22 Feb 2017 02:52:02 -0800 (PST)
Date: Wed, 22 Feb 2017 11:51:56 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/6] second round of tracepoints for DAX
Message-ID: <20170222105156.GC23312@quack2.suse.cz>
References: <20170221195116.13278-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170221195116.13278-1-ross.zwisler@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 21-02-17 12:51:10, Ross Zwisler wrote:
> This second round of DAX tracepoint patches adds tracing to the PTE fault
> path (dax_iomap_pte_fault(), dax_pfn_mkwrite(), dax_load_hole(),
> dax_insert_mapping()) and to the writeback path
> (dax_writeback_mapping_range(), dax_writeback_one()).
> 
> The purpose of this tracing is to give us a high level view of what DAX is
> doing, whether faults are being serviced by PMDs or PTEs, and by real
> storage or by zero pages covering holes.
> 
> I do have some patches nearly ready which also add tracing to
> grab_mapping_entry() and dax_insert_mapping_entry().  These are more
> targeted at logging how we are interacting with the radix tree, how we use
> empty entries for locking, whether we "downgrade" huge zero pages to
> 4k PTE sized allocations, etc.  In the end it seemed to me that this might
> be too detailed to have as constantly present tracepoints, but if anyone
> sees value in having tracepoints like this in the DAX code permanently
> (Jan?), please let me know and I'll add those last two patches.

Yeah, for now I think it is too detailed and high-level logging is good
enough. As we will debug problems, we may find places that are useful for
more detailed tracepoints but for now what you added looks fine.

> All these tracepoints were done to be consistent with the style of the XFS
> tracepoints and with the existing DAX PMD tracepoints.
> 
> This series applies cleanly to the current mmots/master:
> 
> commit 35aa45ffe8d9 ("pci: test for unexpectedly disabled bridges")
> 
> and I'm hoping that it'll end up going to Linus through akpm's -mm tree.

I like the patches and they look fine to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
