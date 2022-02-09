Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886FA2F23
	for <nvdimm@lists.linux.dev>; Wed,  9 Feb 2022 03:30:22 +0000 (UTC)
Received: by mail-pf1-f181.google.com with SMTP id a39so1117564pfx.7
        for <nvdimm@lists.linux.dev>; Tue, 08 Feb 2022 19:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2Je4ysSvm0qGToTfluoX75kuGzoNSHI2qP2Y0C0VNAg=;
        b=CACwA3iWs0mIexxr+JBAReAIEm1js+p8Gd1PctwBpcCRlFarncrQq8u4LV6np8g3is
         D/VOuIRXeoPfghb+/9LTlJtNpAvNKgMSy3Wr4lug4rsCM8eyWtwax7omfbUtcsy/9gV0
         7zKe0Yw5vrIzVjXV0RntPZ6HYUDb3Ci9Ac0MxBz7ePn0Cx3ZAESjOlA/plyTn3cK/JDB
         /4GywPgMyr1VKT1Ars0+RfQs5u2gxDhVAMm6XqUo1P+6wobSWI5xZqPyxvBbdotA9rpW
         M0SPWo6TnlLbTZEqquatVpsjK0f4E620XEFwl1wrQ1s/OMsFf6/RTMOBX8yu4cXgNOQf
         8MqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2Je4ysSvm0qGToTfluoX75kuGzoNSHI2qP2Y0C0VNAg=;
        b=r5k7uvD34WVCHKKbzV5V8cfAVQtZIPohv72kp3I9tQgwr6sqKsmMQ6/ao/GOtnfD2v
         rnZnUOkPzG4dRyj5R5bPArojkbFfhjrmTiHr/dcxYKNQmAI5MAhwRKDUfbz+Jdt74su+
         DXSPLyV/8yvX7/TlwQ5kg1/JxQtCHmwh7mE1SdFHI/8Y/u1xvpAE8cUyUwKttIAHM7qx
         ueadXF9fAUY7bUwteOk27HQXB7LRhRxjuhf2PanMX8FcRSi0GmtU1cvli4P8tnG3ReWK
         U5tSfqA09mnSwec9QUHtNshYHAKToB+FHTbAWXuZZu5n6c1gsuhrJ/1XJNFgGiVqq8h8
         1qTg==
X-Gm-Message-State: AOAM532WXCFsgXo+kd/SXEn7ZfSdnXGGUGY0i7CLtOs7az1XPmlGOBH2
	c2n/Pdm0zK2vClib4mK23MX6a7e3ipxr2w9LSyvXaQ==
X-Google-Smtp-Source: ABdhPJxPkAe7JqNfPN0pMdUWTXV1LFyPzWR+xK9edhPa72Ip0qH/EBHDfJCzGhUn69nUH5cFutBmSs7V8IMhNpn2WjE=
X-Received: by 2002:a62:e907:: with SMTP id j7mr354037pfh.3.1644377421975;
 Tue, 08 Feb 2022 19:30:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220207063249.1833066-1-hch@lst.de> <20220207063249.1833066-8-hch@lst.de>
In-Reply-To: <20220207063249.1833066-8-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 8 Feb 2022 19:30:11 -0800
Message-ID: <CAPcyv4h_axDTmkZ35KFfCdzMoOp8V3dc6btYGq6gCj1OmLXM=g@mail.gmail.com>
Subject: Re: [PATCH 7/8] mm: remove the extra ZONE_DEVICE struct page refcount
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Felix Kuehling <Felix.Kuehling@amd.com>, 
	Alex Deucher <alexander.deucher@amd.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	"Pan, Xinhui" <Xinhui.Pan@amd.com>, Ben Skeggs <bskeggs@redhat.com>, 
	Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Alistair Popple <apopple@nvidia.com>, Logan Gunthorpe <logang@deltatee.com>, 
	Ralph Campbell <rcampbell@nvidia.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, amd-gfx list <amd-gfx@lists.freedesktop.org>, 
	Maling list - DRI developers <dri-devel@lists.freedesktop.org>, nouveau@lists.freedesktop.org, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, Feb 6, 2022 at 10:33 PM Christoph Hellwig <hch@lst.de> wrote:
[..]
> @@ -500,28 +482,27 @@ void free_devmap_managed_page(struct page *page)
>          */
>         page->mapping = NULL;
>         page->pgmap->ops->page_free(page);
> +
> +       /*
> +        * Reset the page count to 1 to prepare for handing out the page again.
> +        */
> +       set_page_count(page, 1);

Interesting. I had expected that to really fix the refcount problem
that fs/dax.c would need to start taking real page references as pages
were added to a mapping, just like page cache.

This looks ok to me, and passes my tests. So given I'm still working
my way back to fixing the references properly I'm ok for this hack to
replace the more broken hack that is there presently.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
