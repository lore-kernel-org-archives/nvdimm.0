Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id F0D761A1E5A
 for <linux-nvdimm@lists.01.org>; Wed, 23 Mar 2016 13:49:59 -0700 (PDT)
Date: Wed, 23 Mar 2016 16:50:14 -0400
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [RFC v2] [PATCH 0/10] DAX page fault locking
Message-ID: <20160323205014.GW23727@linux.intel.com>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
 <20160321174103.GP23727@linux.intel.com>
 <20160323150939.GK4512@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160323150939.GK4512@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, "Wilcox, Matthew R  <matthew.r.wilcox@intel.com>, NeilBrown <neilb@suse.com>, Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 23, 2016 at 04:09:39PM +0100, Jan Kara wrote:
> On Mon 21-03-16 13:41:03, Matthew Wilcox wrote:
> > On Mon, Mar 21, 2016 at 02:22:45PM +0100, Jan Kara wrote:
> > > The basic idea is that we use a bit in an exceptional radix tree entry as
> > > a lock bit and use it similarly to how page lock is used for normal faults.
> > > That way we fix races between hole instantiation and read faults of the
> > > same index. For now I have disabled PMD faults since there the issues with
> > > page fault locking are even worse. Now that Matthew's multi-order radix tree
> > > has landed, I can have a look into using that for proper locking of PMD faults
> > > but first I want normal pages sorted out.
> > 
> > FYI, the multi-order radix tree code that landed is unusably buggy.
> > Ross and I have been working like madmen for the past three weeks to fix
> > all of the bugs we've found and not introduce new ones.  The radix tree
> > test suite has been enormously helpful in this regard, but we're still
> > finding corner cases (thanks, RCU! ;-)
> > 
> > Our current best effort can be found hiding in
> > http://git.infradead.org/users/willy/linux-dax.git/shortlog/refs/heads/radix-fixes-2016-03-15
> > but it's for sure not ready for review yet.  I just don't want other
> > people trying to use the facility and wasting their time.
> 
> So when looking through the fixes I was wondering: Are really sibling
> entries worth it? Won't the result be simpler if we just used
> RADIX_TREE_MAP_SHIFT == 9? We would need to put slot pointers out of
> radix_tree_node structure (there'd be full page worth of them) but that's
> easy. More complications probably come from the fact that we don't want
> that unconditionally since radix tree for small files would consume
> considerably more memory and that could be an issue for some systems. For
> DAX as such we don't really care I think, at least for now, but for normal
> page cache we do. So we would have to make RADIX_TREE_MAP_SHIFT
> per-radix-tree property. What do you think? I can try to write some patches
> if you'd consider it's worth it...

I haven't tried it yet.  I think one of the problems is that there may be
architectures which have PMD_SHIFT-PAGE_SHIFT != PUD_SHIFT-PMD_SHIFT.
I have started evolving the radix tree code towards something
that can support variable height nodes (check the latest head of
radix-fixes-2016-03-15), but I didn't consider splitting the slot array
out of the radix_tree_node.

It'd absolutely be possible to mix different order nodes within the same
tree, but the problem becomes deciding when to use which shift at which
level.  If the first insertion is an order-9 entry, then that's easy, but
if you already have a few order-0 entries in a few places in an order-6
based tree then converting that tree to be order-9 based could be tricky.

Do we really want to introduce another pointer follow operation at each
level of the radix tree?  It'd be partially compensated for by having
fewer levels.  Eg: a file with 1TB entries (and 4k pages) would have 28
bits used for index.  With the current 6-bit MAP_SHIFT, that's 5 levels.
With a 9-bit MAP_SHIFT, that's 4 levels, or 8 indirections.  I seem to
have picked the worst possible case out of thin air there ;-)  A 512GB
file would also use 5 levels with a 6-bit MAP_SHIFT and only 3 with a
9-bit MAP_SHIFT (which would be 6 indirections).

Another way we could go here is removing all the metadata from the
tree, so that each level is only a page.  We could have a metadata tree
that shadows its structure and contains the parent, shift, tags, etc.
That way the lookup would be fast and the less common operations would
be slower.

I'm going to keep going with the sibling entries, but feel free to try
other ways of organising the radix tree!  May the best one win (and may
we all contribute to the test suite ...)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
