Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3421EF091
	for <nvdimm@lists.linux.dev>; Mon,  7 Jul 2025 20:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751919397; cv=none; b=jJRoUcTlF6C3Da+JpB9IICwfY2DBzYBywHgOgQg75EkquZWvD1aV4kLtE1dpX3vfuHqY9EouDCrfbAkluzguRTWrRuiGB0XVmLGcd4ZLK3WKu1HfCvG7eaZv63YMLCPPpkSCryem2LVN2xN8oJq6Lt0iUwx3lxtBQmErLG7cK90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751919397; c=relaxed/simple;
	bh=jYEw+dpQOLsLhqtci6KxjAhEKrOUjQnuRdygwxBmALc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=bMyfTw6dK/bmt3ed8IBGeWrfH4j1AAAklMYzIgx8xEg2u1eQnnU3Ws4OeViklLn2k7iFoLp5YGFbJWmjWiRzzlbl84k7voAAWeztMBe2+XhkUhbGvA5jB7kMDJ5WsJNcyOfE5ofHUKVed7l1+IvoP2vYQ3qiAk83BoxokbG3P4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q/34JVyg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q/34JVyg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751919394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=acOOSG4Qq2nv4W4b3/Nnbhcn7CmsttwwzAN835fhnjc=;
	b=Q/34JVyg4JXhiOeJgdF51a81Mr+I/8CexS38Ei+GsNCGkkFqVyVaQOOPYNYh9737UbsBXe
	OWgsFY/zxmZx9R8strL5JKn4eCA2tc7vOS94unByMeMZDHKzUGep/lvfJv+ktUmHZTWYCs
	HIJ+hdu9lmw6aWMHNRThyckt7tkUCQY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-473-YFZl0pC0NLq_XoKGDL9m0w-1; Mon,
 07 Jul 2025 16:16:31 -0400
X-MC-Unique: YFZl0pC0NLq_XoKGDL9m0w-1
X-Mimecast-MFC-AGG-ID: YFZl0pC0NLq_XoKGDL9m0w_1751919390
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 349701801208;
	Mon,  7 Jul 2025 20:16:29 +0000 (UTC)
Received: from [10.22.80.10] (unknown [10.22.80.10])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54B6E19560AB;
	Mon,  7 Jul 2025 20:16:24 +0000 (UTC)
Date: Mon, 7 Jul 2025 22:16:19 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
cc: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk, hch@lst.de, 
    dan.j.williams@intel.com, Jonathan.Cameron@Huawei.com, 
    linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
    linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
    dm-devel@lists.linux.dev
Subject: =?UTF-8?Q?Re=3A_=5BPATCH_v2_00=2F11=5D_dm-pcache_=E2=80=93_pe?=
 =?UTF-8?Q?rsistent-memory_cache_for_block_devices?=
In-Reply-To: <20250707065809.437589-1-dongsheng.yang@linux.dev>
Message-ID: <85b5cb31-b272-305f-8910-c31152485ecf@redhat.com>
References: <20250707065809.437589-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17



On Mon, 7 Jul 2025, Dongsheng Yang wrote:

> Hi Mikulas,
> 	This is V2 for dm-pcache, please take a look.
> 
> Code:
>     https://github.com/DataTravelGuide/linux tags/pcache_v2
> 
> Changelogs
> 
> V2 from V1:
> 	- introduce req_alloc() and req_init() in backing_dev.c, then we
> 	  can do req_alloc() before holding spinlock and do req_init()
> 	  in subtree_walk().
> 	- introduce pre_alloc_key and pre_alloc_req in walk_ctx, that
> 	  means we can pre-allocate cache_key or backing_dev_request
> 	  before subtree walking.
> 	- use mempool_alloc() with NOIO for the allocation of cache_key
> 	  and backing_dev_req.
> 	- some coding style changes from comments of Jonathan.

Hi

mempool_alloc with GFP_NOIO never fails - so you don't have to check the 
returned value for NULL and propagate the error upwards.

"backing_req->kmem.bvecs = kmalloc_array(n_vecs, sizeof(struct bio_vec), 
GFP_NOIO)" - this call may fail and you should handle the error gracefully 
(i.e. don't end the bio with an error). Would it be possible to trim the 
request to BACKING_DEV_REQ_INLINE_BVECS vectors and retry it? 
Alternativelly, you can create a mempool for the largest possible n_vecs 
and allocate from this mempool if kmalloc_array fails.

I'm sending two patches for dm-pcache - the first patch adds the include 
file linux/bitfield.h - it is needed in my config. The second patch makes 
slab caches per-module rather than per-device, if you have them 
per-device, there are warnings about duplicate cache names.


BTW. What kind of persistent memory do you use? (afaik Intel killed the 
Optane products and I don't know of any replacement)

Some times ago I created a filesystem for persistent memory - see 
git://leontynka.twibright.com/nvfs.git - I'd be interested if you can test 
it on your persistent memory implementation.

Mikulas

