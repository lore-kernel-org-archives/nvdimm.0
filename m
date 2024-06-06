Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E180B196431;
	Thu,  6 Jun 2024 15:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717688338; cv=none; b=mRTb3EcWSqGLdh9EyoVixT+1DEpi32fXlHb+47giSifQg5RpvYJ2YdX3yqqxfDctT2dhxHE1OZwLUOd+P7cvuxkDcolaL4v38cWM9GF7tPsjgTKxEGNWTGQz+U0FCy90ezwXo7+3lpI1R0XsyEd9bUZ0/c3Ry8d1KM5/dj5j+GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717688338; c=relaxed/simple;
	bh=0fqhwtTCMwg3nN0kbPbaQFo+LrZaFWCeNCebgPd87gw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jqusvW1N6Mvk/RJOaA4eNn9yolyPLdkPwX8eMxBZz0doNGTIUb6IwBFmA0UbLrKN5gUl+X3WwAJkCWOVwNjMnO/5/9i4BrHqLYz5guv7WBO3HtJ1WBR5F+5/SP02FFfdT5dLQ7mIGQJWk1n2PL42jD7rUKkJZxSg84Eps3SQxEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4vcq+ZeJ; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4vcq+ZeJ"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Vw7lt02qZz6Cnk9X;
	Thu,  6 Jun 2024 15:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717688322; x=1720280323; bh=maVyEw5qAJ9exIjeLqhPdHWd
	OFMAGD+uPnPP3rBtN3k=; b=4vcq+ZeJ2Tz8h7FvTWtkYye5ybBsQeKzH7LiB/h4
	RYBFunjMs54P5sT/WycS/guHMkgCJiCBlloYezqTZ7mr4FVcPxejYkxIFpmibeR4
	gNcRz8zWHzoBC0D/RNYq4CY9i+rCWkWp9HSvPl+aI/mGFgL3HEgyEyWWFY0FP7RT
	p4mDdyjMwbI/dAP+dOok6Euj9jCvqV3uWVKT/LC4nIMzdjWLziQV0jQRBqkROenn
	QBV7UL2/XVsMrQPtjqxzYzZ1APOdCg5KIjvDbKk6qP23vrMGcWMj4GMZHuvMCcMv
	TzcM9QPqn10RI6Vb3+k9KbjWoPv2Osa6VBpxuHAfjkFXBQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id w919G5Ov9keK; Thu,  6 Jun 2024 15:38:42 +0000 (UTC)
Received: from [172.20.24.239] (unknown [204.98.150.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Vw7lg5CCkz6Cnk9W;
	Thu,  6 Jun 2024 15:38:39 +0000 (UTC)
Message-ID: <2cbf3443-de1c-4bfc-a249-afd1a4e13211@acm.org>
Date: Thu, 6 Jun 2024 09:38:38 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/12] block: remove the blk_integrity_profile structure
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
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
 <fee6338e-4aae-456c-90a3-228a19fae58a@acm.org> <20240606045048.GC8395@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240606045048.GC8395@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/5/24 22:50, Christoph Hellwig wrote:
> On Wed, Jun 05, 2024 at 10:31:27AM -0600, Bart Van Assche wrote:
>>> +	case BLK_INTEGRITY_CSUM_CRC64:
>>> +		if (bi->flags & BLK_INTEGRITY_REF_TAG)
>>> +			return "EXT-DIF-TYPE1-CRC64";
>>> +		return "EXT-DIF-TYPE3-CRC64";
>>> +	default:
>>> +		return "nop";
>>> +	}
>>> +}
>>
>> Since bi->csum_type has an enumeration type, please leave out the "default:"
>> and move return "nop" outside the switch statement. This will make the
>> compiler issue a warning if a new enumeration label would be added without
>> updating the above switch statement. Otherwise this patch looks good to me.
> 
> For that to work you'd need to make csum_type the enum type and not an
> unsigned char, which would bloat the block limits.  You'd also need to
> keep the return "nop" where it is, but use the explicit case instead of
> the default.

Has it been considered to add __packed to the definition of enum
blk_integerity_checksum such that its size changes from 4 to 1 bytes and to
change "unsigned char csum_type" into  "enum blk_integerity csum_type"?

Thanks,

Bart.


