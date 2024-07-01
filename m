Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B8417BBB
	for <nvdimm@lists.linux.dev>; Mon,  1 Jul 2024 04:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719807882; cv=none; b=nYWGVZzhpM6duITHH8KMKbXTaU3qGuK75yN8gIg0fmXZsChftA7/WHfabJ/nIJktNohQiWeuaIgmTUQM8/u+2aZsz73+1Ca89I2ikBY2tAU2GzE6lIEjkZcaYjKeqxyYQ3xD1ybu8NBSzWeW9quf/t81kon/l/h3yroYlcyJERU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719807882; c=relaxed/simple;
	bh=paVAf+8j2Ao8wNZ6d9H4Go6mO+YeHszO+g9YMet+gN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dtBdSnh0AyZjxYAiIb6ISjmTr+md5bx/hEUSsB5/dvsJi78zZvPaTvp+ZdWah2/wuWuqLwf2dqZlxPaQRqotJWJXFOn3OKA8Lm1SOZRVo3pQHakWY78IEPA5ms1Ed2WyO2v2DekDNNmKnRx2myRL5ddOE6bxV0g+wVHHvE/JpKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=hwqy/BjS; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="hwqy/BjS"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1fa55dbf2e7so12238625ad.2
        for <nvdimm@lists.linux.dev>; Sun, 30 Jun 2024 21:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1719807880; x=1720412680; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q8FaXxeW49XxQjIVoOOnJuKPW6Isofg2ljkc7tdAOtU=;
        b=hwqy/BjSOZQlZkpx2esF/bkm1KeG1RoA7KLEOhqs4NlV7WN4rTos5fZObrfV9ZOs5b
         g04RP574pIjC7oMfmuqr4LC7XBlI5AdcnxZzRhQbpULMpn9HlfPL7g37TqugfGrZl9g1
         1H9dUzD7IVkro4TsYVwkOFhaJxO2KM6bQ5HGjIO9ToSrTGbx3o2HGof/MoSvMa4LghLD
         4akwW3Gprip6VSbWh5115c5IvqupG2tteW11MT2S29M3VTb65TG1PR5ODjmf/nZdXmRE
         N/rxH7D0wDi2guMDO7bGp6vChvr09bJAH+8hfTkW5PzbI+wlqFfJuUAyAkba/Rjclx3g
         3m8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719807880; x=1720412680;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q8FaXxeW49XxQjIVoOOnJuKPW6Isofg2ljkc7tdAOtU=;
        b=Dgz8aV5Yp9M2BT/BQqpoV1zewGzAUCQpy8+u9Z+90U2CD+d/HdEQwX0GOImTT6AMXo
         DillRyIxiYZj2+Q5ZLpQSV/xU7xZCKpT+z46mw4KlZWpOel6ipwAMuZKw9Dh/uFBHL0F
         ogfiG5AKhszrtJTO/V+1tH4/Lc4NyiM8BujDtNAuC6RAav8I/sNVGO2pKIXS1e84iXPr
         YamQqSLwJccgy+hO/Nn3p2iLF5lxeD7sTHayggy7mFizFxvK5vVpaQ+unj5UuJ1zRl+1
         PIU4yt2IyCEyKDUT1CyAPIyl1i92E06/7iCGGBKiN2g0OBX0s6yrdZZmMt+wJK719BUQ
         ipSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTjoJJ4QjBHXrayCLFfBQPUqmRDibBXQ22zRamXEf6080urNTioDU6afrsBoWMxITS1DZn5QC858kkero9Hd1NQyU++LUT
X-Gm-Message-State: AOJu0Yw7uBZJgIJjZsnw/gzSXeOjf/rYxsRlsFasbv55SDsQkiPuof6N
	7nKGHJo8QNan0VZuH4tJ9ZFeqRn5wEkoJ9his4G0XWDuWEmu940UNKz3qP5b5wQ=
X-Google-Smtp-Source: AGHT+IFKQ7mlIRHK3qLypxLI+wB6C/xuRboouR5zOv5/KrFwuLBxwDWk/1+R28Hzvt5tq0xC0UW+Zw==
X-Received: by 2002:a17:902:d2cc:b0:1fa:2d0:f85b with SMTP id d9443c01a7336-1fadbce9d59mr26040185ad.49.1719807879574;
        Sun, 30 Jun 2024 21:24:39 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fac1569051sm53926215ad.215.2024.06.30.21.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jun 2024 21:24:39 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sO8ai-00HWNB-2Q;
	Mon, 01 Jul 2024 14:24:36 +1000
Date: Mon, 1 Jul 2024 14:24:36 +1000
From: Dave Chinner <david@fromorbit.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, logang@deltatee.com, bhelgaas@google.com,
	jack@suse.cz, jgg@ziepe.ca, catalin.marinas@arm.com,
	will@kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
	dave.hansen@linux.intel.com, ira.weiny@intel.com,
	willy@infradead.org, djwong@kernel.org, tytso@mit.edu,
	linmiaohe@huawei.com, david@redhat.com, peterx@redhat.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	jhubbard@nvidia.com, hch@lst.de
Subject: Re: [PATCH 00/13] fs/dax: Fix FS DAX page reference counts
Message-ID: <ZoIvhDvzMCw28VBI@dread.disaster.area>
References: <cover.66009f59a7fe77320d413011386c3ae5c2ee82eb.1719386613.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.66009f59a7fe77320d413011386c3ae5c2ee82eb.1719386613.git-series.apopple@nvidia.com>

On Thu, Jun 27, 2024 at 10:54:15AM +1000, Alistair Popple wrote:
> FS DAX pages have always maintained their own page reference counts
> without following the normal rules for page reference counting. In
> particular pages are considered free when the refcount hits one rather
> than zero and refcounts are not added when mapping the page.
> 
> Tracking this requires special PTE bits (PTE_DEVMAP) and a secondary
> mechanism for allowing GUP to hold references on the page (see
> get_dev_pagemap). However there doesn't seem to be any reason why FS
> DAX pages need their own reference counting scheme.
> 
> By treating the refcounts on these pages the same way as normal pages
> we can remove a lot of special checks. In particular pXd_trans_huge()
> becomes the same as pXd_leaf(), although I haven't made that change
> here. It also frees up a valuable SW define PTE bit on architectures
> that have devmap PTE bits defined.
> 
> It also almost certainly allows further clean-up of the devmap managed
> functions, but I have left that as a future improvment.
> 
> This is an update to the original RFC rebased onto v6.10-rc5. Unlike
> the original RFC it passes the same number of ndctl test suite
> (https://github.com/pmem/ndctl) tests as my current development
> environment does without these patches.

I strongly suggest running fstests on pmem devices with '-o
dax=always' mount options to get much more comprehensive fsdax test
coverage. That exercises a lot of the weird mmap corner cases that
cause problems so it would be good to actually test that nothing new
got broken in FSDAX by this patchset.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
