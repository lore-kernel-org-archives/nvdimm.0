Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4C313C823;
	Wed,  5 Jun 2024 16:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717605101; cv=none; b=ASDpneIfuU4KS/CazrY7Pka0tiRf8ZBMcbPG1BiOslXQPQz6PvOdETyNFnVQoHrXgZB8Ag9no5I9AFNLURx6fWY4j15wzYrS7KwD1HfhvXXS0r2iEwlMnpA88lUrydWBBHmZiO3NMXIEjqEyAc6p22TAUx3z4dFj98F/xq7fg0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717605101; c=relaxed/simple;
	bh=d1x30E5sbOdIGXnUdKxs2ZCHj77Xti59ap6262PTeIo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uIr/lsXRkg68+CnSRknut8nAAifHDcT+axmXygNvKXvI1bUW8PBd74+z7mqmwWv9lidm8mR4DBR2EQ2rx6/NQ/q10SAa33bIFakynH5UIyyllRmF1tlhxTpTZZrUldpEfA5sjmw+X1EHnmSxMN0qiJsCYcA3GpSYyi4kXPR6igg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rR5gUlWJ; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rR5gUlWJ"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VvXzH3qxqzlgMVV;
	Wed,  5 Jun 2024 16:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717605093; x=1720197094; bh=xLeXGXOESgYIgwE71qSal5CB
	He6oz9PwFy8FG1a1Dpc=; b=rR5gUlWJQFipRCu76uDVoIk2bggN8nR17hl64A5z
	PpccWJOwEIvZ8Ex+LUw0PcKsrXqqF3M5efiqI3Q2rtmvaaAQyxL9+k9KTE5fcyQB
	d/LVhRYVtcZ1XQu8EFtRrzgfi0IlbTRmp8NLyPzNA2d8V5XuFMFGvZV0SY6X9PgD
	QBPVDj6K5GX7b//Ykz87l7X7G08OU7+voZeKAlmCsrKfxX41liJ8NQEIHHoA/5ku
	cPm5cm2FqpuuEz+D1ZkHQV579m3Nn2KfTEcumkXC89P57yvfR3QgY0sDMwF2UiyZ
	8Qd2aPSw6Ogn8SR39nfaxGIKkeBeMh34qT0wzi8F/AYq0g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QGnqC7xNcTmT; Wed,  5 Jun 2024 16:31:33 +0000 (UTC)
Received: from [192.168.132.235] (unknown [65.117.37.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VvXz51lmjzlgMVS;
	Wed,  5 Jun 2024 16:31:28 +0000 (UTC)
Message-ID: <fee6338e-4aae-456c-90a3-228a19fae58a@acm.org>
Date: Wed, 5 Jun 2024 10:31:27 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/12] block: remove the blk_integrity_profile structure
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
 <20240605063031.3286655-5-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240605063031.3286655-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/5/24 00:28, Christoph Hellwig wrote:
> +const char *blk_integrity_profile_name(struct blk_integrity *bi)
> +{
> +	switch (bi->csum_type) {
> +	case BLK_INTEGRITY_CSUM_IP:
> +		if (bi->flags & BLK_INTEGRITY_REF_TAG)
> +			return "T10-DIF-TYPE1-IP";
> +		return "T10-DIF-TYPE3-IP";
> +	case BLK_INTEGRITY_CSUM_CRC:
> +		if (bi->flags & BLK_INTEGRITY_REF_TAG)
> +			return "T10-DIF-TYPE1-CRC";
> +		return "T10-DIF-TYPE3-CRC";
> +	case BLK_INTEGRITY_CSUM_CRC64:
> +		if (bi->flags & BLK_INTEGRITY_REF_TAG)
> +			return "EXT-DIF-TYPE1-CRC64";
> +		return "EXT-DIF-TYPE3-CRC64";
> +	default:
> +		return "nop";
> +	}
> +}

Since bi->csum_type has an enumeration type, please leave out the "default:"
and move return "nop" outside the switch statement. This will make the
compiler issue a warning if a new enumeration label would be added without
updating the above switch statement. Otherwise this patch looks good to me.

Thanks,

Bart.

