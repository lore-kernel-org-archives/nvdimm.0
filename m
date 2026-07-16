Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3B6423A78;
	Thu, 16 Jul 2026 13:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208720; cv=none; b=oq59Brra/sRh9JSj8giGUe9BxUiyiDe4CvziNwDV1cWqfZiDXU7+VgBlMYp6eheD+n1X0+hwWaiNMKu8g//DsB6FeOPl6BSp4qXikdIPH2eobzAlJpeBVknrmYoIU23L+wj0GCXbkcsOOQusf2aYFPr7XGFl8E3/xOtc+gUs5jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208720; c=relaxed/simple;
	bh=yS9bNunJIYcGp7pM+GGsfoUYEDKOWl8+J/XHzg82dRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pi+eLeUI5uuW5U0o/EPM0/o3U7bbmMR1vSZhYN3GwBwqeGI1vmPeTKNphyib1QOULiH25chR27bz18765w5JcDeSNn/MJPbm5C2aqzXFEFlolSBt+fqP+nKGs9SwgtFBBTR6qMkOqK2DPrcWhmCxDhHcoA8Y3jOqqSgA4e3P2RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KbqUptLj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KbqUptLj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905941F000E9;
	Thu, 16 Jul 2026 13:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784208719;
	bh=yS9bNunJIYcGp7pM+GGsfoUYEDKOWl8+J/XHzg82dRU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KbqUptLjSwHbPDnl6EODLgtr0+4G+Vr/GtLsN8uL1R0gJIbcJrT9INA5Bsp48xFc7
	 uBGW/ISebTiRPnsimApzUl9NclYX2xh1l1X4NXZZjnAeSSSFNYTRMypcY/rUhyl+X1
	 /7F6szx0dZdEkzpjdZXEZE5GDp4nGDRMG6wLJU1JgK7vImT0swvx9wF8O4ht7g3joe
	 kDDXkZm0rqfhR/CQny+02fMgaTBpKdu49C8Yx2xuJ87zFpVlntVhAzq2XjsDAJ5/eD
	 MgCdvius755vFAuRCD11n+E/RU74UcgR42ez7mpfqR5l5mHGTHiYGsp1W8i6LKucW6
	 B2mW+krILaKHg==
Date: Thu, 16 Jul 2026 14:31:43 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev, iommu@lists.linux.dev, 
	kasan-dev@googlegroups.com, linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org, 
	linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	Russell King <linux+etnaviv@armlinux.org.uk>, Ackerley Tng <ackerleytng@google.com>, 
	Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v2 00/33] mm: make VMA page offset handling more
 consistent
Message-ID: <aljdJD9TNWYCQ3HL@lucifer>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <c2fd5114-74d0-4996-8035-311ba976b3eb@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c2fd5114-74d0-4996-8035-311ba976b3eb@amd.com>

On Thu, Jul 16, 2026 at 12:03:41PM +0200, Christian König wrote:
>
> I only skimmed over the set but should there be any changes required to DMA-buf, amdgpu or radeon driver feel free to add
>
> Acked-by: Christian König <christian.koenig@amd.com>
>
> and merge upstream through any branch you feel fit.
>
> Regards,
> Christian.

Thanks :)

Cheers, Lorenzo
