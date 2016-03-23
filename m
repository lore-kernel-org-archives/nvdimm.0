Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 352511A1E53
 for <linux-nvdimm@lists.01.org>; Wed, 23 Mar 2016 08:09:38 -0700 (PDT)
Date: Wed, 23 Mar 2016 16:09:39 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC v2] [PATCH 0/10] DAX page fault locking
Message-ID: <20160323150939.GK4512@quack.suse.cz>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
 <20160321174103.GP23727@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160321174103.GP23727@linux.intel.com>
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
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, NeilBrown <neilb@suse.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon 21-03-16 13:41:03, Matthew Wilcox wrote:
> On Mon, Mar 21, 2016 at 02:22:45PM +0100, Jan Kara wrote:
> > The basic idea is that we use a bit in an exceptional radix tree entry as
> > a lock bit and use it similarly to how page lock is used for normal faults.
> > That way we fix races between hole instantiation and read faults of the
> > same index. For now I have disabled PMD faults since there the issues with
> > page fault locking are even worse. Now that Matthew's multi-order radix tree
> > has landed, I can have a look into using that for proper locking of PMD faults
> > but first I want normal pages sorted out.
> 
> FYI, the multi-order radix tree code that landed is unusably buggy.
> Ross and I have been working like madmen for the past three weeks to fix
> all of the bugs we've found and not introduce new ones.  The radix tree
> test suite has been enormously helpful in this regard, but we're still
> finding corner cases (thanks, RCU! ;-)
> 
> Our current best effort can be found hiding in
> http://git.infradead.org/users/willy/linux-dax.git/shortlog/refs/heads/radix-fixes-2016-03-15
> but it's for sure not ready for review yet.  I just don't want other
> people trying to use the facility and wasting their time.

So when looking through the fixes I was wondering: Are really sibling
entries worth it? Won't the result be simpler if we just used
RADIX_TREE_MAP_SHIFT == 9? We would need to put slot pointers out of
radix_tree_node structure (there'd be full page worth of them) but that's
easy. More complications probably come from the fact that we don't want
that unconditionally since radix tree for small files would consume
considerably more memory and that could be an issue for some systems. For
DAX as such we don't really care I think, at least for now, but for normal
page cache we do. So we would have to make RADIX_TREE_MAP_SHIFT
per-radix-tree property. What do you think? I can try to write some patches
if you'd consider it's worth it...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
