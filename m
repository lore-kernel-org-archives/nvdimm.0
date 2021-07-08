Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A6A168
	for <nvdimm@lists.linux.dev>; Thu,  8 Jul 2021 06:52:37 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="196729642"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="196729642"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 23:52:36 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="498268342"
Received: from jingqili-mobl.ccr.corp.intel.com (HELO [10.238.6.254]) ([10.238.6.254])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 23:52:35 -0700
Subject: Re: [PATCH] ndctl/dimm: Fix to dump namespace indexs and labels
To: "Verma, Vishal L" <vishal.l.verma@intel.com>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
References: <20210609030642.66204-1-jingqi.liu@intel.com>
 <8110e80df98fb57fd20d0bf73dc7d266fef5ab84.camel@intel.com>
 <9cba6794-e3ea-fb89-1391-e3bd992912a6@intel.com>
 <d9d858e2431193f9aacba83f8a792a34486ac900.camel@intel.com>
From: "Liu, Jingqi" <jingqi.liu@intel.com>
Message-ID: <cba902d9-820e-93d2-2718-68abc665ce01@intel.com>
Date: Thu, 8 Jul 2021 14:52:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <d9d858e2431193f9aacba83f8a792a34486ac900.camel@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/8/2021 1:59 PM, Verma, Vishal L wrote:
> On Thu, 2021-07-08 at 09:53 +0800, Liu, Jingqi wrote:
>>>
>>> [..]
>>>>
>>>> diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
>>>> index 0a82616..0ce2bb9 100644
>>>> --- a/ndctl/lib/libndctl.sym
>>>> +++ b/ndctl/lib/libndctl.sym
>>>> @@ -290,6 +290,7 @@ global:
>>>>         ndctl_dimm_validate_labels;
>>>>         ndctl_dimm_init_labels;
>>>>         ndctl_dimm_sizeof_namespace_label;
>>>> +     ndctl_dimm_sizeof_namespace_index;
>>>
>>> This can't go into an 'old' section of the symbol version script - if
>>> you base off the current 'pending' branch, you should see a LIBNDCTL_26
>>> section at the bottom. You can add this there.
>>
>> It's based on the current 'master' branch.
>> I don't see a LIBNDCTL_26 section, just 'LIBNDCTL_25'.
>> How about adding 'ndctl_dimm_sizeof_namespace_index' to LIBNDCTL_25
>> section ?
>>
> No - so once a release happens, that section is 'closed' forever. The
> master branch coincides with the v71 release. That release had added
> new symbols in the LIBNDCTL_25 section, and that section is now done.
> New symbols after v71 need to go in a new section, LIBNDCTL_26.
> 
> The pending branch just happens to have patches that added a new
> symbol, so the new section is already created for you - so if you
> rebase to pending, you can just reuse that. Alternatively, base off
> master, and create a new LIBNDCTL_26 section, and I'll fix up the
> trivial conflict when merging.
> 
> Hope this clarifies things a bit!

Got it.
Thanks your clarification.
The other modifications of this patch are based on the master branch.
So for this file, I'll base off master.
Thank you for fixing up the conflict when merging.

Thanks,
Jingqi
> 
> Thanks,
> -Vishal
> 
