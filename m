Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EC81F81EB2
 for <linux-nvdimm@lists.01.org>; Thu, 15 Dec 2016 18:43:52 -0800 (PST)
Received: by mail-oi0-x22d.google.com with SMTP id v84so65193031oie.3
 for <linux-nvdimm@lists.01.org>; Thu, 15 Dec 2016 18:43:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <DF4PR84MB0169815E607E12A0B343B9FDAB9C0@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
References: <148158809239.159590.16102609849408268953.stgit@djiang5-desk3.ch.intel.com>
 <DF4PR84MB0169815E607E12A0B343B9FDAB9C0@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Dec 2016 18:43:51 -0800
Message-ID: <CAPcyv4he+6hu6PFiAtdkvjfPo4GB9tnMqYr7uPSpkkqj2kz6hA@mail.gmail.com>
Subject: Re: [PATCH 1/3] dev-dax: add support to display badblocks in sysfs
 for dev-dax
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
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 15, 2016 at 5:52 PM, Elliott, Robert (Persistent Memory)
<elliott@hpe.com> wrote:
>> -----Original Message-----
>> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On
>> Behalf Of Dave Jiang
>> Sent: Monday, December 12, 2016 6:15 PM
>> Subject: [PATCH 1/3] dev-dax: add support to display badblocks in
>> sysfs for dev-dax
>>
>> Adding support to show badblocks in the pmem region that's provided
>> by the poison_list. This should show up in
>> /sys/class/dax/daxN.N/badblocks as read only. Currently we only
>> support
>> a single resource and we do not support badblocks for seeds.
>> Additional
>> support code will be implemented to support.
>>
> ...
>> diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
> ...
>> +static ssize_t dax_pmem_badblocks_show(struct device *dev,
>> +struct device_attribute *attr, char *page)
>> +{
>> +struct dax_pmem *dax_pmem =
>> +(struct dax_pmem *)dax_dev_get_private(dev);
>> +
>> +return badblocks_show(&dax_pmem->bb, page, 0);
>> +}
>
> Do /dev/dax devices have a "block size" to explain the units used in
> the sysfs files?  If so, where is it reported?

The "badblocks" sysfs interface is always in 512 byte logical units.
If badblocks ever grew support for other block sizes we would add it
as an attribute of the badblocks interface directly and not rely on
traversing other parts of the sysfs topology.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
