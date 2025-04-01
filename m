Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061D42080FD
	for <nvdimm@lists.linux.dev>; Tue,  1 Apr 2025 15:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743520624; cv=none; b=SHCl5w2z0IT6qSyeg9Pu4iHxNq/ruAMMo2GiILRTMHHFiH4j9i9UxgLzNh5I271yYqVZzpT+/jPmyrl2aYuPFWlSg7In56S7X7+mySvItatdGRHeEkaquPtbn4K8AiUyVGibLAVLWbkUVBZwm01eAT4EWFd4Ac4z8ybnLXld+BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743520624; c=relaxed/simple;
	bh=dQiiCWw0gJL3pM8AURs73NsIreNo5plvxy7k2Sp5/Ig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C7fGCHJqZR7W0k516NtOYbzZcbVVyg47jIK/H12JyqwHZmmMCOa8GU4WdKNa5pzhefpVO/uNjP8lDAubKN9xifS136mjYVq82Bp9KdN6BdQA3/NKxy6xGrzcy3F78kN99cf9Kik5c7yxzNTdEkRpNp5MDVBiM9OO4K71ILF3Yck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=pC3YkmeA; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="pC3YkmeA"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6e8f94c2698so31049906d6.0
        for <nvdimm@lists.linux.dev>; Tue, 01 Apr 2025 08:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1743520622; x=1744125422; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oMrBJmHxMmocbV+bbsiTIdh0Ur8L8QCQ53gPPEe2fCY=;
        b=pC3YkmeAgkYS2LlcAozA53PaGdKHxl+lhiVIInD+7GrAUal2xzCD89I2lI7dIqwGko
         nrSKwVQoeDtfp9ovuxMJ2ERHYew5bA1LVqorcDuO8nktnheIiZVYFPRxo+jwTi2xnliT
         gtYunhgQsMBM0RfWWqKlKuLL5UOP/JJzGFPmDPAEv57Vty0F71hGNr55VovykdaHag9q
         qqgv9idzW6fAqBjtFUWHYvK/07iCHQdSqgQ3PbaVomsGujy3GbE0r/AYFKg5jKanzq4v
         JxPOuT49KtEWaAB218Q8ypCID0ZohcCcOGynY6xfpC4F0QirK+XSva9IOP18Lxzo9PBe
         HNUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743520622; x=1744125422;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oMrBJmHxMmocbV+bbsiTIdh0Ur8L8QCQ53gPPEe2fCY=;
        b=KHJTBFlcOq6guDvzkl7erFE0KMYcCNI4xbe27fS5Xdls+QgY7WoeE0yNfTklqDu7mY
         khlXENFAUo50pN4ezijCggFcs0TBHo+KA7g7bCMYraz8b0LUJjPf3fDjoAy1NYAXylht
         n+eB4EsVX555wb/X7r1XfhHyJjI5I9uLIy7q9/ZzX45M0n69isX8nzxgu/tVjFp3fyCN
         /AjJeZ0TCiP/uZUiugo2TLIMLtO4YfNBklhJVS1tMrqdxZ6M1ZsP8IZ1DwCO/KPO37Oc
         W4wKOGVGsODS/dvJ3VV+GJtMhiikMRUNbD19EBf50hHbbIImHV0MKMJtif9jr7CtAVe+
         SQDA==
X-Forwarded-Encrypted: i=1; AJvYcCV/PbxH+QnggV608FUrlhbn0gAbcf16sy8RobGadd1y6SkqyjWTQlfVB9VEqXLkLIaPknK3NAY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yws0JfoQTqFLdHU9BiLw90pULv90Yl5yQaMSXhHXEiMVFt/z684
	LMTRgm3jd/3F2nEHoHoak+3etWlrLO6N788pdKhz850g9FFMnVPfkRXaHAregvo=
X-Gm-Gg: ASbGncsCACBMNsos+mZ+54lU9KG7+4usFXd6tUvO3IzxTXwb26xO1I868jBStO4E3vs
	xwk5V9YRCdBkPoc6X1u7FpOW7ZaQ7DJoKEpEqi++i59kj6vbdmzc9Ojxnx+tzNqta//cwREQ7dk
	j0IDIsXBzklK3CgU6RPWrcln7Xir7Rc4AOXl3m97uagJzWGHhjXRxXn1PuB+92rJBxNNeW+OmD5
	kD9ZLbBUaa1pn/GzwmgysZjZILwM+HUzAPW5f0yWwXAdndd2d1HQJznMC3zuoQfldam2pZfmfMJ
	ad/WcHEp1RojmFKU5+MX/NPt8m69GEcyY5zyJqCgB3qIUs1LyS0g65py+bio81Qltboip6xROHN
	jB9gkkSOv5U+Fg5cLgSp5l8mGYBDV3crVeLoXcQ==
X-Google-Smtp-Source: AGHT+IHIy9M0MoItUdMIpylHvPXfzLOBmJq2T30poREcLIQ7vfJ8f7SMSyY6atAj0Wc7wGiOXe7vUQ==
X-Received: by 2002:a05:6214:c2f:b0:6e8:ddf6:d136 with SMTP id 6a1803df08f44-6eed627788cmr186283296d6.45.1743520621884;
        Tue, 01 Apr 2025 08:17:01 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-56-208.washdc.fios.verizon.net. [173.79.56.208])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c5f765ad89sm667321785a.16.2025.04.01.08.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 08:17:01 -0700 (PDT)
Date: Tue, 1 Apr 2025 11:16:59 -0400
From: Gregory Price <gourry@gourry.net>
To: David Hildenbrand <david@redhat.com>
Cc: dan.j.williams@intel.com, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH] DAX: warn when kmem regions are truncated for memory
 block alignment.
Message-ID: <Z-wDa2aLDKQeetuG@gourry-fedora-PF4VCD3F>
References: <20250321180731.568460-1-gourry@gourry.net>
 <Z-remBNWEej6KX3-@gourry-fedora-PF4VCD3F>
 <3e3115c0-c3a2-4ec2-8aea-ee1b40057dd6@redhat.com>
 <Z-v7mMZcP1JPIuj4@gourry-fedora-PF4VCD3F>
 <4d051167-9419-43fe-ab80-701c3f46b19f@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d051167-9419-43fe-ab80-701c3f46b19f@redhat.com>

On Tue, Apr 01, 2025 at 04:50:40PM +0200, David Hildenbrand wrote:
> 
> Oh, you mean with the whole memmap_on_memory thing. Even with that, using
> 2GB memory blocks would only fit a single 1GB memory block ... and it
> requires ZONE_NORMAL.
> 
> For ordinary boot memory, the 1GB behavior should be independent of the
> memory block size (a 1GB page can span multiple blocks as long as they are
> in the same zone), which is the most important thing.
> 
> So I don't think it's a concern for DAX right now. Whoever needs that, can
> disable the memmap_on_memory option.
>

If we think it's not a major issue then I'll rebase onto latest and push
a v9.  I think there was one minor nit left.

I suppose folks can complain to their vendors about alignment if they
don't want 60000 memoryN entries on their huge-memory-systems.

Probably we still want this warning?  Silent truncation still seems
undesirable.

~Gregory
