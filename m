Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA64DA23
	for <nvdimm@lists.linux.dev>; Tue, 12 Dec 2023 00:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UACTZqHu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702342716; x=1733878716;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=nso73b76ltEzpEq8N8M/qI8Y1oyBdGdHXb+w/8UiECk=;
  b=UACTZqHuR+hGL16AYDmvJ9oUqyVUsZt6u57FSQMriFSjKt5cRYmWT9wT
   e9H45iFYQ9uWLTl6E2lvENkUYFEYD7B1oUn1+0EgKA0r2JDyDEq+Lbm/B
   qtV6FXgqNjiVvnljxvMeOkp+IrKxQVE+URYninmOpX/GVxordSpFYZk/b
   xqTBrkY3cdu64QU50AtWSkVph0v+xOU5ke4gDiMAi8Lty0svgtHPxH0jU
   EkVOXcF/Y44xms4xP/9jdbW//DH040U1cjUQ4hPRPEVlDEYLJVfELvOHu
   eYjMZa5MvC4FSuyJAb98bKrXGfpajiLSJggW9SqZnQFONvSNr9jfNrDDf
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="459046252"
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="459046252"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2023 16:58:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="843711895"
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="843711895"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2023 16:58:33 -0800
From: "Huang, Ying" <ying.huang@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "david@redhat.com" <david@redhat.com>,  "Jiang, Dave"
 <dave.jiang@intel.com>,  "dave.hansen@linux.intel.com"
 <dave.hansen@linux.intel.com>,  "linux-cxl@vger.kernel.org"
 <linux-cxl@vger.kernel.org>,  "Jonathan.Cameron@huawei.com"
 <Jonathan.Cameron@huawei.com>,  "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,  "Williams, Dan J"
 <dan.j.williams@intel.com>,  "nvdimm@lists.linux.dev"
 <nvdimm@lists.linux.dev>,  "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>
Subject: Re: [PATCH v3 2/2] dax: add a sysfs knob to control
 memmap_on_memory behavior
In-Reply-To: <aac91f0ae8774c521469d518585a499da52912a8.camel@intel.com>
	(Vishal L. Verma's message of "Tue, 12 Dec 2023 08:40:57 +0800")
References: <20231211-vv-dax_abi-v3-0-acf6cc1bde9f@intel.com>
	<20231211-vv-dax_abi-v3-2-acf6cc1bde9f@intel.com>
	<87msugxnx9.fsf@yhuang6-desk2.ccr.corp.intel.com>
	<aac91f0ae8774c521469d518585a499da52912a8.camel@intel.com>
Date: Tue, 12 Dec 2023 08:56:33 +0800
Message-ID: <87il54xmpq.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii

"Verma, Vishal L" <vishal.l.verma@intel.com> writes:

> On Tue, 2023-12-12 at 08:30 +0800, Huang, Ying wrote:
>> Vishal Verma <vishal.l.verma@intel.com> writes:
>>
>> > Add a sysfs knob for dax devices to control the memmap_on_memory setting
>> > if the dax device were to be hotplugged as system memory.
>> >
>> > The default memmap_on_memory setting for dax devices originating via
>> > pmem or hmem is set to 'false' - i.e. no memmap_on_memory semantics, to
>> > preserve legacy behavior. For dax devices via CXL, the default is on.
>> > The sysfs control allows the administrator to override the above
>> > defaults if needed.
>> >
>> > Cc: David Hildenbrand <david@redhat.com>
>> > Cc: Dan Williams <dan.j.williams@intel.com>
>> > Cc: Dave Jiang <dave.jiang@intel.com>
>> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
>> > Cc: Huang Ying <ying.huang@intel.com>
>> > Tested-by: Li Zhijian <lizhijian@fujitsu.com>
>> > Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>> > Reviewed-by: David Hildenbrand <david@redhat.com>
>> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
>> > ---
>> >  drivers/dax/bus.c                       | 47 +++++++++++++++++++++++++++++++++
>> >  Documentation/ABI/testing/sysfs-bus-dax | 17 ++++++++++++
>> >  2 files changed, 64 insertions(+)
>> >
>> > diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
>> > index 1ff1ab5fa105..2871e5188f0d 100644
>> > --- a/drivers/dax/bus.c
>> > +++ b/drivers/dax/bus.c
>> > @@ -1270,6 +1270,52 @@ static ssize_t numa_node_show(struct device *dev,
>> >  }
>> >  static DEVICE_ATTR_RO(numa_node);
>> >
>> > +static ssize_t memmap_on_memory_show(struct device *dev,
>> > +                                    struct device_attribute *attr, char *buf)
>> > +{
>> > +       struct dev_dax *dev_dax = to_dev_dax(dev);
>> > +
>> > +       return sprintf(buf, "%d\n", dev_dax->memmap_on_memory);
>> > +}
>> > +
>> > +static ssize_t memmap_on_memory_store(struct device *dev,
>> > +                                     struct device_attribute *attr,
>> > +                                     const char *buf, size_t len)
>> > +{
>> > +       struct device_driver *drv = dev->driver;
>> > +       struct dev_dax *dev_dax = to_dev_dax(dev);
>> > +       struct dax_region *dax_region = dev_dax->region;
>> > +       struct dax_device_driver *dax_drv = to_dax_drv(drv);
>> > +       ssize_t rc;
>> > +       bool val;
>> > +
>> > +       rc = kstrtobool(buf, &val);
>> > +       if (rc)
>> > +               return rc;
>> > +
>> > +       if (dev_dax->memmap_on_memory == val)
>> > +               return len;
>> > +
>> > +       device_lock(dax_region->dev);
>> > +       if (!dax_region->dev->driver) {
>> > +               device_unlock(dax_region->dev);
>> > +               return -ENXIO;
>> > +       }
>>
>> I think that it should be OK to write to "memmap_on_memory" if no driver
>> is bound to the device.  We just need to avoid to write to it when kmem
>> driver is bound.
>
> Oh this is just a check on the region driver, not for a dax driver
> being bound to the device. It's the same as what things like
> align_store(), size_store() etc. do for dax device reconfiguration.

Sorry, I misunderstood it.

> That said, it might be okay to remove this check, as this operation
> doesn't change any attributes of the dax region (the other interfaces I
> mentioned above can affect regions, so we want to lock the region
> device). If removing the check, we'd drop the region lock acquisition
> as well.

This sounds good to me.

And is it necessary to check driver type with device_lock()?  Can driver
be changed between checking and lock?

--
Best Regards,
Huang, Ying
