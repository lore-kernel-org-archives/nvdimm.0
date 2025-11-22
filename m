Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73A1199234
	for <nvdimm@lists.linux.dev>; Sat, 22 Nov 2025 03:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763782552; cv=none; b=qQnK4nyHtVOPzLJaH3xjvj6WorKyK98esQD7ZCwSI8P5qC5xWQLEOAW5mFdlohp7lp9cF7adP2POHlbTQMJyKku5lobfWmZRmi2y1kzoOIyKA+n7MHq/NO9d1WH3z5D5uvlQ6llIEe+qBV03v1MV7A4gEyvLqPAS9uuvr7zqgxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763782552; c=relaxed/simple;
	bh=DtlZjjB5GXBxNimbN1fUyBrU1LDcvuZ//NBqVnUr52c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FDZ/9o85ha9AsHbNmOSDikBizhMzNA1KJUTG8OSmGmJ4jMcOxLsEJDKs4xlt+LfmH/+/+Ty8Kw73tmODJYd9hcFwQyWYpCTTAX/tBFMf1/utEqmW5rnWf/u3+uNgQC2JNf/L86bM42RSf9xY5C0CiGt5gg/m7vZk+9YHkEeB210=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cl9rkfde; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cl9rkfde"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763782549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jjkw7I36uekbrB3Ab3Kh8mBpfHiwM7PFy2Oe3WuWs0A=;
	b=cl9rkfdeVXSAJzKOEZ4MxwQp9mioDgXLCjW6FteGMmrFElT83Ul02/d9WJtmhvkxUnxKdJ
	s+m7b+iB0D1IE4fGu+z9xb3bewQXnSrh8oehIy30/vfNGddgT5S5yVQEwKPwDNZ2COi6WZ
	OXG7MJg4osGQTJcd8p0MRA/+2Vr0xGc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-141-1VuEGGSHOMylSb3CeDK9wg-1; Fri,
 21 Nov 2025 22:35:46 -0500
X-MC-Unique: 1VuEGGSHOMylSb3CeDK9wg-1
X-Mimecast-MFC-AGG-ID: 1VuEGGSHOMylSb3CeDK9wg_1763782544
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC2E1180049F;
	Sat, 22 Nov 2025 03:35:43 +0000 (UTC)
Received: from fedora (unknown [10.72.116.9])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 11E371956045;
	Sat, 22 Nov 2025 03:35:35 +0000 (UTC)
Date: Sat, 22 Nov 2025 11:35:31 +0800
From: Ming Lei <ming.lei@redhat.com>
To: zhangshida <starzhangzsd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org,
	zhangshida@kylinos.cn
Subject: Re: Fix potential data loss and corruption due to Incorrect BIO
 Chain Handling
Message-ID: <aSEvg8z9qxSwJmZn@fedora>
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121081748.1443507-1-zhangshida@kylinos.cn>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Fri, Nov 21, 2025 at 04:17:39PM +0800, zhangshida wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
> 
> Hello everyone,
> 
> We have recently encountered a severe data loss issue on kernel version 4.19,
> and we suspect the same underlying problem may exist in the latest kernel versions.
> 
> Environment:
> *   **Architecture:** arm64
> *   **Page Size:** 64KB
> *   **Filesystem:** XFS with a 4KB block size
> 
> Scenario:
> The issue occurs while running a MySQL instance where one thread appends data
> to a log file, and a separate thread concurrently reads that file to perform
> CRC checks on its contents.
> 
> Problem Description:
> Occasionally, the reading thread detects data corruption. Specifically, it finds
> that stale data has been exposed in the middle of the file.
> 
> We have captured four instances of this corruption in our production environment.
> In each case, we observed a distinct pattern:
>     The corruption starts at an offset that aligns with the beginning of an XFS extent.
>     The corruption ends at an offset that is aligned to the system's `PAGE_SIZE` (64KB in our case).
> 
> Corruption Instances:
> 1.  Start:`0x73be000`, **End:** `0x73c0000` (Length: 8KB)
> 2.  Start:`0x10791a000`, **End:** `0x107920000` (Length: 24KB)
> 3.  Start:`0x14535a000`, **End:** `0x145b70000` (Length: 8280KB)
> 4.  Start:`0x370d000`, **End:** `0x3710000` (Length: 12KB)
> 
> After analysis, we believe the root cause is in the handling of chained bios, specifically
> related to out-of-order io completion.
> 
> Consider a bio chain where `bi_remaining` is decremented as each bio in the chain completes.
> For example,
> if a chain consists of three bios (bio1 -> bio2 -> bio3) with
> bi_remaining count:
> 1->2->2

Right.

> if the bio completes in the reverse order, there will be a problem. 
> if bio 3 completes first, it will become:
> 1->2->1

Yes.

> then bio 2 completes:
> 1->1->0

No, it is supposed to be 1->1->1.

When bio 1 completes, it will become 0->0->0

bio3's `__bi_remaining` won't drop to zero until bio2's reaches
zero, and bio2 won't be done until bio1 is ended.

Please look at bio_endio():

void bio_endio(struct bio *bio)
{
again:
	if (!bio_remaining_done(bio))
		return;
	...
	if (bio->bi_end_io == bio_chain_endio) {
		bio = __bio_chain_endio(bio);
        goto again;
	}
	...
}


Thanks,
Ming

