Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1D32C6AA
	for <nvdimm@lists.linux.dev>; Mon, 19 Feb 2024 12:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708344288; cv=none; b=aF0NTguPwFAQFdbGLlk39ynEQUJz8MqmFsdrP0icCAqh42fejGRFN+r0FcJ6gXuksqGXKVwTncpUV2KfxX5+ShOoj3W8kmsINU+iaaW3ekgSqwnaDnqqpvmkMPeLijGNqHXc9s9lv7E2xtI7MzDCaxcPaQz5iW4bF5CDxgPIUR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708344288; c=relaxed/simple;
	bh=zDbj09vXhQ9a99MHLCKO+w+Rwn+2vxV620SpE5+aZl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ivI8o/Nnd/PVp3MeitT8QU1oGMuccHStKHRPOD/UMWasWcwQa7wnoNNK9pFm/CXPQyRtL1VnCQyUxwHRiXd6ayeo6xN3VxkEdfS7xE+QBafZYfIx91qX138HqkRMJByDR9AzKFGegYTxwZ8ZwXeF40M0dqcdrQdRm7G0GZxcjpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=jmLb9bxr; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jmLb9bxr"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5d3912c9a83so3142161a12.3
        for <nvdimm@lists.linux.dev>; Mon, 19 Feb 2024 04:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708344286; x=1708949086; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UD0Q+YuM0aYncw1zT/Ixj8YCSgfiS1s5vMLj9q2v0Ag=;
        b=jmLb9bxrRNpL4upcKC/2wskOhhtI+tItNusSFzNh7zU62MixDxXjv+Rgupa4D69Fw3
         cyU4QyIJSl5UhWiYXu0Z/qDoKbcC2tyvEyMtWCvmku3OYG7D3LIOx+t7E0pdlIEU3Wwg
         fnu/mGJW4TpYBAJPOhQCPQHajtI5fIz9pDwyE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708344286; x=1708949086;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UD0Q+YuM0aYncw1zT/Ixj8YCSgfiS1s5vMLj9q2v0Ag=;
        b=O18ygKGHh0jycVKEm1cc4YYk0AyIudFeeQWfh63+gGy13aFvx6FfvY2W1I4futdj+v
         SnsgZKLXpQ7GwGsa6jr2TQJTGBRxXkCNRrsOSB9xNCkHVSKq+XpxY7pDPvwoe5hhkpsn
         wQe4v+4qkocCy2/P6mohzqeF41Ny33jn73hC1RSVI7ztQzercCQ63HmSBSKpPQe0m3vb
         paxa55+MnbVTAfWsJvtwlvOBPdudmwO1Lw8dTYeZieHYG7HoEflxgVt1XeyfGlJOSlSw
         ntxNiBwkAoti7HcvkMl9mgOLVWWGHWn7ah43IuhmtPUFPbjqQKurU9TO3FwH6pFU9iVj
         y9OQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFLLqnRWpfDfb6x6WtTpBbkTn98bFdiNp/ITfqJQBR9F5Qn88P4It0+MvHwKA+5WSf7wp19BCuTGvpei2ZW+qAqudzAkMj
X-Gm-Message-State: AOJu0YzndGKSEp6nTezD5C7NCI26R/mu5S31ZHyNroYZchprs+HSfMCk
	qtvowoNKkRwECea31yvQ4+e88Al19ynwzxOn/AEo8JxJiR2+7TqiNG2t3Sz2Yw==
X-Google-Smtp-Source: AGHT+IGI3q8seWzsit4w49RmDdpR7qXA23sSQ+6AKRh25Sx/UF2Jg2gSUuWiILezaNCe3BsJyRg1Qg==
X-Received: by 2002:a17:90b:607:b0:299:69c9:da3b with SMTP id gb7-20020a17090b060700b0029969c9da3bmr2641050pjb.38.1708344286161;
        Mon, 19 Feb 2024 04:04:46 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:8998:e92c:64ca:f09f])
        by smtp.gmail.com with ESMTPSA id sl14-20020a17090b2e0e00b00296d9c4d5f0sm5125314pjb.10.2024.02.19.04.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 04:04:45 -0800 (PST)
Date: Mon, 19 Feb 2024 21:04:40 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Geert Uytterhoeven <geert@linux-m68k.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Coly Li <colyli@suse.de>, Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	linux-m68k@lists.linux-m68k.org, linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-block@vger.kernel.org
Subject: Re: [PATCH 5/9] zram: pass queue_limits to blk_mq_alloc_disk
Message-ID: <20240219120440.GA11472@google.com>
References: <20240215071055.2201424-1-hch@lst.de>
 <20240215071055.2201424-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240215071055.2201424-6-hch@lst.de>

On (24/02/15 08:10), Christoph Hellwig wrote:
> 
> Pass the queue limits directly to blk_alloc_disk instead of setting them
> one at a time.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
