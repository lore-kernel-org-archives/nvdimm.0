Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x236.google.com (mail-pg0-x236.google.com
 [IPv6:2607:f8b0:400e:c05::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8AF2C21D0A272
 for <linux-nvdimm@lists.01.org>; Sun, 13 Aug 2017 18:36:52 -0700 (PDT)
Received: by mail-pg0-x236.google.com with SMTP id v189so36893362pgd.2
 for <linux-nvdimm@lists.01.org>; Sun, 13 Aug 2017 18:39:15 -0700 (PDT)
Date: Mon, 14 Aug 2017 10:39:30 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH v2 1/7] zram: set BDI_CAP_STABLE_WRITES once
Message-ID: <20170814013930.GA603@jagdpanzerIV.localdomain>
References: <1502428647-28928-1-git-send-email-minchan@kernel.org>
 <1502428647-28928-2-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1502428647-28928-2-git-send-email-minchan@kernel.org>
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
Cc: Jens Axboe <axboe@kernel.dk>, Senozhatsky <sergey.senozhatsky@gmail.com>, jack@suse.cz, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, kernel-team <kernel-team@lge.com>, seungho1.park@lge.com, Ilya Dryomov <idryomov@gmail.com>, "karam . lee" <karam.lee@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On (08/11/17 14:17), Minchan Kim wrote:
> [1] fixed weird thing(i.e., reset BDI_CAP_STABLE_WRITES flag
> unconditionally whenever revalidat_disk is called) so zram doesn't
> need to reset the flag any more whenever revalidating the bdev.
> Instead, set the flag just once when the zram device is created.
> 
> It shouldn't change any behavior.
> 
> [1] 19b7ccf8651d, block: get rid of blk_integrity_revalidate()
> Cc: Senozhatsky <sergey.senozhatsky@gmail.com>
> Cc: Ilya Dryomov <idryomov@gmail.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

	-ss
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
