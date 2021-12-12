Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A972C9E
	for <nvdimm@lists.linux.dev>; Sun, 12 Dec 2021 14:48:16 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso11382913pjb.0
        for <nvdimm@lists.linux.dev>; Sun, 12 Dec 2021 06:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J9eKyZRQJSa64buH1DnQ8o+5rJ2t1cRqyeDbRJ50KfQ=;
        b=BprTLS3JetufOXTjqHMIZ/doR1eF8o+RmR7bZ7L4z15WiJgnpRWJwDkBTdGNGjaZZh
         k791N8rn8M1nGukIBM0xkL+jUt9xHCli2JTS9SXSjS3f4Pmzj7Sgo1CIKmefKtGP2+uA
         q7WpW6T/3voza1lQqczSWvsmL4Vo1EIU1tV/pkPEEuGx1NlIYnmbpB/v/2WUGzMfPo0r
         Dsjtbq3uJZOagSXvLRO6UjzrRcuUysaiCiUjlkQkDw3+XSk1wMtVRCs4tYB2Kqlt9qGS
         KiffM8gWtpSqBx3vHTMci0xdj+SJno2xOEq74AViKGVCG09ZdRqE4mRRhbW5pXji54QD
         /ZSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J9eKyZRQJSa64buH1DnQ8o+5rJ2t1cRqyeDbRJ50KfQ=;
        b=qouw3U+JSRiyfP526qQgVVASFNenLlNC63vh6bYwPQ9NZU58z9NF/Unn0aDxXGXvqE
         M3FGtbNVocHr278gmJF5RhpexODWsas+rftImM1DwDNQuNeFFTkMzvaVCaMfazrwJAZk
         zIZ5ZNuFglrPupqjMKZTDtVL3KqZKlKKK96jXKwYQKaQ6Gq1QGLSYd9A6eSfFyW8kqLY
         ML+gwu9DkI07YYQrPIcdCPkD2lcsaRKKB3TzsNH1efLlin3VYGhjilobMdBDjgodkX/F
         9AenIkBZMq5JlPXzj0Pb7OWgeP2Bw2lSdCNAQ0qjF0+ixStZc/NHMe00tBpmT6kbe+LK
         EnIw==
X-Gm-Message-State: AOAM530QJmu4wrbsY7kwcwDiLERFL7RUUIuQ6PC9XUoOelEvk1sJv4dw
	CsRCL1DiIQWbmxPGhIlTfm8Hts+LRHhGusxVRByRjA==
X-Google-Smtp-Source: ABdhPJwABq62IFvC8Je+2tS1umh6MzmN/dQD3sgNomHUgnGTTqTS7vmAyUKH5BeY5i5mGqV95jTqKs6LCe1lv/XJ4YM=
X-Received: by 2002:a17:902:7fcd:b0:142:8ab3:ec0e with SMTP id
 t13-20020a1709027fcd00b001428ab3ec0emr88266767plb.4.1639320495664; Sun, 12
 Dec 2021 06:48:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211209063828.18944-1-hch@lst.de> <20211209063828.18944-6-hch@lst.de>
 <YbNejVRF5NQB0r83@redhat.com>
In-Reply-To: <YbNejVRF5NQB0r83@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 12 Dec 2021 06:48:05 -0800
Message-ID: <CAPcyv4i_HdnMcq6MmDMt-a5p=ojh_vsoAiES0vUYEh7HvC1O-A@mail.gmail.com>
Subject: Re: [PATCH 5/5] dax: always use _copy_mc_to_iter in dax_copy_to_iter
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, 
	Ira Weiny <ira.weiny@intel.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Matthew Wilcox <willy@infradead.org>, device-mapper development <dm-devel@redhat.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Fri, Dec 10, 2021 at 6:05 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Thu, Dec 09, 2021 at 07:38:28AM +0100, Christoph Hellwig wrote:
