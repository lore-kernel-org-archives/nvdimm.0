Return-Path: <owner-linux-mm@kvack.org>
Date: Tue, 8 Aug 2017 16:02:26 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH v1 5/6] zram: remove zram_rw_page
Message-ID: <20170808070226.GC7765@jagdpanzerIV.localdomain>
References: <1502175024-28338-1-git-send-email-minchan@kernel.org>
 <1502175024-28338-6-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1502175024-28338-6-git-send-email-minchan@kernel.org>
Sender: owner-linux-mm@kvack.org
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Ross Zwisler <ross.zwisler@linux.intel.com>, "karam . lee" <karam.lee@lge.com>, seungho1.park@lge.com, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, jack@suse.cz, Jens Axboe <axboe@kernel.dk>, Vishal Verma <vishal.l.verma@intel.com>, linux-nvdimm@lists.01.org, kernel-team <kernel-team@lge.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

On (08/08/17 15:50), Minchan Kim wrote:
> With on-stack-bio, rw_page interface doesn't provide a clear performance
> benefit for zram and surely has a maintenance burden, so remove the
> last user to remove rw_page completely.

OK, never really liked it, I think we had that conversation before.

as far as I remember, zram_rw_page() was the reason we had to do some
tricks with init_lock to make lockdep happy. may be now we can "simplify"
the things back.


> Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

	-ss

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
