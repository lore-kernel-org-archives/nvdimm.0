Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761F9189F43
	for <nvdimm@lists.linux.dev>; Thu, 22 May 2025 17:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747935473; cv=none; b=A4uSi1+P/vBdFGvRtZH2J6TBSfBgKrF+zzSe3gMr3zOSObXzbXck61rZ97WZFmcV+eNl9bZb4+EWwnCdpGIbXRCUSS+k31yImMkpF9YLlzfkIiOOFyjmaoEjUhBXgHOl+eBc5ik/hyLFoYopu0KidM8TbsmeNvqgVGpZSqfpmug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747935473; c=relaxed/simple;
	bh=u57JL2Ec/Y8ixEHkZcmPBg0sLSxbBXhq4Y7tgAs8nKM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IeyPd8XBUBgy6ITIIUclXB/yFDCCjGcIYyV8CsRmrkDFASd0qxtxeexH+1rVm34Ew5rL2hhxNqSJQHto9ke9VCuFdFOfknnPBbPVOvqJWPAKOt30pvta3sZAiW5FpI7RQ9+e9UCx9FE61kBrXnEnOjgU93tqmQDgdUY2QTlA68s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DOS6CHCZ; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DOS6CHCZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747935471; x=1779471471;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=u57JL2Ec/Y8ixEHkZcmPBg0sLSxbBXhq4Y7tgAs8nKM=;
  b=DOS6CHCZcWIDy7G0lXx6D+kvIZAeyPWjrSbL2CkPTQw8abs+YKYX0CDX
   5g0IeGx1fGQ+PoExanqj7ZDVeG1Nf3yMibnzPguHd641r4RVHtfR0IAhf
   A4rzgk/2aT6VNhiJNqzNdXXxfAxYCWKYRbUc002HPnUlBa33VbK9l0wYN
   iMyk2d2/JbPaAn2xmwBnfwFmN7UFjc3UudaS3m947V/ghKRRdGKRmg5BL
   lH48eie3eh2E/jM28F0hpwzCALsfHvVM5oeZJ0o9q93cUgdlGN1HA9u8u
   Gfs0Sf38kdxMtbaiVwmlY83ThI77mA12pgHiX4i+oJ2MZXR1F/x3/sQLm
   Q==;
X-CSE-ConnectionGUID: Gcmew/L6SwW1ymRoHvkFow==
X-CSE-MsgGUID: tx61fnveQnKf4jDNIL1keg==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="60630893"
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="60630893"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 10:37:51 -0700
X-CSE-ConnectionGUID: rBVwNvulT4eDT+PEGS+V/g==
X-CSE-MsgGUID: F6SBB+PjTMqyz/wnLs3dtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="145943459"
Received: from adavare-mobl.amr.corp.intel.com (HELO [10.125.186.118]) ([10.125.186.118])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 10:37:50 -0700
Message-ID: <ee7865a2-d57a-4b94-820f-7a3be90377b9@linux.intel.com>
Date: Thu, 22 May 2025 10:37:47 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [NDCTL PATCH v6 4/4] cxl/test: Add test for cxl features device
Content-Language: en-GB
To: Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 Dan Williams <dan.j.williams@intel.com>
References: <20250509164006.687873-1-dave.jiang@intel.com>
 <20250509164006.687873-5-dave.jiang@intel.com>
 <aCYxY8tmvJ14sWB-@aschofie-mobl2.lan>
 <1375994d-d3ba-479d-8910-8e564967bace@intel.com>
From: Marc Herbert <Marc.Herbert@linux.intel.com>
In-Reply-To: <1375994d-d3ba-479d-8910-8e564967bace@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-05-15 11:28, Dave Jiang wrote:

>>>  
>>> +uuid_dep = dependency('uuid', required: false)
>>> +if get_option('fwctl').enabled() and uuid_dep.found()
>>> +  fwctl = executable('fwctl', 'fwctl.c',
>>> +    dependencies : libcxl_deps,
>>> +    include_directories : root_inc,
>>> +  )
>>> +  cxl_features = find_program('cxl-features.sh')
>>> +  tests += [
>>> +    [ 'cxl-features.sh',        cxl_features,       'cxl'   ],
>>> +  ]
>>> +endif
>>
>> Is the fwctl feature enabled fuss still needed now that the UAPI headers
>> are vendored locally?  Seems the test will quickly SKIP if fwctl dev not
>> found. I kind of like the idea of seeing a 'SKIP' and knowing the test
>> didn't run than seeing nothing at all in the test output.
> 
> This gives the option to disable fwctl if needed. Also there is a libuuid dependency since we use uuid lib calls. 

Is it possible to go anywhere without uuid?

fedora$ sudo dnf remove libuuid-devel
        meson setup build

...
Run-time dependency libkmod found: YES 33
Run-time dependency libudev found: YES 256
Found CMake: /usr/bin/cmake (3.30.8)
Run-time dependency uuid found: NO (tried pkgconfig and cmake)

meson.build:144:0: ERROR: Dependency "uuid" not found, tried pkgconfig and cmake


meson setup --help | grep uuid  # empty
git grep get_option.*uuid       # empty
grep -C 5 uuid meson.build      # does not look optional

It looks like a hard requirement to me.

UUIDs are rarely ever "optional". It could be required only
by some optional tool but that does not seem to be the case here

Fun fact: it's not even possible to remove /usr/include/uuid/uuid.h
on Arch Linux, not without breaking the system.


