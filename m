Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2014B81DFB
 for <linux-nvdimm@lists.01.org>; Wed, 14 Dec 2016 22:47:02 -0800 (PST)
Received: by mail-oi0-x235.google.com with SMTP id w63so42277218oiw.0
 for <linux-nvdimm@lists.01.org>; Wed, 14 Dec 2016 22:47:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4g8-J31Pk_Z8dOg_DRbvu6b7_Y9MhcWuqhNMgxhcodp7A@mail.gmail.com>
References: <148143770485.10950.13227732273892953675.stgit@dwillia2-desk3.amr.corp.intel.com>
 <148143771052.10950.7622110904173815243.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20161214143802.GD6279@linux-x5ow.site>
 <CAPcyv4g8-J31Pk_Z8dOg_DRbvu6b7_Y9MhcWuqhNMgxhcodp7A@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Dec 2016 22:47:00 -0800
Message-ID: <CAPcyv4juk+M7b3yKuE_9VEjYsfsR-Z8o2Pobu2ZY8mOAUptYNQ@mail.gmail.com>
Subject: Re: [PATCH 1/8] dax: add region-available-size attribute
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 14, 2016 at 7:53 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Wed, Dec 14, 2016 at 6:38 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
>> Hi Dan,
>>
>> On Sat, Dec 10, 2016 at 10:28:30PM -0800, Dan Williams wrote:
>>> In preparation for a facility that enables dax regions to be
>>> sub-divided, introduce a 'dax/available_size' attribute.  This attribute
>>> appears under the parent device that registered the device-dax region,
>>> and it assumes that the device-dax-core owns the driver-data for that
>>> device.
>>>
>>> 'dax/available_size' adjusts dynamically as dax-device instances are
>>> registered and unregistered.
>>>
>>> As a side effect of using __request_region() to reserve capacity from
>>> the dax_region we now track pointers to those returned resources rather
>>> than duplicating the passed in resource array.
>>>
>>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>>> ---
>>
>> [...]
>>
>>> +static const struct attribute_group *dax_region_attribute_groups[] = {
>>> +     &dax_region_attribute_group,
>>> +     NULL,
>>>  };
>>>
>>>  static struct inode *dax_alloc_inode(struct super_block *sb)
>>> @@ -200,12 +251,27 @@ void dax_region_put(struct dax_region *dax_region)
>>>  }
>>>  EXPORT_SYMBOL_GPL(dax_region_put);
>>>
>>> +
>>
>> Stray extra newline?
>>
>> [...]
>>
>>>  struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>>>               struct resource *res, unsigned int align, void *addr,
>>>               unsigned long pfn_flags)
>>>  {
>>>       struct dax_region *dax_region;
>>>
>>> +     if (dev_get_drvdata(parent)) {
>>> +             dev_WARN(parent, "dax core found drvdata already in use\n");
>>> +             return NULL;
>>> +     }
>>> +
>>
>> My first thought was, it might be interesting to see who already claimed
>> the drvdata. Then I figured, how are multiple sub-regions of a dax-device
>> supposed to work? What am I missing here?
>
> This is a check similar to the -EBUSY return you would get from
> request_mem_region(). In fact if all dax drivers are correctly calling
> request_mem_region() before alloc_dax_region() then it would be
> impossible for this check to ever fire. It's already impossible
> because there's only one dax driver upstream (dax_pmem). It's not
> really benefiting the kernel at all until we have multiple dax
> drivers, I'll remove it.

No, I went to go delete this and remembered the real reason this was
added. A device driver that calls alloc_dax_region() commits to
letting the dax core own dev->driver_data. Since this wasn't even
clear to me, I'll go fix up the comment.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
