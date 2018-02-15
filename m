Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 64B9C220F33C7
 for <linux-nvdimm@lists.01.org>; Thu, 15 Feb 2018 11:01:31 -0800 (PST)
Date: Thu, 15 Feb 2018 11:06:58 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v4 1/3] fs: allow per-device dax status checking for
 filesystems
Message-ID: <20180215190658.GQ5217@magnolia>
References: <151871644696.27617.4390718895806529377.stgit@djiang5-desk3.ch.intel.com>
 <151871655228.27617.3514495396592472682.stgit@djiang5-desk3.ch.intel.com>
 <20180215175241.GA25223@infradead.org>
 <f5f93cd1-4d9e-c794-99fb-28daa0d1669d@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f5f93cd1-4d9e-c794-99fb-28daa0d1669d@intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org, david@fromorbit.com, Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 15, 2018 at 10:58:54AM -0700, Dave Jiang wrote:
> On 02/15/2018 10:52 AM, Christoph Hellwig wrote:
> >>  /**
> >> - * __bdev_dax_supported() - Check if the device supports dax for filesystem
> >> + * bdev_dax_supported() - Check if the device supports dax for filesystem
> >>   * @sb: The superblock of the device
> >> + * @bdev: block device to check
> >>   * @blocksize: The block size of the device
> >>   *
> >>   * This is a library function for filesystems to check if the block device
> >> @@ -82,9 +83,9 @@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
> >>   *
> >>   * Return: negative errno if unsupported, 0 if supported.
> >>   */
> >> -int __bdev_dax_supported(struct super_block *sb, int blocksize)
> >> +int bdev_dax_supported(struct super_block *sb, struct block_device *bdev,
> >> +		       int blocksize)
> >>  {
> >> -	struct block_device *bdev = sb->s_bdev;
> >>  	struct dax_device *dax_dev;
> >>  	pgoff_t pgoff;
> >>  	int err, id;
> > 
> > This now only uses sb for sb->s_id.  It might be better to use bdevname
> > to print the device name and don't bother passing a sb at all.
> > 
> 
> I think Darrick wanted to keep the API the same for non-XFS users. I'm
> ok with dropping the passed in sb if Darrick has no objections.

Fine with me to use bdevname.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
