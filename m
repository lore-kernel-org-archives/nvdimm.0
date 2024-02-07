Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E347885953
	for <nvdimm@lists.linux.dev>; Wed,  7 Feb 2024 20:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707337004; cv=none; b=cXY9SpF33ewwZY/pNo4VefNn5D8GCNola5SGE/vGOEaJPmYAFDi5eIip4sdKoeD9D5U2KkZUD7K7v1faBvu8743psW9cRZOW7BfB3DC+bmk30NidcFOc8rDwqjNRHP3tEGpKpZ6uh2IXGueOHC/lXgJBZ78wH3Kbuhc8YV7MDZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707337004; c=relaxed/simple;
	bh=4VVNg7/LB9kXbnJYFvnvtGDF4R7WlJ4TQPpUbtdlnso=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y1JA1nSi4MI0EWW3lfugO/Mi+QmQZt+B8PeJjdNZ+RTOSBZSMoXzSMLrhhgoU8FIlAi69xFXPUBnoUI5n8k6n5w+0IwVBd7908yiZ+7Ji6vMNrn54Hhyl/a90dLXb5wfO2APvPtYzdTJcegHKDAnaGFRdmH9lsqNhxIO6ZUpvEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IvMJi640; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IvMJi640"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707337003; x=1738873003;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4VVNg7/LB9kXbnJYFvnvtGDF4R7WlJ4TQPpUbtdlnso=;
  b=IvMJi640sCdwEKNVuIgp7mNjm6OnNrsvfWbusaRRceeCiCjSd/zFoSgh
   aQngQc0zXMS76a0p/gWn7NrlCHxHd+m7H7v1mmIHT0pJ7PRC0VZ7OTw3J
   qPKfeYPsr9Es+Y6IXx1LSvXIKMir5uz2RK+/BQVum7hdW5j4EgV2E2T95
   b+prtJ3Thh9KScK+ak5gMiKoQjDQxA8ufXAewUIudgWL3SakLdoMOUSdm
   Ia+0LQbwcHwILhbqROzkjHo/Z8ClJ5GEIrhGS6F1oBK0aakES3QE72Ctg
   MXasD4HBCoooc9pMoha6ZjSU/jdbjBed194qPfYJFDpf2HCVET2zq+DtA
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10977"; a="12431554"
X-IronPort-AV: E=Sophos;i="6.05,251,1701158400"; 
   d="scan'208";a="12431554"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 12:16:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,251,1701158400"; 
   d="scan'208";a="32238522"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.246.112.163]) ([10.246.112.163])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 12:16:41 -0800
Message-ID: <c24b91df-f94b-4455-9086-2cad26fc3400@intel.com>
Date: Wed, 7 Feb 2024 13:16:39 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [NDCTL PATCH v6 1/4] ndctl: cxl: Add QoS class retrieval for the
 root decoder
Content-Language: en-US
To: Alison Schofield <alison.schofield@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 vishal.l.verma@intel.com
References: <20240207172055.1882900-1-dave.jiang@intel.com>
 <20240207172055.1882900-2-dave.jiang@intel.com>
 <ZcPiffSmUyGWC6kB@aschofie-mobl2> <ZcPkVQjK2tXbrvYt@aschofie-mobl2>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <ZcPkVQjK2tXbrvYt@aschofie-mobl2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/7/24 1:13 PM, Alison Schofield wrote:
> On Wed, Feb 07, 2024 at 12:05:17PM -0800, Alison Schofield wrote:
>> On Wed, Feb 07, 2024 at 10:19:36AM -0700, Dave Jiang wrote:
>>> Add libcxl API to retrieve the QoS class for the root decoder. Also add
>>> support to display the QoS class for the root decoder through the 'cxl
>>> list' command. The qos_class is the QTG ID of the CFMWS window that
>>> represents the root decoder.
>>>
>>> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>>> ---
>>
>> -snip-
>>
>>> @@ -136,6 +136,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
>>>  		param.regions = true;
>>>  		/*fallthrough*/
>>>  	case 0:
>>> +		param.qos = true;
>>>  		break;
>>>  	}
>>
>> Add qos to the -vvv explainer in Documentation/cxl/cxl-list.txt 
> 
> My comment is wrong, since it is now an 'always displayed', not a -vvv.
> Why put it here at all then? I'm confused!

Just remove param.qos entirely?
> 
> 
>>
>>
