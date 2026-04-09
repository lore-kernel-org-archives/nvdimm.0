Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38F7331209
	for <nvdimm@lists.linux.dev>; Thu,  9 Apr 2026 17:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775754336; cv=none; b=JWzVrZQGnuUtjEUPOSBwZuX7x57fCp+XkyoVBxLTP3Cs3zwbpcneBri28UXctIakb8O1yDBFXntfVh+DzKMZfAEkHK/hZ3VbC7gwpVl24OH0WQU89teCu9AumR7z5PsQMTH/rs4J8SdTrn4l/w1psSpR+BUDXKJaoJxGOPExRZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775754336; c=relaxed/simple;
	bh=mau0TKyITRZdF345Q9QbhDwY67ADiwz1APoYF6lm6Tc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pSi2d/QBohwj/CKdntyov4L9sJfSHy7obaJf9Q6nSsq9ppR0z3fZGfT/p9VnRERBmSpEQgiPy08SKxyEwZ5LQTlPckuVa2oXfoe59tjdm+7JOCPRaDswDtOcn+abgwbohV1L11Sdx5YADe/QN8EHGnyqRpG86vCd7WspLrbN3XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JyKnlA+e; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JyKnlA+e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775754334; x=1807290334;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mau0TKyITRZdF345Q9QbhDwY67ADiwz1APoYF6lm6Tc=;
  b=JyKnlA+ew0YYilKVmflHlO/5UzDCrRllkQeYrsh10yL9U8p0Rr5FIWgu
   1sm3TSip9Nh9gBP4JDkfNrmyzzOXBJlRdu3cOKgWuTciTYTtHX7D2+1Nh
   u4Mg8DKjgwaV+sEhdyMW6TBpQbn/bvnCXYAYU2JHNsHLWvdO11KF6aIgW
   hSj5UGNr20AL4n39si3K77K/q02wMOm38Q6Uyr+3uHkZ/jdro9MoohKzF
   l0HLrTrtPFFveXUUqFlVAtMV0aQWgOCbNyG3V5niZFbEIb/sGLFp5Z9Be
   oEVo/8urZOiwb5626veX4RTawW+kquH+HJgx3PiATLTK2hPK+tkjymxN2
   A==;
X-CSE-ConnectionGUID: eeAgrJd4RwujEc2Hq5FdOA==
X-CSE-MsgGUID: sgPsTHlYRYiQPfy4dHwVtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11754"; a="64307464"
X-IronPort-AV: E=Sophos;i="6.23,170,1770624000"; 
   d="scan'208";a="64307464"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2026 10:05:34 -0700
X-CSE-ConnectionGUID: FBVFpVpXT+O7JytkRMuiEg==
X-CSE-MsgGUID: nAzY+lCJSE+4YKPAP7bxLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,170,1770624000"; 
   d="scan'208";a="252150296"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.108.241]) ([10.125.108.241])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2026 10:05:32 -0700
Message-ID: <829a8dc2-3076-43fb-96da-70c7bd6b3aa3@intel.com>
Date: Thu, 9 Apr 2026 10:05:31 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 0/3] Enable CXL protocol testing
To: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>,
 Terry Bowman <terry.bowman@amd.com>, dave@stgolabs.net,
 jonathan.cameron@huawei.com, alison.schofield@intel.com,
 dan.j.williams@intel.com, shiju.jose@huawei.com, ming.li@zohomail.com,
 Smita.KoralahalliChannabasappa@amd.com, rrichter@amd.com,
 dan.carpenter@linaro.org, PradeepVineshReddy.Kodamati@amd.com,
 lukas@wunner.de, sathyanarayanan.kuppuswamy@linux.intel.com,
 nvdimm@lists.linux.dev, alucerop@amd.com, ira.weiny@intel.com
Cc: linux-cxl@vger.kernel.org
References: <20260408203231.962206-1-terry.bowman@amd.com>
 <7fe63454-9df7-47c9-ae7f-4db1fd1a3576@amd.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <7fe63454-9df7-47c9-ae7f-4db1fd1a3576@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/8/26 2:39 PM, Cheatham, Benjamin wrote:
> On 4/8/2026 3:32 PM, Terry Bowman wrote:
>> Current CXL error injection (EINJ) only supports Root Port protocol error
>> injection but a method to test all CXL devices is needed. This series
>> outlines methods to update both the kernel and the 'aer-inject' tool-without
>> relying on EINJ-to enable CXL RAS protocol error handling across all CXL
>> devices.
>>
> 
> This functionality should probably be added to the inject-protocol-error subcommand
> instead of spread out across the directory as a bunch of scripts + patches. The command
> is only set up for protocol error injection, but I don't think it would be *too* hard
> to extend.
> 
> I think the first thing you have to do is expand the accepted device types to include ports and
> memdevs instead of just dports. That should be simple enough, there are already helpers to find
> both based on sbdf, name, etc. Then, you'd need to change the interface used to inject the error
> based on device type (is it a root port? then use EINJ, otherwise use aer-inject). All that's
> left at that point is to actually call the aer-inject command with the correct options (and
> update the documentation/help messages).
> 
> I would be happy to help with any of the above if you agree with the direction, just let me
> know!

Thanks for the Review Ben! Initially Dan and I asked Terry to just provide his test scripts in the CXL CLI test/contrib directory as a place holder until we can figure out how to integrate it. But if you have better ideas of how to improve the usability, help is much appreciated!


> 
> Thanks,
> Ben

