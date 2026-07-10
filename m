Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DA53B2FE6
	for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 21:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783718051; cv=none; b=qwXh9A6TER2b0E+qjPyW68yRVwA/xIgb3B8fWXeYetbueLZb0DyuYZgeZoqT/QjIIGjrDKC+RiO9ZS/U4L6RUCzbj1H96+5g9fiwRQU8Qi9MzzLDCQ/nflT87k59KWZR0cpRpsiUXi4Mm3AZg9Dcok+/KN5NAUus15/ZwpXX0yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783718051; c=relaxed/simple;
	bh=K/lBj6p3knKpn1KqMVCf0Kk2GjXtTJbSA446pc7gvzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gyezccY3lHOxJ9ysbo8vxaFcdL3gBVIBlC2xjSAV3xn9ehGxq8zah8ZPNf8kARHgGOpwdQ2W7hrxGNJdty/LctHz7A0bjh6X5WeMvSA/tP/ePbsRtkog1hVcJ0EmAuPzgQAqXW6rjPY/Qt41nbGSVoRbFHsbtdjJh4vr0cKUkKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=gOLzyESk; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="gOLzyESk"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e855da580so110739485a.1
        for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 14:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783718049; x=1784322849; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gpMGBsh9fToTErr7i3jlVPE4gbDMnqxhA+rLBjZ5wi0=;
        b=gOLzyESkeAZPSkeY/7bQIDMal7eJxN4PFPH4lmigycKJkRp+eCKw9A9m7I4iSmyFX+
         qFvtC5iCKHDrQqRpVh7k819CAenXNz6XspMnTz7uK6H0fgN7hDX7tsGb9eglpkKGom3u
         d3u1Hduht9SO5ZzRR019R73Men22IUZ/dM8hePvp+LwLVcZWs+e7zzWCVa49SeUXHNH7
         5sl9s+ZfEvSjJApUmKg4gdRuolks7owthTjpIZE+p3Ctn6Wwzpmgzdrco7o5KJF9P/QS
         Qc3A4trdbbB05TICBPM2scstHyreUnK7/aPJtTphTzsE4n56KSXWFDyp1UKrYrTyzVBS
         UFRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718049; x=1784322849;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gpMGBsh9fToTErr7i3jlVPE4gbDMnqxhA+rLBjZ5wi0=;
        b=aaa0H6+6M/h+rdCZumvBBOIjZDDCqOkuItZ2lrD9kynN5D14cnV3tTpo5cIHD65yy1
         iU11ng20qhSAOj1a73pMVW78SbFVt7bULDUipWJMOZ3pWU2gl8iIWWUzF1K7wtA3l0Fp
         a0PJKzZ8TQf5MN6E0zoyz5KIOOdcPPDZwo2j7sapqT6WeboVuCkyr82NiovnCIWWp42h
         a1hkU6xY4Dhh+OgDVpVoSrdOZf+1Ek16Amq3j4r6LU4lVPpK9d5MRwe5Hy6Nyea2LMdT
         xwrILfM9ucdeEprsWQuITEcHDYe4DoTy8nzNbz04ds9A9TMgnao9TAndIQPyOr7g7ZNH
         zzXg==
X-Forwarded-Encrypted: i=1; AHgh+RrLw8DBifunkp2VdyDK+KYg4Cf/Ur7YFgXp1vFTgpJCqusC5RaJT+kfDqy037LDbL0kQIpH6RE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1iGDY9OodMCJUfSCoBHxRLkUl+qsuGCuFbRT8HjC8MeY3eZuA
	hDYjLyx1/YI+g/YMk8W/PqHIUe9mxZVwI9PWZJett6BSkel4nMdq3TeGm3beUDKfpQ8=
X-Gm-Gg: AfdE7cmLZqXeXKmUXMJWVCswjY1Y7B0e8Wuw4aNike+wvUreBp064J+7bo81dV5DAjx
	b/PPZ2rRLL0B0glqB5Amb2hnu4nrpID7ew7KwiohP43zcscKR0h9l8SbAIT3lj7VRy/pxiZLsFq
	T5UzE3mZqSqNW/bU42dTIe65ZyaZsyIJjbnaV44mDZ0rxXDhW5i+VfyWYM4aUr02Ib55oOijZOy
	7cQq2XQM3L82GyBqf4f2NbTTOagGqFJfSnT4mCBG+ks9Z4hntgsgt2uT0YOGTgxFM/srszQUqEl
	dCzcZFy9HXzymHoPG8+GQamXbFD23QWjG60G1ZhlkXfxucYKZ2rYdZ13ZNRyd4i/aeooUaRH8me
	aU/eJcKocwX2e9Z2AAg27KT0mDPSpHqSOA4NrCTTXj74miPbXwl1ZJuHq4wunmiKuAmCtXx7p9G
	pAznBGtmhVTXLmumFgemZiVjyYZOxMD6/HvDbuN7vKqA+c40AxUy6B3MELyBhYEpcwNqrG
X-Received: by 2002:a05:620a:458a:b0:92e:c117:9ea2 with SMTP id af79cd13be357-92ef2e264b0mr94774285a.80.1783718049159;
        Fri, 10 Jul 2026 14:14:09 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd50e3083sm50604746d6.6.2026.07.10.14.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:14:08 -0700 (PDT)
Date: Fri, 10 Jul 2026 17:14:03 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
	Lance Yang <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Christian Gmeiner <christian.gmeiner@gmail.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Abhinav Kumar <abhinav.kumar@linux.dev>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	iommu@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
Subject: Re: [PATCH v2 10/33] mm/rmap: rename anon_vma_interval_tree_*()
 params and use pgoff_t
Message-ID: <alFgm58E4G7hWIm_@gourry-fedora-PF4VCD3F>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-10-2a5aa403d977@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-10-2a5aa403d977@kernel.org>

On Fri, Jul 10, 2026 at 09:16:51PM +0100, Lorenzo Stoakes wrote:
> Rename parameters used by anon_vma_interval_tree_*() functions: 'node' to
> 'avc', 'start/first' to 'pgoff_start', and 'last' to 'pgoff_last' to make
> clear what is being passed.
> 
> Also, express page offsets in terms of pgoff_t to be consistent.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

