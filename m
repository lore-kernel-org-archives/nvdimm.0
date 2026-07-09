Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDC940BCA2
	for <nvdimm@lists.linux.dev>; Thu,  9 Jul 2026 15:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783612639; cv=none; b=kL/Tc9NEe5VLTbBBY9eHjJ+PKzqK2E2JT0iyVOfN8/tei2n7QHAQIJcxxMNXe4V0nak9Km5uHt7oT+NdY5OClioZEz64tAy6ZMp7Kq1LjhPRzEIGSP/B3X6VGVWwut1vPOYGT8AJOgnk7wBfD+YImSh2gob/+O/LC1h1r4XsU3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783612639; c=relaxed/simple;
	bh=zOqJj5IGDkUHkuE0A0VjkQNttgCPQIdWlZYAcSbicnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DqywsLQGB01ctpOSHBmkg+nzvXhtp39CNwDI8g5CyOGNrayYh2i31zBuTYujdNe9AngF+FtCYuktZaV2/yX40PDCLZSuEa9rEkp9ZmfVvxaStK+bo11q46Exb7gFl1AzbS0rD+RDe/7j3MM1/SdJ4q5KYMiMzvhMtHcQJuMlKrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Izkg+ycr; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Izkg+ycr"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8eff5ce3b95so365066d6.3
        for <nvdimm@lists.linux.dev>; Thu, 09 Jul 2026 08:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783612635; x=1784217435; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=T5BtG8ZZnILhla7gs7f63UlRSUpFIkMkPS04TXxov0k=;
        b=Izkg+ycrCyOCViNSSPP/Do+d2sLA2EbH3MqgIZTEDTFkrkUvu/G73aUE9BG838DnCz
         d8SeMg/+eL9LHO2TTmHHr7EI/RId1lnfvYqGUP4Zn+Lce14iR++fdUk5txF4BaOd2ZNA
         olB8K/d6X+nxsp50jZE1vvNelvP52BBoQiRp1uLU4BsqCxBOkMjRl/j3iOhiHgzCM1Xo
         WyWLvXMG+yWXNKbR2BVjz1sb+4B93DutWF9UzcPAgrJGnWS5Ybu9WwAhDcfc151WlE8v
         kYZ0vZf7SM7aUWX3j1ITaakgXJy4NQYi6RZGSSaPBlU8druHLboOHcLj4cuiWJIuOtZy
         hESQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783612635; x=1784217435;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T5BtG8ZZnILhla7gs7f63UlRSUpFIkMkPS04TXxov0k=;
        b=I2yITyrWNhGg4kHRBkpFpfa5FFCyIUPqYQap8LXzC/nTX87GWCJeV4eJotbxpL/RWy
         MOSRHVsUyDoG7yt10buz/Y2zaNQF7OTACEjSb92cdIhufX5A87xROUAaOBBoYd4TwMQo
         yBZY0Iz4ph1tL2utr3s4waZGY65tkYCf3towYqIGvdkZXg0LDm86H2G2Z+toTzByBJRZ
         88OaFEgwXBdUe1UHs4qJ8fd203ZpYBlVxAuLhQQxugJryFsBPuReVjn2dW/TYXgrNwrg
         4A+L8WQ/dUGCeBYWcoYj76Q6lkAXIDkBwRMxE4B+2Ez7xFcRcys1Q01aODK4V0kzDK7G
         FZRg==
X-Forwarded-Encrypted: i=1; AHgh+RqFNv/aFDlu0nz0EeCBUW6zdstzzDofc1959DnvMroteQb6KSfFjKCR4+GrR4wq/OEaWSq8xgQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzBLeWBqbqm7VmtuvgjhI/s7zFIjW1rxHBJglTCtC8x4NOV2CYd
	8Xl075riMHUHtcsYtf4xPpgxGRbpbNVHbyVvpcxjokx0andm//+Cu8j+sKmyg8H0G8Q=
X-Gm-Gg: AfdE7ck78zDKAkQD6SpD/ihqBk+yY1S6cYewux+RURad995sm1YIJvQU/LghCj8bxzY
	t7K1X/Iot9JtjfaE3u9hqJcmdedfSYcCm1pdOBgotn5lyRDlIP4fL8GY0cvMoojNQOd1pig0HeA
	ey6QLbi0A4q3ItoVm561InDjRle7J9+CKEPZNpj2Y8zp30ZgXL5xhIrIHD9raDfNQgsZtk/aOzy
	GDlPAD8UbtDp27p3iabBVhbjmSyn1P9k3rBh7vz7IdfIGvEVsQ+5qFvxBYZT2qUSeWOhGhx3xGR
	v/7VPJH5n2WdIfGeaL1L59peUCiIDwDc4UUgwpA69bzmvG4s5UueT2+MNpSLgZ3lKAnUncpTjyI
	dqlSAKt1koh1xJ3AleKxupP6t8RYj6mWI35owVHAWZbK67uMLD0TVldJc4XUdOlv3zaYotm2Ahi
	mrRPPpQtO6GMO3lRrtjDk51rA/6Paw/9VsXg5bWx351sU10qXxlQXNcZ2Ai7l2Bi/5qPBjNGPgb
	iyWoSk=
X-Received: by 2002:a05:6214:2aa6:b0:8f3:e0ce:6119 with SMTP id 6a1803df08f44-8fec0ead52amr91789316d6.21.1783612635560;
        Thu, 09 Jul 2026 08:57:15 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd86d43e2sm20317526d6.43.2026.07.09.08.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:57:15 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:57:09 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org, iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 19/30] mm: use linear_page_[index, delta]() consistently
Message-ID: <ak_E1Y-D2Twykusr@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <bf56e2e98b512962a2fb88900d535a0e9e6769d8.1782735110.git.ljs@kernel.org>
 <ak_EivwcDDdn1Xvp@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak_EivwcDDdn1Xvp@gourry-fedora-PF4VCD3F>

On Thu, Jul 09, 2026 at 11:55:54AM -0400, Gregory Price wrote:
> > @@ -2462,7 +2463,7 @@ static int comedi_vm_access(struct vm_area_struct *vma, unsigned long addr,
> >  {
> >  	struct comedi_buf_map *bm = vma->vm_private_data;
> >  	unsigned long offset =
> > -	    addr - vma->vm_start + (vma->vm_pgoff << PAGE_SHIFT);
> > +	    addr - vma->vm_start + (vma_start_pgoff(vma) << PAGE_SHIFT);
> >  
> 
> Obviously correct, but was this intended for a different patch?
> 
> ~Gregory

bleh already caught, sorry for the noise :]
