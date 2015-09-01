Return-Path: <owner-linux-mm@kvack.org>
Date: Tue, 1 Sep 2015 14:10:20 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH] mm, dax: VMA with vm_ops->pfn_mkwrite wants to be
 write-notified
Message-ID: <20150901111020.GA7820@node.dhcp.inet.fi>
References: <1441102961-68041-1-git-send-email-kirill.shutemov@linux.intel.com>
 <55E583E2.9000200@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55E583E2.9000200@plexistor.com>
Sender: owner-linux-mm@kvack.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Yigal Korman <yigal@plexistor.com>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 01, 2015 at 01:54:26PM +0300, Boaz Harrosh wrote:
> On 09/01/2015 01:22 PM, Kirill A. Shutemov wrote:
> > For VM_PFNMAP and VM_MIXEDMAP we use vm_ops->pfn_mkwrite instead of
> > vm_ops->page_mkwrite to notify abort write access. This means we want
> > vma->vm_page_prot to be write-protected if the VMA provides this vm_ops.
> > 
> 
> Hi Kirill
> 
> I will test with this right away and ACK on this.
> 
> Hmm so are you saying we might be missing some buffer modifications right now.
> 
> What would be a theoretical scenario that will cause these missed events?

On writable mapping with vm_ops->pfn_mkwrite, but without
vm_ops->page_mkwrite: read fault followed by write access to the pfn.
Writable pte will be set up on read fault and write fault will not be
generated.

I found it examining Dave's complain on generic/080:

http://lkml.kernel.org/g/20150831233803.GO3902@dastard

Although I don't think it's the reason.

> I would like to put a test in our test rigs that should fail today and this
> patch fixes.
> 
> [In our system every modified pmem block is also RDMAed to a remote
>  pmem for HA, a missed modification will make the two copies unsynced]

It shouldn't be a problem for ext2/ext4 as they provide both pfn_mkwrite
and page_mkwrite.

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
