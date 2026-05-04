Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7872A368263;
	Mon,  4 May 2026 22:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777934298; cv=none; b=E7tvkerMPI3N2MZqm9oUfuSL/YkcMiwmiw5ngY0RZJshEY9MChgr5QgcfziwsCiKGlicLApBU6LlwTyzt+DStsWUhddxLE6XDVr4zP2SrWk6gzKdyS11oojgen/BOMsiU4q07KWyXmQcC7gMg1TvyHFEKhhXlEj+LbLRXJ+oO7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777934298; c=relaxed/simple;
	bh=zbzwGRvYkKchDj85vYPZPJGEjsRFzi2wLJWgUIvSU1E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gIACdBxCOjrDhoFakjodr+sk9MKqiFCE+mt4jDW4XojsemguPwK1DD1QZra5li0+rYg13SGETzeG54wDD6QRbbEKn83l/ARNi01DP9GUzbx3Sw5AUZokyXqGBOYblHbHuMfbaXMEnnOA3kruhJF551rPR7gJJKIa3C15DANkAz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eCQ5ohr3; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eCQ5ohr3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777934296; x=1809470296;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zbzwGRvYkKchDj85vYPZPJGEjsRFzi2wLJWgUIvSU1E=;
  b=eCQ5ohr3138unfpH2GErzrSIYIGTvFzuOiprc/xbyUWWS3EVcbWcIrEK
   Wbhs/fnI3gQ+3gF4RpunP//s5W3eCBTteWDxUAuhSM9/57jvGUGjza5kB
   4cnnGi6A2cU2SwJtUcLuRNT1jEIHylrx+TWqUWlo1jNGMoBCulg+jn3EO
   ougp7MhM1WMY0knWOMwZMJiVxOAMxmVbgep71ieY+S2fO/qXYIp0cXH4q
   aW9nOIrzvZju6WZgateI4f3JfPAadzeTdgAnnDnBC1ZAZkFVrpobXqku3
   ah3HDa7k4KTnhU7+mK7Oyd7PeYDTKphF0BL47l04dpbEvLny8JrthKFJZ
   g==;
X-CSE-ConnectionGUID: WIzzoVz5Qg+Fx9LIvo7RHA==
X-CSE-MsgGUID: RvzztKQlRw28BRimp4gyyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11776"; a="78662643"
X-IronPort-AV: E=Sophos;i="6.23,216,1770624000"; 
   d="scan'208";a="78662643"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 15:38:12 -0700
X-CSE-ConnectionGUID: jhrnnHGhRDqDe77/Dz6YqA==
X-CSE-MsgGUID: DhSf4iJ+SL6SklckUIvEEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,216,1770624000"; 
   d="scan'208";a="231270406"
Received: from ssimmeri-mobl2.amr.corp.intel.com (HELO [10.125.110.19]) ([10.125.110.19])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 15:38:09 -0700
Message-ID: <f63382ab-e50a-4b19-af83-a3e037a42c2b@intel.com>
Date: Mon, 4 May 2026 15:38:08 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Update address for Ira Weiny
To: Ira Weiny <ira.weiny@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 driver-core@lists.linux.dev, linux-kernel@vger.kernel.org,
 Ira Weiny <iweiny@kernel.org>
References: <20260504-change-maintain-file-v1-1-6679b030d3e0@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260504-change-maintain-file-v1-1-6679b030d3e0@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/4/26 3:38 PM, Ira Weiny wrote:
> Update MAINTAINERS and .mailmap to point to my kernel.org address:
> iweiny@kernel.org
> 
> Downgrade from maintainer to reviewer whilst doing so.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Acked-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  .mailmap    | 1 +
>  MAINTAINERS | 6 +++---
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/.mailmap b/.mailmap
> index b78aa092b4bb..61d101ce9696 100644
> --- a/.mailmap
> +++ b/.mailmap
> @@ -446,6 +446,7 @@ Juha Yrjola <juha.yrjola@nokia.com>
>  Juha Yrjola <juha.yrjola@solidboot.com>
>  Julien Thierry <julien.thierry.kdev@gmail.com> <julien.thierry@arm.com>
>  Justin Iurman <justin.iurman@gmail.com> <justin.iurman@uliege.be>
> +Ira Weiny <iweiny@kernel.org> <ira.weiny@intel.com>
>  Iskren Chernev <me@iskren.info> <iskren.chernev@gmail.com>
>  Kalle Valo <kvalo@kernel.org> <kvalo@codeaurora.org>
>  Kalle Valo <kvalo@kernel.org> <quic_kvalo@quicinc.com>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 882214b0e7db..d30ab65ece8a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4255,7 +4255,7 @@ M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>  M:	"Rafael J. Wysocki" <rafael@kernel.org>
>  M:	Danilo Krummrich <dakr@kernel.org>
>  R:	Dave Ertman <david.m.ertman@intel.com>
> -R:	Ira Weiny <ira.weiny@intel.com>
> +R:	Ira Weiny <iweiny@kernel.org>
>  R:	Leon Romanovsky <leon@kernel.org>
>  L:	driver-core@lists.linux.dev
>  S:	Supported
> @@ -6426,8 +6426,8 @@ M:	Jonathan Cameron <jic23@kernel.org>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  M:	Alison Schofield <alison.schofield@intel.com>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
> -M:	Ira Weiny <ira.weiny@intel.com>
>  M:	Dan Williams <djbw@kernel.org>
> +R:	Ira Weiny <iweiny@kernel.org>
>  L:	linux-cxl@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/driver-api/cxl
> @@ -14686,7 +14686,7 @@ LIBNVDIMM: NON-VOLATILE MEMORY DEVICE SUBSYSTEM
>  M:	Dan Williams <djbw@kernel.org>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
>  M:	Dave Jiang <dave.jiang@intel.com>
> -M:	Ira Weiny <ira.weiny@intel.com>
> +R:	Ira Weiny <iweiny@kernel.org>
>  L:	nvdimm@lists.linux.dev
>  S:	Supported
>  Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
> 
> ---
> base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
> change-id: 20260504-change-maintain-file-8f033435619b
> 
> Best regards,
> --  
> Ira Weiny <ira.weiny@intel.com>
> 

