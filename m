Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEE8313E3E
	for <nvdimm@lists.linux.dev>; Tue,  3 Feb 2026 10:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770115437; cv=pass; b=oWFsIX8TF4IkO6Els02eAbzf/N13nmQLxejO4fdD83KnCS1dztImPjTFeu1TLlqxRo4TXAOjnZcQFcUmm2L4IuBUzQBevb7o6PVJCpIeR34k+qBTSPhZ3+6VQ3o2mgl/yIrK5TVVQEpigglWcJ6nRHwok0gJwU46q6rCLVkSY4w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770115437; c=relaxed/simple;
	bh=RRuGMaiDDxW6j0slJ2xiz4MP+wBJAw4O1epEZRkk8qA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eXZ4QA/tsjhe7NLbbofWDemIFnk6tJ+p7LciWvmlQuevw9aPX64WBV6yUFyp8FjhAFL2cYlBa7JD/ht+LEN2KsN/CCr3psP7xI7y+Jury0bGjFU2RBIKem9FWwPfDcqT498WpOgylMTEUyHMcorM1FIbLaPaDauC0UyGHqm8a28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WtChIcxu; arc=pass smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WtChIcxu"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a7bced39cfso57910905ad.1
        for <nvdimm@lists.linux.dev>; Tue, 03 Feb 2026 02:43:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770115436; cv=none;
        d=google.com; s=arc-20240605;
        b=O9/vBpRGjHnpObBOgehr160oMncezFTOQ7JhhMLriWZR9IxHesGeEg3udgIDapKiAr
         3G5JwVsrD6j0UEMCeC3H+Qwe4i5S1BEWw/8uAL4dS9NbtP2tIuU5b6xVIcPrLj2baUhb
         QBSn7JDN4s4Cx13wzZjoNQxzxkJIBcXXYlgYfqpW0iqFiMO0/+fFiS/ho3tSn6Fca1BQ
         x5PQD24xyXBR7IroEATEN9GPT43Ei9uYC1Qw3poVXuwTFh/DNAyoGzQoTae1Uznef937
         UU2UHv4KTvMVD2a1yPsk+nQPJfgcfWsS2bQRcNdXQPgEfS/lCWQ93hdpIC5wdKjh401m
         wwmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1STIRAxHKajbWHjuKHeCah+NmqTOtV3nZHAJmzsLz5w=;
        fh=rOYN6Cc2ziPl/GhBeMq1eaRwzzzgCDCuXZG3C/Ms/Fw=;
        b=TUEKGf0bRmKd1ui9/N6a8u5Br5AXRWi+W+uq3woK2odYYPgxFqL445yiA8TTz2NpCy
         79C4yP+G8RB/14sdDYxQLNvGsMRDeCOFuWGZcRPbGUJFADsu56kCB95Ya5NQu4InXyh6
         JmsdxBj7+qaTvpb2PWOWb6bDYyfS8VUWzWr8ugLMHcOW2eU4SnsTjT9BxzbqAYr2pM/z
         V3IRxiDUIK/8WCuw97/7rUTi1JxDIEfsAJTj99Ai5YKbUmgcl05x+2pXeJYxnHWK8u00
         SKAoTt0Jd5ny2Vx4xdDuhQvrglTCfNt6HiIiWEz/1XUiHg37letFv80vg3QxhMMdYkxx
         FlGA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770115436; x=1770720236; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1STIRAxHKajbWHjuKHeCah+NmqTOtV3nZHAJmzsLz5w=;
        b=WtChIcxuzyVKy9Htpb5AQJpL3t5E9aQP8BJZv93ewMe5siIWaaBkTdPdpV58rebXGk
         Nndqc/TUiOYysV4M3lw3ObQDy6bQKxIlIMnWPU1sPYkfXwtI6OhgEl5dbT/FhUItbex9
         1RVwsAbDSMig8gt6bsnQ3O378f/k72qNiovjH9e+9gzfJU9kO5Tj5BEFz1uSuVjCs9LI
         Z8mBZyXpKc62lGTdNJ/UkchOXTX0NyrCQSRafz0pATpYEEeURACAusDBGc2k4VR8GU4z
         /BUy5NGrALWpCPGWSip+8HU7VEwLbn7xpHVM9BFYbuaBDJfi6LUsGHlLCiTU6ig62Nxd
         8ciA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770115436; x=1770720236;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1STIRAxHKajbWHjuKHeCah+NmqTOtV3nZHAJmzsLz5w=;
        b=iJPegVgQ+LDIvKVHEf9aYsaembEpQY0g+bGoq0TMUjZYsU+pRV/fqJnVXOpBNXpMwI
         eOaOBntOIWTxi1VhZX5klketUlWll74iRls70YI6E5Z5zTD7e7W/sIMcT2rxHzN4j4p0
         /PeTBM5Xj2IcWwJlATuQr9Em8mo6GPhWUew1NUmSKvvoO6GpWVJ2MtoJsMczwQ1qryGK
         U4eOJ7+o46UGZxJgebKjm22EIzml8Rov58J9Yb8/ItmXzKhMmaDMau7HXrLQ5f1wX7Yo
         7dMapg+qM5B1GSjUjvV0cNpf1kzDqdlupmmhb44Qwcq8CG+qnZB1YKvyGXi5fF5DnuxR
         fh6g==
X-Forwarded-Encrypted: i=1; AJvYcCWSgjS0ARoCWO6Fzkc4MLHiRLdn3IX9dqjcoog1fO2RXskCb2jFO+bOreKAnBlwFL53GxOyEYA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxDVshxZOHIvZJLTlqssZ71CIuscn5RQ3smEaxxGc/Gj+VRLuzY
	JyOtJXuOK7s2YgvUu6PCwYmH5sajtwKeIwb+TOIwEQZSSrHHFJThfv7UOjHyQ8uPKyR5QkUrNma
	cT3GswYBvZ4sZpTaWU6VNHr0KcslG5bA=
