Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x22f.google.com (mail-pg0-x22f.google.com
 [IPv6:2607:f8b0:400e:c05::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CD66F21DF968C
 for <linux-nvdimm@lists.01.org>; Tue,  8 Aug 2017 01:21:19 -0700 (PDT)
Received: by mail-pg0-x22f.google.com with SMTP id y129so12020694pgy.4
 for <linux-nvdimm@lists.01.org>; Tue, 08 Aug 2017 01:23:36 -0700 (PDT)
Date: Tue, 8 Aug 2017 17:23:50 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH v1 5/6] zram: remove zram_rw_page
Message-ID: <20170808082350.GD7765@jagdpanzerIV.localdomain>
References: <1502175024-28338-1-git-send-email-minchan@kernel.org>
 <1502175024-28338-6-git-send-email-minchan@kernel.org>
 <20170808070226.GC7765@jagdpanzerIV.localdomain>
 <20170808081338.GA30908@bbox>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170808081338.GA30908@bbox>
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
To: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, jack@suse.cz, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, kernel-team <kernel-team@lge.com>, seungho1.park@lge.com, Andrew Morton <akpm@linux-foundation.org>, "karam . lee" <karam.lee@lge.com>
List-ID: <linux-nvdimm@lists.01.org>

Hello Minchan,

On (08/08/17 17:13), Minchan Kim wrote:
> Hi Sergey,
> 
> On Tue, Aug 08, 2017 at 04:02:26PM +0900, Sergey Senozhatsky wrote:
> > On (08/08/17 15:50), Minchan Kim wrote:
> > > With on-stack-bio, rw_page interface doesn't provide a clear performance
> > > benefit for zram and surely has a maintenance burden, so remove the
> > > last user to remove rw_page completely.
> > 
> > OK, never really liked it, I think we had that conversation before.
> > 
> > as far as I remember, zram_rw_page() was the reason we had to do some
> > tricks with init_lock to make lockdep happy. may be now we can "simplify"
> > the things back.
> 
> I cannot remember. Blame my brain. ;-)

no worries. I didn't remember it clearly as well, hence the "may be" part.

commit 08eee69fcf6baea543a2b4d2a2fcba0e61aa3160
Author: Minchan Kim

    zram: remove init_lock in zram_make_request
    
    Admin could reset zram during I/O operation going on so we have used
    zram->init_lock as read-side lock in I/O path to prevent sudden zram
    meta freeing.
    
    However, the init_lock is really troublesome.  We can't do call
    zram_meta_alloc under init_lock due to lockdep splat because
    zram_rw_page is one of the function under reclaim path and hold it as
    read_lock while other places in process context hold it as write_lock.
    So, we have used allocation out of the lock to avoid lockdep warn but
    it's not good for readability and fainally, I met another lockdep splat
    between init_lock and cpu_hotplug from kmem_cache_destroy during working
    zsmalloc compaction.  :(
    
    Yes, the ideal is to remove horrible init_lock of zram in rw path.  This
    patch removes it in rw path and instead, add atomic refcount for meta
    lifetime management and completion to free meta in process context.
    It's important to free meta in process context because some of resource
    destruction needs mutex lock, which could be held if we releases the
    resource in reclaim context so it's deadlock, again.
    
    As a bonus, we could remove init_done check in rw path because
    zram_meta_get will do a role for it, instead.

> Anyway, it's always welcome to make thing simple.
> Could you send a patch after settle down this patchset?

well, if it will improve anything after all :)

	-ss
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
