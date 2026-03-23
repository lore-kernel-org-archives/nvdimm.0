Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3449382F28
	for <nvdimm@lists.linux.dev>; Mon, 23 Mar 2026 22:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774304752; cv=none; b=iAP7we/HCHAS2cBLEViTdjjmxyurX++riwU9WgODiTT6MwUlcVvsXmJPDYY8oc5+FiDDuuBdRCk4X6KHzqGjsnTCw4uX9ZE3f1HIIV3Z1E28s/8UziEXQ6QliV6g5RS9e6wJEE/zHSDdjQp2rXanjZQehc19JJkV13oCkUezrsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774304752; c=relaxed/simple;
	bh=GImzQFOA0Prmw4aihz51x6uTzNNN7eNfIs6T9njPGFM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uPfst9OMRbUdlEh1PAoLn0FGjovipdx2Atre6cZUiMBO7YZVx6HmsKRAAlQuMdLx0nkrCXkC+qBDpuXgfZKThzekaXqXx2G5uFLsyN3P8dSElUprbCsFb5z3SDE096R3aRfaTsRz3oTCqJwj5C+LS0WpsMoX257wlF4+I35aojg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m1kjoDqQ; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m1kjoDqQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774304750; x=1805840750;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=GImzQFOA0Prmw4aihz51x6uTzNNN7eNfIs6T9njPGFM=;
  b=m1kjoDqQJCFnu83FsYPGJ71La7GvdgX+twOyjt8KLNNvT7icEoKj9y4x
   vN65GEh5oJv/8ATGZ76LLHaXFC1UnZbcGGB0+cSwr3f7YUjdDrfLXlNDL
   HfAIOH1AGTTtrtWCfFlKwj27PgrNYhnSpoVdWhIz28p8WH37w1un0ARds
   E8Gl0B7vlUypaAs7fWy+LgFClGnPURjBfo5n+Y2nzWrwX+AzD8DfQMlMg
   30f5Uv4m9cNsRuAmSHcBMHuG9H7rPGGW/3Pg6MrCgzmp+WzvEqFPMvwwR
   PXdb8Kt00YIBWoGOFTPtG8SVzk/n5qbQsmTtvdutd2I6d82EaUI27I252
   A==;
X-CSE-ConnectionGUID: IiKTpUJrRkSiqhFKszLgYg==
X-CSE-MsgGUID: 4X0cxrfWSmCfnHX6Jfiszg==
X-IronPort-AV: E=McAfee;i="6800,10657,11738"; a="85625069"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="85625069"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 15:25:50 -0700
X-CSE-ConnectionGUID: znmdbrzqQAGORxY+PHmkHg==
X-CSE-MsgGUID: a/L9uHU1QBGM4yu6pNp3SA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="254634354"
Received: from jdoman-mobl3.amr.corp.intel.com (HELO [10.125.109.216]) ([10.125.109.216])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 15:25:49 -0700
Message-ID: <9ce7c8ba-eb09-4569-b39b-147815b0e15d@intel.com>
Date: Mon, 23 Mar 2026 15:25:48 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] test/cxl-topology.sh: verify dax device creation
 for auto region
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
References: <20260323220148.2620066-1-alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260323220148.2620066-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/23/26 3:01 PM, Alison Schofield wrote:
> The auto-discovered CXL region should create a dax device with
> matching size and resource mapping. A recent regression in the
> no-soft-reserved case broke this behavior without test coverage.
> 
> Expand the existing auto-region check to validate the dax device.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

I'm terrible with Bash and jq. AFAICT LGTM.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

 
> ---
>  test/cxl-topology.sh | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
> index d9475b1bae9c..170c9caf840b 100644
> --- a/test/cxl-topology.sh
> +++ b/test/cxl-topology.sh
> @@ -22,12 +22,24 @@ rc=1
>  # paired update must be made to this test.
>  
>  # validate the autodiscovered region
> -region=$("$CXL" list -R | jq -r ".[] | .region")
> -if [[ ! $region ]]; then
> -	echo "failed to find autodiscovered region"
> -	err "$LINENO"
> -fi
> +region_json=$("$CXL" list -R -u)
> +[ -n "$region_json" ] || err "$LINENO"
> +region=$(jq -r '.region // empty' <<<"$region_json")
> +region_size=$(jq -r '.size // empty' <<<"$region_json")
> +region_resource=$(jq -r '.resource // empty' <<<"$region_json")
> +[ -n "$region" ] || err "$LINENO"
> +[ -n "$region_size" ] || err "$LINENO"
> +[ -n "$region_resource" ] || err "$LINENO"
>  
> +# validate the dax device created for the autodiscovered region
> +dax_json=$("$DAXCTL" list -r "$region" -DMu)
> +[ -n "$dax_json" ] || err "$LINENO"
> +dax_dev=$(jq -r '.chardev // empty' <<<"$dax_json")
> +dax_size=$(jq -r '.size // empty' <<<"$dax_json")
> +dax_start=$(jq -r '.mappings[0].start // empty' <<<"$dax_json")
> +[ -n "$dax_dev" ] || err "$LINENO"
> +[ "$dax_size" = "$region_size" ] || err "$LINENO"
> +[ "$dax_start" = "$region_resource" ] || err "$LINENO"
>  
>  # collect cxl_test root device id
>  json=$($CXL list -b cxl_test)
> 
> base-commit: 99da468880dba2ec61ba2d9fdf8d48fc3bae085e

