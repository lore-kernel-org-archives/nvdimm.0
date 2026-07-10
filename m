Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C2C3750D5
	for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 19:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783712329; cv=none; b=X6781LUQRL0Mkt5e6Z0b/YrI1qmkEfHoX9qIUWETTVyuapLNOimL8kAJ4myz41jmNPWCWIZUuanuMcElBcQ/Q1nQeYFmH26kJcPB3r96cEikccSr5Az5M6RuIot1OmTtFt+k9IsLPjmlzIZTt2jpKDu7TAay6oNcGNDlCLmNKJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783712329; c=relaxed/simple;
	bh=93/k6XquwkESRTY8Qvhh+3gNAdxoxyU3Cel9zV++PQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tmjSUcV5PUCkMmGlDZI6fBkX1avCwbsD1lwAcOYkkJI/mSX7FWH88SC+mfVz7DhDjVftxsX/T2LATj2WJADS3+v8Vay+Gzsh3vE1CHAlUAOmSAPsTdbYEXXydBzD+XkypJYLhbp8Qj58b//U03XaXS69N2OUbP5oN0XWitbzgTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=cVuh1+1M; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="cVuh1+1M"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8f032b47e3cso10244376d6.0
        for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 12:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783712326; x=1784317126; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=68XwZpqFqsaLFsxYJLdxs3+k1PzHke/kGWmUPy80R6g=;
        b=cVuh1+1MhRK3K5pvOdw7+QA2ATUN0eS7xVBE0jQGX2d/p3FYarOI4x1u3QUY4g/b/U
         LJrPzph/5vT88SCUJnCMOm0j/UUPj61VMKdExz/BjlhaXG9ZNI/T8tmzi37KLSJoY9oZ
         XR7r4HPb3iDw6QAhhXFSNOtA5LLs0vuZkhaKYMdEtVuxcwK6X2T1ltTtwtkhgITaG+Mm
         7beaNVu3zCBxpfqwYpNox7Yr5zlc4NKh8ewyOyhAiJB2TXmniTj1gYW6wTw71vDmC5PJ
         0CoxnzqDD9n2q1lTAPojIRVIR4Hh2XKlj4x2ok9DgyjR14uQd4VQl1ee58lDqDSgNaM5
         +/Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783712326; x=1784317126;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=68XwZpqFqsaLFsxYJLdxs3+k1PzHke/kGWmUPy80R6g=;
        b=k6Kc7ngeskOnqdLNs64YVAKik0q/WfTFwtl2K7ybLSGCBWDiLip9oIsj/1lFQecdpn
         PJBYUGP58fW3Qf4+Ny93bmpdAGqOOYooUOAg8qyS/kSs26X2Behb28OXEPQeESLzelwr
         u5bDapHunRtnHSmqcKT4jeuTGBs2hsMWt7PLR1WQGRAoHMfIhwE0RqouzZYep9FOZZCt
         NMpgt9q44+WAsNSuz8ER0Q0IBnHoEZei7SsdYLiPQBRu52W7XeLvaw0S0VKwID7J0XOU
         7J6AM+UyJ7jmBDWPKbJQO6qGL8G0dMoDqT5us9hoeSzXkPEXxlHQbQmOzXZ3ylN52eon
         f23Q==
X-Forwarded-Encrypted: i=1; AHgh+RqyRcOhAkIf0HhC6ghc+QBSNorPH3vy0o2aUIGbR6RZoFxBCLb3WqEUk+tWqvSrFbtOvLgPd+Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YzUmN1uXrXnKjW9gCKwFc/4B8QvuonDucWNvCho7PtAZR9v6Db1
	/EtvsJ/4UJt1N6hfBBpWhCgtSs9mj2sa6s9IXi1gmHAGuZTePFkF0rQ4MPPYDyGJgkM=
X-Gm-Gg: AfdE7clhSA8DGThRGAQ4Dvq9fOR2JA4F7hmEq6vnzGUSnoppX3+nKMlOH9KIyk71sw7
	1eem8n3cCmZOnxFneX0K7yDTFBIOLWD1ZlLy4KrASB8hrOqCOvsZ/fICgTvusW0mHTW10tycLTz
	n8kQhwMbLT1dp35K7JEhlPxuJdM6ZV/LEZB9g5Bh1xkDFW9//o7cbPamj+Ftv31VEVkzZ/ybvAw
	u9nOnw0rZ1TzGnmnavUkW1MSnu+VT+XXE1exQQMMw+ctlGBIIPxCZ+z3Kq0Mm7EwgJYkPRdlR34
	HwErqCRhQ96J9IJsSc6EAKuXZ0xGoRPIGEUamtM9Ued3oyi7RFv0OA1Ly7Co6O6xleRkXklCrYN
	ffOP6DvivalzYKRAyMsQ4JGAghFM6qxXZcsIkaSK/O0Is6myIrD/YOPB1U/YccOZU5P2QSFAp77
	ywq28rUrlqRi4bAZBiDgeYEnUo+TtjZesp0kog8JlzuiOr4CaIn0AdBsMtjTbync6RP9IF
X-Received: by 2002:a05:6214:4b08:b0:8dd:fde8:68c7 with SMTP id 6a1803df08f44-90402c685c0mr4983166d6.30.1783712326120;
        Fri, 10 Jul 2026 12:38:46 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd87c9500sm48486486d6.46.2026.07.10.12.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 12:38:45 -0700 (PDT)
Date: Fri, 10 Jul 2026 15:38:40 -0400
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
Subject: Re: [PATCH 28/30] mm/vma: use guard clauses in
 can_vma_merge_[before, after]()
Message-ID: <alFKQOJrgiJl0p_t@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <213918ef85ed427d29d0635db6b07b15280d3bb0.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <213918ef85ed427d29d0635db6b07b15280d3bb0.1782735110.git.ljs@kernel.org>

On Mon, Jun 29, 2026 at 01:23:39PM +0100, Lorenzo Stoakes wrote:
> Rather than combining a bunch of conditionals in a single expression,
> simplify by inverting the mergeability requirements into guard clauses.
> 
> that is - instead of checking what must be true for the conditions to be
> met, instead check the inverse of the requirements and return false if any
> are true, defaulting to true.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

