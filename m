Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 312F32095D211
 for <linux-nvdimm@lists.01.org>; Tue, 20 Jun 2017 00:33:36 -0700 (PDT)
Date: Tue, 20 Jun 2017 09:34:56 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 1/2] mm: introduce bmap_walk()
Message-ID: <20170620073456.GA8453@lst.de>
References: <149766212410.22552.15957843500156182524.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149766212976.22552.11210067224152823950.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170617052212.GA8246@lst.de>
 <CAPcyv4g=x+Af1C8_q=+euwNw_Fwk3Wwe45XibtYR5=kbOcmgfg@mail.gmail.com>
 <20170618075152.GA25871@lst.de> <20170619181956.GH10672@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170619181956.GH10672@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 19, 2017 at 07:19:57PM +0100, Al Viro wrote:
> Speaking of iomap, what's supposed to happen when doing a write into what
> used to be a hole?  Suppose we have a file with a megabyte hole in it
> and there's some process mmapping that range.  Another process does
> write over the entire range.  We call ->iomap_begin() and allocate
> disk blocks.  Then we start copying data into those.  In the meanwhile,
> the first process attempts to fetch from address in the middle of that
> hole.  What should happen?

Right now the buffered iomap code expects delayed allocations.
So ->iomap_begin will only reserve block in memory, and not even
mark the blocks as allocated in the page / buffer_head.  The fact
that the block is allocated is only propagated into the page buffer_head
on a page by page basis in the actor.

> Should the blocks we'd allocated in ->iomap_begin() be immediately linked
> into the whatever indirect locks/btree/whatnot we are using?  That would
> require zeroing all of them first - otherwise that readpage will read
> uninitialized block.  Another variant would be to delay linking them
> in until ->iomap_end(), but...  Suppose we get the page evicted by
> memory pressure after the writer is finished with it.  If ->readpage()
> comes before ->iomap_end(), we'll need to somehow figure out that it's
> not a hole anymore, or we'll end up with an uptodate page full of zeroes
> observed by reads after successful write().

Delayed blocks are ignored by the read code, so it will read 'through'
them.

> The comment you've got in linux/iomap.h would seem to suggest the second
> interpretation, but neither it nor anything in Documentation discusses the
> relations with readpage/writepage...

I'll see if I can come up with some better documentation.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
