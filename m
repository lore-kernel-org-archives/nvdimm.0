Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3110D21E11D7C
 for <linux-nvdimm@lists.01.org>; Fri, 28 Jul 2017 10:29:47 -0700 (PDT)
Date: Fri, 28 Jul 2017 10:31:43 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 0/3] remove rw_page() from brd, pmem and btt
Message-ID: <20170728173143.GE15980@bombadil.infradead.org>
References: <20170728165604.10455-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170728165604.10455-1-ross.zwisler@linux.intel.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Jerome Marchand <jmarchan@redhat.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Minchan Kim <minchan@kernel.org>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "karam . lee" <karam.lee@lge.com>, seungho1.park@lge.com, Nitin Gupta <ngupta@vflare.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 28, 2017 at 10:56:01AM -0600, Ross Zwisler wrote:
> Dan Williams and Christoph Hellwig have recently expressed doubt about
> whether the rw_page() interface made sense for synchronous memory drivers
> [1][2].  It's unclear whether this interface has any performance benefit
> for these drivers, but as we continue to fix bugs it is clear that it does
> have a maintenance burden.  This series removes the rw_page()
> implementations in brd, pmem and btt to relieve this burden.

Why don't you measure whether it has performance benefits?  I don't
understand why zram would see performance benefits and not other drivers.
If it's going to be removed, then the whole interface should be removed,
not just have the implementations removed from some drivers.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
