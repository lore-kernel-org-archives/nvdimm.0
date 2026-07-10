Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37B73C2782
	for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 21:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783719570; cv=none; b=NeDBtn/pTVoLd5a24iDXeLS2DH8743ut0Xr7I/oPIZvb5AhYoeYXQhcThi6P6QInW2jQMjU6/rUqSlqi4lAvyY42kb6GO5kZyDdbJzR6wEyPLKDHYHuCDGpVjMbEtglQIApjmyqfGsoPAkFAlXuf4A3Cjr3rZZqgMoScycSYMsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783719570; c=relaxed/simple;
	bh=8IQ5CYx7b5nVnRm8wkAHsld3shhNHab0xIV3bA9f26A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iDvtBUHYH4YKpnC6NBOBk1CIFmswxawzpAYPECxbZRIWgTEfOy+e2hGB0cK7QXNllXlf3vuXB9+S09KR298ruViIUBcY39qGLWo0v8N8DD66qYQFS1rXYsQU8VbD0a97I2thd1q7IbDcmeyv4jw5A2IZYRdGM1HpGDO3WezvC9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=PS1+TZ5O; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="PS1+TZ5O"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8ff5d1b0f91so8300256d6.2
        for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 14:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783719568; x=1784324368; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Wb1LcvJKID9cCXN+ue8juptbLrwaSleub1+yDxtfpnU=;
        b=PS1+TZ5OUZo3PJI/8g85y92S46GPcW2n9mOsphkKh7ZFTXoiIap3tyz/KKICuoz1xb
         x3juhNfKSyAR3C38ykVLjxhE880jxPUgSTBwHKJH3Jb4GcCaFYGsL5hS7cwPDkERUAaV
         H6YDEncpKcWblx6dGywzqzlX4qpalukFCdPU6qA9ri/gQWY8G+6B+Jw/8V+FXTZxx7Ni
         Pu+meqxNUjr3DCWFLkY4iPgaI4/7YRWv6mR4+A/cdOJ8umviM5NBpgOidMWSiDaHJvw0
         J4ACFD01RfWjW50iSorrTo6j2zKVQoK9dRV6bFxR9ciR3GdtJ9ncJzRJ5LwLIYfjjGAO
         AWPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783719568; x=1784324368;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wb1LcvJKID9cCXN+ue8juptbLrwaSleub1+yDxtfpnU=;
        b=QnlgI8Wf2kr15yB2R/NUTLQ5oK/Eu0V6dz5tl2omtmp6K76L5950RedQOaMXSa6/C5
         I8hC9T2hjepeAepEdtthXLXhaj7gJVzsbAChXRHLqGbjjhbEv2IvPhYqs6yeeyNScvkX
         CiRtNQWWF7TJS9qHsInvYzYByeJFAPDkjAXKPXtE+1tJcrkEDWB/4RJatKMPTLM5rbHR
         UqzbKL1UxcyjxoahuCLJFFH4NgsdHInp0/lhUysxr8xDAh2ddWjTHtPVuAh9IEVUDrF+
         IaG0/R/AHhLohLDqcoQzswl3N8uhWdiro/RrEaHEwczr2d004CgXQhYLZfvUCvJ5KkfT
         nGhQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro13PoFXmKq6YgCIqHwqHi0eqI900BPorGXcQOvB0dPPKOchi2XS8qWPsJybi+nG5EdgM2Iz7o=@lists.linux.dev
X-Gm-Message-State: AOJu0YwNGXhfhcJJgn0MovBajkiCA6gol23bmamBBMSf+yjVjYDYVx7G
	9ZwfBo7jYeTvN3amWYzfB25e1yARJP/yWg+hwPmVSBjWV1sSVn6sZ5fXuMv/zrVp8Yc=
X-Gm-Gg: AfdE7cnGnKSOYSUI23q3EdLluFfCxleUrxOln24qRIYgrMgMQRHSMplnlT5hhIPy8EJ
	GJYZGvbzte3bx1ij1vSeeTGtQM3cisUTGwYiESCmywdQpsfGFl9NSkSj0VwWrErNeuZCoLVjLCN
	lskp3q0h7+KwBxFhVbaZBGRfYMr2qryS9Gsqe8KeWsFTQ0+IM6F6NZoTEWHh/Q1ov4G37YVYVEi
	YikdwHU439H3dwqH8bLttxE+zMQv3v46Y0I5AZUF7OXTDmVCsovW02ztr++EIkyBLuH8M74Ukd2
	msN3Ffb7kwuiw33TnbQn5TzhCd4fV6sCNiBFT8ob1754LVVg8PqJEMwvwwuOBTRebtpSZDLj9WR
	xYH5i8ekBZkPbrKONTjXMntEumva0hrF9nFopnFgSbBNnZJUuBRStooF5KJAtT8oSxF2csZxpSU
	MnJBLTnRMTQ+DQlU0Q8aRmJGQUneLYzeTMHlSXgsk3cOcRmfUFYuiOrmQM+F+GRCIuxngE
X-Received: by 2002:a05:6214:5904:b0:8ce:9cbd:b0ce with SMTP id 6a1803df08f44-90400c8fae9mr11445886d6.34.1783719567574;
        Fri, 10 Jul 2026 14:39:27 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd50e081dsm50984276d6.9.2026.07.10.14.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:39:25 -0700 (PDT)
Date: Fri, 10 Jul 2026 17:39:19 -0400
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
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>, SJ Park <sj@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Hugh Dickins <hughd@google.com>, Peter Xu <peterx@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Ian Abbott <abbotti@mev.co.uk>, Paolo Bonzini <pbonzini@redhat.com>,
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
Subject: Re: [PATCH v2 28/33] mm/vma: slightly rework the anonymous check in
 __mmap_new_vma()
Message-ID: <alFmh0sm1are2VIq@gourry-fedora-PF4VCD3F>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-28-2a5aa403d977@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-28-2a5aa403d977@kernel.org>

On Fri, Jul 10, 2026 at 09:17:09PM +0100, Lorenzo Stoakes wrote:
> Determine if the VMA is anonymous early on, so we separate the logic which
> invokes callbacks from the rest of the logic.
> 
> This is in order that a subsequent commit which asserts correct virtual
> page offset for anonymous mappings correctly asserts this for new anonymous
> mappings.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

