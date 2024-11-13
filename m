Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F92146A69
	for <nvdimm@lists.linux.dev>; Wed, 13 Nov 2024 04:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731473506; cv=none; b=T0HoaAfrL3S0+rsZMuexNPTPVcfCG6HwaZxshDNrwML+QQgmi335IS1kR2PXyMH6s7AX8h0cbN/H+64Brur8eOasttQZIUdgU3JY6qR4nSHNfnZXyoMg5MtGB58DwCPJ+9g5QIDznJv7HBfbJ8tePM3WG6VpmCqF/E2/0Kqk7cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731473506; c=relaxed/simple;
	bh=/1pRHDRrAZ9iIpgY02t018pfdsaFQcMvD4hdZMbo7HU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SuAuKXqVJUpJO1Ly+3Y4C90w4EHlzBI4SI5M/kXJd5dUYL9rSDu+YnjdQQWTbDm2T1yahNmU73ZTLVKyW8ZgbTVEYUMgEdUOIBY/5d6MBDVpK0PQFaWpfWWiTHhv4UxrdO0/N57rOpJEqgQIA0dnHI0EW2cmj/Xaxb9BRURo3co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=my525b8f; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="my525b8f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731473504; x=1763009504;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/1pRHDRrAZ9iIpgY02t018pfdsaFQcMvD4hdZMbo7HU=;
  b=my525b8fTuK9mWUDIApCLvb5ceZTRv3cWfnCIkIw00FyatQAJPTBXnH9
   CjudvjkhcYM2K0uhZ0w1B+lgLI6tKovhd14X6jCEdNdR/tTP6be3cqT74
   vaomgmE7o7tOUMgh92qOwpTkJH3UDEmbjW/ceqeSba43e07hT6aXG57A6
   b6W1YvZJ1bdPEinKl7ffPvWM6hnf6r70gGc/K5UKGiv0msT4H0m7vFZ84
   +rCfGQvlLRR00P0RUcR0vIlPn1qu2O48e5x6bC6FR8t083KKzKONTIMfV
   KVlUYqXvDFlQ+ClEtL0eUTrAaGMoLtBMwYa56mvPiaKHK9IvwcMiS5eLA
   g==;
X-CSE-ConnectionGUID: lsdIkxm8Qa6SbQMwbZ9SAQ==
X-CSE-MsgGUID: Okf4GaHqSc+CL0KJq99Yqg==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="30746310"
X-IronPort-AV: E=Sophos;i="6.12,150,1728975600"; 
   d="scan'208";a="30746310"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 20:51:43 -0800
X-CSE-ConnectionGUID: XRPXDymmT0C0dzE/kkXdkA==
X-CSE-MsgGUID: hvvj7OAnTYm4tn+HILU6Lw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,150,1728975600"; 
   d="scan'208";a="92518723"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.111.153])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 20:51:43 -0800
Date: Tue, 12 Nov 2024 20:51:41 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Suraj Sonawane <surajsonawane0215@gmail.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, rafael@kernel.org,
	lenb@kernel.org, nvdimm@lists.linux.dev, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] acpi: nfit: vmalloc-out-of-bounds Read in
 acpi_nfit_ctl
Message-ID: <ZzQwXXSwioLsG8vv@aschofie-mobl2.lan>
References: <20241112052035.14122-1-surajsonawane0215@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241112052035.14122-1-surajsonawane0215@gmail.com>

On Tue, Nov 12, 2024 at 10:50:35AM +0530, Suraj Sonawane wrote:
> Fix an issue detected by syzbot with KASAN:
> 
> BUG: KASAN: vmalloc-out-of-bounds in cmd_to_func drivers/acpi/nfit/
> core.c:416 [inline]
> BUG: KASAN: vmalloc-out-of-bounds in acpi_nfit_ctl+0x20e8/0x24a0
> drivers/acpi/nfit/core.c:459
> 
> The issue occurs in `cmd_to_func` when the `call_pkg->nd_reserved2`
> array is accessed without verifying that `call_pkg` points to a
> buffer that is sized appropriately as a `struct nd_cmd_pkg`. This
> could lead to out-of-bounds access and undefined behavior if the
> buffer does not have sufficient space.
> 
> To address this issue, a check was added in `acpi_nfit_ctl()` to
> ensure that `buf` is not `NULL` and `buf_len` is greater than or
> equal to `sizeof(struct nd_cmd_pkg)` before casting `buf` to
> `struct nd_cmd_pkg *`. This ensures safe access to the members of
> `call_pkg`, including the `nd_reserved2` array.
> 
> This change preventing out-of-bounds reads.
> 
> Reported-by: syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=7534f060ebda6b8b51b3
> Tested-by: syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
> Fixes: 2d5404caa8c7 ("Linux 6.12-rc7")
> Signed-off-by: Suraj Sonawane <surajsonawane0215@gmail.com>

Suraj,

The fixes tag needs to be where the issue originated, not
where you discovered it (which I'm guessing was using 6.12-rc7).

Here's how I find the tag:

$ git blame drivers/acpi/nfit/core.c | grep call_pkg | grep buf
ebe9f6f19d80d drivers/acpi/nfit/core.c (Dan Williams       2019-02-07 14:56:50 -0800  458) 		call_pkg = buf;

$ git log -1 --pretty=fixes ebe9f6f19d80d
Fixes: ebe9f6f19d80 ("acpi/nfit: Fix bus command validation")

I think ^ should be your Fixes tag. 



snip

> 
