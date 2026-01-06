Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4D82E1EF8
	for <nvdimm@lists.linux.dev>; Tue,  6 Jan 2026 15:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767714102; cv=none; b=GAHcFQco7YO0o65Mhz4q5tsqO5G0FRFJtLV20i186hAhE568tRxH3KeRAM7/VC5JT7B8fOP8Of9kc39/H/pK3iEXDJCH3s7quSsTynD9FzoTPTs9r1mzpEtEnbQgaH/AgWPZsHg0crwOLf66tEymNJANeBkARli1Ukh0ngUpdWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767714102; c=relaxed/simple;
	bh=CNpGKvJQRTD7YvSwspXKiImCgI0NJYjdpwnxa5wzF7o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UwlCV8Dsu5oh1GNs9GOFpeBGE8+Jxd5fsU01hoXnjQwyfofBdc6UMLinP+EjTK9SWiD4g0pn6cu/X9K2irYyf1uJzzw7KRhXgf2P8yIxVXJFx51SuKmvJiszpcKk2DA/lognNdUsQC7QZzy4xhq0+rEygpwJezzXK/FlOz7YpWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ehgwynis; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ehgwynis"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767714099; x=1799250099;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CNpGKvJQRTD7YvSwspXKiImCgI0NJYjdpwnxa5wzF7o=;
  b=ehgwynisERrncdyDcuL/5sBXNim2sXY7bWQhU36prV960KKK371gU8Fh
   0odWXMRnU+XhHEZNFgDMD6IbNuquf4JG+i9rBHD5ZKZO81EKuz2gfiMiB
   DXewJDCmnPCoZut0Uds8WsGwSYFUIhZC5VBBHIQ2azA1WmovHmoc2Fy5e
   6dRcMlMJD8Rz4bxyNi7xmiGD1ZRK9sHBEnAHEcjZwj1U7A9mEkdFKXsOr
   uI1utn4M0ZGvC117g3vwH4FE2yd+o6tdONWCjKHxSc/jVDwA7yGMeFJlz
   iT/xduHDKYPsU8A3BCKxgsmbJSbMHRWLdfd9AS6vKL1klvQC1ETP279zG
   g==;
X-CSE-ConnectionGUID: dMYcBSylQSu3RvfhdJ04lg==
X-CSE-MsgGUID: D+YGpOibRuC3OPhr4I1Gvw==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="94547517"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="94547517"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 07:41:37 -0800
X-CSE-ConnectionGUID: Bimlg/gxQhGqKO0oXVtDOg==
X-CSE-MsgGUID: fUA7NRoNQKm/p1LfBPRxog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="207553589"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.109.101]) ([10.125.109.101])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 07:41:37 -0800
Message-ID: <b328f1cc-dcf8-4e44-80d6-b95a1e4c2ba5@intel.com>
Date: Tue, 6 Jan 2026 08:41:35 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] ndctl/lib: move nd_cmd_pkg with a flex array to end
 of structures
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev
Cc: Cristian Rodriguez <yo@cristianrodriguez.net>
References: <20260106035209.322010-1-alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260106035209.322010-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/5/26 8:52 PM, Alison Schofield wrote:
> Placing nd_cmd_pkg anywhere but at the end of a structure can lead to
> undefined behavior for the flex array member. Move nd_cmd_pkg to the
> end of all affected structures.
> 
> Reproduce using Clang:
> ~/git/ndctl$ rm -rf build
> ~/git/ndctl$ CC=clang meson setup build
> ~/git/ndctl$ meson compile -C build
> 
> ../ndctl/lib/hpe1.h:324:20: warning: field 'gen' with variable sized type 'struct nd_cmd_pkg' not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
> 
> Reported-by: Cristian Rodriguez <yo@cristianrodriguez.net>
> Closes: https://github.com/pmem/ndctl/issues/296
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

I wonder if a comment needs to be inserted to the definition of 'nd_cmd_pkg' to warn users that the struct should never be placed anywhere besides the end when used as a member of another struct.

