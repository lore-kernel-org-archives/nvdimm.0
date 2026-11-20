Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795164618;
	b=c+SRKl7vFCK9SlPZKxX4hfCZ5/rQEVF5dUVBjyDWXlbvgBb7OqyRuc4+qxBUiSZK9GkI
	 mpq+rZGg4h7XPkQFSBeYgOwUP4srAnZDAVIEuHswu8aaNDWlGyrGNEwlCdAWUR9e3vMmB
	 2PCfpAomtiRjR8/O3pzu0IbQlrKdB5GACMzvsU8VHGuA+nSahWuUFXle/KS7CZvj3MaHN
	 SNehTEJj5HhaNVAY9ZTFiGgGrNMNqjRdIWtpGYHbZyw6xfK9mxloDcWCEMa7c6SWLyCca
	 +7SH2DFbo6GLxGu4ywlTjk3V2pnZ+vqPsmDowBvk83MFI7LPsuHEgBOnmcvkKAMljQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795164618;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=1Ips5gNFNHVDk9WkT0yECCMeelogWLU5bZ3nsGCf99w=;
	b=BpfYAxanXeTJNSm0err3qAH41mAq6gVHN5Hwp4dYgyw94s9Mqgr03y14BJM+rQYiflr/
	 Opqe3TcdeervKKz7Tm0Sx88HXZrHM6muNHJVjrdUGwM/PfZACYXSAAyUQakTbRNRoUVRb
	 Rf8NJbGhliefxSQgA/kZDA2WXCt6cWgB6PZbGoRKl9jRCbKp0vTTlunn6ro3zsKbc1Yen
	 GMtPVUHwOGbjIfrCQzQbTXoll54uiTo0ETK8jdsfTwutt0ysRKg/7d4w8kjOfNgx56aZe
	 QPhz+b5DNrv2telxm83rA63xR88Epg5lZ2Ce4mjJMmd5SYMFEsK9A5OovNaMACeEOBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pt4gNGEw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5595606A320;
	Fri, 20 Nov 2026 08:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pt4gNGEw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39191F000CA;
	Fri, 20 Nov 2026 08:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795164617;
	bh=1Ips5gNFNHVDk9WkT0yECCMeelogWLU5bZ3nsGCf99w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Pt4gNGEwGWQFvJVbir+puWF+wd2jZCjy2k0bSCVybJyG1ho3rFwaml++4b43rbXWS
	 qmDjiMQyNrffl3iqdvXzJLm56IMTKk3ZaEZGuRThvo6DZa5CmBWo5siLNQznCXMI0f
	 2jwIdoct49Iz3uT4OLqXzFySZhDxuWTY4h3uSwBjs9xm3nk8pPrcDB2qqzFmgvIf17
	 BqEkxiUDT0rp3MyCgSa8KvfFr7hTDwaSxGH4DIyC3qSjswLm2jkiblAeu8YtOfcTad
	 MPrCbLDpjXrbCxxEb7Uxekpcli17YE4rTFJwyCxTVlrcp0zwB+hXiDLsUU86e2lec+
	 xuXJUYLuBdz5w==
Date: Fri, 20 Nov 2026 14:20:13 +0530
From: Vinod Koul <vkoul@kernel.org>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <jic23@kernel.org>, Frank Li <Frank.Li@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Update CXL, NVDIMM, DAX, and others for djbw
Message-ID: <awAJxeXEA2yykiV-@parshuram>
References: <20261103201547.4079847-1-dave.jiang@intel.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103201547.4079847-1-dave.jiang@intel.com>

Hi Dave,

On 03-11-26, 13:15, Dave Jiang wrote:
> Dan is no longer with us. Removing entries in MAINTAINERS to prevent
> people from keep emailing his address.

Can you please add the entry in Credits. We will miss Dan, his
presence cannot go away, he stays always here.


> 
> async_tx will be essentially orphaned. There has been discussion of
> deprecation for the feature on the dmaengine mailing list.

I think we can fold this one into dmaengine entry as well

-- 
~Vinod
