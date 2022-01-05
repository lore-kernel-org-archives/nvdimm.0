Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AE32C9C
	for <nvdimm@lists.linux.dev>; Wed,  5 Jan 2022 18:23:19 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id u20so78154pfi.12
        for <nvdimm@lists.linux.dev>; Wed, 05 Jan 2022 10:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O3txqHljQl/GCNxyCJxfFojCjkO470bmaKiTOmC1xSE=;
        b=iDaMKn+q7SGqX3ujdNUGLIq8rR9uST+ZG/7EUkKHkYITiY/9guw1ZRXf3Ht59Dz2kA
         IljULJEO3i+pPOzOnZXhD3vALfxADxcPKVZqVKrO/pzmcxvaa37+fRTER/WdpRu2YXiH
         XqA6bprq+O3qlgt6rpbnONeUrs2A5iUPw0Rr1Oy1rrK9MTDAm9TcPBdRKFW5yS4YufWJ
         Npd4V2aXugQPk341QkO2dH7kuWmID7i5orec/rVIGU1QPRTl8oafYAQgyLhqEOk1JFG/
         fpy6WAxwAtIUhlSp+IGClZEoLSmXUYQNHBB+0UeoK9tpNTY6HPYa/lBmoGxCn8zwKVzT
         bdLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O3txqHljQl/GCNxyCJxfFojCjkO470bmaKiTOmC1xSE=;
        b=RQKG7b9cng/BFouoMNK4oa06ClOqu5LId2s7DTQg1ydmMtZQy24CvFLxfWCM4HL6Fj
         R185SrtsCVJcYCv4TKlF0gRwNZWMU/LVb7AJ24ZUYWIZEQMgN14MAYNlZGs1hRasbqU2
         tZcfGUxjJrtRAYGD9+VqZuh9lW8HpT5O8wjQ8qEYNvLOPeMn9gVJf88IdGCqUaCiXKzj
         IPshTvFHwXapyJ9nGiT/kC9qMExTmTxChaeZwejQ+5V8pLV9onpXe3Zb9w3/y5/5wkKN
         6mV5m96yBoXdokfK05Y6QhLX8HBU5tGIlsF5DbtaEUhQLk2Yd9PK5HdePCJeSdzBMQ1w
         vpEw==
X-Gm-Message-State: AOAM530nX8YPGMBtbwozQ9/jKzUNQaHL9w79gzkOUcQ2G9EtPce3/n0Z
	ANTp7jqYM5ESpO/ostL5pDYapkAl1rcY08B7mcjuCA==
X-Google-Smtp-Source: ABdhPJxoBP/aT1AEtcGz3BudjHksIAmWp/YqSFrZQveftZYxEW3pAAMJ+2H/kJ2DcT1CwoBX6W8azzzA4zy/f9WM0+k=
X-Received: by 2002:a63:710f:: with SMTP id m15mr18291969pgc.40.1641406998932;
 Wed, 05 Jan 2022 10:23:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211226143439.3985960-1-ruansy.fnst@fujitsu.com>
 <20211226143439.3985960-3-ruansy.fnst@fujitsu.com> <20220105181230.GC398655@magnolia>
In-Reply-To: <20220105181230.GC398655@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 5 Jan 2022 10:23:08 -0800
Message-ID: <CAPcyv4iTaneUgdBPnqcvLr4Y_nAxQp31ZdUNkSRPsQ=9CpMWHg@mail.gmail.com>
Subject: Re: [PATCH v9 02/10] dax: Introduce holder for dax_device
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, david <david@fromorbit.com>, 
	Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jan 5, 2022 at 10:12 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Sun, Dec 26, 2021 at 10:34:31PM +0800, Shiyang Ruan wrote:
> > To easily track filesystem from a pmem device, we introduce a holder for
> > dax_device structure, and also its operation.  This holder is used to
> > remember who is using this dax_device:
> >  - When it is the backend of a filesystem, the holder will be the
> >    instance of this filesystem.
> >  - When this pmem device is one of the targets in a mapped device, the
> >    holder will be this mapped device.  In this case, the mapped device
> >    has its own dax_device and it will follow the first rule.  So that we
> >    can finally track to the filesystem we needed.
> >
> > The holder and holder_ops will be set when filesystem is being mounted,
> > or an target device is being activated.
> >
> > Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> > ---
> >  drivers/dax/super.c | 62 +++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/dax.h | 29 +++++++++++++++++++++
> >  2 files changed, 91 insertions(+)
> >
> > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > index c46f56e33d40..94c51f2ee133 100644
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> > @@ -20,15 +20,20 @@
> >   * @inode: core vfs
> >   * @cdev: optional character interface for "device dax"
> >   * @private: dax driver private data
> > + * @holder_data: holder of a dax_device: could be filesystem or mapped device
> >   * @flags: state and boolean properties
> > + * @ops: operations for dax_device
> > + * @holder_ops: operations for the inner holder
> >   */
> >  struct dax_device {
> >       struct inode inode;
> >       struct cdev cdev;
> >       void *private;
> >       struct percpu_rw_semaphore rwsem;
> > +     void *holder_data;
> >       unsigned long flags;
> >       const struct dax_operations *ops;
> > +     const struct dax_holder_operations *holder_ops;
> >  };
> >
> >  static dev_t dax_devt;
> > @@ -192,6 +197,29 @@ int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
> >  }
> >  EXPORT_SYMBOL_GPL(dax_zero_page_range);
> >
> > +int dax_holder_notify_failure(struct dax_device *dax_dev, u64 off,
> > +                           u64 len, int mf_flags)
> > +{
> > +     int rc;
> > +
> > +     dax_read_lock(dax_dev);
> > +     if (!dax_alive(dax_dev)) {
> > +             rc = -ENXIO;
> > +             goto out;
> > +     }
> > +
> > +     if (!dax_dev->holder_ops) {
> > +             rc = -EOPNOTSUPP;
> > +             goto out;
> > +     }
> > +
> > +     rc = dax_dev->holder_ops->notify_failure(dax_dev, off, len, mf_flags);
> > +out:
> > +     dax_read_unlock(dax_dev);
> > +     return rc;
> > +}
> > +EXPORT_SYMBOL_GPL(dax_holder_notify_failure);
> > +
> >  #ifdef CONFIG_ARCH_HAS_PMEM_API
> >  void arch_wb_cache_pmem(void *addr, size_t size);
> >  void dax_flush(struct dax_device *dax_dev, void *addr, size_t size)
> > @@ -254,6 +282,10 @@ void kill_dax(struct dax_device *dax_dev)
> >               return;
> >       dax_write_lock(dax_dev);
> >       clear_bit(DAXDEV_ALIVE, &dax_dev->flags);
> > +
> > +     /* clear holder data */
> > +     dax_dev->holder_ops = NULL;
> > +     dax_dev->holder_data = NULL;
> >       dax_write_unlock(dax_dev);
> >  }
> >  EXPORT_SYMBOL_GPL(kill_dax);
> > @@ -401,6 +433,36 @@ void put_dax(struct dax_device *dax_dev)
> >  }
> >  EXPORT_SYMBOL_GPL(put_dax);
> >
> > +void dax_register_holder(struct dax_device *dax_dev, void *holder,
> > +             const struct dax_holder_operations *ops)
> > +{
> > +     if (!dax_alive(dax_dev))
> > +             return;
> > +
> > +     dax_dev->holder_data = holder;
> > +     dax_dev->holder_ops = ops;
>
> Shouldn't this return an error code if the dax device is dead or if
> someone already registered a holder?  I'm pretty sure XFS should not
> bind to a dax device if someone else already registered for it...

Agree, yes.

>
> ...unless you want to use a notifier chain for failure events so that
> there can be multiple consumers of dax failure events?

No, I would hope not. It should be 1:1 holders to dax-devices. Similar
ownership semantics like bd_prepare_to_claim().