> ---
>  ndctl/lib/hpe1.h      | 2 +-
>  ndctl/lib/hyperv.h    | 2 +-
>  ndctl/lib/intel.h     | 2 +-
>  ndctl/lib/msft.h      | 2 +-
>  ndctl/lib/papr.h      | 2 +-
>  ndctl/libndctl-nfit.h | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/ndctl/lib/hpe1.h b/ndctl/lib/hpe1.h
> index bc19f72ca8d0..99d8f57eb8e0 100644
> --- a/ndctl/lib/hpe1.h
> +++ b/ndctl/lib/hpe1.h
> @@ -321,8 +321,8 @@ union ndn_hpe1_cmd {
>  };
>  
>  struct ndn_pkg_hpe1 {
> -	struct nd_cmd_pkg gen;
>  	union ndn_hpe1_cmd u;
> +	struct nd_cmd_pkg gen;
>  } __attribute__((packed));
>  
>  #define NDN_IOCTL_HPE1_PASSTHRU		_IOWR(ND_IOCTL, ND_CMD_CALL, \
> diff --git a/ndctl/lib/hyperv.h b/ndctl/lib/hyperv.h
> index 45741c7cdd17..9157f1563632 100644
> --- a/ndctl/lib/hyperv.h
> +++ b/ndctl/lib/hyperv.h
> @@ -31,8 +31,8 @@ union nd_hyperv_cmd {
>  } __attribute__((packed));
>  
>  struct nd_pkg_hyperv {
> -	struct nd_cmd_pkg	gen;
>  	union  nd_hyperv_cmd	u;
> +	struct nd_cmd_pkg	gen;
>  } __attribute__((packed));
>  
>  #endif /* __NDCTL_HYPERV_H__ */
> diff --git a/ndctl/lib/intel.h b/ndctl/lib/intel.h
> index 5aee98062a84..09f8cf7745ce 100644
> --- a/ndctl/lib/intel.h
> +++ b/ndctl/lib/intel.h
> @@ -141,7 +141,6 @@ struct nd_intel_lss {
>  } __attribute__((packed));
>  
>  struct nd_pkg_intel {
> -	struct nd_cmd_pkg gen;
>  	union {
>  		struct nd_intel_smart smart;
>  		struct nd_intel_smart_inject inject;
> @@ -154,6 +153,7 @@ struct nd_pkg_intel {
>  		struct nd_intel_fw_finish_query fquery;
>  		struct nd_intel_lss lss;
>  	};
> +	struct nd_cmd_pkg gen;
>  };
>  
>  #define ND_INTEL_STATUS_MASK		0xffff
> diff --git a/ndctl/lib/msft.h b/ndctl/lib/msft.h
> index 8d246a5ed137..65789950abe1 100644
> --- a/ndctl/lib/msft.h
> +++ b/ndctl/lib/msft.h
> @@ -41,8 +41,8 @@ union ndn_msft_cmd {
>  } __attribute__((packed));
>  
>  struct ndn_pkg_msft {
> -	struct nd_cmd_pkg	gen;
>  	union ndn_msft_cmd	u;
> +	struct nd_cmd_pkg	gen;
>  } __attribute__((packed));
>  
>  #define NDN_MSFT_STATUS_MASK		0xffff
> diff --git a/ndctl/lib/papr.h b/ndctl/lib/papr.h
> index 77579396a7bd..4f35bc60017f 100644
> --- a/ndctl/lib/papr.h
> +++ b/ndctl/lib/papr.h
> @@ -8,8 +8,8 @@
>  
>  /* Wraps a nd_cmd generic header with pdsm header */
>  struct nd_pkg_papr {
> -	struct nd_cmd_pkg gen;
>  	struct nd_pkg_pdsm pdsm;
> +	struct nd_cmd_pkg gen;
>  };
>  
>  #endif /* __PAPR_H__ */
> diff --git a/ndctl/libndctl-nfit.h b/ndctl/libndctl-nfit.h
> index 9ec0db55776d..020dc7384a98 100644
> --- a/ndctl/libndctl-nfit.h
> +++ b/ndctl/libndctl-nfit.h
> @@ -77,13 +77,13 @@ struct nd_cmd_ars_err_inj_stat {
>  } __attribute__((packed));
>  
>  struct nd_cmd_bus {
> -	struct nd_cmd_pkg gen;
>  	union {
>  		struct nd_cmd_ars_err_inj_stat err_inj_stat;
>  		struct nd_cmd_ars_err_inj_clr err_inj_clr;
>  		struct nd_cmd_ars_err_inj err_inj;
>  		struct nd_cmd_translate_spa xlat_spa;
>  	};
> +	struct nd_cmd_pkg gen;
>  };
>  
>  int ndctl_bus_is_nfit_cmd_supported(struct ndctl_bus *bus, int cmd);

