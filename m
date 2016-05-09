Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
 [150.101.137.131]) by ml01.01.org (Postfix) with ESMTP id EEB9A1A1DFF
 for <linux-nvdimm@lists.01.org>; Mon,  9 May 2016 14:19:26 -0700 (PDT)
Date: Tue, 10 May 2016 07:19:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 2/5] block: Add bdev_supports_dax() for dax mount checks
Message-ID: <20160509211903.GW18496@dastard>
References: <1462494596-20938-1-git-send-email-toshi.kani@hpe.com>
 <1462494596-20938-3-git-send-email-toshi.kani@hpe.com>
 <CAPcyv4hKpvF6uqBzV+1seUzFfxDZM-ApordAL_NecRLNcdNgwg@mail.gmail.com>
 <1462817565.27137.102.camel@hpe.com>
 <CAPcyv4g6mPsmHM6OSTi78n_KBKCZrb1ou90=xWuhc7eGyx0DPg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4g6mPsmHM6OSTi78n_KBKCZrb1ou90=xWuhc7eGyx0DPg@mail.gmail.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, micah.parrish@hpe.com, Jens Axboe <axboe@fb.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 09, 2016 at 11:23:03AM -0700, Dan Williams wrote:
> On Mon, May 9, 2016 at 11:12 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> > On Sun, 2016-05-08 at 12:14 -0700, Dan Williams wrote:
> >> On Thu, May 5, 2016 at 5:29 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
> >  :
> >> > +int bdev_supports_dax(struct super_block *sb, int blocksize)
> >> > +{
> >> > +       struct blk_dax_ctl dax = {
> >> > +               .sector = 0,
> >> > +               .size = PAGE_SIZE,
> >> > +       };
> >> > +       int err;
> >> > +
> >> > +       if (blocksize != PAGE_SIZE) {
> >> > +               vfs_msg(sb, KERN_ERR, "error: unsupported blocksize for
> >> > dax");
> >> > +               return -EINVAL;
> >> > +       }
> >> > +
> >> > +       err = bdev_direct_access(sb->s_bdev, &dax);
> >> > +       if (err < 0) {
> >> > +               switch (err) {
> >> > +               case -EOPNOTSUPP:
> >> > +                       vfs_msg(sb, KERN_ERR,
> >> > +                               "error: device does not support dax");
> >> > +                       break;
> >> > +               case -EINVAL:
> >> > +                       vfs_msg(sb, KERN_ERR,
> >> > +                               "error: unaligned partition for dax");
> >> > +                       break;
> >> > +               default:
> >> > +                       vfs_msg(sb, KERN_ERR,
> >> > +                               "error: dax access failed (%d)", err);
> >> > +               }
> >> > +               return err;
> >> > +       }
> >> > +
> >> > +       return 0;
> >> > +}
> >> > +EXPORT_SYMBOL_GPL(bdev_supports_dax);
> >>
> >> This patch should replace blkdev_dax_capable(), or just reuse that
> >> existing routine, or am I missing something?
> >
> > Good question.  bdev_supports_dax() is a helper function tailored for the
> > filesystem's mount -o dax case.  While blkdev_dax_capable() is similar, it
> > does not need error messages like "device does not support dax" since it
> > implicitly enables dax when capable.  So, I think we can keep
> > blkdev_dax_capable(), but change it to call bdev_direct_access() so that
> > actual check is performed in a single place.
> 
> Sounds good to me.

Can you name them consistently then? i.e. blkdev_dax_supported() and
blkdev_dax_capable()?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
