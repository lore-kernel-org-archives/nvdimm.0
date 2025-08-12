Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8093D20B218
	for <nvdimm@lists.linux.dev>; Tue, 12 Aug 2025 21:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755035199; cv=none; b=hw5sibcHleHnVl5dMAuPcp8I3KHqBECSRFo4mgVMfkQ5bG+E+Y0nyE5vz9VJRgNQpqUl4CwOHMPeCP1HJRHvdJbKXiRcCP6FhodIGgIJ6irfVS/aF1MoUXgthAVM6b3OB0m02ffEvG9t8I6OkVdV+BvVagXIudUrfr7psIwt2PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755035199; c=relaxed/simple;
	bh=Xf1H+ySZWWLVeLIhuFpndzvCpwSw16J2X0fr7aWCB9Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b47SWECXaofir6XjJDWGxGcUFsgkStK5YA4526n51Kbx4AnKFBUfP3B51H96Fe+LwvONAmlsE86cruX/aPTDJHynQewkfWx3yhK38pUUy36HETmb2rmqbynTYymK54ZslqaPbow0FoF8c/5gPZIfBGTxW6Afd8UaAfUg4TciGM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HcLTrA74; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HcLTrA74"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755035197; x=1786571197;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Xf1H+ySZWWLVeLIhuFpndzvCpwSw16J2X0fr7aWCB9Q=;
  b=HcLTrA74rh9cS+ydDr+3R0a2pJ2HWidsNMFMadkiWs9oAMFuGFig70hL
   5JDr3bWF23sRKrIGwF6x+1lOYtgkOMttSiUlRr/sdj3Mvgr+qocN3KYKS
   oa4wIbigFShz+rvGrmksuMpbOu5D6RpXHrc8IuNC2YnjQIfv03kcMRxSj
   at6Y3CY3bIVefxgrsWdxnCTT/yTu+2BhptWsgDVf6UqZXwJPIgWg5VjVz
   fK+7TPHxLVsHrduwjvpxi5IFZT4jxNfgOKw7ZYis8Uxbgq6s1RovzWnLg
   P9j3irM7ikSN8RLsbXDXNGYfxoF9OldMh/etMb9N5RnbWp1jQmifk8ZfE
   A==;
X-CSE-ConnectionGUID: OsmWMCqhQTiun2goNrrUgg==
X-CSE-MsgGUID: AIa0IgITSWytWvOgsPed0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="57384628"
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="57384628"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 14:46:37 -0700
X-CSE-ConnectionGUID: gK8oe98TSN6hKy7LLMf8gw==
X-CSE-MsgGUID: G+wHHAdcSj2OiMRU++Awog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="166573218"
Received: from anmitta2-mobl3.gar.corp.intel.com (HELO [10.247.119.148]) ([10.247.119.148])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 14:46:29 -0700
Message-ID: <f2120762-bbc6-47b0-9cb6-fa45bd9cd460@intel.com>
Date: Tue, 12 Aug 2025 14:46:24 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 00/20] Add CXL LSA 2.1 format support in nvdimm and cxl
 pmem
To: Neeraj Kumar <s.neeraj@samsung.com>,
 Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso
 <dave@stgolabs.net>, Jonathan Cameron <jonathan.cameron@huawei.com>,
 Ira Weiny <ira.weiny@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
 cpgs@samsung.com
References: <CGME20250730121221epcas5p3ffb9e643af6b8ae07cfccf0bdee90e37@epcas5p3.samsung.com>
 <20250730121209.303202-1-s.neeraj@samsung.com>
 <1983025922.01754829002385.JavaMail.epsvc@epcpadp1new>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <1983025922.01754829002385.JavaMail.epsvc@epcpadp1new>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/7/25 2:02 AM, Neeraj Kumar wrote:
> On 30/07/25 05:41PM, Neeraj Kumar wrote:
>> Introduction:
>> =============
>> CXL Persistent Memory (Pmem) devices region, namespace and content must be
>> persistent across system reboot. In order to achieve this persistency, it
>> uses Label Storage Area (LSA) to store respective metadata. During system
>> reboot, stored metadata in LSA is used to bring back the region, namespace
>> and content of CXL device in its previous state.
>> CXL specification provides Get_LSA (4102h) and Set_LSA (4103h) mailbox
>> commands to access the LSA area. nvdimm driver is using same commands to
>> get/set LSA data.
>>
> 
> Hi Jonathan, Dave and Ira
> 
> I have addressed the review comments of V1 patch-set and sent out this
> V2 Patch-set.
> 0-Day Kernel Test bot has reported couple of minor issues which I will
> address in next series.
> 
> Can you please have a look at this V2 series and let me know your
> feedback.

Hi Neeraj,
It's on my review queue. Will try to get to it soon.

Also, it seems that lore is still not happy your mailer. 
https://lore.kernel.org/linux-cxl/1983025922.01754829002385.JavaMail.epsvc@epcpadp1new/T/#t

See all the [not found] threading. Just FYI.

DJ


> 
> 
> Regards,
> Neeraj
> 

