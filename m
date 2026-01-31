Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72333361643
	for <nvdimm@lists.linux.dev>; Sat, 31 Jan 2026 17:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769881643; cv=none; b=dYXJ9H2x7FeaYDuk+zHupaN1jzq8Tuu6/l/Ot6NLdlsr5RP+J6S0MsQFtVelbayLJBXb3QYPXuVAq5yN1qQf2Jkd71XyjTBzG0fh4VE0awmFNsaE47/xEWFZV57ns0zyZyizZZ2r3zamRGCb2dq9Xe/HRYQWHktk4c4goRtGnVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769881643; c=relaxed/simple;
	bh=euC1NR7KWzjKk7aJJoJp/mDOt//epXbAUPHvHSiARFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=DTJlnXzV/x62GPX+nMtmWJSqot6AbLFG50O/ZTt2bOcSIfwCVpsOYytu1y0s4GKEaErwFbu8AwNZ6RkjBiefzMMZ46YLqUnj85waEC/mupjThqNvgpfPisIKPlsfjTeyb+34kLg5sIe+zK9ixS35srpE55jbHrOLScD/Ti+zc8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F8mTs3m/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F8mTs3m/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769881641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lyC9AeugLVf6y9Ie9AFkVUdIHXhswpQlP3HqazDDtWI=;
	b=F8mTs3m/OU77D5QvXM8ulweZ89A86qGQFGZJ95upVU3NdP/JxnZtOV8CLES2Kwh/TvQjEt
	e8lSE9J7kRD8RS+kDMJCjPITAWI9Hw1X/0WVsoJbrLTvZOcZl4lJnUQTcuB1+PRh7abexV
	V5QCFwONOfVK1M69q8fGU00Ei2tSOiw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-HxhyjP9lP0-o7DUCuK6dEw-1; Sat, 31 Jan 2026 12:47:20 -0500
X-MC-Unique: HxhyjP9lP0-o7DUCuK6dEw-1
X-Mimecast-MFC-AGG-ID: HxhyjP9lP0-o7DUCuK6dEw_1769881639
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48069a43217so33145635e9.1
        for <nvdimm@lists.linux.dev>; Sat, 31 Jan 2026 09:47:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769881639; x=1770486439;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lyC9AeugLVf6y9Ie9AFkVUdIHXhswpQlP3HqazDDtWI=;
        b=wCQALqwxyTTwGJrQodGcAJFO7W4YUnx59VFmcIAXn7SPdTBrGqzgaTC+TrMC8huzZT
         GLQOe5fNqlEOt6YM88xX7CXqhXvlC5YZRxyy8+yrNAZw5ZDxsHMbIbh15IdYbbYD26j1
         sxYy0IDv7KKz1j+GE14cMjjE0vnzybcIpblF9XlXsxBAjym0GX+WMy0gZiOmW5LN6/hS
         sS/PONiTnZGbpO7jJMLyXD5NgN/3lKlD2L+D0+p0u5YEAXcCeTJCLYb7Fq8idYeypl3i
         p+6lr+60dNyQz3YQn/wzfP/lY0YjBNgzjdznxMq7Viw/xipEYBpC0Gb40MpDhItU/F6a
         DEjg==
X-Forwarded-Encrypted: i=1; AJvYcCVZt5XM3HfhhBaImOdJbbhcgPzB3a5E9tTeubudRlOEygJUfIZ3KBHLy0kzs8gng7aCcwn/VUA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyuogd3mzEVyICSnYIm7vZ/3axab4dPBuS3xeSBFWCl75SS9jBd
	F9auCMKRjDgQq7ibuGeRmFEDitwI03I2XbhqPYA3xfX3vKw3aM88DCSQhQ6d9W6nXeT1SxqlOgy
	BXFXzlTObx9xH449jWqpcPmV/8kC9BECfeyuxpS9xFdBhH8C+KgwvNNXE1w==
X-Gm-Gg: AZuq6aLIiAMV+2NocI76dvm9JHrcpM50LOs5KGDObSUdx81WWpeiFu5S7qaK9Jtj+iK
	kAYWvq4D0NgnxvYPS7ImIteDICjF5EjYJXAt2PlEYvAO2VYf2rX0DYyutyAeZK41UVBNlpvTk3z
	e+rcqYegzZ2LZn1LtVwnyMrYXy/If2Ca496ut9N50MwViLhr/YQhe9hWD5oDdt2O7MtbCB8NVaw
	r3XIvYikcnENNxl1T9vTFCLpzsA8fBTRhE9fHI3FxJGlUkgZqoolpT+eqx7Dre/i9IKcTjv/bx9
	t3MJBwN+aRCO7BsLvZ8FWgEHXEEhl1MgovNoWr/N/z7FhDCJNs4ezrEtP6EpMNoptIunKSNs57t
	ORctP3g==
X-Received: by 2002:a05:600c:3ba0:b0:47e:e71a:e13a with SMTP id 5b1f17b1804b1-482db4ee2camr81020295e9.32.1769881638745;
        Sat, 31 Jan 2026 09:47:18 -0800 (PST)
X-Received: by 2002:a05:600c:3ba0:b0:47e:e71a:e13a with SMTP id 5b1f17b1804b1-482db4ee2camr81020105e9.32.1769881638297;
        Sat, 31 Jan 2026 09:47:18 -0800 (PST)
Received: from redhat.com ([2a06:c701:73e3:8f00:866c:5eeb:fc46:7674])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4806ce5ec6bsm294453495e9.15.2026.01.31.09.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jan 2026 09:47:17 -0800 (PST)
Date: Sat, 31 Jan 2026 12:47:15 -0500
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
Message-ID: <20260131124628-mutt-send-email-mst@kernel.org>
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
X-Mimecast-MFC-PROC-ID: I1XWrRcaOF4SDnoNOuDUevBEjeafk6-9NE_5s7rU0YU_1769881639
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
> > +	mutex_lock(&vpmem->flush_lock);
> 
> Assuming this does fix a bug I'd rather use guard here.

Do you, from code review, agree with the logic that
it's racy right now?
Whether the bug is reproducible isn't really the question.


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

