Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CE3215065
	for <nvdimm@lists.linux.dev>; Mon,  3 Mar 2025 20:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741032303; cv=none; b=dDWOjLf/xxyRkiBA2DX84TBRpdOvLN41/PaVxx2k6EV0iYQvxHkhIvwV47IHMG9iE1QBlgLTm/fy/O+awmL5f5aZwEApCffjyIlPsoXzvOEDbMREisSfFamAQy5l6JGzJguV6lSTJUnmULpYJPU+Hj1KBCkrQxwKiyd6JVD5WKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741032303; c=relaxed/simple;
	bh=ZP1OxJciFfXGxm2zCO4JtFQsCxlx/flcPytrD7bnehk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ya7lkuHjOKUS8u8h8uXdtegiJcNh+hN4NVaPQYyKavAN6+7baj7d9TlS0vEiY3Fx9oOgQEZirYsiLo18Qc9TAUzDTGmfZWCXzt5K1ngIhJ/qcOFnvRCg7/2FKiUdyQco4tzLKcvVuzRjnlmkfEn6ebhbY9FVVLv0IEnuhmsGkpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NoUVax4i; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NoUVax4i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741032302; x=1772568302;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZP1OxJciFfXGxm2zCO4JtFQsCxlx/flcPytrD7bnehk=;
  b=NoUVax4iQ1w2V2m4hPOYwQ99Ca5SlI2ZHTB06jB+UPpZ2kONJIE5r8sC
   +IqUTy9O3+EDSOIbk296No5Aek8fx+VKKKBgMY7lcm8FplI53LT64gIIt
   6ST4j2x51NBs/1JhbVi+XPNXX9jVAUK4zoIOYas9sj0t2WRuarKoo2JvI
   /d5rDsEvIgu361ccka6qfCSFjFfQAQ00WJ+iuQJd8rsug/M62npJB7RQt
   hWys7oPJsaYgpqLaHFedTrPn3P+Va7jRtvvDSwUz9MGCvaC0PsOjkA8H6
   RmLppiGJj8vKfO8M/z67ahICY1XLp9D28qmcoQDGnevBvXXbeFzgIREN9
   A==;
X-CSE-ConnectionGUID: MIHNGSxYRIy2/KYdcovT8A==
X-CSE-MsgGUID: ovhyfZmcQhKuRnRCNUB7Zw==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="45702279"
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="45702279"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 12:05:02 -0800
X-CSE-ConnectionGUID: fY6XEs2ER7+NGADkla/eew==
X-CSE-MsgGUID: 48Mb+S3LSKCCQdDkIha+mw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="122773445"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.109.46])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 12:05:00 -0800
Date: Mon, 3 Mar 2025 12:04:59 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Li Ming <ming.li@zohomail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 1/1] daxctl: Output more information if memblock is
 unremovable
Message-ID: <Z8YLawbD-nwMU2bf@aschofie-mobl2.lan>
References: <20241204161457.1113419-1-ming.li@zohomail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241204161457.1113419-1-ming.li@zohomail.com>

On Thu, Dec 05, 2024 at 12:14:56AM +0800, Li Ming wrote:
> If CONFIG_MEMORY_HOTREMOVE is disabled by kernel, memblocks will not be
> removed, so 'dax offline-memory all' will output below error logs:
> 
>   libdaxctl: offline_one_memblock: dax0.0: Failed to offline /sys/devices/system/node/node6/memory371/state: Invalid argument
>   dax0.0: failed to offline memory: Invalid argument
>   error offlining memory: Invalid argument
>   offlined memory for 0 devices
> 
> The log does not clearly show why the command failed. So checking if the
> target memblock is removable before offlining it by querying
> '/sys/devices/system/node/nodeX/memoryY/removable', then output specific
> logs if the memblock is unremovable, output will be:
> 
>   libdaxctl: offline_one_memblock: dax0.0: memory371 is unremovable
>   dax0.0: failed to offline memory: Operation not supported
>   error offlining memory: Operation not supported
>   offlined memory for 0 devices
> 
> Besides, delay to set up string 'path' for offlining memblock operation,
> because string 'path' is stored in 'mem->mem_buf' which is a shared
> buffer, it will be used in memblock_is_removable().
> 
> Signed-off-by: Li Ming <ming.li@zohomail.com>
> ---

Merged to https://github.com/pmem/ndctl/commits/pending/

Per my earlier message, if you want to update the list output too,
send another patch.


snip

 
