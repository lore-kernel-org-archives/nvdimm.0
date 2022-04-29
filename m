Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191B67B
	for <nvdimm@lists.linux.dev>; Fri, 29 Apr 2022 18:56:57 +0000 (UTC)
Received: by mail-pf1-f181.google.com with SMTP id t13so7673048pfg.2
        for <nvdimm@lists.linux.dev>; Fri, 29 Apr 2022 11:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HUb2AeTNJcZwD078seN9U1UAiMId+LQbZ7Ey7wYnH7M=;
        b=lCZ+u1S+AFvX2KAPzeeyfNspgNzW2MhKZeU9/82UI2hA3U4Y4FzX7+SkEU6yi6zNjz
         Mkdm5qWqL6gaskhqOO+vrjp1EBAP9sjnhovlkU9w32PSxUVIe3H3yn9tlxjDLUJDgQCv
         L7b7Graze7N7RjiBC+Z44qj5QihUoKDeTs4phvkE0Tk9Wzhh59NVtm5sC9bt28DtsF6z
         WG225h0HcSLmvgkkL3WCwXCMJ6YYpMwxnuo4uy1tXKLw8KiaFF2CDHkI2YqrpS4yA6T4
         pLvkDvqeo6qYrMiwg+rwOSsI1kn3SCF94CUvINJThFOSwv2RbXGEmXYQbf2Nq6V9uPqR
         YQJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HUb2AeTNJcZwD078seN9U1UAiMId+LQbZ7Ey7wYnH7M=;
        b=FZWtSiGLbrhkQHPoScldnmH2tiRRnz7iJu2p52JbG62Ce/1iIYsuWmAQA/gisNLAcS
         4T3kwDgUv8OLG5jCF98zAei/YfhcFma0DeiJq6cb0adPI0FdYEubsGc8gDF5SQBmS+3g
         n0zsOwGpyvtFwWbouZ+cgfiAmZ/+ierl/2P2XQf3wWynpM/V9pPQOparslNfQJt9qC7l
         ehNxwSgex3KmjLPvdmADK3KCZtis3Lb6E1FeaXRw+hpu53SZYyq2F+sjk0RxiyUrUUaq
         2ppdDrreWTeXpQhl0gnah6D6QyYYJmMeHteOGddj2qEIZc3wBwi+EiU/kTtk6GO0l5OV
         k1Ow==
X-Gm-Message-State: AOAM53109r+u8cfM/WLfw/2/chqmMb8rO9uRBjlC4XaPPukl+nb484CD
	s80QzBZVrmW8ImfXMVHBBIeoiPjWn+YjOhse0Wbtzg==
X-Google-Smtp-Source: ABdhPJyAQ9fwnpAk2Ts6MauMQOVJu3OiitVnvRuUjeBbPPg4ife6hXfiwPfjwiEmGv5y/CBqMtaclPgDWCA1uvplV9o=
X-Received: by 2002:a62:a105:0:b0:50d:c97b:3084 with SMTP id
 b5-20020a62a105000000b0050dc97b3084mr177523pff.61.1651258617382; Fri, 29 Apr
 2022 11:56:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220429134039.18252-1-msuchanek@suse.de>
In-Reply-To: <20220429134039.18252-1-msuchanek@suse.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 29 Apr 2022 11:56:46 -0700
Message-ID: <CAPcyv4g7wBJvw-yNz58eGcLYSvsSHOGZsZV8Px=WRacQ5Ur2Og@mail.gmail.com>
Subject: Re: [PATCH] testing: nvdimm: iomap: make __nfit_test_ioremap a macro
To: Michal Suchanek <msuchanek@suse.de>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Zou Wei <zou_wei@huawei.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Apr 29, 2022 at 6:41 AM Michal Suchanek <msuchanek@suse.de> wrote:
>
> The ioremap passed as argument to __nfit_test_ioremap can be a macro so
> it cannot be passed as function argument. Make __nfit_test_ioremap into
> a macro so that ioremap can be passed as untyped macro argument.
>

Looks reasonable to me and passes tests, applied.

> Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> ---
>  tools/testing/nvdimm/test/iomap.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
>
> diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
> index b752ce47ead3..ea956082e6a4 100644
> --- a/tools/testing/nvdimm/test/iomap.c
> +++ b/tools/testing/nvdimm/test/iomap.c
> @@ -62,16 +62,14 @@ struct nfit_test_resource *get_nfit_res(resource_size_t resource)
>  }
>  EXPORT_SYMBOL(get_nfit_res);
>
> -static void __iomem *__nfit_test_ioremap(resource_size_t offset, unsigned long size,
> -               void __iomem *(*fallback_fn)(resource_size_t, unsigned long))
> -{
> -       struct nfit_test_resource *nfit_res = get_nfit_res(offset);
> -
> -       if (nfit_res)
> -               return (void __iomem *) nfit_res->buf + offset
> -                       - nfit_res->res.start;
> -       return fallback_fn(offset, size);
> -}
> +#define __nfit_test_ioremap(offset, size, fallback_fn) ({              \
> +       struct nfit_test_resource *nfit_res = get_nfit_res(offset);     \
> +       nfit_res ?                                                      \
> +               (void __iomem *) nfit_res->buf + (offset)               \
> +                       - nfit_res->res.start                           \
> +       :                                                               \
> +               fallback_fn((offset), (size)) ;                         \
> +})
>
>  void __iomem *__wrap_devm_ioremap(struct device *dev,
>                 resource_size_t offset, unsigned long size)
> --
> 2.34.1
>
