Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EAF6320965DDE
 for <linux-nvdimm@lists.01.org>; Wed,  9 May 2018 08:09:39 -0700 (PDT)
Date: Wed, 9 May 2018 09:09:38 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 5/5] radix tree: fix multi-order iteration race
Message-ID: <20180509150938.GA3814@linux.intel.com>
References: <20180503192430.7582-1-ross.zwisler@linux.intel.com>
 <20180503192430.7582-6-ross.zwisler@linux.intel.com>
 <20180509124611.6hoa743z4qrx6bgc@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180509124611.6hoa743z4qrx6bgc@quack2.suse.cz>
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
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 09, 2018 at 02:46:11PM +0200, Jan Kara wrote:
> On Thu 03-05-18 13:24:30, Ross Zwisler wrote:
> > Fix a race in the multi-order iteration code which causes the kernel to hit
> > a GP fault.  This was first seen with a production v4.15 based kernel
> > (4.15.6-300.fc27.x86_64) utilizing a DAX workload which used order 9 PMD
> > DAX entries.
> > 
> > The race has to do with how we tear down multi-order sibling entries when
> > we are removing an item from the tree.  Remember for example that an order
> > 2 entry looks like this:
> > 
> > struct radix_tree_node.slots[] = [entry][sibling][sibling][sibling]
> > 
> > where 'entry' is in some slot in the struct radix_tree_node, and the three
> > slots following 'entry' contain sibling pointers which point back to
> > 'entry.'
> > 
> > When we delete 'entry' from the tree, we call :
> >   radix_tree_delete()
> >     radix_tree_delete_item()
> >       __radix_tree_delete()
> >         replace_slot()
> > 
> > replace_slot() first removes the siblings in order from the first to the
> > last, then at then replaces 'entry' with NULL.  This means that for a brief
> > period of time we end up with one or more of the siblings removed, so:
> > 
> > struct radix_tree_node.slots[] = [entry][NULL][sibling][sibling]
> > 
> > This causes an issue if you have a reader iterating over the slots in the
> > tree via radix_tree_for_each_slot() while only under
> > rcu_read_lock()/rcu_read_unlock() protection.  This is a common case in
> > mm/filemap.c.
> > 
> > The issue is that when __radix_tree_next_slot() => skip_siblings() tries to
> > skip over the sibling entries in the slots, it currently does so with an
> > exact match on the slot directly preceding our current slot.  Normally this
> > works:
> >                                     V preceding slot
> > struct radix_tree_node.slots[] = [entry][sibling][sibling][sibling]
> >                                             ^ current slot
> > 
> > This lets you find the first sibling, and you skip them all in order.
> > 
> > But in the case where one of the siblings is NULL, that slot is skipped and
> > then our sibling detection is interrupted:
> > 
> >                                            V preceding slot
> > struct radix_tree_node.slots[] = [entry][NULL][sibling][sibling]
> >                                                   ^ current slot
> > 
> > This means that the sibling pointers aren't recognized since they point all
> > the way back to 'entry', so we think that they are normal internal radix
> > tree pointers.  This causes us to think we need to walk down to a struct
> > radix_tree_node starting at the address of 'entry'.
> > 
> > In a real running kernel this will crash the thread with a GP fault when
> > you try and dereference the slots in your broken node starting at 'entry'.
> > 
> > We fix this race by fixing the way that skip_siblings() detects sibling
> > nodes.  Instead of testing against the preceding slot we instead look for
> > siblings via is_sibling_entry() which compares against the position of the
> > struct radix_tree_node.slots[] array.  This ensures that sibling entries
> > are properly identified, even if they are no longer contiguous with the
> > 'entry' they point to.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Reported-by: CR, Sapthagirish <sapthagirish.cr@intel.com>
> > Fixes: commit 148deab223b2 ("radix-tree: improve multiorder iterators")
> > Cc: <stable@vger.kernel.org>
> 
> Looks good to me. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thank you for the review, Jan.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
