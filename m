Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAD81BB3A
	for <nvdimm@lists.linux.dev>; Mon, 21 Aug 2023 23:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692660937; x=1724196937;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=lyG/72iRKaKPXkXbLzVHa9J51DlyHySbY0/hxJRW8/0=;
  b=Vrdgwyyg93WCL5tJb8k60iIlcD76fJ9kK++kINaBkGgIMsZ8i2/dHtxD
   6Jjsvcg/nro8xl+zFe8k5y+pvdRgJysnJ7rPDVtseaOu8tkVNWJofswDC
   QbGaeu3G8F9W2UIKXfonLT+NkkG6nk3USbRylvrvlYa0YYJ8aWMHHIF3F
   oOAiriAtsQ4WpPTq3YSqbDPfww+0RiMuNV16R2WrLd51QD9nJiV6hdbw2
   pmUGKImBTH0u1LeAspFFSWpUlVROxlQzxVzBIUN0fResTK9E8uqU1Jouu
   wpHmWlL8THsGnW968tbL61GBgy+AMgevvbMX2GunTr8H+kIYokEiI8Qc1
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="440097325"
X-IronPort-AV: E=Sophos;i="6.01,191,1684825200"; 
   d="scan'208";a="440097325"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2023 16:35:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="850368628"
X-IronPort-AV: E=Sophos;i="6.01,191,1684825200"; 
   d="scan'208";a="850368628"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2023 16:35:33 -0700
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
Subject: Re: [PATCH RESEND 4/4] dax, kmem: calculate abstract distance with
 general interface
References: <20230721012932.190742-1-ying.huang@intel.com>
	<20230721012932.190742-5-ying.huang@intel.com>
	<87edkwznsf.fsf@nvdebian.thelocal>
	<87cz0gxylp.fsf@yhuang6-desk2.ccr.corp.intel.com>
	<871qfwwqi3.fsf@nvdebian.thelocal>
Date: Tue, 22 Aug 2023 07:33:28 +0800
In-Reply-To: <871qfwwqi3.fsf@nvdebian.thelocal> (Alistair Popple's message of
	"Mon, 21 Aug 2023 22:03:43 +1000")
Message-ID: <87a5ukc6nr.fsf@yhuang6-desk2.ccr.corp.intel.com>
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
>>>> Previously, a fixed abstract distance MEMTIER_DEFAULT_DAX_ADISTANCE is
>>>> used for slow memory type in kmem driver.  This limits the usage of
>>>> kmem driver, for example, it cannot be used for HBM (high bandwidth
>>>> memory).
>>>>
>>>> So, we use the general abstract distance calculation mechanism in kmem
>>>> drivers to get more accurate abstract distance on systems with proper
>>>> support.  The original MEMTIER_DEFAULT_DAX_ADISTANCE is used as
>>>> fallback only.
>>>>
>>>> Now, multiple memory types may be managed by kmem.  These memory types
>>>> are put into the "kmem_memory_types" list and protected by
>>>> kmem_memory_type_lock.
>>>
>>> See below but I wonder if kmem_memory_types could be a common helper
>>> rather than kdax specific?
>>>
>>>> Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
>>>> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>>>> Cc: Wei Xu <weixugc@google.com>
>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>> Cc: Dan Williams <dan.j.williams@intel.com>
>>>> Cc: Dave Hansen <dave.hansen@intel.com>
>>>> Cc: Davidlohr Bueso <dave@stgolabs.net>
>>>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>>>> Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>>>> Cc: Michal Hocko <mhocko@kernel.org>
>>>> Cc: Yang Shi <shy828301@gmail.com>
>>>> Cc: Rafael J Wysocki <rafael.j.wysocki@intel.com>
>>>> ---
>>>>  drivers/dax/kmem.c           | 54 +++++++++++++++++++++++++++---------
>>>>  include/linux/memory-tiers.h |  2 ++
>>>>  mm/memory-tiers.c            |  2 +-
>>>>  3 files changed, 44 insertions(+), 14 deletions(-)
>>>>
>>>> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
>>>> index 898ca9505754..837165037231 100644
>>>> --- a/drivers/dax/kmem.c
>>>> +++ b/drivers/dax/kmem.c
>>>> @@ -49,14 +49,40 @@ struct dax_kmem_data {
>>>>  	struct resource *res[];
>>>>  };
>>>>  
>>>> -static struct memory_dev_type *dax_slowmem_type;
>>>> +static DEFINE_MUTEX(kmem_memory_type_lock);
>>>> +static LIST_HEAD(kmem_memory_types);
>>>> +
>>>> +static struct memory_dev_type *kmem_find_alloc_memorty_type(int adist)
>>>> +{
>>>> +	bool found = false;
>>>> +	struct memory_dev_type *mtype;
>>>> +
>>>> +	mutex_lock(&kmem_memory_type_lock);
>>>> +	list_for_each_entry(mtype, &kmem_memory_types, list) {
>>>> +		if (mtype->adistance == adist) {
>>>> +			found = true;
>>>> +			break;
>>>> +		}
>>>> +	}
>>>> +	if (!found) {
>>>> +		mtype = alloc_memory_type(adist);
>>>> +		if (!IS_ERR(mtype))
>>>> +			list_add(&mtype->list, &kmem_memory_types);
>>>> +	}
>>>> +	mutex_unlock(&kmem_memory_type_lock);
>>>> +
>>>> +	return mtype;
>>>> +}
>>>> +
>>>>  static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>>>>  {
>>>>  	struct device *dev = &dev_dax->dev;
>>>>  	unsigned long total_len = 0;
>>>>  	struct dax_kmem_data *data;
>>>> +	struct memory_dev_type *mtype;
>>>>  	int i, rc, mapped = 0;
>>>>  	int numa_node;
>>>> +	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
>>>>  
>>>>  	/*
>>>>  	 * Ensure good NUMA information for the persistent memory.
>>>> @@ -71,6 +97,11 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>>>>  		return -EINVAL;
>>>>  	}
>>>>  
>>>> +	mt_calc_adistance(numa_node, &adist);
>>>> +	mtype = kmem_find_alloc_memorty_type(adist);
>>>> +	if (IS_ERR(mtype))
>>>> +		return PTR_ERR(mtype);
>>>> +
>>>
>>> I wrote my own quick and dirty module to test this and wrote basically
>>> the same code sequence.
>>>
>>> I notice your using a list of memory types here though. I think it would
>>> be nice to have a common helper that other users could call to do the
>>> mt_calc_adistance() / kmem_find_alloc_memory_type() /
>>> init_node_memory_type() sequence and cleanup as my naive approach would
>>> result in a new memory_dev_type per device even though adist might be
>>> the same. A common helper would make it easy to de-dup those.
>>
>> If it's useful, we can move kmem_find_alloc_memory_type() to
>> memory-tier.c after some revision.  But I tend to move it after we have
>> the second user.  What do you think about that?
>
> Usually I would agree, but this series already introduces a general
> interface for calculating adist even though there's only one user and
> implementation. So if we're going to add a general interface I think it
> would be better to make it more usable now rather than after variations
> of it have been cut and pasted into other drivers.

In general, I would like to introduce complexity when necessary.  So, we
can discuss the necessity of the general interface firstly.  We can do
that in [1/4] of the series.

--
Best Regards,
Huang, Ying
