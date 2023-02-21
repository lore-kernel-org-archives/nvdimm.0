Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A046FAB
	for <nvdimm@lists.linux.dev>; Tue, 21 Feb 2023 16:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676997974; x=1708533974;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Fjen9j3+shI4NxVJreGUM55iXw0I9Dwn2lS2rxB/nL0=;
  b=ShzNpwgN+yXEWnRa/DyFvYWINDntcWwf9q3ZAlTdeIi/HwN6jntX4yZE
   VDZxtz5+REfAumAmUJqpd2feRIeedLgiLVwVS4Jy3OnakH0ZALPqfW7Iv
   d+Mmrn5uge3Scl5jF/9zqlnetFhTVqHdTN0Yg1hje+67vMQrQt8h3OsuP
   i+EM4zr7d0Pkoq9l3pYRn3Xgw5VFgKKyMGLZP/KBvkDZLnFnu6CfBdxjs
   ekV38yyoAgdOC2Ydw9tu1Dv0QvjHvA80z3K/jERtsLQhMdoDSKnpkfHFx
   O33Hjv6bug3nE3rdM2YFMSy60gfRkrG+WkM6Yhn4cJ0fmtIz4BibDERZf
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="418908248"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="418908248"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 08:45:50 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="845741450"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="845741450"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.213.184.163]) ([10.213.184.163])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 08:45:49 -0800
Message-ID: <e357fd16-8a1b-af74-ca27-2bacf82ef98a@intel.com>
Date: Tue, 21 Feb 2023 09:45:49 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.0
Subject: Re: [PATCH ndctl 3/3] test/cxl-security.sh: avoid intermittent
 failures due to sasync probe
Content-Language: en-US
To: Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>
References: <20230217-coverity-fixes-v1-0-043fac896a40@intel.com>
 <20230217-coverity-fixes-v1-3-043fac896a40@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230217-coverity-fixes-v1-3-043fac896a40@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/17/23 5:40 PM, Vishal Verma wrote:
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
> 
> Cc: Dave Jiang <dave.jiang@intel.com>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   test/security.sh | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/test/security.sh b/test/security.sh
> index 04f630e..fb04aa6 100755
> --- a/test/security.sh
> +++ b/test/security.sh
> @@ -225,6 +225,7 @@ if [ "$uid" -ne 0 ]; then
>   fi
>   
>   modprobe "$KMOD_TEST"
> +cxl list
>   setup
>   check_prereq "keyctl"
>   rc=1
> 
