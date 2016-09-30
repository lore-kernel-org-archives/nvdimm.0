From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/20 v3] dax: Clear dirty bits after flushing caches
Date: Fri, 30 Sep 2016 02:14:18 -0700
Message-ID: <20160930091418.GC24352@infradead.org>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1474992504-20133-1-git-send-email-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-nvdimm@lists.01.org

On Tue, Sep 27, 2016 at 06:08:04PM +0200, Jan Kara wrote:
> Hello,
> 
> this is a third revision of my patches to clear dirty bits from radix tree of
> DAX inodes when caches for corresponding pfns have been flushed. This patch set
> is significantly larger than the previous version because I'm changing how
> ->fault, ->page_mkwrite, and ->pfn_mkwrite handlers may choose to handle the
> fault

Btw, is there ny good reason to keep ->fault, ->pmd_fault, page->mkwrite
and pfn_mkwrite separate these days?  All of them now take a struct
vm_fault, and the differences aren't exactly obvious for callers and
users.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
