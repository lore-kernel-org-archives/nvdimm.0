Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51C1715B0
	for <nvdimm@lists.linux.dev>; Fri, 23 Sep 2022 01:36:45 +0000 (UTC)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
	by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E8C368AA501;
	Fri, 23 Sep 2022 11:36:35 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1obXcI-00B0jP-E9; Fri, 23 Sep 2022 11:36:34 +1000
Date: Fri, 23 Sep 2022 11:36:34 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, akpm@linux-foundation.org,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2 10/18] fsdax: Manage pgmap references at entry
 insertion and deletion
Message-ID: <20220923013634.GY3600936@dread.disaster.area>
References: <166329936739.2786261.14035402420254589047.stgit@dwillia2-xfh.jf.intel.com>
 <YysZrdF/BSQhjWZs@nvidia.com>
 <632b2b4edd803_66d1a2941a@dwillia2-xfh.jf.intel.com.notmuch>
 <632b8470d34a6_34962946d@dwillia2-xfh.jf.intel.com.notmuch>
 <YyuLLsindwo0prz4@nvidia.com>
 <632ba8eaa5aea_349629422@dwillia2-xfh.jf.intel.com.notmuch>
 <YyurdXnW7SyEndHV@nvidia.com>
 <632bc5c4363e9_349629486@dwillia2-xfh.jf.intel.com.notmuch>
 <YyyhrTxFJZlMGYY6@nvidia.com>
 <632cd9a2a023_3496294da@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <632cd9a2a023_3496294da@dwillia2-xfh.jf.intel.com.notmuch>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=632d0da5
	a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
	a=kj9zAlcOel0A:10 a=xOM3xZuef0cA:10 a=7-415B0cAAAA:8
	a=HMkrczR5A4c5RoH6gtYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22

On Thu, Sep 22, 2022 at 02:54:42PM -0700, Dan Williams wrote:
> Jason Gunthorpe wrote:
> > On Wed, Sep 21, 2022 at 07:17:40PM -0700, Dan Williams wrote:
> > > Jason Gunthorpe wrote:
> > > > On Wed, Sep 21, 2022 at 05:14:34PM -0700, Dan Williams wrote:
> > > > 
> > > > > > Indeed, you could reasonably put such a liveness test at the moment
> > > > > > every driver takes a 0 refcount struct page and turns it into a 1
> > > > > > refcount struct page.
> > > > > 
> > > > > I could do it with a flag, but the reason to have pgmap->ref managed at
> > > > > the page->_refcount 0 -> 1 and 1 -> 0 transitions is so at the end of
> > > > > time memunmap_pages() can look at the one counter rather than scanning
> > > > > and rescanning all the pages to see when they go to final idle.
> > > > 
> > > > That makes some sense too, but the logical way to do that is to put some
> > > > counter along the page_free() path, and establish a 'make a page not
> > > > free' path that does the other side.
> > > > 
> > > > ie it should not be in DAX code, it should be all in common pgmap
> > > > code. The pgmap should never be freed while any page->refcount != 0
> > > > and that should be an intrinsic property of pgmap, not relying on
> > > > external parties.
> > > 
> > > I just do not know where to put such intrinsics since there is nothing
> > > today that requires going through the pgmap object to discover the pfn
> > > and 'allocate' the page.
> > 
> > I think that is just a new API that wrappers the set refcount = 1,
> > percpu refcount and maybe building appropriate compound pages too.
> > 
> > Eg maybe something like:
> > 
> >   struct folio *pgmap_alloc_folios(pgmap, start, length)
> > 
> > And you get back maximally sized allocated folios with refcount = 1
> > that span the requested range.
> > 
> > > In other words make dax_direct_access() the 'allocation' event that pins
> > > the pgmap? I might be speaking a foreign language if you're not familiar
> > > with the relationship of 'struct dax_device' to 'struct dev_pagemap'
> > > instances. This is not the first time I have considered making them one
> > > in the same.
> > 
> > I don't know enough about dax, so yes very foreign :)
> > 
> > I'm thinking broadly about how to make pgmap usable to all the other
> > drivers in a safe and robust way that makes some kind of logical sense.
> 
> I think the API should be pgmap_folio_get() because, at least for DAX,
> the memory is already allocated. The 'allocator' for fsdax is the
> filesystem block allocator, and pgmap_folio_get() grants access to a

No, the "allocator" for fsdax is the inode iomap interface, not the
filesystem block allocator. The filesystem block allocator is only
involved in iomapping if we have to allocate a new mapping for a
given file offset.

A better name for this is "arbiter", not allocator.  To get an
active mapping of the DAX pages backing a file, we need to ask the
inode iomap subsystem to *map a file offset* and it will return
kaddr and/or pfns for the backing store the file offset maps to.

IOWs, for FSDAX, access to the backing store (i.e. the physical pages) is
arbitrated by the *inode*, not the filesystem allocator or the dax
device. Hence if a subsystem needs to pin the backing store for some
use, it must first ensure that it holds an inode reference (direct
or indirect) for that range of the backing store that will spans the
life of the pin. When the pin is done, it can tear down the mappings
it was using and then the inode reference can be released.

This ensures that any racing unlink of the inode will not result in
the backing store being freed from under the application that has a
pin. It will prevent the inode from being reclaimed and so
potentially accessing stale or freed in-memory structures. And it
will prevent the filesytem from being unmounted while the
application using FSDAX access is still actively using that
functionality even if it's already closed all it's fds....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
