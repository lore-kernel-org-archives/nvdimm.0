Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3252E2E7384
	for <nvdimm@lists.linux.dev>; Sat, 30 May 2026 00:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780100211; cv=none; b=F0osFQo+ULD2OpIpteGaykPRQ4bLREd0o2lXWGSp8S41nyoL3c05NncNzZDbukMz3oKGRZvDDIJvOy1QkJlP8ZljI0Ey0nB5eixxvX0hRb/5A7JI2dWCUmO89Esd+oBKPrjZY0XvQT41HuYduznbQRb/9C+v5vg3KufhT0Gbtsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780100211; c=relaxed/simple;
	bh=DYmADI6IP7uO7YTuaI6/QQAmwTU+7ASPKSPQ73eNSP4=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d3n+Mv7OxjJiKEGSOR9lE3TkcEVoOyU2HYhJy+lhZTudsXgWT8AMWz9/gHhxvT03xzkBfAXGl7+9K/FsAkceXexNfw+4HIcli0sEI5Zj0eZZpjhazt1bOC/kBuIGjEnSbVDX5CN8aYezKF2lZSkmST5ZyW2b9DIy945S8l8aPDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o9TW0q8F; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o9TW0q8F"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-304d7f31215so2261980eec.1
        for <nvdimm@lists.linux.dev>; Fri, 29 May 2026 17:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780100209; x=1780705009; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vVXgdiFbBmNELLJoSYJrAzCjvqnh18uX+00qEbp8DyY=;
        b=o9TW0q8FpK5K9fWK6T3bBMAtSXKiNEjxW08xOWV5kN4tpLhU6hNOobFSm/jiUnT6g/
         taV53WtyOUJOxQ72PcURegAqwDSUxL1Tv5hLzu7tX6NLrk4a32dBy8NEUQEv4689EJM2
         41+uJUdq7mWWEBq+tRId+kqiQw58kSB8Eb2PpSyAeCtNby6Vfms5dVWp4URHRxC0JnaS
         VygD0hTat8HO7EPI4U7ShwZZPFnIIE+2ai/cAAExwsDB6kzNxc1aTfOpNZ/2oJVmfBJQ
         mtuDpLZRNEA0Kvc9m5q4Sb6cdtQnGygjRyCvdMDu2C4FFH2IRtxWwkV6NtfFHYewDEr9
         NGRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780100209; x=1780705009;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vVXgdiFbBmNELLJoSYJrAzCjvqnh18uX+00qEbp8DyY=;
        b=C1WCsiFK9baqW8OvgjfzOeC+kacaAnxTe+94nOiDqM5E8qmW4N7413XTt3XzunV5p9
         K2DKkwyeXXm2IWH+gqCxiKfpjkXAvEhNtr8f1gkhuf83r/qH2OJfLoRWXxHIvVvPZaRZ
         3sEvhdmcXBIGigfKKGykhKmG3cgfDblr0tQ1Sk6Ptz+0r7BuRyMmvNCFllv+VM03e0h5
         B9qGRb1GmhO6NTDxspHaoTNoh0H2USGC24gWHqiMQdPs1RvnAJv/Vac9IRDFPfODCnRV
         NdCFMFM95WsAuNfGqqcEx7N+rMjfDVXjrKocAEGMJcqMAg4cTfmgYppt4xVNONRldbnz
         RhmQ==
X-Forwarded-Encrypted: i=1; AFNElJ/NXC3uH0Q+/AnELha8qLrcVHiZaUSIfAC1Gc7FF/TfxFKS7oUQg0k5ik8OdsaYC6Axfb7vQAc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNnuH8yMBcgNY/8QvP4G5OofbwDDC8Tvmxt0ruLP/fJRsKAV6m
	QRD9+fLoiB84u0gtjq9BsM7WnkOgdvDieU62FrSEfwjkJLxzQqtoX//u
X-Gm-Gg: Acq92OF7Gjbxdl2cJy/P9utMnzH7+krzz5xNFcED0qqjhJ/IZLBFiLQWC42CAM7kca6
	MpLGrcjQkJYrjLev/+yrCayZg+XD5Z39EGPqP+qDWEklap4XqKO2deioOxQI7B22hZ6qx124dFv
	a7vp6sFhEVyCfZfn+Yvt5fHKyS1cA/fp2E+xmp6YMCeCuSTUltSK/rauHK7MyYX3PKKXQx4dvXT
	o8YQ9ftxv7sTnu6GlWNltKEMDzR2CW52kCVZxdcxZAnc7hCF0VQY45F0dB41stC3+JAMJdREVWQ
	pJdpPZ37MWf612pewLK6Do5hnhE1lsKad2DH/8itSKuKWfhm6NLxLv7rYt0qWTGZ8kYQFuwjF4P
	eeTeN7+RMZmiS4M0UUehXstZGirvdtYr3kNUjWqMkRz2qgdgYn7HlUiv6paD8aFSOCPEunN9zIN
	jV8/B/kJbT/Dzv5MPBXEkRAe/vWWnRwZgf4ZeZnWEV5+ke1coThLZZ87J4iEilyLx8UUxxceuR8
	6MkXEa0Diov+z1FTw==
X-Received: by 2002:a05:7301:168a:b0:2d9:a799:3c4f with SMTP id 5a478bee46e88-304fa652e17mr1009889eec.24.1780100209263;
        Fri, 29 May 2026 17:16:49 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-304ed2c154fsm2455194eec.3.2026.05.29.17.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 17:16:48 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Fri, 29 May 2026 17:16:46 -0700
To: Dave Jiang <dave.jiang@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH v10 00/31] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Message-ID: <ahosbq5DgcwlBEHx@AnisaLaptop.localdomain>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <3b1b2486-d09e-4bfe-8c64-224df8048d44@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b1b2486-d09e-4bfe-8c64-224df8048d44@intel.com>

On Wed, May 27, 2026 at 11:51:13AM -0700, Dave Jiang wrote:
> 
> 
> On 5/23/26 2:42 AM, Anisa Su wrote:
> 
> <-- snip -->
> 
> > Series Info
> >   =============
> >   The series builds on top of cxl-next with the famfs-v9 patchset
> >   applied.
> 
> Hi Anisa,
> Just for future reference, I would prefer that you base off of latest Linus tags for future patch submissions. i.e. for this week it should be v7.1-rc5. I would prefer that it does not base on cxl/next unless instructed otherwise. Thankfully this series applies cleanly to v7.1-rc5 so it's not a concern. Thanks!
> 
> DJ
> 
> 
Noted, will remember for next time!

Thanks,
Anisa
