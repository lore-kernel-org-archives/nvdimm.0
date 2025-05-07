Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882BD20E700
	for <nvdimm@lists.linux.dev>; Wed,  7 May 2025 22:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746657678; cv=none; b=dyiQ9MqTg0u9lwKlMjQz9zmh9zfNCFmZCHOHktmqxZ376oqD9sQk61eMOSyPL5+O1pfkq4xlUHSTFoXEPY569Jfy4wIrjuEK1B9+tj/vE0juPgCVQoaagLaSvbDeUYxz59dPQW+7koabkcMIJLbW0dEyN1T/8Q5MxRuemz536B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746657678; c=relaxed/simple;
	bh=bVBAV/l/oQchOwOUjd82Rm7zE+GkQFLAfDTwB40czc8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=IykvpUpvG5hrG2N6sajlP3NqkGuiCLcG1pIpvmmvixoDvq212eb3CbCkHFg3tK+klYpfagEgic02BdRBsc+WFWdr2BWNZJbh2bo+K5juqJjSuwyAVg1tPOqFbMGti+fH+0lbMIwvyyY3hsy1XwUrCRcETwKtmIgneOcKSJoaSPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IfkmKbJp; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IfkmKbJp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746657676; x=1778193676;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=bVBAV/l/oQchOwOUjd82Rm7zE+GkQFLAfDTwB40czc8=;
  b=IfkmKbJprf8KQKAkPDB9EagGHYQQgqSidN702uKWRyKqXQOWsYhAIm/x
   WFfclHi1v6omfQFZwqXderxFDdW6G00I9tQLJdZ35YQtDMw9FIWm8yBvj
   +1ZHgV72itxoAxOadsWFV3xd2gql/4y6xXiI8rB1RPgyXQfS5d6WkvKqq
   JJ56efu34q5f9YtPpj+TTiqQUoqo0diU1TFW4iqOV1doYHW5fj5B6cWOV
   cvP0b00FoS/xXmAXIAzsFPQo80WPSdtiAxFkRc++fFO1bG3Pj4Lxb7JsI
   uk7JgtickD36VAd0lzKzwUL+m0YP8hfDP4LVLFBsrGdVBUqXJcuOG/E4y
   A==;
X-CSE-ConnectionGUID: hSX7PKsuSyOlAO4TiYafMA==
X-CSE-MsgGUID: m7gVzEwTSDyl2GM3utlI/Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="52069371"
X-IronPort-AV: E=Sophos;i="6.15,270,1739865600"; 
   d="scan'208";a="52069371"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 15:41:15 -0700
X-CSE-ConnectionGUID: JE0oXrIBQoyFRV4aeJedww==
X-CSE-MsgGUID: MphzKSb3SImKPGfVG+zrJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,270,1739865600"; 
   d="scan'208";a="141221301"
Received: from mgoodin-mobl2.amr.corp.intel.com (HELO [10.125.108.17]) ([10.125.108.17])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 15:41:15 -0700
Message-ID: <a34e0710-eed9-4010-a7ae-89c6af233cc2@intel.com>
Date: Wed, 7 May 2025 15:41:12 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] test/meson.build: add missing
 'CXL=@0@'.format(cxl_tool.full_path()),
To: marc.herbert@linux.intel.com, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev
References: <20250507161547.204216-1-marc.herbert@linux.intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250507161547.204216-1-marc.herbert@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/7/25 9:15 AM, marc.herbert@linux.intel.com wrote:
> From: Marc Herbert <marc.herbert@linux.intel.com>
> 
> This fixes the ability to copy and paste the helpful meson output when a
> test fails, in order to re-run a failing test directly outside meson and
> from any current directory.
> 
> meson never had that problem because it always switches to a constant
> directory before running the tests.
> 
> Fixes commit ef85ab79e7a4 ("cxl/test: Add topology enumeration and
> hotplug test") which added the (failing) search for the cxl binary.
> 
> Signed-off-by: Marc Herbert <marc.herbert@linux.intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  test/meson.build | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/test/meson.build b/test/meson.build
> index d871e28e17ce..2fd7df5211dd 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -255,6 +255,7 @@ foreach t : tests
>      env : [
>        'NDCTL=@0@'.format(ndctl_tool.full_path()),
>        'DAXCTL=@0@'.format(daxctl_tool.full_path()),
> +      'CXL=@0@'.format(cxl_tool.full_path()),
>        'TEST_PATH=@0@'.format(meson.current_build_dir()),
>        'DATA_PATH=@0@'.format(meson.current_source_dir()),
>      ],

