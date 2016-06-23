Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 11ED41A1DFA
 for <linux-nvdimm@lists.01.org>; Thu, 23 Jun 2016 11:10:55 -0700 (PDT)
Received: by mail-oi0-x236.google.com with SMTP id r2so82315717oih.2
 for <linux-nvdimm@lists.01.org>; Thu, 23 Jun 2016 11:10:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACTTzNY-sQYGGy-NhGP2hCUH2ynpDD-g74sJt4zY9c9RvGGFKw@mail.gmail.com>
References: <1466639694-25394-1-git-send-email-toshi.kani@hpe.com>
 <1466639694-25394-2-git-send-email-toshi.kani@hpe.com>
 <CACTTzNYAxtY-d8+8Vo=Y2WpuXVaSkJk9PC7DcHXKJuU=gqvXFw@mail.gmail.com>
 <1466702773.3504.363.camel@hpe.com>
 <CACTTzNY-sQYGGy-NhGP2hCUH2ynpDD-g74sJt4zY9c9RvGGFKw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 23 Jun 2016 11:10:21 -0700
Message-ID: <CAPcyv4g-VDXUt4_xbn3jPyYiet2gMJQT6=zXCOh9qx+qXyou0A@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] block: add QUEUE_FLAG_DAX for devices to advertise
 their DAX support
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
To: Yigal Korman <yigal@plexistor.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>, "agk@redhat.com" <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 23, 2016 at 11:05 AM, Yigal Korman <yigal@plexistor.com> wrote:
> On Thu, Jun 23, 2016 at 8:36 PM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
>> On Thu, 2016-06-23 at 19:31 +0300, Yigal Korman wrote:
>>> On Thu, Jun 23, 2016 at 2:54 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
>>> >
>>> >
>>> > Currently, presence of direct_access() in block_device_operations
>>> > indicates support of DAX on its block device.  Because
>>> > block_device_operations is instantiated with 'const', this DAX
>>> > capablity may not be enabled conditinally.
>>> >
>>> > In preparation for supporting DAX to device-mapper devices, add
>>> > QUEUE_FLAG_DAX to request_queue flags to advertise their DAX
>>> > support.  This will allow to set the DAX capability based on how
>>> > mapped device is composed.
>>>
>>> Hi Toshi,
>>> This patch is very helpful!
>>> I think QUEUE_FLAG_DAX can also help with identifying dax devices in
>>> userspace.
>>> Perhaps you'd be willing to squash the patch below with this one or
>>> add it to your submission?
>>
>> Hi Yigal,
>>
>> Good idea.  Mike can probably take it into his tree, but I will include it
>> into the series if I needed to submit v3.
>>
>> Acked-by: Toshi Kani <toshi.kani@hpe.com>
>
> Great, Thanks!
> I'll follow the thread to see if it goes through or needs to be resubmitted.
>
>>
>> I have one minor comment below.
>
> My reply below as well.
>
>>
>>> [PATCH] block: expose QUEUE_FLAG_DAX in sysfs
>>>
>>> There's currently no way to identify DAX enabled devices in userspace.
>>>
>>> Signed-off-by: Yigal Korman <yigal@plexistor.com>
>>> ---
>>>  block/blk-sysfs.c | 15 +++++++++++++++
>>>  1 file changed, 15 insertions(+)
>>>
>>> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
>>> index 9920596..d55126d 100644
>>> --- a/block/blk-sysfs.c
>>> +++ b/block/blk-sysfs.c
>>> @@ -379,6 +379,15 @@ static ssize_t queue_wc_store(struct
>>> request_queue *q, const char *page,
>>>         return count;
>>>  }
>>>
>>> +static ssize_t queue_dax_show(struct request_queue *q, char *page)
>>> +{
>>> +       int bit;
>>> +
>>> +       bit = test_bit(QUEUE_FLAG_DAX, &q->queue_flags);
>>> +
>>> +       return queue_var_show(bit, page);
>>
>> This can be:
>>         return queue_var_show(blk_queue_dax(q), page);
>
> Oh, sure, of course you're right. thanks.
>
> Subject: [PATCH] block: expose QUEUE_FLAG_DAX in sysfs
>
> There's currently no way to identify DAX enabled devices in userspace.
>
> Signed-off-by: Yigal Korman <yigal@plexistor.com>
> Acked-by: Toshi Kani <toshi.kani@hpe.com>

Great!

Acked-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
