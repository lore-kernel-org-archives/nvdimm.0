Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DD56FC4
	for <nvdimm@lists.linux.dev>; Tue, 21 Feb 2023 17:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677000173; x=1708536173;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2bASnVZjyZBBIQKCtbnfgI7YfZzKvTnORyQXnFEKi0U=;
  b=S5awCppkmgF+fa0L6mUydIrO9kosRgm+71PLbzJ5OJ3OJwGA4YTvx+eJ
   EXjwYv2cEhwrlNeSuxG5ncu7EN5gFEsHSWf2d3j/oOm4fCoh78Bl59aE+
   HB8XZe0cuoDtVvtXM8YpH5sHV1TVUqCcYEQW5nQN3KUewu6J+XvVqLxJw
   buvIzWiJyxgCw1X07LMfpclkMClfg5Z1My5M9K6+PkzyvYFt7Qz65YZC9
   H+UBest3D60Vfr2Df2pYddVE3D5I7QttRF2aZDECwan2oZOoLK5ykjYaC
   z3NP9Cuxpu0K6yLE05tmxGgypZScvt9kpp7CglEIWY47UYqFJuX07S2Kn
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="332700001"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="332700001"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 09:22:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="621579418"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="621579418"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.251.28.85])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 09:22:52 -0800
Date: Tue, 21 Feb 2023 09:22:50 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH ndctl 3/3] test/cxl-security.sh: avoid intermittent
 failures due to sasync probe
Message-ID: <Y/T96khZVa7Oo6uU@aschofie-mobl2>
References: <20230217-coverity-fixes-v1-0-043fac896a40@intel.com>
 <20230217-coverity-fixes-v1-3-043fac896a40@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217-coverity-fixes-v1-3-043fac896a40@intel.com>

On Fri, Feb 17, 2023 at 05:40:24PM -0700, Vishal Verma wrote:
> This test failed intermittently because the ndctl-list operation right
> after a 'modprobe cxl_test' could race the actual nmem devices getting
> loaded.
> 
> Since CXL device probes are asynchronous, and cxl_acpi might've kicked
> off a cxl_bus_rescan(), a cxl_flush() (via cxl_wait_probe()) can ensure
> everything is loaded.
> 
> Add a plain cxl-list right after the modprobe to allow for a flush/wait
> cycle.

Is this the preferred method to 'settle', instead of udevadm settle?

> 
> Cc: Dave Jiang <dave.jiang@intel.com>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  test/security.sh | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/test/security.sh b/test/security.sh
> index 04f630e..fb04aa6 100755
> --- a/test/security.sh
> +++ b/test/security.sh
> @@ -225,6 +225,7 @@ if [ "$uid" -ne 0 ]; then
>  fi
>  
>  modprobe "$KMOD_TEST"
> +cxl list
>  setup
>  check_prereq "keyctl"
>  rc=1
> 
> -- 
> 2.39.1
> 
> 
