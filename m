Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3667621DF9693
 for <linux-nvdimm@lists.01.org>; Fri, 25 Aug 2017 00:13:04 -0700 (PDT)
Date: Fri, 25 Aug 2017 09:15:38 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: consolidate the various page fault handlers
Message-ID: <20170825071538.GB9191@lst.de>
References: <20170824152207.30729-1-hch@lst.de>
 <20170824152207.30729-3-hch@lst.de> <20170824212942.GB20489@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170824212942.GB20489@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 24, 2017 at 03:29:42PM -0600, Ross Zwisler wrote:
> > +	/* DAX can shortcut the normal fault path on write faults! */
> 
> Does this comment still make sense for the PMD case?

I kept the code as before, and also kept the comment intent as-is
(although I shortend it a bit).

> Here's what I *think* it
> means: For DAX write faults we make the PTE writeable in the ->fault() code
> and don't rely on a follow-up ->page_mkwrite() call.  This happens in
> do_shared_fault(), where we return before the ->page_mkwrite() call because
> the DAX write fault returns VM_FAULT_NOPAGE.
> 
> This is in contrast to the normal page fault case where the ->fault() call
> ends up calling filemap_fault(), which populates the page read-only, and then
> do_shared_fault() does a follow-up ->page_mkwrite() call which makes the page
> writable.
> 
> First, is the above correct?  :)

Yes.

> If so, I think the comment doesn't make
> sense for the PMD fault path because in that case we always make the PMD
> writeable in the first ->huge_fault() call, as there is no follow-up
> *_mkwrite()?

Well, there is non-DAX huge_fault case.  It still is different from the
normal non-hugepage fault case, so the comment still makes some sense,
but maybe I should remove the DAX.  That being said if we eventually
get huge page page cache support (patches are on the list) I suspect
they'll work like the normal fault path, not the DAX path.

> >  static int
> 
>    STATIC

We're phasing that out, so I should probably remove it where it's
currently newly added/moved in the patch.

> I see that this size check is gone from the new code, and we now rely on the
> equivalent check in dax_iomap_fault().  Nice.

Yes.  And I actually used to mention that in the changelog, but it got
lost.  I'll re-add it.

> I wonder if pe_size would be more readable as a string via __print_symbolic()
> so we see "pe_size PMD" instead of "pe_size 1" from enum page_entry_size?

Probably.  I was just lazy :)  If I want to go all the way I could also
use a __print_flags for the FAULT_FLAG_* flags.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
