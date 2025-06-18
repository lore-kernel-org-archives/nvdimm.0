Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCF421B8F5
	for <nvdimm@lists.linux.dev>; Wed, 18 Jun 2025 22:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750285919; cv=none; b=EEaMuv5dmLf1G+H9LJVRWeUw/HSUR42UeP37r7OzdA0N2uBXYz0zj3DxUWFZ09omeRNmayTP0cu9UXifKEKVOlyDc9KmXaKNW+7e8Z1hurhjHKvHMT4uCP6l8RwSQ1KISnBq3vpqKMJf0QGAGnGvH1UZcan7fvMLpZezIYkvYhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750285919; c=relaxed/simple;
	bh=Gpkx/jLqNPKgh8ElmAdfWN5ENxp3bIjOKNgb0ETV/Ho=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GdIfYleakvLSv3rIPS/yCL7fIDRhLQyf/oXHGS2I6xsb0/r4XaXLUwFD1foa6h2jnKnYCqKi52iGjQJ/unAhok+dq+d/F8cSNroDZs8p920F+HhJr2fSUUMaxBgFQXs70g6YwAa4fWZ7mrAAFaIHH7N2zXALmhllNQnZGzBsCMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ECywaFMu; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ECywaFMu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750285918; x=1781821918;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Gpkx/jLqNPKgh8ElmAdfWN5ENxp3bIjOKNgb0ETV/Ho=;
  b=ECywaFMuyuiTLQuH/8OenTxAu5MZY/ljTG0W236NJUnnkagR/Ye/ME1+
   uiL0y5bR/srIk5vGa/vUVOCvS/a434UM1HrxogNmie0wXtPi0DkvkqFwE
   KCcwFC4EkewD6RwAoDGH/ypk7Tz38s3G599E8riqTE1lAtU5o+RjD9L6F
   5SHXO7d/UlHhMaqGAhGTCa3yJyOFFnCjJY7iKNLeNjBc+oQNrfDtsguCr
   NmXH+583WCWWH/+zMB9QkZmng461y9YuPJcNCsBaOtrTBe8A+fjXc0+zJ
   zv7tEdjdhJHawiYrvbVknYuvH8isVijuuXduxofLR8uFWlE9V5ODvwOh3
   A==;
X-CSE-ConnectionGUID: E8chBi6DQ7Wnn72dPDeZYw==
X-CSE-MsgGUID: tewmXJziQiWmqy9kCav7Ww==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="40136528"
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="40136528"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:31:57 -0700
X-CSE-ConnectionGUID: Tm7c4ONHT9uFTT75SM3n4Q==
X-CSE-MsgGUID: qdtz+4U9R3abcusPuznRsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="150951384"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO [10.125.108.99]) ([10.125.108.99])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:31:53 -0700
Message-ID: <014b7ab9-d9b6-48a5-bd54-28705ea52b64@intel.com>
Date: Wed, 18 Jun 2025 15:31:49 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 4/5] test: Update documentation with required
 packages to install
To: Dan Williams <dan.j.williams@intel.com>, alison.schofield@intel.com
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <20250618222130.672621-1-dan.j.williams@intel.com>
 <20250618222130.672621-5-dan.j.williams@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250618222130.672621-5-dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/18/25 3:21 PM, Dan Williams wrote:
> After recently needing to manually rebuild a test environment I discovered
> the dependencies that need to be installed. Add a section to the README for
> package dependencies.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  README.md | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/README.md b/README.md
> index ac24eeb28b6b..1943fd66d432 100644
> --- a/README.md
> +++ b/README.md
> @@ -85,6 +85,11 @@ loaded.  To build and install nfit_test.ko:
>     CONFIG_TRANSPARENT_HUGEPAGE=y
>     ```
>  
> +1. Install the following packages, (Fedora instructions):
> +   ```
> +   dnf install e2fsprogs xfsprogs parted jq trace-cmd hostname fio fio-engine-dev-dax
> +   ```
> +
>  1. Build and install the unit test enabled libnvdimm modules in the
>     following order.  The unit test modules need to be in place prior to
>     the `depmod` that runs during the final `modules_install`  

