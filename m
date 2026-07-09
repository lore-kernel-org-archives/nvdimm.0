Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3740E428474
	for <nvdimm@lists.linux.dev>; Thu,  9 Jul 2026 15:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783612250; cv=none; b=rA8K1ME/kZTeXx9K8ZOVA7RN1hOCXonAOxQP/s6a69pznrn8+VwP6BTk++4bxKhjYV3aGx1zWU62Ud1kXj/l+qzLDl3bcPUTvMJdYSMoFSAe/ApLVH9HKAnlFeYs2reXUBE8eg01r9QUTkWG8IBjcggK9URZQc/kmTzegELNs6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783612250; c=relaxed/simple;
	bh=ooFqL0kdzm3Mqvprf/ktKH8mQbzOh+NePJH/rGI4MOY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MCdTxCQrqE06XlgfUqTCtxYshT8eK6wVLBthG7ePiz0sStG3AyxCxwyDRMyFFyM/cNGjwZZVURKombZOznCx9ItxcezP42VHoQWrbcW7eVBii7Ir8z4Z0H+D//TGYTFiHZ+vnibgAwqZdzjOX826OC4f5B5yF+Qa7U+3RtifZrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=L/5sxBSZ; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="L/5sxBSZ"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51c0c45c580so15065431cf.0
        for <nvdimm@lists.linux.dev>; Thu, 09 Jul 2026 08:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783612247; x=1784217047; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4H58DRU6wxIzBQ0PfS3OOFxFy6X9tDniNwjExlFI+ak=;
        b=L/5sxBSZ0ntzw1PPGdgtogqcUemzKFMUdkbeYGjGQG/pk8vhYEI57K+y9mXPavZxCG
         8cWIKiq8fX86SUuuhCS3XG0duNHMa5yXhjctG8X1nJLDxgiXIMgYGrXPi3H8s9ELQH/F
         F7VeoiMdJCzD1Kzk+yGUhdqgvizPF8FBBwXzmwe4uAZeyHmLs+keZYDCYoVzptEFdB8j
         Sb0hYUR4FWLcbJ5bM3zstPWb2gomBwTE9J9OLhYu9JzlYjJtzwvBi0HF4YynMxux4gQk
         5mRL2cgmsnrRiC4LWld0rYNf73fxWkB9SxLqGCvOn+PLve01pDrxsaCrLS69bReO9wdC
         4spw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783612247; x=1784217047;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4H58DRU6wxIzBQ0PfS3OOFxFy6X9tDniNwjExlFI+ak=;
        b=lsW5g9rAqKaZGmFuBfpJEHoehyfvBjPyQeGzCzwvWZzwYkyI0F6cQANT2onFJId67i
         tuqxdG+pl9Wsg6eEkPZ8yeo+vSlYX7BuWHCfkb7NjL7takfDb/S8sEKBgH4ghsXwLi3x
         sDizBiuybKIEH3qf1Ev7uc4mgyUJ3SM3O91KxPB86z/Z+BRa0OV6RopjStc9TILkHFyl
         5VEbx8/ZLp/ErFyxMmT8Texk5GQawQGCwzQsYAzHuXNgvPsrT45OefTL3zSpP8GQLlKl
         YOrmhCHoz0aaMGk9hM8hubNI9gHvH7muAEPVQHowfKJ9TPUB+3NCGLd2kTfOGisS2jCQ
         Mb1A==
X-Forwarded-Encrypted: i=1; AHgh+RrC/TX0D2hYY93RnWlAhewUqsUCIzDdL+ss2p5AE2w5Mg2JD2ik7SnFxIUnMkmyKcFRKEQLC/Q=@lists.linux.dev
X-Gm-Message-State: AOJu0Yytk3q06ptdPSWkeN3eMeeR7AkwChseOIcZnbBJsON7WPSmQzUv
	wNAbCwIBFlTBOX1qvBCoZI3skMxgb/KlyUcMyZ3zKWiJqH503bYIRIulqdIuwqkvKfE=
X-Gm-Gg: AfdE7cnq+F0fxqysT8OPVuYKZHfwJl9hpDgzw78pA980jT+kCrjQJdfbcH7+ynTOkbv
	rl71RBPKD23eBEyviw7JzMZD013aoeolZPzOgL54OtM6IfjQATK7ept5Bt16092nUSE9eKgkTJR
	syaYEX4HOD22MHJDtm8MkD0fVF/x0Kpl37XctOdnocc3mirIlFWNIcW1srSUt4GDmYxTK6Jt1AU
	pHmytgDvBNZafXYmMD4RrdBnRhXvDnKlHYQRiuNp5je+GiqhiQuGhjQa6v4RCytU32SYJx6m4p2
	XcZ8615tqpYFtXT6ZHuemYgoID0J1/ox2Ii0AwsGAAjx6dtag1nxH2JfTAE+P/3THk8jidtvbqN
	qIw7M641d3z7W81NdPXN4xML+QoO/ag2AvWFQcPivqUhlq51Od/udpesiMSCynjDSMDEOFz3nIk
	is/E8WF4zLlmNvhUBPiS5YmDplIg+EDa68clyogNbhFDP4+5ZtmrUgml5OLkfJi9gClB1v
X-Received: by 2002:ac8:5f0a:0:b0:51a:8c9c:7f52 with SMTP id d75a77b69052e-51c8b40a675mr79940341cf.69.1783612246884;
        Thu, 09 Jul 2026 08:50:46 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51c4202366csm161049781cf.30.2026.07.09.08.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:50:45 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:50:40 -0400
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
Subject: Re: [PATCH 18/30] mm/vma: remove duplicative vma_pgoff_offset()
 helper
Message-ID: <ak_DUDt-1tb-V3b2@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <10671c2fc5d0dd4e3bf497181923e63e46053df1.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10671c2fc5d0dd4e3bf497181923e63e46053df1.1782735110.git.ljs@kernel.org>

On Mon, Jun 29, 2026 at 01:23:29PM +0100, Lorenzo Stoakes wrote:
> This is doing what linear_page_index() does, so eliminate it and replace it
> with linear_page_index().
> 
> Update the VMA userland tests to reflect this change.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

