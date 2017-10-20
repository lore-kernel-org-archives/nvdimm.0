Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2405D2034C087
 for <linux-nvdimm@lists.01.org>; Fri, 20 Oct 2017 10:23:43 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id a132so21139564oih.11
 for <linux-nvdimm@lists.01.org>; Fri, 20 Oct 2017 10:27:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171020163221.GB26320@lst.de>
References: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150846720244.24336.16885325309403883980.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1508504726.5572.41.camel@kernel.org>
 <CAPcyv4hXCJYTkUKs6NiOp=8kgExu+bgZnVn_v+Os7fVUc2NxFg@mail.gmail.com>
 <20171020163221.GB26320@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Oct 2017 10:27:22 -0700
Message-ID: <CAPcyv4iGN6KO_ggJ-vTHCPWanudY3Gq6n=+9sbnMsnTeF56uJA@mail.gmail.com>
Subject: Re: [PATCH v3 12/13] dax: handle truncate of dma-busy pages
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jeff Layton <jlayton@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Oct 20, 2017 at 9:32 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Fri, Oct 20, 2017 at 08:42:00AM -0700, Dan Williams wrote:
>> I agree, but it needs quite a bit more thought and restructuring of
>> the truncate path. I also wonder how we reclaim those stranded
>> filesystem blocks, but a first approximation is wait for the
>> administrator to delete them or auto-delete them at the next mount.
>> XFS seems well prepared to reflink-swap these DMA blocks around, but
>> I'm not sure about EXT4.
>
> reflink still is an optional and experimental feature in XFS.  That
> being said we should not need to swap block pointers around on disk.
> We just need to prevent the block allocator from reusing the blocks
> for new allocations, and we have code for that, both for transactions
> that haven't been committed to disk yet, and for deleted blocks
> undergoing discard operations.
>
> But as mentioned in my second mail from this morning I'm not even
> sure we need that.  For short-term elevated page counts like normal
> get_user_pages users I think we can just wait for the page count
> to reach zero, while for abuses of get_user_pages for long term
> pinning memory (not sure if anyone but rdma is doing that) we'll need
> something like FL_LAYOUT leases to release the mapping.

I'll take a look at hooking this up through a page-idle callback. Can
I get some breadcrumbs to grep for from XFS folks on how to set/clear
the busy state of extents?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
