Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CAA538F
	for <nvdimm@lists.linux.dev>; Tue, 25 Jul 2023 06:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690267813; x=1721803813;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=sMXp8XuVx7sja1Zb9TfJOl/mMXazPG34qUPoSd0z870=;
  b=HFVfU2t4zk9Zw8cgzUHlLkdcAJLqDetJtUJ1J0DzwoMjaz3HvY00J+an
   zV1g4oFv6d6sjszSbYkCTfxEIPMXAWM/o0ypyDA3lar3E86C/oZiXEDF1
   QpOUWigIs80AkzlWoeWiItoBxRs/YUYxaWpmZsb7Vvb8id00XKhKJ80a/
   crpwr8h+NrQQWqqGH4R2kDI90AUfyUcaOxnFWR7Ss36GVByMJuHrl5Olb
   GgzOwx14M0x6ZQOOcz8d54q8sFwVBqs2xR/ciMi5r7983dU8e4/J+Y11X
   y8XCuBxpW6TKdQm7g5Wj4DMUZgfBo1iW6GTpWpdjcqwQ+Fc12tKJMA9R2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="347242154"
X-IronPort-AV: E=Sophos;i="6.01,230,1684825200"; 
   d="scan'208";a="347242154"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 23:50:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="1056698073"
X-IronPort-AV: E=Sophos;i="6.01,230,1684825200"; 
   d="scan'208";a="1056698073"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 23:49:39 -0700
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
In-Reply-To: <87ila8zo80.fsf@nvdebian.thelocal> (Alistair Popple's message of
	"Tue, 25 Jul 2023 12:45:01 +1000")
References: <20230721012932.190742-1-ying.huang@intel.com>
	<20230721012932.190742-4-ying.huang@intel.com>
	<87ila8zo80.fsf@nvdebian.thelocal>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Date: Tue, 25 Jul 2023 14:47:47 +0800
Message-ID: <87h6psxzak.fsf@yhuang6-desk2.ccr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii

Alistair Popple <apopple@nvidia.com> writes:

> Huang Ying <ying.huang@intel.com> writes:
>
>> A memory tiering abstract distance calculation algorithm based on ACPI
>> HMAT is implemented.  The basic idea is as follows.
>>
>> The performance attributes of system default DRAM nodes are recorded
>> as the base line.  Whose abstract distance is MEMTIER_ADISTANCE_DRAM.
>> Then, the ratio of the abstract distance of a memory node (target) to
>> MEMTIER_ADISTANCE_DRAM is scaled based on the ratio of the performance
>> attributes of the node to that of the default DRAM nodes.
>
> The problem I encountered here with the calculations is that HBM memory
> ended up in a lower-tiered node which isn't what I wanted (at least when
> that HBM is attached to a GPU say).

I have tested the series on a server machine with HBM (pure HBM, not
attached to a GPU).  Where, HBM is placed in a higher tier than DRAM.

> I suspect this is because the calculations are based on the CPU
> point-of-view (access1) which still sees lower bandwidth to remote HBM
> than local DRAM, even though the remote GPU has higher bandwidth access
> to that memory. Perhaps we need to be considering access0 as well?
> Ie. HBM directly attached to a generic initiator should be in a higher
> tier regardless of CPU access characteristics?

What's your requirements for memory tiers on the machine?  I guess you
want to put GPU attache HBM in a higher tier and put DRAM in a lower
tier.  So, cold HBM pages can be demoted to DRAM when there are memory
pressure on HBM?  This sounds reasonable from GPU point of view.

The above requirements may be satisfied via calculating abstract
distance based on access0 (or combined with access1).  But I suspect
this will be a general solution.  I guess that any memory devices that
are used mainly by the memory initiators other than CPUs want to put
themselves in a higher memory tier than DRAM, regardless of its
access0.

One solution is to put GPU HBM in the highest memory tier (with smallest
abstract distance) always in GPU device driver regardless its HMAT
performance attributes.  Is it possible?

> That said I'm not entirely convinced the HMAT tables I'm testing against
> are accurate/complete.

--
Best Regards,
Huang, Ying
