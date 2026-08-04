Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6591846EF88
	for <nvdimm@lists.linux.dev>; Tue,  4 Aug 2026 15:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785858340; cv=none; b=uwqnACfpWoUnLOFPg29ooEsbstEVFAytp1zBRn4O8bjrgBmI4uEhUAm9apeDKt8u0XCfa6WoevEeBP09x+I58tLUlC0zXE6mUyWE5W6S8/y+ADBab5ymO09pTY7QT99alhQYKOyGOAHoX/wIuMheXdGO6jhkGfsRUP3acgeHUI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785858340; c=relaxed/simple;
	bh=pfBibOOiLte/EX/+qle7mKZzjGU+fpJrKO2P1AlRO5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OKyuDpE9xwQ4jyD7WXCva1ZQTSr4ITOtOKK3Po+gOIssIPrbKyCokiVB3/hUB1cmq/XhXUL1amIuqPn+wsaY597GBKixg9OxF3xCORYw/S5GSxR+OprhXfVm6ChyL0FPgnXq7ay21QMHbH6qsv1vGKd82kWWnJi3JbwdvYOkZw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=EWVkA/rt; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="EWVkA/rt"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-934a3d14924so307730085a.2
        for <nvdimm@lists.linux.dev>; Tue, 04 Aug 2026 08:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785858336; x=1786463136; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5hmIhzrJ0XGT4baK5fEbfCbo8T+vTuWeZjg9ljZYg7A=;
        b=EWVkA/rtuDZ5JsR0bsjOS5MQEhTtwgPTMomywfxS5eHIZ3AHNinN/y7VDe00Si63w+
         +MzFyE4L9mYXIM8qgAFQwwFydK7Za3R5T2Pqdbz9Utc2ecObXwjx1ZefD+2PbNzcj4Q7
         iy1fvm/3FKpa94XmloM2/flRMjJ3DvMKONO+7kS/1kCd3BJZo3GBT21tbXKPQNkxC7RW
         frQuGbKSUhuigiPn9eKbp4YICiZjZW3O9BVA8qYFX+NnM9TwYqMAOmNZ/28/Y/Zrf2GO
         /2oF1+ZFTSTcVT7g5GC3BQTsusBQk3B4GbVqeRmH/eFSCh8EI+mSKqAdLCwiTm18U5gG
         TIcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785858336; x=1786463136;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5hmIhzrJ0XGT4baK5fEbfCbo8T+vTuWeZjg9ljZYg7A=;
        b=mD9VTwZ1kFIDngskOKR+rTfXch9WrUf+X8BBQMIxjFFgzr9xasIKkugtvKv7WeTY3N
         /ev/bCNlSrNhwERZtZciJjUPwcPGyCbL2e0cH7I809bKIJaXNft4qnvR+IgfIq0u+ER5
         +YjEyo8SO3zjLKxHNV488m9uJmYVCnlzoWFR8mdrAAiDiHId3JZAMteANgL2mLktAXw7
         eCaByeF+rKsgYX+/nmPZwNrZO21n2rQtV+enlv0ThFXwbGo/ads40u+IIX3jGdhW8ein
         0/eVoXdEnD7Y625NppWsbcabaQ8RK036rKpwupziaUUEjyhmpyo1gj0/80QpNie1tN74
         nM+g==
X-Forwarded-Encrypted: i=1; AHgh+RpZowqrg7PbTItMY/DnuWa319cXJduHs6o1JoyFhfjMluCh+pH/RfoSCh4TmFXE/YUDh7HP0LA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxrVWNFYlTFucVLbgTqk87LuC0BtYo75eayDqxvgHkkgmpAS5MW
	VOHEdl8iGEsMVMxOMFzDgBRXnRCMSDvFrH2/L9M18kujibs+00bTzI9Ca+oSOUYI0qPGiY9f3wz
	4EboA
X-Gm-Gg: AR+sD10/GBXeyDiilNRqvmfEgKf2lAl1xVRizxXfVy6/iawEGbaEfvLuaDiNSajBT0s
	y3OvkvCA062aciSHE43wzkRARG5tw+xXpeTMtIYBSWK8MSmgy3b8qQR0HM+LmsVNIftjKw4oVAv
	SH3dfYFP660bBSXRB8xGDKa2y44QE9cosewULUVsRjcXqxGvGKIuhyrd8IL5e+WfQX0qHlp8Qgy
	YapSlKs2OJ+FHAG7nt+ymHYGfLg/I6SSRXrc/uOx2yCZrobsISyUqi8+NRzYyNhoj77AicoMYwt
	pzTjhaU0vfQWGQQo1lRqTmyKxYDRvYzdgqYtG1ulPlIpCkY/s9Fwo67UA6o1qDQu5rd7BgvDotb
	Ol1gJQ2z1kB+GeezlgZFpQp/PpF+eiEti02RsITHA1vmqoSXScaJ8YTrdfwCVHPPTKggBJaLUB2
	DVt7msGJ5KXQK/ZOHvYBSgNbPediwwkZKkw5BWJkExMSuwtlIUc2gBM7oa/nPOQU3phjyKD6oB1
	IbBqEDZIzQ7P9u/MEoJWYdGtibtvEKSlILhUitan/SEp4CwKXBjzzA=
X-Received: by 2002:a05:620a:8c85:b0:92e:e7e0:ea45 with SMTP id af79cd13be357-934a0b10cdcmr2098248985a.47.1785858336297;
        Tue, 04 Aug 2026 08:45:36 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93641592964sm115484485a.0.2026.08.04.08.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 08:45:35 -0700 (PDT)
Date: Tue, 4 Aug 2026 11:45:34 -0400
From: Gregory Price <gourry@gourry.net>
To: Anisa Su <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, Jonathan Cameron <jic23@kernel.org>, 
	Fan Ni <nifan.cxl@gmail.com>, Li Ming <ming.li@zohomail.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, 
	Ira Weiny <iweiny@kernel.org>, Benjamin Cheatham <benjamin.cheatham@amd.com>, 
	Wonjae Lee <wj28.lee@samsung.com>, Junhee Park <jh9934.park@samsung.com>, 
	Heesoo Kim <habil.kim@samsung.com>, Anisa Su <anisa.su@samsung.com>
Subject: Re: [PATCH v12 1/8] cxl/mbox: Flag support for Dynamic Capacity
 Devices (DCD)
Message-ID: <anIJFdtTEmofty6U@gourry-fedora-PF4VCD3F>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-2-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731084901.1512819-2-anisa.su@samsung.com>

On Fri, Jul 31, 2026 at 01:48:06AM -0700, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> Per the CXL 4.0 specification software must check the Command Effects
> Log (CEL) for dynamic capacity command support.
> 
> Detect support for the DCD commands while reading the CEL, including:
> 
>         Get DC Config
>         Get DC Extent List
>         Add DC Response
>         Release DC
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> Tested-by: Junhee Park <jh9934.park@samsung.com>
> Tested-by: Heesoo Kim <habil.kim@samsung.com>
> 

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

