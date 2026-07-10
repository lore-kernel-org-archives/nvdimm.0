Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93A638237D
	for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 19:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783710785; cv=none; b=DYCC21kJYBQD9IKtqtRXKWBmUJntnZ374jyVODp6FDpXhlzjrVPFZpT2B4kwuu9QplQMM2d9ao9iyiIynbflHtU9MMlGsB7LJWBsL8sCK60G8Pi4SS8fXIdr4CuX0ZJZCcN9m7zDJmNyVG0HltftBbJqwzErDBXrdWlQ2uGrTFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783710785; c=relaxed/simple;
	bh=mbUpbN9JA5TocILiu7DT262VDuT+uIcfX8rdIywuDIw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p9Ro39ps71ArSPezMVhOq2X8TCz1FpY2LBmY6mJKxxSOiDo4ASs3GDqReD0HOc7w/2ugIP65qiaR2tE42EFe5GDJty4rGv2FhG8x2gCbUhFAqWiG1v9NO7PGQs63NAuNO+uQXMc7VrQOrR7oFma6v7nb983Ica1SQFyibGpX+VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=u09uVFdO; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="u09uVFdO"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8ff20870ac7so9676726d6.1
        for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 12:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783710783; x=1784315583; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Zl1BBUQ1SVF8WlDcAjuqmqY9e/JVxV3t5chHRhyKtnA=;
        b=u09uVFdOb4eJKC1Fz5Qsa6jdNI+i4M5bnXiEISOU48t1+0aPMVKTlHykEnSFws5XSK
         wVtM6lCWh1Hrs0SahXuvTzH7XV8YGGJRcdW17XD+Y9FlaIkjtgdfPzDERkBvib48DP6e
         lbPC53M2H8//JyHrHVgR/cOoVsgaSJVL+gbGO2BN+FLXi7YMvrA55819z9lLqSHH+WRb
         CPazP5RboldnVPptoS0wzz3tGv5GOVnUvW2k38MW9HUzHmyYMvGcMMGkQeAtbzKi7xL0
         UQilAIdMtqwzberjXqzaGGb2+SLY1hxfbTHRrbqE3BHU1wavc4wNE0cWdMZQ94l9vKlN
         EE5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783710783; x=1784315583;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zl1BBUQ1SVF8WlDcAjuqmqY9e/JVxV3t5chHRhyKtnA=;
        b=NoVNKaOd25v9NlgmLiSRUF7G0ghUDx5JndeMbLb7vXE3B878+9G/NqafmyEa4CihsE
         RfUL412UtM9YZaRGocHnQE0RrJR3BMEKp2ZnLqKkO4wJYHnZR+9QHUJvBKH9U1AJX5+i
         4cOXC5lnPg+5NS2VSJUs0SAsOoMP9TsUQG31VEQjI+TxPSJFMI8sd6eHrRy1WP8g7AaF
         MLwlBXUJ8xQDZP/NuA6coERuY4nGe77/rmDPQo06Rk6ZJBeWYgRt3mUfqYCEwWtQIa3q
         VQltwmc6BZurNydlskJ8xiEGWHb51PHNeNfKoelPPkO7QR3PyW9zb8HGC/IVaBaTGPYi
         Q0Bg==
X-Forwarded-Encrypted: i=1; AHgh+Ro2UvxOy5hOcN+IoFQ3XB3scipNVBtHcFikbyBBFANV56rhPYWKmc5YimdFqeD943ZvUzjD9Ts=@lists.linux.dev
X-Gm-Message-State: AOJu0YxQkgjk5j5czc69vmPCxtrfDoIA++nEW+k5+H2qRQsHPgJMb450
	RxJnRr4IwQE7kOxBvGT7RXFYGUGjyRHI/1axZhfGk0EtN0huDfQK12b6eVfifoG1F5E=
X-Gm-Gg: AfdE7cmxGf7FZT5oY/jl+qIKs8vK4ykhkja2wO9LilSZ0wJTq9l7sJWeqcOGWaY7e91
	LokWWKfwxdLKbSytSTe/hkloe5qjVCbUdtu1zBw8Erst8Jo6FHMOHcA/xXelBczMuzbiYu1g0RV
	kkFY6tRsXxFGk4MPgG6xajb9/tFmjYQ7776z7FfPyL13+yTsDCo2H56IoN66kAUWVrolW639Lhd
	41VNNGJueGCON82eyXV1DyaYYMMRWccjuqhF7OWXbZf0EGBOkiJ1chWoS/W2yHyAD6F8FD5TJ0Z
	ZGLf1Kz/4g8Uu6kVITdw4thsOWdAPD433dmDlutobk8keA+duAmZYWb9WuqkLCleB4suuU/dnWN
	FlGC6QC0FgPKrZsHG3TrPCoNDKQz4DdWWRNdBrYaFfov1z7s2tuFIDWjS12JxkN1nO7rSt1hWWR
	kcUVgDzvQeIXyTggmn43UkdQLrNeZYAfRouERBiTOacX8ci7loK9Z2EZvjH7CHUoQAsp1s
X-Received: by 2002:a05:6214:450c:b0:8f0:9d9c:52c2 with SMTP id 6a1803df08f44-903fe450e5fmr5228126d6.5.1783710782628;
        Fri, 10 Jul 2026 12:13:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd87c9128sm47321526d6.45.2026.07.10.12.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 12:13:02 -0700 (PDT)
Date: Fri, 10 Jul 2026 15:12:57 -0400
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
Subject: Re: [PATCH 25/30] mm/vma: update vmg_adjust_set_range() to offset
 pgoff instead
Message-ID: <alFEOTiJw2g--9F1@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <910f7b5be78232304dc7ca01cd57c6f5ca8f3d13.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <910f7b5be78232304dc7ca01cd57c6f5ca8f3d13.1782735110.git.ljs@kernel.org>

On Mon, Jun 29, 2026 at 01:23:36PM +0100, Lorenzo Stoakes wrote:
> We are calculating the pgoff as an offset, since we have vma_add_pgoff()
> and vma_sub_pgoff() available, just offset this value directly and use
> __vma_set_range() for vma->vm_[start, end] values.
> 
> We take care to update the range before offsetting the page offset, so the
> adjusted VMA's vm_start and vm_pgoff are mutually consistent at the point
> the page offset helpers operate - this matters once vma_set_pgoff() comes
> to assert invariants which relate the two.
> 

Given the prior code just did it in 3 lines of code with no special
dance, there's a presumption here that this is done in a critical
section and no external actor can see the inconsistent state?

(i.e. range is updated but offset is not)

Just think about this from a bisection/debugging standpoint.

> Doing so lays the foundation for future work which allows for use of
> virtual page offsets for MAP_PRIVATE-file backed mappings.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>
