Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF394308F25
	for <nvdimm@lists.linux.dev>; Fri, 15 Aug 2025 18:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755281177; cv=none; b=JVkJ3fTsPsQR6pgIfY3+MjDv9LX043ZwCnLdCMkvKf+Up+W3xc6m88zoCp6+LPzUTvTPwk0AoFVS3xV2pAWtszo4lNo9M3eDwW7Fu8kaquzwslzy7nLofM0+98oTs0auztOdruFcSN/TKKxmntwo2CWCcJmFk60k4w4kap59dD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755281177; c=relaxed/simple;
	bh=SJDcsSJXahvK6w3PVLzUoWHXDtQZ5aGGi+KFg2tF+4s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VOhJUBblV/N+IeoA6TTW9Hpn4x10SF2CX2FsldBTUQQKzPobcCaKu8MZXAlRBv4kLE8vMCK9+DlQio8NkkaBbWO8UryZDrdqK9fOeUSExHlG2pBoyqZVWCuybYvhxQPJ6U5dBKBT9I4NHIyY5ajSU0YNiX2BI3BAMSHdt2dLyVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MqI4eLjT; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MqI4eLjT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755281176; x=1786817176;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SJDcsSJXahvK6w3PVLzUoWHXDtQZ5aGGi+KFg2tF+4s=;
  b=MqI4eLjTnsA/z9PALk2BhWPYqsDomep9zlXByBtH5QB5763ea+XNeNNG
   tfeJp+lC7dCHQl/JtQSL/vHURiRojcqkgrDwh/CcrQOFWpgvS/ssZzTIi
   4Y2XLx/cF4RW35c1PnnvysXGCoHiM60xFrMyqDfKueII40Iqgi74mzhyc
   TlHVcM9bG34btPi1qIlWIeNdmWqCg2JQ8kOINPZ3TL6FNqBNNch6O8SPl
   B7wyI45d58PcfHXB1wpID4Ha3tYLT7OfJXqcCXGQ3rWt3dDxU+Ru5MBAE
   kvyVmPSabxNuFqMvLXpQGCmsSVOOWvliVBWnRRxHUVd2k69/jbjKaPoRk
   Q==;
X-CSE-ConnectionGUID: WHxqTmaZTzCCgViRvD8i5w==
X-CSE-MsgGUID: Kna35Nk7R2CqkJWyMXnNFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11523"; a="61417155"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="61417155"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 11:06:15 -0700
X-CSE-ConnectionGUID: 9vGjZEVGRQaT9wmWLRC5eA==
X-CSE-MsgGUID: McxF2AsDSm+AEHvcC7cKrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="171318698"
Received: from anmitta2-mobl4.gar.corp.intel.com (HELO [10.247.119.183]) ([10.247.119.183])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 11:06:09 -0700
Message-ID: <7ff8b51b-7263-4d9c-99f8-1b507cf46262@intel.com>
Date: Fri, 15 Aug 2025 11:06:04 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 01/20] nvdimm/label: Introduce NDD_CXL_LABEL flag to
 set cxl label format
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Neeraj Kumar <s.neeraj@samsung.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, gost.dev@samsung.com,
 a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
References: <20250730121209.303202-1-s.neeraj@samsung.com>
 <CGME20250730121223epcas5p1386bdf99a0af820dd4411fbdbd413cd5@epcas5p1.samsung.com>
 <20250730121209.303202-2-s.neeraj@samsung.com>
 <20250813141218.0000091f@huawei.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250813141218.0000091f@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/13/25 6:12 AM, Jonathan Cameron wrote:
