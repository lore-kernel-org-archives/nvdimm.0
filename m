Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9615168
	for <nvdimm@lists.linux.dev>; Fri, 28 Jan 2022 10:12:09 +0000 (UTC)
Received: by mail-io1-f45.google.com with SMTP id w7so7098968ioj.5
        for <nvdimm@lists.linux.dev>; Fri, 28 Jan 2022 02:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wNPUfF1dwsGSwixCd2rgdU0h/HhD4TFDiOUvTQkWOEw=;
        b=M7eajZzEWKAncpyXdu/HipsM/BbPDnRWxumzOXgLR3bNg3puk4HY8RWpErAOAyvZRJ
         dLuxXEMFGu0r76nmAuFHh+cILobCzGgMKju5UFC+pQwBi0BdyNpldCDaDxu+H/aEyT2+
         VrbLU9n4jkA5Fg45qihW1O4j0sGAVjEQ8z/sv+5jRl18OPR9yIxQWrEoOBp4y7DVK9Bm
         ipmTMEOSgZgqJra4/6TZczJGTqa/NEfaQTIkBqBaDYWSbalOaqIaBbwV7vADAvD6+wEw
         iSbxk6KLEW3Si+dazP8BDLOZAIgOGJiNTfTpQLxSjvsy1eIs64w9hm2UCFDlacn8hUgy
         B3Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wNPUfF1dwsGSwixCd2rgdU0h/HhD4TFDiOUvTQkWOEw=;
        b=B0jtry5707bIim+YLQFjmAVJtyTfUxGpm1Qsf/LbwIZ7w77vhjRgjY38/7n7eX2OH+
         rnJ4GL9kaT3biQiQeZSsnCmIRZggs364zwT3XdVtFjLc1B8pP5KNiVlu9ly1dMJTx/Xy
         sL3ZHLpQfzj1L4JNEDjb1wOo+yiN50Cd4PsW0V0ZcDwaxD0v3QSzrVECQyY9o2GfTAx/
         spImKqbxrF/oO0IKZ4xW9U/NGxub413xPVRcwK51U/6s4Z5FkrEtoMgYY2tcfp+n4Huq
         9bMgy5ukgwwQSJ7vWwXPWHUPKRUwgoQS/4Ax5wORSttN6mRrD+fWicu05buzPlNKoARC
         SkXQ==
X-Gm-Message-State: AOAM531JGIijE4wKGlnKzIW7koAnet+FaAKblIlPQ9kCpnVroHuaPh7G
	joYt5cuXQhkIoFOTvkuReh5+V0eBUI0tB6Q6g8AftNfi
X-Google-Smtp-Source: ABdhPJzA47HiAINhIev418uQPCnpTvMVzET/UujTk/Xfo0TPNEGz8HIjGdEOu3Tn8BgVJiYxgWxjHGWM1CF4UL+nCTg=
X-Received: by 2002:a5e:9249:: with SMTP id z9mr4758438iop.188.1643364728844;
 Fri, 28 Jan 2022 02:12:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220111161937.56272-1-pankaj.gupta.linux@gmail.com>
In-Reply-To: <20220111161937.56272-1-pankaj.gupta.linux@gmail.com>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Fri, 28 Jan 2022 11:11:57 +0100
Message-ID: <CAM9Jb+gDKEt_XK-cE-2Q08u8EM3cYMTegrwM01R9m4JYe32mbA@mail.gmail.com>
Subject: Re: [RFC v3 0/2] virtio-pmem: Asynchronous flush
To: Linux NVDIMM <nvdimm@lists.linux.dev>, virtualization@lists.linux-foundation.org, 
	LKML <linux-kernel@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, jmoyer <jmoyer@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, David Hildenbrand <david@redhat.com>, 
	"Michael S . Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Pankaj Gupta <pankaj.gupta@ionos.com>
Content-Type: text/plain; charset="UTF-8"

ping

>  Jeff reported preflush order issue with the existing implementation
>  of virtio pmem preflush. Dan suggested[1] to implement asynchronous flush
>  for virtio pmem using work queue as done in md/RAID. This patch series
>  intends to solve the preflush ordering issue and makes the flush asynchronous
>  for the submitting thread. Also, adds the flush coalscing logic.
>
>  Submitting this RFC v3 series for review. Thank You!
>
>  RFC v2 -> RFC v3
>  - Improve commit log message - patch1.
>  - Improve return error handling for Async flush.
>  - declare'INIT_WORK' only once.
>  - More testing and bug fix.
>
>  [1] https://marc.info/?l=linux-kernel&m=157446316409937&w=2
>
> Pankaj Gupta (2):
>   virtio-pmem: Async virtio-pmem flush
>   pmem: enable pmem_submit_bio for asynchronous flush
>
>  drivers/nvdimm/nd_virtio.c   | 74 +++++++++++++++++++++++++++---------
>  drivers/nvdimm/pmem.c        | 15 ++++++--
>  drivers/nvdimm/region_devs.c |  4 +-
>  drivers/nvdimm/virtio_pmem.c | 10 +++++
>  drivers/nvdimm/virtio_pmem.h | 16 ++++++++
>  5 files changed, 98 insertions(+), 21 deletions(-)
>
> --
> 2.25.1
>
