Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9486C332916
	for <nvdimm@lists.linux.dev>; Thu,  9 Jul 2026 15:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783609625; cv=none; b=PM6fX02VmZvlhfXeoyx7q5Puxepr/G2LZ/bRzMDm4d1ZZvRUP4kCFgMd9fsxoQ6QVtTAB3u5NXkZ/P3byJ82roDlyoGhQc9zINuA2YnoG+/qeP+xApZrwqiOvwL0OSPRJiPTnIG+HN7Z8LUN2/NebnKc8Cu+/5IH3qdEAJqQ0UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783609625; c=relaxed/simple;
	bh=/grVSRUciXotV+M5DyGJv/gSDKzJoMKn2myJZvg9YgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RR2HJSmmvWnPuS2+7pBTGBzbCGls25S86N2WQyPyTeEA3b6Cu0heotlIrGJv/5HpyF3GkG8jAaofGnpxYMMsY/AZoYN5nCcRGhUtR7yRbENSADzHN9b9x5hQv+vlP5WF2tuPEFm1VXJHsOZsX9mTSb1XaD/++Va2qOX66PKCLxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=LoNAug54; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="LoNAug54"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c0c68aa31so13653361cf.3
        for <nvdimm@lists.linux.dev>; Thu, 09 Jul 2026 08:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783609622; x=1784214422; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LA4FqejTaFf1jVYUF/eNvlLLZJZ5tRpTNigHNeOPvho=;
        b=LoNAug54s3EDQ7tQWy68+iiS3XxKg67F/zfPIIuZcT+vINArZIq+jQP97sTDFtejDK
         rZmgpMBninANbZM9XSFUJvp6c6BMFBazpo1lXUuguh7cKQ6z5KLacDuKyB9CcY5tqVTh
         uQ9ePu+8OKaulsNmXgVSborKYUtqCUUNj27I5OGmM4jb3IxflNCg4GP0KVQXiE/jRDLe
         hqRP8UuBkXoW4z8cusGvZaD9Osu0jt4erxE8iQ94vxhcwmYY3fL96d7p7zn5oVN7fELf
         w/QThz0BalW/xD6iWkBTracO5myIaLZqCdEPH9RyL2ltnTnUBlTJZYhE39DhY+BxJLT7
         g8Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783609622; x=1784214422;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LA4FqejTaFf1jVYUF/eNvlLLZJZ5tRpTNigHNeOPvho=;
        b=g5nIlRq+zNvHrW4EILiKCxNz+dGcRL30/b52RONGim/5oVWJV2KoJs5j+aihIMCAbi
         3gzSEJjaQ4dpS6gOwCtKAE5A1w7NG5UBZmJx/NVRgMcy/GpAmG6Fbgt5qVU4ULxVgPdO
         blKH5KPMGejg0s4yMuvainGrPxxzuMOCwciWV3HIrVwgehgZYqmYA3pvYZFkgMhB5/X/
         xcVvsL1dhcUjrTTURu6VL6/VcZdi6+Krl1BEyee+wiCw/XKkHJJXfTR8nVVCC9oCewgS
         43/hIMKsWIIR/z6HNXNE6R1DiJOEV9BNxZywNpIQiNUtUupYHoGMRRyCqUa+ID9Vr1aB
         +QPQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr8v9ZQ5NJ7FnmSFx14TFJ6AV12VX+7SKkFNgW11bjxGnbkU4WXA7G2Qjxpq5mIfXM9l29gpL4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxC+ixGXECno8eW1cyp+ir1WwbDpEFojYXWajAjkBclB7p85vJj
	YmJJ3b5CTt3WdUhNqvXz26icD5vp0BusuwSIMUwJKDaWlDLkSRf5V304xOklqDrmp/w=
X-Gm-Gg: AfdE7ckiqXUQSOjse/pKHr3er9L/IbMspQCLWoCoZdbOrYToqgwzrFSZ96iWdqMZzrF
	YP8uVCGbn6h9AZWvn8NDC+fXO/j0EN51LptTFm4qHlFy7vA9t/Q+KnJf2BdGCZnQ4PvaapLFliU
	MFnDyqUMBMfCtAT96F0fArqGUQLdk7FPmR3N3uSsmszUdxD4gZEp2T5YQVqgDz/rDapCZXxZQyY
	iNEjfjeaytD960jc2uG/afFGMzZWZqzFrJlTXDOhNwOx/Tvq4hWC+CyF9Bo/XQSjCCLQPz8TB0E
	GEgtGDVv3PXm6kEh0ZKgaHuCbDk0/AYpe+ZW5/xjbWsWdXQ85RrGulVFmalj2CdJLTaEuT8E2u/
	dvZyGk/BLnvPA8P6qRJblvgxN59AKVc/rtLpQGTyetwwlWSd9FOT+HUxxeiaegfmU4gL0p2lC95
	jalTY0RmNsrfBq4srNe/4+SNB6NuGhSgfYnEMYwLNJDJvey0fjuqPrrfYdRzjNTL9oDDWhg4fCz
	bBVCGg=
X-Received: by 2002:a05:622a:1791:b0:51c:7b12:5fee with SMTP id d75a77b69052e-51c8b40f651mr77711651cf.74.1783609622533;
        Thu, 09 Jul 2026 08:07:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51c42038c4bsm160321251cf.31.2026.07.09.08.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:07:02 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:06:57 -0400
From: Gregory Price <gourry@gourry.net>
To: Richard Cheng <icheng@nvidia.com>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
Subject: Re: [PATCH v6 06/10] mm/memory_hotplug: add
 offline_and_remove_memory_ranges()
Message-ID: <ak-5EXwL56O3G_J_@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-7-gourry@gourry.net>
 <ak9ee95F7pJpCKMo@MWDK4CY14F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak9ee95F7pJpCKMo@MWDK4CY14F>

On Thu, Jul 09, 2026 at 04:45:51PM +0800, Richard Cheng wrote:
> On Tue, Jun 30, 2026 at 05:18:38PM +0800, Gregory Price wrote:
> > +/**
> > + * offline_and_remove_memory_ranges - offline and remove multiple memory ranges
> > + * @ranges: array of physical address ranges to offline and remove
> > + * @nr_ranges: number of entries in @ranges
> > + *
> > + * Offline and remove several memory ranges as one operation, serialized
> > + * against other hotplug operations by a single lock_device_hotplug().
> > + *
> > + * This offlines all ranges before removing any of them.  If offlining any
> > + * range fails, the entire process is reverted and nothing is removed.
> > + * This provides a fully atomic semantic for unplugging an entire device.
> > + *
> > + * Each range must be memory-block aligned in start and size.
> > + *
> > + * Return: 0 on success, negative errno otherwise.  On failure no range has
> > + * been removed.
> > + */
> 
> I think this can return 1, and it shouldn't.
> device_offline() returns 1 when a block is already offline, and phase 1 passes that value through as-is.
> 
> Easy to hit with patch 0, offline one memory block via memoryN/state, then write
> "unplugged" to daxX.Y/state. The store returns 1, userspace treats it as a partial write of 1 byte,
> and retries the write with the rest of the string.
> 
> Maybe
> """
> if (rc > 0)
>     rc = -EBUSY;
> """

Oh weird, I thought I'd solved this problem at some point.  I must have
botched a rebase or something.  Good catch.

I'd originaly had some tests that race memoryN/state and dax/state, but
I dropped them because it caused long testing cycles (mostly because i
was testing force unplugging).  Maybe I'll re-introduce some of these
partial tests and just avoid the destructive ones.

~Gregory
