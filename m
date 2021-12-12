Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BAF2C9E
	for <nvdimm@lists.linux.dev>; Sun, 12 Dec 2021 14:44:37 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id y8so9472973plg.1
        for <nvdimm@lists.linux.dev>; Sun, 12 Dec 2021 06:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=agYW6DcaeuP+q4nan8V1VqgSNwzlJAeR6akaOZ2DEVE=;
        b=NhXgmEqiOO3TDAnM/oJYTe308BJdK34sJJBFru0szdBrVWgK9AoytL660B82dxWuHq
         Uk1WbiFnBpVzFZVCeNGfGlbraNzlE4y4q2b1Akd3exuclDWE56luAHTvH2uhmcv65HA/
         ZJO7p6YmjOOvQtXVf/jhtCiSdGV6YElJuPbrFu+mPyonxBMAO3PjGgZBXtY/J3piabR2
         34gwJnZUYWxDqlZKkERQCyAsIpvU6mlsyr8rrU8NEZpCpRRe7fPvv/9QSvYT9hweUYit
         rvMtfYbrkepesOsTejX8oKII9/8TKssEO0lrGkjJE1lymRG4b95lITyRik0ePoOzEmRj
         eI2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=agYW6DcaeuP+q4nan8V1VqgSNwzlJAeR6akaOZ2DEVE=;
        b=kWwBGReVU0JjbyVc7+/8w4nHgZR2C7cJLQgI/1eiJ/4wTZifWEwuArfdjkvs/Bp2hX
         tR0tanyFYanceEgYPzY0xzyEIpgRu9/6Pp6GKYJ35SbD3nDfhBrSh+BsTDtFC3Seaeth
         1OBoDxN0IgFlg1BA/EUYiay3yZRsQ9PPy/kpOqZkXeRpeuGIo1pnUugPO1KNOkBwkOQC
         y/vNW6IhaDaWa6xd/BuU1KUePVG/TEYT5aYjxN3ufU3GS1xT2phicS/QVtfbp/SlxdX8
         5xrkCcNYSo+2CPueHRFRb33gpuZjVUks5Rcl9biSoTE/yJgyzLYFu+fkkrEB9sXlmgr1
         FLRA==
X-Gm-Message-State: AOAM533Vs+Dc9pUvSpZHkawIvs8e4zDNzPl0oYMLFDCcUkQNFMRDYmQR
	8VgmrgxDGUeHCuCRG9ih/8VyrzOHogcrPeaQxyI8IQ==
X-Google-Smtp-Source: ABdhPJwLj56PBRqvGExnBUnnCkX5apEf9je516CrVNM0D8M9K2XSCF8Su7nlWxjv1JO1vwplQ6ww7tAn0NH7STTpMKQ=
X-Received: by 2002:a17:902:7fcd:b0:142:8ab3:ec0e with SMTP id
 t13-20020a1709027fcd00b001428ab3ec0emr88249325plb.4.1639320277138; Sun, 12
 Dec 2021 06:44:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211209063828.18944-1-hch@lst.de> <20211209063828.18944-5-hch@lst.de>
 <YbNhPXBg7G/ridkV@redhat.com>
In-Reply-To: <YbNhPXBg7G/ridkV@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 12 Dec 2021 06:44:26 -0800
Message-ID: <CAPcyv4g4_yFqDeS+pnAZOxcB=Ua+iArK5mqn0iMG4PX6oL=F_A@mail.gmail.com>
Subject: Re: [PATCH 4/5] dax: remove the copy_from_iter and copy_to_iter methods
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

