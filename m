Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D90F381D5
	for <nvdimm@lists.linux.dev>; Wed, 31 Jan 2024 20:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706733774; cv=none; b=AWQ1VEBCfq1iKcNiTyoratUN8Q/fPOGIhDjdv69iDj5JodH8zWXlxRhdBAeUu7CYhPk+W5/CP2p/Lz9vTdomk6BcBzr5qfFftPO/3gpvG5Hzf3t02G/Ya0nw69P+ZOaWwuSKlFfK52QO+J6PQYuwNIZslJdDeNGGLiTXrwgMsxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706733774; c=relaxed/simple;
	bh=0ttANtOrcttr7NXaqt/G0w+9AjfKy+c5thEW3pDhz3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sCflt2orshv4zVTuiZEmrSwe//XMDD6CTGvqW5CNIVQvRJkr55w5qAofe4NCBGJtQXBcafqs3akqrULl1x4gBfUzugrRGjThOd1nrnblWz8V4oU38sIVRIaA3wXFGyI4K+2K/sqqSGvnMpiCwFOcZZ27BPnNtPlLkTHPHVyrXhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=u0jkoS5a; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="u0jkoS5a"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1d8ef977f1eso1629505ad.0
        for <nvdimm@lists.linux.dev>; Wed, 31 Jan 2024 12:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1706733772; x=1707338572; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4HikurBEOhu9euC7gl0ui3GG6XowXvyoYxK7m1zGW+s=;
        b=u0jkoS5a4oT/w2bG/IjvA3Ops/6Af3U5Ok/4IuiIopgueNtvcBt1LFzpgG46JBMxoo
         4no6hVtfva/hBTvN/RWRx9RvlT0JTLijdccrrEVEetwlfrKIVvzHsrLtRFwuBwlN6Fez
         OH2ZVfNCXqTJZeyZvzwOkNGRN7xsw9sb/8GSfoQVdB8o3pAxkbvbvvvbYzeGEmxt7XAy
         0ccxvD8Kk7HPAOrEzgQctv4zjgAiWLc8LpY32bRZp3tyAIsQ9f1pFFIJKeMK8VuUGLI7
         QMV/By7R40M3y8mk+JzB38wK/0A3159ATbW8unh4lLPmu51s53saZWvZ0iX5jr0Yz1YG
         pmMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706733772; x=1707338572;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4HikurBEOhu9euC7gl0ui3GG6XowXvyoYxK7m1zGW+s=;
        b=poC4wB7kvttRUGEfWIETQHhpyeNUX5jIrO37XOQ/pnwHyWpbxK7z+17ES5i1kUhwBr
         Ex7eCGeQBzzrD2LWfNkP4+l7xu0K0q9o3MQ3y4qcBd1I8mWL6l1Si4RQLUPIU52syKU5
         rC4i0hH9oTmAFJqVXqs8yZPP/Co6gbXlStiS+PHni4SvXw5uY/ByyxJ5wxIKPjTV3YjZ
         /awGYNU42AHkyx/Ooouyq4IcYWO9g1U/4m/dlScTDWbavxDrjcogrtdgHDqIYyR8carJ
         No9yM5+TEJAFRLnts7LKDD3OWlrfTpglxVgx6cqY1ynW/YQPO8Erz3aE24tXdf8aDeTD
         cAsQ==
X-Gm-Message-State: AOJu0YwaJ1jZ8n/vOrp7zcjC3dbAzHzsHngBSDprrWVWtLjMdvPma2eq
	umIBZpimf7+Zn7ddbrCpD8lKZkaO3lyrS1sjtOu61XS79+6Y25ix/ZhDAF3kVHc=
X-Google-Smtp-Source: AGHT+IFKgnjyHOHXjb8FWpmberef1nwD4qkIyOp+/vPJjvOfE+QEc5Mj2C0M+Fe+UDPDMwl9iwoIbw==
X-Received: by 2002:a17:90b:2406:b0:295:cf9f:a1de with SMTP id nr6-20020a17090b240600b00295cf9fa1demr2928435pjb.12.1706733771727;
        Wed, 31 Jan 2024 12:42:51 -0800 (PST)
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id db16-20020a17090ad65000b0029608793122sm225215pjb.20.2024.01.31.12.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 12:42:51 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rVHPz-000JNE-2o;
	Thu, 01 Feb 2024 07:42:47 +1100
Date: Thu, 1 Feb 2024 07:42:47 +1100
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
Message-ID: <Zbqwx12WfXvZ6kk2@dread.disaster.area>
References: <20240130165255.212591-1-mathieu.desnoyers@efficios.com>
 <20240130165255.212591-8-mathieu.desnoyers@efficios.com>
 <Zbm1CLy+YZWx2IuO@dread.disaster.area>
 <d30a890a-f64e-4082-8d8e-864bfb3c3800@efficios.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d30a890a-f64e-4082-8d8e-864bfb3c3800@efficios.com>

On Wed, Jan 31, 2024 at 09:58:21AM -0500, Mathieu Desnoyers wrote:
> On 2024-01-30 21:48, Dave Chinner wrote:
> > On Tue, Jan 30, 2024 at 11:52:54AM -0500, Mathieu Desnoyers wrote:
> > > Introduce a generic way to query whether the dcache is virtually aliased
> > > on all architectures. Its purpose is to ensure that subsystems which
> > > are incompatible with virtually aliased data caches (e.g. FS_DAX) can
> > > reliably query this.
> > > 
> > > For dcache aliasing, there are three scenarios dependending on the
> > > architecture. Here is a breakdown based on my understanding:
> > > 
> > > A) The dcache is always aliasing:
> > > 
> > > * arc
> > > * csky
> > > * m68k (note: shared memory mappings are incoherent ? SHMLBA is missing there.)
> > > * sh
> > > * parisc
> > 
> > /me wonders why the dentry cache aliasing has problems on these
> > systems.
> > 
> > Oh, dcache != fs/dcache.c (the VFS dentry cache).
> > 
> > Can you please rename this function appropriately so us dumb
> > filesystem people don't confuse cpu data cache configurations with
> > the VFS dentry cache aliasing when we read this code? Something like
> > cpu_dcache_is_aliased(), perhaps?
> 
> Good point, will do. I'm planning go rename as follows for v3 to
> eliminate confusion with dentry cache (and with "page cache" in
> general):
> 
> ARCH_HAS_CACHE_ALIASING -> ARCH_HAS_CPU_CACHE_ALIASING
> dcache_is_aliasing() -> cpu_dcache_is_aliasing()
> 
> I noticed that you suggested "aliased" rather than "aliasing",
> but I followed what arm64 did for icache_is_aliasing(). Do you
> have a strong preference one way or another ?

Not really.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
