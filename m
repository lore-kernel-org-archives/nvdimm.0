Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD643B52E2
	for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 21:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783718222; cv=none; b=Vv5kqw/eEYDAU3fBSTMZCxpk7FZxVXNS5pH1efSRAN05cuegczCHLrdHikJ0e1lpxtZa4lFR875nDL4L8xTZk3+7gzy29Za9Q8fMEOlSCb4rUFxqU8nLXJZdaEoJpDwssqyB89NmynwT+LU6IUKpSI9IA3E+lXJTyxkctkxlQ+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783718222; c=relaxed/simple;
	bh=5KPNhmwijDAsBGeZ64JTaNX2be8iS/2XlIFbwRyt0OU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rsXvmAOUINa6sRR4XDdOYrMf/bjxV/CS0DZFEGnNuSvYAsDD9F1ERFzp3FMLezhSPx8ssD3+O4cDWmXrVx7eUdAV1jefIX+k3KQgFN4tNBI7L2UdPWNGncym7A3tnXkQ09URpAh08WGiezggFRMB/yuuUPws4iPe9UDqsUg8T7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=ZD+xd7nJ; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="ZD+xd7nJ"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e6a434cabso71485885a.1
        for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 14:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783718218; x=1784323018; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Izor2xUYDxPFma+uXVb9laI9dziDM9wo4fE46zQgxzc=;
        b=ZD+xd7nJ+lhPLJK2MGLC6laAodd54pYiKGk9wDglrZhYZbNlnIbjuEgsRBQhBae0P3
         ChxzEpHmemUw/k9/fRlbU7GRZjfcROlGyYdRyuFcBlopR5Qe22urenPqH3wMriYy/2oO
         2FeU5ZgiR8elwUk9c55BFTwTOvq/2SrW7E+nj2CvhqmagpauTvut6FwYr6ttgqYugo/L
         87ruMxAeykupvs53AokxASmsvsFSCqrdKV9ebRE55TIb0eyfst+Hc1+sxgw03Ptedtya
         habm/AmtLTP5aYoQRyL5ZIA03rbEHRXYP6eXRR30fFFHsdd2IjvTWuoWalIdvVkEtUo7
         mDuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718218; x=1784323018;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Izor2xUYDxPFma+uXVb9laI9dziDM9wo4fE46zQgxzc=;
        b=W+ZkLDUG0GHqYVqNDO+z9uFzsEkm6OkvcONCRgbU+p6sesrhcAp88VEAtFlbVDzEkg
         i/RoCRJH/C+ExmRk+PtIILR5PS5IjTzZ8UWfxOzCcRFhxkSV8vkVnr0HhVEDTZdVG9bD
         tmqJa3hXFT2XnZiQj+NOaBMgRWZ4PRpdBN+YofNLPr2LwhJd/dAHsIOrBQVn6ozGBrfl
         FwqxmhKJAVFw5P5YJJHFeQi6291ihCSPxAZpzq9gfGmxsuMAeSaJS+acOgmLkrsVMy6p
         /DhTV67QsfOqmO1WvMz5BSvaOen7cKz/s1msY0S2k04ZY/zneUZhGn/6BiYlR5bqAqsp
         QF5Q==
X-Forwarded-Encrypted: i=1; AHgh+RqCxThtitKFGKnPnih9Gyi3BZyxj629nzAcJFEmG7NFxbo6jMm1boan6MStYqxjBObu5AZ4SbE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7X1C1LRrLtNXeUurnS2UGv1zPLbjRuMYE4SYyiKJzDUO04Daa
	xyP3rmhEzyJ/Ffkny6j4Y9/2DyGo2+M3L8MB8lXVkcKNfvcxrH4HLStz6fsu9+sId74=
X-Gm-Gg: AfdE7cmhEkOrNxPKbLXQwgqPSszhehiC01YAawYWp87vbPepej2lio6Lq9DAVrefqkx
	UCvRKIhfYTjRcBd0K6FOZVcOQHwGRB96eOdqpIVrrT2+fTqi20Z2qYjZiAzRhcfzfUjqTFy1brI
	8S0QbWxHwjECh4QXKUpHKpvm4QyOHZ7Dw/8hqdf+4sBEwIMsneylTRN9SMWW6fU2HMralNN+xo5
	CCnk33coTS/mtlHZvs/14bp/tpVF7vGVORnngibl2TGSvcIgd9CHcV//4pJUAQ0CRVo5U0RVDsV
	gzv9jDHCvS6kmhCHYBEdQmrioV/7e1qrqG5Ke4oDr0kjc1OQbiX/ryymFpDFHKurL0w1GDp8Nja
	EQN/TrzX/9LQ9JcA7wBVEWDJDeD94SSPTJTUxb6W5j8/1dovbWyQIMG5IMbOHumoyyJYIuwP17E
	9qQQxu0nb6b31D/hVUalRVBn0Uy21bLYXQX4aXsagHuqTZIfW93pQf6yVOGHg6EwbJgtRd
X-Received: by 2002:a05:620a:2691:b0:92e:72a4:f290 with SMTP id af79cd13be357-92ef2b3518cmr83584585a.19.1783718217777;
        Fri, 10 Jul 2026 14:16:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd80fe218sm49983646d6.33.2026.07.10.14.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:16:57 -0700 (PDT)
Date: Fri, 10 Jul 2026 17:16:51 -0400
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
	Naoya Horiguchi <nao.horiguchi@gmail.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Christian Gmeiner <christian.gmeiner@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
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
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	iommu@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
Subject: Re: [PATCH v2 11/33] mm/rmap: rename anon_vma_interval_tree_*() to
 anon_rmap_tree_*()
Message-ID: <alFhQ71-WGGHo1sJ@gourry-fedora-PF4VCD3F>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-11-2a5aa403d977@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-11-2a5aa403d977@kernel.org>

On Fri, Jul 10, 2026 at 09:16:52PM +0100, Lorenzo Stoakes wrote:
> To be consistent with the newly renamed mapping_rmap_tree_*(), rename the
> anon_vma_interval_tree_*() helpers to anon_rmap_tree_*().
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Nice.

Reviewed-by: Gregory Price <gourry@gourry.net>

