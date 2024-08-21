Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8057D17107F
	for <nvdimm@lists.linux.dev>; Wed, 21 Aug 2024 21:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724277484; cv=none; b=PXtXVAwyGf22kd7jA3nzg1mhTqCuxqz0Ye2M9dsdqhXM6jiGru7OsrZbgMrPFNbmC1+d5Dlz0xSJvCW50Y6ZOkGs8rl5dMpSRSXu1bBKG5HZkQ+p9OK9eVbsPMRH2zNcPdw+EHh1fFDwnUsH3SlATwcyApUVJhEnOmp0PtnU5ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724277484; c=relaxed/simple;
	bh=cOlACYZKtHsnvPUZM9UN9RaiV3c9s/mgV1Tu0lgqm7w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pg/oYiIktK7UMaTa1aPjiNMTWzdC7MsnY/G6LOdx9u5fizb/vFJjQCCCdhZlu2ev/JQqqUvLxF7gCfEA5PWlpE7TJL+2ABEfLNBb+c8myhCTAOlHjZa1Z/EZHSKE2UWV9a9yp7j7xvUQB7R5aql5Ds5FmxmzdyqUcweuemWwlcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HIg5fW8e; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HIg5fW8e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724277482; x=1755813482;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cOlACYZKtHsnvPUZM9UN9RaiV3c9s/mgV1Tu0lgqm7w=;
  b=HIg5fW8es4etlGttrFqIzUVUV6239XG7mHlmNcEmszA/+0G+0xqoaIHH
   YnSYHRoj6RevIkgzPNCXZjVPveVHJd11UHgQxSfHw2SVgUf6T7/oT22dk
   eKRKvqZt7AY/GssbONKmolzC5z51RNzMq56wJUnHB9di6cyIjhwi429yy
   2Atz/ipPcQHzJ2gXDe/IEKo9PI/aOD8JBpG/kzWLB3BMvOa9hkNPPPzwL
   zjbaqXQoHlzuUcIsRXHOXxwaQP9d+0gCYvgItVX6w2idsERps2Z3uf9iO
   E/KyIerHvwDDmaM0k38I7+yAOODU/e/6cfAPfbwDsyUJV5mzrGR8zFriR
   g==;
X-CSE-ConnectionGUID: w9NlkDX9RUamFnHWdiCTlA==
X-CSE-MsgGUID: BTlqv77JRHOUmpkqZKtfUw==
X-IronPort-AV: E=McAfee;i="6700,10204,11171"; a="40178282"
X-IronPort-AV: E=Sophos;i="6.10,165,1719903600"; 
   d="scan'208";a="40178282"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2024 14:58:02 -0700
X-CSE-ConnectionGUID: rnsB9i9hT6Wb1pAwi0Np/g==
X-CSE-MsgGUID: K57G8qAISLeqwUOJxeLIbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,165,1719903600"; 
   d="scan'208";a="66109347"
Received: from cmdeoliv-mobl.amr.corp.intel.com (HELO [10.125.108.204]) ([10.125.108.204])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2024 14:58:01 -0700
Message-ID: <69919815-0bb3-4364-9573-1ff61d74adfb@intel.com>
Date: Wed, 21 Aug 2024 14:58:00 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] ndctl.spec.in: enable libtrace{event|fs} support
 for Fedora
To: alison.schofield@intel.com, Vishal Verma <vishal.l.verma@intel.com>,
 nvdimm@lists.linux.dev
Cc: Jerry James <loganjerry@gmail.com>
References: <20240821214529.96966-1-alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240821214529.96966-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/21/24 2:45 PM, alison.schofield@intel.com wrote:
> From: Jerry James <loganjerry@gmail.com>
> 
> As noted in https://src.fedoraproject.org/rpms/ndctl/pull-request/2,
> the expression "0%{?rhel}" evaluates to zero on Fedora, so the
> conditional "%if 0%{?rhel} < 9" evaluates to true, since 0 is less
> than 9. The result is that ndctl builds for Fedora lack support for
> libtraceevent and libtracefs. Correct the expression.
> 
> Reposted here from github pull request:
> https://github.com/pmem/ndctl/pull/266/
> 
> Signed-off-by: Jerry James <loganjerry@gmail.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  ndctl.spec.in | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/ndctl.spec.in b/ndctl.spec.in
> index cb9cb6fe0b86..ea9fadc266d8 100644
> --- a/ndctl.spec.in
> +++ b/ndctl.spec.in
> @@ -10,7 +10,7 @@ Requires:	LNAME%{?_isa} = %{version}-%{release}
>  Requires:	DAX_LNAME%{?_isa} = %{version}-%{release}
>  Requires:	CXL_LNAME%{?_isa} = %{version}-%{release}
>  BuildRequires:	autoconf
> -%if 0%{?rhel} < 9
> +%if 0%{?rhel} && 0%{?rhel} < 9
>  BuildRequires:	asciidoc
>  %define asciidoctor -Dasciidoctor=disabled
>  %define libtracefs -Dlibtracefs=disabled
