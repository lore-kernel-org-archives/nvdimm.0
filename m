Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EB23FBB76
	for <nvdimm@lists.linux.dev>; Mon, 29 Jun 2026 15:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782748496; cv=none; b=dt7Pb2PNN8iUHx112BWfp8Z4mSj3/PUv831v/XjYkaRXg0rqNYEd9x+aXVn/s0mrVwczhz6KwcIm7E6+IcBGLniyrM1+o4AwO/wsCKxqKiSlaX1PGGAitrKkyKvkYWs+tlKX6ry5RLDPi6pwXBOfMq2BCVt8YdMuCTuATdGUJRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782748496; c=relaxed/simple;
	bh=vSc4ORRRpUbp5nwMJk1U6F/78ha49jf3UdrgblxYv9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GmgQyzakzX+xHIqKYoLaO+q6UfrYLiCp9j+9K2DgcFTl5S6nMnRiEJ3hlfjsj2eMl5SHpCxnXBt+LFsX7He5RouNlXxevqe8ePGLZpegXL0AcBoQakXMiIWHu+QArB3EvLZsfk4qhfO3EHGgxZlb/xA7DpToJcxySdyT91RiBLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=iIQgt3cf; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="iIQgt3cf"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8eec5dfdb65so9350636d6.0
        for <nvdimm@lists.linux.dev>; Mon, 29 Jun 2026 08:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782748493; x=1783353293; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4r3nyg8MsZ+G0ckW9OOGJtlL6QAvCNLsDtm+wiwuKtE=;
        b=iIQgt3cfcOAwo1mrTmq2ufd7KBn7KaZZcIcwoYn3k/1jUjMHWhQGvQ4DQ3gdJVdNiv
         KWzQBVBW/ZL7XV/e2KjuKu2Zpg9i6fyTNG4Kv3m/G5jB6Znl9LTwS+ixCMc7GI2VBhik
         cO5j2exnCvxvPGgEQxFxF1HIPpi2nKZNOe8P+6lOhGTTR0wXZki9pQ0+HrKGWSnUMtxo
         cNIaiBPACH2+lUM7D/d/z7iry8ibk/Wp0if6q+Fr5Z92SVu//XAclq6DiXEO5yV1ilgi
         KBXBsaWOwQN6PO8T+2OHN362TYHjzMTXXgndYOp6HbtgRmOKbE/H2dcqzwzyuaMBJOVr
         d1ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782748493; x=1783353293;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4r3nyg8MsZ+G0ckW9OOGJtlL6QAvCNLsDtm+wiwuKtE=;
        b=ex50DPwkKlTZDER1me2p7JD1mBVbPElJRuajKTUDlXZAcPMKbiynymaWGlV+ykZCge
         DeTwW7lQqFfGNOnROaqb1a54AaGicEWW/48NaXg9LS6jyjyp3AvodCjPGPgm4NL8eTTl
         Y7H3l8TiKV9nNirbGdhI8JTCuxA6plIyf+uaHF30fY4xAUqGw+O94nD8hJ5TXzYu7i/U
         yGnUKELO+s0jOEg70mkEzUQ5iVmXcw9YJiRLmWQQqo68mFzlndSla5J9ES0WxhPoo4rs
         uFipvj3s05gFuXa2NRFL3FxwtKkJkUzBn7UGv8aJnd/G2QGSWpBCx6ECKC+s12Mz4FQm
         ovSg==
X-Forwarded-Encrypted: i=1; AHgh+RpS9Wa56f2Hk0jdRVdku/rYJUudUtfqbl1hjarzpF7vS+216Od2POdmPOZRZzk8RLPXZWvfjBs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxMtybSjcNlCfHxITg9aHfXnURUoSGozKf3/VGWKawbHivUtiDv
	+nUzyRu2N+s+Y0p8TMp+tWSAbrmv8YSvD0X1X65Or8ngOT0pSz8IvjCzvpkXfC5xVU4=
X-Gm-Gg: AfdE7cnTvV+ffjltEjMe1SfImO0wUzn7TaNKQ5XHIZ2aczEJtLR1/aTUYMoqilZ7Igv
	fjiptgVEP9kC30/F0Fg30WMV9tiSbgj5ijGnMhx0EYjgrHlbjK4jL2Vk5KlWZwUfv8JOQdD0HEN
	68dfzIotTLM7zM/bgyGQlNsg0xW0sxJOKmbpcaRPkYiA39KPUZZklypQRhxNtj2u3dFBgaOV1Kj
	yj1wTlnDw1SDeR7CSkc2b4v6L/OqcshApdkQdm7eDBXMyv1Pv4z4EuVuAzgkKW01AqcpiRNyS7c
	6QE75tUeNaphb0SSK7PdsLP2vGr6DTHXgyPd2PxkS3lDPfmlB5RM32H2VLHBNZxLHJxeQQWx8UH
	xO9fluUaTB3mcHmG3KPC2WSV3v7whh1M7QNjvupZw1/5JtBuup2/sIABIfI5WT8+6L9EIQVYMyG
	/mJuZsYZR+pMIRVc5jm7xKSJLBuJC63fy0MfxcB7FbAD7ZBaE4fVTplmaLVdWLBQh50ZuLe1ld7
	L8RG4k=
X-Received: by 2002:a05:6214:c65:b0:8f0:5b55:1f6c with SMTP id 6a1803df08f44-8f05b552223mr58558406d6.43.1782748492988;
        Mon, 29 Jun 2026 08:54:52 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f1a26f1b34sm1726396d6.3.2026.06.29.08.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 08:54:52 -0700 (PDT)
Date: Mon, 29 Jun 2026 11:54:47 -0400
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
Subject: Re: [PATCH 04/30] mm: introduce and use vma_end_pgoff()
Message-ID: <akKVR2wNSjbLDt1-@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <e379a1cb6a897126ad96e3a263fdb91d6c11f6cb.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e379a1cb6a897126ad96e3a263fdb91d6c11f6cb.1782735110.git.ljs@kernel.org>

On Mon, Jun 29, 2026 at 01:23:15PM +0100, Lorenzo Stoakes wrote:
> We already have vma_last_pgoff() which retrieves the last page offset
> within a VMA.
> 
> However, code often wishes to span a page offset range, which requires the
> exclusive end of this range.
> 
> So provide this in vma_end_pgoff() and update vma_last_pgoff() to use this
> function.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