X-Gm-Gg: AZuq6aIjLHLQe3SnwmO8i90E42lUhJGQ09ExKgtBfB45j0F4L9mZ8CUBV8GLn3PQ6oc
	GctIK56VsjeOU/QlpohDiiYxIDGCpEOgosqro/cz7xSl/+kk2IK4DAgmjdngS6oma08ChNAAh3Q
	Eq7EbqJ1YroQXNlKTLUEa0/p3QoMhejbHC8L+qtqoH6GPrzF7a6jHYt7utlHkiDJqSPG1Rr7qTK
	w4Ls/sQNyXQhZ3R+bSowEU21wFkGQ1Ass1+9WLJjs1sd8sLXe1EbObL5VOIgYdKHiV0ydYE
X-Received: by 2002:a17:903:244f:b0:2a5:8c95:d823 with SMTP id
 d9443c01a7336-2a8d96a6a6bmr160580425ad.10.1770115435853; Tue, 03 Feb 2026
 02:43:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260203021353.121091-1-me@linux.beauty>
In-Reply-To: <20260203021353.121091-1-me@linux.beauty>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Tue, 3 Feb 2026 11:43:44 +0100
X-Gm-Features: AZwV_Qj95cNa-ZOZ966OO3GhsyHmrO-vIC4T1fGio9b5sYjdGjXuYPVPwCDZoWc
Message-ID: <CAM9Jb+iBD1=BgPjN6Jku7=G8qSoavCfB9ZB+rmb_aqgmhQdctA@mail.gmail.com>
Subject: Re: [PATCH v2] nvdimm: virtio_pmem: serialize flush requests
To: Li Chen <me@linux.beauty>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Cornelia Huck <cohuck@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Yuval Shaia <yuval.shaia@oracle.com>, 
	virtualization@lists.linux.dev, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> Under heavy concurrent flush traffic, virtio-pmem can overflow its request
> virtqueue (req_vq): virtqueue_add_sgs() starts returning -ENOSPC and the
> driver logs "no free slots in the virtqueue". Shortly after that the
> device enters VIRTIO_CONFIG_S_NEEDS_RESET and flush requests fail with
> "virtio pmem device needs a reset".
>
> Serialize virtio_pmem_flush() with a per-device mutex so only one flush
> request is in-flight at a time. This prevents req_vq descriptor overflow
> under high concurrency.
>
> Reproducer (guest with virtio-pmem):
>   - mkfs.ext4 -F /dev/pmem0
>   - mount -t ext4 -o dax,noatime /dev/pmem0 /mnt/bench
>   - fio: ioengine=io_uring rw=randwrite bs=4k iodepth=64 numjobs=64
>         direct=1 fsync=1 runtime=30s time_based=1
>   - dmesg: "no free slots in the virtqueue"
>            "virtio pmem device needs a reset"
>
> Fixes: 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
> Signed-off-by: Li Chen <me@linux.beauty>

Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com

> ---
> v2:
> - Use guard(mutex)() for flush_lock (as suggested by Ira Weiny).
> - Drop redundant might_sleep() next to guard(mutex)() (as suggested by Michael S. Tsirkin).
>
>  drivers/nvdimm/nd_virtio.c   | 3 ++-
>  drivers/nvdimm/virtio_pmem.c | 1 +
>  drivers/nvdimm/virtio_pmem.h | 4 ++++
>  3 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> index c3f07be4aa22..af82385be7c6 100644
> --- a/drivers/nvdimm/nd_virtio.c
> +++ b/drivers/nvdimm/nd_virtio.c
> @@ -44,6 +44,8 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
>         unsigned long flags;
>         int err, err1;
>
> +       guard(mutex)(&vpmem->flush_lock);
> +
>         /*
>          * Don't bother to submit the request to the device if the device is
>          * not activated.
> @@ -53,7 +55,6 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
>                 return -EIO;
>         }
>
> -       might_sleep();
>         req_data = kmalloc(sizeof(*req_data), GFP_KERNEL);
>         if (!req_data)
>                 return -ENOMEM;
> diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> index 2396d19ce549..77b196661905 100644
> --- a/drivers/nvdimm/virtio_pmem.c
> +++ b/drivers/nvdimm/virtio_pmem.c
> @@ -64,6 +64,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
>                 goto out_err;
>         }
>
> +       mutex_init(&vpmem->flush_lock);
>         vpmem->vdev = vdev;
>         vdev->priv = vpmem;
>         err = init_vq(vpmem);
> diff --git a/drivers/nvdimm/virtio_pmem.h b/drivers/nvdimm/virtio_pmem.h
> index 0dddefe594c4..f72cf17f9518 100644
> --- a/drivers/nvdimm/virtio_pmem.h
> +++ b/drivers/nvdimm/virtio_pmem.h
> @@ -13,6 +13,7 @@
>  #include <linux/module.h>
>  #include <uapi/linux/virtio_pmem.h>
>  #include <linux/libnvdimm.h>
> +#include <linux/mutex.h>
>  #include <linux/spinlock.h>
>
>  struct virtio_pmem_request {
> @@ -35,6 +36,9 @@ struct virtio_pmem {
>         /* Virtio pmem request queue */
>         struct virtqueue *req_vq;
>
> +       /* Serialize flush requests to the device. */
> +       struct mutex flush_lock;
> +
>         /* nvdimm bus registers virtio pmem device */
>         struct nvdimm_bus *nvdimm_bus;
>         struct nvdimm_bus_descriptor nd_desc;
> --
> 2.52.0
