Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7F71527B5;
	Wed,  5 Jun 2024 16:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717604491; cv=none; b=I5D2Xu/Ed5pjbowk5vp+6S4FTC92UqVFnpupLU8gt6VEQrVeHA34HuBxWnMUjJymQGyuQI2o1yPAXSfN+vTghjQJGfXtX9EqduhiR9YqrlzPWNglVPggDu9VsZQanHODzya+RoRL64XSHqMW7SEGqGRj+IPn8v7bQloTqrnKMfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717604491; c=relaxed/simple;
	bh=AeMpN3/HkoGEKgWkazauMmOVV7MorD6M70jE/QLwyw0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D18OT5oI4J7QmeWgIyxMxgfbwnI52AphFv+bApV/ckes3wlkb8Nwsf2Wz6esYUVT/Pf/5EvM8pF7S9yHpMtyE657bNvzOxywn2IYQfuW4Gk2bjB7qBCiCgEP2NhgR3e6aOghgPJfYqcxL9tztkjA+1pxENtEB8eVI25yMRQslzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rPUEUzoZ; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rPUEUzoZ"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VvXlY2Rxnz6Cnv3g;
	Wed,  5 Jun 2024 16:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717604483; x=1720196484; bh=AeMpN3/HkoGEKgWkazauMmOV
	V7MorD6M70jE/QLwyw0=; b=rPUEUzoZ8+KtwYmYeN7KvwPdY7EOKVynTJK+fuWF
	LaoU5ckjwgRby7kkTKgtKGUiYtVXK9rzxp6GB511AEqNulgxggxdZMkeTTwYWWMx
	s2kwIsnrH87QkEJ+c61r1M955VRxUd5y2xd0Es7OHNE4aQqofgTswIyrpXr2lPsW
	YCBC0snf+ZTwbKYZ6Nx+Swm7H0hiRiOswF6eJPfxPJ9dz/NhAa+A5SOn5VOz7Nc6
	GMmdcIhYn9MUJxRjiLNBiLczbPgsvE3xc8+Q+HJys0PH0GG2UCiWUKmHGmsh2M6I
	FG0Uc9LLYrF0wAMHTKzSNfedf63LMKcqNRtvJHe9pcgUdQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LdQe7KTkFscU; Wed,  5 Jun 2024 16:21:23 +0000 (UTC)
Received: from [192.168.132.235] (unknown [65.117.37.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VvXlM2TnXz6Cnv3Q;
	Wed,  5 Jun 2024 16:21:19 +0000 (UTC)
Message-ID: <2a4ce522-bdc0-41b9-b601-6e001719121b@acm.org>
Date: Wed, 5 Jun 2024 10:21:17 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/12] block: remove the BIP_IP_CHECKSUM flag
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20240605063031.3286655-1-hch@lst.de>
 <20240605063031.3286655-4-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240605063031.3286655-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/5/24 00:28, Christoph Hellwig wrote:
> Remove the BIP_IP_CHECKSUM as sd can just look at the per-disk
> checksum type instead.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
