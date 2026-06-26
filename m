Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442373B8D41
	for <nvdimm@lists.linux.dev>; Fri, 26 Jun 2026 21:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782510191; cv=none; b=Zo4XzfGxFIl10YuEm031Ez39jcB6CKVxMB+7qfSiqIxv20ZXnYlNm8+S/MyfQkZY9/XGVJudlh9tZ7jmuS4EW86BrY4qUx2lDlyOxrgtlFTyyjADD5D9xRPeTnLEBJxvBNubnpeqhnjvtAJSHRuAwXf8tyyeMQ9SM5YZyoiDVNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782510191; c=relaxed/simple;
	bh=X3PeWzMgIpm9OjT1QHhICQ3FysVRzAcr3pEV6/pV4Mw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fGPbj1csffLH7gRU0lMeVFR4XMuZ6xcvi/uhmLgGpqhQ4Q/YFLSxdHnNpgQwJi0xh9aT5U8km12CYDr8SeqQOfuaT/kKMzHAOiryfVb2YNRTtn8iOJP1ASQyT95E+gIEipLis1hJ9nUvMqwPagtgA6uXx+qAiNRTtQIFipSM9fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BnjZOSRO; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BnjZOSRO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782510190; x=1814046190;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=X3PeWzMgIpm9OjT1QHhICQ3FysVRzAcr3pEV6/pV4Mw=;
  b=BnjZOSROchTZPlUYcF70MEmFLVQPXfyeIprq+O+guXJLOz9LY3z7mNEZ
   JBSZgEgNfVPdQSz87froQp29LtvvvYP+qe9cTx0YESc1W09AfYoAP8OdZ
   voeedDR24rIN7Xsh3ABXWsGKjpfLVT/Yr8SwCcuSwFdv4PK7G7QkWdPeq
   EqM5bew4r50UDDr40SIwDMbmvrPM0zhJIbeVp/kuPGEX5S93/p277ZMTb
   UshOWVmFVjeWV6a+Hk2V9DF88XBlqtp/MF26RLUu3kvsFiaXHdPo9j48c
   RiUzQJXlWiEbkH5yzTUdi1DL6yPmijdjDToh1iNlvNz08ty8/lkJKDPz2
   g==;
X-CSE-ConnectionGUID: PwdwPOgrTkiFvQq3/z1CqA==
X-CSE-MsgGUID: R+U/JdvsTk2Vrv4GhZSPfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11829"; a="93659169"
X-IronPort-AV: E=Sophos;i="6.24,227,1774335600"; 
   d="scan'208";a="93659169"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2026 14:43:10 -0700
X-CSE-ConnectionGUID: kgonjLh7QvSX3LLODIMn4A==
X-CSE-MsgGUID: bVaH5NIHSIWGgueD/JRHnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,227,1774335600"; 
   d="scan'208";a="253323785"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.109.96]) ([10.125.109.96])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2026 14:43:08 -0700
Message-ID: <12c4b5ce-b2b6-4ff8-8a2d-0411d7297fa3@intel.com>
Date: Fri, 26 Jun 2026 14:43:07 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 01/31] cxl/mbox: Flag support for Dynamic Capacity
 Devices (DCD)
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Anisa Su <anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-2-anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260625112638.550691-2-anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/25/26 4:04 AM, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> Per the CXL 4.0 specification software must check the Command Effects
> Log (CEL) for dynamic capacity command support.
> 
> Detect support for the DCD commands while reading the CEL, including:
> 
>         Get DC Config
>         Get DC Extent List
>         Add DC Response
>         Release DC
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

tiny nit below

