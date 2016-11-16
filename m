Return-Path: <owner-linux-mm@kvack.org>
Date: Wed, 16 Nov 2016 14:12:05 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 05/21] mm: Trim __do_fault() arguments
Message-ID: <20161116131205.GJ21785@quack2.suse.cz>
References: <1478233517-3571-1-git-send-email-jack@suse.cz>
 <1478233517-3571-6-git-send-email-jack@suse.cz>
 <20161115221001.GE23021@node>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161115221001.GE23021@node>
Sender: owner-linux-mm@kvack.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Andrew Morton <akpm@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 16-11-16 01:10:01, Kirill A. Shutemov wrote:
> On Fri, Nov 04, 2016 at 05:25:01AM +0100, Jan Kara wrote:
> >  static int do_cow_fault(struct vm_fault *vmf)
> >  {
> >  	struct vm_area_struct *vma = vmf->vma;
> > -	struct page *fault_page, *new_page;
> > -	void *fault_entry;
> > +	struct page *new_page;
> 
> Why not get rid of new_page too?

OK, I did that as well.

> Otherwise makes sense:
> 
> Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
