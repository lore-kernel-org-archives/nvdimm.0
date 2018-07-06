Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D8F59203B99D2
 for <linux-nvdimm@lists.01.org>; Thu,  5 Jul 2018 17:12:57 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id m2-v6so20225664oim.12
 for <linux-nvdimm@lists.01.org>; Thu, 05 Jul 2018 17:12:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hmEOJF-T9Ueqe5hcOqG11HS9RrE2ttkwqgsx2OasE5Ag@mail.gmail.com>
References: <20180705201726.512-1-keith.busch@intel.com>
 <CAPcyv4hmEOJF-T9Ueqe5hcOqG11HS9RrE2ttkwqgsx2OasE5Ag@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 5 Jul 2018 17:12:56 -0700
Message-ID: <CAPcyv4iCkXkO4bcT=vvgayRqCMd9HOF++mstSFnPnK55ZLhtLA@mail.gmail.com>
Subject: Re: [PATCHv2 1/2] libnvdimm: Use max contiguous area for namespace
 size
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
To: Keith Busch <keith.busch@intel.com>
Cc: stable <stable@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 5, 2018 at 2:13 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Thu, Jul 5, 2018 at 1:17 PM, Keith Busch <keith.busch@intel.com> wrote:
>> This patch will find the max contiguous area to determine the largest
>> namespace size that can be created. If the requested size exceeds the
>> largest available, ENOSPC error will be returned.
>>
>> This fixes the allocation underrun error and wrong error return code
>> that have otherwise been observed as the following kernel warning:
>>
>>   WARNING: CPU: <CPU> PID: <PID> at drivers/nvdimm/namespace_devs.c:913 size_store
>>
>> Fixes: a1f3e4d6a0c3 ("libnvdimm, region: update nd_region_available_dpa() for multi-pmem support")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Keith Busch <keith.busch@intel.com>
>> ---
>> v1 -> v2:
>>
>>   Updated changelog to indicate the warning this patch fixes and copy
>>   stable.
>>
>>   Fixed code comments with the correct name of a function
>
> Looks good to me, applied to my for-4.18/libnvdimm tracking branch.

I take it back, this is causing the libndctl unit test to fail. debugging...
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
