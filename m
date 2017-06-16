Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4FB1021A07A81
 for <linux-nvdimm@lists.01.org>; Fri, 16 Jun 2017 12:44:23 -0700 (PDT)
Date: Fri, 16 Jun 2017 13:45:40 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 3/3] dax: use common 4k zero page for dax mmap reads
Message-ID: <20170616194540.GB20742@linux.intel.com>
References: <20170614172211.19820-1-ross.zwisler@linux.intel.com>
 <20170614172211.19820-4-ross.zwisler@linux.intel.com>
 <20170615145856.GO1764@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170615145856.GO1764@quack2.suse.cz>
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
Cc: linux-xfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, linux-doc@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 15, 2017 at 04:58:56PM +0200, Jan Kara wrote:
> On Wed 14-06-17 11:22:11, Ross Zwisler wrote:
> > @@ -216,17 +217,6 @@ static void dax_unlock_mapping_entry(struct address_space *mapping,
> >  	dax_wake_mapping_entry_waiter(mapping, index, entry, false);
> >  }
> >  
> > -static void put_locked_mapping_entry(struct address_space *mapping,
> > -				     pgoff_t index, void *entry)
> > -{
> > -	if (!radix_tree_exceptional_entry(entry)) {
> > -		unlock_page(entry);
> > -		put_page(entry);
> > -	} else {
> > -		dax_unlock_mapping_entry(mapping, index);
> > -	}
> > -}
> > -
> 
> The naming becomes asymetric with this. So I'd prefer keeping
> put_locked_mapping_entry() as a trivial wrapper around
> dax_unlock_mapping_entry() unless we can craft more sensible naming / API
> for entry grabbing (and that would be a separate patch anyway).

Sure, that works for me.  I'll fix for v3.

> > -static int dax_load_hole(struct address_space *mapping, void **entry,
> > +static int dax_load_hole(struct address_space *mapping, void *entry,
> >  			 struct vm_fault *vmf)
> >  {
> >  	struct inode *inode = mapping->host;
> > -	struct page *page;
> > -	int ret;
> > -
> > -	/* Hole page already exists? Return it...  */
> > -	if (!radix_tree_exceptional_entry(*entry)) {
> > -		page = *entry;
> > -		goto finish_fault;
> > -	}
> > +	unsigned long vaddr = vmf->address;
> > +	int ret = VM_FAULT_NOPAGE;
> > +	struct page *zero_page;
> > +	void *entry2;
> >  
> > -	/* This will replace locked radix tree entry with a hole page */
> > -	page = find_or_create_page(mapping, vmf->pgoff,
> > -				   vmf->gfp_mask | __GFP_ZERO);
> 
> With this gone, you can also remove the special DAX handling from
> mm/filemap.c: page_cache_tree_insert() and remove from dax.h
> dax_wake_mapping_entry_waiter(), dax_radix_locked_entry() and RADIX_DAX
> definitions. Yay! As a separate patch please.

Oh, yay!  :)  Sure, I'll have this patch for v3.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
