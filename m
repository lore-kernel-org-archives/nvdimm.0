Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3185437F8B6
	for <nvdimm@lists.linux.dev>; Mon, 12 Oct 2026 13:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791812076; cv=none; b=i1FKsc866HVXhz7KpAc64MLOt2ZUx85julnura2hfkz4tIg1folMYHpJrFzbrtYLt9qeC7TrKCBLItw2c6vhy4aI93UFOi+/NiPl+FwVF5R/brxY7Yh9g8o+gG4/GMJouxntRh2ybqc+0fQZ5bifJQ62KAwnWDIR84jMOHFdfS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791812076; c=relaxed/simple;
	bh=NHu/K0xZgZFW3d5lgMZbXzllHDi8ib7YEEBd+KLWdQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HVOYKXtbo0kwTFBS99YEbbJYTUlnD3Ny6lOUWoYgFS6DXIjJde294yRwZO9XqUCjxxlleroIiNxkPr8WU5J3VvQ2rO7Ow41Rgsl2XqmAop6d466fihbv4Z10If9oj/XUT67BvLARPnrj3Yc2crwWTO+fk9tFOphiocs/riEts1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=RHDA9SGS; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="RHDA9SGS"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-93e50170ba7so123975285a.3
        for <nvdimm@lists.linux.dev>; Mon, 12 Oct 2026 06:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1791812074; x=1792416874; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=APyi0iRUPZWOwHWtuxjyWmMEyDkcX7OsLaOURKQenfI=;
        b=RHDA9SGSGhhR/GHAhI1svmx3O7B+8h0hNS5iJ82aY3FfbzoXWWS7ODduaGtA2fWW62
         jYxtShx2DY2Rh3vCcJphtGwYLvG6BMPuK55rBhzljnOFACCUsl0JqrW9NgX8kLSgov49
         un2uW4kuyjwRxuuCVn5SFspPnoYoOn3l1Z39Y+qZGAifV2cYIC1rxxxYWMlEqjqcxHC/
         OibH6DScKxchJNUkTTTBi3pOuoHmmfe1dUQ1gGzqoSD9o11v2OwbVLoE538NznEeKaqC
         gXF8MiwnfEchK1AAc3z5Bxm5aBzukiIk2SGHMKcEkYKRQbKOKIRXnt40QUI30/X+LUkP
         fFZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791812074; x=1792416874;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=APyi0iRUPZWOwHWtuxjyWmMEyDkcX7OsLaOURKQenfI=;
        b=RGz89PugSPi2pA0mdG+T3tMpwMUn0bM4pCoW+EwbQTUaw093dA8YVo2GiOq4uUPB5Z
         c1Pdo9WwTFCswkt0btmGMfXuiRiuYvH+tTnUrFPa/Gd7/Bxy1GA6loLBHeZ/lcciS6GX
         tv5Nj02XKwZlddd1Aqn/xzPW6R7dEKkD6LkFM5EQebdgLa5wyPmBApb0omD+50KmR4aH
         w4sli29hbAhCEysGYbnYjIs2pOC60d8G78wYYSXlQdwJa4+TZ5gpBUEOAy8Q9LsGqiex
         ZF9Fx+qaeqtnm5Ib8N03NpLWndNYDQq2XHukwMiTiQ0MX0djCXKQHTK29Kbd8iOICgxo
         Lb7g==
X-Forwarded-Encrypted: i=1; AKwUvBwN5hpT0IrhF7a7V52pm9EsN93XZwytAV3VoxsCLilJPSraBKRQWTOLrlGuRkIdnJ18BaEkkHg=@lists.linux.dev
X-Gm-Message-State: AFq9FYLriCOIVOdRZIzWvKRMep8fenZI0nmE/YQKkn6SBb321o/obbBq
	/UB1rQLQURbremogIx3xaRwYqR+wlffGS+JsRkeYORrLEKzjacqg1iXXXZKboNvjyiY=
X-Gm-Gg: AYBFou0aMkT/SB9sOCCKcPHzwJYqkhJWFQvRfUA7FfoadEoPUUnXM/D1Kch/nea/mG9
	8K8+XFW3+kZTRpvqWQfUO45JYxkTD1k5VKMeCmUB362hDW/VmNZ6d1D9boy+Y+3qA8iKmVNL8qj
	vLcfUjarAG56T27cay8AK26ltrybyu0EWJfYiTbu6ny8rSK6GhwElXXEHgJ7ai8aP5X5h2E1zrP
	YDC/qvrwW9cBV9IlEAn9g25zqUOyfc9Ly1e9WY/aFy5l2ihzbYi1gfX+snZKMkrjSfLxuaGlUHb
	vSvt+qnUb4sE7+87PtzC3vxHcOI3xlUtBrvMiZ0WAUvjmC5bRowRdukUNTAfdJEisiVAIzkPHpS
	24gAVsG9LHXh7GE0LrvScmgf/HzYeHdN4vFSEPVTtDdMKEt6soVCQr12xAgLs0WnphTtl7Qskza
	OXRnCYRfIzxPFzaELfgSSaq4zm5IRNjsiS9z84ELq/C4pZmxTsWfTuIDUa9Tblj+uTk/O/fH2lT
	yqMsJdIBTZMUZeZoMAtzMHpJBOeSTSVRleuT+p+0Kx6ccBMqWbhC7c=
X-Received: by 2002:a05:620a:371b:b0:912:1206:ddd1 with SMTP id af79cd13be357-93ebd0e4d43mr1584355485a.1.1791812074159;
        Mon, 12 Oct 2026 06:34:34 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93eb98c6b4bsm855300385a.34.2026.10.12.06.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 06:34:33 -0700 (PDT)
Date: Mon, 12 Oct 2026 09:34:31 -0400
From: Gregory Price <gourry@gourry.net>
To: Anisa Su <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, Jonathan Cameron <jic23@kernel.org>, 
	Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Fan Ni <nifan.cxl@gmail.com>, Li Ming <ming.li@zohomail.com>, 
	Benjamin Cheatham <benjamin.cheatham@amd.com>, Richard Cheng <icheng@nvidia.com>, 
	Anisa Su <anisa.su@samsung.com>
Subject: Re: [PATCH v16 8/8] Documentation/cxl: Document DPA partition layout
 and ordering rules
Message-ID: <aszhulUhlzXn4njl@gourry-fedora-PF4VCD3F>
References: <20261010225852.10727-1-anisa.su@samsung.com>
 <20261010225852.10727-9-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010225852.10727-9-anisa.su@samsung.com>

On Sun, Oct 11, 2026 at 07:54:59AM +0900, Anisa Su wrote:
> DC Partitions complicate DPA ordering. Add a DPA Partitions section to
> cxl-driver.rst describing spec-mandated and Linux requirements for the
> layout.
> 
> maturity-map.rst breaks the DCD entry into sub-items so the map shows
> what this series lands: partition enumeration is [1], event handling
> and DC-backed DAX regions remain [0] until the follow-on series enables
> them. The parent stays [0]; nothing is usable yet.
> 
> Suggested-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> Tested-by: Junhee Park <jh9934.park@samsung.com>
> Tested-by: Heesoo Kim <habil.kim@samsung.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
> Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>


Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

