Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CB591202E5318
 for <linux-nvdimm@lists.01.org>; Tue, 12 Feb 2019 17:27:32 -0800 (PST)
Date: Wed, 13 Feb 2019 09:27:07 +0800
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: Re: [PATCH 1/2] libnvdimm, pfn: use size is enough
Message-ID: <20190213012707.GA4470@richard>
References: <20190122024810.4448-1-richardw.yang@linux.intel.com>
 <CAPcyv4hn2JKAaH2YX0Ywc0Qa-_kHGk9QaqnO+odzHFzchbZVzA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hn2JKAaH2YX0Ywc0Qa-_kHGk9QaqnO+odzHFzchbZVzA@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: Wei Yang <richardw.yang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <zwisler@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 22, 2019 at 05:28:39PM -0800, Dan Williams wrote:
>On Mon, Jan 21, 2019 at 6:49 PM Wei Yang <richardw.yang@linux.intel.com> wrote:
>>
>> When trying to see whether current nd_region intersects with others, we
>> have already calculated the *size* to be expanded to SECTION size.
>>
>> So just pass size is enough.
>>
>> Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
>> ---
>>  drivers/nvdimm/pfn_devs.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
>> index becf0bb481b3..5eca050b3660 100644
>> --- a/drivers/nvdimm/pfn_devs.c
>> +++ b/drivers/nvdimm/pfn_devs.c
>> @@ -686,7 +686,7 @@ static void trim_pfn_device(struct nd_pfn *nd_pfn, u32 *start_pad, u32 *end_trun
>>         if (region_intersects(start, size, IORESOURCE_SYSTEM_RAM,
>>                                 IORES_DESC_NONE) == REGION_MIXED
>>                         || !IS_ALIGNED(end, nd_pfn->align)
>> -                       || nd_region_conflict(nd_region, start, size + adjust))
>> +                       || nd_region_conflict(nd_region, start, size))
>

Hi, Dan,

I got a question about the trim on start.

We check the alignment of nd_pfn->align on end, while we don't do this for
start. I lost why we would like to have this behavior.

Would we align start with nd_pfn->align too?

>Good catch, thanks. I fixed up the changelog a bit and applied this:
>
>    libnvdimm, pfn: Fix over-trim in trim_pfn_device()
>
>    When trying to see whether current nd_region intersects with others,
>    trim_pfn_device() has already calculated the *size* to be expanded to
>    SECTION size.
>
>    Do not double append 'adjust' to 'size' when calculating whether the end
>    of a region collides with the next pmem region.
>
>    Fixes: ae86cbfef381 "libnvdimm, pfn: Pad pfn namespaces relative
>to other regions"
>    Cc: <stable@vger.kernel.org>
>    Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
>    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

-- 
Wei Yang
Help you, Help me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
