Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7DB6521951C86
 for <linux-nvdimm@lists.01.org>; Wed, 26 Apr 2017 01:52:41 -0700 (PDT)
Date: Wed, 26 Apr 2017 10:52:35 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] dax: fix data corruption due to stale mmap reads
Message-ID: <20170426085235.GA21738@quack2.suse.cz>
References: <20170420191446.GA21694@linux.intel.com>
 <20170421034437.4359-1-ross.zwisler@linux.intel.com>
 <20170421034437.4359-2-ross.zwisler@linux.intel.com>
 <20170425111043.GH2793@quack2.suse.cz>
 <20170425225936.GA29655@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170425225936.GA29655@linux.intel.com>
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
Cc: Latchesar Ionkov <lucho@ionkov.net>, Jan Kara <jack@suse.cz>, Trond Myklebust <trond.myklebust@primarydata.com>, linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>, linux-cifs@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Eric Van Hensbergen <ericvh@gmail.com>, linux-nvdimm@lists.01.org, Alexander Viro <viro@zeniv.linux.org.uk>, v9fs-developer@lists.sourceforge.net, Jens Axboe <axboe@kernel.dk>, linux-nfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>, Alexey Kuznetsov <kuznet@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel@vger.kernel.org, Ron Minnich <rminnich@sandia.gov>, Andrew Morton <akpm@linux-foundation.org>, Anna Schumaker <anna.schumaker@netapp.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 25-04-17 16:59:36, Ross Zwisler wrote:
> On Tue, Apr 25, 2017 at 01:10:43PM +0200, Jan Kara wrote:
> <>
> > Hum, but now thinking more about it I have hard time figuring out why write
> > vs fault cannot actually still race:
> > 
> > CPU1 - write(2)				CPU2 - read fault
> > 
> > 					dax_iomap_pte_fault()
> > 					  ->iomap_begin() - sees hole
> > dax_iomap_rw()
> >   iomap_apply()
> >     ->iomap_begin - allocates blocks
> >     dax_iomap_actor()
> >       invalidate_inode_pages2_range()
> >         - there's nothing to invalidate
> > 					  grab_mapping_entry()
> > 					  - we add zero page in the radix
> > 					    tree & map it to page tables
> > 
> > Similarly read vs write fault may end up racing in a wrong way and try to
> > replace already existing exceptional entry with a hole page?
> 
> Yep, this race seems real to me, too.  This seems very much like the issues
> that exist when a thread is doing direct I/O.  One thread is doing I/O to an
> intermediate buffer (page cache for direct I/O case, zero page for us), and
> the other is going around it directly to media, and they can get out of sync.
> 
> IIRC the direct I/O code looked something like:
> 
> 1/ invalidate existing mappings
> 2/ do direct I/O to media
> 3/ invalidate mappings again, just in case.  Should be cheap if there weren't
>    any conflicting faults.  This makes sure any new allocations we made are
>    faulted in.

Yeah, the problem is people generally expect weird behavior when they mix
direct and buffered IO (or let alone mmap) however everyone expects
standard read(2) and write(2) to be completely coherent with mmap(2).

> I guess one option would be to replicate that logic in the DAX I/O path, or we
> could try and enhance our locking so page faults can't race with I/O since
> both can allocate blocks.

In the abstract way, the problem is that we have radix tree (and page
tables) cache block mapping information and the operation: "read block
mapping information, store it in the radix tree" is not serialized in any
way against other block allocations so the information we store can be out
of date by the time we store it.

One way to solve this would be to move ->iomap_begin call in the fault
paths under entry lock although that would mean I have to redo how ext4
handles DAX faults because with current code it would create lock inversion
wrt transaction start.

Another solution would be to grab i_mmap_sem for write when doing write
fault of a page and similarly have it grabbed for writing when doing
write(2). This would scale rather poorly but if we later replaced it with a
range lock (Davidlohr has already posted a nice implementation of it) it
won't be as bad. But I guess option 1) is better...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
