Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9AEBA220C2A4D
 for <linux-nvdimm@lists.01.org>; Fri,  9 Mar 2018 08:29:38 -0800 (PST)
Date: Fri, 9 Mar 2018 09:35:54 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] loop: Fix lost writes caused by missing flag
Message-ID: <20180309163554.GA485@linux.intel.com>
References: <20180212230558.5546-1-ross.zwisler@linux.intel.com>
 <20180309002048.GA22835@linux.intel.com>
 <81204608-a436-c16b-6846-947573e6ee3c@kernel.dk>
 <92dc07f1-dfbd-2449-ce76-502455f56136@kernel.dk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <92dc07f1-dfbd-2449-ce76-502455f56136@kernel.dk>
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
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 09, 2018 at 08:38:57AM -0700, Jens Axboe wrote:
> On 3/9/18 8:38 AM, Jens Axboe wrote:
> > On 3/8/18 5:20 PM, Ross Zwisler wrote:
> >> This has gotten Reviewed-by tags from Christoph and Ming Lei.
> >>
> >> Al, are you the right person to merge this?  Or is the correct person Jens,
> >> whom I accidentally didn't include when I sent this out?
> >>
> >> Just wanted to make sure this got merged, and to see whether it was targeting
> >> v4.16 or v4.17.
> > 
> > I'm the right guy, but I don't see patches if I'm not cc'ed on them...
> > I have queued this up for 4.16, thanks.
> 
> I do see patches sent to linux-block as well, but you didn't CC that one
> either.

I figure out who to CC on my patches by using scripts/get_maintainer.pl, and
it didn't know about you or linux-block because drivers/block wasn't covered
in MAINTAINERS.  I'll send a patch to fix this.

As it was I just CC'd the folks involved in the original patch, and that one
went up through Al.

Thanks for picking this up.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