> 
> ---
> 
> Changes:
> - remove unused param struct cxl_memdev_state *mds from
>   cxl_set_dcd_cmd_enabled()
> 
> - remove unused param struct cxl_memdev_state *mds from
>   cxl_verify_dcd_cmds()
> 
> - cxl_verify_dcd_cmds(): originally filled out local
>   bitmap with all DCD cmd bits and checking if cmds_seen
>   bitmap is equal to the local bitmap. Replace with
>   simple call to bitmap_full(cmd_seen)
> 
> - cxl_walk_cel(): zero out dcd_cmds bitmap before using
> 
> - cxlmem.h: Add comment to enum dcd_cmd_enabled_bits
>   pointing to where the command set is defined in the
>   4.0 spec
> 
> - original commit message referred to CXL r3.1. Bump to r4.0
> ---
>  drivers/cxl/core/mbox.c | 39 +++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxlmem.h    | 20 ++++++++++++++++++++
>  2 files changed, 59 insertions(+)
> 
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 7c6c5b7450a5..07aba6f0b719 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -165,6 +165,38 @@ static void cxl_set_security_cmd_enabled(struct cxl_security_state *security,
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
> +static void cxl_set_dcd_cmd_enabled(u16 opcode, unsigned long *cmd_mask)
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
> +static bool cxl_verify_dcd_cmds(unsigned long *cmds_seen)
> +{
> +	return bitmap_full(cmds_seen, CXL_DCD_ENABLED_MAX);
> +}
> +
>  static bool cxl_is_poison_command(u16 opcode)
>  {
>  #define CXL_MBOX_OP_POISON_CMDS 0x43
> @@ -757,6 +789,7 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
>  	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
>  	struct cxl_cel_entry *cel_entry;
>  	const int cel_entries = size / sizeof(*cel_entry);
> +	DECLARE_BITMAP(dcd_cmds, CXL_DCD_ENABLED_MAX) = {};
>  	struct device *dev = mds->cxlds.dev;
>  	int i, ro_cmds = 0, wr_cmds = 0;
>  
> @@ -785,11 +818,17 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
>  			enabled++;
>  		}
>  
> +		if (cxl_is_dcd_command(opcode)) {
> +			cxl_set_dcd_cmd_enabled(opcode, dcd_cmds);
> +			enabled++;
> +		}
> +
>  		dev_dbg(dev, "Opcode 0x%04x %s\n", opcode,
>  			enabled ? "enabled" : "unsupported by driver");
>  	}
>  
>  	set_features_cap(cxl_mbox, ro_cmds, wr_cmds);
> +	mds->dcd_supported = cxl_verify_dcd_cmds(dcd_cmds);
>  }
>  
>  static struct cxl_mbox_get_supported_logs *cxl_get_gsl(struct cxl_memdev_state *mds)
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 776c50d1db51..60dc3f0006a7 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -230,6 +230,20 @@ struct cxl_event_state {
>  	struct mutex log_lock;
>  };
>  
> +/**
> + * CXL r4.0 Section 8.2.10.9 - Memory Device Command Sets. See Table 8-308.
> + *
> + * The 48h Command Set (Opcodes 4800h - 4803h) defines the device-enabled DCD
> + * commands.
> + * */

*/

checkpatch flags this

DJ

> +enum dcd_cmd_enabled_bits {
> +	CXL_DCD_ENABLED_GET_CONFIG,
> +	CXL_DCD_ENABLED_GET_EXTENT_LIST,
> +	CXL_DCD_ENABLED_ADD_RESPONSE,
> +	CXL_DCD_ENABLED_RELEASE,
> +	CXL_DCD_ENABLED_MAX
> +};
> +
>  /* Device enabled poison commands */
>  enum poison_cmd_enabled_bits {
>  	CXL_POISON_ENABLED_LIST,
> @@ -405,6 +419,7 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
>   * @partition_align_bytes: alignment size for partition-able capacity
>   * @active_volatile_bytes: sum of hard + soft volatile
>   * @active_persistent_bytes: sum of hard + soft persistent
> + * @dcd_supported: all DCD commands are supported
>   * @event: event log driver state
>   * @poison: poison driver state info
>   * @security: security driver state info
> @@ -424,6 +439,7 @@ struct cxl_memdev_state {
>  	u64 partition_align_bytes;
>  	u64 active_volatile_bytes;
>  	u64 active_persistent_bytes;
> +	bool dcd_supported;
>  
>  	struct cxl_event_state event;
>  	struct cxl_poison_state poison;
> @@ -485,6 +501,10 @@ enum cxl_opcode {
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

