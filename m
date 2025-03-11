Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669EC26AE4
	for <nvdimm@lists.linux.dev>; Tue, 11 Mar 2025 04:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741669115; cv=none; b=keweZ4k6uxCLa/Tz7nGLl+jBZKu/1zk3SqzZ3dS42q5hi/3hbZ5IGvNdnxMybK8AXkfkDhK4V08KqadCO1OHH7Sx+zZ4mg+uuIei3a3t16O9bJWZnehXc71SidBWUIuue3lR+n5LOIgFkU1J9JzMlByM4QU/8wrF8qZDWBY/ilw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741669115; c=relaxed/simple;
	bh=y4p+ZhQyaKnYanXotaEYWNu9zgRRUQZJKlAJpGme0rI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V8HLziXew5vVmbjR28U/3n8Qg/5TGh/aIVG+Lm4jKFhkuUL8hQQTLfefzK7icorP27SaadJg4NX0WucMY8OoR4Oj81p3nr0C/1nugq8eAgaKYXDYA4RXVf7X2fXGnw5dcUE+tY7PR+alMGBOrI+0XeLfrfj9g9Z0NIfBR0xdEOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=b7uYy6zu; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="b7uYy6zu"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-224171d6826so79414675ad.3
        for <nvdimm@lists.linux.dev>; Mon, 10 Mar 2025 21:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1741669114; x=1742273914; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8USPBO/MC/ax4XcIyiJLB9/BI0M0mqSA7MMjrt59Uto=;
        b=b7uYy6zuKhPWHhbaOp0SX1jktAEVJOp6H30TCxaPXK0gZ0fX4SHYQVLv4RsgOnYWof
         6xVAFC+4EONMRjKREWvCkNCYdkjbncd1YUcmP8A9G0WjIscnkPl9J8V6LYeJ7VlQsjuC
         CTZBommqS6cmU7q1btaDgkj55Ow5Mu27DTfzU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741669114; x=1742273914;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8USPBO/MC/ax4XcIyiJLB9/BI0M0mqSA7MMjrt59Uto=;
        b=UOfHuNGxmPM4ur6Qmg9saP1vYw4DnftLySvx9Uc35T0guKtOfEXz4NuOEAVNCDuxO9
         bmjHzupISHLJGLg1lmjoBeXR8zFpdmB72+Prz8jTFLn73hss0u/EIR/gYa8/U00/Xrxy
         CIN+iirjoed1MqPG43JJn5Fga4JBkIDNc2SlSlNIeHWw2oeLM43qYR4XQBNxzK9LZS69
         xIB7hKOoF9CHQ9B01Eif4PkkuKJmUMBP4avJkZgiunu/r4OWu2NN1C1meMYjWKBSsddZ
         9iuALDqPlaUYX0HsNqesed6t4qxQ7EYEfzBtZKkkDv7btVJReoHtMext97l/RotsBRsJ
         axiA==
X-Forwarded-Encrypted: i=1; AJvYcCWJ00j40LPbNx8ZALOxwyNRMfOrsTrkD9PFmW2UGVa4ZtLSYDd7tjp1YvCPlzcGcWWYU5fEvMw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyEQnHvFgnOCkHct2V1tYi7tiPnxCohZBZjdtpy8SyO3g14a0Ni
	D2Ngy/wxrkHOXuG22PMEfr5mqX5s0oZc32o/IC+mHE/lTisJveIpo57IqsHzEw==
X-Gm-Gg: ASbGnct6FWY2+mAgop1Rz/KQAJlngFU1Ds1G+dIVx8jYwlWV0mKAGcAxOEmKaxB5B8+
	tFYjDoyvRv26W5T2EA1As/N2AbFmbo0KJrOMvaT3CTZA2IuQb1ESEIKbH2UuDhWtHUmIWcSo7l6
	npG0GSG8B4Tx3X9cz62jRtFOKf22vTOsfshpuMHRPnvcsVmn5TAyqqZsYUiYhFMaYMiD3mGHWxE
	+umXem+AENIGNJuQlJB3nsnDeIcPcTBjogYOl52em1c2HD+jXxNjX4Qe9kur6v3AUXIUt/+rG2z
	wFoFsmdya34kTBAeDV4o/F6J1/WZc3/xV8P/UI/2Zl/vuAeBJqjqDrUPsMg=
