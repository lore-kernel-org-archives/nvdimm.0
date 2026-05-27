Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A744F34EEE3
	for <nvdimm@lists.linux.dev>; Wed, 27 May 2026 21:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779917675; cv=none; b=JrR1n/yG7wJIEBTR3HefflM4JdU/04kn6v1afP5RIFUy52NqumqHBJ4ci6dsUWumXTh2ROD4nWL4no82uhSzAtL0hyUfLN0nQrmtbZUXn+QD2N7JSCDnoGzXAUtCDwjUmuee3cO1uXJ59SS21ibuw360BAEn1zYBVIo7Fw6tecY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779917675; c=relaxed/simple;
	bh=4HtiqdH2gnJwfhqzp6lZSvTIbZ3f77f4a3Y3AUKwcXI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a/0oC5AqtoKCQOPCzbsHiWAQxOWvdQMg2b64+RSErnrNmpS4fM5k9WLMnGM6TBNNDt7RAubwCMUJ8/KBLE1WO4HAUj208Kjy125qIgI2ZsOz6Nt6cCSX5f5O0zo0kDXPGXdYQk9OU+BTHQKzSOvn2lA1WhQKtAeIz2duBYRPC4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nM4VakVB; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nM4VakVB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779917674; x=1811453674;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4HtiqdH2gnJwfhqzp6lZSvTIbZ3f77f4a3Y3AUKwcXI=;
  b=nM4VakVBmHz9ZI8OYsofRqMJClsieQp23ReEaDNQSrnSvL+czgyNzJWO
   xsBgCZI8w9zRbDWRe6h4SeknzhJeNB7You2UQjTb4zzGlfAgGaJI0ps+m
   h1OCRDNPEYIBJidwap2kaj5rP4oMn4deNFvQaiK/msk40DPsIv4GamqOn
   UYeoP725w78CWoDJ6GVFqGTX8ZXVM62yOSC9innBp49wWfXo+YkioZQqB
   L8Viliusmb7l685uT+KaOPOEDqRfLEj1aWcNp7i7GnVdiHzQwmGWqcjDh
   3/7jsFU1ZsqgTT3y03hqOD5rvgL9y5dZqkgsd9wkOj2jy4/YLTN4V4AJi
   g==;
X-CSE-ConnectionGUID: 3J0iGD41RaSofyaKNriJGg==
X-CSE-MsgGUID: PA6AHJ5xQs20ErjIaU0T/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="92146407"
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="92146407"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 14:34:33 -0700
X-CSE-ConnectionGUID: IDJsD9mQQyeifdLTyyq1CQ==
X-CSE-MsgGUID: GNzTjLvoQACC9QqqNZseRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="242510319"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.111.23]) ([10.125.111.23])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 14:34:32 -0700
Message-ID: <dfab67e3-6592-4bb1-bd5b-7a548f6b084f@intel.com>
Date: Wed, 27 May 2026 14:34:31 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 01/31] cxl/mbox: Flag support for Dynamic Capacity
 Devices (DCD)
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Ira Weiny <ira.weiny@intel.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <4700826deb086665c9e1c643156864eaecfe1fef.1779528761.git.anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <4700826deb086665c9e1c643156864eaecfe1fef.1779528761.git.anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/23/26 2:42 AM, Anisa Su wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> Per the CXL 3.1 specification software must check the Command Effects

May as well update to CXL r4.0

> Log (CEL) for dynamic capacity command support.
> 
> Detect support for the DCD commands while reading the CEL, including:
> 
> 	Get DC Config
> 	Get DC Extent List
> 	Add DC Response
> 	Release DC
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

missing Anisa sign off

> 
> ---
> Changes:
> [anisa: rebase]
> ---
>  drivers/cxl/core/mbox.c | 43 +++++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxlmem.h    | 15 ++++++++++++++
>  2 files changed, 58 insertions(+)
> 
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index aaa5c6277ebf..7ef5708bf210 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -165,6 +165,42 @@ static void cxl_set_security_cmd_enabled(struct cxl_security_state *security,
>  	}
>  }
>  
> +static bool cxl_is_dcd_command(u16 opcode)
> +{
> +#define CXL_MBOX_OP_DCD_CMDS 0x48
> +
> +	return (opcode >> 8) == CXL_MBOX_OP_DCD_CMDS;
> +}
> +
> +static void cxl_set_dcd_cmd_enabled(struct cxl_memdev_state *mds, u16 opcode,
> +				    unsigned long *cmd_mask)

mds not used, consider drop

