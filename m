Return-Path: <owner-linux-mm@kvack.org>
Date: Thu, 3 Sep 2015 10:44:53 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] dax, pmem: add support for msync
Message-ID: <20150903164453.GA10341@linux.intel.com>
References: <1441047584-14664-1-git-send-email-ross.zwisler@linux.intel.com>
 <20150831233803.GO3902@dastard>
 <20150901070608.GA5482@lst.de>
 <55E597A1.9090205@plexistor.com>
 <20150902190401.GC32255@linux.intel.com>
 <55E7E962.2000607@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55E7E962.2000607@plexistor.com>
Sender: owner-linux-mm@kvack.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@osdl.org>, Dave Hansen <dave.hansen@linux.intel.com>, linux-nvdimm@lists.01.org, Peter Zijlstra <peterz@infradead.org>, x86@kernel.org, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Sep 03, 2015 at 09:32:02AM +0300, Boaz Harrosh wrote:
> On 09/02/2015 10:04 PM, Ross Zwisler wrote:
> > On Tue, Sep 01, 2015 at 03:18:41PM +0300, Boaz Harrosh wrote:
> <>
> >> Apps expect all these to work:
> >> 1. open mmap m-write msync ... close
> >> 2. open mmap m-write fsync ... close
> >> 3. open mmap m-write unmap ... fsync close
> >>
> >> 4. open mmap m-write sync ...
> > 
> > So basically you made close have an implicit fsync?  What about the flow that
> > looks like this:
> > 
> > 5. open mmap close m-write
> > 
> 
> What? no, close means ummap because you need a file* attached to your vma
> 
> And you miss-understood me, the vm_opts->close is the *unmap* operation not
> the file::close() operation.
> 
> I meant memory-cl_flush on unmap before the vma goes away.

Ah, got it, thanks for the clarification.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
