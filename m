Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E29916EBEF
	for <nvdimm@lists.linux.dev>; Wed, 10 Apr 2024 15:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712763226; cv=none; b=QzZKjJViqFzYhzjBjDZHZXkz/XlqI3wuQr5EPEotcA5T3jtYNEI0bZFkmjB6VzYRHdKAOaJXnwsDllP9qbfwsd/cMHUi8vn00om9PgAPcirTPWwd3Qupjk0fOrB60xreLMY+5bscRhdtY/qnDovTQD/2QxI/mK9TqpD62NqqNUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712763226; c=relaxed/simple;
	bh=Qoxd/EbwvZ/aUHfaZhEyr8BhscDhWHYgbMSxF6RY0lg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tnl/RSUvqmP3WR7iEhkdX9Q1U6qXrOho8fMPIE/Cbxlsn82WRx+jI6H0SucGJxKFMgvSpiITu0UJg7+tz4wLWL4N8ugl+pLgDe+KLZIlsb79QlZ5IeQ5p65TW6Ia+lafvTOH7ZQayIfaLYeNJ50/KJHxqvyKPRFLHJs0BvaQU6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QoEJOFzl; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QoEJOFzl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712763224; x=1744299224;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Qoxd/EbwvZ/aUHfaZhEyr8BhscDhWHYgbMSxF6RY0lg=;
  b=QoEJOFzlUKEZBlf370SZMaDAGM2gjcz8tdMpLZX0hwmQdhX17jxUj++i
   Uj+1wvwq/HPDT13+JdGufhVJgnlnINNVJapfK4MahMdJUD6aljeXOZOGF
   yR/CEET1ycpHZjIZm9YKH8oMSgCc1xCGcTxYceFL+P+opUbLJbXrEDZTY
   cbY++cGXfGHPxurEpF3xOaHomsjCwlxUF5ooy9QDKCmNu0uU4uw+DBw5g
   ZZLSg8dNxAsuG7z8VAv/fWSYvRhScHd8JvklyRruHCJWDHPpsyAlGe4i0
   NzRqN+9YPaY4iWE/d9Ll5XJeiiXWtDgJGnzI45lhqJe3grD2Qnrl4AM8T
   g==;
X-CSE-ConnectionGUID: IiA7tkeZQmGVUXX/VAxDvg==
X-CSE-MsgGUID: Yf6Lh1oATtWz8l94eIC2Ng==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="33537385"
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="33537385"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 08:33:44 -0700
X-CSE-ConnectionGUID: TFiIzLx1TRScROaZVCfQqA==
X-CSE-MsgGUID: QN9LOi0ATsiCnZAol38psA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="51799259"
Received: from priyajos-mobl1.amr.corp.intel.com (HELO [10.212.69.89]) ([10.212.69.89])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 08:33:43 -0700
Message-ID: <07d60e08-9e2d-42ff-8cea-f31c6d69977a@intel.com>
Date: Wed, 10 Apr 2024 08:33:42 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] nvdimm: Convert to platform remove callback returning
 void
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Oliver O'Halloran <oohall@gmail.com>
Cc: nvdimm@lists.linux.dev, kernel@pengutronix.de
References: <cover.1712756722.git.u.kleine-koenig@pengutronix.de>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <cover.1712756722.git.u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 4/10/24 6:47 AM, Uwe Kleine-König wrote:
> Hello,
> 
> this series converts all platform drivers below drivers/nvdimm/ to not
> use struct platform_device::remove() any more. See commit 5c5a7680e67b
> ("platform: Provide a remove callback that returns no value") for an
> extended explanation and the eventual goal.
> 
> All conversations are trivial, because the driver's .remove() callbacks
> returned zero unconditionally.
> 
> There are no interdependencies between these patches, so they can be
> applied independently if needed. This is merge window material.
> 
> Best regards
> Uwe
> 
> Uwe Kleine-König (2):
>   nvdimm/e820: Convert to platform remove callback returning void
>   nvdimm/of_pmem: Convert to platform remove callback returning void
> 
>  drivers/nvdimm/e820.c    | 5 ++---
>  drivers/nvdimm/of_pmem.c | 6 ++----
>  2 files changed, 4 insertions(+), 7 deletions(-)
> 
> base-commit: 6ebf211bb11dfc004a2ff73a9de5386fa309c430

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

for the series
