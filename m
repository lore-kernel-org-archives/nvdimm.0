Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966973C4B98
	for <nvdimm@lists.linux.dev>; Tue, 12 May 2026 15:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778600694; cv=none; b=QN1VCUEEYSh3iOs066UPs7FDi+dtvDsk0KswaiJLgOwjrfMrbyP+n/BckKRhAscQWwXPCnCRxbpCBYWHP8DT1UnlyZ34aHoE/1H1G3WJmYb9XR6Cg5ICYlvDDUU2YAA7o5eBLdJLzbpUM9t8T4/Fxq0AAdITh9zG1JMXMFSlHXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778600694; c=relaxed/simple;
	bh=KeYuZ8GxrTdO4QCnUizgHtWp/2BUl0oj1XJ8jBhQa4o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DnzUTYEDIq33uYNPnytWED5fPptwFfIWi/eMcB6hfdyEgvPtN/4vVoKsgMwcHleiWlxGa6/Oxw3oCmurXZGCx1fQkDrlJAk71kwfsVNR+WVtImKJ0uYTFa6ygj60/h2myCiShT/f0Yzw83LgdJKBwsjsEtc1cL3fZ137nwTAbNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z4cYTyni; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z4cYTyni"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778600692; x=1810136692;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KeYuZ8GxrTdO4QCnUizgHtWp/2BUl0oj1XJ8jBhQa4o=;
  b=Z4cYTyniVRhHj9hSsOEWIy6eAXHMMf2Hl8eSXM6r3b3Qg6n55TCOWKof
   mghWBClXg9EUFxx4KvUfERMPksw62i7UIhu5mxQv7CaMN94mBZBjpMcmK
   ZgAWksEEmsjyPHuWsaMPfSA+shs1tmpMAB0MvjrKwhFOiitea+vTblodj
   jw0PjPwXb8RSNmEh7hJIogEJ67/eRi+lnMg6e2ce4fHi+Lrq7St/MtzYL
   tm2czDDKnrSAyVRUoBk91swYN0fxVK2V+wFFQVgxCylOkUWhG/KgObPG4
   EqTAFFIJ4+Y+A+VvdS3gY0X6FcciANa4jU4eIkLWNskjxyPY/MwWb7gXY
   w==;
X-CSE-ConnectionGUID: cTj1jnksSk6WkUu2imtxmw==
X-CSE-MsgGUID: 0JlMvw55SjKbiOMRZTX1Mw==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="90616514"
X-IronPort-AV: E=Sophos;i="6.23,231,1770624000"; 
   d="scan'208";a="90616514"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 08:44:50 -0700
X-CSE-ConnectionGUID: iLiBCTpWQXSkfOV5Cv/0bQ==
X-CSE-MsgGUID: 9ZEmdtslRHu4DtVIXHY2lA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,231,1770624000"; 
   d="scan'208";a="242773975"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.111.237]) ([10.125.111.237])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 08:44:47 -0700
Message-ID: <6f82e991-30f7-4eb2-abdc-6b0bc704d4a6@intel.com>
Date: Tue, 12 May 2026 08:44:45 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/9] dax/hmem, cxl: Coordinate Soft Reserved handling
 with CXL and HMEM
To: Tomasz Wolski <tomasz.wolski@fujitsu.com>
Cc: alison.schofield@intel.com, ardb@kernel.org, benjamin.cheatham@amd.com,
 bp@alien8.de, dave@stgolabs.net, gregkh@linuxfoundation.org,
 huang.ying.caritas@gmail.com, ira.weiny@intel.com, jack@suse.cz,
 jeff.johnson@oss.qualcomm.com, len.brown@intel.com,
 linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
 lizhijian@fujitsu.com, ming.li@zohomail.com, nathan.fontenot@amd.com,
 nvdimm@lists.linux.dev, pavel@kernel.org, peterz@infradead.org,
 rafael@kernel.org, rrichter@amd.com, smita.koralahallichannabasappa@amd.com,
 terry.bowman@amd.com, vishal.l.verma@intel.com, willy@infradead.org,
 yaoxt.fnst@fujitsu.com, yazen.ghannam@amd.com, Dan Williams
 <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>
References: <20260416224618.12987-1-tomasz.wolski@fujitsu.com>
 <20260512125759.30007-1-tomasz.wolski@fujitsu.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260512125759.30007-1-tomasz.wolski@fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/12/26 5:57 AM, Tomasz Wolski wrote:
> Hello Smita,
> 
> Do you plan to address the remaining minor comments from Dan and Jonathan in the next revision?
> https://lore.kernel.org/linux-cxl/69c1a8d1c0fa9_7ee3100a1@dwillia2-mobl4.notmuch/
> https://lore.kernel.org/linux-cxl/20260323181331.000018f2@huawei.com/

Hi Tomaz,

Smita's series were merged in during the 7.1 merge window. So any additional changes will have to be follow on patches.

> 
> Best regards,
> Tomasz

