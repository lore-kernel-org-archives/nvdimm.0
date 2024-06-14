Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1201316B751
	for <nvdimm@lists.linux.dev>; Fri, 14 Jun 2024 16:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718381766; cv=none; b=cLTXtg6jXnWs1znkOyJtjdP7KGkvECvTKpqHSFcZKwHmJma1Vs9o4jGbXH9QjM8VrzVlwPxCL2r6fReO4leajqxOjAlI4hIUKnAw62KfZuA8NF0iXzxukJPA2eCVGqdY4rKmOgKVvmPo+ONv/i+Y5A1AsEMFOjSAFTFHV/rIBoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718381766; c=relaxed/simple;
	bh=Aad19hIjxSUfEbYh1/pSP2sHGv1iCwO+UAJvrB+cZ08=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BiUXIXLIrjLYBvF/mcgFp+bzTHGCAweMkb9BJsvfQczwM+zmLk6qmpopYliqR3i4Igs3Az2ZHQrYM0WYJkcQTe0lelhHc9eCedZw7u8WvVSm2AAKKSlru7AVqETKcE4bT9Hq2DI+9PgY5QOHYRSybCf6CB8NpMQt0yS+dxAyajI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nHzrOi7Z; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nHzrOi7Z"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7041a382663so73088b3a.2
        for <nvdimm@lists.linux.dev>; Fri, 14 Jun 2024 09:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718381764; x=1718986564; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BDixbra1HnV5DPgXv78teb+z8r3TOra1wJTUjH08YD4=;
        b=nHzrOi7Znmk2k7ROTSk9VaBOX02JdoWWJBm8V8gcBHuwyFTDQO9U1c2qbiGm8cY4Av
         bj48p6D2IqUCrWfZixaYrYGpEbNqnJgN3IiDnBH/CAML6DMNBsrbtkZ78dMXNht6Qeb/
         3FDkrAqijc730n4nJqWtJcbUuEHJ866qWNDVqZpWjzT0ZZJUDqQ33uhsI8T2FZLXMdIC
         bADrJUU+9eAYuHchVvuLWSBBXPI3Y/tOee/u4ADZGjLguk+9W8xBoqPSUmQw5z+Wm3qh
         6y/xSDwQopI3tOzpq29RBDJbfudAmjERuSMdsB+QkGUea4a+5+haNJQdieWBXS8vERPK
         JMeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718381764; x=1718986564;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BDixbra1HnV5DPgXv78teb+z8r3TOra1wJTUjH08YD4=;
        b=T2A4z+HTggMT5PWXcFdmH4gq2lO2MVW4V0E8UCBsvvk7xU6plM3OMfpWsTddNyVja+
         4wShX0vc+O7ixdEMYGNUhNMe2hgKOrwYRf1QTUPH5oqTFx1E3ZN1vSmQ4mEILKIfKy33
         kPFX6EHZKFIFM/XGv6i0vUtjkvUnEk/K7XJAWFgBFf0xYNjqLCUYLbgbZZAtwTHFkNrl
         +9KdFR1UTlCFtehShXbMiU2KD8Yps+xaawtjS6LjyoO7sa7H5GpuL8RIYo0Lh2nxcGlP
         nE+jYn9HJmIPup/OS5r51M8Ue9I9HcKCqJtb6/YT1hbR1MOZQSNWCE/25lg4OUWEYmdw
         x4nQ==
X-Forwarded-Encrypted: i=1; AJvYcCXE9piw39J87S7k7cPw/aSCGEHxf8FKQNUXjp7T/6Mn4R2N2c6t9RT/CwHN0CFqqQ7G1dQyhdJUYvXuC5vwFg3okbYl5qYU
X-Gm-Message-State: AOJu0Yx/SnArfUAdsmnqadgSxjUZsvJfjVT0t7Bpw2oMStXn5yOA6NRT
	gIQUxIAF1xIXO4amHeeJ/avcm3FGUQuTqFTzRPnujHznt6fkV/OuGtKkwbqxD7E=
X-Google-Smtp-Source: AGHT+IHcxyIgaaVTPfM4bd/lwoK3Ws05v5eakEhv+baleiJUj4MZMdoqwGuHfLvaj6ML51yAKT62Sg==
X-Received: by 2002:a05:6a21:6d98:b0:1b4:e10c:62bd with SMTP id adf61e73a8af0-1bae7ed3e48mr3699835637.2.1718381764289;
        Fri, 14 Jun 2024 09:16:04 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccb8d98bsm3224419b3a.191.2024.06.14.09.16.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 09:16:03 -0700 (PDT)
Message-ID: <6c5d4295-098c-4dc2-8ad2-f747a205f689@kernel.dk>
Date: Fri, 14 Jun 2024 10:16:01 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: move integrity settings to queue_limits v3
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240614160708.GA17171@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/14/24 10:07 AM, Christoph Hellwig wrote:
> On Fri, Jun 14, 2024 at 10:04:28AM -0600, Jens Axboe wrote:
>>> That sounds like you didn't apply the above mentioned
>>> "convert the SCSI ULDs to the atomic queue limits API v2" series before?
>>
>> That might indeed explain it... Surprising it applied without.
> 
> Also as mentioned a couple weeks ago and again earlier this week,
> can we please have a shared branch for the SCSI tree to pull in for
> the limits conversions (including the flags series I need to resend
> next week) so that Martin can pull it in?

For some reason, lore is missing 12-14 of that series, which makes applying
it a bit more difficult... But I can setup a for-6.11/block-limits branch
off 6.10-rc3 and apply both series, then both scsi and block can pull that
in.

-- 
Jens Axboe


