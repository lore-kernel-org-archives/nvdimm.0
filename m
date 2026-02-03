Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D474318EC0
	for <nvdimm@lists.linux.dev>; Tue,  3 Feb 2026 10:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770114443; cv=none; b=In7JjnAaz2FbZIY3SdPhad+go4bP6jfMHjMMbE1zr1zjUvFjc7Q/zUx3IWJeKxizjiLL5axEiBqh45gwdxqv2AbTqTz7DNpaV1mNh0cfB+0uELZVzemSq4+IKBNbyOuFtEWas8zgT+dzNIXMuIh7k9xVQxUJgVXEOPboVDJiccM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770114443; c=relaxed/simple;
	bh=HhpAzoexONqBRfMann0YeEk4K22xyRssx8IfzbrtrLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=IyWt8rd7H5e7yrWXqH7BCY+3WOse9N6dr+Y7PtboWjBcXjJzGVGTgdarPxnRKr7/8foGS02nZcsvvvN2x6yCgnrQSqSKHg3mFeoArVW39t7ezBP7fDtzUySB9StV1AlyWTYwBd7TlxtkYGrfacua2vg+4nLYB+1Y8mLxtAGDKEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XEyveIaS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XEyveIaS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770114440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kA8qyidkR7INyra5mnWciv78DJNfJc/S9cwmeexYPIA=;
	b=XEyveIaSpPf/Akt8ONhpKY8e0VDP5IOPAB4/obHLbm9nWYqNtyoWx1cOqFDSrX3K42N4hO
	akwVY8bGVXp9p8wyTdSItLj5VTBPlLCPf3Pd8jmGJbWM58pgiAPLxNyye9I0bM4criumcT
	SeDBLhy3fh6Q4GFjihuykOa1EA1e4Y0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-NGZ9qzoANfuZjVz34eHmIA-1; Tue, 03 Feb 2026 05:27:17 -0500
X-MC-Unique: NGZ9qzoANfuZjVz34eHmIA-1
X-Mimecast-MFC-AGG-ID: NGZ9qzoANfuZjVz34eHmIA_1770114436
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4359849d324so3812173f8f.1
        for <nvdimm@lists.linux.dev>; Tue, 03 Feb 2026 02:27:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770114436; x=1770719236;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kA8qyidkR7INyra5mnWciv78DJNfJc/S9cwmeexYPIA=;
        b=EAP8Sb6UQqmyXLIL/0aQw2b/w1AUsVQlx/yoOG90hx6KwJJ/BYSDcvVu59ia7l5V/k
         c/uZVKk6IR0hshLrVwcq8vf0ry6hwx+1CnO1C85eUXLmn7W+yZkQ3rnj6g0tbOJqaaMH
         rEUvxlq6NRHPFuEqjIJDT5N4Apq12jes/oCVENa3sST8CZRTK1yiC6pFz9wSsUBLpWHa
         FBOhmlqG+FxfG3WX3h3j9H6q9wy/WF92tNExQQOseUg5SMaDv29Gh4YGpi8HhY/XUqzI
         2xuYmTh6+wwRm8MZX9Wc+kAje2gMZ4BKPkK6bVrF2I2giz0Fp76EYauKouO85p/bNFrg
         nwJg==
X-Forwarded-Encrypted: i=1; AJvYcCWP1+ac3Uy3V8q59M/PMIBtW+yaOyl7bLMNzNcfsajoLBunY3Zf9q8S4t0wlGQvqbV+A9RLN3Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YwrgxdkrJTqDnom1L7wJdIDAsFKQd/EaCTyU3ps+P1gouJuO2m7
	N7lzpzNzui5i5GCOVKtmQ3YGzmoXV4fCPlBGqoULXWeuqmysKCEeq3oxDnCSkwSN3NJrc35Ei12
	xiwv7U+6ddusL/pJJ0RxXe0itLMdJKAzw1i2P+0rR5E8Zxd4DqHfj5iEVqQ==
