Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77975258E
	for <nvdimm@lists.linux.dev>; Fri, 11 Mar 2022 23:35:25 +0000 (UTC)
Received: by mail-pg1-f169.google.com with SMTP id t14so8694151pgr.3
        for <nvdimm@lists.linux.dev>; Fri, 11 Mar 2022 15:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=13t7T+1H2gbtDRvuwDVr1bm3a+2J2xIzpet95fdBuh4=;
        b=RIgXQdVfVb6lODawzvdTxr4kAtwLPsRjREsyVUC9K9FXvakpJNymy17e6FkbZx5Gvv
         LeDcUKOKw2VoVa83HdzrEPE+n4lq8xuCULunoupKYxugg5JDuOq5trFf3fm42gMytdUt
         ERkjzkjwpAU0zoJJj8eO/F2dpsyBXR6QjMjtDGcOsDfDr2CJipG41gyKlmh4HlNGNwWJ
         vwkcU6O57nxaJWLRTl+0Hya9nMI7GHfWxpWRkjw+wUNIj2S8tgExKh9huQ4lWfIYS5K0
         A8C1eX/+5cBiho3K4ItispCSGtWUy9zYfhJ3aJCa4TY2pJ8nVxCb77Wvrz7OmBeIoOjA
         1QIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=13t7T+1H2gbtDRvuwDVr1bm3a+2J2xIzpet95fdBuh4=;
        b=wrxYuZigLqpznEuETRYPoTylfQx4/3Gn0Rkmjc2cMEOd/nCCjnfgIlBufZMSrJHt4X
         FiPwl2QfD22Ao9wM0TH5yAVqDguKHH+NexiKXYX5+q+hdUZUMtEfi/JnFUyCO1qVH7nT
         IPJ8nBFzF5KSNJdBpMWzoYK4tWDWgBnIYwSDm2gv023gSZz8f9z3fEgciO+KuLSDdx1G
         uf37MNaMYDRTHav8U6D1srYASYA4LVrV4XbnOoAdzgZmpJG7hwHjkESTzFbhmpPL/moC
         TecKuAFhoYv9oUx4YR4J/v5IF01tmEImwveWWr6ro1j3DdYAoB6O8SKT1961m4pZN0jw
         Og8Q==
X-Gm-Message-State: AOAM53019Ma1X5G0eeIpIQJsuxLa3fJuH7dD2jE8Ydo00LdYA7Rc87sm
	KfDY2fe8oU1iYl4AkShk+j7rrls8pIomZbAbVTiHRA==
X-Google-Smtp-Source: ABdhPJy2YDPTfdvIBlgNDhr+xnU7i87kZGa7MwrAaA3nvXLDFGkcmuMWf5/eMsJKEsCu2BWW9StjfFYHKRuRIZXl8BI=
X-Received: by 2002:a62:1481:0:b0:4f6:38c0:ed08 with SMTP id
 123-20020a621481000000b004f638c0ed08mr12796868pfu.86.1647041724808; Fri, 11
 Mar 2022 15:35:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220227120747.711169-1-ruansy.fnst@fujitsu.com> <20220227120747.711169-2-ruansy.fnst@fujitsu.com>
In-Reply-To: <20220227120747.711169-2-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 Mar 2022 15:35:13 -0800
Message-ID: <CAPcyv4jAqV7dZdmGcKrG=f8sYmUXaL7YCQtME6GANywncwd+zg@mail.gmail.com>
Subject: Re: [PATCH v11 1/8] dax: Introduce holder for dax_device
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	david <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Sun, Feb 27, 2022 at 4:08 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> To easily track filesystem from a pmem device, we introduce a holder for
> dax_device structure, and also its operation.  This holder is used to
> remember who is using this dax_device:
>  - When it is the backend of a filesystem, the holder will be the
>    instance of this filesystem.
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
>  drivers/dax/super.c | 89 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dax.h | 32 ++++++++++++++++
>  2 files changed, 121 insertions(+)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index e3029389d809..da5798e19d57 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -21,6 +21,9 @@
>   * @cdev: optional character interface for "device dax"
>   * @private: dax driver private data
>   * @flags: state and boolean properties
> + * @ops: operations for dax_device
> + * @holder_data: holder of a dax_device: could be filesystem or mapped device
> + * @holder_ops: operations for the inner holder
>   */
>  struct dax_device {
>         struct inode inode;
> @@ -28,6 +31,8 @@ struct dax_device {
>         void *private;
>         unsigned long flags;
>         const struct dax_operations *ops;
> +       void *holder_data;
> +       const struct dax_holder_operations *holder_ops;
>  };
>
>  static dev_t dax_devt;
> @@ -193,6 +198,29 @@ int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
>  }
>  EXPORT_SYMBOL_GPL(dax_zero_page_range);
>
> +int dax_holder_notify_failure(struct dax_device *dax_dev, u64 off,
> +                             u64 len, int mf_flags)
> +{
> +       int rc, id;
> +
> +       id = dax_read_lock();
> +       if (!dax_alive(dax_dev)) {
> +               rc = -ENXIO;
> +               goto out;
> +       }
> +
> +       if (!dax_dev->holder_ops) {
> +               rc = -EOPNOTSUPP;

I think it is ok to return success (0) for this case. All the caller
of dax_holder_notify_failure() wants to know is if the notification
was successfully delivered to the holder. If there is no holder
present then there is nothing to report. This is minor enough for me
to fix up locally if nothing else needs to be changed.

> +               goto out;
> +       }
> +
> +       rc = dax_dev->holder_ops->notify_failure(dax_dev, off, len, mf_flags);
> +out:
> +       dax_read_unlock(id);
> +       return rc;
> +}
> +EXPORT_SYMBOL_GPL(dax_holder_notify_failure);
> +
>  #ifdef CONFIG_ARCH_HAS_PMEM_API
>  void arch_wb_cache_pmem(void *addr, size_t size);
>  void dax_flush(struct dax_device *dax_dev, void *addr, size_t size)
> @@ -268,6 +296,10 @@ void kill_dax(struct dax_device *dax_dev)
>
>         clear_bit(DAXDEV_ALIVE, &dax_dev->flags);
>         synchronize_srcu(&dax_srcu);
> +
> +       /* clear holder data */
> +       dax_dev->holder_ops = NULL;
> +       dax_dev->holder_data = NULL;

