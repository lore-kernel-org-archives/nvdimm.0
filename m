Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793256326;
	b=0o93dDPXGq4VHues6gKsYfJi57xpI3fgoMB13B1glI/E7QKTP7KAcaDOA42FlAGR9udy
	 f1Q8rlnjEDTFY4dcCmAd4zDx7XqC4k3+AeLc1sCy7Fl/gQeXq/IixKFW3LAAYqmRZKY0U
	 nPI1E3vKlauW71NuBBdy+3gCmj/7OHmNosk1kLCvyR6YOXzwTIy/monhdujNBQVxdqbmL
	 bCnarLGdg6DTuC0A9eSE8D5HlnsjAQS0n8IZZlGnsybGgh2nxiFXKiZjW02pudxxIgfbE
	 LLiMFtMKlNtvY+l1UUwdkdkh/QnHUyM75ClK6ScQbE5G1Zv51qgEjQnRPSLjsjvocBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793256326;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Sender:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=PpZwiOLy+qBSQ8PQ3tlsCfW6m/0pXMByVlZ/42AmEx0=;
	b=GOTqoAY40AOJr/NelTabU9lurs9ukpbHpns7jTdmb+XyWEdK88UbkdS24oIGrVKQ3Pdd
	 2Juf+oXTTHN0b21k3YnHPr1jbcmTl5ri15itu1P33U0u44i6/8yPRC8PyWXuWg1faFJPH
	 17Z2/HhnJH6Ftc54qxRqN3wrMTY97WiwxPJFg9Ba13dbmpmdFVqXBnHkBhsbUaS5o0pg7
	 gzCX6s33VQq5j/a8R9Sepe4WOPlnbUsFAJWAk1jIfMZ9QvL5KI9SRrKnKyXKl8PyF5G4+
	 06aSs3REyqp0Tg2oUFVaye82pG3IZAyZkGDd9PY1g4jzTh0pJ0opCsc1UmAn8RnkIog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hBIBqUsY;
	arc=none smtp.remote-ip=209.85.216.46
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C948606A31C
	for <nvdimm@lists.linux.dev>; Thu, 29 Oct 2026 06:45:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C948606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hBIBqUsY
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3ac7842c17dso1156157a91.3
        for <nvdimm@lists.linux.dev>; Wed, 28 Oct 2026 23:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793256320; x=1793861120; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PpZwiOLy+qBSQ8PQ3tlsCfW6m/0pXMByVlZ/42AmEx0=;
        b=hBIBqUsYpbl6/HoRKecB8X9BooUy9pUlpjrwvh4wKIQFe4YA5PBQirofHs0Lk7wm5c
         NCK2g7tbdYBxlx+xSXU5oEXXQbCYjI3lO1Oz1/Q0jEOtklaLm3X4m8uuERfckdQLKGMh
         k8rbvbdgv2lGVZV0YgJNI46QBlKNXdlBBPHxdp0ZJfYmoUuFu9+tCTzcGexV9zjPMK00
         YGKccRnOFUq3FRobvdaNrXTwdwLxuNLe7KM/PjIQu74y2nm4JtvoFv2a6x8FPc8aKWji
         iUm2YM5UgR+PYli2FkL7JCtMCmBsKuoTvK6fOyHFaklfHxH22F+uZ3HPGak2lnx0gPl1
         81VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793256320; x=1793861120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PpZwiOLy+qBSQ8PQ3tlsCfW6m/0pXMByVlZ/42AmEx0=;
        b=FZnRvRrJKr1ek8we5UmHUsTfJdMCPr+c6HVyA0Jy8ODBuSRSXOciYsHQgdsPGk5Sji
         csAUyWilefSkMG6RoUfQu8brj/rROo71V9qpFzDk+prfWKxLlR+vnHOioy3VYmjFtg2B
         paysSQ/WXhe9T0162pKvqESWcDSmeDzeJTSwohfIXCTt4ETwlykAwBGs7e+fYwcCjQrx
         x/T29ZYvnJ8gqGfczuHM/QpNE32+1w/ZhAPmbIw6iXFhsOiqp04zrUoVH9+9Xop9qgG4
         dhHtxz/T6a7D3y5CVcxhAZhClFcK+n8cmwARh7Ndokp8Rea7VfW0BYY4cX0/f5JWTACI
         IDtg==
