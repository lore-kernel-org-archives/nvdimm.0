Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC55285049
	for <nvdimm@lists.linux.dev>; Mon, 30 Jun 2025 13:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751290267; cv=none; b=CWIS7u16chR1rpzhr+pSjF81X3iYkKyJTwx5TaSfGddLZcu16fMlFq/MbWmBrwR1+UvjtXsLpfSCuyaykH3K0dg+WtngHGy8utSLNE4uUzjyPiXdaRB4xww66yvCpmI/RWwGm07XB2BBWWZiPOQNNB8jqLSEOxVTwCyhK9Ew+HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751290267; c=relaxed/simple;
	bh=0/FZCiLaRndiTPePRIo/GUOxbR20fxMdpfov79uN7uQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=hcpaO5r5UxfmVB8FY0WY9NhHAEhmj3gaGdCVriEIxI+52/V+MBwn9P0adLCBsFGYEX+3D+faWja2lxK5cSSVcqPY5PngMJtTr1qqgST207oiWJs1DDuC57MIVP4PrgyyLZ7kB9fEucoCZyobCGj1aXIrA2M681GDope+fOo12PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d0DYH4zV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d0DYH4zV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751290263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jz9RQCLVSvMznWWKk2eRSrkkyI7/meflTI0QApH5lD4=;
	b=d0DYH4zV/wtw8RFwzLsERABJKh15VOTgW8VzsVvz5QkxiEruVw7PYgys0rGaFAN/6fQLoQ
	2mkbp14yAnTThcWTOKDzLl1K1M9DjAgT1XVF08hLXqzks2wqJaI7j1TznG0o1xnyPWlsyO
	eTVrpP0N1mI3tzBAdheTloA+szYBGSE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-130-VVFOYvEXNZqE0X_VvTDHeQ-1; Mon,
 30 Jun 2025 09:31:00 -0400
X-MC-Unique: VVFOYvEXNZqE0X_VvTDHeQ-1
X-Mimecast-MFC-AGG-ID: VVFOYvEXNZqE0X_VvTDHeQ_1751290255
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B148B190FBC6;
	Mon, 30 Jun 2025 13:30:54 +0000 (UTC)
Received: from [10.22.80.10] (unknown [10.22.80.10])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 20F3E195609D;
	Mon, 30 Jun 2025 13:30:50 +0000 (UTC)
Date: Mon, 30 Jun 2025 15:30:48 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
cc: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk, hch@lst.de, 
    dan.j.williams@intel.com, Jonathan.Cameron@Huawei.com, 
    linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
    linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
    dm-devel@lists.linux.dev
Subject: =?UTF-8?Q?Re=3A_=5BPATCH_v1_00=2F11=5D_dm-pcache_=E2=80=93_pe?=
 =?UTF-8?Q?rsistent-memory_cache_for_block_devices?=
In-Reply-To: <20250624073359.2041340-1-dongsheng.yang@linux.dev>
Message-ID: <8d383dc6-819b-2c7f-bab5-2cd113ed9ece@redhat.com>
References: <20250624073359.2041340-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15



On Tue, 24 Jun 2025, Dongsheng Yang wrote:

> Hi Mikulas,
> 	This is V1 for dm-pcache, please take a look.
> 
> Code:
>     https://github.com/DataTravelGuide/linux tags/pcache_v1
> 
> Changelogs from RFC-V2:
> 	- use crc32c to replace crc32
> 	- only retry pcache_req when cache full, add pcache_req into defer_list,
> 	  and wait cache invalidation happen.
> 	- new format for pcache table, it is more easily extended with
> 	  new parameters later.
> 	- remove __packed.
> 	- use spin_lock_irq in req_complete_fn to replace
> 	  spin_lock_irqsave.
> 	- fix bug in backing_dev_bio_end with spin_lock_irqsave.
> 	- queue_work() inside spinlock.
> 	- introduce inline_bvecs in backing_dev_req.
> 	- use kmalloc_array for bvecs allocation.
> 	- calculate ->off with dm_target_offset() before use it.

Hi

The out-of-memory handling still doesn't seem right.

If the GFP_NOWAIT allocation doesn't succeed (which may happen anytime, 
for example it happens when the machine is receiving network packets 
faster than the swapper is able to swap out data), create_cache_miss_req 
returns NULL, the caller changes it to -ENOMEM, cache_read returns 
-ENOMEM, -ENOMEM is propagated up to end_req and end_req will set the 
status to BLK_STS_RESOURCE. So, it may randomly fail I/Os with an error.

Properly, you should use mempools. The mempool allocation will wait until 
some other process frees data into the mempool.

If you need to allocate memory inside a spinlock, you can't do it reliably 
(because you can't sleep inside a spinlock and non-sleepng memory 
allocation may fail anytime). So, in this case, you should drop the 
spinlock, allocate the memory from a mempool with GFP_NOIO and jump back 
to grab the spinlock - and now you holding the allocated object, so you 
can use it while you hold the spinlock.


Another comment:
set_bit/clear_bit use atomic instructions which are slow. As you already 
hold a spinlock when calling them, you don't need the atomicity, so you 
can replace them with __set_bit and __clear_bit.

Mikulas