X-Gm-Gg: AZuq6aLJ0PXGy5AYiQD6JboG67KoPw2pb0SOrZOEkWePtinr3DcCfSLupAkqaDXoamc
	IYxNwxNsQdwRCZceujFIy4PLI3sM4H5JUlHxWaF3QTVQE8rUndFJQC9fU4xODT1qyKe0JZrtjd9
	OOtNwHYZduZjTUrkbvUENumLuAexOsorjwWPkeFY8cV+B69BBhkyX+6eEeqVkJG8X1PaPXNKQqN
	5WYlE0h0O5wVYdZuOklPsnl8sy0IswxK6E9DVv+R9uHerm+E4N4jQHvIpe8JOLBf878fohqZk2l
	53lvdmIECqThwP0maGnPxHUJ2BGYUsWijUtLwktSHoh8kBjzfUj6vRf1E7g29y18GYfxmRKBNvh
	xjtSYO8VwtDnIPvNBmraYrGxeSrNibNfUAg==
X-Received: by 2002:a5d:4851:0:b0:436:1e6:e1e3 with SMTP id ffacd0b85a97d-43601e6e2damr9992067f8f.46.1770114436124;
        Tue, 03 Feb 2026 02:27:16 -0800 (PST)
X-Received: by 2002:a5d:4851:0:b0:436:1e6:e1e3 with SMTP id ffacd0b85a97d-43601e6e2damr9992025f8f.46.1770114435579;
        Tue, 03 Feb 2026 02:27:15 -0800 (PST)
Received: from redhat.com (IGLD-80-230-34-155.inter.net.il. [80.230.34.155])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e131ce64sm53894663f8f.26.2026.02.03.02.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 02:27:15 -0800 (PST)
Date: Tue, 3 Feb 2026 05:27:12 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Li Chen <me@linux.beauty>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Yuval Shaia <yuval.shaia@oracle.com>,
	virtualization@lists.linux.dev, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] nvdimm: virtio_pmem: serialize flush requests
Message-ID: <20260203052616-mutt-send-email-mst@kernel.org>
References: <20260203021353.121091-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260203021353.121091-1-me@linux.beauty>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SfIDTE72wvMi8mSFvBZdgHY-QBAOmTGROSKOd9r0_qg_1770114436
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 03, 2026 at 10:13:51AM +0800, Li Chen wrote:
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


Thanks!
And the commit message looks good now and includes the
reproducer.

Acked-by: Michael S. Tsirkin <mst@redhat.com>

Ira are you picking this up?


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
>  	unsigned long flags;
>  	int err, err1;
>  
> +	guard(mutex)(&vpmem->flush_lock);
> +
>  	/*
>  	 * Don't bother to submit the request to the device if the device is
>  	 * not activated.
> @@ -53,7 +55,6 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
>  		return -EIO;
>  	}
>  
> -	might_sleep();
>  	req_data = kmalloc(sizeof(*req_data), GFP_KERNEL);
>  	if (!req_data)
>  		return -ENOMEM;
> diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> index 2396d19ce549..77b196661905 100644
> --- a/drivers/nvdimm/virtio_pmem.c
> +++ b/drivers/nvdimm/virtio_pmem.c
> @@ -64,6 +64,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
>  		goto out_err;
>  	}
>  
> +	mutex_init(&vpmem->flush_lock);
>  	vpmem->vdev = vdev;
>  	vdev->priv = vpmem;
>  	err = init_vq(vpmem);
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
>  	/* Virtio pmem request queue */
>  	struct virtqueue *req_vq;
>  
> +	/* Serialize flush requests to the device. */
> +	struct mutex flush_lock;
> +
>  	/* nvdimm bus registers virtio pmem device */
>  	struct nvdimm_bus *nvdimm_bus;
>  	struct nvdimm_bus_descriptor nd_desc;
> -- 
> 2.52.0

