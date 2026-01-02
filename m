Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B2D30FF08
	for <nvdimm@lists.linux.dev>; Fri,  2 Jan 2026 12:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767357012; cv=none; b=RHrqUc1QwUS8ILgejdI6X754T4DJkAWUeV0Ft+eIE7s/G3c9ekba6fDSyoAn5sUMcjvhPAfie7M79MN8COtbtRJrlazB+dIT17Wo3ERznQGY5s8RhI+dS+dNrXvJkNE20Dliefj73xWP75/+0RvOQY01PpFpC4rcBUkDWa08CCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767357012; c=relaxed/simple;
	bh=AmaWQ5CXbUg3ciml/z9VJ5JFV4qJeUFdMIaYJrDMXlg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o+e4KCUjWKBl/Fz1eF9Rs4wfUUJmJwJ6fHEqV03js7RnWlvBMxwP7O2vqFvNWjOTKLfKmFCRHPbQOP7xe2w9znzXjGLsF7eq+WibdPB4/6s3pPIpU7ZJfZrGHsTkcdVIsp43ICnetnW1dZsLD6H9gD3gwf8aII7ViFsVOvR5ErQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yld8HJ4m; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yld8HJ4m"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a0d0788adaso108646505ad.3
        for <nvdimm@lists.linux.dev>; Fri, 02 Jan 2026 04:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767357010; x=1767961810; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8BoW0bcmK/sCMsuQ6Inc10VNOGnxhb+hS2Ao4sv1iKQ=;
        b=Yld8HJ4mrofVH7SeUM+HdUc8pEzO1TM/0xOvNf0Nj8GI7mvXuPm+3W/6HGjFTjXNlK
         AXEmN+L5w19qbj7CtwiWI6Gb1uQzQfCG+1XfbT1czpjpXxGHQ/GcfPIcOVCJ+MFbkNl9
         Yn1g6adILhqEgB6TzbaCKLyi0LoybLWdsG9Dh0Iz+dIPQFANY0ljPcnRXtgSX5LqB9n1
         D2PIGPa2C4e7v3HoT6yO5Dulg6J88ZGiileAjnAnFxOFxCjYTa7ceT+P3rzdiTawT62j
         uS2+pnn9cItFX7bOS3PNZF+TF3FF7VUjRxAfzntT0Sgi790t6MK9F0uxe1fgY6MbuYcA
         4Rqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767357010; x=1767961810;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8BoW0bcmK/sCMsuQ6Inc10VNOGnxhb+hS2Ao4sv1iKQ=;
        b=cI2iImpnaX8zrUwouQlEGdS2jPF4uOXRer24NuxKZAOGrzbYQuzadCv1hhpDajlXHH
         p/wFNIwymzfi8b/ibIF6revEIqPM0K6T/1sFuG3tHmX3krYJf+JoCKAz9v5106dZsf6k
         1LOrlVfOLv593RfSmBCrML+STay4iCVmOCR1IjgQwNJHsDn2TJaTRSoYyEvLSL1cEox9
         2Kl2CHZRbQY3gqKq9GFGcMcR46O2ccqpwlcuC6zJkkQiemrDQrDAWDxT2JUl5us8rF96
         YyEOQhnL8sLCGSrJJ4bZy9E36Zybgf4pgoICuSlc9li8LYPScIzEDtK025k7ZK6TAKW0
         8ONQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwlfkAZ+md3oBZdwzzXYX9LVdLiwYArWuZ4It/oOSJuOElN1eoshAPj2pdbFZcndKK7CmKcxw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzr4Xnha5JN14ZmJ7TE4ympqAgGBtkB86cjWkYrL0y76ZtE+Abg
	S/q9PCqZHOZKddiMGuzeJ2vr+yeDC7ElzG9WU9OJ2d9hNM+e3aZcJfNFYstp2ktarh94BajUoRk
	HRQUfQSP8f59D2WQs9B/YeZ5MdiKlqPY=
X-Gm-Gg: AY/fxX7CrcSrW8hXrLg5AvKtRA3tTX4mojYV0zAVrvBJEO2QQS/KyALTaSv/gDC2x3S
	H4ga2IkoQcyJ87rMTEbiTKk8Q2JAH/QNrjq8Ihf6VzPkDvpB2GKEjwtiZ6U7dzqaVq2rqwvit3A
	Ii7Vq9UYlfFqmLrnh/oedEknrrPM4rGAsPOy7c9i1XgoFqKNa91vav7CjLp+e+0tUBWsEezPC+U
	8wPHOZZX8DXKHzJ39dkcbhbaBJLgo2Fy+cYTfraGspJPitkEwg46CDvkYp/4qpOtWdlZkno
X-Google-Smtp-Source: AGHT+IGx+INPR/R4gVPyo42+4do1Mx5vMHRBzkq/BpyzBu528TDuEHQ9iOd5kFbLBxSrkiHob0RQ7Fq1B4FWfMYB/Ro=
X-Received: by 2002:a17:903:2b0f:b0:2a0:b02b:210a with SMTP id
 d9443c01a7336-2a2f28368c1mr434803905ad.37.1767357010333; Fri, 02 Jan 2026
 04:30:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251225042915.334117-1-me@linux.beauty> <20251225042915.334117-2-me@linux.beauty>