> +{
> +	switch (opcode) {
> +	case CXL_MBOX_OP_GET_DC_CONFIG:
> +		set_bit(CXL_DCD_ENABLED_GET_CONFIG, cmd_mask);
> +		break;
> +	case CXL_MBOX_OP_GET_DC_EXTENT_LIST:
> +		set_bit(CXL_DCD_ENABLED_GET_EXTENT_LIST, cmd_mask);
> +		break;
> +	case CXL_MBOX_OP_ADD_DC_RESPONSE:
> +		set_bit(CXL_DCD_ENABLED_ADD_RESPONSE, cmd_mask);
> +		break;
> +	case CXL_MBOX_OP_RELEASE_DC:
> +		set_bit(CXL_DCD_ENABLED_RELEASE, cmd_mask);
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> +static bool cxl_verify_dcd_cmds(struct cxl_memdev_state *mds, unsigned long *cmds_seen)

mds not used. consider drop

> +{
> +	DECLARE_BITMAP(all_cmds, CXL_DCD_ENABLED_MAX);
> +
> +	bitmap_fill(all_cmds, CXL_DCD_ENABLED_MAX);
> +	return bitmap_equal(cmds_seen, all_cmds, CXL_DCD_ENABLED_MAX);

Above lines can be replaced with:
return bitmap_full(cmds_seen, CXL_DCD_ENABLED_MAX);

> +}
> +
>  static bool cxl_is_poison_command(u16 opcode)
>  {
>  #define CXL_MBOX_OP_POISON_CMDS 0x43
> @@ -757,6 +793,7 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
>  	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
>  	struct cxl_cel_entry *cel_entry;
>  	const int cel_entries = size / sizeof(*cel_entry);
> +	DECLARE_BITMAP(dcd_cmds, CXL_DCD_ENABLED_MAX);

Need to zero out the declared bitmap 'dcd_cmds' on stack before using.

	DECLARE_BITMAP(dcd_cmds, CXL_DCD_ENABLED_MAX) = {};

>  	struct device *dev = mds->cxlds.dev;
>  	int i, ro_cmds = 0, wr_cmds = 0;
>  
> @@ -785,11 +822,17 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
>  			enabled++;
>  		}
>  
> +		if (cxl_is_dcd_command(opcode)) {
> +			cxl_set_dcd_cmd_enabled(mds, opcode, dcd_cmds);
> +			enabled++;
> +		}
> +
>  		dev_dbg(dev, "Opcode 0x%04x %s\n", opcode,
>  			enabled ? "enabled" : "unsupported by driver");
>  	}
>  
>  	set_features_cap(cxl_mbox, ro_cmds, wr_cmds);
> +	mds->dcd_supported = cxl_verify_dcd_cmds(mds, dcd_cmds);
>  }
>  
>  static struct cxl_mbox_get_supported_logs *cxl_get_gsl(struct cxl_memdev_state *mds)
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 776c50d1db51..53444af448d7 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -230,6 +230,15 @@ struct cxl_event_state {
>  	struct mutex log_lock;
>  };
>  
> +/* Device enabled DCD commands */
> +enum dcd_cmd_enabled_bits {
> +	CXL_DCD_ENABLED_GET_CONFIG,
> +	CXL_DCD_ENABLED_GET_EXTENT_LIST,
> +	CXL_DCD_ENABLED_ADD_RESPONSE,
> +	CXL_DCD_ENABLED_RELEASE,
> +	CXL_DCD_ENABLED_MAX
> +};
> +

would be nice to have comment point to where in the spec this is

DJ

>  /* Device enabled poison commands */
>  enum poison_cmd_enabled_bits {
>  	CXL_POISON_ENABLED_LIST,
> @@ -405,6 +414,7 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
>   * @partition_align_bytes: alignment size for partition-able capacity
>   * @active_volatile_bytes: sum of hard + soft volatile
>   * @active_persistent_bytes: sum of hard + soft persistent
> + * @dcd_supported: all DCD commands are supported
>   * @event: event log driver state
>   * @poison: poison driver state info
>   * @security: security driver state info
> @@ -424,6 +434,7 @@ struct cxl_memdev_state {
>  	u64 partition_align_bytes;
>  	u64 active_volatile_bytes;
>  	u64 active_persistent_bytes;
> +	bool dcd_supported;
>  
>  	struct cxl_event_state event;
>  	struct cxl_poison_state poison;
> @@ -485,6 +496,10 @@ enum cxl_opcode {
>  	CXL_MBOX_OP_UNLOCK		= 0x4503,
>  	CXL_MBOX_OP_FREEZE_SECURITY	= 0x4504,
>  	CXL_MBOX_OP_PASSPHRASE_SECURE_ERASE	= 0x4505,
> +	CXL_MBOX_OP_GET_DC_CONFIG	= 0x4800,
> +	CXL_MBOX_OP_GET_DC_EXTENT_LIST	= 0x4801,
> +	CXL_MBOX_OP_ADD_DC_RESPONSE	= 0x4802,
> +	CXL_MBOX_OP_RELEASE_DC		= 0x4803,
>  	CXL_MBOX_OP_MAX			= 0x10000
>  };
>  

