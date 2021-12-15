Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CF9168
	for <nvdimm@lists.linux.dev>; Wed, 15 Dec 2021 03:09:49 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so17836121pjb.5
        for <nvdimm@lists.linux.dev>; Tue, 14 Dec 2021 19:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zV7Byx9t+KDsgsJ+lRahaZM7qh41MhISAIcarU0rIrs=;
        b=602lIADH8P0VxX3t15azUhnF4g8PeHZMtloaMQG4uOL1R82WuF0JrBx6pFOtz993GF
         NTUL3zyB44Tvo4UI07UeIj8wXBUatoMBpM3AFutfdSkjBKlgdOm8S14c4vNhwBl+8rGu
         ST63etO43gdF+JemQDiRWRxOlyD3CT8vQ0XDYPd9ayEkVpc6BSOTsAWSNIMX3YrAjLVI
         W7ncayOkW2TfhNpDzNDWbEeOM9FzNG+ESP9A48mEbyRHD4R6ZaVb7mOWEs5/2qh6NhaE
         hxBCthC8kRhqY3deTGWEcsg1qUck0ddwwKsrnGre1xi1zfYyWzxzmQmOSj9BLKUsmAf/
         sKzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zV7Byx9t+KDsgsJ+lRahaZM7qh41MhISAIcarU0rIrs=;
        b=iy4SELISH3/IhBWBTTuKkMdeCmvP5pbEdDwDyfGZqeQmKoyDLV786ywZixfxuqf6o8
         B4BKMvXxvCKox+gF4ArO+ErBYLbctIi0tMToa2HKjOkYcrRdsIafqPlre+wP0mr4KZED
         q6IdcXp2Y3XBmtj5IpPkjaAM7sxCJQhVwYZ01jFfiLj+aYIsCso3Ich/HrKBSPxZjgyJ
         7pzSqjRco3SAHmYOLQ7d66ckYs54hOGWA8WzGwm7cZQEgwMXxbrxtGfpvUwy3LiJzoVI
         GLxBkHG7Qlba1OgvkuL3+skiMDw2bbyO3Z9lz7wqJlBszQczEdVQryYKjPbdRAHPoUZv
         o+cA==
X-Gm-Message-State: AOAM531CFrAG20tajBa7FCrg1qPBObGLItfC8+8qAFszVyE1yuDmsSsu
	h7yV4GcrIkNLbkq3iC0D8Z7gAu18TteDgLm9q9qViw==
X-Google-Smtp-Source: ABdhPJyjMfaGYmiposIisiZRidNY8TOPZq1tLdw8NQ7Z5XZbq18nnyTwV4R/TrMM9ymfKh/aJSUi3bLLzquD7YpcUjU=
X-Received: by 2002:a17:903:41c1:b0:141:f28f:729e with SMTP id
 u1-20020a17090341c100b00141f28f729emr9342998ple.34.1639537789085; Tue, 14 Dec
 2021 19:09:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211202084856.1285285-1-ruansy.fnst@fujitsu.com> <20211202084856.1285285-3-ruansy.fnst@fujitsu.com>