> On Wed, 30 Jul 2025 17:41:50 +0530
> Neeraj Kumar <s.neeraj@samsung.com> wrote:
> 
>> Prior to LSA 2.1 version, LSA contain only namespace labels. LSA 2.1
>> introduced in CXL 2.0 Spec, which contain region label along with
>> namespace label.
>>
>> NDD_LABELING flag is used for namespace. Introduced NDD_CXL_LABEL
>> flag for region label. Based on these flags nvdimm driver performs
>> operation on namespace label or region label.
>>
>> NDD_CXL_LABEL will be utilized by cxl driver to enable LSA2.1 region
>> label support
>>
>> Accordingly updated label index version
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> Hi Neeraj,
> 
> A few comments inline.
> 
>> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
>> index 04f4a049599a..7a011ee02d79 100644
>> --- a/drivers/nvdimm/label.c
>> +++ b/drivers/nvdimm/label.c
>> @@ -688,11 +688,25 @@ static int nd_label_write_index(struct nvdimm_drvdata *ndd, int index, u32 seq,
>>  		- (unsigned long) to_namespace_index(ndd, 0);
>>  	nsindex->labeloff = __cpu_to_le64(offset);
>>  	nsindex->nslot = __cpu_to_le32(nslot);
>> -	nsindex->major = __cpu_to_le16(1);
>> -	if (sizeof_namespace_label(ndd) < 256)
>> +
>> +	/* Set LSA Label Index Version */
>> +	if (ndd->cxl) {
>> +		/* CXL r3.2 Spec: Table 9-9 Label Index Block Layout */
>> +		nsindex->major = __cpu_to_le16(2);
>>  		nsindex->minor = __cpu_to_le16(1);
>> -	else
>> -		nsindex->minor = __cpu_to_le16(2);
>> +	} else {
>> +		nsindex->major = __cpu_to_le16(1);
>> +		/*
>> +		 * NVDIMM Namespace Specification
>> +		 * Table 2: Namespace Label Index Block Fields
>> +		 */
>> +		if (sizeof_namespace_label(ndd) < 256)
>> +			nsindex->minor = __cpu_to_le16(1);
>> +		else
>> +		 /* UEFI Specification 2.7: Label Index Block Definitions */
> 
> Odd comment alignment. Either put it on the else so
> 		else /* UEFI 2.7: Label Index Block Defintions */
> 
> or indent it an extra tab
> 
> 		else
> 			/* UEFI 2.7: Label Index Block Definitions */
> 			
>> +			nsindex->minor = __cpu_to_le16(2);
>> +	}
>> +
>>  	nsindex->checksum = __cpu_to_le64(0);
>>  	if (flags & ND_NSINDEX_INIT) {
>>  		unsigned long *free = (unsigned long *) nsindex->free;
> 
>> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
>> index e772aae71843..0a55900842c8 100644
>> --- a/include/linux/libnvdimm.h
>> +++ b/include/linux/libnvdimm.h
>> @@ -44,6 +44,9 @@ enum {
>>  	/* dimm provider wants synchronous registration by __nvdimm_create() */
>>  	NDD_REGISTER_SYNC = 8,
>>  
>> +	/* dimm supports region labels (LSA Format 2.1) */
>> +	NDD_CXL_LABEL = 9,
> 
> This enum is 'curious'.  It combined flags from a bunch of different
> flags fields and some stuff that are nothing to do with flags.
> 
> Anyhow, putting that aside I'd either rename it to something like
> NDD_REGION_LABELING (similar to NDD_LABELING that is there for namespace labels
> or just have it a meaning it is LSA Format 2.1 and drop the fact htat
> also means region labels are supported.

I agree. I had a conversation with Dan about it where I mentioned calling it CXL to describe LSA 2.1 just doesn't seem quite right. He also offered up something like NDD_REGION_LABELING instead of NDD_CXL_LABEL. So +1 to this comment.

DJ 

> 
> Combination of a comment that talks about one thing and a definition name
> that doesn't associate with it seems confusing to me.
> 
> Jonathan
> 
> 
>> +
>>  	/* need to set a limit somewhere, but yes, this is likely overkill */
>>  	ND_IOCTL_MAX_BUFLEN = SZ_4M,
>>  	ND_CMD_MAX_ELEM = 5,
> 
> 

