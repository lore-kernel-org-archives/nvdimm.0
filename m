Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B5E692020D33A
 for <linux-nvdimm@lists.01.org>; Mon, 26 Aug 2019 04:54:13 -0700 (PDT)
Date: Mon, 26 Aug 2019 04:51:52 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/19] dax: remove block device dependencies
Message-ID: <20190826115152.GA21051@infradead.org>
References: <20190821175720.25901-1-vgoyal@redhat.com>
 <20190821175720.25901-2-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190821175720.25901-2-vgoyal@redhat.com>
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, dgilbert@redhat.com, virtio-fs@redhat.com, stefanha@redhat.com, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 21, 2019 at 01:57:02PM -0400, Vivek Goyal wrote:
> From: Stefan Hajnoczi <stefanha@redhat.com>
> 
> Although struct dax_device itself is not tied to a block device, some
> DAX code assumes there is a block device.  Make block devices optional
> by allowing bdev to be NULL in commonly used DAX APIs.
> 
> When there is no block device:
>  * Skip the partition offset calculation in bdev_dax_pgoff()
>  * Skip the blkdev_issue_zeroout() optimization
> 
> Note that more block device assumptions remain but I haven't reach those
> code paths yet.

I think this should be split into two patches.  For bdev_dax_pgoff
I'd much rather have the partition offset if there is on in the daxdev
somehow so that we can get rid of the block device entirely.

Similarly for dax_range_is_aligned I'd rather have a pure dax way
to offload zeroing rather than this bdev hack.

In the long run I'd really like to make the bdev vs daxdev in iomap a
union instead of having to carry both around.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
