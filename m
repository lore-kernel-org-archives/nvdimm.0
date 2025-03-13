Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B46C2EAF7
	for <nvdimm@lists.linux.dev>; Thu, 13 Mar 2025 03:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741835368; cv=none; b=aKlHLtxCxkE8V3KLzbUur9yP5e3fbTFBeIV7BG7LZfT6naRs/O4eDNZjz1CjDazeC8QJ3sWPLymg43FU0uNddOTfym9u6uyVKSBj1Ojgb/SxnJTN48bMNQoyKkHWBuToaqDTzpJiB8lfgKhACoES28CpeFa0cgfZcduRPONzuow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741835368; c=relaxed/simple;
	bh=+WFlGMAcg1dSYyKmxTCSAfJCHc1g1MepJvAxDiPw50g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qm6086oHt4Ap31yGEEDZ3IbZfN59ciPzkSO67ihc5GP16pT1OfxS+GewYUeBGeyVQoPTxBMrUZEimShs0EbYVQ9GQkootLbr28YsRqccazKrc9EczjzLI/e6DxgEltjD+i4Ug5kVEvRNsCDSPATAWsx9TiGCWQBmWQoUa9cM4uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Z+wbRP/J; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Z+wbRP/J"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2ff087762bbso880712a91.3
        for <nvdimm@lists.linux.dev>; Wed, 12 Mar 2025 20:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1741835367; x=1742440167; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2w2NNoyeUMTe+WJP3vOV4lxBW7OxevPqpMtYOQZ7KSQ=;
        b=Z+wbRP/JtxdK8mz10t4AteL6N40o0Q+Nmf5Ff1IJZeF1EODVEttPbmaEXl+GLndLVQ
         u4Rdq+vpACjH27y+3OhCyPGU7QVIjU4nHxEgjNQF8G8NZj/AQ6ELN9m7BmzIqnKc2D+Q
         n34REXY/3RxexqRzwQ0EwpOqJ9o6L71aKyE4Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741835367; x=1742440167;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2w2NNoyeUMTe+WJP3vOV4lxBW7OxevPqpMtYOQZ7KSQ=;
        b=xAIuieQkQLOGHU9Uu+kbjGNvpsZoLbwGZBCcdnOtdv8n//130bffU41mr5RKaaebG5
         jfW8CjA8b8cVXFgTY9TFBr90WXTnottJ/ClHGMKLKjc+FqlI3qpShHYevzrFMXC7t4U0
         0AAdU5wGZFLyXpIeeKhfnkxgX5TuqGlNBFFfnxNEGqWBb/548c14iQodhp8gGvJKwiXC
         uT3OaCzlUGsHvDOhG0Srkaxp5LCWOEY6vm0OdzShklowE1JUtVwPM8wpQ0nwYQgL+M0F
         qqi1IP5vQwaeXJQ0UtfWSvfaSV0mf6G7cO+HVz3r//9R5Y57X9Iob0iZWERVHHZy34Ez
         +7qA==
X-Forwarded-Encrypted: i=1; AJvYcCXntUKmsgvqebJkMCsbslfJNNt/jlkp2gUkIpsYw8uxTLA020fgRnPpTjBP3RcXEdFEAu8VPsc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwCvC25GoTHL+T28WlD/0ogy8qg2OPrysfrCqS32RoXPsBc7K7n
	9ysGifNk2LLFkYQjuZwZYQfZdmOjX8JWnindEqo7pAOdHpDE2AReqF0muG4pJg==
X-Gm-Gg: ASbGnctxEWU1oRAPhcy8G/OtqQAjSR7Dv3yW1Kw+tk65tkBE0WbsZqBo9xLkQ4+bmc7
	5neUqjRg3YevRctCSPeI7vOPK9uwanl8DQRKn8nVyDLQM08ZBqmqNXuh0/GbgYQz0j8T1gZdM3p
	Sm2c7sfFVvyAQrNEqIeye7DlP852JGpO2M0Aknj6n2kyh6TFs0C4QTlM2gt93WK+m4+AD3RfCH2
	03+O8n6YFs9MgmuCCQ5vCjmbLKpFIFcVvYcL6LjCavWJCKwWXUhducZTbkikZpUQSTMrZAj/83p
	KZcANXydW25b9inD4EHL4/NUoP6xDFjIUHhCI2ixLZDKvoo=
X-Google-Smtp-Source: AGHT+IGFWO2nTLQPYrZdNHWAUjr4TV9jgOKxZGHY6bU9yRm/owksjVUBeXx/Vr3GQFVpil54DqonnA==
X-Received: by 2002:a17:90b:2f4c:b0:2f9:bcd8:da33 with SMTP id 98e67ed59e1d1-300ff10d6d1mr11929540a91.21.1741835366628;
        Wed, 12 Mar 2025 20:09:26 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:ef7a:848f:3b9:98dc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301302a8995sm848639a91.1.2025.03.12.20.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 20:09:26 -0700 (PDT)
Date: Thu, 13 Mar 2025 12:09:18 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Qun-Wei Lin <qun-wei.lin@mediatek.com>, Jens Axboe <axboe@kernel.dk>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Chris Li <chrisl@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, "Huang, Ying" <ying.huang@intel.com>, 
	Kairui Song <kasong@tencent.com>, Dan Schatzberg <schatzberg.dan@gmail.com>, 
	Barry Song <baohua@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
	Casper Li <casper.li@mediatek.com>, Chinwen Chang <chinwen.chang@mediatek.com>, 
	Andrew Yang <andrew.yang@mediatek.com>, James Hsu <james.hsu@mediatek.com>
Subject: Re: [PATCH 0/2] Improve Zram by separating compression context from
 kswapd
Message-ID: <5gqqbq67th4xiufiw6j3ewih6htdepa4u5lfirdeffrui7hcdn@ly3re3vgez2g>
References: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
 <Z9HOavSkFf01K9xh@google.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9HOavSkFf01K9xh@google.com>

On (25/03/12 11:11), Minchan Kim wrote:
> On Fri, Mar 07, 2025 at 08:01:02PM +0800, Qun-Wei Lin wrote:
> > This patch series introduces a new mechanism called kcompressd to
> > improve the efficiency of memory reclaiming in the operating system. The
> > main goal is to separate the tasks of page scanning and page compression
> > into distinct processes or threads, thereby reducing the load on the
> > kswapd thread and enhancing overall system performance under high memory
> > pressure conditions.
> > 
> > Problem:
> >  In the current system, the kswapd thread is responsible for both
> >  scanning the LRU pages and compressing pages into the ZRAM. This
> >  combined responsibility can lead to significant performance bottlenecks,
> >  especially under high memory pressure. The kswapd thread becomes a
> >  single point of contention, causing delays in memory reclaiming and
> >  overall system performance degradation.
> 
> Isn't it general problem if backend for swap is slow(but synchronous)?
> I think zram need to support asynchrnous IO(can do introduce multiple
> threads to compress batched pages) and doesn't declare it's
> synchrnous device for the case.

The current conclusion is that kcompressd will sit above zram,
because zram is not the only compressing swap backend we have.
