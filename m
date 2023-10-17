Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30D7C134
	for <nvdimm@lists.linux.dev>; Tue, 17 Oct 2023 05:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mGOukdYi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697522215; x=1729058215;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=aigizliSGfQOt/MVN5mwaZASQEdSNMmajEsIVyXWVes=;
  b=mGOukdYiSi2caSzQGxGBxt8o4mLedzzcj2gpQP3xKtLYBfGQSU22bRPe
   cextzfNrtkdLVjJPu2FVuCyAehbRv390K99MvfVPJPnH7c1z+h13pxVOr
   IJuBDsvrZY5ltYWok832/1SnjjNjgwpEciVw77Zs4px0NknAqmHq1xxxh
   Dfkr+e6RjuJmhRj9NlhwrPajXFw9N6/tnW3eEibGoXpg7Pj7EIERuxvnu
   N6yyv9KYJnHIQE9vbyGktUdR0UFsfFzSMwaLpNTKLPEpDej3KfrY4ainO
   4hDkonhhyc4JDhfc4IbC7cmuqj+b9BSsW7D+6ctc1fP4+T8nTP1FvD+L2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="370775614"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="370775614"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 22:56:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="785370099"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="785370099"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 22:56:51 -0700
From: "Huang, Ying" <ying.huang@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "david@redhat.com" <david@redhat.com>,  "Hocko, Michal"
 <mhocko@suse.com>,  "Jiang, Dave" <dave.jiang@intel.com>,
  "linux-mm@kvack.org" <linux-mm@kvack.org>,  "osalvador@suse.de"
 <osalvador@suse.de>,  "aneesh.kumar@linux.ibm.com"
 <aneesh.kumar@linux.ibm.com>,  "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,  "Williams, Dan J"
 <dan.j.williams@intel.com>,  "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>,  "linux-cxl@vger.kernel.org"
 <linux-cxl@vger.kernel.org>,  "nvdimm@lists.linux.dev"
 <nvdimm@lists.linux.dev>,  "dave.hansen@linux.intel.com"
 <dave.hansen@linux.intel.com>,  "jmoyer@redhat.com" <jmoyer@redhat.com>,
  "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v5 2/2] dax/kmem: allow kmem to add memory with
 memmap_on_memory
In-Reply-To: <7a29c85bda2543a0f31d575ced3e57eb93063fc3.camel@intel.com>
	(Vishal L. Verma's message of "Tue, 17 Oct 2023 13:44:27 +0800")
References: <20231005-vv-kmem_memmap-v5-0-a54d1981f0a3@intel.com>
	<20231005-vv-kmem_memmap-v5-2-a54d1981f0a3@intel.com>
	<651f27b728fef_ae7e7294b3@dwillia2-xfh.jf.intel.com.notmuch>
	<923d65270ad08d47adae0d82ab4b508d01e9cc00.camel@intel.com>
	<87edhtaksf.fsf@yhuang6-desk2.ccr.corp.intel.com>
	<7a29c85bda2543a0f31d575ced3e57eb93063fc3.camel@intel.com>
Date: Tue, 17 Oct 2023 13:54:50 +0800
Message-ID: <874jip94k5.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii

"Verma, Vishal L" <vishal.l.verma@intel.com> writes:

> On Tue, 2023-10-17 at 13:18 +0800, Huang, Ying wrote:
>> "Verma, Vishal L" <vishal.l.verma@intel.com> writes:
>>
>> > On Thu, 2023-10-05 at 14:16 -0700, Dan Williams wrote:
>> > > Vishal Verma wrote:
>> > > >
>> > <..>
>> >
>> > > > +
>> > > > +       rc = kstrtobool(buf, &val);
>> > > > +       if (rc)
>> > > > +               return rc;
>> > >
>> > > Perhaps:
>> > >
>> > > if (dev_dax->memmap_on_memory == val)
>> > >         return len;
>> > >
>> > > ...and skip the check below when it is going to be a nop
>> > >
>> > > > +
>> > > > +       device_lock(dax_region->dev);
>> > > > +       if (!dax_region->dev->driver) {
>> > >
>> > > Is the polarity backwards here? I.e. if the device is already
>> > > attached to
>> > > the kmem driver it is too late to modify memmap_on_memory policy.
>> >
>> > Hm this sounded logical until I tried it. After a reconfigure-
>> > device to
>> > devdax (i.e. detach kmem), I get the -EBUSY if I invert this check.
>>
>> Can you try to unbind the device via sysfs by hand and retry?
>>
> I think what is happening maybe is while kmem gets detached, the device
> goes back to another dax driver (hmem in my tests). So either way, the
> check for if (driver) or if (!driver) won't distinguish between kmem
> vs. something else.
>
> Maybe we just remove this check? Or add an explicit kmem check somehow?

I think it's good to check kmem explicitly here.

--
Best Regards,
Huang, Ying
