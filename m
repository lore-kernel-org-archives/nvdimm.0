Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7389C4F8B1
	for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 20:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709065741; cv=none; b=m0FZA1T+E2b5OsPZipMd3YisMO/yzhCeNTChCibhsqjeEQZXp2FUaQMgwss8SxnXUIKp9tTOHAJWPKh11lddtFYQzsCR/vcU+OIluHmzRZI0c0v7DkndY+21rn9Y/ymAhRt5iIXNlqetrFlY8sBwOWThtRYFEcB0iGUCzt80qE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709065741; c=relaxed/simple;
	bh=nAUGOYHwbgc37EK4Po1Uxn5ZeOZ74M8gDruDHnMJzMo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JS4umVCUnSAAZwfOROdn8EYJ8wSCU/r7ZxxuYgLFcqsDCJqb/wJJJE1/PD7bJ7IccA12KsZl21iSngeVfgDuMt/ZmQ2OH9nOez628BcklZP4blPuGdiKrRUGr2Fi142hrHMxgvCqPSh3+q8nxNxen9Mr/ChvYtXYvb39HZnVTSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HKT0yWsV; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HKT0yWsV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709065739; x=1740601739;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nAUGOYHwbgc37EK4Po1Uxn5ZeOZ74M8gDruDHnMJzMo=;
  b=HKT0yWsVQEUE3StLDOCoF+NkW8Rq6gnbvF/RGwpRgKiD89e7FfFRF45w
   tIHeeG0MP6F+YfG03c9aC3V4/QZu6r2NLauMby/EF0jzkkqb33x9tX+1a
   s2jQ5ZmSbUaDW+T5I6ZIiuKfeCbSW7oY2403mLx85SsgH3noAWhcrqSAs
   GTAhwlRB4VtmdL/NjVBmIDhXmx9EFKftrKwARFNEIduQRHQa4nl6MPiN7
   JrL5OqmVQyywb0+5W7i0dlPLmhVra3fn3oU8Qv4kWHmb9IaF8sAfI6zr6
   u7qiZ4iuZtjq823B1IZydDAo8fYvNAvdLpAzMs2N0UnhW03SxQaRxzAD5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="25900692"
X-IronPort-AV: E=Sophos;i="6.06,188,1705392000"; 
   d="scan'208";a="25900692"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 12:28:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,188,1705392000"; 
   d="scan'208";a="11835463"
Received: from pbackus-mobl1.amr.corp.intel.com (HELO [10.246.114.227]) ([10.246.114.227])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 12:28:58 -0800
Message-ID: <86f8f0a0-3619-4905-a6e8-9fd871ec0a39@intel.com>
Date: Tue, 27 Feb 2024 13:28:56 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Question about forcing 'disable-memdev'
Content-Language: en-US
To: Jane Chu <jane.chu@oracle.com>, =?UTF-8?B?Q2FvLCBRdWFucXVhbi/mm7kg5YWo?=
 =?UTF-8?B?5YWo?= <caoqq@fujitsu.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
References: <3788c116-50aa-ae97-adca-af6559f5c59a@fujitsu.com>
 <dd61a8f2-ef80-46cc-8033-b3a4b987b3f4@intel.com>
 <ebe3f86f-d3f9-414d-9749-7d41ac7d3404@oracle.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <ebe3f86f-d3f9-414d-9749-7d41ac7d3404@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2/27/24 1:24 PM, Jane Chu wrote:
> On 2/27/2024 8:40 AM, Dave Jiang wrote:
> 
>>
>> On 2/26/24 10:32 PM, Cao, Quanquan/曹 全全 wrote:
>>> Hi, Dave
>>>
>>> On the basis of this patch, I conducted some tests and encountered unexpected errors. I would like to inquire whether the design here is reasonable? Below are the steps of my testing:
>>>
>>> Link: https://lore.kernel.org/linux-cxl/170138109724.2882696.123294980050048623.stgit@djiang5-mobl3/
>>>
>>>
>>> Problem description: after creating a region, directly forcing 'disable-memdev' and then consuming memory leads to a kernel panic.
>> If you are forcing memory disable when the memory cannot be offlined, then this behavior is expected. You are ripping the memory away from underneath kernel mm. The reason the check was added is to prevent the users from doing exactly that.
> 
> Since user is doing the illegal thing, shouldn't that lead to SIGBUS or SIGKILL ?

The behavior is unpredictable once the CXL memory is ripped away. If the memory only backed user memory then you may see SIGBUS. But if the memory backed kernel data then kernel OOPs is not out of question. 

> 
> thanks,
> 
> -jane
> 
>>
>>>
>>> Test environment:
>>> KERNEL    6.8.0-rc1
>>> QEMU    8.2.0-rc4
>>>
>>> Test steps：
>>>        step1: set memory auto_online to movable zones.
>>>             echo online_movable > /sys/devices/system/memory/auto_online_blocks
>>>        step2: create region
>>>             cxl create-region -t ram -d decoder0.0 -m mem0
>>>        step3: disable memdev
>>>             cxl disable-memdev mem0 -f
>>>        step4: consum CXL memory
>>>             ./consumemem   <------kernel panic
>>>
>>> numactl node status:
>>>        step1: numactl -H
>>>
>>>      available: 2 nodes (0-1)
>>>      node 0 cpus: 0 1
>>>      node 0 size: 968 MB
>>>      node 0 free: 664 MB
>>>      node 1 cpus: 2 3
>>>      node 1 size: 683 MB
>>>      node 1 free: 333 MB
>>>      node distances:
>>>      node   0   1
>>>        0:  10  20
>>>
>>>      step2: numactl -H
>>>
>>>      available: 3 nodes (0-2)
>>>      node 0 cpus: 0 1
>>>      node 0 size: 968 MB
>>>      node 0 free: 677 MB
>>>      node 1 cpus: 2 3
>>>      node 1 size: 683 MB
>>>      node 1 free: 333 MB
>>>      node 2 cpus:
>>>      node 2 size: 256 MB
>>>      node 2 free: 256 MB
>>>      node distances:
>>>      node   0   1   2
>>>        0:  10  20  20
>>>        1:  20  10  20
>>>        2:  20  20  10
>>>
>>>      step3: numactl -H
>>>
>>>      available: 3 nodes (0-2)
>>>      node 0 cpus: 0 1
>>>      node 0 size: 968 MB
>>>      node 0 free: 686 MB
>>>      node 1 cpus: 2 3
>>>      node 1 size: 683 MB
>>>      node 1 free: 336 MB
>>>      node 2 cpus:
>>>      node 2 size: 256 MB
>>>      node 2 free: 256 MB
>>>      node distances:
>>>      node   0   1   2
>>>        0:  10  20  20
>>>        1:  20  10  20
>>>        2:  20  20  10
