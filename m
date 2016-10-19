Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6416F1A1E57
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 00:25:08 -0700 (PDT)
Date: Wed, 19 Oct 2016 09:25:05 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 19/20] dax: Protect PTE modification on WP fault by radix
 tree entry lock
Message-ID: <20161019072505.GI29967@quack2.suse.cz>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
 <1474992504-20133-20-git-send-email-jack@suse.cz>
 <20161018195332.GF7796@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161018195332.GF7796@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 18-10-16 13:53:32, Ross Zwisler wrote:
> On Tue, Sep 27, 2016 at 06:08:23PM +0200, Jan Kara wrote:
> > -	void *entry;
> > +	void *entry, **slot;
> >  	pgoff_t index = vmf->pgoff;
> >  
> >  	spin_lock_irq(&mapping->tree_lock);
> > -	entry = get_unlocked_mapping_entry(mapping, index, NULL);
> > -	if (!entry || !radix_tree_exceptional_entry(entry))
> > -		goto out;
> > +	entry = get_unlocked_mapping_entry(mapping, index, &slot);
> > +	if (!entry || !radix_tree_exceptional_entry(entry)) {
> > +		if (entry)
> > +			put_unlocked_mapping_entry(mapping, index, entry);
> 
> I don't think you need this call to put_unlocked_mapping_entry().  If we get
> in here we know that 'entry' is a page cache page, in which case
> put_unlocked_mapping_entry() will just return without doing any work.

Right, but that is just an implementation detail internal to how the
locking works. The rules are simple to avoid issues and thus the invariant
is: Once you call get_unlocked_mapping_entry() you either have to lock the
entry and then call put_locked_mapping_entry() or you have to drop it with
put_unlocked_mapping_entry(). Once you add arguments about entry types
etc., errors are much easier to make...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
