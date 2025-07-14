Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE9623A9BB
	for <nvdimm@lists.linux.dev>; Mon, 14 Jul 2025 15:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752507842; cv=none; b=UgmJgWi5a3nf5J33Sw7gWhCa7Mp3zJqQFTJgkXxNZ/MxwXplX0ED7cWHQpsIU2WzdhOIwCCYXthXMW7orIroid/vXanTHKcdIuH4XpMbrgtBPskG921erJZ0hs4ZeT/E6BzuHACnqzSPhsWlhDXpfPfWoqtptLEmwUZX9k7XZFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752507842; c=relaxed/simple;
	bh=NHZTk1MbSwuX2TC/cvr03+rgfi9Vzg5JE+R5y6MRDO0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=q5MTJjNUjcGf9fQ1UjicxKBTA92M3JXsRkrsI2d4AP4L/Dn2dpKOZcvhDXo0E71VoYq77MrsuTLj9q0n6hIKVJwNbkbwmrfYvlOMipGH+NZZ2a0BX4qT+ks6jBdXDUHTfC0o47CG/lOAxS66JWArLu8M802JjO15vOLKo0rdPPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dgaAPgzY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dgaAPgzY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752507839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pioZSV5t4QyWHRN8AGbngDT1fEVjtAAoah29uzJwYZQ=;
	b=dgaAPgzYmImyTg5Q3bRekiQy23bojiigh0yFT7iO+9wUCkoXvUU/Px4dQRVL59a36voiCj
	LLOta0GvVvZQx0YHVLWaRVa8Aa9W9h4Wst5LS0Ncdm5387L9tDiBpcTdXnnwEZ07NTozYI
	QKP5wDM3snCjl6y91q8uVxsVV74D1kM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-274-A2zzeiPKMzuFj4_W3vNnnQ-1; Mon,
 14 Jul 2025 11:43:55 -0400
X-MC-Unique: A2zzeiPKMzuFj4_W3vNnnQ-1
X-Mimecast-MFC-AGG-ID: A2zzeiPKMzuFj4_W3vNnnQ_1752507833
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 530631800343;
	Mon, 14 Jul 2025 15:43:52 +0000 (UTC)
Received: from [10.22.80.10] (unknown [10.22.80.10])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D81B5180035E;
	Mon, 14 Jul 2025 15:43:47 +0000 (UTC)
Date: Mon, 14 Jul 2025 17:43:42 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
cc: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk, hch@lst.de, 
    dan.j.williams@intel.com, Jonathan.Cameron@Huawei.com, 
    linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
    linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
    dm-devel@lists.linux.dev
Subject: =?UTF-8?Q?Re=3A_=5BPATCH_v2_00=2F11=5D_dm-pcache_=E2=80=93_pe?=
 =?UTF-8?Q?rsistent-memory_cache_for_block_devices?=
In-Reply-To: <e50ef45e-4c1a-4874-8d5f-9ca86f9a532c@linux.dev>
Message-ID: <1ff2da54-60dd-9719-eb55-386ff32ae421@redhat.com>
References: <20250707065809.437589-1-dongsheng.yang@linux.dev> <85b5cb31-b272-305f-8910-c31152485ecf@redhat.com> <e50ef45e-4c1a-4874-8d5f-9ca86f9a532c@linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="-1463811712-660552650-1752506079=:673007"
Content-ID: <1c6a656d-7cb0-02e3-f428-fcf371e66565@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811712-660552650-1752506079=:673007
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <604db260-a208-1612-a6e0-250e4a0b7b66@redhat.com>



On Wed, 9 Jul 2025, Dongsheng Yang wrote:

> 
> 在 7/8/2025 4:16 AM, Mikulas Patocka 写道:
> > 
> > On Mon, 7 Jul 2025, Dongsheng Yang wrote:
> > 
> > > Hi Mikulas,
> > > 	This is V2 for dm-pcache, please take a look.
> > > 
> > > Code:
> > >      https://github.com/DataTravelGuide/linux tags/pcache_v2
> > > 
> > > Changelogs
> > > 
> > > V2 from V1:
> > > 	- introduce req_alloc() and req_init() in backing_dev.c, then we
> > > 	  can do req_alloc() before holding spinlock and do req_init()
> > > 	  in subtree_walk().
> > > 	- introduce pre_alloc_key and pre_alloc_req in walk_ctx, that
> > > 	  means we can pre-allocate cache_key or backing_dev_request
> > > 	  before subtree walking.
> > > 	- use mempool_alloc() with NOIO for the allocation of cache_key
> > > 	  and backing_dev_req.
> > > 	- some coding style changes from comments of Jonathan.
> > Hi
> > 
> > mempool_alloc with GFP_NOIO never fails - so you don't have to check the
> > returned value for NULL and propagate the error upwards.
> 
> 
> Hi Mikulas:
> 
>    I noticed that the implementation of mempool_alloc—it waits for 5 seconds
> and retries when allocation fails.

No, this is incorrect observation.

mempool_alloc will add the current process to a wait queue:
  prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
then, it will execute the wait:
  io_schedule_timeout(5*HZ);
and then remove the current process from a wait queue:
  finish_wait(&pool->wait, &wait);

but the io_schedule_timeout function will wait at most 5 seconds - it 
doesn't wait exactly 5 seconds. If some other piece of code frees some 
data into the mempool, it executes:
  wake_up(&pool->wait);
so that the process that is waiting in io_schedule_timeout(5*HZ) is woken 
up immediatelly.

See this comment in mempool_alloc:
        /*
         * FIXME: this should be io_schedule().  The timeout is there as a
         * workaround for some DM problems in 2.6.18.
         */
        io_schedule_timeout(5*HZ);

- the timeout is actually a workaround for some buggy code in device 
mapper where the code allocated more and more entries from the mempool 
without freeing them. I fixed this bug many years ago. But people 
shouldn't add more buggy code that depends on this timeout.

> With this in mind, I propose that we handle -ENOMEM inside defer_req() using a
> similar mechanism. something like this commit:
> 
> 
> https://github.com/DataTravelGuide/linux/commit/e6fc2e5012b1fe2312ed7dd02d6fbc2d038962c0
> 
> 
> Here are two key reasons why:
> 
> (1) If we manage -ENOMEM in defer_req(), we don’t need to modify every
> lower-level allocation to use mempool to avoid failures—for example,
> 
> cache_key, backing_req, and the kmem.bvecs you mentioned. More importantly,
> there’s no easy way to prevent allocation failure in some places—for instance,
> bio_init_clone() could still return -ENOMEM.
> 
> (2) If we use a mempool, it will block and wait indefinitely when memory is
> unavailable, preventing the process from exiting.

Mempool will wait until some other code frees some data into the mempool. 
So, as long as your code can make forward progress and finish some 
requests and free their data into the mempool, it should work properly.

On the other hand, non-mempool GFP_NOIO allocations can wait indefinitely.

> But with defer_req(), the user can still manually stop the pcache device using
> dmsetup remove, releasing some memory if user want.
> 
> What do you think?

I think that you should go back to version 2 (that had mempools) and 
change the non-mempool allocation "backing_req->kmem.bvecs = 
kmalloc_array(n_vecs, sizeof(struct bio_vec), GFP_NOIO);" to use a 
mempool.

> Thanx
> 
> Dongsheng

Mikulas
---1463811712-660552650-1752506079=:673007--

