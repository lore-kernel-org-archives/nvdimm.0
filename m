Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F3D891A1E60
 for <linux-nvdimm@lists.01.org>; Mon, 10 Oct 2016 15:06:20 -0700 (PDT)
Date: Mon, 10 Oct 2016 16:06:19 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v5 15/17] dax: add struct iomap based DAX PMD support
Message-ID: <20161010220619.GB22793@linux.intel.com>
References: <1475874544-24842-1-git-send-email-ross.zwisler@linux.intel.com>
 <1475874544-24842-16-git-send-email-ross.zwisler@linux.intel.com>
 <20161010155917.GA19978@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161010155917.GA19978@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 10, 2016 at 05:59:17PM +0200, Christoph Hellwig wrote:
> On Fri, Oct 07, 2016 at 03:09:02PM -0600, Ross Zwisler wrote:
> > -	if (RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD)
> > +	if ((unsigned long)entry & RADIX_DAX_PMD)
> 
> Please introduce a proper inline helper that mask all the possible type
> bits out of the radix tree entry, and use them wherever you do the
> open cast.

Sure, will do.

> >  restart:
> >  	spin_lock_irq(&mapping->tree_lock);
> >  	entry = get_unlocked_mapping_entry(mapping, index, &slot);
> > +
> > +	if (entry) {
> > +		if (size_flag & RADIX_DAX_PMD) {
> > +			if (!radix_tree_exceptional_entry(entry) ||
> > +			    !((unsigned long)entry & RADIX_DAX_PMD)) {
> > +				entry = ERR_PTR(-EEXIST);
> > +				goto out_unlock;
> > +			}
> > +		} else { /* trying to grab a PTE entry */
> > +			if (radix_tree_exceptional_entry(entry) &&
> > +			    ((unsigned long)entry & RADIX_DAX_PMD) &&
> > +			    ((unsigned long)entry &
> > +			     (RADIX_DAX_HZP|RADIX_DAX_EMPTY))) {
> 
> And when we do these cases N times next to each other we should
> have a local variable the valid flag bits of entry.

Okay, will fix.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