> > While using the MC-safe copy routines is rather pointless on a virtual device
> > like virtiofs,
>
> I was wondering about that. Is it completely pointless.
>
> Typically we are just mapping host page cache into qemu address space.
> That shows as virtiofs device pfn in guest and that pfn is mapped into
> guest application address space in mmap() call.
>
> Given on host its DRAM, so I would not expect machine check on load side
> so there was no need to use machine check safe variant.

That's a broken assumption, DRAM experiences multi-bit ECC errors.
Machine checks, data aborts, etc existed before PMEM.

>  But what if host
> filesystem is on persistent memory and using DAX. In that case load in
> guest can trigger a machine check. Not sure if that machine check will
> actually travel into the guest and unblock read() operation or not.
>
> But this sounds like a good change from virtiofs point of view, anyway.
>
> Thanks
> Vivek
>
>
> > it also isn't harmful at all.  So just use _copy_mc_to_iter
> > unconditionally to simplify the code.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  drivers/dax/super.c | 10 ----------
> >  fs/fuse/virtio_fs.c |  1 -
> >  include/linux/dax.h |  1 -
> >  3 files changed, 12 deletions(-)
> >
> > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > index ff676a07480c8..fe783234ca669 100644
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> > @@ -107,8 +107,6 @@ enum dax_device_flags {
> >       DAXDEV_SYNC,
> >       /* do not use uncached operations to write data */
> >       DAXDEV_CACHED,
> > -     /* do not use mcsafe operations to read data */
> > -     DAXDEV_NOMCSAFE,
> >  };
> >
> >  /**
> > @@ -171,8 +169,6 @@ size_t dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
> >        * via access_ok() in vfs_red, so use the 'no check' version to bypass
> >        * the HARDENED_USERCOPY overhead.
> >        */
> > -     if (test_bit(DAXDEV_NOMCSAFE, &dax_dev->flags))
> > -             return _copy_to_iter(addr, bytes, i);
> >       return _copy_mc_to_iter(addr, bytes, i);
> >  }
> >
> > @@ -242,12 +238,6 @@ void set_dax_cached(struct dax_device *dax_dev)
> >  }
> >  EXPORT_SYMBOL_GPL(set_dax_cached);
> >
> > -void set_dax_nomcsafe(struct dax_device *dax_dev)
> > -{
> > -     set_bit(DAXDEV_NOMCSAFE, &dax_dev->flags);
> > -}
> > -EXPORT_SYMBOL_GPL(set_dax_nomcsafe);
> > -
> >  bool dax_alive(struct dax_device *dax_dev)
> >  {
> >       lockdep_assert_held(&dax_srcu);
> > diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> > index 754319ce2a29b..d9c20b148ac19 100644
> > --- a/fs/fuse/virtio_fs.c
> > +++ b/fs/fuse/virtio_fs.c
> > @@ -838,7 +838,6 @@ static int virtio_fs_setup_dax(struct virtio_device *vdev, struct virtio_fs *fs)
> >       if (IS_ERR(fs->dax_dev))
> >               return PTR_ERR(fs->dax_dev);
> >       set_dax_cached(fs->dax_dev);
> > -     set_dax_nomcsafe(fs->dax_dev);
> >       return devm_add_action_or_reset(&vdev->dev, virtio_fs_cleanup_dax,
> >                                       fs->dax_dev);
> >  }
> > diff --git a/include/linux/dax.h b/include/linux/dax.h
> > index d22cbf03d37d2..d267331bc37e7 100644
> > --- a/include/linux/dax.h
> > +++ b/include/linux/dax.h
> > @@ -90,7 +90,6 @@ static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
> >  #endif
> >
> >  void set_dax_cached(struct dax_device *dax_dev);
> > -void set_dax_nomcsafe(struct dax_device *dax_dev);
> >
> >  struct writeback_control;
> >  #if defined(CONFIG_BLOCK) && defined(CONFIG_FS_DAX)
> > --
> > 2.30.2
> >
>
