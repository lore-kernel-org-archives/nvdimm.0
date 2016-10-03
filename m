From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/20 v3] dax: Clear dirty bits after flushing caches
Date: Mon, 3 Oct 2016 09:59:02 +0200
Message-ID: <20161003075902.GG6457@quack2.suse.cz>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
 <20160930091418.GC24352@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160930091418.GC24352@infradead.org>
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-nvdimm@lists.01.org

On Fri 30-09-16 02:14:18, Christoph Hellwig wrote:
> On Tue, Sep 27, 2016 at 06:08:04PM +0200, Jan Kara wrote:
> > Hello,
> > 
> > this is a third revision of my patches to clear dirty bits from radix tree of
> > DAX inodes when caches for corresponding pfns have been flushed. This patch set
> > is significantly larger than the previous version because I'm changing how
> > ->fault, ->page_mkwrite, and ->pfn_mkwrite handlers may choose to handle the
> > fault
> 
> Btw, is there ny good reason to keep ->fault, ->pmd_fault, page->mkwrite
> and pfn_mkwrite separate these days?  All of them now take a struct
> vm_fault, and the differences aren't exactly obvious for callers and
> users.

IMO ->fault and ->pmd_fault can be merged, ->page_mkwrite and ->pfn_mkwrite
can be merged. There were even patches flying around for that. I want to do
that but it's not a priority now as the patch set it already large enough.

I'm not sure whether merging ->fault and ->page_mkwrite would be really
helpful and it would certainly require some non-trivial changes in the
fault path. For example currently a write fault of a file mapping will
result in first ->fault being called which handles the read part of the
fault and then ->page_mkwrite is called to handle write-enabling of the
PTE. When the handlers would be merged, calling one handler twice would be
really strange.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
