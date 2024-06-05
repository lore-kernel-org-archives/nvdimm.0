Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80AF188CDE;
	Wed,  5 Jun 2024 16:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717604176; cv=none; b=hO+2ZD25K9gTN0s90kYhrYTwexA7TZmqltwwt8TBtR9ErznSXmO1gA13GV2iJX7LKk5S3BwmjiNExKtrKRlZCUJ6r5ST8wakA9kzbzejMg8NoOXPHfo4lkHjpqfIoFI4sCJLuRwc90Ve7aJHqKDTDFZdisumqyjmAE0JoZ8B4no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717604176; c=relaxed/simple;
	bh=rbeMU3HXyh3KgvxlW1b0chGKtCCVDfkoycQDGmv9s9Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i5yrTXkHN/jmyTdVk7pRf7y+dcZbviDFjG4GqRIWx6nQHBs0c3sqAdXrBa+h7NHanP/jvZxTMNlcOQD5oObFQ2TOlosKlg4WhJnrF4Qe0XlzpwTchiv/0k4ZDDiLvXZvoU6eMjD1u4Cdsf1oQKYZPWoM5ISDSnM826YXaoIOolY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=B1G+9Q4r; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="B1G+9Q4r"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VvXdV0zfRzlgMVV;
	Wed,  5 Jun 2024 16:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717604169; x=1720196170; bh=rbeMU3HXyh3KgvxlW1b0chGK
	tCCVDfkoycQDGmv9s9Q=; b=B1G+9Q4rI3c7YMkVyZKJdrogq5ItO3Khy4C+pnto
	5ieTc77UgyBluAbOyoPxkuZKvMw+AhgVksavepsbUGSHMAIkDrBrnu0oEsEulHF2
	X3E+8NtQEH1xWdL0EIFg0hYp6oubnCPIKKtmI2ROjXa8FS1kYtjVW/3DBmi/6cmp
	wO6E/ldd/jvisjCD5r3Dw9MM3SX6EZoH2CFJqmNKHuYQtzUS/1iOAzgZl5aqSuMB
	006MiAZo2nC5eTSldFvzB54+DmJcvZyOmilAjEpsWuoMRIAYHwlcOEWh2T01uUyg
	15b+Ir2Fs3K5vtzJOtIie7akvVS8mfhGgjf/MBxhfZMnbQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id aL7ltNKIChlW; Wed,  5 Jun 2024 16:16:09 +0000 (UTC)
Received: from [192.168.132.235] (unknown [65.117.37.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VvXdK1zbMzlgMVS;
	Wed,  5 Jun 2024 16:16:04 +0000 (UTC)
Message-ID: <c717ce88-9c3d-4992-a24b-8f6c9db4fbed@acm.org>
Date: Wed, 5 Jun 2024 10:16:03 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/12] block: remove the unused BIP_{CTRL,DISK}_NOCHECK
 flags
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
 <20240605063031.3286655-3-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240605063031.3286655-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/5/24 00:28, Christoph Hellwig wrote:
> Both flags are only checked, but never set.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
