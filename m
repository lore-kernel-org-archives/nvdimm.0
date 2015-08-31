Return-Path: <owner-linux-mm@kvack.org>
Date: Mon, 31 Aug 2015 13:26:40 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] dax, pmem: add support for msync
Message-ID: <20150831192640.GA15717@linux.intel.com>
References: <1441047584-14664-1-git-send-email-ross.zwisler@linux.intel.com>
 <20150831190619.GA27141@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150831190619.GA27141@lst.de>
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@osdl.org>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, Matthew Wilcox <willy@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 31, 2015 at 09:06:19PM +0200, Christoph Hellwig wrote:
> On Mon, Aug 31, 2015 at 12:59:44PM -0600, Ross Zwisler wrote:
> > For DAX msync we just need to flush the given range using
> > wb_cache_pmem(), which is now a public part of the PMEM API.
> > 
> > The inclusion of <linux/dax.h> in fs/dax.c was done to make checkpatch
> > happy.  Previously it was complaining about a bunch of undeclared
> > functions that could be made static.
> 
> Should this be abstracted by adding a ->msync method?  Maybe not
> worth to do for now, but it might be worth to keep that in mind.

Where would we add the ->msync method?  Do you mean to the PMEM API, or
somewhere else?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
