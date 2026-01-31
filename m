Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD3A35FF78
	for <nvdimm@lists.linux.dev>; Sat, 31 Jan 2026 17:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769881588; cv=none; b=KnTA+ekdWxCLcbg2giEsCHyTMxTkTAFvePa4alooCvb/cWluGDdcYN7QVQ+zUxbfIitE6275Chu9nLmbiIPEoBhfj7IEccuWCScy6eJv0jt+ZFEUkKVxXsw/gB8VJanvtt1siP6JbUBNeBQip58ufgR/2cQlZ3vKrHkOjKe5Pd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769881588; c=relaxed/simple;
	bh=FO0XxGiW7YqfVtzLltyctsCxTlWqT0+V7VxlKQHFZjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=PdDG9neWWyaAvkOAlA6lltUi3AB+5uGHnfT9tRrLfCTq7u56AbeTr9NeYaI2TR9gTJkXgR8KrweyZDwl/3jfXkUjdQS8qrFIX0li3jLa1PgaKWKN9w3NnNEb1HlYaPzhZmPqRNVsCydGd5GIuqVeZxDwBVBHN81zKicFARjp3R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LXzVlO8v; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LXzVlO8v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769881586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5XwIcJJrN88f5EmnbhwkMpwuoOxnaOad2/ndcUFOcSM=;
	b=LXzVlO8vs4axWQd715chtDsx9UvKnJxT9ejNqnRJLzH+1wlomTjR9l4v/DwGcWR2syUTUZ
	7SoI7z2mQakNK1L4juxewjagoUFVB3PTQKzGEuxCZInxhxIOa6GUToHA2E2TMby1WtC/37
	pp2TsIxAyT+jkZs3LfxI3TNjjFUnt0Q=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-90-R4Wdnhh2OeCEmbuHWg1WtA-1; Sat, 31 Jan 2026 12:46:24 -0500
X-MC-Unique: R4Wdnhh2OeCEmbuHWg1WtA-1
X-Mimecast-MFC-AGG-ID: R4Wdnhh2OeCEmbuHWg1WtA_1769881583
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43284f60a8aso2639769f8f.3
        for <nvdimm@lists.linux.dev>; Sat, 31 Jan 2026 09:46:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769881583; x=1770486383;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5XwIcJJrN88f5EmnbhwkMpwuoOxnaOad2/ndcUFOcSM=;
        b=alVYj4qYSpoauoDb8Wn71HD4Ei6dGLO/6Ums4ltRDUeD79WqXkgwJLRppBSfhlIknw
         B/aFSlz3zXYsgSeN90UIUuI57EAS3TKP4sIVZqknwIZJ8Ovpbj0GzKKoB5Oy0/4HFYDQ
         J9LCI0KEUafb6rTLGN75fAQM0jBx3K9JHZJYEl0FTaq7aLu4EYn3MWfn1mbBknr9hDut
         0L3QWJ7TlDq/tbitI4IC9SpUAEER4nvyaac1zCRCAftebMfTwxQGFF4A5d1znYIvsUMk
         f6jjgTOftzE8TvP15E1BxDYcKkiKcKcSe31DoOk36GawxWtu9dqPo45d+61Co24o7pw5
         9PyA==
X-Forwarded-Encrypted: i=1; AJvYcCXPN9dCqscdrq3w/B9JTQUF1qlGIGLkY9+NZfurGiNuAi8DRn12F6gyk3hWMWK3VuLGs6BbpOY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyieDtxizWgZnMowXi06rXwu0eQ3vzDI88meaR+R3jPfkGCfN12
	c7TJ8GV4tiaArX1a3nzY+IRY0qMOwzmdhqW51kltC0ITM1rUK60ZCOKumIF2esy2yqP7NPr6vlY
	HVbHLs3E4Ho3z0WYpGAr3Au3nX0TJTPLxuoAwAbUB+nBbdAdF1RZbzMNxmw==
X-Gm-Gg: AZuq6aIYLDL0baqrGelzot2JIhDOSko5dX8K9V6AZZGRpJBi5FY9aRhDtEKqhpW1/F+
	f0KaByka8K7aX4W0HpGvrmwxk3QPIMkgcaUtZEgC2B1ntp8ZTdC3j1yiCwMjD4tRRrh+P4VR41T
	5d90vKPylpLZBr9YjLbZQTeVPFiJptK6z83MTn9aKH4CncMWFRonRT1g02WSy4tntxuNfRKs8FQ
	IdM0vLQMtLTRf0GkosM5hAVGQ3EbZ7DhgaFXmH/cnd23vjA0nhKfw64BEcS2pU1b/UCdKvhOAkt
	4My96pE5eD/DXHDG8yF25Rio8TKQc7EyuZdBkVhYQMkhkYvtmd7zIYPGKOwrWbTyS2xbLT+2GZ+
	CF14HSw==
X-Received: by 2002:a05:600c:34c4:b0:480:52fd:d2e4 with SMTP id 5b1f17b1804b1-482db012dd7mr87513045e9.0.1769881583158;
        Sat, 31 Jan 2026 09:46:23 -0800 (PST)
