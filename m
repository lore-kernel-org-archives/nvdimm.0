Return-Path: <owner-linux-mm@kvack.org>
Date: Mon, 31 Aug 2015 21:34:49 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] dax, pmem: add support for msync
Message-ID: <20150831193449.GA27444@lst.de>
References: <1441047584-14664-1-git-send-email-ross.zwisler@linux.intel.com> <20150831190619.GA27141@lst.de> <20150831192640.GA15717@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150831192640.GA15717@linux.intel.com>
Sender: owner-linux-mm@kvack.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@osdl.org>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, Matthew Wilcox <willy@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 31, 2015 at 01:26:40PM -0600, Ross Zwisler wrote:
> > Should this be abstracted by adding a ->msync method?  Maybe not
> > worth to do for now, but it might be worth to keep that in mind.
> 
> Where would we add the ->msync method?  Do you mean to the PMEM API, or
> somewhere else?

vm_operations_struct would be the most logical choice, with filesystems
having a dax-specific instance of that.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
