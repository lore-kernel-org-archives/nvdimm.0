Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DD17021159930
 for <linux-nvdimm@lists.01.org>; Thu, 27 Sep 2018 04:13:56 -0700 (PDT)
Date: Thu, 27 Sep 2018 13:13:54 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 07/11] filesystem-dax: Introduce
 dax_lock_mapping_entry()
Message-ID: <20180927111354.GA16469@quack2.suse.cz>
References: <153074042316.27838.17319837331947007626.stgit@dwillia2-desk3.amr.corp.intel.com>
 <153074046078.27838.5465590228767136915.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180924115721.75893931@gnomeregan.cam.corp.google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180924115721.75893931@gnomeregan.cam.corp.google.com>
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
To: Barret Rhoden <brho@google.com>
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Mon 24-09-18 11:57:21, Barret Rhoden wrote:
> Hi Dan -
> 
> On 2018-07-04 at 14:41 Dan Williams <dan.j.williams@intel.com> wrote:
> [snip]
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 4de11ed463ce..57ec272038da 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> [snip]
> > +bool dax_lock_mapping_entry(struct page *page)
> > +{
> > +	pgoff_t index;
> > +	struct inode *inode;
> > +	bool did_lock = false;
> > +	void *entry = NULL, **slot;
> > +	struct address_space *mapping;
> > +
> > +	rcu_read_lock();
> > +	for (;;) {
> > +		mapping = READ_ONCE(page->mapping);
> > +
> > +		if (!dax_mapping(mapping))
> > +			break;
> > +
> > +		/*
> > +		 * In the device-dax case there's no need to lock, a
> > +		 * struct dev_pagemap pin is sufficient to keep the
> > +		 * inode alive, and we assume we have dev_pagemap pin
> > +		 * otherwise we would not have a valid pfn_to_page()
> > +		 * translation.
> > +		 */
> > +		inode = mapping->host;
> > +		if (S_ISCHR(inode->i_mode)) {
> > +			did_lock = true;
> > +			break;
> > +		}
> > +
> > +		xa_lock_irq(&mapping->i_pages);
> > +		if (mapping != page->mapping) {
> > +			xa_unlock_irq(&mapping->i_pages);
> > +			continue;
> > +		}
> > +		index = page->index;
> > +
> > +		entry = __get_unlocked_mapping_entry(mapping, index, &slot,
> > +				entry_wait_revalidate);
> > +		if (!entry) {
> > +			xa_unlock_irq(&mapping->i_pages);
> > +			break;
> > +		} else if (IS_ERR(entry)) {
> > +			WARN_ON_ONCE(PTR_ERR(entry) != -EAGAIN);
> > +			continue;
> 
> In the IS_ERR case, do you need to xa_unlock the mapping?  It looks
> like you'll deadlock the next time around the loop.

Yep, that looks certainly wrong. I'll send a fix.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