X-Received: by 2002:a05:600c:34c4:b0:480:52fd:d2e4 with SMTP id 5b1f17b1804b1-482db012dd7mr87512805e9.0.1769881582675;
        Sat, 31 Jan 2026 09:46:22 -0800 (PST)
Received: from redhat.com ([2a06:c701:73e3:8f00:866c:5eeb:fc46:7674])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4806ce4c3d1sm289628525e9.9.2026.01.31.09.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jan 2026 09:46:21 -0800 (PST)
Date: Sat, 31 Jan 2026 12:46:19 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Li Chen <me@linux.beauty>, Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Jakub Staron <jstaron@google.com>, nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nvdimm: virtio_pmem: serialize flush requests
Message-ID: <20260131124554-mutt-send-email-mst@kernel.org>
References: <20260113034552.62805-1-me@linux.beauty>
 <697d19fc772ad_f6311008@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <697d19fc772ad_f6311008@iweiny-mobl.notmuch>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: H4fM0fJZxr41TE2skXHXrUlJRunK2hPtNL1E8-XLedo_1769881583
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 30, 2026 at 02:52:12PM -0600, Ira Weiny wrote:
> Li Chen wrote:
> > Under heavy concurrent flush traffic, virtio-pmem can overflow its request
> > virtqueue (req_vq): virtqueue_add_sgs() starts returning -ENOSPC and the
> > driver logs "no free slots in the virtqueue". Shortly after that the
> > device enters VIRTIO_CONFIG_S_NEEDS_RESET and flush requests fail with
> > "virtio pmem device needs a reset".
> > 
> > Serialize virtio_pmem_flush() with a per-device mutex so only one flush
> > request is in-flight at a time. This prevents req_vq descriptor overflow
> > under high concurrency.
> > 
> > Reproducer (guest with virtio-pmem):
> >   - mkfs.ext4 -F /dev/pmem0
> >   - mount -t ext4 -o dax,noatime /dev/pmem0 /mnt/bench
> >   - fio: ioengine=io_uring rw=randwrite bs=4k iodepth=64 numjobs=64
> >         direct=1 fsync=1 runtime=30s time_based=1
> 
> I don't see this error.
> 
> <file>
> 13:28:50 > cat foo.fio 
> # test http://lore.kernel.org/20260113034552.62805-1-me@linux.beauty
> 
> [global]
> filename=/mnt/bench/foo
> ioengine=io_uring
> size=1G
> bs=4K
> iodepth=64
> numjobs=64
> direct=1
> fsync=1
> runtime=30s
> time_based=1
> 
> [rand-write]
> rw=randwrite
> </file>
> 
> It's possible I'm doing something wrong.  Can you share your qemu cmdline
> or more details on the bug yall see.
> 
> >   - dmesg: "no free slots in the virtqueue"
> >            "virtio pmem device needs a reset"
> > 
> > Fixes: 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
> > Signed-off-by: Li Chen <me@linux.beauty>
> > ---
> >  drivers/nvdimm/nd_virtio.c   | 15 +++++++++++----
> >  drivers/nvdimm/virtio_pmem.c |  1 +
> >  drivers/nvdimm/virtio_pmem.h |  4 ++++
> >  3 files changed, 16 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> > index c3f07be4aa22..827a17fe7c71 100644
> > --- a/drivers/nvdimm/nd_virtio.c
> > +++ b/drivers/nvdimm/nd_virtio.c
> > @@ -44,19 +44,24 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
> >  	unsigned long flags;
> >  	int err, err1;
> >  
> > +	might_sleep();


for that matter might_sleep not really needed near mutex_lock.


> > +	mutex_lock(&vpmem->flush_lock);
> 
> Assuming this does fix a bug I'd rather use guard here.
> 
> 	guard(mutex)(&vpmem->flush_lock);
> 
> Then skip all the gotos and out_unlock stuff.
> 
> Also, does this affect performance at all?
> 
> Ira
> 
> > +
> >  	/*
> >  	 * Don't bother to submit the request to the device if the device is
> >  	 * not activated.
> >  	 */
> >  	if (vdev->config->get_status(vdev) & VIRTIO_CONFIG_S_NEEDS_RESET) {
> >  		dev_info(&vdev->dev, "virtio pmem device needs a reset\n");
> > -		return -EIO;
> > +		err = -EIO;
> > +		goto out_unlock;
> >  	}
> >  
> > -	might_sleep();
> >  	req_data = kmalloc(sizeof(*req_data), GFP_KERNEL);
> > -	if (!req_data)
> > -		return -ENOMEM;
> > +	if (!req_data) {
> > +		err = -ENOMEM;
> > +		goto out_unlock;
> > +	}
> >  
> >  	req_data->done = false;
> >  	init_waitqueue_head(&req_data->host_acked);
> > @@ -103,6 +108,8 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
> >  	}
> >  
> >  	kfree(req_data);
> > +out_unlock:
> > +	mutex_unlock(&vpmem->flush_lock);
> >  	return err;
> >  };
> 
> [snip]

