Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B5BE574
	for <nvdimm@lists.linux.dev>; Wed, 31 Jan 2024 02:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706669326; cv=none; b=anMQ3+EqZkh7Z2gy5c/0TM6XfzeHcBjOuYuYF9p2P5UNHe24+pEP4ygH7Yw6vJWJ+LBfA56j5Q42SRuQYCrXPD3j1dy5O8UD+iQNrs/6k1C2AMR/GAaTREuZJRTumM2OhrCYn3wdImTM+mqVfsqxCDl4P69S2hL7DPJP06qn4mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706669326; c=relaxed/simple;
	bh=EQL375dfJ45QKL20tEKFWpifQWW4xKqbP46PsyALWuI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HQ2mOmwdj74df6LIlCZJPeifaJZCNwMdT15Ekr63JXyYn05YmsWrgZ8VNnYrdgn+YeNIjON6sCmWoDMdB/hS4MAwVMp2GYC3EM5mtfpC4K6zmIBMP1NNJphad4orCcdZxRlXgmcSEGnj1fX/JoLQxkI7Z6pdmuGspm7WSH9LAEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=S8AqXC2+; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="S8AqXC2+"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6d9b37f4804so315194b3a.1
        for <nvdimm@lists.linux.dev>; Tue, 30 Jan 2024 18:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1706669324; x=1707274124; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QXPQ5XtJsAXFNxQJCj+inZTl278RjDiJDDTKJAOYW4w=;
        b=S8AqXC2+iqlBdrfzNJxv7G7u8FfKtIABP3Bh60XCwHPdjY7Kk3jE9NkZccjVTI7U4g
         gwcI4UM+thZU8p4cc3Wn3oBqHRgZvkQcyJQGq0HbgAMqVRvNo1GtgH7mHxl6z/ognBuY
         k+d/W+zrb397GKisD3aOHplEaWzXvAvZZnUa/SQQX475WjFxzTkhG+Qw17mfP6fhoP8c
         Q0cFJuoYTgbaJlwUA0NkZfiFnRub81o4LhUTbw5+i65OGmGZ7fLyck8xURjUYnG8E+pg
         45XX/x0X52bs89E+ZjmeuD1VPMTY3O6WfdHTIRHgeV2gd0dAKHpJX4QwxhfdLNb1s/5Q
         Nx8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706669324; x=1707274124;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QXPQ5XtJsAXFNxQJCj+inZTl278RjDiJDDTKJAOYW4w=;
        b=nbjdPq+4P+Ie5zA1ja9eapXOq2wy4rrB1IQHu/OFmSgs/0BF20IAVJyTIA0lGfcvdU
         GIwcg97QNfMrYDS/nkKVPXKyzgTgBSSxIH0HQadmVF8fQIOCPr48KbQwTVFRRUm43eyh
         ofHsQpbsZ6NofLjdAE9wS/tAlG26CwvjLoIGGO19zWl3nKDAst8gF8osv4lNmMIs4m7j
         MXMIToeE03gsokEEcaqEEtl220XZGdWZ9rYYo3+WSrlerEZmemV2FglsQM6PPoA6Gthb
         6hRsHNIMjpEB4IbqGaOYfOjgfTM2TAIQfgHQm0e3YLiS5miyS2fVVQHRVHX2sBh5+GTU
         eMcg==
X-Gm-Message-State: AOJu0Ywwnik4VJJsJnAGD21kPy2rgb2DDlxrcf8aS5LVG6h80dfJt712
	MvnBdBYyn/jZvKEl6ywsfn8cShygMSq/BsWYRsILoWh4IcNlba/e2NBGIg1f79I=
X-Google-Smtp-Source: AGHT+IGIax+EKntkIgHYl8yak5r7GR0dyUWQMl80wvDvveadSoiMDe5xxcs2Y26+s2lWbIwhfQlPNA==
X-Received: by 2002:a05:6a00:d66:b0:6da:c8b6:6dc8 with SMTP id n38-20020a056a000d6600b006dac8b66dc8mr333189pfv.13.1706669323865;
        Tue, 30 Jan 2024 18:48:43 -0800 (PST)
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id r6-20020a056a00216600b006dbd79596f3sm8582748pff.160.2024.01.30.18.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 18:48:43 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rV0eW-00HZlT-1P;
	Wed, 31 Jan 2024 13:48:40 +1100
Date: Wed, 31 Jan 2024 13:48:40 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>,
	linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2 7/8] Introduce dcache_is_aliasing() across all
 architectures
Message-ID: <Zbm1CLy+YZWx2IuO@dread.disaster.area>
References: <20240130165255.212591-1-mathieu.desnoyers@efficios.com>
 <20240130165255.212591-8-mathieu.desnoyers@efficios.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130165255.212591-8-mathieu.desnoyers@efficios.com>

On Tue, Jan 30, 2024 at 11:52:54AM -0500, Mathieu Desnoyers wrote:
> Introduce a generic way to query whether the dcache is virtually aliased
> on all architectures. Its purpose is to ensure that subsystems which
> are incompatible with virtually aliased data caches (e.g. FS_DAX) can
> reliably query this.
> 
> For dcache aliasing, there are three scenarios dependending on the
> architecture. Here is a breakdown based on my understanding:
> 
> A) The dcache is always aliasing:
> 
> * arc
> * csky
> * m68k (note: shared memory mappings are incoherent ? SHMLBA is missing there.)
> * sh
> * parisc

/me wonders why the dentry cache aliasing has problems on these
systems.

Oh, dcache != fs/dcache.c (the VFS dentry cache).

Can you please rename this function appropriately so us dumb
filesystem people don't confuse cpu data cache configurations with
the VFS dentry cache aliasing when we read this code? Something like
cpu_dcache_is_aliased(), perhaps?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
