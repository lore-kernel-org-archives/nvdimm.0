Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-vk0-x230.google.com (mail-vk0-x230.google.com
 [IPv6:2607:f8b0:400c:c05::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5BA911A1E21
 for <linux-nvdimm@lists.01.org>; Mon, 12 Sep 2016 23:01:15 -0700 (PDT)
Received: by mail-vk0-x230.google.com with SMTP id 16so144619010vko.2
 for <linux-nvdimm@lists.01.org>; Mon, 12 Sep 2016 23:01:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jcJTWBzfTO5tamm1YxXrjvCyytR2cL00cwLpzZcK-gHg@mail.gmail.com>
References: <CAC1QiQHNz7sgf=GcCmqLE-VQT4BxmD0M-XSaQqKL-ADqRt4pcg@mail.gmail.com>
 <CAPcyv4jcJTWBzfTO5tamm1YxXrjvCyytR2cL00cwLpzZcK-gHg@mail.gmail.com>
From: ryan chen <ryan.chan105@gmail.com>
Date: Tue, 13 Sep 2016 14:01:13 +0800
Message-ID: <CAC1QiQEQS0sXYPfRw-=GSOsChopQ60mF4YXnmQVv7BxbL5soHQ@mail.gmail.com>
Subject: Re: Panic when insmod nfit_test.ko
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 13, 2016 at 10:50 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Mon, Sep 12, 2016 at 7:30 PM, ryan chen <ryan.chan105@gmail.com> wrote:
>> Hi all,
>> Recently I'm trying to check the testing suite of nfit_test for nvdimm
>> on 4.8-rc5, and system got panic once insmod nfit_test.ko ,
>> I've checked the RIP, I guess it panics due to NULL
>> nvdimm_map pointer, i.e., accessing nvdimm_map->mem,
>> so I have a question that, should we check the return value of
>> alloc_nvdimm_map if it failed:
>>
>> --- a/drivers/nvdimm/core.c
>> +++ b/drivers/nvdimm/core.c
>> @@ -171,6 +171,9 @@ void *devm_nvdimm_memremap(struct device *dev,
>> resource_size_t offset,
>>                 kref_get(&nvdimm_map->kref);
>>         nvdimm_bus_unlock(dev);
>>
>> +       if (!nvdimm_map)
>> +               return NULL;
>> +
>>         if (devm_add_action_or_reset(dev, nvdimm_map_put, nvdimm_map))
>>                 return NULL;
>> But why we got NULL nvdimm_map is still unknown,
>> please let me know if you need any information. Thanks.
>
> Thanks for the report.  We do need to check if alloc_nvdimm_map fails.
> My guess as to why it is failing the call to request_mem_region().
> Can you try the attached patch, and send the kernel log as well as the
> contents of /proc/iomem?
OK, I've tried this patch, and there is no panic anymore, however the
request region offset
seems a little weird, it is not in the iomem space, not sure if I'm
doing the right testing.
please refer to attachment the kernel boot log , iomem address space
and the insmod nfit_test.ko message.
I'm testing like this:
modprobe dax
modprobe dax_pmem
modprobe libnvdimm
modprobe nd_blk
modprobe nd_btt
modprobe nd_e820
modprobe nd_pmem
modprobe nfit
insmod nfit_test_iomap.ko
insmod nfit_test.ko
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
