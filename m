Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5415F1373
	for <nvdimm@lists.linux.dev>; Thu, 24 Feb 2022 05:58:09 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id bt13so1824522ybb.2
        for <nvdimm@lists.linux.dev>; Wed, 23 Feb 2022 21:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aZRlDF8hWNRYQY9pK6CTd02SSyMoTN/lFolx1y0wAt4=;
        b=5U57mpz8cHyPxqbNyydMgJINUZ6JPYutw2vLH9XEsfFf1KtY4MwXRKrW0fEAb2sOLR
         KN9NjNlXKrGrlmKcqKNpWCq4P8K3v0wniPhnPeTKcZ6ndkP+27NgvY7bhAapWs1csev1
         yLaIE5pPyF9OjQ1OSyhKX2j4ST3k9HFqIq7NWubDkeefk+rIYzOM8U8jYJolwxTXjhU+
         PSF118d8xYQSwWzk26vpszyxw2HToe/WtSKzDVsWd39wlKKGv9Zjpk1zPyYgobWhMsQw
         c5OVp7YpmfN4J3KO4mKhKNOvIBBJ9c3bKYhLvEeXZNz7dM+6j5iL/8onn8XGpgfwPe2M
         HEgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aZRlDF8hWNRYQY9pK6CTd02SSyMoTN/lFolx1y0wAt4=;
        b=ROzdpZ9bXX0nuFFyrnaFPrwxtF23tc0g3QXX+TF7some3SlzMJHGm36fJM3UTB9K3m
         mI3hN0KFUl4b4fkw5ibFEt+Uz28FdkIZuJPOsb8ub47Eac9t+c0OI85xP6qZxd2PCUzw
         Q1LmWpa+mPcjGw4kjmbzCKIr9774WyFrG0hzzM+RFMbzXd6caSMqEv6cxE0vTeQTr7tu
         KwqoT+WECHHwNNH69efHW2oOSvfWpCdZhkS2/8xjsrKjatO81wOvWxBARMF+aOxbksZw
         z831YWIM2tqXKmfLNw36+RSIfqTXziTfxdSx2ASf/UtExoyB8tmh+2zRYrTYuXMLPShW
         Vorw==
X-Gm-Message-State: AOAM5309LkX/P8pv1qCq6I2v2bqDj/l78RdRQa2HSA6GDQIvGtwwineG
	WIK47PE9bFJNcG4I9R2SAmoEGszwokC8T0+ut9lX8A==
X-Google-Smtp-Source: ABdhPJxj92w4OLuJgUtu5oDa3uKzHyY/QkH+o6gXG7Vt0gJW3V64WOAMsC3/biXjaU5LVT7b8gCx6yPGtav8NBjybHE=
X-Received: by 2002:a25:d2cd:0:b0:61d:6a33:8129 with SMTP id
 j196-20020a25d2cd000000b0061d6a338129mr1101624ybg.246.1645682288360; Wed, 23
 Feb 2022 21:58:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220223194807.12070-1-joao.m.martins@oracle.com> <20220223194807.12070-6-joao.m.martins@oracle.com>
In-Reply-To: <20220223194807.12070-6-joao.m.martins@oracle.com>
From: Muchun Song <songmuchun@bytedance.com>
Date: Thu, 24 Feb 2022 13:57:30 +0800
Message-ID: <CAMZfGtWBtoygDbU+qdUswdz1K5=86+eCt11Ffeyvw2e0z+xrzw@mail.gmail.com>
Subject: Re: [PATCH v6 5/5] mm/page_alloc: reuse tail struct pages for
 compound devmaps
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jane Chu <jane.chu@oracle.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, nvdimm@lists.linux.dev, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 24, 2022 at 3:48 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> Currently memmap_init_zone_device() ends up initializing 32768 pages
> when it only needs to initialize 128 given tail page reuse. That
> number is worse with 1GB compound pages, 262144 instead of 128. Update
> memmap_init_zone_device() to skip redundant initialization, detailed
> below.
>
> When a pgmap @vmemmap_shift is set, all pages are mapped at a given
> huge page alignment and use compound pages to describe them as opposed
> to a struct per 4K.
>
> With @vmemmap_shift > 0 and when struct pages are stored in ram
> (!altmap) most tail pages are reused. Consequently, the amount of
> unique struct pages is a lot smaller that the total amount of struct
> pages being mapped.
>
> The altmap path is left alone since it does not support memory savings
> based on compound pages devmap.
>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  mm/page_alloc.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e0c1e6bb09dd..01f10b5a4e47 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6653,6 +6653,20 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>         }
>  }
>
> +/*
> + * With compound page geometry and when struct pages are stored in ram most
> + * tail pages are reused. Consequently, the amount of unique struct pages to
> + * initialize is a lot smaller that the total amount of struct pages being
> + * mapped. This is a paired / mild layering violation with explicit knowledge
> + * of how the sparse_vmemmap internals handle compound pages in the lack
> + * of an altmap. See vmemmap_populate_compound_pages().
> + */
> +static inline unsigned long compound_nr_pages(struct vmem_altmap *altmap,
> +                                             unsigned long nr_pages)
> +{
> +       return !altmap ? 2 * (PAGE_SIZE/sizeof(struct page)) : nr_pages;
> +}
> +

Should be:

return is_power_of_2(sizeof(struct page)) &&
       !altmap ? 2 * (PAGE_SIZE/sizeof(struct page)) : nr_pages;

Thanks.
