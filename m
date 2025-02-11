Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3619C261397
	for <nvdimm@lists.linux.dev>; Tue, 11 Feb 2025 17:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739294060; cv=none; b=csIwK5CJRfQ1Slu+NlWIhhrOygSA45tvUtsmNxqdRn2/Ru3mtQ6jcKTqkjeWyQEtBnHrggAnORdkub1tjdl1xU0eGmdEt8/xZszbvpLE45FtkZHvAL+6F9AEkwosxgk5+nzu+ezcqVTsUTFl1Q5OPRXUmGPJ3KNVGZgTbHaGKj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739294060; c=relaxed/simple;
	bh=3m6+wFerQxYeEoh4DOFNqfvWEkqBGzTgBwK6PS3M6jk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ke0QW9gb3/jdNSF7UNXzyCMro6oxkZJBCPpkbv0jvxImU5Jpg2pSShZpLvukXDL0cmSeoU3z6e/IkrfuAwvpO/DXqD9RT0UJMACIoOtLxGLEAp83wAunhyKZK/dBZn5kRLvJvFAEehu1smTBTYj6Dxb9v7WpUe3PmOud2sDPuSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Moxw7j0c; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Moxw7j0c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739294058; x=1770830058;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3m6+wFerQxYeEoh4DOFNqfvWEkqBGzTgBwK6PS3M6jk=;
  b=Moxw7j0cYlafdMstknzSh1q+eLeyODoimxvLsjQ8WJIU9rdPvsDmA8Rw
   Q7GLyJ4vORG5nxEc9BMVk05PrRQ3G75KYCxROFbgAEqPs4xszVGUO78Yk
   AmwXYiveevDMPAtXEjlhUi4TMJMsAgDdl9w3xEs0sISD5xfkllrqJrje+
   1LnanCSg5P2AfrD+wEz79o/WP94vzvxsFHDNfvO04fTJJAnr4XvBBaGXc
   S9WjP4brlihOg5EWtgc2aLkKBfoZ4qMYbv72B1ugXG6k/OrNH9NjYWaTM
   hDi9Dv1qjNIXn4fbsBuu/mt9oESaSEFXIf00Qj7VrwszRVua6DcRRW5SL
   A==;
X-CSE-ConnectionGUID: BGm90kVpQnirN9GXubq4qQ==
X-CSE-MsgGUID: SZflpNXaQ1e0k1H/eiqYCg==
X-IronPort-AV: E=McAfee;i="6700,10204,11342"; a="43581285"
X-IronPort-AV: E=Sophos;i="6.13,278,1732608000"; 
   d="scan'208";a="43581285"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 09:14:17 -0800
X-CSE-ConnectionGUID: 0CcGNpErTa+UU2zPPJiB4A==
X-CSE-MsgGUID: kIKcdoGnQ4Was+6FlfqcBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,278,1732608000"; 
   d="scan'208";a="112785920"
Received: from unknown (HELO [10.24.8.124]) ([10.24.8.124])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 09:14:17 -0800
Message-ID: <89603666-3c31-4689-b0bc-e558e6aa5b22@intel.com>
Date: Tue, 11 Feb 2025 09:14:09 -0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] cxl/json: remove prefix from tracefs.h #include
To: alison.schofield@intel.com, nvdimm@lists.linux.dev
Cc: Michal Suchanek <msuchanek@suse.de>
References: <20250209180348.1773179-1-alison.schofield@intel.com>
Content-Language: en-US
From: Marc Herbert <Marc.Herbert@intel.com>
In-Reply-To: <20250209180348.1773179-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-02-09 10:03, alison.schofield@intel.com wrote:
> From: Michal Suchanek <msuchanek@suse.de>
> 
> Distros vary on whether tracefs.h is placed in {prefix}/libtracefs/
> or {prefix}/tracefs/. Since the library ships with pkgconfig info
> to determine the exact include path the #include statement can drop
> the tracefs/ prefix.
> 
> This was previously found and fixed elsewhere:
> a59866328ec5 ("cxl/monitor: fix include paths for tracefs and traceevent")
> but was introduced anew with cxl media-error support in ndctl v80.
> 
> Reposted here from github pull request:
> https://github.com/pmem/ndctl/pull/268/
> 
> [ alison: commit msg and log edits ]
> 
> Fixes: 9873123fce03 ("cxl/list: collect and parse media_error records")
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  cxl/json.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Marc Herbert <marc.herbert@intel.com>
 
> diff --git a/cxl/json.c b/cxl/json.c
> index 5066d3bed13f..e65bd803b706 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -9,7 +9,7 @@
>  #include <json-c/json.h>
>  #include <json-c/printbuf.h>
>  #include <ccan/short_types/short_types.h>
> -#include <tracefs/tracefs.h>
> +#include <tracefs.h>
>  
>  #include "filter.h"
>  #include "json.h"
> 
> base-commit: 04815e5f8b87e02a4fb5a61aeebaa5cad25a15c3

