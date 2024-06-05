Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C02E15350D;
	Wed,  5 Jun 2024 16:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717606593; cv=none; b=I9wLD2p51oEk2VTPt0fuk5IQDYWOuKSLp7ue6aqZNelWk12mdhHRlQIvU/3VW3fTd0R8h8DKT89JARkU1FCjYYHusncM+S41QDaWY5qQvnmNxFTPtXErjM+Mzbo3sESMd7uO5dcTd95L5zsp6W4Rs66p5XGdHvnh3BMA2BB9hoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717606593; c=relaxed/simple;
	bh=VIkUI+8noKmui9Dd8MhGalJEjmjpC3rRm8d4AOslBqM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aFsrBNDRoSEAffk/Zf3Axjp/pj42hbYicNYeZiXN8vlZYt1AwtaJNn0tBtsIoY+Cz7wEFUMcBi78SZ0yfja8VCPSAypUH1vpKVUVwMfgMGsGX1GFX3r09hOuObub7aIZkpU1pY7D+U84OxWVmdGFeRMxzasDvtk3NVJ05P7/DSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=CHNpTwuy; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="CHNpTwuy"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VvYWz0TttzlgMVV;
	Wed,  5 Jun 2024 16:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717606586; x=1720198587; bh=uMMIDLFYhjKDbpd2fVFvbQHY
	dZeC9BpYMZt3FtU3l/Y=; b=CHNpTwuyyQ2/Vw+IkJ0iRF/7h/7YGhNvMCg/32TL
	92IZfq8YZO3ziQ0am696c97F561j5gzc11NKsXCsB5/SpJWCe82ka68Bdl09oG0S
	+gjsmtrB7eqY03TqFxiIcnmZycxEp6K49t/dH85CZW8xs/RqXV1gf94TWBkNoJrj
	yWzw8Y68OKiqhXcP+fdZJtAB5VnR2GCHFhXCUvoXWlMux42NoEo955Is9AvAmT/M
	NabPbblfBkTnPxAvzLTNx5k0eudDF0SaB51zZMU3ZkxMbxwvcKeCTAFApma+xO0h
	T5/MqxPngZ6T31tuxqZ/5PYBaRmfwRpUe7J7nUEatzw/Qw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3f_26z_J4OVI; Wed,  5 Jun 2024 16:56:26 +0000 (UTC)
Received: from [192.168.132.235] (unknown [65.117.37.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VvYWp4Cw7zlgMVS;
	Wed,  5 Jun 2024 16:56:21 +0000 (UTC)
Message-ID: <3e49207a-1efc-4fe6-99c2-8cdd9c24664c@acm.org>
Date: Wed, 5 Jun 2024 10:56:20 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/12] block: move integrity information into queue_limits
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
 <20240605063031.3286655-13-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240605063031.3286655-13-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/5/24 00:28, Christoph Hellwig wrote:
>   	if (!dix && scsi_host_dix_capable(sdp->host, 0)) {
> -		dif = 0; dix = 1;
> +		dif = 0;
> +		dix = 1;
>   	}

Although the above change looks fine to me, it is unrelated to the
other changes in this patch?

Thanks,

Bart.

