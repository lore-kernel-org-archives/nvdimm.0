Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 426D321E1DB4F
 for <linux-nvdimm@lists.01.org>; Mon, 31 Jul 2017 00:40:00 -0700 (PDT)
Date: Mon, 31 Jul 2017 09:42:06 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/3] remove rw_page() from brd, pmem and btt
Message-ID: <20170731074206.GA16706@lst.de>
References: <20170728165604.10455-1-ross.zwisler@linux.intel.com>
 <20170728173143.GE15980@bombadil.infradead.org>
 <20170728142123.729b20e9fcf45c6a814f18e7@linux-foundation.org>
 <20170730221659.GA28031@bbox> <20170731071707.GA16299@lst.de>
 <20170731073647.GA26199@bbox>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170731073647.GA26199@bbox>
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
Cc: Jens Axboe <axboe@kernel.dk>, Jerome Marchand <jmarchan@redhat.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, seungho1.park@lge.com, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "karam . lee" <karam.lee@lge.com>, Christoph Hellwig <hch@lst.de>, Nitin Gupta <ngupta@vflare.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 31, 2017 at 04:36:47PM +0900, Minchan Kim wrote:
> Do you suggest define something special flag(e.g., SWP_INMEMORY)
> for in-memory swap to swap_info_struct when swapon time manually
> or from bdi_queue_someting automatically?
> And depending the flag of swap_info_struct, use the onstack bio
> instead of dynamic allocation if the swap device is in-memory?

Currently swap always just does I/O on a single page as far
as I can tell, so it can always just use an on-stack bio and
biovec.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
