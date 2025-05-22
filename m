Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495D71EA84
	for <nvdimm@lists.linux.dev>; Thu, 22 May 2025 17:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747936038; cv=none; b=WgqsA2Zob1pdx8MYru+EAhDuzILddcXiQRboraK48Kq8ZLa6U2v2Fc/DxSjKtLeJG/syczOgNVvw8ZTpJbMEmjxBlbZyyKBcwqRILpm4e6e246cjzEpa4Zx50Dcxdt45LW8Whf/dxn/VxS1LvzE9HsGRE8gNk+Ny8lA0UsB13kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747936038; c=relaxed/simple;
	bh=8LHaOebIcuBVZJz6t1UR3CFXu1PV8TtDIhjsbTPCCXI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mus6Ix2k1SaG3DNssxZ5izzNsLkLSzQJxZdYATsp387iauLLXqPcNjKbSq5bL9okZxuyqHdYBsOak5Xih7xN1KYGIkGe63Ef5Mv/Ygrz4BbU1yAGJQF5qIZbIy3EG10npXBKSfDi49zWw5lDPP+LQooLF18auBrY1vAubaRbo5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WllOyjHj; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WllOyjHj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747936036; x=1779472036;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8LHaOebIcuBVZJz6t1UR3CFXu1PV8TtDIhjsbTPCCXI=;
  b=WllOyjHjcwv/SJAZ1BqzVIpneo26ZEQfU10deY49Lr5vIVQpQUMNKotx
   jMrJnq6XzfMJok/1GknEsykciCgtEHlTIG2gUrHRkE/udtFdIDmpF3E/j
   Su62Bu7E+8xAagHbGXCpc+k3OISs0QcSqd9flSnSm2NTmcFXGODs8X5lX
   vt6iegwE6F1ZQF/SV9AU1xOfSeJUqI7Rt7Sa+WAR1aVUVbQf99azUO0mj
   f3tN7dVnPfFCqbTdGqCe9d8ndjqw/wOE+O178/FmLBl8ReouVSlX9ap9x
   Tcw4Oa1t8pFratzhaFZpZHAXQ7lJZpuYlGD3petLxq22f6FfLXi9iRvd/
   Q==;
X-CSE-ConnectionGUID: uVxtEk15RLOJziWQKQLB3Q==
X-CSE-MsgGUID: cdUUtwTqTFOot6yFIgmZPA==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="75377104"
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="75377104"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 10:46:47 -0700
X-CSE-ConnectionGUID: Lx8VJQ9bRri9hdFYZMIVhQ==
X-CSE-MsgGUID: DvqOq+tkStCIdaMPLkQF/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="140777543"
Received: from tjmaciei-mobl5.ger.corp.intel.com (HELO [10.125.109.122]) ([10.125.109.122])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 10:46:46 -0700
Message-ID: <fc21a089-efa0-41b4-bc3e-70f6e7423719@intel.com>
Date: Thu, 22 May 2025 10:46:45 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [NDCTL PATCH v6 4/4] cxl/test: Add test for cxl features device
To: Marc Herbert <Marc.Herbert@linux.intel.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 Dan Williams <dan.j.williams@intel.com>
References: <20250509164006.687873-1-dave.jiang@intel.com>
 <20250509164006.687873-5-dave.jiang@intel.com>
 <aCYxY8tmvJ14sWB-@aschofie-mobl2.lan>
 <1375994d-d3ba-479d-8910-8e564967bace@intel.com>
 <ee7865a2-d57a-4b94-820f-7a3be90377b9@linux.intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <ee7865a2-d57a-4b94-820f-7a3be90377b9@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/22/25 10:37 AM, Marc Herbert wrote:
> On 2025-05-15 11:28, Dave Jiang wrote:
> 
>>>>  
>>>> +uuid_dep = dependency('uuid', required: false)
>>>> +if get_option('fwctl').enabled() and uuid_dep.found()
>>>> +  fwctl = executable('fwctl', 'fwctl.c',
>>>> +    dependencies : libcxl_deps,
>>>> +    include_directories : root_inc,
>>>> +  )
>>>> +  cxl_features = find_program('cxl-features.sh')
>>>> +  tests += [
>>>> +    [ 'cxl-features.sh',        cxl_features,       'cxl'   ],
>>>> +  ]
>>>> +endif
>>>
>>> Is the fwctl feature enabled fuss still needed now that the UAPI headers
>>> are vendored locally?  Seems the test will quickly SKIP if fwctl dev not
>>> found. I kind of like the idea of seeing a 'SKIP' and knowing the test
>>> didn't run than seeing nothing at all in the test output.
>>
>> This gives the option to disable fwctl if needed. Also there is a libuuid dependency since we use uuid lib calls. 
> 
> Is it possible to go anywhere without uuid?
> 
> fedora$ sudo dnf remove libuuid-devel
>         meson setup build
> 
> ...
> Run-time dependency libkmod found: YES 33
> Run-time dependency libudev found: YES 256
> Found CMake: /usr/bin/cmake (3.30.8)
> Run-time dependency uuid found: NO (tried pkgconfig and cmake)
> 
> meson.build:144:0: ERROR: Dependency "uuid" not found, tried pkgconfig and cmake
> 
> 
> meson setup --help | grep uuid  # empty
> git grep get_option.*uuid       # empty
> grep -C 5 uuid meson.build      # does not look optional
> 
> It looks like a hard requirement to me.
> 
> UUIDs are rarely ever "optional". It could be required only
> by some optional tool but that does not seem to be the case here

Apparently it's not an requirement for kernel build. As my feature user header caused issues due to lack of libuuid package.

> 
> Fun fact: it's not even possible to remove /usr/include/uuid/uuid.h
> on Arch Linux, not without breaking the system.
> 
> 

