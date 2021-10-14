Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E763E2C80
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 18:25:02 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id v8so2051303pfu.11
        for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 11:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZrwusMQgn7Kh5ZWmzery+mEysHznYixIAxkraeYDT8I=;
        b=JlgglDk2moNFtf4OKCiOZgtJWM4sHhKsi1gizW7ywm488nbnm8LGggBhoTDozcIDuK
         o3oaErlTWwe8AXwwSp+T9zG6au6KofLizn8EGDcpWF2cokP3E6aDyL7NnemOErJeI6T3
         pVq7yA2MG52TMp2WDBaeDKpVaWEhGPJl39Lgl26xLaRzIU4U0LVc5Ql77xnULeUjqjHY
         ssXwo5vnvc2iw+en6bf3zYjFspezqN/dz4MtQj80Qj2EmzrJhfQBsOJqaqqkwH7casNZ
         wba3G6DVVPSp0kFdvaP9fJ5074t4LH3Xs81nH3Qu2Zw9ap4AsZIvokuEAaD4nvvk1xgs
         Z8pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZrwusMQgn7Kh5ZWmzery+mEysHznYixIAxkraeYDT8I=;
        b=u4h5fRJNspwCrf+50LMtK5OPrqYU9VlQpvcTs26gP94qLpcSt38qlu3uzTsx5Nt6aE
         idNtP3T0DZX+jmRsJ6WWZ9ccpfVPrvBOOx73hODH7C+NpEUYo9Dc1vlrpC2+TY9j0DML
         BP1+mxmP6LzcWIXGwonwNYEAFhzEagft6ssrbpZvczH637Jb9QbZ6TXraI2jtNM0YYne
         lfmy1wJr36fXeaV6hmwY3K+k4fplAsYU2gn2BCGLnVRj9/ruzCxu02WqotRTJdHprqWW
         +uFSsbuf7PkEkeVh6ptB15fwfx+/FcdjRccSadL4gjj3jhf6TLnPvWaRVFoPsvlPHzm8
         aMCA==
X-Gm-Message-State: AOAM530shvqW0xy6POj6myWcKOjM9fYtxKPW7DZUKZxu+E6WD6uwNjV3
	uX/A5oty5sq+NcABev46ueOWZRxFt+M1ZYxEPfo/7g==
X-Google-Smtp-Source: ABdhPJztKmJOesXMRk6BKGtvmpjvsfAdSSn0+uARW4b3Fc8fmLRB8vYSVOMFIX/qFzu+IiqYQbW4FG1jMRSX9TvP2q0=
X-Received: by 2002:a05:6a00:1a01:b0:44c:1ec3:364f with SMTP id
 g1-20020a056a001a0100b0044c1ec3364fmr7117844pfv.86.1634235902347; Thu, 14 Oct
 2021 11:25:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211007082139.3088615-1-vishal.l.verma@intel.com> <20211007082139.3088615-11-vishal.l.verma@intel.com>
In-Reply-To: <20211007082139.3088615-11-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Oct 2021 11:24:52 -0700
Message-ID: <CAPcyv4h64LkFS1T_YqoRDz-7jDfkycNxBEkSzRxs-eUe4Y=LVg@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 10/17] libcxl: add label_size to cxl_memdev, and
 an API to retrieve it
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 7, 2021 at 1:22 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Size of the Label Storage Area (LSA) is available as a sysfs attribute
> called 'label_storage_size'. Add that to libcxl's memdev so that it is available
> for label related commands.
>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  cxl/lib/private.h  |  1 +
>  cxl/lib/libcxl.c   | 12 ++++++++++++
>  cxl/libcxl.h       |  1 +
>  cxl/lib/libcxl.sym |  5 +++++
>  4 files changed, 19 insertions(+)
>
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index 9c6317b..671f12f 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -21,6 +21,7 @@ struct cxl_memdev {
>         unsigned long long pmem_size;
>         unsigned long long ram_size;
>         int payload_max;
> +       size_t lsa_size;
>         struct kmod_module *module;
>  };
>
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 33cc462..de3a8f7 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -247,6 +247,13 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
>         if (memdev->payload_max < 0)
>                 goto err_read;
>
> +       sprintf(path, "%s/label_storage_size", cxlmem_base);
> +       if (sysfs_read_attr(ctx, path, buf) < 0)
> +               goto err_read;
> +       memdev->lsa_size = strtoull(buf, NULL, 0);
> +       if (memdev->lsa_size == ULLONG_MAX)
> +               goto err_read;
> +
>         memdev->dev_path = strdup(cxlmem_base);
>         if (!memdev->dev_path)
>                 goto err_read;
> @@ -350,6 +357,11 @@ CXL_EXPORT const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev
>         return memdev->firmware_version;
>  }
>
> +CXL_EXPORT size_t cxl_memdev_get_label_size(struct cxl_memdev *memdev)
> +{
> +       return memdev->lsa_size;
> +}
> +
>  CXL_EXPORT void cxl_cmd_unref(struct cxl_cmd *cmd)
>  {
>         if (!cmd)
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index 7408745..d3b97a1 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -42,6 +42,7 @@ struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
>  unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
>  unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
>  const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
> +size_t cxl_memdev_get_label_size(struct cxl_memdev *memdev);
>
>  #define cxl_memdev_foreach(ctx, memdev) \
>          for (memdev = cxl_memdev_get_first(ctx); \
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index 1b608d8..b9feb93 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -75,3 +75,8 @@ global:
>         cxl_cmd_new_read_label;
>         cxl_cmd_read_label_get_payload;
>  } LIBCXL_2;
> +
> +LIBCXL_4 {
> +global:
> +       cxl_memdev_get_label_size;

Since we never made a release with the v2 symbols, why do we need a new v3 set?

Other than that, looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
