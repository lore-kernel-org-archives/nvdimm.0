Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188AD32E121
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 13:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782394520; cv=none; b=coodIRT2z/HR4eQuJW59nPaZht5tN79J6hTAzUmD/9X11uTP0wk2npIg1yEYKlq1tx1APvToB1X8kOGXPa8+XiMNLeXd4Ma0pQWln6FqkTQ2rb2xpz5FOZ3lParDGvfrLMQ1ogILPDn5vospGukh+mdykiUgVevXU8sVUKOE3CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782394520; c=relaxed/simple;
	bh=VTl59t5FGNxl9vwIccoBE1FSh1ipsJkGVWNaK8PoD04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cspgHHWYcRurdQJ1g6UI3yGBpwFFWTLtShc8EFcfq5FapUd8PQcvU6rgeXJJH6RpawOInaRdEU13Qv6vOWXEIq5dJTZDjGxljJ33btttnCA/hGYLOVIiYyNqzt4ApZHyBkn6Gzk+UKZORw9CDW1a7YQz8MuO0ucH4452UbW2onY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=QGQpbzPn; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="QGQpbzPn"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8dea42b547eso32422756d6.1
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 06:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782394517; x=1782999317; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q8pz5eRLl5osDfg8s+rI8Lgc8KwmBuE9WN+Pu83DenE=;
        b=QGQpbzPnl5MyHZLUnj9THzPangH1zWjxsP1pkD827M1XlLlW78v2NhQ7sPcghDaSJo
         sOgHdGO/foc2k1Ax7vAx7NxpAXC89vLdEjhz5C5Jel17f3O4Of1kyF9JLahwHGdvXciF
         PMen8VBmMPzLhbhXa9Sc9JQ4+IHT5B/P9M9k2FxaMATsCnQh27KE1j3ekLJImp0X1+A2
         2s/hsAW6XgOSACO6Lvh6oepSMb4aC//AEZRdYKCeAdIYss0oXnCKmfKURqMVnIgx9F3u
         fkZGVaKG2YrVGnQC9zAWqFcHpTUjc0GnP8aZx/LE6aAxJDyKEZheBeGyFdjFGdWw20hC
         zpPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782394517; x=1782999317;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q8pz5eRLl5osDfg8s+rI8Lgc8KwmBuE9WN+Pu83DenE=;
        b=FSxhJ0yodLNxQy8ZkHwtaj3s99UI+goHmZ6WABP+8Mu6gGPSsywcOCm4Zaz2OsUiRq
         Yhxpa1iryZbH2Tnx2CU+DKp9GdgCFYwolxleSR5tPanXczbaHsNtkHX2DVnnITknecDg
         Tp4mz3taEX5qPz3NOyz45BjnLqJbzo9RYJFcgclfG67Gdf+3kXCZv2fIHjzI0PlJ4PGe
         ObGDpj1Wr85A1h2MJzvrQXRKgQtZ78UNrsX+IHDbhZIw/611CIxeaVpAZT0QrP3CSMAT
         E27MYxHsqb5SvR5sd3S/n/RfSi1LpAV6eZngdw6qYW/8KyFVXDTv+E/iyGwd0EttjtbL
         9Jew==
X-Forwarded-Encrypted: i=1; AHgh+Rpq/tmmYvbAnz+R68f9EwllI6Rm0Wbj9dd4rvbaVxQWqXGekCx/DGV1t5QS8QTjYkL36D5cTeU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxD1hpkJXG6zgVAjYw8fCKI9v+rqUj8pFTvj2PP9TgP4wkrTUcT
	aGf0/+m7URcmzc9PQazP0lX4lF3Dnmggvn22CuiATiWYG/sd8XiLkXhPnS7duGm356c=
X-Gm-Gg: AfdE7cneDksCqFxJgMjeauPj5cLyR97/TUngQBAbYQ1Xq0yeKzBAu1frX2KPPNKRtVz
	wYZpTMFiE7Eqglqc9sl45j7ni47w9dD/sYael81ZwSFT2cPkojmDiAVG1rRV4tBFSiKNTpm2DYy
	JfTQGPGviYSJnzSog5DLbCQhqsjQGWPDOHOAJRqJ4BaN6/y9UxJwNUXZ5faXIP/khwoZ9wlmJsT
	FWizVqdBmH0ZKn6KRCEez12TQfWMY8KATU7i2znJ4Ve1qcM+ulErjfA9TpJOR7hT+fx/7yFcfSe
	9rEqkiycrMRqR2s9rCCCsqd7t20YCTgxnwkFL9OdIIfgj2M+2fcEpVR7lJlKiSp23y86THsqjTK
	RJCGnzbu1Unlp4vmVz/B0rVWHcKsfi0xqGjJ/ZvprfrudDap7Bw5quHkt1F97PvIwCD1NVPVKeH
	eZZ+U2aVTMIxsi8sNS1bUMsY6Eiue+KikAvbnTEXLCthN7HpTS+qbUvT4fe7jQm15N0dv0
X-Received: by 2002:a05:6214:2686:b0:8cf:9bd:744 with SMTP id 6a1803df08f44-8e6d2ec8509mr48772246d6.12.1782394516856;
        Thu, 25 Jun 2026 06:35:16 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8df81cde319sm183477356d6.31.2026.06.25.06.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 06:35:16 -0700 (PDT)
Date: Thu, 25 Jun 2026 09:35:12 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, osalvador@suse.de, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, djbw@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com, ira.weiny@intel.com,
	apopple@nvidia.com, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 8/9] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
Message-ID: <aj0ukAdiKRDEtYeN@gourry-fedora-PF4VCD3F>
References: <20260624145744.3532049-1-gourry@gourry.net>
 <20260624145744.3532049-9-gourry@gourry.net>
 <1d8f74a7-502b-43cb-a0f0-1923049aa213@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d8f74a7-502b-43cb-a0f0-1923049aa213@kernel.org>

On Thu, Jun 25, 2026 at 09:40:02AM +0200, David Hildenbrand (Arm) wrote:
> >  Documentation/ABI/testing/sysfs-bus-dax |  26 +++
> >  drivers/base/memory.c                   |   9 +
> 
> Can we have this ...
> 
> >  drivers/dax/kmem.c                      | 224 ++++++++++++++++++++----
> >  include/linux/memory_hotplug.h          |   1 +
> > 
> 
> ... and this as a separate patch, please?
> 
> Nothing else jumped at me.
> 

ack

~Gregory
