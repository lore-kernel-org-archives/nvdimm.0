Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 85B171A1EEA
 for <linux-nvdimm@lists.01.org>; Fri, 18 Mar 2016 08:39:16 -0700 (PDT)
Date: Fri, 18 Mar 2016 16:39:19 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 12/12] dax: New fault locking
Message-ID: <20160318153919.GG7152@quack.suse.cz>
References: <1457637535-21633-1-git-send-email-jack@suse.cz>
 <1457637535-21633-13-git-send-email-jack@suse.cz>
 <87h9gdj3dt.fsf@notabene.neil.brown.name>
 <87egbbh1cr.fsf@notabene.neil.brown.name>
 <20160318141618.GF7152@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160318141618.GF7152@quack.suse.cz>
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
To: NeilBrown <neilb@suse.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Wilcox,
List-ID: <linux-nvdimm@lists.01.org>

On Fri 18-03-16 15:16:18, Jan Kara wrote:
> On Wed 16-03-16 08:34:28, NeilBrown wrote:
> > On Fri, Mar 11 2016, NeilBrown wrote:
> > 
> > > On Fri, Mar 11 2016, Jan Kara wrote:
> > >
> > >> Currently DAX page fault locking is racy.
> > >>
> > >> CPU0 (write fault)		CPU1 (read fault)
> > >>
> > >> __dax_fault()			__dax_fault()
> > >>   get_block(inode, block, &bh, 0) -> not mapped
> > >> 				  get_block(inode, block, &bh, 0)
> > >> 				    -> not mapped
> > >>   if (!buffer_mapped(&bh))
> > >>     if (vmf->flags & FAULT_FLAG_WRITE)
> > >>       get_block(inode, block, &bh, 1) -> allocates blocks
> > >>   if (page) -> no
> > >> 				  if (!buffer_mapped(&bh))
> > >> 				    if (vmf->flags & FAULT_FLAG_WRITE) {
> > >> 				    } else {
> > >> 				      dax_load_hole();
> > >> 				    }
> > >>   dax_insert_mapping()
> > >>
> > >> And we are in a situation where we fail in dax_radix_entry() with -EIO.
> > >>
> > >> Another problem with the current DAX page fault locking is that there is
> > >> no race-free way to clear dirty tag in the radix tree. We can always
> > >> end up with clean radix tree and dirty data in CPU cache.
> > >>
> > >> We fix the first problem by introducing locking of exceptional radix
> > >> tree entries in DAX mappings acting very similarly to page lock and thus
> > >> synchronizing properly faults against the same mapping index. The same
> > >> lock can later be used to avoid races when clearing radix tree dirty
> > >> tag.
> > >
> > > Hi,
> > >  I think the exception locking bits look good - I cannot comment on the
> > >  rest.
> > >  I looks like it was a good idea to bring the locking into dax.c instead
> > >  of trying to make it generic.
> > >
> > 
> > Actually ... I'm still bothered by the exclusive waiting.  If an entry
> > is locked and there are two threads in dax_pfn_mkwrite() then one would
> > be woken up when the entry is unlocked and it will just set the TAG_DIRTY
> > flag and then continue without ever waking the next waiter on the
> > wait queue.
> > 
> > I *think* that any thread which gets an exclusive wakeup is responsible
> > for performing another wakeup.  In this case it must either lock the
> > slot, or call __wakeup.
> > That means:
> >   grab_mapping_entry needs to call wakeup:
> >      if radix_tree_preload() fails
> >      if radix_tree_insert fails other than with -EEXIST
> >      if a valid page was found
> 
> Why would we need to call wake up when a valid page was found? In that case
> there should not be any process waiting for the radix tree entry lock.
> Otherwise I agree with you. Thanks for pointing this out, you've likely
> saved me quite some debugging ;).
> 
> 
> >   dax_delete_mapping_entry needs to call wakeup
> >      if the fail case, though as that isn't expect (WARN_ON_ONCE)
> >         it should be a problem not to wakeup here
> >   dax_pfn_mkwrite needs to call wakeup unconditionally

Actually, after some thought I don't think the wakeup is needed except for
dax_pfn_mkwrite(). In the other cases we know there is no radix tree
exceptional entry and thus there can be no waiters for its lock...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
