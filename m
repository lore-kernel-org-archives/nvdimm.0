Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAA53A27B;
	Tue, 11 Jun 2024 19:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718134301; cv=none; b=Zunz7PsGfYOlQs87DR/kM8umMuoxToUCSrphmOGuf1l/ktUKdYSDKnj95Y06hCcEYko6p+EWqdBXzs3CpeBAJ5dUYme4zWF6YFArd1Ck3MWJminH1hue/iNLfhHKHQOVF91pPlz3/+bRAcyMC2F+6DwoALR1ralGSYzzRN9v/jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718134301; c=relaxed/simple;
	bh=Cf7GcJGKcu7D5BiBoZvRx6x3LTfH72Sz+jyW+IP4PGw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NW2RSDwwy9vrVy/Xki8pDVC4T+q8uUnXL8xEs3X0j9uq6iMkjLkZ318pRHN0iEUidk+a/zH84R5fTw/jDQ7u+o/kjPb/SEE0lTaz0IdP3tyDJKdy980Rq//rdSUtrsu6P4GmJdOP8C2LSb9ctY32qom97wwPBs2gFAWTyH2ifS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=d+QkU/8V; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="d+QkU/8V"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VzJhC6RZtzlgMVP;
	Tue, 11 Jun 2024 19:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718134291; x=1720726292; bh=Cf7GcJGKcu7D5BiBoZvRx6x3
	LTfH72Sz+jyW+IP4PGw=; b=d+QkU/8VZ6Dq+WOkUNTA34lPXUILl3LVbu6kO4uj
	dRf9ZLceTOdlVMVrbZoxWEf4u5ywVZd7xmS7z7Qu9fGFq3c09JpTwe9Izw4JtWWY
	tHhkQiq7BjVQmgAeymktZWCjgXvLtR18TTk9AbAP5hLoxcQzO5YN29aNyMj+6U8N
	mnLgDc3DfcoUZU+HIpoj33PjIC9sY+avSJ5HN8s208j4yIUXD3pm8VAHyLZOImgN
	bjIvKsv7Fn1K4+4dykzuQT4iVGBagOEJKDZaAYW7tHizV3z3TzNCBZqR7MTEAs6D
	ikorZXLPiNhCfCU2hPtZjpFb2ahQxj4wO1mOgHFaYmHiNQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DQP8SoW0yS3G; Tue, 11 Jun 2024 19:31:31 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VzJgv1SgJzlgMVN;
	Tue, 11 Jun 2024 19:31:22 +0000 (UTC)
Message-ID: <8206c0cf-1787-4282-bcec-746d7c7f3880@acm.org>
Date: Tue, 11 Jun 2024 12:31:21 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/26] loop: fold loop_update_rotational into
 loop_reconfigure_limits
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
 Richard Weinberger <richard@nod.at>,
 Philipp Reisner <philipp.reisner@linbit.com>,
 Lars Ellenberg <lars.ellenberg@linbit.com>,
 =?UTF-8?Q?Christoph_B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Josef Bacik <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, Vineeth Vijayan <vneethv@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-m68k@lists.linux-m68k.org, linux-um@lists.infradead.org,
 drbd-dev@lists.linbit.com, nbd@other.debian.org,
 linuxppc-dev@lists.ozlabs.org, ceph-devel@vger.kernel.org,
 virtualization@lists.linux.dev, xen-devel@lists.xenproject.org,
 linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
 linux-mtd@lists.infradead.org, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20240611051929.513387-1-hch@lst.de>
 <20240611051929.513387-8-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240611051929.513387-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/10/24 10:19 PM, Christoph Hellwig wrote:
> This prepares for moving the rotational flag into the queue_limits and
> also fixes it for the case where the loop device is backed by a block
> device.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
