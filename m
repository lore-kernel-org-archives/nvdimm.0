Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6F1ED6
	for <nvdimm@lists.linux.dev>; Thu, 24 Feb 2022 03:11:15 +0000 (UTC)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-2d625082ae2so11161297b3.1
        for <nvdimm@lists.linux.dev>; Wed, 23 Feb 2022 19:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8mtpPZAP/jAYJJyMzEonaOx2sTOc5n28GBAe2uH3WEY=;
        b=S0K6WvP3CBpaQxxCYEvAn89gSciPZblXBrv71erMz95cLnLNtW2zkatg+yAJAgTj00
         POqnWFPbhQghMwFFx4v0DLLnGg6ylky5WSvhfyRD8R2eEZySUm2zKBAQfCDyV+amNQ0Q
         TVAW63GcunhlDC39D3QlNDI8r/9sC5Bbzjc4XQ1p58f3ABxBmWb8lzxiEl8uszqR+lCr
         XIFntqbOgE/2zcf3Ybjetlfvc2GBpyLZOEQkS+4ZXpZivDuMHD60zcPjdLQs6+eJvp36
         1f+jnfdZInSE2h7dz9KTvRD7mJS3lbOeq37L+eQA0DDbC6tqWpcZ1s/HzkcwP1uEJbya
         Hmfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8mtpPZAP/jAYJJyMzEonaOx2sTOc5n28GBAe2uH3WEY=;
        b=Rq1IWc8agKLXt02WYTJaRL1zkcJBdV2CQKKVZZgqi4zJXUWrGd7NtCt8+RT/ieZeAX
         595Hpxg05Duf1cvCORgclKpPDqn9bNQM0PNMZPdqPeCtt8JgqenZJUwim3UWKz7dH9SY
         JowM0kUzACSZ+tGga0IS2Mq1RJrsSiAJe1ZDAZVQPZlsEmNnwh8DEMI0q3KbAA4NVb5T
         M7cNn9prINqDdhekQM6ByRUM64WIr2FFQHbS/UOhaJ+lHnb6DBuK/HJcMQSDH0ASg/rH
         itUjxCFnbOULBVZNyAWGqW05ANaw3Nt+fGuHA1M7WWB8h4Uz8GiAdDKEm+XnjkRK562F
         OCbA==
X-Gm-Message-State: AOAM533wczemxNvQ9t1PY7aqFgje17brPXHHcdd0hO0DV9hnz0nLKl6B
	FY6lVCh+Is6SDNTUpRqUfMQAXX8f8oBSiJ7uhFEIsA==
X-Google-Smtp-Source: ABdhPJwptZfPYhJvyu9jxfgMax6JVNrA4Pjt/3kifQRRjekLcRYO6pKkn+QzAd2aHb3P73wOLHCN4Da3bM9b+36fi5g=
X-Received: by 2002:a0d:f347:0:b0:2d6:916b:eb3f with SMTP id
 c68-20020a0df347000000b002d6916beb3fmr596585ywf.141.1645672274498; Wed, 23
 Feb 2022 19:11:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220223194807.12070-1-joao.m.martins@oracle.com> <20220223194807.12070-3-joao.m.martins@oracle.com>
In-Reply-To: <20220223194807.12070-3-joao.m.martins@oracle.com>
From: Muchun Song <songmuchun@bytedance.com>
Date: Thu, 24 Feb 2022 11:10:37 +0800
Message-ID: <CAMZfGtVD6XyjqrQ4RpDDPOSZCgo1NHXbfjeRwqi2KmUckW-6xA@mail.gmail.com>
Subject: Re: [PATCH v6 2/5] mm/sparse-vmemmap: refactor core of
 vmemmap_populate_basepages() to helper
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
> In preparation for describing a memmap with compound pages, move the
> actual pte population logic into a separate function
> vmemmap_populate_address() and have vmemmap_populate_basepages() walk
> through all base pages it needs to populate.
>
> While doing that, change the helper to use a pte_t* as return value,
> rather than an hardcoded errno of 0 or -ENOMEM.
>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>

Reviewed-by: Muchun Song <songmuchun@bytedance.com>

Thanks.