In-Reply-To: <20211202084856.1285285-3-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 14 Dec 2021 19:09:38 -0800
Message-ID: <CAPcyv4gkjhrzNoRqwiWxps_ymAhmm3DJSWL7Lr+bLpSxSPvd0w@mail.gmail.com>
Subject: Re: [PATCH v8 2/9] dax: Introduce holder for dax_device
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	david <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Dec 2, 2021 at 12:49 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
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
>  drivers/dax/super.c | 61 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dax.h | 25 +++++++++++++++++++
>  2 files changed, 86 insertions(+)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 719e77b2c2d4..a19fcc0a54f3 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -20,15 +20,20 @@
>   * @inode: core vfs
>   * @cdev: optional character interface for "device dax"
>   * @private: dax driver private data
> + * @holder_data: holder of a dax_device: could be filesystem or mapped device
>   * @flags: state and boolean properties
> + * @ops: operations for dax_device
> + * @holder_ops: operations for the inner holder
>   */
>  struct dax_device {
>         struct inode inode;
>         struct cdev cdev;
>         void *private;
>         struct percpu_rw_semaphore rwsem;
> +       void *holder_data;
>         unsigned long flags;
>         const struct dax_operations *ops;
> +       const struct dax_holder_operations *holder_ops;
>  };
>
>  static dev_t dax_devt;
> @@ -190,6 +195,29 @@ int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
>  }
>  EXPORT_SYMBOL_GPL(dax_zero_page_range);
>
> +int dax_holder_notify_failure(struct dax_device *dax_dev, u64 off,
> +                             u64 len, int mf_flags)
> +{
> +       int rc;
> +
> +       dax_read_lock(dax_dev);
> +       if (!dax_alive(dax_dev)) {
> +               rc = -ENXIO;
> +               goto out;
> +       }
> +
> +       if (!dax_dev->holder_ops) {
> +               rc = -EOPNOTSUPP;
> +               goto out;
> +       }
> +
> +       rc = dax_dev->holder_ops->notify_failure(dax_dev, off, len, mf_flags);
> +out:
> +       dax_read_unlock(dax_dev);
> +       return rc;
> +}
> +EXPORT_SYMBOL_GPL(dax_holder_notify_failure);
> +
>  #ifdef CONFIG_ARCH_HAS_PMEM_API
>  void arch_wb_cache_pmem(void *addr, size_t size);
>  void dax_flush(struct dax_device *dax_dev, void *addr, size_t size)
> @@ -252,6 +280,10 @@ void kill_dax(struct dax_device *dax_dev)
>                 return;
>         dax_write_lock(dax_dev);
>         clear_bit(DAXDEV_ALIVE, &dax_dev->flags);
> +
> +       /* clear holder data */
> +       dax_dev->holder_ops = NULL;
> +       dax_dev->holder_data = NULL;
>         dax_write_unlock(dax_dev);
>  }
>  EXPORT_SYMBOL_GPL(kill_dax);
> @@ -399,6 +431,35 @@ void put_dax(struct dax_device *dax_dev)
>  }
>  EXPORT_SYMBOL_GPL(put_dax);
>
> +void dax_set_holder(struct dax_device *dax_dev, void *holder,
> +               const struct dax_holder_operations *ops)
> +{
> +       dax_write_lock(dax_dev);
> +       if (!dax_alive(dax_dev))
> +               goto out;
> +
> +       dax_dev->holder_data = holder;
> +       dax_dev->holder_ops = ops;
> +out:
> +       dax_write_unlock(dax_dev);

Why does this need to be a write_lock()? This is just like any other
dax_operation that can only operate while the dax device is alive.

> +}
> +EXPORT_SYMBOL_GPL(dax_set_holder);
> +
> +void *dax_get_holder(struct dax_device *dax_dev)
> +{
> +       void *holder = NULL;
> +
> +       dax_read_lock(dax_dev);
> +       if (!dax_alive(dax_dev))
> +               goto out;
> +
> +       holder = dax_dev->holder_data;
> +out:
> +       dax_read_unlock(dax_dev);
> +       return holder;

The read_lock should be held outside of this helper. I.e. the caller
of this will already want to do:

dax_read_lock()
dax_get_holder()
*do holder operation*
dax_read_unlock() <-- now device can finalize kill_dax().

> +}
> +EXPORT_SYMBOL_GPL(dax_get_holder);
> +
>  /**
>   * inode_dax: convert a public inode into its dax_dev
>   * @inode: An inode with i_cdev pointing to a dax_dev
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 8414a08dcbea..f01684a63447 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -44,6 +44,21 @@ struct dax_operations {
>  #if IS_ENABLED(CONFIG_DAX)
>  struct dax_device *alloc_dax(void *private, const struct dax_operations *ops,
>                 unsigned long flags);
> +struct dax_holder_operations {
> +       /*
> +        * notify_failure - notify memory failure into inner holder device
> +        * @dax_dev: the dax device which contains the holder
> +        * @offset: offset on this dax device where memory failure occurs
> +        * @len: length of this memory failure event
> +        * @flags: action flags for memory failure handler
> +        */
> +       int (*notify_failure)(struct dax_device *dax_dev, u64 offset,
> +                       u64 len, int mf_flags);
> +};
> +
> +void dax_set_holder(struct dax_device *dax_dev, void *holder,
> +               const struct dax_holder_operations *ops);
> +void *dax_get_holder(struct dax_device *dax_dev);
>  void put_dax(struct dax_device *dax_dev);
>  void kill_dax(struct dax_device *dax_dev);
>  void dax_write_cache(struct dax_device *dax_dev, bool wc);
> @@ -71,6 +86,14 @@ static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
>         return dax_synchronous(dax_dev);
>  }
>  #else
> +static inline void dax_set_holder(struct dax_device *dax_dev, void *holder,
> +               const struct dax_holder_operations *ops)
> +{
> +}
> +static inline void *dax_get_holder(struct dax_device *dax_dev)
> +{
> +       return NULL;
> +}
>  static inline struct dax_device *alloc_dax(void *private,
>                 const struct dax_operations *ops, unsigned long flags)
>  {
> @@ -199,6 +222,8 @@ size_t dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
>                 size_t bytes, struct iov_iter *i);
>  int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
>                         size_t nr_pages);
> +int dax_holder_notify_failure(struct dax_device *dax_dev, u64 off, u64 len,
> +               int mf_flags);
>  void dax_flush(struct dax_device *dax_dev, void *addr, size_t size);
>
>  ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
> --
> 2.34.0
>
>
>