X-Google-Smtp-Source: AGHT+IEy+/UJdnWSvGMFpDegWU6yxUJzFshmjVJEwVUQ1vPxzmyvb0Te8hk0DkXqfdh84yZ0kk8jEg==
X-Received: by 2002:a05:6a00:b84:b0:736:3d7c:236c with SMTP id d2e1a72fcca58-736aaa00c36mr22819900b3a.14.1741669113611;
        Mon, 10 Mar 2025 21:58:33 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:cce8:82e2:587d:db6a])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af281287d9esm8542757a12.75.2025.03.10.21.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 21:58:33 -0700 (PDT)
Date: Tue, 11 Mar 2025 13:58:24 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Cc: Nhat Pham <nphamcs@gmail.com>, Barry Song <21cnbao@gmail.com>, 
	Jens Axboe <axboe@kernel.dk>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Chris Li <chrisl@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, "Huang, Ying" <ying.huang@intel.com>, 
	Kairui Song <kasong@tencent.com>, Dan Schatzberg <schatzberg.dan@gmail.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-mediatek@lists.infradead.org, Casper Li <casper.li@mediatek.com>, 
	Chinwen Chang <chinwen.chang@mediatek.com>, Andrew Yang <andrew.yang@mediatek.com>, 
	James Hsu <james.hsu@mediatek.com>
Subject: Re: [PATCH 0/2] Improve Zram by separating compression context from
 kswapd
Message-ID: <dubgo2s3xafoitc2olyjqmkmroiowxbpbswefhdioaeupxoqs2@z3s4uuvojvyu>
References: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
 <CAKEwX=NfKrisQL-DBcNxBwK2ErK-u=MSzHNpETcuWWNBh9s9Bg@mail.gmail.com>
 <CAGsJ_4ysL1xV=902oNM3vBfianF6F_iqDgyck6DGzFrZCtOprw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4ysL1xV=902oNM3vBfianF6F_iqDgyck6DGzFrZCtOprw@mail.gmail.com>

On (25/03/08 18:41), Barry Song wrote:
> On Sat, Mar 8, 2025 at 12:03 PM Nhat Pham <nphamcs@gmail.com> wrote:
> >
> > On Fri, Mar 7, 2025 at 4:02 AM Qun-Wei Lin <qun-wei.lin@mediatek.com> wrote:
> > >
> > > This patch series introduces a new mechanism called kcompressd to
> > > improve the efficiency of memory reclaiming in the operating system. The
> > > main goal is to separate the tasks of page scanning and page compression
> > > into distinct processes or threads, thereby reducing the load on the
> > > kswapd thread and enhancing overall system performance under high memory
> > > pressure conditions.
> >
> > Please excuse my ignorance, but from your cover letter I still don't
> > quite get what is the problem here? And how would decouple compression
> > and scanning help?
> 
> My understanding is as follows:
> 
> When kswapd attempts to reclaim M anonymous folios and N file folios,
> the process involves the following steps:
> 
> * t1: Time to scan and unmap anonymous folios
> * t2: Time to compress anonymous folios
> * t3: Time to reclaim file folios
> 
> Currently, these steps are executed sequentially, meaning the total time
> required to reclaim M + N folios is t1 + t2 + t3.
> 
> However, Qun-Wei's patch enables t1 + t3 and t2 to run in parallel,
> reducing the total time to max(t1 + t3, t2). This likely improves the
> reclamation speed, potentially reducing allocation stalls.

If compression kthread-s can run (have CPUs to be scheduled on).
This looks a bit like a bottleneck.  Is there anything that
guarantees forward progress?  Also, if compression kthreads
constantly preempt kswapd, then it might not be worth it to
have compression kthreads, I assume?

If we have a pagefault and need to map a page that is still in
the compression queue (not compressed and stored in zram yet, e.g.
dut to scheduling latency + slow compression algorithm) then what
happens?
