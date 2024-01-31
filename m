Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91C4E572
	for <nvdimm@lists.linux.dev>; Wed, 31 Jan 2024 02:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706668694; cv=none; b=thBd5q5zUp0cULMBo8Lk1EVeNj70Fww3mdA460MeTBjrV3W6jjH0zKyjZr0zxqiO1YvqDLU8wm48Z4S5fmYvjuBZdvH3vzwgyAJys2LfSSkojbGZFXgwdI6OrKMzfaNn/nJrD6qP/MGXcG6Og52jucyGnVMQP01cxIHHAR5F3pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706668694; c=relaxed/simple;
	bh=21EOOfDX3QJoscC3qTFj1I2tpuBsaPAwtHgQo7BYlrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LLPtD9uGBvjE5kdB9tFs4PzUZWbHO3iyEhe10nQzc3qZDKCSFuOf9IJ4ROXGVHFxjDiDYmjXkQfioZ0Nr53lKd/692zG4nmqTBC84vA+IGExclizJYHLHtrPrzYFwrKivJKgfxtOKaOtw9TAFoTlB9eqNqLMoFjRXLX13ddPWJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=l8Ep0BTo; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="l8Ep0BTo"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5ceb3fe708eso2887529a12.3
        for <nvdimm@lists.linux.dev>; Tue, 30 Jan 2024 18:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1706668692; x=1707273492; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N09f6sJYKv0DgOi8MMLVMh039rU6+gfv4wN0Iyy6R6U=;
        b=l8Ep0BToFEkloKV3CB1AeDQzycaxsjuQJ32BHwd03nlPooDgn3LhckywZJHwwf/D6z
         gHWDwkSBi8yixQJ2gnJqi5Q1I4mZeWKXAkKFEdaRpanO98/4UGJ+SiaYtH6T2pDQRwp/
         /QQiXafuZZlbOWaSdTCarVkd50VA8EHYSsVzmAoEY4AXQ9HM9/BGKqPXlIhMx4zT5dzI
         v562VmTVnJWYpvgNe3LWbtvJm4U/a/A4b8rsTLcoFb+IjvUqSzp29WY6QQrE/j/rpDXB
         l1pslt+QiN9w5rN90Cdl1vtDth2CGd9Ar3ZpV40AH6dR4uHjVDYEAa30KKovby9i7e44
         s+Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706668692; x=1707273492;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N09f6sJYKv0DgOi8MMLVMh039rU6+gfv4wN0Iyy6R6U=;
        b=FlB4YSn+NesveqJMKjLgZgWow+xMkLBNKz05oruM51owOmhhI3uSLEZL2fhIbYjnxB
         hLlrrlbPOJ2IWrHu/a1wXOvkVp8fcar8HxkQg2aPxktyh2bOfWzSJ6rvWtuPtfyCBvx7
         nNC4gokLxXuI3x2iMpcm9+BZVuKnNmEilrmO4jF5rMVNZ8OT7QNsx1hn6xNhcXIw68mU
         hmNbHcCxjQL0cuPDTfBgor6r/0yGr8+mOmGB/BhFEV/r7Paj5gdmb7TMmZ1b855lcfHQ
         FJ1BEb67DvvkkB3+w1O20lhcjQEjWUZlEFNLkZejthXt3twvitVYEJLa9u7b6k744EeO
         pelw==
X-Gm-Message-State: AOJu0YzRhA7HDzs8lk6m/mlrqWe398mWWIJzT4eC/RZ5aPCslCuUnWc3
	1g6Oa/dddr0vkWAY9gON07O8Jfd3P9bhkiPz2dmZ9cVC1++uv+YBL9v8VuZEZYU=
X-Google-Smtp-Source: AGHT+IF3nqKBEWVvci4SEZHcSu5GXkVElPYZJQUjCfKrIEylC/tWBpIZMu1aOQe1t168W5NNY8DKnw==
X-Received: by 2002:a17:902:ea0a:b0:1d7:199:cfc5 with SMTP id s10-20020a170902ea0a00b001d70199cfc5mr484297plg.117.1706668692197;
        Tue, 30 Jan 2024 18:38:12 -0800 (PST)
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id b4-20020a170902d88400b001d706e373a9sm7935517plz.292.2024.01.30.18.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 18:38:11 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rV0UL-00HZeK-17;
	Wed, 31 Jan 2024 13:38:09 +1100
Date: Wed, 31 Jan 2024 13:38:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/8] dax: Introduce dax_is_supported()
Message-ID: <ZbmykQpcllC/LY6J@dread.disaster.area>
References: <20240130165255.212591-1-mathieu.desnoyers@efficios.com>
 <20240130165255.212591-2-mathieu.desnoyers@efficios.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130165255.212591-2-mathieu.desnoyers@efficios.com>

On Tue, Jan 30, 2024 at 11:52:48AM -0500, Mathieu Desnoyers wrote:
> Introduce a new dax_is_supported() static inline to check whether the
> architecture supports DAX.
> 
> This replaces the following fs/Kconfig:FS_DAX dependency:
> 
>   depends on !(ARM || MIPS || SPARC)
> 
> This is done in preparation for its use by each filesystem supporting
> the dax mount option to validate whether dax is indeed supported.
> 
> This is done in preparation for using dcache_is_aliasing() in a
> following change which will properly support architectures which detect
> dcache aliasing at runtime.
> 
> Fixes: d92576f1167c ("dax: does not work correctly with virtual aliasing caches")
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: linux-arch@vger.kernel.org
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: nvdimm@lists.linux.dev
> Cc: linux-cxl@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> ---
>  fs/Kconfig          |  1 -
>  include/linux/dax.h | 10 ++++++++++
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 42837617a55b..e5efdb3b276b 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -56,7 +56,6 @@ endif # BLOCK
>  config FS_DAX
>  	bool "File system based Direct Access (DAX) support"
>  	depends on MMU
> -	depends on !(ARM || MIPS || SPARC)
>  	depends on ZONE_DEVICE || FS_DAX_LIMITED
>  	select FS_IOMAP
>  	select DAX
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index b463502b16e1..cfc8cd4a3eae 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -78,6 +78,12 @@ static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
>  		return false;
>  	return dax_synchronous(dax_dev);
>  }
> +static inline bool dax_is_supported(void)
> +{
> +	return !IS_ENABLED(CONFIG_ARM) &&
> +	       !IS_ENABLED(CONFIG_MIPS) &&
> +	       !IS_ENABLED(CONFIG_SPARC);
> +}

Uh, ok. Now I see what dax_is_supported() does.

I think this should be folded into fs_dax_get_by_bdev(), which
currently returns NULL if CONFIG_FS_DAX=n and so should be cahnged
to return NULL if any of these platform configs is enabled.

Then I don't think you need to change a single line of filesystem
code - they'll all just do what they do now if the block device
doesn't support DAX....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
