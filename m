Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 63172212C344D
 for <linux-nvdimm@lists.01.org>; Tue, 12 Jun 2018 11:07:49 -0700 (PDT)
Date: Tue, 12 Jun 2018 12:07:47 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v4 10/12] filesystem-dax: Introduce dax_lock_page()
Message-ID: <20180612180747.GA28436@linux.intel.com>
References: <152850182079.38390.8280340535691965744.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152850187437.38390.2257981090761438811.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180611154146.jc5xt4gyaihq64lm@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180611154146.jc5xt4gyaihq64lm@quack2.suse.cz>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, hch@lst.de, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 11, 2018 at 05:41:46PM +0200, Jan Kara wrote:
> On Fri 08-06-18 16:51:14, Dan Williams wrote:
> > In preparation for implementing support for memory poison (media error)
> > handling via dax mappings, implement a lock_page() equivalent. Poison
> > error handling requires rmap and needs guarantees that the page->mapping
> > association is maintained / valid (inode not freed) for the duration of
> > the lookup.
> > 
> > In the device-dax case it is sufficient to simply hold a dev_pagemap
> > reference. In the filesystem-dax case we need to use the entry lock.
> > 
> > Export the entry lock via dax_lock_page() that uses rcu_read_lock() to
> > protect against the inode being freed, and revalidates the page->mapping
> > association under xa_lock().
> > 
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> Some comments below...
> 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index cccf6cad1a7a..b7e71b108fcf 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -361,6 +361,82 @@ static void dax_disassociate_entry(void *entry, struct address_space *mapping,
> >  	}
> >  }
> >  
> > +struct page *dax_lock_page(unsigned long pfn)
> > +{
> 
> Why do you return struct page here? Any reason behind that? Because struct
> page exists and can be accessed through pfn_to_page() regardless of result
> of this function so it looks a bit confusing. Also dax_lock_page() name
> seems a bit confusing. Maybe dax_lock_pfn_mapping_entry()?

It's also a bit awkward that the functions are asymmetric in their arguments:
dax_lock_page(pfn) vs dax_unlock_page(struct page)

Looking at dax_lock_page(), we only use 'pfn' to get 'page', so maybe it would
be cleaner to just always deal with struct page, i.e.:

void dax_lock_page(struct page *page);
void dax_unlock_page(struct page *page);
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
