Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 389DD1A1F1A
 for <linux-nvdimm@lists.01.org>; Wed, 11 May 2016 08:26:54 -0700 (PDT)
Date: Wed, 11 May 2016 17:26:46 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 6/6] block: Update blkdev_dax_capable() for consistency
Message-ID: <20160511152646.GF14744@quack2.suse.cz>
References: <1462897437-16626-1-git-send-email-toshi.kani@hpe.com>
 <1462897437-16626-7-git-send-email-toshi.kani@hpe.com>
 <20160511080537.GA14744@quack2.suse.cz>
 <1462976710.27137.140.camel@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1462976710.27137.140.camel@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Toshi Kani <toshi.kani@hpe.com>
Cc: hch@infradead.org, Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, micah.parrish@hpe.com, axboe@fb.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, tytso@mit.edu
List-ID: <linux-nvdimm@lists.01.org>

On Wed 11-05-16 08:25:10, Toshi Kani wrote:
> On Wed, 2016-05-11 at 10:05 +0200, Jan Kara wrote:
> > On Tue 10-05-16 10:23:57, Toshi Kani wrote:
> > > =

> > > blkdev_dax_capable() is similar to bdev_dax_supported(), but needs
> > > to remain as a separate interface for checking dax capability of
> > > a raw block device.
> > > =

> > > Rename and relocate blkdev_dax_capable() to keep them maintained
> > > consistently, and call bdev_direct_access() for the dax capability
> > > check.
> > ...
> > > =

> > > +bool bdev_dax_capable(struct block_device *bdev)
> > > +{
> > > +	struct gendisk *disk =3D bdev->bd_disk;
> > > +	struct blk_dax_ctl dax =3D {
> > > +		.size =3D PAGE_SIZE,
> > > +	};
> > > +
> > > +	if (!IS_ENABLED(CONFIG_FS_DAX))
> > > +		return false;
> >
> > Frankly, I prefer the #ifdef CONFIG_FS_DAX and just compile the code out
> > when DAX is not enabled (like it was with blkdev_dax_capable()). That w=
ay
> > we don't grow the kernel for people who don't care about DAX.
> =

> When CONFIG_FS_DAX is not set, the rest of the code is optimized out. =A0=
So,
> I think the code size is the same.
> =

> (gdb) disas bdev_dax_capable
> Dump of assembler code for function bdev_dax_capable:
> =A0=A0=A00xffffffff81260d20 <+0>:=A0=A0=A0=A0=A0callq=A0=A00xffffffff8181=
3c30 <__fentry__>
> =A0=A0=A00xffffffff81260d25 <+5>:=A0=A0=A0=A0=A0push=A0=A0=A0%rbp
> =A0=A0=A00xffffffff81260d26 <+6>:=A0=A0=A0=A0=A0xor=A0=A0=A0=A0%eax,%eax
> =A0=A0=A00xffffffff81260d28 <+8>:=A0=A0=A0=A0=A0mov=A0=A0=A0=A0%rsp,%rbp
> =A0=A0=A00xffffffff81260d2b <+11>:=A0=A0=A0=A0pop=A0=A0=A0=A0%rbp
> =A0=A0=A00xffffffff81260d2c <+12>:=A0=A0=A0=A0retq=A0=A0=A0
> End of assembler dump.

Ah, good. So feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- =

Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
