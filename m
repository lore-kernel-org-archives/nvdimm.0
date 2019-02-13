Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6A195201B043A
 for <linux-nvdimm@lists.01.org>; Wed, 13 Feb 2019 08:50:00 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id 32so5319848ota.12
 for <linux-nvdimm@lists.01.org>; Wed, 13 Feb 2019 08:50:00 -0800 (PST)
MIME-Version: 1.0
References: <155000668075.348031.9371497273408112600.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155000669646.348031.16690970886357498896.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190213102202.GA13313@quack2.suse.cz>
In-Reply-To: <20190213102202.GA13313@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 13 Feb 2019 08:49:47 -0800
Message-ID: <CAPcyv4jwMx2ohs9QobTohL8jxc5G74XhmY5QFpmiVF9siWLuwA@mail.gmail.com>
Subject: Re: [PATCH 3/7] dax: Check the end of the block-device capacity with
 dax_direct_access()
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 13, 2019 at 2:22 AM Jan Kara <jack@suse.cz> wrote:
>
> On Tue 12-02-19 13:24:56, Dan Williams wrote:
> > The checks in __bdev_dax_supported() helped mitigate a potential data
> > corruption bug in the pmem driver's handling of section alignment
> > padding. Strengthen the checks, including checking the end of the range,
> > to validate the dev_pagemap, Xarray entries, and sector-to-pfn
> > translation established for pmem namespaces.
> >
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  drivers/dax/super.c |   39 +++++++++++++++++++++++++++++----------
> >  1 file changed, 29 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > index 6e928f37d084..a27395cfcec6 100644
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> > @@ -86,12 +86,14 @@ bool __bdev_dax_supported(struct block_device *bdev, int blocksize)
> >  {
> >       struct dax_device *dax_dev;
> >       bool dax_enabled = false;
> > +     pgoff_t pgoff, pgoff_end;
> >       struct request_queue *q;
> > -     pgoff_t pgoff;
> > -     int err, id;
> > -     pfn_t pfn;
> > -     long len;
> >       char buf[BDEVNAME_SIZE];
> > +     void *kaddr, *end_kaddr;
> > +     pfn_t pfn, end_pfn;
> > +     sector_t last_page;
> > +     long len, len2;
> > +     int err, id;
> >
> >       if (blocksize != PAGE_SIZE) {
> >               pr_debug("%s: error: unsupported blocksize for dax\n",
> > @@ -113,6 +115,15 @@ bool __bdev_dax_supported(struct block_device *bdev, int blocksize)
> >               return false;
> >       }
> >
> > +     last_page = ALIGN_DOWN(part_nr_sects_read(bdev->bd_part)
> > +                     - PAGE_SIZE / 512, PAGE_SIZE / 512);
>
> Why not just (i_size_read(bdev->bd_inode) - 1) >> PAGE_SHIFT?

Because that would be too elegant and straightforward?

> Otherwise the patch looks good to me.

Thanks, I'll fix up the last page calculation.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
