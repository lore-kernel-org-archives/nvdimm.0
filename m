Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id B440B1A1FBE
 for <linux-nvdimm@lists.01.org>; Wed, 13 Apr 2016 11:22:57 -0700 (PDT)
Date: Wed, 13 Apr 2016 14:22:49 -0400
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH v2 2/5] ext4: call dax_get_unmapped_area() for DAX pmd
 mappings
Message-ID: <20160413182249.GB3120@linux.intel.com>
References: <1460493572-31667-1-git-send-email-toshi.kani@hpe.com>
 <20160413030156.GN2781@linux.intel.com>
 <1460560116.24985.55.camel@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1460560116.24985.55.camel@hpe.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, akpm@linux-foundation.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 13, 2016 at 09:08:36AM -0600, Toshi Kani wrote:
> > Could you do something like:
> > =

> > =A0#ifdef CONFIG_FS_DAX
> > =A0struct page *read_dax_sector(struct block_device *bdev, sector_t n);
> > +unsigned long dax_get_unmapped_area(struct file *filp, unsigned long
> > addr,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0unsigned long len, unsign=
ed long pgoff, unsigned long
> > flags);
> > =A0#else
> > =A0static inline struct page *read_dax_sector(struct block_device *bdev,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sector_t n)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0return ERR_PTR(-ENXIO);
> > =A0}
> > +#define dax_get_unmapped_area	NULL
> > =A0#endif
> > =

> > in patch 1/5.=A0=A0Then there's no need for the ifdefs in each filesyst=
em.
> =

> I thought about it, but I do not think we can use an inline function to an
> entry point.

That's not an inline function.  It's just NULL.  So after the preprocessor
is done with it, it just looks like:

	.get_unmapped_area =3D NULL,

and it won't be called by get_unmapped_area().
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
