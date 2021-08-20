Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143AA3FC3
	for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 20:51:34 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id oc2-20020a17090b1c0200b00179e56772d6so4802100pjb.4
        for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 13:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ULkGRivL56ptdhLg0qblOi29E6UuI3GKppQ73W5RcQM=;
        b=wljVRLX4qPe+NrAUHjhvsefxSXN6ijVZv63Pk+E8YjbzTLnFXsawQ4zasGGHJ9DI/j
         LNnvEAJOChgaeq15qhAKQrNdM+zSHl83TKm21KHMzu/Kj34ogt2J8PlNoComIFiSxTux
         ZKAeASlP7cb89cYcVuiKawdWSszkqhTR6dDUO6JiMBsI2TJxtUKHqwu8/Mu+C8IAY6TH
         IBg2Cuwk7G5a8G6lOMJjraA6x87/5aIT/X9Nt616MtxhG+Oyu8CGTIEk74nvOt3pIg5R
         jyMa0gao/WvU4WUXcSgzEhn+z0TTdpm2b2ioKkK5gyn1+vGrSRBrUOY03LKG9SxDZltK
         zElQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ULkGRivL56ptdhLg0qblOi29E6UuI3GKppQ73W5RcQM=;
        b=nWGZ2bQmciX1/VULXKlY/GODxBLtFYfJYi2DDJp0pTGEUlAga+SXLtzl8tKMdzsvJq
         f88ZmY8ybsxUTPMN44bcitHYqU7kxybJmV99ZS5IXtxplXcXqOk5iqR6y/XkWaOrad0r
         rW4vqgIgaICrUhQ+Uqjfh6Ip6E/AM8Hj4uppucrZfN7Wvj8Fj//m+0r6+DS/O6aFH7zp
         6588d9w+JRnDodnan4fXE8KdSAhLqanaxJP1AXF1RUB8wWmNT40w0iIb5FRKD3Qbw7tL
         O4comJ5r/RfXGXwk5yMmYyeo2F7U/BnXXHz5cwqq87Z2WlWImf5FeuIR3KhP6SdXzRNm
         ZECA==
X-Gm-Message-State: AOAM533FFFI9ieznmTJTG6DVRHbUA8lUtgnWS7uFAgzYLy4vXpqMQiIh
	FN84ksxKau51u6QkokvtUSKgUKjnQ9XPYoQKzJ7mvFXSsM7tHg==
X-Google-Smtp-Source: ABdhPJzPJ2XQpEtJq+wbuCgzapFmXjO/y38fzH3RNB8Wj2SGZHiAnemQziTjbPerD3pCdyF6tyAETSGC8SlS9MQj/UI=
X-Received: by 2002:a17:902:e54e:b0:12d:cca1:2c1f with SMTP id
 n14-20020a170902e54e00b0012dcca12c1fmr17574055plf.79.1629492693543; Fri, 20
 Aug 2021 13:51:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com> <20210730100158.3117319-5-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210730100158.3117319-5-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Aug 2021 13:51:22 -0700
Message-ID: <CAPcyv4hQgSV6n0nuiqm-cv7pvpwDgBgZMezW7TkdR9SaAiCNHg@mail.gmail.com>
Subject: Re: [PATCH RESEND v6 4/9] pmem,mm: Implement ->memory_failure in pmem driver
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	device-mapper development <dm-devel@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>, 
	Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Jul 30, 2021 at 3:02 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> With dax_holder notify support, we are able to notify the memory failure
> from pmem driver to upper layers.  If there is something not support in
> the notify routine, memory_failure will fall back to the generic hanlder.

How about:

"Any layer can return -EOPNOTSUPP to force memory_failure() to fall
back to its generic implementation."


>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  drivers/nvdimm/pmem.c | 13 +++++++++++++
>  mm/memory-failure.c   | 14 ++++++++++++++
>  2 files changed, 27 insertions(+)
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 1e0615b8565e..fea4ffc333b8 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -362,9 +362,22 @@ static void pmem_release_disk(void *__pmem)
>         del_gendisk(pmem->disk);
>  }
>
> +static int pmem_pagemap_memory_failure(struct dev_pagemap *pgmap,
> +               unsigned long pfn, unsigned long nr_pfns, int flags)
> +{
> +       struct pmem_device *pmem =
> +                       container_of(pgmap, struct pmem_device, pgmap);
> +       loff_t offset = PFN_PHYS(pfn) - pmem->phys_addr - pmem->data_offset;
> +
> +       return dax_holder_notify_failure(pmem->dax_dev, offset,
> +                                        page_size(pfn_to_page(pfn)) * nr_pfns,

I do not understand the usage of page_size() here? memory_failure()
assumes PAGE_SIZE pages. DAX pages also do not populate the compound
metadata yet, but even if they did I would expect memory_failure() to
be responsible for doing something like:

    pgmap->ops->memory_failure(pgmap, pfn, size >> PAGE_SHIFT, flags);

...where @size is calculated from dev_pagemap_mapping_shift().

> +                                        &flags);

Why is the local flags variable passed by reference? At a minimum the
memory_failure() flags should be translated to a new set dax-notify
flags, because memory_failure() will not be the only user of this
notification interface. See NVDIMM_REVALIDATE_POISON, and the
discussion Dave and I had about using this notification to signal
unsafe hot-removal of a memory device.


> +}
> +
>  static const struct dev_pagemap_ops fsdax_pagemap_ops = {
>         .kill                   = pmem_pagemap_kill,
>         .cleanup                = pmem_pagemap_cleanup,
> +       .memory_failure         = pmem_pagemap_memory_failure,
>  };
>
>  static int pmem_attach_disk(struct device *dev,
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 3bdfcb45f66e..ab3eda335acd 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1600,6 +1600,20 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
>          */
>         SetPageHWPoison(page);
>
> +       /*
> +        * Call driver's implementation to handle the memory failure, otherwise
> +        * fall back to generic handler.
> +        */
> +       if (pgmap->ops->memory_failure) {
> +               rc = pgmap->ops->memory_failure(pgmap, pfn, 1, flags);
> +               /*
> +                * Fall back to generic handler too if operation is not
> +                * supported inside the driver/device/filesystem.
> +                */
> +               if (rc != EOPNOTSUPP)
> +                       goto out;
> +       }
> +
>         mf_generic_kill_procs(pfn, flags);
>  out:
>         /* drop pgmap ref acquired in caller */
> --
> 2.32.0
>
>
>
