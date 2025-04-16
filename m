Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AC8201006
	for <nvdimm@lists.linux.dev>; Wed, 16 Apr 2025 01:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744765453; cv=none; b=S45SfFci/wXTPre2O/x5g+Ipxqc++0+ZTSefbW5pArvotWNT4AE7p6B96qinhn0IHMMTwoQRLa/djXPQh5tlqIuLvOHkncz09rxFxHi+p7Hlzy+0zFOpF5mnB4ip0jU7A8uwvpcypYVhCa5KGzFuqdv+ZTGh03lJpME7DjWg6sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744765453; c=relaxed/simple;
	bh=tPIIDWCtvCMUi0dba5wS/vnKRpQYieJRvDzGuUpS2cE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a1yuAea4QevdJVNPnLjw3mTQiIWcljCf8VA8Am8JSFMQ/at/dr2PZm8O5Wu0A3+OZaD789jSY4b8xTzzfyFWYSMQryuqvY+ip9sHmWsE7MfndfTBPiEypfGyG6JLRWS20nKs62afdFbINd1P5x0OYJCfoyydxYnadKSNIxzZLrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dROq1Qzk; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dROq1Qzk"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-86117e5adb3so207121339f.2
        for <nvdimm@lists.linux.dev>; Tue, 15 Apr 2025 18:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744765451; x=1745370251; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YOzygePW3310tVx7kEfO3x/NC5w6EQLjdhpFeXqXF04=;
        b=dROq1QzkhNCLf27f+pRe5KU/HcPwVaxca/EDDJzi6A9BEURJhP0zWYuFSAMQMYehOv
         QPlXN9tYk1Y0Ud4eYzQTNHqqFkUySNIJhF2QMRLp3Rmbaab6NyM9/J2BcEOC69bbDvT1
         PpIuaNqdcnoX8i0eOqTL3ekweC1wMGNGdy9cl/gbTxlAu9eDoX7iLIfyMf/su0Y4CLoE
         deXt9dSWBUnDLQuFs1C5zoNNnD3J1vwInHOFmAppDKnRC/GRYGC69eu0fp8+6tiY62sa
         qFJQ1ICv8Q9Sik7BoczPDDEdA12uku4ryLc5rcIbQq1IGRGC6Xy0bs6XhpiZWWb3ojI4
         wwAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744765451; x=1745370251;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YOzygePW3310tVx7kEfO3x/NC5w6EQLjdhpFeXqXF04=;
        b=MwgXlkBsoOSnF4kESKXq19754cHbhlaGKu85jwnZsWgmH4JTz1b2fyrS3vXIHOBCMW
         JXCV27zodheqDb5/1UrdoGU2KH3jTfB+c6t8VTqpg6TYvJhrct0MjBm40gQrTRIB7Gnm
         Ui7EwizWWtdLGlMiHPN9qiX0WDf2UlH624oXNxjhHCQwgYuJzn3R3QAyv7X3ClqEKPvC
         HmeXVXTiALvPiCtcO8j5hzO1gySxscmonWBmTSNckk3zxPrXLFp/Cu5g/i1cuVX2sz8u
         3IDvDGAFGVcrygEkrcejw0wxPFYhSCpkE9+QPRoe1PXGfNJL5xD/TIJLmEnxXX7iOO9f
         0eRw==
X-Forwarded-Encrypted: i=1; AJvYcCXvd+ZrP/nBbyQ6iArBdG23f9ISFSOIzOmH5bntB2SWyvkSeoVxF1rUg4h3d4CG/8yR8UFKVrw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8tWkGZhYNRHxhpDaPLCe7g2v5wP3grzYDwHP5O5K5kd6OlxV9
	ODCtkyfefoHy/iRVKZBx9GnE2XnVJ1mBsVVCeoEnd9F66P81FJVeaiN+wnfp0v0=
X-Gm-Gg: ASbGnctn3Pekz4yeWvzCzzTFqBNcVRctTkYi1g8Qc5Nw6sPUyM7+6fuhlwZdjS/w6pE
	pBUs3IMULkdjEP9zZBhK1KmpvFEGUto02L2bIv0/O/qC+C2JutkRU3OiI45yvQfEHnaJLd/tY61
	ev/kgq+POYVEAcKjenU3FmJ4LDZ2v40UUeOQvxwD572qraF1KRlzO/e8vri/sxic6sPNkBrqdng
	Nz71gXq0G2zAj0YoJErMaw2zYHKU568QaT9Jcwqgf/WJk+ALk9OcRNATTB5d50XdZfJqvZYnepe
	SW4AVwyLZHgz/djEuR934n2X9thO5U4bVXCb6g==
X-Google-Smtp-Source: AGHT+IEHI5YXtsH3GtE+xAxjPnoEaxwITdOpITzfsT2ZontVDQfoJEe0M8gxlFjwjY706Hy1dO+lEg==
X-Received: by 2002:a05:6602:360f:b0:85e:8583:adc8 with SMTP id ca18e2360f4ac-861bfbbd3d6mr192307839f.3.1744765451183;
        Tue, 15 Apr 2025 18:04:11 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8616522cf6bsm275091139f.7.2025.04.15.18.04.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Apr 2025 18:04:10 -0700 (PDT)
Message-ID: <15e2151a-d788-48eb-8588-1d9a930c64dd@kernel.dk>
Date: Tue, 15 Apr 2025 19:04:09 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/11] pcache: Persistent Memory Cache for Block
 Devices
To: Dan Williams <dan.j.williams@intel.com>,
 Dongsheng Yang <dongsheng.yang@linux.dev>, hch@lst.de,
 gregory.price@memverge.com, John@groves.net, Jonathan.Cameron@huawei.com,
 bbhushan2@marvell.com, chaitanyak@nvidia.com, rdunlap@infradead.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, linux-bcache@vger.kernel.org,
 nvdimm@lists.linux.dev
References: <20250414014505.20477-1-dongsheng.yang@linux.dev>
 <67fe9ea2850bc_71fe294d8@dwillia2-xfh.jf.intel.com.notmuch>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <67fe9ea2850bc_71fe294d8@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/15/25 12:00 PM, Dan Williams wrote:
> Thanks for making the comparison chart. The immediate question this
> raises is why not add "multi-tree per backend", "log structured
> writeback", "readcache", and "CRC" support to dm-writecache?
> device-mapper is everywhere, has a long track record, and enhancing it
> immediately engages a community of folks in this space.

Strongly agree.

-- 
Jens Axboe
