Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 835C41A1E75
 for <linux-nvdimm@lists.01.org>; Thu, 12 May 2016 00:58:23 -0700 (PDT)
Date: Thu, 12 May 2016 09:58:18 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 16/18] dax: New fault locking
Message-ID: <20160512075818.GA10306@quack2.suse.cz>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
 <1461015341-20153-17-git-send-email-jack@suse.cz>
 <20160506041350.GA29628@linux.intel.com>
 <20160510122715.GK11897@quack2.suse.cz>
 <20160511192632.GA8841@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160511192632.GA8841@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed 11-05-16 13:26:32, Ross Zwisler wrote:
> > > In the various places where clear_exceptional_entry() is called, the code
> > > batches up a bunch of entries in a pvec via pagevec_lookup_entries().  We
> > > don't hold the mapping->tree_lock between the time this lookup happens and the
> > > time that the entry is passed to clear_exceptional_entry(). This is why the
> > > old code did a verification that the entry passed in matched what was still
> > > currently present in the radix tree.  This was done in the DAX case via
> > > radix_tree_delete_item(), and it was open coded in clear_exceptional_entry()
> > > for the page cache case.  In both cases if the entry didn't match what was
> > > currently in the tree, we bailed without doing anything.
> > > 
> > > This new code doesn't verify against the 'entry' passed to
> > > clear_exceptional_entry(), but instead makes sure it is an exceptional entry
> > > before removing, and if not it does a WARN_ON_ONCE().
> > > 
> > > This changes things because:
> > > 
> > > a) If the exceptional entry changed, say from a plain lock entry to an actual
> > > DAX entry, we wouldn't notice, and we would just clear the latter out.  My
> > > guess is that this is fine, I just wanted to call it out.
> > > 
> > > b) If we have a non-exceptional entry here now, say because our lock entry has
> > > been swapped out for a zero page, we will WARN_ON_ONCE() and return without a
> > > removal.  I think we may want to silence the WARN_ON_ONCE(), as I believe this
> > > could happen during normal operation and we don't want to scare anyone. :)
> > 
> > So your concerns are exactly why I have added a comment to
> > dax_delete_mapping_entry() that:
> > 
> > 	/*
> > 	 * Caller should make sure radix tree modifications don't race and
> > 	 * we have seen exceptional entry here before.
> > 	 */
> > 
> > The thing is dax_delete_mapping_entry() is called only from truncate /
> > punch hole path. Those should hold i_mmap_sem for writing and thus there
> > should be no modifications of the radix tree. If anything changes, between
> > what truncate_inode_pages() (or similar functions) finds and what
> > dax_delete_mapping_entry() sees, we have a locking bug and I want to know
> > about it :). Any suggestion how I should expand the comment so that this is
> > clearer?
> 
> Ah, I didn't understand all that.  :)  Given a bit more context the comment
> seems fine - if anything it could be a bit more specific, and include the
> text: "dax_delete_mapping_entry() is called only from truncate / punch hole
> path. Those should hold i_mmap_sem for writing and thus there should be no
> modifications of the radix tree."  Either way - thanks for explaining.

OK, I've made the comment more detailed.

> At the end of this mail I've attached one small fixup for the incremental diff
> you sent.  Aside from that, I think that you've addressed all my review
> feedback, thanks!

Yup, I've found this out as well when compiling the new version.

> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Thanks.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
