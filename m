Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F20235061
	for <nvdimm@lists.linux.dev>; Tue,  3 Jun 2025 13:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748957825; cv=none; b=plW7tkQoS2q/eObQXwyoLI58sfcDn2e0SgUtX1awVfy+/PExeQuFP4CXeSHIZUhQFOiqZRKFijDKSQVlZxMAzgnWiQEFF3MXN4RS2WX1cZDY83BthfukXDiAWLHmM7EAUmZIdyfOWPtQfPFVNqtwl9nRCjM4AgrTJgrjJZlLWm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748957825; c=relaxed/simple;
	bh=MfnZO5lFJA5kphVhQXFmjyYwzPaWj6A9QLg5HcsjC6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ujYRHHr0ioAnj/GXu8Wi5KRKYJX05XnIBrzp12NVtlIZb5uCkCYvL8VVwAHO6s1oC2IchvXCkk2+fvVku8jn+Z9AFFWAyxnGwakQUDLxir6L81a60+ssEuafo5xo+qfNDaT/+ZjoBi1lRbLSvc5qBrInBgew1hknK4OA8oLnIUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=jlJU/yIJ; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="jlJU/yIJ"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7cadd46eb07so557337385a.3
        for <nvdimm@lists.linux.dev>; Tue, 03 Jun 2025 06:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1748957821; x=1749562621; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M2tOvYIRYhJ3zgazeT9iy9SxHIfkqCxujQJZWAlLZ4g=;
        b=jlJU/yIJe44QW2Y15FakA1Jy8j8rgYPOj8DxQgVW4o3hJbIyd8HEaQxh5JK4XSDREo
         AnC8A/YORbsGJiDPkEJDYqZOpegWB5TTwVsMCt5N0bsxHRSBzqYjs3jE7fvetxeEOK7F
         1jObFFkU06boaQaxroRTzM8ma5AdTvxHt56yiyWgEcAroFPjV1uDjvkWAOr+oTaZ35lR
         /1pxUIpObjh2JgqjOFbfnJuxX8Ow/tYaPg06KYwuJTsx1BBBfd5i1/RLeC+11TtXBvBV
         jvADcaUO2pgB4pr9YI71MNVRLNbs+OBMpElMsuOEkmbHDtJNI0rTZ3/YkDS8AfMRX4Ke
         llaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748957821; x=1749562621;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M2tOvYIRYhJ3zgazeT9iy9SxHIfkqCxujQJZWAlLZ4g=;
        b=L86W3U4QNcBpZMu/zXV27RSmehnNiQSh/BnzQyPyOgZZlgQntwuuCcduRnHRre0nan
         UugqjZh9lC9Huz447S/IAc0dCptUCUpu8QFaxK9UFalgC+32z0PhaZtHLf0RoyYfYVqA
         CTw/PzP4q6i/p+7/CqmcurRLZxT7oRcfhX0unCPQHl7pJV0QBaD7eHORNIEywbgMneCW
         wbsJFoRKfHl2mclmeL+IfT5MqjrDKDQFmebcUs1uWYSEruRniN9woRAAs0R9ZKY0Ufl9
         YL20qtEry+wC6VIIZ/nS8DrdubSrXqja40qPZmKNU8+sQMxXs8QRMjnOxG+ozrE/9t4H
         7kPg==
X-Forwarded-Encrypted: i=1; AJvYcCX0Fxf3qcrrcra+QzcG81rBsIIEZJMoYTArRye9HcMbmcNniSkQyG2DSxWR/EB3n/iXrZJ6DWs=@lists.linux.dev
X-Gm-Message-State: AOJu0YwdcmxiyV+0f2tGpamUXp/vpGJ+o1Ns1E/X4ULaxKD0vg/zozLe
	VMiA39TK6+zAipVKjaRwtL84PSGD4zPoP3Vxmayu9w3/fI+SqohFiNSwojwNmdCOPY8=
X-Gm-Gg: ASbGnctpAIb9fJ80/Wkq1vTL5T++Dd47y9cCMG/otrsYtBXuGMXF+J5xo0Jfha2L+LE
	v6dMEobct0pnK93b6czKe8QzbXIS2q3CTg4dks2Yj8yMeRly/ka8DTTXfmKyVjYtMmCEzSZyuDS
	aFDYlIKnZSUFDK1nJ7ocGDwMqpWvdLe1uaThjB0JhgqXGhs5CmpgHJpwtAngvL7vw5ZJ+kfDQqo
	zdtxvtcU/s6uzbFo6oRWcrv9YYpyNQEhf7P5sadmsxvhz4wEImCXQRVJykb32ap3UgM9cxQgs6d
	BV1YI0RO7ja6LS7jGu6d14q3u1Fd84el2D7tio0fn8b9pXNV2iQ1E3Gn+3r5E0/JFxKPUjaGWn8
	+dpa/fESJOIVsTdzJBc9OirN4H8o=
X-Google-Smtp-Source: AGHT+IF/1nQKKWghBymIv6kapapYp3T/T+mDb2uBcjAQYD1rkFwd/p2CMx7wy82AG8RXeUKzw729SQ==
X-Received: by 2002:a05:620a:4408:b0:7c5:3d60:7f8d with SMTP id af79cd13be357-7d0a1fb91a0mr2626422385a.19.1748957820692;
        Tue, 03 Jun 2025 06:37:00 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d09a0fa38fsm842635185a.35.2025.06.03.06.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 06:37:00 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uMRp5-00000001h5Y-2rWO;
	Tue, 03 Jun 2025 10:36:59 -0300
Date: Tue, 3 Jun 2025 10:36:59 -0300
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
Subject: Re: [PATCH 03/12] mm/pagewalk: Skip dax pages in pagewalk
Message-ID: <20250603133659.GD386142@ziepe.ca>
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com>
 <1799c6772825e1401e7ccad81a10646118201953.1748500293.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1799c6772825e1401e7ccad81a10646118201953.1748500293.git-series.apopple@nvidia.com>

On Thu, May 29, 2025 at 04:32:04PM +1000, Alistair Popple wrote:
> Previously dax pages were skipped by the pagewalk code as pud_special() or
> vm_normal_page{_pmd}() would be false for DAX pages. Now that dax pages are
> refcounted normally that is no longer the case, so add explicit checks to
> skip them.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>  include/linux/memremap.h | 11 +++++++++++
>  mm/pagewalk.c            | 12 ++++++++++--
>  2 files changed, 21 insertions(+), 2 deletions(-)

But why do we want to skip them?

Like hmm uses pagewalk and it would like to see DAX pages?

I guess it makes sense from the perspective of not changing things,
but it seems like a comment should be left behind explaining that this
is just for legacy reasons until someone audits the callers.

Jason
