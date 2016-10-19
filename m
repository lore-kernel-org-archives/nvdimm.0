Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 418F81A1E57
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 00:30:19 -0700 (PDT)
Date: Wed, 19 Oct 2016 09:30:16 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 20/20] dax: Clear dirty entry tags on cache flush
Message-ID: <20161019073016.GJ29967@quack2.suse.cz>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
 <1474992504-20133-21-git-send-email-jack@suse.cz>
 <20161018221254.GG7796@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161018221254.GG7796@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 18-10-16 16:12:54, Ross Zwisler wrote:
> On Tue, Sep 27, 2016 at 06:08:24PM +0200, Jan Kara wrote:
> > Currently we never clear dirty tags in DAX mappings and thus address
> > ranges to flush accumulate. Now that we have locking of radix tree
> > entries, we have all the locking necessary to reliably clear the radix
> > tree dirty tag when flushing caches for corresponding address range.
> > Similarly to page_mkclean() we also have to write-protect pages to get a
> > page fault when the page is next written to so that we can mark the
> > entry dirty again.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Looks great. 
> 
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Thanks for review Ross! I've rebased the series on top of rc1. Do you have
your PMD series somewhere rebased on top of rc1 so that I can rebase my
patches on top of that as well? Then I'd post another version of the
series...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
