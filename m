Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B45F450904
	for <nvdimm@lists.linux.dev>; Tue,  9 Jun 2026 15:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781017917; cv=none; b=m6aT1ggS+7kEPelCOG4mZTvJrMWaQwxSUJux6whgp12ZUPpccH9eBDB0M5Lk6983OvokFYDMz033TxpcoQo6y10o3NcY+zm5fB20WC+rNDc+s9W18TeTKnKYJC6P9uv4Xe041YSDt/FldZ0V79eMnbUC3U22tnDyakgDW6/8OJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781017917; c=relaxed/simple;
	bh=2N6jjPNXS8KHkA9ELWAn9DU9QeobkpuL9vsk9iqxtB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l3ScyqfJ1J0SKqIr8XaKp6Uz2YhZs6g9OHAsKzjlXTTUG56JfxHuOFvlkXCA/5ufnnFsYSlq9yvk91sWNrmWrgOqZdZD5YpFwMOlQGDo1YwltdKLOGzgiAqwqAJdwSSmd5p8DQjzxNXM76PHpkTcGgCczUOornxbJrlooqcCr5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=R9xW4m/P; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="R9xW4m/P"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-91562bf6c12so692714285a.2
        for <nvdimm@lists.linux.dev>; Tue, 09 Jun 2026 08:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781017914; x=1781622714; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4JHWQ15ZRzqnNTI4yBH6/uoHMgLXFxEcxAiVyb8DKfs=;
        b=R9xW4m/Pgphf3jsKvhmPQbYPRDpZPkldJ78spTv0BRWTfxfb8EfHXummaBg/MldD7g
         kSr94wJC41K/uuwYQ2JRZcqpA8XsFZFUeMXUNg2wplzlJC+YDOco2hVWzt5HSaFwZHwA
         dSUM7XPPoM13OKFaVt6bPfIzoo5O6SASlVVrfVwIwa3Q4pYrSHBieSCw4b8JubM/3+kR
         rxwURyBlsxUWrJsfLtCwb+rqFNtZP6lIKFEvZjvFNfMu63r98qNCdwfok5uHuyJo3O7L
         w7e5y9mAWD+7mKnmW1Nn1PubO5ft1RBD/OMtmmlMG4zLzRiu+MWoDrGcYyzO7zZRzgCa
         14Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781017914; x=1781622714;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4JHWQ15ZRzqnNTI4yBH6/uoHMgLXFxEcxAiVyb8DKfs=;
        b=S1Mv81tn9/0mlmslmpmKsQxnU4bZLP+gFrVY+yDM1rypnJYPPOFD7HDGPOGlvGppZP
         bjvd+m225NCfiwNq1ffZv2dx/hym7yJ7PqyjQrwXQzbV/H+T8TIEN+YRdzPpOmiK2Uqi
         oyyYON6TOOG56WqCXQGgMADkzA0c4ETvOuHT8WFa9ZQGzC9Ek/hbpRolq5l/kpbSkeuA
         j7U30ad/BALDgEi9SaQVES8i9KnkgBl6WwjMrjFRphCdc2dCbaiRlxAiyhs1WQfKllvE
         hMWGNHAwFnddEuCNaL6UO7p3zbN6Vn2gJGPCOeGhjhmayQCFlXl+p1EVUqwajR3cvXOU
         jViw==
X-Forwarded-Encrypted: i=1; AFNElJ8zsF4lTTYvIFWedvdg51wakNt5PPuvkKJ3Awz2kWjECRNJa4VA2UjpRd9lw21OIKkEbsQojJ0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzTRyvbhVOmX/RGNXVh8YOk+2i5DhT4Sdc66gjDoqFgF/X/Jigp
	yXFmIHE+WjjxPbdLznDxeQnwvwrIxmxGhPi7VwNhGa7pCBYR8k8PAtwWJBLTDCzBkSQ=
X-Gm-Gg: Acq92OEUxyPjzpcsd3dDElkCN3BwL3GTaqHGhFA5BQvFZixb5fEht3uB6HC6+WW6WRK
	tQRqh5JkbhQZtMKArhwDlv2aRDRYKXsOVZNzXlsH7TpAy7eYV8AQzanQnPCDmfCKC0y2Fv68lND
	D5qIkp9Bd7U3N9DwoqnpeO+x5XfuNtPb4hDCdZoA8UyAurfNnSGAAfK9unwOPEwELuhnRDUKsDz
	ZkQlblX7zojGmLLXajsw2Bb1KioD2gCQb4KxHWzTXXINPoF3BF4jbWnlWNd3UEGSZzJ8mEKTSdZ
	HL14Y330abUqqymrV0QQETlUfpRCsNFQMxcxEFj12wJnc/DN4/5q2TZT25DNdFenxYOHmG5q5Iu
	hfhPTkJXPrVWxGnGr1uoF8unkOuOD4U85VcRR8Ty4N63MagbmpeAU/CuAQm3kpZ60eqxWLpSEI8
	ILO3RSA5rJc3VBojA+wS6sxTN1saj6Rpm+ZiAb7AfyBWY1/fD6cFN+L/bvwcJL5x97H20iyVQSS
	uB7w+u504WMe4yxpQ==
X-Received: by 2002:a05:620a:4546:b0:915:cf88:1e3b with SMTP id af79cd13be357-915cf882096mr1578753385a.47.1781017914136;
        Tue, 09 Jun 2026 08:11:54 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a237330sm2207058485a.16.2026.06.09.08.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 08:11:53 -0700 (PDT)
Date: Tue, 9 Jun 2026 11:11:51 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	linux-cxl@vger.kernel.org, linux-kselftest@vger.kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, osalvador@suse.de, shuah@kernel.org,
	alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com, apopple@nvidia.com
Subject: Re: [PATCH v4 3/9] mm/memory_hotplug: export
 mhp_get_default_online_type
Message-ID: <aigtN28XUvHyCSkG@gourry-fedora-PF4VCD3F>
References: <20260605211911.2160954-1-gourry@gourry.net>
 <20260605211911.2160954-4-gourry@gourry.net>
 <eaea4aac-fcba-4f83-99dd-f8289e5556c0@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eaea4aac-fcba-4f83-99dd-f8289e5556c0@kernel.org>

On Tue, Jun 09, 2026 at 11:52:21AM +0200, David Hildenbrand (Arm) wrote:
> On 6/5/26 23:19, Gregory Price wrote:
> > Drivers which may pass hotplug policy down to DAX need MMOP_ symbols
> > and the mhp_get_default_online_type function for hotplug use cases.
> > 
> > Some drivers (cxl) co-mingle their hotplug and devdax use-cases into
> > the same driver code, and chose the dax_kmem path as the default driver
> > path - making it difficult to require hotplug as a predicate to building
> > the overall driver (it may break other non-hotplug use-cases).
> > 
> > Export mhp_get_default_online_type function to allow these drivers to
> > build when hotplug is disabled and still use the DAX use case.
> > 
> > In the built-out case we simply return MMOP_OFFLINE as it's
> 
> Ah, you mean without CONFIG_MEMORY_HOTPLUG
> 

Yeah i'll update the commit message, thanks!

> > non-destructive.  The internal function can never return -1 either,
> > so we choose this to allow for defining the function with 'enum mmop'.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> -- 
> Cheers,
> 
> David
