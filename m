Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from lgeamrelo13.lge.com (LGEAMRELO13.lge.com [156.147.23.53])
 by ml01.01.org (Postfix) with ESMTP id BAC4A21DF969D
 for <linux-nvdimm@lists.01.org>; Tue,  8 Aug 2017 01:11:24 -0700 (PDT)
Date: Tue, 8 Aug 2017 17:13:38 +0900
From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v1 5/6] zram: remove zram_rw_page
Message-ID: <20170808081338.GA30908@bbox>
References: <1502175024-28338-1-git-send-email-minchan@kernel.org>
 <1502175024-28338-6-git-send-email-minchan@kernel.org>
 <20170808070226.GC7765@jagdpanzerIV.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170808070226.GC7765@jagdpanzerIV.localdomain>
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
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, jack@suse.cz, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, kernel-team <kernel-team@lge.com>, seungho1.park@lge.com, "karam . lee" <karam.lee@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Sergey,

On Tue, Aug 08, 2017 at 04:02:26PM +0900, Sergey Senozhatsky wrote:
> On (08/08/17 15:50), Minchan Kim wrote:
> > With on-stack-bio, rw_page interface doesn't provide a clear performance
> > benefit for zram and surely has a maintenance burden, so remove the
> > last user to remove rw_page completely.
> 
> OK, never really liked it, I think we had that conversation before.
> 
> as far as I remember, zram_rw_page() was the reason we had to do some
> tricks with init_lock to make lockdep happy. may be now we can "simplify"
> the things back.

I cannot remember. Blame my brain. ;-)

Anyway, it's always welcome to make thing simple.
Could you send a patch after settle down this patchset?

> 
> 
> > Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> 
> Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Thanks for the review!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
