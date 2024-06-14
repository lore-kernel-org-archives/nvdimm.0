Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18C5199247
	for <nvdimm@lists.linux.dev>; Fri, 14 Jun 2024 12:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718368426; cv=none; b=bY735z0caBFv0ZVPYDDejYe90Id6fcjimOSWPcW1f7xBmKFGtCVomLZQzC2lcN3Do1Dz4zW5Wgn03XD3yLMmApS+nJ2bNmVbkM6LQ5BuG07hKkdsIAxNE2yBXj2RWJOfG+K9zFMOxYBSDwcb+kfuExuMeyDjKBtG/GZFkxcSx3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718368426; c=relaxed/simple;
	bh=ViOeFSLpzBTfbhkwvbIOhDLgIujUpX169FCRqiXsZHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=goxGfTokzx522qhLAl6uH5u0TiSzDIgs1osJl1KGgQdfHGaFlai6w310PGGWyCP8Bj7WAzqZowi4AnWybqrCJ4K7HVoVa0de5g9huuSurQJf9Mg7crVK4pPKBrwc/3FtZEB7bVnPlGQc1qnl8+P4G9TsnWdGSXMVXwDyAdhSq/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XswhQA7A; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XswhQA7A"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1f6f23e9377so1830425ad.3
        for <nvdimm@lists.linux.dev>; Fri, 14 Jun 2024 05:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718368424; x=1718973224; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IQUOxKnD6CsmHDQ8zwTblKdKo9rITBkMiMcIVKNHWq0=;
        b=XswhQA7AttfblfMay/LRpJlrq3CZqN/QpWAxdU+KEV2wybKtsimuS7tlrYa4+x9GOP
         P0RiNKfDVqs0GWK8QPY1aD6suPws0OP8bQ3mPbtGOYVwFVewcYSxfgHjPhbTzKNJ+eeR
         3xXq8JrOkudGL9lhyfcGPBaCbR6OaqePx59Q6VPvnbi0Bpv/l1kaPG2qVM+dnUoWzrUA
         crdDNg0OOrQ2yfGOwq3fOT07ouR/0mNLyi7YZ1ETNzN17V8Il5FK9ru9nUTzzJJZhbT/
         v0O60MNX36VnJ5wjkAq2k72O7xk/oO8hXIzIDdR3jv0wWM+PgwdfweDMB0O2YdCtxoej
         M0Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718368424; x=1718973224;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IQUOxKnD6CsmHDQ8zwTblKdKo9rITBkMiMcIVKNHWq0=;
        b=uoFnXGdi7DUm9qL2ifRMrLtRGOGcKjv51bunKruuUxytHH90bPB9cBh+24mVOEtxk4
         82mJhDGAAM1ldycPl4m5LfFpAwpie5kz6nIgosPQQ/COiSnMh0qR1+0Gtr1kdQQK3Mzr
         g2snAhsjyaTPBYdPWUmgS8TeVKyq1OCauSfBYkVOebT35AAAf065hERfmrUytwPo0HBv
         Y7Nxy9A5gXAKkMQE2sxyABrY4jfJ1gl/ut0Z3mk+882MTwHUEmCpxomlowMk2I1YK+4C
         8ZK726ou713aWZDI0J42+CZ4SXFrOJTWx/WpXSOr7uz1pY7t46gREitsovuoR/JasM+2
         Mm+g==
X-Forwarded-Encrypted: i=1; AJvYcCU1GFreL6ZQnJAF9D8IbG0145obCVl7re5IsCExpSg33YMIU2nm3sxHmLG+ysZ3WHNAdGRc118THnqc0fKBuzs0Tjn7ZiNb
X-Gm-Message-State: AOJu0Yw+K5p9xaq51sghsCvwzQFBIEf/dsk79+s/bxAyoCAHf695RNL2
	iKmy1uAzTRli42/A0WC6JyGLYx9KP750rXErNl35saDGx5i6lL50thaZW1LUJHk=
X-Google-Smtp-Source: AGHT+IFgr4iSfGSF5IPV3zZl5qFPlqcnaulUtE1TfAC51U6Q4NBcINjOTwVkZv2IxHULMCAp2GZWSA==
X-Received: by 2002:a17:902:eccc:b0:1f7:1a37:d0b5 with SMTP id d9443c01a7336-1f862c30f6amr26779945ad.4.1718368424251;
        Fri, 14 Jun 2024 05:33:44 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855e55c3bsm31084685ad.57.2024.06.14.05.33.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 05:33:43 -0700 (PDT)
Message-ID: <f134f09a-69df-4860-90a9-ec9ad97507b2@kernel.dk>
Date: Fri, 14 Jun 2024 06:33:41 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: move integrity settings to queue_limits v3
To: Christoph Hellwig <hch@lst.de>,
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
References: <20240613084839.1044015-1-hch@lst.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240613084839.1044015-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 6/13/24 2:48 AM, Christoph Hellwig wrote:
> Hi Jens, hi Martin,
> 
> this series converts the blk-integrity settings to sit in the queue
> limits and be updated through the atomic queue limits API.
> 
> I've mostly tested this with nvme, scsi is only covered by simple
> scsi_debug based tests.
> 
> For MD I found an pre-existing error handling bug when combining PI
> capable devices with not PI capable devices.  The fix was posted here
> (and is included in the git branch below):
> 
>    https://lore.kernel.org/linux-raid/20240604172607.3185916-1-hch@lst.de/
> 
> For dm-integrity my testing showed that even the baseline fails to create
> the luks-based dm-crypto with dm-integrity backing for the authentication
> data.  As the failure is non-fatal I've not addressed it here.
> 
> Note that the support for native metadata in dm-crypt by Mikulas will
> need a rebase on top of this, but as it already requires another
> block layer patch and the changes in this series will simplify it a bit
> I hope that is ok.
> 
> The series is based on top of my previously sent "convert the SCSI ULDs
> to the atomic queue limits API v2" API.

I was going to queue this up, but:

drivers/scsi/sd.c: In function ‘sd_revalidate_disk’:
drivers/scsi/sd.c:3658:45: error: ‘lim’ undeclared (first use in this function)
 3658 |                 sd_config_protection(sdkp, &lim);
      |                                             ^~~
drivers/scsi/sd.c:3658:45: note: each undeclared identifier is reported only once for each function it appears in

-- 
Jens Axboe

