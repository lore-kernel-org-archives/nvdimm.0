Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 29E9D21F3882A
 for <linux-nvdimm@lists.01.org>; Thu, 12 Oct 2017 23:53:47 -0700 (PDT)
Date: Fri, 13 Oct 2017 08:57:16 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v9 0/6] MAP_DIRECT for DAX userspace flush
Message-ID: <20171013065716.GB26461@lst.de>
References: <150776922692.9144.16963640112710410217.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171012142319.GA11254@lst.de>
 <CAPcyv4gTON__Ohop0B5R2gsKXC71bycTBozqGmF3WmwG9C6LVA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gTON__Ohop0B5R2gsKXC71bycTBozqGmF3WmwG9C6LVA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux API <linux-api@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 12, 2017 at 10:41:39AM -0700, Dan Williams wrote:
> So, you're jumping into this review at v9 where I've split the patches
> that take an initial MAP_DIRECT lease out from the patches that take
> FL_LAYOUT leases at memory registration time. You can see a previous
> attempt in "[PATCH v8 00/14] MAP_DIRECT for DAX RDMA and userspace
> flush" which should be in your inbox.

The point is that your problem has absolutely nothing to do with mmap,
and all with get_user_pages.

get_user_pages on DAX doesn't give the same guarantees as on pagecache
or anonymous memory, and that is the prbolem we need to fix.  In fact
I'm pretty sure if we try hard enough (and we might have to try
very hard) we can see the same problem with plain direct I/O and without
any RDMA involved, e.g. do a larger direct I/O write to memory that is
mmap()ed from a DAX file, then truncate the DAX file and reallocate
the blocks, and we might corrupt that new file.  We'll probably need
a special setup where there is little other chance but to reallocate
those used blocks.

So what we need to do first is to fix get_user_pages vs unmapping
DAX mmap()ed blocks, be that from a hole punch, truncate, COW
operation, etc.

Then we need to look into the special case of a long-living non-transient
get_user_pages that RDMA does - we can't just reject any truncate or
other operation for that, so that's where something like me layout
lease suggestion comes into play - but the call that should get the
least is not the mmap - it's the memory registration call that does
the get_user_pages.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
