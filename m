Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2713FC0
	for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 20:19:21 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id n5so8075370pjt.4
        for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 13:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BkGBH+Sk2bQQ3B5sfYf3Y77q6TOaLfRpAcPAwL8BdAo=;
        b=ecXEd1DeQkdKgu9gLiR1FnqZyViNsljclorUBJyGwLxYUHCPK4WZISv10/u9Zptlus
         FVsZhPWNk6afCvlXCEt/KypYJRqjVv5p4tB38Y4xQ7N8hQCHiFCI1Wy/0r13jIzLcFY3
         SVzcwNQEvMNUNmxDkS84Rd3A8dwjCiHQJ1/v/P2RaI7/M6PwE2f4GmEJ0J669WZT+2vw
         K5jV5336LwDoCgbQu5A590/GgUZUWFEILYVLvL2rDGR+IP8aJRMkYB8JDJcpGwXt0HxZ
         hsjVMAkPb8RtHCOiKvnFbj2Fg4ExPof2GDhJELQ4h5ADtPHTZbBazYzWXh/7eNNia8NY
         lOHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BkGBH+Sk2bQQ3B5sfYf3Y77q6TOaLfRpAcPAwL8BdAo=;
        b=W3+HJ6w4GG0Bp+GedvZ81XsWK5swzyYJM1974G5J4wDaT0PTreuIlgun0Kn8dp53jc
         c9rfIzSsRfZ72XtE+y9ST+TETdlQjJql2zzfXCBY+T9c6s2mjnUi5JQ7jl7+sICVvnyN
         VxThmww3ioIjRUPaHPR59uG57XNnUpd6F4ce6RI9wAi/A8WVDtKUcAZDxY4jqjLSYQkU
         VcVVch7yPI0HELn6oZFD0bKpUaWL6yenoFL1h5C4x8GfaikKouLgY/9gPNSvqoXnKQMc
         uSjNDTEwSCtmu2dDc5/M0zUp0C1fYxMM/JS46Tb5v78R3SBmHlrhk2zwEGnvIcX9SR0L
         dqSA==
X-Gm-Message-State: AOAM5309lbBM24Olmgw5PZlyWE5YPRdJmlK6r0s65168FzEnJq1TyJXW
	WeldGcSSdzp+1NXWnOXAExJse7Cwv4Cuublq9ea/PA==
X-Google-Smtp-Source: ABdhPJzHkxMGpPeA9h8LIot15bFD38zvkcY7p2LLxN6VLnB4hejIZ98f8Ub0InyuHc2GQ/N4yQ3nMHLlOt8cA/d6bXM=
X-Received: by 2002:a17:902:c10a:b0:12d:97e1:f035 with SMTP id
 10-20020a170902c10a00b0012d97e1f035mr17854315pli.52.1629490761440; Fri, 20
 Aug 2021 13:19:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com> <20210730100158.3117319-3-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210730100158.3117319-3-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Aug 2021 13:19:10 -0700
Message-ID: <CAPcyv4gd6O=Aaghn3bnAchc3o06J01SwPCg0KHPQLTTguoxdLw@mail.gmail.com>
Subject: Re: [PATCH RESEND v6 2/9] dax: Introduce holder for dax_device
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	device-mapper development <dm-devel@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>, 
	Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Jul 30, 2021 at 3:02 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> To easily track filesystem from a pmem device, we introduce a holder for
