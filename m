Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A836F21A143C3
 for <linux-nvdimm@lists.01.org>; Wed, 14 Jun 2017 03:45:13 -0700 (PDT)
Date: Wed, 14 Jun 2017 12:46:26 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 13/14] filesystem-dax: gate calls to dax_flush() on
 QUEUE_FLAG_WC
Message-ID: <20170614104626.GA21506@quack2.suse.cz>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703989611.20620.6907872165215640212.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <149703989611.20620.6907872165215640212.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, dm-devel@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Fri 09-06-17 13:24:56, Dan Williams wrote:
> Some platforms arrange for cpu caches to be flushed on power-fail. On
> those platforms there is no requirement that the kernel track and flush
> potentially dirty cache lines. Given that we still insert entries into
> the radix for locking purposes this patch only disables the cache flush
> loop, not the dirty tracking.
> 
> Userspace can override the default cache setting via the block device
> queue "write_cache" attribute in sysfs.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

...

> -	dax_flush(dax_dev, pgoff, kaddr, size);
> +	if (test_bit(QUEUE_FLAG_WC, &bdev->bd_queue->queue_flags))
> +		dax_flush(dax_dev, pgoff, kaddr, size);

IMHO the check belongs into dax_flush() similarly as blkdev_issue_flush()
takes silently handles whether the flush is actually needed or not.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