X-Forwarded-Encrypted: i=1; AKwUvBxmYkNsOj2xfofOETbjrd3YZrUe/CcK6x/ZLrtFeZMg+TBlok+uSE8bCyjJwCjx5VcrJ5tE2m0=@lists.linux.dev
X-Gm-Message-State: AFq9FYKn/03ozXYL24pfLaCvLwgTNUtTm3sHBTolItHtXkdvonxi5CWz
	xo7MfJNHPc41frOXXBTKAGVopcxw5venF3D4PyNk4CPnGt5TYLeSaAAX
X-Gm-Gg: AYBFou1lrQ3GNdxO1Ex47JciF3WCiMmP6oKJbU7xzpgOIUr6meAAlIfvgYdzOsCicB8
	U1zju38N0Uh07NmpjtBRchUJsX2n76LbE+oGzETJ7Uszsf9UwGDOE7Q2xGei8E4+m4eVmdMQpQ6
	L52dHkI50gpiUvmLqoXhxf0ZdKLbxmwzLj0uP8FpSSSwnKs3vG6jJtPt3ykooSzBXkDniu+ozDB
	64Xj+Nj8G+wDFDmKvISx1kEFUDuj8b23SQqxkI/2sLby4kav2LRbzVmtVHq3rDUWjDRzwPpPj+5
	gdWaaAyoJATOvsyniANmgXrsBbYS3jXwXV0KR/EhZjwCuMym5WUH/11ddb3KmySj5tSx0IPzb4n
	EfUvch80VkyLKMVYlM4wYU3yzxu5/3hozRwy9BXZ+Lj+6ZKxcg7OVWDjk8cNZsUeRGFjZfemHxu
	0Ua9Ic+CpXV6oee1y3fbSJ7NJf2Ju1NUGk3m5nyon1LtoBProwfh61mORAv9UGgOzEt3hABWF4V
	8/j4jxRmAwGR1szflNpQvfDDhwuqvT+LP3b2/gUIMk9P611vg5vilSvaQNQP0YBE/LrObbJD8fL
	pL9VYhxCfHucXECfnN8AziqZ97SszwBEm26d78q8rpBXOCyp9+YS6Q==
X-Received: by 2002:a17:90b:2543:b0:3a0:e1f7:9b04 with SMTP id 98e67ed59e1d1-3ae58172e4emr3338233a91.12.1793256320522;
        Wed, 28 Oct 2026 23:45:20 -0700 (PDT)
Received: from localhost.localdomain ([101.44.96.6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e8401casm2729502a91.11.2026.10.28.23.45.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 23:45:20 -0700 (PDT)
Sender: Yilei Zheng <trilithzheng@gmail.com>
From: Yilei Zheng <trilith.zheng@gmail.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <djbw@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Mike Rapoport <rppt@kernel.org>,
	Ira Weiny <iweiny@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH 3/4] mm: add shared read-only vmemmap support for FS-DAX
Date: Thu, 29 Oct 2026 14:45:10 +0800
Message-Id: <20261029064510.17667-1-trilith.zheng@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <2E5C10CF-F3E0-4694-965C-B0E432A1A962@linux.dev>
References: <20260903122128.12264-1-songmuchun@bytedance.com> <20260903122128.12264-4-songmuchun@bytedance.com> <20261027065723.66564-1-trilith.zheng@gmail.com> <4c9741cf-ac62-41d4-9c7a-7d5ceea4a8e1@linux.dev> <20261029030511.12004-1-trilith.zheng@gmail.com> <2E5C10CF-F3E0-4694-965C-B0E432A1A962@linux.dev>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> What's the size of the roots image? And I just want to know how much
> memory this series could save in your workload.

In our setup, the rootfs is an EROFS image exported from the OCI
container image, so the pmem device size follows the image size.

Most of our workloads are simple today, with images around 1 to 2 GiB,
which means 16 to 32 MiB of vmemmap overhead per guest. And we expect
the average image size to reach about 5 GiB as we add heavier desktop
and agentic RL environments. That would save roughly 80 MiB per guest.

At our target density of about 200 sandboxes per node, this adds up
to around 16 GiB of guest RAM saved per node. Memory is what caps
density here, so this saving helps a lot.
