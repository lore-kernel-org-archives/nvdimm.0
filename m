Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794282866;
	b=OTtB7YR2X8wgAviLM+rxZ2beYjhB5o/IOxG21W2ZQPBhmC5QVC1IXKF3eyFt2IpqAsSV
	 TLG07GE+M8cBN2PUGiL9dNWFXYBEFh7S/5FaaYiwocFrkQYP3qC8QJ4ixiE8Og5qRoSy8
	 KctHAxBGsPNrrBCo9SdfCijzyNn5QgZpzHola+s2wTYOx8BjIBdGHS7U7i0FUYxYt5w4f
	 He2xfdFRwySkHJ/bzc+JjXHiuVtwFoOorEwURh2ovLUMVt4JSHYqRLhU6msKTCOg0gZGO
	 ttzsZfdQQjcYFyJNXB/Y8DE+Eoj4mCR3xdeuJNvxBMvojpHletXuuZaVQDngi0l1pwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794282866;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=8o+szAQ34oEkzo5LUxZyRjaESjeRqlTdKNM6n0ldHtk=;
	b=eV5MbvLL4/HmCjgtmcQtdPQEklElly6+ptMLNZret3QN6FhZ0Znd2EDJcXYFYpN4aGnQ
	 uw01+8JRIbBWRtXNUXOKnXHWdcbta5OUDKmcjSUlecITF3Ab6AAcNiBvPDCvYppvBwZ9v
	 tOfPFwfp4g85UW/0Ce0/rRAEh8055A6SMljlpzSQ9T4ijn4W+sxplvFCoZHT09D/ycuiO
	 RSpZYvImn3lWmn5lFnQ71NM6jYNLI6/unxzeKEXOGrdzIo/dovFbkY3CyKZaF+UMDSJdS
	 sSbhi7hUCx5ZIXcVvd56ZtcM8Un+TwTYzU/ZA1rm38UQrL4hO1k8VXxreyK2ZzEIAIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CKlpVCtQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67ED7606A31C;
	Tue, 10 Nov 2026 03:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CKlpVCtQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663241F0089F;
	Tue, 10 Nov 2026 03:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794282866;
	bh=8o+szAQ34oEkzo5LUxZyRjaESjeRqlTdKNM6n0ldHtk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=CKlpVCtQ6mZaCuix8N8Y+4yyLAMzS5z1M9LTQKSqZxIwjWGpIvdDz8QMnXp2+mT/o
	 UO/3xeVl/r3tKUCzqS2Ojj9jZt95BC1u0IjuKIxrMvmEzePEkq5LbQB5RQns2RPV+Z
	 0aKQlWttU1jOpVqIgsHqaw8z/p70DW36WsF4I24cZfsPT58sj4LRgT3j8zXxa6BdrD
	 f1GHJhlreQx+f2SHZTlUIPDFG2e67RGYIPEUqK7a0/tWrhFaWrsHXN9in7WpXlDLn4
	 oGbsTbpq/cKgqk8faXNKz0Uz8Z5XbpqPc1hGE3pZLYGDs+VPYut3AONr2tVfhrIxSL
	 WHtbuZTFb0zsA==
Date: Tue, 10 Nov 2026 03:54:17 +0000
From: Jonathan Cameron <jic23@kernel.org>
To: Dave Jiang <dave.jiang@intel.com>, Jan Kara <jack@suse.cz>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
 linux-kernel@vger.kernel.org, Alison Schofield
 <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
 Matthew Wilcox <willy@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Update CXL, NVDIMM, DAX, and others for
 djbw
Message-ID: <20261110035417.736a05a6@jic23-hlaptop>
In-Reply-To: <20261103201547.4079847-1-dave.jiang@intel.com>
References: <20261103201547.4079847-1-dave.jiang@intel.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  3 Nov 2026 13:15:47 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Dan is no longer with us. Removing entries in MAINTAINERS to prevent
> people from keep emailing his address.
> 
> async_tx will be essentially orphaned. There has been discussion of
> deprecation for the feature on the dmaengine mailing list.
> 
> fsdax will no longer have a maintainer. But there are reviewers still
> and Alison Schofield will continue to wrangle patches for DAX overall.
> 
> Cc: Alison Schofield <alison.schofield@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: Frank Li <Frank.Li@kernel.org>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Acked-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

