Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A003A5C08B
	for <nvdimm@lists.linux.dev>; Wed, 22 Nov 2023 18:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FNrKbJdI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700679358; x=1732215358;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zXKICjKqzQIDGFViWkCDLIOvPMYkqHudqhx8AiDVP4g=;
  b=FNrKbJdIjmeefTWJ6DD6cOREVRvjMHQvasC4y4WShxZpU4VPoj+oQFx+
   hZkYw+gc5PBRCkIQMYW6Ak+x8UESHyxpQZptzXpWmeU2MJ0g5pg9VNs2Y
   In2i+fQFPKYDmubFXxsaHaWAUX0H5ONRQyg8zKajlEWtwomQP5aSvB+pZ
   IXUm27O6lxlzCPj/tIfexHlCtpjS9NpnXtL2kEElycVJGs52+9W03DEcO
   3BfHX12ijaKezWPTxSGYO+g59Tmyd5mvI9+5Hz/wsTWPF3sA7MlXEn60l
   IjY+vmglQCERsJmFMvZpausXa8+V7G0UBP5TOQmyQEceR1eTZPjMxRc0A
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="377155328"
X-IronPort-AV: E=Sophos;i="6.04,219,1695711600"; 
   d="scan'208";a="377155328"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2023 10:55:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,219,1695711600"; 
   d="scan'208";a="15390151"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.4.129])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2023 10:55:57 -0800
Date: Wed, 22 Nov 2023 10:55:55 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH] cxl/test: validate the auto region in
 cxl-topology.sh
Message-ID: <ZV5Ou9cSnHIfeNe7@aschofie-mobl2>
References: <20231122021849.1208967-1-alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231122021849.1208967-1-alison.schofield@intel.com>

On Tue, Nov 21, 2023 at 06:18:49PM -0800, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> The cxl-test module sets up a region to be autodiscovered in
> order to test the CXL driver handling of BIOS defined regions.
> Confirm the region exists upon load of the cxl-test module.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
> 
> The region does survive the ensuing shenanigans of this test.
> The region state moves from committed to disabled and back
> again as the memdevs, ports, and host bridges are disabled
> and then re-enabled. Although that was interesting, it's not
> clear that this test should be doing region error recovery
> testing. 
> Let me know if you think otherwise?

I probably should have explained what doing 'more' would look
like. We can add another check of the region before the final
bus disable to confirm that it survived.

> 
> 
>  test/cxl-topology.sh | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
> index 89d01a89ccb1..e8b9f56543b5 100644
> --- a/test/cxl-topology.sh
> +++ b/test/cxl-topology.sh
> @@ -21,6 +21,14 @@ rc=1
>  # tools/testing/cxl/test/cxl.c. If that model ever changes then the
>  # paired update must be made to this test.
>  
> +# validate the autodiscovered region
> +region=$("$CXL" list -R | jq -r ".[] | .region")
> +if [[ ! $region ]]; then
> +	echo "failed to find autodiscovered region"
> +	err "$LINENO"
> +fi
> +
> +
>  # collect cxl_test root device id
>  json=$($CXL list -b cxl_test)
>  count=$(jq "length" <<< $json)
> 
> base-commit: a871e6153b11fe63780b37cdcb1eb347b296095c
> -- 
> 2.37.3
> 