> dax_device structure, and also its operation.  This holder is used to
> remember who is using this dax_device:
>  - When it is the backend of a filesystem, the holder will be the
>    superblock of this filesystem.
>  - When this pmem device is one of the targets in a mapped device, the
>    holder will be this mapped device.  In this case, the mapped device
>    has its own dax_device and it will follow the first rule.  So that we
>    can finally track to the filesystem we needed.
>
> The holder and holder_ops will be set when filesystem is being mounted,
> or an target device is being activated.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  drivers/dax/super.c | 46 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dax.h | 17 +++++++++++++++++
>  2 files changed, 63 insertions(+)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 5fa6ae9dbc8b..00c32dfa5665 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -214,6 +214,8 @@ enum dax_device_flags {
>   * @cdev: optional character interface for "device dax"
>   * @host: optional name for lookups where the device path is not available
>   * @private: dax driver private data
> + * @holder_rwsem: prevent unregistration while holder_ops is in progress
> + * @holder_data: holder of a dax_device: could be filesystem or mapped device
>   * @flags: state and boolean properties
>   */
>  struct dax_device {
> @@ -222,8 +224,11 @@ struct dax_device {
>         struct cdev cdev;
>         const char *host;
>         void *private;
> +       struct rw_semaphore holder_rwsem;
> +       void *holder_data;
>         unsigned long flags;
>         const struct dax_operations *ops;
> +       const struct dax_holder_operations *holder_ops;
>  };
>
>  static ssize_t write_cache_show(struct device *dev,
> @@ -373,6 +378,25 @@ int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
>  }
>  EXPORT_SYMBOL_GPL(dax_zero_page_range);
>
> +int dax_holder_notify_failure(struct dax_device *dax_dev, loff_t offset,
> +                             size_t size, void *data)
I took a look at patch3 and had some questions about the api.

Can you add kernel-doc for this api and specifically clarify what is
@data used for vs dax_dev->holder_data?

I also think the holder needs to know whether this failure is being
signaled synchronously. or asynchronously. In the synchronous case a
process has consumed poison and action needs to be taken immediately.
In the asynchronous case the driver stack has encountered failed
address ranges and is notifying the holder to avoid those ranges, but
no immediate action needs to be taken to shoot down mappings. For
example, I would use the synchronous notification when
memory_failure() is invoked with the "action required" indication, and
the asynchronous notification when an NVDIMM_REVALIDATE_POISON event
fires, or the "action optional" memory_failure() case.

In short I think the interface just needs a flags argument.


> +{
> +       int rc;
> +
> +       if (!dax_dev)
> +               return -ENXIO;
> +
> +       if (!dax_dev->holder_data)
> +               return -EOPNOTSUPP;
> +
> +       down_read(&dax_dev->holder_rwsem);
> +       rc = dax_dev->holder_ops->notify_failure(dax_dev, offset,
> +                                                        size, data);
> +       up_read(&dax_dev->holder_rwsem);
> +       return rc;
> +}
> +EXPORT_SYMBOL_GPL(dax_holder_notify_failure);
> +
>  #ifdef CONFIG_ARCH_HAS_PMEM_API
>  void arch_wb_cache_pmem(void *addr, size_t size);
>  void dax_flush(struct dax_device *dax_dev, void *addr, size_t size)
> @@ -603,6 +627,7 @@ struct dax_device *alloc_dax(void *private, const char *__host,
>         dax_add_host(dax_dev, host);
>         dax_dev->ops = ops;
>         dax_dev->private = private;
> +       init_rwsem(&dax_dev->holder_rwsem);
>         if (flags & DAXDEV_F_SYNC)
>                 set_dax_synchronous(dax_dev);
>
> @@ -624,6 +649,27 @@ void put_dax(struct dax_device *dax_dev)
>  }
>  EXPORT_SYMBOL_GPL(put_dax);
>
> +void dax_set_holder(struct dax_device *dax_dev, void *holder,
> +               const struct dax_holder_operations *ops)
> +{
> +       if (!dax_dev)
> +               return;
> +       down_write(&dax_dev->holder_rwsem);
> +       dax_dev->holder_data = holder;
> +       dax_dev->holder_ops = ops;
> +       up_write(&dax_dev->holder_rwsem);
> +}
> +EXPORT_SYMBOL_GPL(dax_set_holder);
> +
> +void *dax_get_holder(struct dax_device *dax_dev)
> +{
> +       if (!dax_dev)
> +               return NULL;
> +
> +       return dax_dev->holder_data;
> +}
> +EXPORT_SYMBOL_GPL(dax_get_holder);
> +
>  /**
>   * dax_get_by_host() - temporary lookup mechanism for filesystem-dax
>   * @host: alternate name for the device registered by a dax driver
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index b52f084aa643..6f4b5c97ceb0 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -38,10 +38,17 @@ struct dax_operations {
>         int (*zero_page_range)(struct dax_device *, pgoff_t, size_t);
>  };
>
> +struct dax_holder_operations {
> +       int (*notify_failure)(struct dax_device *, loff_t, size_t, void *);
> +};
> +
>  extern struct attribute_group dax_attribute_group;
>
>  #if IS_ENABLED(CONFIG_DAX)
>  struct dax_device *dax_get_by_host(const char *host);
> +void dax_set_holder(struct dax_device *dax_dev, void *holder,
> +               const struct dax_holder_operations *ops);
> +void *dax_get_holder(struct dax_device *dax_dev);
>  struct dax_device *alloc_dax(void *private, const char *host,
>                 const struct dax_operations *ops, unsigned long flags);
>  void put_dax(struct dax_device *dax_dev);
> @@ -77,6 +84,14 @@ static inline struct dax_device *dax_get_by_host(const char *host)
>  {
>         return NULL;
>  }
> +static inline void dax_set_holder(struct dax_device *dax_dev, void *holder,
> +               const struct dax_holder_operations *ops)
> +{
> +}
> +static inline void *dax_get_holder(struct dax_device *dax_dev)
> +{
> +       return NULL;
> +}
>  static inline struct dax_device *alloc_dax(void *private, const char *host,
>                 const struct dax_operations *ops, unsigned long flags)
>  {
> @@ -226,6 +241,8 @@ size_t dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
>                 size_t bytes, struct iov_iter *i);
>  int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
>                         size_t nr_pages);
> +int dax_holder_notify_failure(struct dax_device *dax_dev, loff_t offset,
> +               size_t size, void *data);
>  void dax_flush(struct dax_device *dax_dev, void *addr, size_t size);
>
>  ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
> --
> 2.32.0
>
>
>
