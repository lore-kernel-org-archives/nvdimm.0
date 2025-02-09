Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65682C2FA
	for <nvdimm@lists.linux.dev>; Sun,  9 Feb 2025 01:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739064076; cv=none; b=qGxGWy86FIMVyeu/hQYI5niVlQDXLuSFHqaUShqYTsoTcc4mRIJCGMFn/8yO7pQ5n2hCSOwIBh5RiwS1hlgvopZErJ9oFc91kRZxJrXuBGbdueMaZ3SQnH40r0II+/d1vPTvRvHuWLkLuBYAZhZT5SpuonO/mb86MCXsPmisAxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739064076; c=relaxed/simple;
	bh=EU0vvjvElMG7VijPF380pawRKAzzbl1R8WB+1dcSFnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bhesl2nhDedMdlMLS+bgLXTQwwpZ/VS/CRsFk+gH0eLxXesTPRLftI7IOrHIb0hYJmnh+kYKrknk6ISxQrjbgIMLb4jeWXlxkjOP5Euh0utl1KTl0GU52oWJOTkIWvXmtEsrFN37mWRlOEciZ75DErwDNfBxbKFZdYJoKM19DCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S2fcNdDl; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S2fcNdDl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739064074; x=1770600074;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EU0vvjvElMG7VijPF380pawRKAzzbl1R8WB+1dcSFnw=;
  b=S2fcNdDlrNxI2t5Q5QYCVXTo1JwjGAwfMtLVw4B3f3dtQkXhmBdXbwBr
   AQvm5UXEYSfFyXyLolYWC5ILBxK86/5RjPnx1CchZC/0Fb93BX4FeUSAr
   GVVj6Eb9Ps9RVqG+hgQk15PVO5nWXfmoF/we19QWntG/JWGBSNmDF4few
   c3Z/muBZuo2KeidIIJKzEGdjd3986enmFn5UHAgQYpz3XSvJZyDkUwTx6
   met+7hlj7NwGBm6Yg5QWRzUvWthyHPSb5Ef2+CvDsGUYYZNpAGHvXHP4d
   Ags38LZw1hAstP3j77LfLZpPEhoQSaYDVLCEOEUKo0j5kx4rkJxLugBjx
   Q==;
X-CSE-ConnectionGUID: Ag+KOLG/Scao2/fRf8r0NA==
X-CSE-MsgGUID: NpF59rQ/RaaRCAemXh4OYg==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="39789841"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="39789841"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2025 17:21:13 -0800
X-CSE-ConnectionGUID: 8armEJQ6QfqTWtg9JvKX2A==
X-CSE-MsgGUID: aV0ZbmbxRwmJLNeL3S5Sbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,271,1732608000"; 
   d="scan'208";a="112488085"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.111.139])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2025 17:21:13 -0800
Date: Sat, 8 Feb 2025 17:21:11 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Li Zhijian <lizhijian@fujitsu.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v3 2/2] test/monitor.sh: Fix shellcheck SC2086
 issues as more as possible
Message-ID: <Z6gDB4XhDk8_Zuu0@aschofie-mobl2.lan>
References: <20241018013020.2523845-1-lizhijian@fujitsu.com>
 <20241018013020.2523845-2-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241018013020.2523845-2-lizhijian@fujitsu.com>

On Fri, Oct 18, 2024 at 09:30:20AM +0800, Li Zhijian wrote:
> SC2086 [1], aka. Double quote to prevent globbing and word splitting.
> 
> Previously, SC2086 will cause error in [[]] or [], for example
> $ grep -w line build/meson-logs/testlog.txt
> test/monitor.sh: line 99: [: too many arguments
> test/monitor.sh: line 99: [: nmem0: binary operator expected
> 
> Firstly,  generated diff by shellcheck tool:
> $ shellcheck -i SC2086 -f diff test/monitor.sh
> 
> In addition, we have remove the double quote around $1 like below
> changes. That's because when an empty "$1" passed to a command will open to ''
> it would cause an error, for example
> $ ndctl/build/test/list-smart-dimm -b nfit_test.0 ''
>   Error: unknown parameter ""
> 
> -       $NDCTL monitor -c "$monitor_conf" -l "$logfile" "$1" &
> +       $NDCTL monitor -c "$monitor_conf" -l "$logfile" $1 &
> 
> -       jlist=$("$TEST_PATH"/list-smart-dimm -b "$smart_supported_bus" "$1")
> +       jlist=$("$TEST_PATH"/list-smart-dimm -b "$smart_supported_bus" $1)
> 
> -       $NDCTL inject-smart "$monitor_dimms" "$1"
> +       $NDCTL inject-smart "$monitor_dimms" $1
> 
> -       [[ $1 == $notify_dimms ]]
> +       [[ "$1" == "$notify_dimms" ]]
> 
> -               [ ! -z "$monitor_dimms" ] && break
> +               [[ "$monitor_dimms" ]] && break
> 
> [1] https://www.shellcheck.net/wiki/SC2086
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>

Thanks! Applied to https://github.com/pmem/ndctl/tree/pending
with [ alison: edited commit msg/log ]

snip
