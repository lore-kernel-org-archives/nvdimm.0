Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282FB1BB39
	for <nvdimm@lists.linux.dev>; Mon, 21 Aug 2023 23:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692660659; x=1724196659;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=EkN9k5iykyBDgII9+Wb82RB1BZVZdD0TgXowwLM8pWs=;
  b=DDRHfrGfRHKNskjCYppSqrh3oyx5kl4ihdVxnA2L0IGjJwnmCfOSF/8I
   9ArtrBhD0R4BytwKk0BwQizLuEMuQqpP5fZeNgQ+ecWm1gvM7iBxjm+mM
   MsXGXnH5/MKvy2xhqniqsL+alCSnlSnJC1Igxh21mjsOcd3K+TfNtUVcu
   0MQSnhaUzW0lkFPkaeYQVmpEd9hrFOKtV8CTO7Bx2V+Gw8tQJ1cGmtdHL
   1rLrmpzbYQakSModAvgWs9qTAhb/M45jzLlUF6y/097FtTKnYJtBJd+HR
   1eKyyQNv3KRRICLffO6bzU0UQhKrF1IOtwxybl4KNS+B1F+uhXZDDAuPv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="354052684"
X-IronPort-AV: E=Sophos;i="6.01,191,1684825200"; 
   d="scan'208";a="354052684"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2023 16:30:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="1066803842"
X-IronPort-AV: E=Sophos;i="6.01,191,1684825200"; 
   d="scan'208";a="1066803842"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2023 16:30:54 -0700
From: "Huang, Ying" <ying.huang@intel.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  <linux-mm@kvack.org>,
  <linux-kernel@vger.kernel.org>,  <linux-cxl@vger.kernel.org>,
  <nvdimm@lists.linux.dev>,  <linux-acpi@vger.kernel.org>,  "Aneesh Kumar K
 . V" <aneesh.kumar@linux.ibm.com>,  Wei Xu <weixugc@google.com>,  Dan
 Williams <dan.j.williams@intel.com>,  Dave Hansen <dave.hansen@intel.com>,
  "Davidlohr Bueso" <dave@stgolabs.net>,  Johannes Weiner
 <hannes@cmpxchg.org>,  "Jonathan Cameron" <Jonathan.Cameron@huawei.com>,
  Michal Hocko <mhocko@kernel.org>,  Yang Shi <shy828301@gmail.com>,
  Rafael J Wysocki <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH RESEND 3/4] acpi, hmat: calculate abstract distance with
 HMAT
References: <20230721012932.190742-1-ying.huang@intel.com>
	<20230721012932.190742-4-ying.huang@intel.com>
	<87ila8zo80.fsf@nvdebian.thelocal>
	<87h6psxzak.fsf@yhuang6-desk2.ccr.corp.intel.com>
	<878ra4wqz0.fsf@nvdebian.thelocal>
Date: Tue, 22 Aug 2023 07:28:49 +0800
In-Reply-To: <878ra4wqz0.fsf@nvdebian.thelocal> (Alistair Popple's message of
	"Mon, 21 Aug 2023 21:53:13 +1000")
Message-ID: <87edjwc6vi.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii

Alistair Popple <apopple@nvidia.com> writes:

> "Huang, Ying" <ying.huang@intel.com> writes:
>
>> Alistair Popple <apopple@nvidia.com> writes:
>>
>>> Huang Ying <ying.huang@intel.com> writes:
>>>
>>>> A memory tiering abstract distance calculation algorithm based on ACPI
>>>> HMAT is implemented.  The basic idea is as follows.
>>>>
>>>> The performance attributes of system default DRAM nodes are recorded
>>>> as the base line.  Whose abstract distance is MEMTIER_ADISTANCE_DRAM.
>>>> Then, the ratio of the abstract distance of a memory node (target) to
>>>> MEMTIER_ADISTANCE_DRAM is scaled based on the ratio of the performance
>>>> attributes of the node to that of the default DRAM nodes.
>>>
>>> The problem I encountered here with the calculations is that HBM memory
>>> ended up in a lower-tiered node which isn't what I wanted (at least when
>>> that HBM is attached to a GPU say).
>>
>> I have tested the series on a server machine with HBM (pure HBM, not
>> attached to a GPU).  Where, HBM is placed in a higher tier than DRAM.
>
> Good to know.
>
>>> I suspect this is because the calculations are based on the CPU
>>> point-of-view (access1) which still sees lower bandwidth to remote HBM
>>> than local DRAM, even though the remote GPU has higher bandwidth access
>>> to that memory. Perhaps we need to be considering access0 as well?
>>> Ie. HBM directly attached to a generic initiator should be in a higher
>>> tier regardless of CPU access characteristics?
>>
>> What's your requirements for memory tiers on the machine?  I guess you
>> want to put GPU attache HBM in a higher tier and put DRAM in a lower
>> tier.  So, cold HBM pages can be demoted to DRAM when there are memory
>> pressure on HBM?  This sounds reasonable from GPU point of view.
>
> Yes, that is what I would like to implement.
>
>> The above requirements may be satisfied via calculating abstract
>> distance based on access0 (or combined with access1).  But I suspect
>> this will be a general solution.  I guess that any memory devices that
>> are used mainly by the memory initiators other than CPUs want to put
>> themselves in a higher memory tier than DRAM, regardless of its
>> access0.
>
> Right. I'm still figuring out how ACPI HMAT fits together but that
> sounds reasonable.
>
>> One solution is to put GPU HBM in the highest memory tier (with smallest
>> abstract distance) always in GPU device driver regardless its HMAT
>> performance attributes.  Is it possible?
>
> It's certainly possible and easy enough to do, although I think it would
> be good to provide upper and lower bounds for HMAT derived adistances to
> make that easier. It does make me wonder what the point of HMAT is if we
> have to ignore it in some scenarios though. But perhaps I need to dig
> deeper into the GPU values to figure out how it can be applied correctly
> there.

In the original design (page 11 of [1]),

[1] https://lpc.events/event/16/contributions/1209/attachments/1042/1995/Live%20In%20a%20World%20With%20Multiple%20Memory%20Types.pdf

the default memory tier hierarchy is based on the performance from CPU
point of view.  Then the abstract distance of a memory type (e.g., GPU
HBM) can be adjusted via a sysfs knob
(<memory_type>/abstract_distance_offset) based on the requirements of
GPU.

That's another possible solution.

--
Best Regards,
Huang, Ying

