Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F84325D539
	for <nvdimm@lists.linux.dev>; Thu, 15 May 2025 18:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747333687; cv=none; b=A95v1z1jy4Q5+PHWcgLZ6TVhNRV3sm6HI6NP0LLw69+C7jbRebKVLVA160gAnIWkPqh26BeCkwYX3hDOSfbaCDJ9+Erv1TvXY8Kl/3pgiEgteeDckCOILpMmhOZ9YTEmp+3Lrt2rI2djJYoZvSlTdd/rhSYtY6QzMfK2jds8ZJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747333687; c=relaxed/simple;
	bh=DG9VQ1Zs3e3zKoY7O9whzhGa2vKfpSjMY2vFoI/mBqU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bcFDcZXYvnOmRETxDwsroTJFbz2stC0cEaycwhH+kqu4VvAmzkvubujjg4TVMFdDmZhxBwOs0Pydsj0xE4VjgC/nwQPly+RvYfN5JjAWLQ3hSc5fgfuDZsAZB5PHz3Rs+w2t+k5q/HlBicYLJSwayDHBCd0OBvyudlck6d2Y3UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eZB8vHz9; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eZB8vHz9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747333685; x=1778869685;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DG9VQ1Zs3e3zKoY7O9whzhGa2vKfpSjMY2vFoI/mBqU=;
  b=eZB8vHz9D0f4B3Dgo+Su6r2b7ok0q4o4udvlVPPrejFZmo938B0L2A1d
   xLfu/vXIrXV+e6LA/L58iw8yHXSNEE+STpXbQEumJYPglROuQgl0WC+Qm
   q7JJ5rMUB5CkAPvk7s4Ud/gbxZYCdObJU4E0V9Du7bPinY8IfEt9cgVyo
   RTw3Rnz2ZDHA+K0m+EZHwt/FlpNsgFOy884XK7l/Lk882UJFezDUqPdcZ
   XNy8rk8qoZJcKhJU8rFawQBfODTMU5sOZflNqohtAooirTA2K5W0VQGdO
   Z/N/qNnitcQHClM9dYLkllZvOyuNTW3HwbUmd/sWsKXPkY6i9FXlAGIDn
   g==;
X-CSE-ConnectionGUID: GnAIfX9+TC+INnmKEbrTvw==
X-CSE-MsgGUID: PuZoeYZ5Tei6ulgU/NJzDA==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="49358025"
X-IronPort-AV: E=Sophos;i="6.15,291,1739865600"; 
   d="scan'208";a="49358025"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 11:28:05 -0700
X-CSE-ConnectionGUID: tBA8J/K3Stu84CooL+G2xA==
X-CSE-MsgGUID: Y9Eq5rqqQmGRh8tPkdssDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,291,1739865600"; 
   d="scan'208";a="169528097"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO [10.125.109.47]) ([10.125.109.47])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 11:28:04 -0700
Message-ID: <1375994d-d3ba-479d-8910-8e564967bace@intel.com>
Date: Thu, 15 May 2025 11:28:01 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [NDCTL PATCH v6 4/4] cxl/test: Add test for cxl features device
To: Alison Schofield <alison.schofield@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 Dan Williams <dan.j.williams@intel.com>
References: <20250509164006.687873-1-dave.jiang@intel.com>
 <20250509164006.687873-5-dave.jiang@intel.com>
 <aCYxY8tmvJ14sWB-@aschofie-mobl2.lan>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <aCYxY8tmvJ14sWB-@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/15/25 11:24 AM, Alison Schofield wrote:
> On Fri, May 09, 2025 at 09:39:15AM -0700, Dave Jiang wrote:
>> Add a unit test to verify the features ioctl commands. Test support added
>> for locating a features device, retrieve and verify the supported features
>> commands, retrieve specific feature command data, retrieve test feature
>> data, and write and verify test feature data.
>>
>> Acked-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>> v6:
>> - Provide a fwctl option and move everything behind it. (Dan)
>> - Rename test app back to fwctl.c. (Dan)
>> - Fix spelling error. (Dan)
>> - Expand scope of fwctl device in documentation. (Dan)
>> ---
>>  cxl/fwctl/cxl.h      |   2 +-
>>  meson_options.txt    |   2 +
>>  test/cxl-features.sh |  31 +++
>>  test/fwctl.c         | 439 +++++++++++++++++++++++++++++++++++++++++++
>>  test/meson.build     |  19 ++
>>  5 files changed, 492 insertions(+), 1 deletion(-)
>>  create mode 100755 test/cxl-features.sh
>>  create mode 100644 test/fwctl.c
>>
> 
> skip - 
> 
> 
>> diff --git a/test/meson.build b/test/meson.build
>> index d871e28e17ce..918db7e6049b 100644
>> --- a/test/meson.build
>> +++ b/test/meson.build
>> @@ -17,6 +17,13 @@ ndctl_deps = libndctl_deps + [
>>    versiondep,
>>  ]
>>  
>> +libcxl_deps = [
>> +  cxl_dep,
>> +  ndctl_dep,
>> +  uuid,
>> +  kmod,
>> +]
>> +
>>  libndctl = executable('libndctl', testcore + [ 'libndctl.c'],
>>    dependencies : libndctl_deps,
>>    include_directories : root_inc,
>> @@ -235,6 +242,18 @@ if get_option('keyutils').enabled()
>>    ]
>>  endif
>>  
>> +uuid_dep = dependency('uuid', required: false)
>> +if get_option('fwctl').enabled() and uuid_dep.found()
>> +  fwctl = executable('fwctl', 'fwctl.c',
>> +    dependencies : libcxl_deps,
>> +    include_directories : root_inc,
>> +  )
>> +  cxl_features = find_program('cxl-features.sh')
>> +  tests += [
>> +    [ 'cxl-features.sh',        cxl_features,       'cxl'   ],
>> +  ]
>> +endif
> 
> Is the fwctl feature enabled fuss still needed now that the UAPI headers
> are vendored locally?  Seems the test will quickly SKIP if fwctl dev not
> found. I kind of like the idea of seeing a 'SKIP' and knowing the test
> didn't run than seeing nothing at all in the test output.

This gives the option to disable fwctl if needed. Also there is a libuuid dependency since we use uuid lib calls. 

> 
>> +
>>  foreach t : tests
>>    test(t[0], t[1],
>>      is_parallel : false,
>> -- 
>> 2.49.0
>>

