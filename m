Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0EA207A0B
	for <nvdimm@lists.linux.dev>; Fri, 16 Jan 2026 19:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768592513; cv=none; b=dxdQ9d3OoIHpHD0tMiHM/YFkluFqEY2+Cg6fte8Cz6VpZaHw7EpthATc4jsVlMQkNJ0WJkz9xG89Ml0g9+sKrdG6neXGW7DjvgBv7MnNfty3Qk+jQOQ9wRa3TKE1Q0pyiQQgYdy53mv9Vcv66ipluZD5jaPdVjHQq23wWOl3F40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768592513; c=relaxed/simple;
	bh=Jj1av06DXS5IbKWYei1Oke8WIGcxVvXo7NAK6tkNz2U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lUywJJp/HWbOsYygSvqG006aH2nbuqVvxOV9jsx5IPFOsm/sYsUD8a+YukBR7Vko+yqYXdnjLHuJSVNH4xtB5UUgYA3pPJkG4+FFLlXBB/OvIC7Vg6mqhKZePa+o8lq1ioBg0IViOJ6A1fkOxzdYjwylFgtKycTipevjBnL5cHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GRHtFSp2; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GRHtFSp2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768592510; x=1800128510;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=Jj1av06DXS5IbKWYei1Oke8WIGcxVvXo7NAK6tkNz2U=;
  b=GRHtFSp2qQ/XATN4RBkqfwChPSw53Ga2s01pllAtpCAP39ZO0JAmjLBR
   /TV97UK1KnphZy/JyzMTbPhz+U81C3+B1aOupLPU8JxjvYboiW9shfOWQ
   674EsDi0HBzXr92dfHITmxdzOpewU6arI50n3xMsfNvf697lTOjuwmo/X
   uJW9gJQWjXXuIIUiBZyiLRcMO7fkJ9GTejOmRevFMttonuSU+f4zMNJKp
   xbhZn5kvtsZla92Yw5a8ngdz0Efbbg8TpcudOhKvqmvyL1IUpD//hJhL5
   M/5d8PNrP+BPoMH1tlzRDGN1IaohyHk5ndg+qX3z0IhOTcekFw35t4u/r
   A==;
X-CSE-ConnectionGUID: VByrHSwBRumAlFPUxXeAqw==
X-CSE-MsgGUID: bs32QTz8R5OLKcXlVV4CSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="92576462"
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="92576462"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 11:41:50 -0800
X-CSE-ConnectionGUID: ybub8z3/Swi8KcMVDxTJZQ==
X-CSE-MsgGUID: Ij4zP7qLQX+lxRDJThuuKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="205593930"
Received: from unknown (HELO C02X38VBJHD2mac.local) ([10.241.241.24])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 11:41:36 -0800
From: Marc Herbert <marc.herbert@linux.intel.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH v2] daxctl: replace basename() usage with new
 path_basename()
In-Reply-To: <20260116043056.542346-1-alison.schofield@intel.com> (Alison
	Schofield's message of "Thu, 15 Jan 2026 20:30:53 -0800")
References: <20260116043056.542346-1-alison.schofield@intel.com>
Date: Fri, 16 Jan 2026 11:41:35 -0800
Message-ID: <m2qzrpe45s.fsf@linux.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Hearing the punishment for inputs with a trailing slash is not too
harsh:

Reviewed-by: Marc Herbert <marc.herbert@linux.intel.com>


Alison Schofield <alison.schofield@intel.com> writes:

> A user reports that ndctl fails to compile on MUSL systems:
>
> daxctl/device.c: In function 'parse_device_options':
> daxctl/device.c:377:26: error: implicit declaration of function 'basename' [-Wimplicit-function-declaration]
>   377 |                 device = basename(argv[0]);
>       |                          ^~~~~~~~
>
> There are two versions of basename() with different behaviors:
> 	GNU basename() from <string.h>: doesn't modify its argument
> 	POSIX basename() from <libgen.h>: may modify its argument
>
> glibc provides both versions, while MUSL libc only provides the POSIX
> version. Previous code relied on the GNU extension without a header
> or used the POSIX version inconsistently.
>
> Introduce a new helper path_basename() that returns the portion of a
> path after the last '/', the full string if no '/' is present, and a
> trailing '/' returns an empty string. This avoids libc-specific
> basename() behavior and is safe for argv style and arbitrary paths.
>
> Closes: https://github.com/pmem/ndctl/issues/283
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>
> Changes in v2: 
> - Replace open coded strrchr() logic with new helper (Marc, Dan)
> - Comment that new helper (Marc)
> - Update commit msg
>
>
>  daxctl/device.c        |  4 ++--
>  daxctl/lib/libdaxctl.c |  7 ++++---
>  util/util.h            | 15 +++++++++++++++
>  3 files changed, 21 insertions(+), 5 deletions(-)
>
