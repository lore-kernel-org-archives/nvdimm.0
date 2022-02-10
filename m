Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2296E2F28
	for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 09:40:11 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id o19so13557374ybc.12
        for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 01:40:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vwSyjkWA8Xtx6McE/937H/83En/EAsN4/n12OaGn97U=;
        b=Q9U5MhFM50SJ6zKg3p/BHPAbW/1PqWiV8IwLRh7eYuvqYsefXz7JVtkApiN0D5tJs9
         NjgtZ08Kif7nIin7P9Lj3k6IR7GOTseT9s5laCSNNmTWHD2uCXfrqGfuutVuti7FabYq
         BBBAb4MnvkLH4UJThCTrI8+/mOnZaltJr+bpG6t9FkMSJZxm2G82RI22ShxjcihlxEsi
         Y82w37OnLpB5Xi9WU56u6QA7+3qLoNq0E7XxjqXpD9HrhneWbPs+sNufIntIIK3bmpgw
         cO6+9m8+iutxaFYcQMGptKVxtMwZN8MAWIOLV4hGp2W+29wbPx10LCsVwxL/brPe2+Mu
         8Ffg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vwSyjkWA8Xtx6McE/937H/83En/EAsN4/n12OaGn97U=;
        b=n+EG0Ani3tOcZMeDxvY6Wj7iIjcQmTr29FPT0LZZsAsDac15BfklsXCLozIOzmsxRB
         PNC5pnlnTT1PTMFjGd6AFAsYd72X4VjdBnLjDKkj12F4OXtVC/umiM5XZmk+6zeyxUlP
         L4C8B25dXBla/MnBEnza14pcwifbsf4wvuAQMJ9n4CsuOSGP2LXAF/amETmq9fGRMIKQ
         Zx4tFA/c83jfBmhYCc7a7U066d0b+NrT0uIzXpeow5OHnkUexZfuEVvJLM5vVyeJ0E/j
         XclLLHIHlRNF/7I78i/TGSXAZ3NmjODwqBHq1zOpBz8laEEsBi3l89ZxC91HiWp15Dy8
         ENHA==
X-Gm-Message-State: AOAM533s7kOhU227AzplBxrduCHJxQIrWRwiP+TTqurus7xZz8G5+AvZ
	rvM8LQDrbcmH192RiUDJAxOGf2QawpJtn9LvQBeFIg==
X-Google-Smtp-Source: ABdhPJyMOovS5IpsBIbmJvgp0LJOskYVPag8axtaKArSDLNMC4EYiKcUxfRUU3qBQ8ccmcQ6MqVRs4tbRTDCogGg4e4=
X-Received: by 2002:a25:4742:: with SMTP id u63mr6032141yba.523.1644486011092;
 Thu, 10 Feb 2022 01:40:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220210072828.2930359-1-hch@lst.de> <20220210072828.2930359-4-hch@lst.de>
In-Reply-To: <20220210072828.2930359-4-hch@lst.de>
From: Muchun Song <songmuchun@bytedance.com>
Date: Thu, 10 Feb 2022 17:39:34 +0800
Message-ID: <CAMZfGtWb9a8gN7DjaJngYi4aJLVHL74eKnXmctXC27QyarHsDQ@mail.gmail.com>
Subject: Re: [PATCH 03/27] mm: remove pointless includes from <linux/hmm.h>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Felix Kuehling <Felix.Kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	"Pan, Xinhui" <Xinhui.Pan@amd.com>, Ben Skeggs <bskeggs@redhat.com>, 
	Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Alistair Popple <apopple@nvidia.com>, Logan Gunthorpe <logang@deltatee.com>, 
	Ralph Campbell <rcampbell@nvidia.com>, LKML <linux-kernel@vger.kernel.org>, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	nouveau@lists.freedesktop.org, nvdimm@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, Jason Gunthorpe <jgg@nvidia.com>, Chaitanya Kulkarni <kch@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 10, 2022 at 3:28 PM Christoph Hellwig <hch@lst.de> wrote:
>
> hmm.h pulls in the world for no good reason at all.  Remove the
> includes and push a few ones into the users instead.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

Reviewed-by: Muchun Song <songmuchun@bytedance.com>
