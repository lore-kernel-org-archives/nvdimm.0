Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BA92C82
	for <nvdimm@lists.linux.dev>; Sat, 16 Oct 2021 08:23:20 +0000 (UTC)
Received: by mail-io1-f45.google.com with SMTP id h196so10397216iof.2
        for <nvdimm@lists.linux.dev>; Sat, 16 Oct 2021 01:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sn3fEWnQVyBE6l38TAM+W6Gz1Wv8DbKyNC4SbW6kXYA=;
        b=PkWmUSXXeOhuhn5e6ySI0Gkw5Y/k1c/iat8AFXl68yPocD6RcGL1v+CmIbE10O6Gbi
         TVR47rr4TRpb17VTHk5kqODVc+Z3nXiBMHY+3VZnJ+dVh3EbZtjUdiVNx3vJi2wTZDMa
         5oW6x9mHG6hzjKBmguL35b80g/aZF+/kscMJPiFv58c3UTFp55UpO70n92JQROBh54ut
         U1fxGrhuU5t9Nh5JRlgqX4bRvvYYuaZasHTg7s8SSX+QyFX4gldE181JnORXVajcsE6l
         THBFSai7C4wGVDM/IPVDISvkMp8zhLa6YK+icwtmfrQ/ZfW7mOh3Ke8jzizxABwO7JT+
         rsgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sn3fEWnQVyBE6l38TAM+W6Gz1Wv8DbKyNC4SbW6kXYA=;
        b=oWaHUYCIl+d4ou1UiTGyTdh4FqcE5CJtP6ioR6TB026I7YdrwZ4/3e1+RqCo6Lz6mr
         NeSoM84sN+U5u7eiOxHtYjf1y2S5hPBu3RWgWjs7sagyz1JET8zAxWN8Xu4CIO/XVSPe
         UBPUm+MZW4KlAbg0+xENTjr70A9EtVPVPE4s5Jl/cXn8ewOtNvT8a6e7q3w23KtnGa87
         flvwv/Ej80aTuu7oXjIBjedAsvj6BSUro2HrO/m4vjLEiCpYd8rE47su/8/dSvoFhJ1D
         dnLCkybB14M8qMk84DPhvYp+UeOq68p6T5zGC3D768TEL8VXrcDTbUKwbZ2VXDeafBVX
         eUNw==
X-Gm-Message-State: AOAM532wbyjToxMJkDf1c184tpeW8GwTdv1v2C30KQoWR89f+/c2/dpG
	xINZ3DA635n0gL4u4GW8MdYiD9tdZRRLGI3rEgjM0VqBdJg=
X-Google-Smtp-Source: ABdhPJyjSDKKSYeeQssqAhi1uUODfRGFbuA4G8uK0J8OU4CTin6tUsQbEOz8APatVo7Qmwpfpgy0LDUe62+YeSqpGs8=
X-Received: by 2002:a05:6602:2e95:: with SMTP id m21mr7210622iow.21.1634372599984;
 Sat, 16 Oct 2021 01:23:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210726060855.108250-1-pankaj.gupta.linux@gmail.com> <CAM9Jb+jDU7anniT8eL5yUQw1t_MZzndw=n1LWJ5fWV5k871+wQ@mail.gmail.com>
In-Reply-To: <CAM9Jb+jDU7anniT8eL5yUQw1t_MZzndw=n1LWJ5fWV5k871+wQ@mail.gmail.com>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Sat, 16 Oct 2021 10:23:08 +0200
Message-ID: <CAM9Jb+i5L4D130psUirHRaHbZc=ODrzOp_OQGxpFfsMXbt3eRg@mail.gmail.com>
Subject: Re: [RFC v2 0/2] virtio-pmem: Asynchronous flush
To: Linux NVDIMM <nvdimm@lists.linux.dev>, LKML <linux-kernel@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, jmoyer <jmoyer@redhat.com>, 
	David Hildenbrand <david@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Pankaj Gupta <pankaj.gupta@ionos.com>
Content-Type: text/plain; charset="UTF-8"

Friendly ping!

Thanks,
Pankaj

On Thu, 19 Aug 2021 at 13:08, Pankaj Gupta <pankaj.gupta.linux@gmail.com> wrote:
>
> Gentle ping.
>
> >
> >  Jeff reported preflush order issue with the existing implementation
> >  of virtio pmem preflush. Dan suggested[1] to implement asynchronous flush
> >  for virtio pmem using work queue as done in md/RAID. This patch series
> >  intends to solve the preflush ordering issue and also makes the flush
> >  asynchronous for the submitting thread.
> >
> >  Submitting this patch series for review. Sorry, It took me long time to
> >  come back to this due to some personal reasons.
> >
> >  RFC v1 -> RFC v2
> >  - More testing and bug fix.
> >
> >  [1] https://marc.info/?l=linux-kernel&m=157446316409937&w=2
> >
> > Pankaj Gupta (2):
> >   virtio-pmem: Async virtio-pmem flush
> >   pmem: enable pmem_submit_bio for asynchronous flush
> >
> >  drivers/nvdimm/nd_virtio.c   | 72 ++++++++++++++++++++++++++++--------
> >  drivers/nvdimm/pmem.c        | 17 ++++++---
> >  drivers/nvdimm/virtio_pmem.c | 10 ++++-
> >  drivers/nvdimm/virtio_pmem.h | 14 +++++++
> >  4 files changed, 91 insertions(+), 22 deletions(-)
> >
> > --
> > 2.25.1
> >