Isn't this another failure scenario? If kill_dax() is called while a
holder is still holding the dax_device that seems to be another
->notify_failure scenario to tell the holder that the device is going
away and the holder has not released the device yet.

>  }
>  EXPORT_SYMBOL_GPL(kill_dax);
>
> @@ -409,6 +441,63 @@ void put_dax(struct dax_device *dax_dev)
>  }
>  EXPORT_SYMBOL_GPL(put_dax);
>
> +/**
> + * dax_holder() - obtain the holder of a dax device
> + * @dax_dev: a dax_device instance
> +
> + * Return: the holder's data which represents the holder if registered,
> + * otherwize NULL.
> + */
> +void *dax_holder(struct dax_device *dax_dev)
> +{
> +       if (!dax_alive(dax_dev))
> +               return NULL;

It's safe for the holder to assume that it can de-reference
->holder_data freely in its notify_handler callback because
dax_holder_notify_failure() arranges for the callback to run in
dax_read_lock() context.

This is another minor detail that I can fixup locally.

> +
> +       return dax_dev->holder_data;
> +}
> +EXPORT_SYMBOL_GPL(dax_holder);
> +
> +/**
> + * dax_register_holder() - register a holder to a dax device
> + * @dax_dev: a dax_device instance
> + * @holder: a pointer to a holder's data which represents the holder
> + * @ops: operations of this holder
> +
> + * Return: negative errno if an error occurs, otherwise 0.
> + */
> +int dax_register_holder(struct dax_device *dax_dev, void *holder,
> +               const struct dax_holder_operations *ops)
> +{
> +       if (!dax_alive(dax_dev))
> +               return -ENXIO;
> +
> +       if (cmpxchg(&dax_dev->holder_data, NULL, holder))
> +               return -EBUSY;
> +
> +       dax_dev->holder_ops = ops;
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(dax_register_holder);
> +
> +/**
> + * dax_unregister_holder() - unregister the holder for a dax device
> + * @dax_dev: a dax_device instance
> + * @holder: the holder to be unregistered
> + *
> + * Return: negative errno if an error occurs, otherwise 0.
> + */
> +int dax_unregister_holder(struct dax_device *dax_dev, void *holder)
> +{
> +       if (!dax_alive(dax_dev))
> +               return -ENXIO;
> +
> +       if (cmpxchg(&dax_dev->holder_data, holder, NULL) != holder)
> +               return -EBUSY;
> +       dax_dev->holder_ops = NULL;
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(dax_unregister_holder);
> +
>  /**
>   * inode_dax: convert a public inode into its dax_dev
>   * @inode: An inode with i_cdev pointing to a dax_dev
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 9fc5f99a0ae2..262d7bad131a 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -32,8 +32,24 @@ struct dax_operations {
>         int (*zero_page_range)(struct dax_device *, pgoff_t, size_t);
>  };
>
> +struct dax_holder_operations {
> +       /*
> +        * notify_failure - notify memory failure into inner holder device
> +        * @dax_dev: the dax device which contains the holder
> +        * @offset: offset on this dax device where memory failure occurs
> +        * @len: length of this memory failure event

Forgive me if this has been discussed before, but since dax_operations
are in terms of pgoff and nr pages and memory_failure() is in terms of
pfns what was the rationale for making the function signature byte
based?

I want to get this series merged into linux-next shortly after
v5.18-rc1. Then we can start working on incremental fixups rather
resending the full series with these long reply cycles.
