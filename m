Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309E3537FB
	for <nvdimm@lists.linux.dev>; Wed,  1 May 2024 21:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714598419; cv=none; b=bbY82WJoNuEa9xXCmx6qvpUUJ4NUmNAfigQvJw+0P7OabWAvqgyxTd18MTON4UL7djlyxzX5T2ngCp6akC4gmPFPWElTrVKNkAhVVojzncsOxlzJhnx4mKYGO1V2Pr6wOG2f7ZLDo59hf8FDE+2C7KSYUfEOv23dNKjnZLLG/ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714598419; c=relaxed/simple;
	bh=lUpmU5tHQFBtsBbtYElOFLxrSo0B3+YafQIQIWzlV1g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fqoXBsirmoQI/wRZC6wNfwjizZ1akYgFRCfwdxeqTNnewxeF35RdFPCvhJGm+iQc1SFx9ApNBEUfO0bQjz3dS9FC72PDSkACRx9L44jUxMmeaYEXsmyPLJdvrO9M1KQYlzEMk5VfuZJPVhoslhMriQ9it4lbVz9FfNd7z2Mxj8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UAEvM4GU; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UAEvM4GU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714598418; x=1746134418;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lUpmU5tHQFBtsBbtYElOFLxrSo0B3+YafQIQIWzlV1g=;
  b=UAEvM4GUwpzMjDuAvv7S0S5MUcUsbwyQHy/pF5DBJ04NdQXRzhaPpQmM
   rS9gUAYc6vg7ecrKR0y9qQb+59weKNVnWskWol+dp9lk+MHC0DstwF2rU
   nqyQywsT2sMhMrwLBVyRGkd9OuT7B3tw6wghHVvi2FZvubZ/LX3GG7otm
   xisGZgQ704zY7akGC1RqCLMMaGwdAKmYUCP7sZU0DAS7dynBjIjqBpFmX
   f1xUd5ZItwPXrdqSbmdaP+VFl+tPWSPdjnuJ7GDuCnn0kOUcqtm5kZJev
   U+HCToBidIBgCFYMC/JsV/wzxGDT4PByGRSHQSeF36yjd4iTPxXyohQkX
   A==;
X-CSE-ConnectionGUID: YuXrGPCZRd2lgT/G6asRdQ==
X-CSE-MsgGUID: 53T0WV74Sb2z9x9JBpv6UA==
X-IronPort-AV: E=McAfee;i="6600,9927,11061"; a="10221899"
X-IronPort-AV: E=Sophos;i="6.07,246,1708416000"; 
   d="scan'208";a="10221899"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2024 14:20:17 -0700
X-CSE-ConnectionGUID: YSAy4EVARLen6RdC91208Q==
X-CSE-MsgGUID: blMjP7OXSpquhu+jSxSvaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,246,1708416000"; 
   d="scan'208";a="58098248"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.124.221.175]) ([10.124.221.175])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2024 14:20:16 -0700
