Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A20AD4A
	for <nvdimm@lists.linux.dev>; Fri, 13 Jan 2023 17:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673632587; x=1705168587;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8AoNubCxV8QATo7GoGNTAFM149XOR7IH+9tkOEwnG+U=;
  b=l9uADLdBRGmOyc2x/LJy+MefQp3vJMh1wjKuYzBqQXBde6mHdNrhKZOk
   40tIws4GgeP2AolMIl3cz1zbZX90iNcm8sqejdJ0cT6f5DMAgy9fUCnhC
   /0NtYHLAb0IKsf5y7y1PL29L2HXrIx4G9nbaOLeciI2uHXaZy4Uf6SUKb
   t23Fmqr/un0sgiJIolI3+RH3of5vahBttjF2H2+jNHAZk4gVgz5IfA+Ej
   f8WKWXWPZpMNieUWzPVhqWi2GCS+5B6TtO1k3oz5wGNvNXH2swCZ8wj2H
   m3qEY0ZKcW+UuA7/F7/AZbkuL7R4XVm/IqLOK6EVjNy+Acu8jq5t3u0Ap
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10589"; a="307602015"
X-IronPort-AV: E=Sophos;i="5.97,214,1669104000"; 
   d="scan'208";a="307602015"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2023 09:56:26 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10589"; a="782235293"
X-IronPort-AV: E=Sophos;i="5.97,214,1669104000"; 
   d="scan'208";a="782235293"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.212.225.67])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2023 09:56:26 -0800
Date: Fri, 13 Jan 2023 09:56:24 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Subject: Re: [PATCH ndctl] test/cxl-xor-region.sh: skip instead of fail for
 missing cxl_test
Message-ID: <Y8GbSNR5Kbvn7HR0@aschofie-mobl2>
References: <20230112-vv-xor-test-skip-v1-1-92ddc619ba6c@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112-vv-xor-test-skip-v1-1-92ddc619ba6c@intel.com>

On Fri, Jan 13, 2023 at 10:16:21AM -0700, Vishal Verma wrote:
> Fix cxl-xor-region.sh to correctly skip if cxl_test is unavailable by
> returning the special code '77' if the modprobe fails.

Thanks Vishal!

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> 
> Link: https://github.com/pmem/ndctl/issues/229
> Fixes: 05486f8bf154 ("cxl/test: add cxl_xor_region test")
> Cc: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  test/cxl-xor-region.sh | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/test/cxl-xor-region.sh b/test/cxl-xor-region.sh
> index 5c2108c..1962327 100644
> --- a/test/cxl-xor-region.sh
> +++ b/test/cxl-xor-region.sh
> @@ -4,7 +4,7 @@
>  
>  . $(dirname $0)/common
>  
> -rc=1
> +rc=77
>  
>  set -ex
>  
> @@ -15,6 +15,7 @@ check_prereq "jq"
>  modprobe -r cxl_test
>  modprobe cxl_test interleave_arithmetic=1
>  udevadm settle
> +rc=1
>  
>  # THEORY OF OPERATION: Create x1,2,3,4 regions to exercise the XOR math
>  # option of the CXL driver. As with other cxl_test tests, changes to the
> 
> ---
> base-commit: b73e4e0390aae822bc91b8bf72430e6f0e84d668
> change-id: 20230112-vv-xor-test-skip-3ae4f5d065e4
> 
> Best regards,
> -- 
> Vishal Verma <vishal.l.verma@intel.com>
> 
