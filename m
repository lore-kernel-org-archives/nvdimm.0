Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB4A1EC011
	for <nvdimm@lists.linux.dev>; Wed, 12 Feb 2025 16:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739376071; cv=none; b=ngPp+oHAd23seWDEIzghiXDB+EBXw49VV0+mTtbo0NZrFJ0/i508KZtyN6gKSueinFVRL7tf3D6kt261KsLQoBW3tPoROhIJlEJ/EUJyOhaJx9qVt/raG/vsGw6DgdjsAu+mvE9hSlolYE7Y2TgeLtJ+HgmJFcEJRqiWTld8pB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739376071; c=relaxed/simple;
	bh=4FsYbVqGywo4IcI5Coq7GfRZ5qiRUoK0fdplN7YYbLE=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HO0sA8+hXQyP06PKizj/Wn2lXlWpObtmQccZJYa4S3UZdVVA1Hzad1Z2Yt7W1pUnD+vAAl/xktlCGePJ6CqXkX10TmpMViwxZg6WjfLd4OcYTKSiJWoZGJPw2gno8pUtXo3dYUWTV5n/gD9SvKYrWVFhTTzffgqjA7wGsOzZYzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VFmqYReM; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VFmqYReM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739376069; x=1770912069;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=4FsYbVqGywo4IcI5Coq7GfRZ5qiRUoK0fdplN7YYbLE=;
  b=VFmqYReMyDT6JRMjkLDRHZDPviAxNDFxTQggtsi0V8aU49z5OZtiXSpi
   5wNB3aem9Ml296G7Xn+qUB4bZ2dR2uO/+r/XnhcMuH5cFDLxJDpbPPQyY
   lrOhTr4Ay69hSfprzgceNCSH3jmoYnJZ4SuZoNW7yxzVqRGyKglkog2eg
   ce02sUd0dXctjl+bKgNNelmJ/mCFNLJJBjHF2EHWhyWNUBQsRYCAjtJif
   /dE75wMdx5AYNJjUmilI364C4cXywDtZ5YE1WkH+n3WYSqG7B4X6nsOhL
   o3p42WHVTrn9B/sce33a+inr0CB3mZc7HAUl2eRX6w0YcSgYU4C7WWfv4
   g==;
X-CSE-ConnectionGUID: o6RAuY3ESqaffO3DFfoPYQ==
X-CSE-MsgGUID: BOAi/y9wTICvMUXnWxqGOw==
X-IronPort-AV: E=McAfee;i="6700,10204,11343"; a="39230189"
X-IronPort-AV: E=Sophos;i="6.13,280,1732608000"; 
   d="scan'208";a="39230189"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 08:01:09 -0800
X-CSE-ConnectionGUID: sYFDVehRQxqTIdzaEgkhQA==
X-CSE-MsgGUID: g9M1uB7yROe0T8EBQ8JDxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,280,1732608000"; 
   d="scan'208";a="112711469"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.108.123])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 08:01:08 -0800
Date: Wed, 12 Feb 2025 08:01:06 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] util/strbuf: remove unused cli infrastructure
 imports
Message-ID: <Z6zFwkCh7DXNDqUl@aschofie-mobl2.lan>
References: <20250212034020.1865719-1-alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250212034020.1865719-1-alison.schofield@intel.com>

On Tue, Feb 11, 2025 at 07:40:18PM -0800, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> The ndctl cli interface is built around an imported perf cli
> infrastructure which was originally from git. [1]
> 
> A recent static analysis scan exposed an integer overflow issue in
> sysbuf_read() and although that is fixable, the function is not used
  ^^^
  strbuf_read()


> in ndctl. Further examination revealed additional unused functionality
> in the string buffer handling import and a subset of that has already
> been obsoleted from the perf cli.
> 
> In the interest of not maintaining unused code, remove the unused code
> in util/strbuf.h,c. Ndctl, including cxl-cli and daxctl, are mature
> cli's so it seems ok to let this functionality go after 14 years.
> 
> In the interest of not touching what is not causing an issue, the
> entirety of the original import was not reviewed at this time.
> 
> [1] 91677390f9e6 ("ndctl: import cli infrastructure from perf")
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  util/strbuf.c | 51 ---------------------------------------------------
>  util/strbuf.h |  7 -------
>  2 files changed, 58 deletions(-)

snip