Message-ID: <44aeaf64-f3e6-4dfe-bb76-d5c317ec794d@intel.com>
Date: Wed, 1 May 2024 14:20:16 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ndctl] Build: Fix deprecated str.format() usage
To: Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, alison.schofield@intel.com
References: <20240501-vv-build-fix-v1-1-792eecb2183b@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240501-vv-build-fix-v1-1-792eecb2183b@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/1/24 1:25 PM, Vishal Verma wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> 
> New versions of Meson throw a warning around ndctl's use of
> 'str.format':
> 
>   WARNING: Broken features used:
>    * 1.3.0: {'str.format: Value other than strings, integers, bools, options, dictionaries and lists thereof.'}
> 
> Fix this by explicit string concatenation for building paths for the
> version script, whence the warnings originated.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Thanks for fixing this!
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  cxl/lib/meson.build    |  9 +++++----
>  daxctl/lib/meson.build | 10 ++++++----
>  ndctl/lib/meson.build  |  9 +++++----
>  3 files changed, 16 insertions(+), 12 deletions(-)
> 
> diff --git a/cxl/lib/meson.build b/cxl/lib/meson.build
> index 422a3513..3f47e495 100644
> --- a/cxl/lib/meson.build
> +++ b/cxl/lib/meson.build
> @@ -3,8 +3,9 @@ libcxl_version = '@0@.@1@.@2@'.format(
>    LIBCXL_REVISION,
>    LIBCXL_AGE)
>  
> -mapfile = files('libcxl.sym')
> -vflag = '-Wl,--version-script,@0@/@1@'.format(project_source_root, mapfile[0])
> +libcxl_dir_path = meson.current_source_dir()
> +libcxl_sym = files('libcxl.sym')
> +libcxl_sym_path = libcxl_dir_path / 'libcxl.sym'
>  
>  cxl = library('cxl',
>    '../../util/sysfs.c',
> @@ -21,8 +22,8 @@ cxl = library('cxl',
>    version : libcxl_version,
>    install : true,
>    install_dir : rootlibdir,
> -  link_args : vflag,
> -  link_depends : mapfile,
> +  link_args : '-Wl,--version-script=' + libcxl_sym_path,
> +  link_depends : libcxl_sym,
>  )
>  cxl_dep = declare_dependency(link_with : cxl)
>  
> diff --git a/daxctl/lib/meson.build b/daxctl/lib/meson.build
> index b79c6e59..b2c7a957 100644
> --- a/daxctl/lib/meson.build
> +++ b/daxctl/lib/meson.build
> @@ -4,8 +4,10 @@ libdaxctl_version = '@0@.@1@.@2@'.format(
>    LIBDAXCTL_AGE,
>  )
>  
> -mapfile = files('libdaxctl.sym')
> -vflag = '-Wl,--version-script,@0@/@1@'.format(project_source_root, mapfile[0])
> +libdaxctl_dir_path = meson.current_source_dir()
> +libdaxctl_sym = files('libdaxctl.sym')
> +libdaxctl_sym_path = libdaxctl_dir_path / 'libdaxctl.sym'
> +
>  
>  libdaxctl_src = [
>    '../../util/iomem.c',
> @@ -25,8 +27,8 @@ daxctl = library(
>    ],
>    install : true,
>    install_dir : rootlibdir,
> -  link_args : vflag,
> -  link_depends : mapfile,
> +  link_args : '-Wl,--version-script=' + libdaxctl_sym_path,
> +  link_depends : libdaxctl_sym,
>  )
>  
>  daxctl_dep = declare_dependency(link_with : daxctl)
> diff --git a/ndctl/lib/meson.build b/ndctl/lib/meson.build
> index abce8794..2907af7f 100644
> --- a/ndctl/lib/meson.build
> +++ b/ndctl/lib/meson.build
> @@ -3,8 +3,9 @@ libndctl_version = '@0@.@1@.@2@'.format(
>    LIBNDCTL_REVISION,
>    LIBNDCTL_AGE)
>  
> -mapfile = files('libndctl.sym')
> -vflag = '-Wl,--version-script,@0@/@1@'.format(project_source_root, mapfile[0])
> +libndctl_dir_path = meson.current_source_dir()
> +libndctl_sym = files('libndctl.sym')
> +libndctl_sym_path = libndctl_dir_path / 'libndctl.sym'
>  
>  ndctl = library(
>   'ndctl',
> @@ -32,8 +33,8 @@ ndctl = library(
>    version : libndctl_version,
>    install : true,
>    install_dir : rootlibdir,
> -  link_args : vflag,
> -  link_depends : mapfile,
> +  link_args : '-Wl,--version-script=' + libndctl_sym_path,
> +  link_depends : libndctl_sym,
>  )
>  ndctl_dep = declare_dependency(link_with : ndctl)
>  
> 
> ---
> base-commit: 7c8c993b87ee8471b4c138de549c39d1267f0067
> change-id: 20240501-vv-build-fix-5d72f9979fad
> 
> Best regards,
