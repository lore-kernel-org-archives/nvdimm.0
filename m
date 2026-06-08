Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBD4394498
	for <nvdimm@lists.linux.dev>; Mon,  8 Jun 2026 07:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780905302; cv=none; b=bVBeZAgyoLAqqQy0UNweZyBo+xKkIc/2lx+5ih6rAk5pd2dgZnTUtZSIN2zT3T7kTdyqjHtkyIP6ULAQ7sZcfe3a3+omKE00RVNMarkeJ7lX+v7HiV+2lWW1uW5BZ6U897JWaC8fi5gbB1TmrjlsOZrV/jO74oDD6GYVRktOmGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780905302; c=relaxed/simple;
	bh=vHKD4pNBVP5yFi9n1sK1jxsbPuVMP2VwTvfvDo5lkK0=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UszAT+40X+oquKhVD3C++8p/4UNLaec9pSZCtxlueSeVCex85Cetd0RfIkGYqoeBxi2HgVAxOK58jeTBnYVDtAOQ2Q68mySDVb6fgbe0nkN7IGEC3gXh+b47GG7Igw6cZBcgwFkI1wf+NHGBHG4BFQURPORbdEdZmARv4Srdg6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZxxJ+H8K; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZxxJ+H8K"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-30749947917so8832073eec.1
        for <nvdimm@lists.linux.dev>; Mon, 08 Jun 2026 00:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780905300; x=1781510100; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Lg7vHrN5N+PObzyU44CzppwiRskgouQ+48smFaUfiD0=;
        b=ZxxJ+H8Kn5HsiNhoffXADzJSkqEkYrIfKjUzRCNywYmB0Ra6tN+ZPG72gvqGTNfF5g
         fN+85pLLsikJlAEGP5HMc99UdmQtG7S+DDCFDHmSLmKjRxc4G15Rw9Mc69fvAlAKVRUY
         Ej8n5vsKsiWed5H8iFkIcgodCwoM8ziHJDRgiZT77vDitOn3vqfuSjLRwObhRu7i95ly
         e3fAov2Pj5bZpGRQ7EId0FqvHEEgggLbmW80w9SrgA1G33ZerNII3ikwfsMhNtI5ZC0K
         UXsvu71ZSH8nD5cHTYEohA+sWhdREadGUwjPPefsizhqUdPzYR4Xiud6g6SR4gtThfi5
         Up5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780905300; x=1781510100;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lg7vHrN5N+PObzyU44CzppwiRskgouQ+48smFaUfiD0=;
        b=A3o6LYnYHLcJT0L9cfybeDYd/kEXroT7WJtmCl8x8vRXz3DfMfTkmodkaJpFsG79gO
         hXVYsIdz2bsinfCfpdT2ACXg6qsn0kANGmGR8VSQQNoBN/GVJNUqlRJpiGD/yHzsccwl
         3qoj+01PucS6LEyIlA0wpOVvLzFH/axn+I7gNzt8zHnAopvRTxZEiwaoe3ojdd0Kse6N
         oMczmiQFOsC5gd086j5YSGz1SH6chGN5U7/EurY1oXMxEXFBYuTmvkx98cjKzgKF4Vj/
         jOQTkVVPD+p25Z6x674/LL2SwTpp3/N7oH2WoxSdvqLDE6p25JBIpR1wPMRRBeYuSEnB
         7fvA==
X-Forwarded-Encrypted: i=1; AFNElJ8qImDX3t+9j+q3tAjbyArKSdnVJQXbtk9QTq2MELmlkMggMHd0hJMqynhVqAU9AcQM7BkQ46k=@lists.linux.dev
X-Gm-Message-State: AOJu0YydV52EDPtpPak3L5Efp3y4Wcs4bls61jM0gndxyCww7GFWIoTf
	rAPk2OD2wDcADbPEg+BDMqumpyaT7p/AP9B1i9aiYe2ay9s2Ix4tufY3
X-Gm-Gg: Acq92OEoII069yAxewSyDMN03y7Z5/NStgVPDL4FaqKkE7SYgEw6I174JWUCIMfAvn/
	8J8CtP6RgVzt3QIQb2SE1DEpwbr1XjmA1EQFhn75UmWgK2PqQ7zl+sgTRKPoLjNoVOkW7TLGMNV
	mXR6Z50sLv7ZNUiQrpevWfIndM7TtFW/O1UEke48CtYM2c/vDgzVecPCRfhvvuIp6fEGUcqJUTA
	fsLL1y+onNL698a15OY2In3hQE6cRAAOnSwHQqedeSHRhkf0G/JPQdVMN1s6Pb4S0En46bkBe9j
	DncBpRLdMvrLfV9/JTvBeX+npmYG4oU+UAHDgznIbXsM3p+syFh8rZkjCaLaVogp+yZrLb+O/g+
	qzAB+ActsV9G046fcB/7fxbvmLpU0QuApNQbORCqj1AdYJ86mv/Wg0TCoKntWjs6+ITYoHQFfRy
	7rPrraOGFhxGFlGVf+XfxF7ONiZRB95Lqx99oEu8tksDK52+bBeX15IOsPgaZX3lv0A3Gm7yVFQ
	8uGkDIkT00etr1xq7oCbLGJkKpo
X-Received: by 2002:a05:7300:6d03:b0:307:26a3:75e4 with SMTP id 5a478bee46e88-3077b35801bmr8385334eec.4.1780905299936;
        Mon, 08 Jun 2026 00:54:59 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074db55f60sm20803983eec.6.2026.06.08.00.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 00:54:59 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Mon, 8 Jun 2026 00:54:57 -0700
To: Alison Schofield <alison.schofield@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>, John Groves <John@groves.net>,
	Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH v10 00/31] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Message-ID: <aiZ1Uc87l7qd1Hvc@AnisaLaptop.localdomain>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <aiJgBmxiwx0DWduN@aschofie-mobl2.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiJgBmxiwx0DWduN@aschofie-mobl2.lan>

On Thu, Jun 04, 2026 at 10:35:02PM -0700, Alison Schofield wrote:
> On Sat, May 23, 2026 at 02:42:54AM -0700, Anisa Su wrote:
> > Table of Contents
> > ==================
> > - Use Case
> > - LSFMM`26 Discussion
> > - Updated Design Overview
> >     - DC Add
> >     - DC Release
> > - Series Info
> > - Changes from v9
> >     - CXL Layer Changes
> >     - DAX Layer Changes
> > - Testing
> > - References
> 
> snip
> 
> The cover letter is missing the list of patches, diffstat, and
> base commit which are all usually at the tail end here.
> 
> I noticed because I went looking for the diffstat to see if there
> might be a Kconfig change. Didn't find that info here, but very
> happy that this seems to require no new config parameter.
> 
> Please bring those sections back in next rev.
> 
Will do, sorry! I accidentally overwrote it when pasting the contents
this time :(

> I did fire it all up and will post in the ndctl patch first
> findings.
> 
Thank you!
Anisa
> > 
> > -- 
> > 2.43.0
> > 
