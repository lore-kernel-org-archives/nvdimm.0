Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E49A15A7
	for <nvdimm@lists.linux.dev>; Wed, 11 May 2022 02:15:36 +0000 (UTC)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
	by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C137810E66A0;
	Wed, 11 May 2022 11:48:19 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1nobSc-00AVtI-9Y; Wed, 11 May 2022 11:48:18 +1000
Date: Wed, 11 May 2022 11:48:18 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	dan.j.williams@intel.com, hch@infradead.org, jane.chu@oracle.com,
	rgoldwyn@suse.de, viro@zeniv.linux.org.uk, willy@infradead.org,
	naoya.horiguchi@nec.com, linmiaohe@huawei.com
Subject: Re: [PATCHSETS] v14 fsdax-rmap + v11 fsdax-reflink
Message-ID: <20220511014818.GE1098723@dread.disaster.area>
References: <20220508143620.1775214-1-ruansy.fnst@fujitsu.com>
 <20220511000352.GY27195@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511000352.GY27195@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=627b15e7
	a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
	a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=omOdbC7AAAAA:8
	a=7-415B0cAAAA:8 a=AXPICKo_Apo_Re-Q38cA:9 a=CjuIK1q_8ugA:10
	a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22

On Tue, May 10, 2022 at 05:03:52PM -0700, Darrick J. Wong wrote:
> On Sun, May 08, 2022 at 10:36:06PM +0800, Shiyang Ruan wrote:
> > This is a combination of two patchsets:
> >  1.fsdax-rmap: https://lore.kernel.org/linux-xfs/20220419045045.1664996-1-ruansy.fnst@fujitsu.com/
> >  2.fsdax-reflink: https://lore.kernel.org/linux-xfs/20210928062311.4012070-1-ruansy.fnst@fujitsu.com/
> > 
> >  Changes since v13 of fsdax-rmap:
> >   1. Fixed mistakes during rebasing code to latest next-
> >   2. Rebased to next-20220504
> > 
> >  Changes since v10 of fsdax-reflink:
> >   1. Rebased to next-20220504 and fsdax-rmap
> >   2. Dropped a needless cleanup patch: 'fsdax: Convert dax_iomap_zero to
> >       iter model'
> >   3. Fixed many conflicts during rebasing
> >   4. Fixed a dedupe bug in Patch 05: the actuall length to compare could be
> >       shorter than smap->length or dmap->length.
> >   PS: There are many changes during rebasing.  I think it's better to
> >       review again.
> > 
> > ==
> > Shiyang Ruan (14):
> >   fsdax-rmap:
> >     dax: Introduce holder for dax_device
> >     mm: factor helpers for memory_failure_dev_pagemap
> >     pagemap,pmem: Introduce ->memory_failure()
> >     fsdax: Introduce dax_lock_mapping_entry()
> >     mm: Introduce mf_dax_kill_procs() for fsdax case
> 
> Hmm.  This patchset touches at least the dax, pagecache, and xfs
> subsystems.  Assuming it's too late for 5.19, how should we stage this
> for 5.20?

Yeah, it's past my "last date for this merge cycle" which was
-rc6. I expected stuff might slip a little - as it has with the LARP
code - but I don't have the time and bandwidth to start working
on merging another feature from scratch before the merge window
comes around.

Getting the dax+reflink stuff in this cycle was always an optimistic
stretch, but I wanted to try so that there was no doubt it would be
ready for merge in the next cycle...

> I could just add the entire series to iomap-5.20-merge and base the
> xfs-5.20-merge off of that?  But I'm not sure what else might be landing
> in the other subsystems, so I'm open to input.

It'll need to be a stable branch somewhere, but I don't think it
really matters where al long as it's merged into the xfs for-next
tree so it gets filesystem test coverage...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
