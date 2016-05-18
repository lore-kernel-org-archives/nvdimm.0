Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 9CC921A1FBE
 for <linux-nvdimm@lists.01.org>; Wed, 18 May 2016 12:30:39 -0700 (PDT)
Date: Wed, 18 May 2016 13:30:20 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH] remove unused blkdev_dax_capable() function
Message-ID: <20160518193020.GB20021@omniknight.lm.intel.com>
References: <1462897437-16626-1-git-send-email-toshi.kani@hpe.com>
 <1462897437-16626-7-git-send-email-toshi.kani@hpe.com>
 <3280835.MNk2ItMooy@wuerfel>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3280835.MNk2ItMooy@wuerfel>
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
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-block@vger.kernel.org, jack@suse.cz, linux-nvdimm@lists.01.org, axboe@fb.com, david@fromorbit.com, linux-kernel@vger.kernel.org, micah.parrish@hpe.com, hch@infradead.org, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, tytso@mit.edu, sfr@canb.auug.org.au
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 18, 2016 at 09:54:08AM +0200, Arnd Bergmann wrote:
> The change from blkdev_dax_capable() to bdev_dax_capable() removed the only user
> of the former, so we now get a build warning:
> 
> fs/block_dev.c:1244:13: error: 'blkdev_dax_capable' defined but not used [-Werror=unused-function]
>  static bool blkdev_dax_capable(struct block_device *bdev)
> 
> This removes the now-unused function.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: a8078b1fc616 ("block: Update blkdev_dax_capable() for consistency")
> ---
> On Tuesday 10 May 2016 10:23:57 Toshi Kani wrote:
> > @@ -1295,7 +1330,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
> >  
> >                         if (!ret) {
> >                                 bd_set_size(bdev,(loff_t)get_capacity(disk)<<9);
> > -                               if (!blkdev_dax_capable(bdev))
> > +                               if (!bdev_dax_capable(bdev))
> >                                         bdev->bd_inode->i_flags &= ~S_DAX;
> > 
> 
> It's not entirely from the patch description what the intention was here
> in keeping two slightly different implementations of the same function
> in one file, my best guess is that it was not intentional and we should
> just remove this.
> 

Good catch - like Toshi said, this was indeed a mis-merge.

Stephen, for reference, I've added a branch with the expected conflict
resolution at:

https://git.kernel.org/cgit/linux/kernel/git/nvdimm/nvdimm.git/ libnvdimm-for-4.7-merge

Thanks,
	-Vishal
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
