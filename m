Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B6C8F70
	for <nvdimm@lists.linux.dev>; Tue, 17 Oct 2023 05:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lTHY6Llv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697520062; x=1729056062;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=0ljYECpynZJuwW/CzHhX9ZRRExV5kXxxKaS9D40UqLM=;
  b=lTHY6LlvxpIu2ofTU3/5LcoiRXjUnvTWMrQLd8h7HwxUFcRGa402nuk0
   y0CivI755Z/+xXaAp+ObIV7VIB9yj1L5ZF4YVBvqRphrpBGX5dBK0jFkj
   Y4r8qmIukxDxJxFM49ambUD1YGOVML1vh1VGEiVP5PNOwH0bF8Q9erxV1
   sJT96hpZ70ULLiEFvzBR9nvJq/9+KLn7tM7WLWMe6tlQWpM9quncR1Bkl
   cFcdV85y0FIUfGKdnjtbbOaeBJhZJeGkpOe0wF9sbaz2zMlhkP8T6I8VT
   cB8lRt0e4y7FvhJAl3vqfxUZ3QJf1Yq3TAfh2XbE2lVTdIbJeiUNyJQum
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="370771756"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="370771756"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 22:21:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="846685324"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="846685324"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 22:20:56 -0700
From: "Huang, Ying" <ying.huang@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,  "Jiang, Dave"
 <dave.jiang@intel.com>,  "osalvador@suse.de" <osalvador@suse.de>,
  "david@redhat.com" <david@redhat.com>,  "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>,  "dave.hansen@linux.intel.com"
 <dave.hansen@linux.intel.com>,  "linux-mm@kvack.org" <linux-mm@kvack.org>,
  "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
  "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
  "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,  "Hocko, Michal"
 <mhocko@suse.com>,  "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
  "jmoyer@redhat.com" <jmoyer@redhat.com>,  "Jonathan.Cameron@huawei.com"
 <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v5 2/2] dax/kmem: allow kmem to add memory with
 memmap_on_memory
In-Reply-To: <923d65270ad08d47adae0d82ab4b508d01e9cc00.camel@intel.com>
	(Vishal L. Verma's message of "Tue, 17 Oct 2023 08:31:04 +0800")
References: <20231005-vv-kmem_memmap-v5-0-a54d1981f0a3@intel.com>
	<20231005-vv-kmem_memmap-v5-2-a54d1981f0a3@intel.com>
	<651f27b728fef_ae7e7294b3@dwillia2-xfh.jf.intel.com.notmuch>
	<923d65270ad08d47adae0d82ab4b508d01e9cc00.camel@intel.com>
Date: Tue, 17 Oct 2023 13:18:56 +0800
Message-ID: <87edhtaksf.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii

"Verma, Vishal L" <vishal.l.verma@intel.com> writes:

> On Thu, 2023-10-05 at 14:16 -0700, Dan Williams wrote:
>> Vishal Verma wrote:
>> >
> <..>
>
>> > +
>> > +       rc = kstrtobool(buf, &val);
>> > +       if (rc)
>> > +               return rc;
>>
>> Perhaps:
>>
>> if (dev_dax->memmap_on_memory == val)
>>         return len;
>>
>> ...and skip the check below when it is going to be a nop
>>
>> > +
>> > +       device_lock(dax_region->dev);
>> > +       if (!dax_region->dev->driver) {
>>
>> Is the polarity backwards here? I.e. if the device is already attached to
>> the kmem driver it is too late to modify memmap_on_memory policy.
>
> Hm this sounded logical until I tried it. After a reconfigure-device to
> devdax (i.e. detach kmem), I get the -EBUSY if I invert this check.

Can you try to unbind the device via sysfs by hand and retry?

--
Best Regards,
Huang, Ying

>>
>> > +               device_unlock(dax_region->dev);
>> > +               return -ENXIO;
>>

[snip]
