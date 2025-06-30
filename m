Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E0828C5AC
	for <nvdimm@lists.linux.dev>; Mon, 30 Jun 2025 15:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751298336; cv=none; b=lBnq/LQasj281oHtA+4AwyXlLvh1cgh6v6XuTjsnc7llQ4ONVuEBmzDM8NMYQBQsN1tF+jJNbI5+504qEOkTe8EEuGTDZOagklfRP7JbxDVOgibrbwxFDqCmIyWoQ18Nlsdc2mETO7v4gltYNmau1viYowcd/RYnSXc09O0JZzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751298336; c=relaxed/simple;
	bh=ALmsu4DpCtGbbhmY3nVRw1xg+2esadVAR3daySXJWtg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=VUwG28EZvcqEr7ETHboSJmpHyndAwJqaHQ7xbVm8bB7V/LTlaMguFBzyQZSxrnmuiJ9JphubKbR1Vw/1rsnpy17b7tmIy4tfteLlRw1weuGR1R1b6+ayXbXGppbxDMY/23VPEuP9528C/Ynjc/T5XMpMaGscDYTu352sU5ofRxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TG2KMl31; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TG2KMl31"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751298333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ihrgL7XLc9K6vXziileToqhZtOGRjkRkc3jWqhOJ//8=;
	b=TG2KMl31uahSMg5BCM0BOmQT5Rf8+0eIKOMoCWYv8VQnfduIINIhmLO7WerrzpdABKtCbE
	TkINENSdFiIo2ZVSminixqqLxoMT+3ixwdS0sVjiN4V+D7TqBobGIu4d3fj4Yx2OgQpUeI
	b5qyj7oeSzfHtKgNBobM7OeH0SEGz7c=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-375-4pFzU12FOIqSwJaSEVD59A-1; Mon,
 30 Jun 2025 11:45:30 -0400
X-MC-Unique: 4pFzU12FOIqSwJaSEVD59A-1
X-Mimecast-MFC-AGG-ID: 4pFzU12FOIqSwJaSEVD59A_1751298328
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EF5091978F63;
	Mon, 30 Jun 2025 15:45:27 +0000 (UTC)
Received: from [10.22.80.10] (unknown [10.22.80.10])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 41AF31800285;
	Mon, 30 Jun 2025 15:45:23 +0000 (UTC)
Date: Mon, 30 Jun 2025 17:45:18 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
cc: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk, hch@lst.de, 
    dan.j.williams@intel.com, Jonathan.Cameron@Huawei.com, 
    linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
    linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
    dm-devel@lists.linux.dev
Subject: =?UTF-8?Q?Re=3A_=5BPATCH_v1_00=2F11=5D_dm-pcache_=E2=80=93_pe?=
 =?UTF-8?Q?rsistent-memory_cache_for_block_devices?=
In-Reply-To: <43e84a3e-f574-4c97-9f33-35fcb3751e01@linux.dev>
Message-ID: <f0c46aba-9756-5f05-a843-51bc4898a313@redhat.com>
References: <20250624073359.2041340-1-dongsheng.yang@linux.dev> <8d383dc6-819b-2c7f-bab5-2cd113ed9ece@redhat.com> <7ff7c4fc-d830-41c9-ab94-a198d3d9a3b5@linux.dev> <43e84a3e-f574-4c97-9f33-35fcb3751e01@linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811712-2042544932-1751298327=:274049"
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811712-2042544932-1751298327=:274049
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Mon, 30 Jun 2025, Dongsheng Yang wrote:

> Hi Mikulas,
> 
>     The reason why we don’t release the spinlock here is that if we do, the
> subtree could change.
> 
> For example, in the `fixup_overlap_contained()` function, we may need to split
> a certain `cache_key`, and that requires allocating a new `cache_key`.
> 
> If we drop the spinlock at this point and then re-acquire it after the
> allocation, the subtree might already have been modified, and we cannot safely
> continue with the split operation.

Yes, I understand this.

>     In this case, we would have to restart the entire subtree search and walk.
> But the new walk might require more memory—or less,
> 
> so it's very difficult to know in advance how much memory will be needed
> before acquiring the spinlock.
> 
>     So allocating memory inside a spinlock is actually a more direct and
> feasible approach. `GFP_NOWAIT` fails too easily, maybe `GFP_ATOMIC` is more
> appropriate.

Even GFP_ATOMIC can fail. And it is not appropriate to return error and 
corrupt data when GFP_ATOMIC fails.

> What do you think?

If you need memory, you should drop the spinlock, allocate the memory 
(with mempool_alloc(GFP_NOIO)), attach the allocated memory to "struct 
pcache_request" and retry the request (call pcache_cache_handle_req 
again).

When you retry the request, there are these possibilities:
* you don't need the memory anymore - then, you just free it
* you need the amount of memory that was allocated - you just proceed 
  while holding the spinlock
* you need more memory than what you allocated - you drop the spinlock, 
  free the memory, allocate a larger memory block and retry again

Mikulas
---1463811712-2042544932-1751298327=:274049--

