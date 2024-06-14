Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2211A16FF3C
	for <nvdimm@lists.linux.dev>; Fri, 14 Jun 2024 16:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718382218; cv=none; b=tXf18Z+AhDfBDeKLNb+n8Lh4MMdezheoksn3qPDdk3TAKdisZSWQ7dDK68Uf7EX3THgyXnXzMRcIibtgpMjN/z8nuPQDJYnw0F6WXbRyzLc8dGIvcLDASmvDXGOEYyMkiIRiRAiOTm60sV41BQWJ3JQ2BwHr/yzdxJ/JE7NyhU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718382218; c=relaxed/simple;
	bh=WoWOHKjU+KL6TRZLfvPcBUOFt61J2dtVf/RZIND74SM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Qtc2QwY3TXOUMQMrFdaLG5kYrMDws9bFzstC9lvB+2IyXQG4Xxmpl2fnngSGaqxJ0ewRMAAdNYIrbA1PlP5pBgTfIxel8EW3uqCkr8Vbb8154O9zi/CdhAkCFqyIzGNDNsacakuQjf8w4rrHiMzj6v4dGlAGJO+KQdCaLBGFsMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Z4BkLuCs; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Z4BkLuCs"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2c1b39ba2afso400635a91.2
        for <nvdimm@lists.linux.dev>; Fri, 14 Jun 2024 09:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718382216; x=1718987016; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3I8EQqt1crG6Q0TuvnTQoOetYt/333GlTD0SUTj3N30=;
        b=Z4BkLuCsm+Tgg4sIz36uTnRkNlTmEQ7hsltMes4ovLn76DX6hJ2DRPhWyiC3bc9UFW
         8OvDRfaTWULS29oQNeBPFjsPu+YzjFdvYAx0M3384IJp/4Fcs0Dfdpbx9dEIiSgnvd24
         8T3fkvhM+wlavEcv2ilqj/P80f3U3hiG/Xi+BrqpPdX9ajA7Y60ht/TlZSYxOVmo1JQO
         kYSiM1ogsSj2nnrtNWAWrreMs1UnSd1EiQFv6lFidwGdyUOWZEh77GJPeWTV4IzWLqqm
         pH4nJKYLceKIJRh48bClxM79zTfEpEEFenPklPAXVOBd1FK4IrnQe2yBJ11CNJ6f03vp
         TOmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718382216; x=1718987016;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3I8EQqt1crG6Q0TuvnTQoOetYt/333GlTD0SUTj3N30=;
        b=jcfPHCxFVrj48bQjDSCWfLEbQ74kjfxEMuqG1ztKpj/dUcpmyimoL03vHajkJptbX7
         SsIWvi+9Zw5uMURPFBvc9GjXhaTLx7JW2PYY/RUAZKYKuqlUl7Fudm9vSkKBWFryTc1S
         I24Rpk4hgrAY0aOrrslO5mn1woTqxBB840diMq24M+iFbVcSfHp3cEOIltCJ7wD72YqA
         Us+mS9ZY08xCB5g2GmXxwQWJee0b/XWhLt+r6agbfh/wVzhH60VBoQiIr0DASlwRlrED
         7Qf3ZMfV0kJdCh5/Vl85lbuLecz+HB1cW/uw2rM+KJiNo5n1e3nu+Lg6tBexqKfZny+q
         1oqw==
X-Forwarded-Encrypted: i=1; AJvYcCVIpMm6JGKfjoraGo/v3d+RpLUSWsBvKUdjAF1RJuJpkunzDWar5vaQk1rLfCByLGZyq5/9CdM3EHJUAWVu/s1LKxnHuh+A
X-Gm-Message-State: AOJu0YzJJpGF6JksQAvcA8cK2KHkoM1I31g75EtDom9da0O1ztAePN1J
	MXrDrTi+Npkh/YV1xO1JTTY1t1ZW3CLosmDwfKrwjeXaJ38+d9BlZYFmC3B8z/8=
X-Google-Smtp-Source: AGHT+IESX47a6MjNSHBX1WWMmqXAUrRz04daSkbqzpNkyc1AvtEK1pUdz6iDmWheXtCqLaPD91gHzA==
X-Received: by 2002:a17:902:d511:b0:1f3:10e8:1e0 with SMTP id d9443c01a7336-1f8627f38bbmr33817845ad.2.1718382216194;
        Fri, 14 Jun 2024 09:23:36 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855f525fcsm33896755ad.294.2024.06.14.09.23.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 09:23:35 -0700 (PDT)
Message-ID: <2fb3fc18-64fb-4a12-9771-3685111fd19f@kernel.dk>
Date: Fri, 14 Jun 2024 10:23:33 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: move integrity settings to queue_limits v3
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20240613084839.1044015-1-hch@lst.de>
 <f134f09a-69df-4860-90a9-ec9ad97507b2@kernel.dk>
 <20240614160322.GA16649@lst.de>
 <af0144b5-315e-4af0-a1df-ec422f55e5be@kernel.dk>
 <20240614160708.GA17171@lst.de>
 <6c5d4295-098c-4dc2-8ad2-f747a205f689@kernel.dk>
Content-Language: en-US
In-Reply-To: <6c5d4295-098c-4dc2-8ad2-f747a205f689@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/14/24 10:16 AM, Jens Axboe wrote:
> On 6/14/24 10:07 AM, Christoph Hellwig wrote:
>> On Fri, Jun 14, 2024 at 10:04:28AM -0600, Jens Axboe wrote:
>>>> That sounds like you didn't apply the above mentioned
>>>> "convert the SCSI ULDs to the atomic queue limits API v2" series before?
>>>
>>> That might indeed explain it... Surprising it applied without.
>>
>> Also as mentioned a couple weeks ago and again earlier this week,
>> can we please have a shared branch for the SCSI tree to pull in for
>> the limits conversions (including the flags series I need to resend
>> next week) so that Martin can pull it in?
> 
> For some reason, lore is missing 12-14 of that series, which makes applying
> it a bit more difficult... But I can setup a for-6.11/block-limits branch
> off 6.10-rc3 and apply both series, then both scsi and block can pull that
> in.

Done, both series are in for-6.11/block-limits. It's pulled into the main
block branch as well, but SCSI can pull it too as needed.

-- 
Jens Axboe