In-Reply-To: <20251225042915.334117-2-me@linux.beauty>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Fri, 2 Jan 2026 13:29:59 +0100
X-Gm-Features: AQt7F2pkDTCumQCutZu713NbzDLbaUdN-VN1zrM4hEgQJfHH3moax5fk1W1gX08
Message-ID: <CAM9Jb+jvbEQ48=abnQDKwtTEBtuJ0im8SVP+BwTQz-OLh9g6mQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/5] nvdimm: virtio_pmem: always wake -ENOSPC waiters
To: Li Chen <me@linux.beauty>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, 
	"Michael S . Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"

+CC MST
> virtio_pmem_host_ack() reclaims virtqueue descriptors with
> virtqueue_get_buf(). The -ENOSPC waiter wakeup is tied to completing the
> returned token.
>
> If token completion is skipped for any reason, reclaimed descriptors may
> not wake a waiter and the submitter may sleep forever waiting for a free
> slot.
>
> Always wake one -ENOSPC waiter for each virtqueue completion before
> touching the returned token.
>
> Use READ_ONCE()/WRITE_ONCE() for the wait_event() flags (done and
> wq_buf_avail). They are observed by waiters without pmem_lock, so make
> the accesses explicit single loads/stores and avoid compiler
> reordering/caching across the wait/wake paths.
>
> Signed-off-by: Li Chen <me@linux.beauty>
> ---
>  drivers/nvdimm/nd_virtio.c | 35 +++++++++++++++++++++--------------
>  1 file changed, 21 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> index c3f07be4aa22..6f9890361d0b 100644
> --- a/drivers/nvdimm/nd_virtio.c
> +++ b/drivers/nvdimm/nd_virtio.c
> @@ -9,26 +9,33 @@
>  #include "virtio_pmem.h"
>  #include "nd.h"
>
> +static void virtio_pmem_wake_one_waiter(struct virtio_pmem *vpmem)
> +{
> +       struct virtio_pmem_request *req_buf;
> +
> +       if (list_empty(&vpmem->req_list))
> +               return;
> +
> +       req_buf = list_first_entry(&vpmem->req_list,
> +                                 struct virtio_pmem_request, list);

[...]
> +       list_del_init(&req_buf->list);
> +       WRITE_ONCE(req_buf->wq_buf_avail, true);
> +       wake_up(&req_buf->wq_buf);

Seems with the above change (3 line fix), you are allowing to wakeup a waiter
before accessing the token. Maybe simplify the patch by just
keeping this change in the single patch & other changes (READ_ONCE/WRITE_ONCE)
onto separate patch with corresponding commit log.

Thanks,
Pankaj

> +}
> +
>   /* The interrupt handler */
>  void virtio_pmem_host_ack(struct virtqueue *vq)
>  {
>         struct virtio_pmem *vpmem = vq->vdev->priv;
> -       struct virtio_pmem_request *req_data, *req_buf;
> +       struct virtio_pmem_request *req_data;
>         unsigned long flags;
>         unsigned int len;
>
>         spin_lock_irqsave(&vpmem->pmem_lock, flags);
>         while ((req_data = virtqueue_get_buf(vq, &len)) != NULL) {
> -               req_data->done = true;
> +               virtio_pmem_wake_one_waiter(vpmem);
> +               WRITE_ONCE(req_data->done, true);
>                 wake_up(&req_data->host_acked);
> -
> -               if (!list_empty(&vpmem->req_list)) {
> -                       req_buf = list_first_entry(&vpmem->req_list,
> -                                       struct virtio_pmem_request, list);
> -                       req_buf->wq_buf_avail = true;
> -                       wake_up(&req_buf->wq_buf);
> -                       list_del(&req_buf->list);
> -               }
>         }
>         spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
>  }
> @@ -58,7 +65,7 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
>         if (!req_data)
>                 return -ENOMEM;
>
> -       req_data->done = false;
> +       WRITE_ONCE(req_data->done, false);
>         init_waitqueue_head(&req_data->host_acked);
>         init_waitqueue_head(&req_data->wq_buf);
>         INIT_LIST_HEAD(&req_data->list);
> @@ -79,12 +86,12 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
>                                         GFP_ATOMIC)) == -ENOSPC) {
>
>                 dev_info(&vdev->dev, "failed to send command to virtio pmem device, no free slots in the virtqueue\n");
> -               req_data->wq_buf_avail = false;
> +               WRITE_ONCE(req_data->wq_buf_avail, false);
>                 list_add_tail(&req_data->list, &vpmem->req_list);
>                 spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
>
>                 /* A host response results in "host_ack" getting called */
> -               wait_event(req_data->wq_buf, req_data->wq_buf_avail);
> +               wait_event(req_data->wq_buf, READ_ONCE(req_data->wq_buf_avail));
>                 spin_lock_irqsave(&vpmem->pmem_lock, flags);
>         }
>         err1 = virtqueue_kick(vpmem->req_vq);
> @@ -98,7 +105,7 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
>                 err = -EIO;
>         } else {
>                 /* A host response results in "host_ack" getting called */
> -               wait_event(req_data->host_acked, req_data->done);
> +               wait_event(req_data->host_acked, READ_ONCE(req_data->done));
>                 err = le32_to_cpu(req_data->resp.ret);
>         }
>
> --
> 2.52.0
>
