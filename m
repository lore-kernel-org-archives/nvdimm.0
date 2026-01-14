Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEEF2FFDD8
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 17:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768411719; cv=none; b=hspZ4BgFfLNkSejCJG3DgkweZd4u3WgNb2v1JkfCOVuyerl/L26hDZ8LkjrqwJlBLAXFdVRK+7U8WC7rVBKqMblwitaKg1AuuRdOwPQ+PPdtx2Qwit3SZ4cYNcCb+IpoXxs/DEpUshivcR0+vfeVY+ZaMzqT3bFhDxf33DNbNpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768411719; c=relaxed/simple;
	bh=pn2FMj69xGy0y/5Gx9Y/UeewmmSegh4/cOxhPfcbyl0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=utvppCcLWvtHEosse2D609v1AHeiqBUo2JJ4JVPf9ym18UURZtemZJzb9oEupAWC/2tAQhOkbb+lV6+u/TXT+cwLIjmsyhb1TnH3VWlJ638eFJ+9nRMeM83Q+o+2cUaswl3rpdKPnfqfKqpM+W3b3+oRwMkYONEGhb88xzAeT1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=eemakQNB; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="eemakQNB"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-88ffcb14e11so66626d6.0
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 09:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768411715; x=1769016515; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M8gk61w9S/yjYbnW7IJJtdpbyzDzV71vvh8bvL1b1DI=;
        b=eemakQNBt9UrcG/hDW7JI2pfJ9CnuUdl/Ahor71Mp8/PamVJ3WdsW4jPZXfBGRB4Te
         cnbAoJj6e+z0ENTvqcqNQhInlxGanRo1y19pS5oVgQhNLZQ/jPHD15o5QtIXN4TAll8M
         gG53SycpOmESoQzIhAscxoDupB3dty6uI4ra+y6PCdcNGnX3KbpTJaHPXsptiagJqk2Q
         hK1wlUiObtFlZajffRpY8z7eexQrf8FL2aC13S3CBw/p4wMIJYQWmFgw4CboaH79M87r
         fKFZdJlSYjaHLqscS+fx156gi1UJJ0qVEmJhCqbu4iwxbn46tHkqeQEjHJLPIENY9ezX
         sDLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768411715; x=1769016515;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M8gk61w9S/yjYbnW7IJJtdpbyzDzV71vvh8bvL1b1DI=;
        b=mEO5Q+m7LODSPfOHd8kcL5X7cvq7Ka2Rquxzjb9TB4gp8d88kYiHFBDqp6mcx8+J+l
         YkQDZHIn6XalP+7Gw0WBy9RGhA58oHWj1HTZ8IWWg280VoOH+cXmbBsGM3ct4TWVIrGn
         kVHmXzVtmDQzS0qPoKpj7A8mu9ZPWdGm22XmEUpwfzAOFJ0Z9g9dUPRpejV/mir5XsRr
         KwxNMmkA9Sya4Rq5CwBsxWjkbUEy/KOlrW7PCcQjCmDeE/PFr28lWWeCr6f+JQMpzfLe
         BsR8NLVfiYCUFdhxM2wl34vdpDvqH/cw6NwrPDt3v2XonqZxnfMtrbX6ihanQkiKRit7
         Txug==
X-Forwarded-Encrypted: i=1; AJvYcCW6irR3ZAb3rAZHAVs5r74bj8ESgxCdO3e5z2U+OBovm11IwyTKBTLiaQCkJSS2yslluByTYLk=@lists.linux.dev
X-Gm-Message-State: AOJu0YztgaMBANfy5ZVCMC3HYG1h2fAdRknYPYeQPMdIGX5gJm6/CxF9
	BtxpL3mKjnS2nV5lw1XN9h1OkcOJp9TeL1EhG3znJCAcOaCSDW5qZiaNwWv5K8Ng8BscjCPEkSF
	hO7SMn0g=
X-Gm-Gg: AY/fxX7i10nC/d/rUtWSUCQihql7iILSy2QQwnI9UhJRFW1OallBdYuhrEbPPwfVmsb
	suUBDzTIOEhoSwUA2mjnio7ClKWpKqUSz/rQhf/krLyhwesSgco39pB2JTBuqgrXEUeVx3uBx3e
	M5Do7qCy21ro4j+iV1oRqEZ5fvH7CXiRxhjaH6h9ga6P614miFHlEQ+JO7FBpBy+59TNpusE8bn
	uvWbw0iqDVSGCSVil5BBRmz6LDZJ1Iyxi68DybNMSSnV8wIilPBcF4iiPHBsjnsSn/X6Dlo5vxo
	NSaQwrNFf1NaWMoQ269Kllo4mbooT69ZM7AdCUrQoiZDITGoJlSCnT0NojtX2nidYa/MSXu4cBQ
	U7+6DcBuXKbGkp5gkZezDc1Nvq1NrHFRyM7ktHhVhz21r9UOuqhqMUDAmEWTPC0IRvjdqhPy/RY
	fzvHQ78BsPP2/xguzR7ygpIjO279/xahjiunp8Y6ImKOpfFtr0nIXDLlz5X2OgzbLWPXRrDg==
X-Received: by 2002:a05:6214:f6c:b0:87d:e2b:cdf7 with SMTP id 6a1803df08f44-8927445388dmr42459046d6.66.1768411714702;
        Wed, 14 Jan 2026 09:28:34 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8927a07c731sm10671566d6.34.2026.01.14.09.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 09:28:34 -0800 (PST)
Date: Wed, 14 Jan 2026 12:28:01 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kernel-team@meta.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com,
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com, osalvador@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 4/8] mm/memory_hotplug: return online type from
 add_memory_driver_managed()
Message-ID: <aWfSIX5lRqb35yUf@gourry-fedora-PF4VCD3F>
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-5-gourry@gourry.net>
 <6a9db6ff-2fe8-4be6-baba-7db7913898f2@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a9db6ff-2fe8-4be6-baba-7db7913898f2@kernel.org>

On Wed, Jan 14, 2026 at 11:49:19AM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/14/26 09:51, Gregory Price wrote:
> > Change add_memory_driver_managed() to return the online type (MMOP_*)
> > on success instead of 0. This allows callers to determine the actual
> > online state of the memory after addition, which is important when
> > MMOP_SYSTEM_DEFAULT is used and the actual online type depends on the
> > system default policy.
> 
> Another reason to just let the caller handle MMOP_SYSTEM_DEFAULT itself by
> calling mhp_get_default_online_type() :)
>

Yeah i don't even end up using it, this is just cruft from early
iterations.  I'll clean it up.

~Gregory