On Fri, Dec 10, 2021 at 6:17 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Thu, Dec 09, 2021 at 07:38:27AM +0100, Christoph Hellwig wrote:
> > These methods indirect the actual DAX read/write path.  In the end pmem
> > uses magic flush and mc safe variants and fuse and dcssblk use plain ones
> > while device mapper picks redirects to the underlying device.
> >
> > Add set_dax_virtual() and set_dax_nomcsafe() APIs for fuse to skip these
> > special variants, then use them everywhere as they fall back to the plain
> > ones on s390 anyway and remove an indirect call from the read/write path
> > as well as a lot of boilerplate code.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  drivers/dax/super.c           | 36 ++++++++++++++--
> >  drivers/md/dm-linear.c        | 20 ---------
> >  drivers/md/dm-log-writes.c    | 80 -----------------------------------
> >  drivers/md/dm-stripe.c        | 20 ---------
> >  drivers/md/dm.c               | 50 ----------------------
> >  drivers/nvdimm/pmem.c         | 20 ---------
> >  drivers/s390/block/dcssblk.c  | 14 ------
> >  fs/dax.c                      |  5 ---
> >  fs/fuse/virtio_fs.c           | 19 +--------
> >  include/linux/dax.h           |  9 ++--
> >  include/linux/device-mapper.h |  4 --
> >  11 files changed, 37 insertions(+), 240 deletions(-)
> >
>
> [..]
> > diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> > index 5c03a0364a9bb..754319ce2a29b 100644
> > --- a/fs/fuse/virtio_fs.c
> > +++ b/fs/fuse/virtio_fs.c
> > @@ -753,20 +753,6 @@ static long virtio_fs_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
> >       return nr_pages > max_nr_pages ? max_nr_pages : nr_pages;
> >  }
> >
> > -static size_t virtio_fs_copy_from_iter(struct dax_device *dax_dev,
> > -                                    pgoff_t pgoff, void *addr,
> > -                                    size_t bytes, struct iov_iter *i)
> > -{
> > -     return copy_from_iter(addr, bytes, i);
> > -}
> > -
> > -static size_t virtio_fs_copy_to_iter(struct dax_device *dax_dev,
> > -                                    pgoff_t pgoff, void *addr,
> > -                                    size_t bytes, struct iov_iter *i)
> > -{
> > -     return copy_to_iter(addr, bytes, i);
> > -}
> > -
> >  static int virtio_fs_zero_page_range(struct dax_device *dax_dev,
> >                                    pgoff_t pgoff, size_t nr_pages)
> >  {
> > @@ -783,8 +769,6 @@ static int virtio_fs_zero_page_range(struct dax_device *dax_dev,
> >
> >  static const struct dax_operations virtio_fs_dax_ops = {
> >       .direct_access = virtio_fs_direct_access,
> > -     .copy_from_iter = virtio_fs_copy_from_iter,
> > -     .copy_to_iter = virtio_fs_copy_to_iter,
> >       .zero_page_range = virtio_fs_zero_page_range,
> >  };
> >
> > @@ -853,7 +837,8 @@ static int virtio_fs_setup_dax(struct virtio_device *vdev, struct virtio_fs *fs)
> >       fs->dax_dev = alloc_dax(fs, &virtio_fs_dax_ops);
> >       if (IS_ERR(fs->dax_dev))
> >               return PTR_ERR(fs->dax_dev);
> > -
> > +     set_dax_cached(fs->dax_dev);
>
> Looks good to me from virtiofs point of view.
>
> Reviewed-by: Vivek Goyal <vgoyal@redhat.com>
>
> Going forward, I am wondering should virtiofs use flushcache version as
> well. What if host filesystem is using DAX and mapping persistent memory
> pfn directly into qemu address space. I have never tested that.
>
> Right now we are relying on applications to do fsync/msync on virtiofs
> for data persistence.

This sounds like it would need coordination with a paravirtualized
driver that can indicate whether the host side is pmem or not, like
the virtio_pmem driver. However, if the guest sends any fsync/msync
you would still need to go explicitly cache flush any dirty page
because you can't necessarily trust that the guest did that already.

>
> > +     set_dax_nomcsafe(fs->dax_dev);
> >       return devm_add_action_or_reset(&vdev->dev, virtio_fs_cleanup_dax,
> >                                       fs->dax_dev);
> >  }
>
> Thanks
> Vivek
>
>
