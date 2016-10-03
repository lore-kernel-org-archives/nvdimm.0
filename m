Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD3151A1E1E
 for <linux-nvdimm@lists.01.org>; Mon,  3 Oct 2016 11:40:10 -0700 (PDT)
Date: Mon, 3 Oct 2016 12:40:02 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v4 07/12] dax: coordinate locking for offsets in PMD range
Message-ID: <20161003184002.GB2044@linux.intel.com>
References: <1475189370-31634-1-git-send-email-ross.zwisler@linux.intel.com>
 <1475189370-31634-8-git-send-email-ross.zwisler@linux.intel.com>
 <20161003095518.GM6457@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161003095518.GM6457@quack2.suse.cz>
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
Cc: Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 03, 2016 at 11:55:18AM +0200, Jan Kara wrote:
> On Thu 29-09-16 16:49:25, Ross Zwisler wrote:
> > DAX radix tree locking currently locks entries based on the unique
> > combination of the 'mapping' pointer and the pgoff_t 'index' for the entry.
> > This works for PTEs, but as we move to PMDs we will need to have all the
> > offsets within the range covered by the PMD to map to the same bit lock.
> > To accomplish this, for ranges covered by a PMD entry we will instead lock
> > based on the page offset of the beginning of the PMD entry.  The 'mapping'
> > pointer is still used in the same way.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > ---
> >  fs/dax.c            | 37 ++++++++++++++++++++++++-------------
> >  include/linux/dax.h |  2 +-
> >  mm/filemap.c        |  2 +-
> >  3 files changed, 26 insertions(+), 15 deletions(-)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index baef586..406feea 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -64,10 +64,17 @@ static int __init init_dax_wait_table(void)
> >  }
> >  fs_initcall(init_dax_wait_table);
> >  
> > +static pgoff_t dax_entry_start(pgoff_t index, void *entry)
> > +{
> > +	if (RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD)
> > +		index &= (PMD_MASK >> PAGE_SHIFT);
> 
> Hum, but if we shift right, top bits of PMD_MASK will become zero - not
> something we want I guess... You rather want to mask with something like:
> 	~((1UL << (PMD_SHIFT - PAGE_SHIFT)) - 1)

Great catch, thanks.  Fixed for v5.

> > @@ -447,10 +457,11 @@ restart:
> >  	return entry;
> >  }
> >  
> > -void dax_wake_mapping_entry_waiter(struct address_space *mapping,
> > +void dax_wake_mapping_entry_waiter(void *entry, struct address_space *mapping,
> >  				   pgoff_t index, bool wake_all)
> 
> Nitpick: Ordering of arguments would look more logical to me like:
> 
> dax_wake_mapping_entry_waiter(mapping, index, entry, wake_all)

Cool, I'll reorder them for v5.

Thanks for the review!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
