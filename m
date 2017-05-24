Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1D391219FFEF8
 for <linux-nvdimm@lists.01.org>; Wed, 24 May 2017 02:03:36 -0700 (PDT)
Date: Wed, 24 May 2017 11:03:32 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] add fallback reason strings to DAX PMD path
Message-ID: <20170524090332.GC10604@quack2.suse.cz>
References: <20170523212600.26477-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170523212600.26477-1-ross.zwisler@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 23-05-17 15:25:57, Ross Zwisler wrote:
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

So I don't like adding strings into tracepoints. It just seems too close to
debug printk. After all if you need detailed information for debugging some
particular bug, you can always add kprobe tracepoint at particular
instruction in the function.

Probably my objection boils down to the fact that I don't think tracepoints
in DAX code are for a normal user. They expose lot of details about the
implementation and once users start depending on a particular tracepoint,
it becomes part of the kernel API and cannot be changed which will be
very inconvenient for DAX implementation. I think these tracepoints are for
kernel developers to be able to diagnose what's going on and I'm willing to
impose some thinking burden on those ;).

Also looking at the reasons you've added most of them can already be
detected from the information output by the tracepoint so it seems mostly
like a duplicit information. So my opinion is: If you need more information
like whether pfn is from devmap, make that visible in the tracepoint (like
add pfn flags to the output). Sure the reason for fallback isn't
immediately visible but if you really wonder, you go through conditions in
the code, verify them against the data from the tracepoint and you should
be able to find the reason... If there are some common fallback paths that
you'd think are worth detecting and it's not easy to add information to the
final tracepoint, then we can add a specific tracepoint to that branch.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
