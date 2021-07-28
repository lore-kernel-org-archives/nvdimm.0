Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D302FAE
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 07:29:53 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id m2-20020a17090a71c2b0290175cf22899cso2978249pjs.2
        for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 00:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2S8+P9Er5rx8OhndztunXCa9ZYXKz6ZFsurjIyFPNKI=;
        b=gqdezsRO/p2YBoDmobyxqSuAOW3vRt4ku2SPejRpps4UMPun0YUJDOhjEzr7HDCaSo
         WBVu1lOOcsXy1mD+ZjzjRsM7RVnXGnYN9Sp78lblD0zfLD+qTXmNSxEwIKmpGcrngGaz
         SdO6vKep8ASVg8Jnj96pBB2ZX6AutIZ+h+Wkj019/6st0j0C41zTdD6Bp2Xfw6cZWz1x
         /0Daiodp/h9zwTK2C6KGbQdYJpW5Lry8tvK5hKcvMWueVFOXJ6tQ4CSmKIONcoaaQpSW
         IqFc3SPLhIEJveSRWwNC6ohwHyyZL/+Ag4W6YPNUg6UXGPnXN0jqKKXTHtubRZ/YqxcK
         uT2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2S8+P9Er5rx8OhndztunXCa9ZYXKz6ZFsurjIyFPNKI=;
        b=fr/A9sfhqEM6+mIoJHlrB4EvQRXxtuKlolLYJCzvsS1s6MDE/hiNQcKIHFthug8UBF
         E6LTfY6SD+p962D1xo8Pfpm4SnqU7elZ2QqTzDZTpIwZM6WxswPLjzaU501cPrnDdt00
         S9D9a9gjOzCfQy/MwPERr7UCMUPWTCd4Hddx5e0cv+JaFguq9bxfNIi8zzQ2YmNrCbqa
         ILGvDmHxUqMUQyiXtEeWZUzquwwvC9B0I75Cip5CFmfEMJ/aVgrgHwCS2h32PhR63rwj
         R2+tXJsSmZU1Oh/nnxZqKfxySDynDEnjGlbqccjZG+TVvgaU9pFYmZ/12yAGteQ31s+r
         vcTw==
X-Gm-Message-State: AOAM530ITBBjURrBqNHLE7ugyKJhqXxclcDxj6cZ0CgNi2mLMr4veDVI
	RsR9QwBDkUhg7nH+gc7Q+utHQCLIGKx4xnFvcD0APQ==
X-Google-Smtp-Source: ABdhPJwCSgiiXe9Ln9i8qGaBPIqEBi67YnKEKmT/EGWvvMj1Z25AvGEZqAAFUqQq71dxAlqNK2jmc743sCGmsO5Gn+M=
X-Received: by 2002:a17:902:ab91:b029:12b:8dae:b1ff with SMTP id
 f17-20020a170902ab91b029012b8daeb1ffmr22005774plr.52.1627457393556; Wed, 28
 Jul 2021 00:29:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com> <20210714193542.21857-11-joao.m.martins@oracle.com>
In-Reply-To: <20210714193542.21857-11-joao.m.martins@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Jul 2021 00:29:42 -0700
Message-ID: <CAPcyv4hxn4_E0dJdLgzskzcJUsQ=0cb5KHM9_yiMLOeNq7muoA@mail.gmail.com>
Subject: Re: [PATCH v3 10/14] device-dax: use ALIGN() for determining pgoff
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Naoya Horiguchi <naoya.horiguchi@nec.com>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> Rather than calculating @pgoff manually, switch to ALIGN() instead.

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/dax/device.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index dd8222a42808..0b82159b3564 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -234,8 +234,8 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
>                  * mapped. No need to consider the zero page, or racing
>                  * conflicting mappings.
>                  */
> -               pgoff = linear_page_index(vmf->vma, vmf->address
> -                               & ~(fault_size - 1));
> +               pgoff = linear_page_index(vmf->vma,
> +                               ALIGN(vmf->address, fault_size));
>                 for (i = 0; i < fault_size / PAGE_SIZE; i++) {
>                         struct page *page;
>
> --
> 2.17.1
>
