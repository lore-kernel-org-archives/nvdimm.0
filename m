Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CAB233701
	for <nvdimm@lists.linux.dev>; Tue,  3 Jun 2025 13:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748958686; cv=none; b=pl1m8TdtdhTlKE+4M5OtRcfhqA5GiAkNi66vLU6t5G5Iv1PwUkW0EITSIov9YMfDjACg1ThaRhFuvveqkzDPeAULYuzhkgfPwkbQ7m7iZvwmkbiOb+Gw0BRM/ny0z41iESNmnn0y8ZkHFKC8GCJX96Ll17Y2rugbqtGlg+sUVO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748958686; c=relaxed/simple;
	bh=DZgdvaQsVzy3FEkZ9qjIOfWCU7WN4gcYp04RM+bGGPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LxCRl7XGaPO0EYD+n+agBKQXMC81xPdPksw6WdphecKTSGax/3yZPZBFc1+IzFKGMZf1QtUjAVUPO/Rdo+ghCdRdBk7D3XGDsaiKVvm/zqILBzxqD8CBHzFRPstR8fmcFukeLkukIUtvSpHzi9Ct/OX1wwqI2BL/Ry8kfE5Cn2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=CIHU3AW2; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="CIHU3AW2"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6facba680a1so60197426d6.3
        for <nvdimm@lists.linux.dev>; Tue, 03 Jun 2025 06:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1748958684; x=1749563484; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VzY+cZCL0448RY0GID08t4arF/zf+2+XaBNqbHYkIpY=;
        b=CIHU3AW2TojuEjgtXOdP9TASuFRuULleL3soLTDe9p54M+LB/IpAK8oRH8decbeRR/
         5SIXJFFiywR1K/BKYKYt85AR1cuRQDS7ifvhzDpEmiRj4B85aqXtSLoI6SWZVsPP3+cB
         KM089d/z3SEyTpt96cG7sJ7VJGAsFf+sLuHYqqCk/zUVeQZbMX928WLN0SMHdTypp70r
         7+XwyGWcz0KCCA47EavDEiS8dEdQWZXcMT8MWSrXskPGcCUZf+FosnNPAlm+RJygpGrn
         E1FKP7BJ/uaA1sSOKC9vC21AYPzlks4VFOI+iSx09+B5feuh54Aw3BlFx1m9blFnO5wl
         r9Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748958684; x=1749563484;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VzY+cZCL0448RY0GID08t4arF/zf+2+XaBNqbHYkIpY=;
        b=gIpo+7F7eb8vu5ZX3IF6YmfydQP7AGCGIIvw/4nJrvuGBcziL0cZnzCVk7tBVr4moq
         aVe/UNwjav6fOhQVZFX0MuOrfGCwaOXur3Ya4Qj9hN+lK/txtWSrvEw5uPVnJv9IGqx2
         iLYglBcaxTB+D+pgPX+RMljQ+DQLVNiidjUsLBlW4wSKZ+XEmvkOnoWGXWsQePNfTU29
         8olwaW1u5un+4xDl4kSS5S4hBrDiDrj7/w8JEJwhWkHh58FzE8Z3117kbSoWMgcYCOmT
         z48De9KPgJ3mIcfqOyM46HKenYrt/ZIq8OUbHXYNyCP/Kma8sF1UISvnAI0wbpS4hox6
         doJw==
X-Forwarded-Encrypted: i=1; AJvYcCVbsaRFEakmBoG+7C0LsASr2Q9YPlPb6b4lqh/ms+pqM4gRewIyMQpKrnHgjwaXsC36dh2CiGs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4LTR74TOQbjFF6kuDecaK+Kquvj0dDgBzFXlNfX40dqomBYcF
	sjqKb4CA02OzWhaik0tJFP5+HLhc8u3PDJY4eOq9CDrhzvBTYZ2n2ednuWVpWT8jYimkbb0/58Q
	nraIM
X-Gm-Gg: ASbGnct5igWHA+TT7YaoshBW10BB7NzMO+9Xu+1yztya90/XskGHaS4dA/3WPET1rfj
	UdITgx8K3wkD1XryyCP7jd8NtXF0teiLBKSENHYYJARF5ieiG+X+6LUOAuBobptYbsYN5JmXkrf
	5SaUbSVE8uXXDLSYnXfik9S5X3nfvhRBx/CcbCgzgIGvJDVlwc1Tpf2uHASX7vuTWdJs3V/Lghw
	Yp68P5cZFb0K6XKRuLiwviT5l/H4UMIi8mtPT9r8SLYN0WdZtmq1Msjw1x928NjUVywVD9nLo9t
	RKu7nWTDCkSJc6p86kdvs6C223q72ZPuzCRUdPR7/RYT5rPjxJDFpzARPOdgIi3d2iXv5VDPmqg
	DXuhlaRq26XEMt8gX4fu7k4vSGdk=
X-Google-Smtp-Source: AGHT+IFvqH9ubcC6dbv0UqQGW5DGDtp+BZ9QNaQHwHo+bs9Vg0oCfSh3AzQ5xeJI5fTattmwccxXPg==
X-Received: by 2002:a05:6214:2aa3:b0:6fa:caa2:19bc with SMTP id 6a1803df08f44-6fad916605amr159392986d6.44.1748958672893;
        Tue, 03 Jun 2025 06:51:12 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fad0495cf2sm68040826d6.39.2025.06.03.06.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 06:51:12 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uMS2p-00000001hDX-3xh9;
	Tue, 03 Jun 2025 10:51:11 -0300
Date: Tue, 3 Jun 2025 10:51:11 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, gerald.schaefer@linux.ibm.com,
	dan.j.williams@intel.com, willy@infradead.org, david@redhat.com,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de,
	zhang.lyra@gmail.com, debug@rivosinc.com, bjorn@kernel.org,
	balbirs@nvidia.com, lorenzo.stoakes@oracle.com,
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
	linux-cxl@vger.kernel.org, dri-devel@lists.freedesktop.org,
	John@groves.net
Subject: Re: [PATCH 12/12] mm/memremap: Remove unused devmap_managed_key
Message-ID: <20250603135111.GM386142@ziepe.ca>
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com>
 <112f77932e2dc6927ee77017533bf8e0194c96da.1748500293.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <112f77932e2dc6927ee77017533bf8e0194c96da.1748500293.git-series.apopple@nvidia.com>

On Thu, May 29, 2025 at 04:32:13PM +1000, Alistair Popple wrote:
> It's no longer used so remove it.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>  mm/memremap.c | 27 ---------------------------
>  1 file changed, 27 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
