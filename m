Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EB6D721A0483B
 for <linux-nvdimm@lists.01.org>; Thu,  6 Apr 2017 10:53:07 -0700 (PDT)
Received: by mail-oi0-x232.google.com with SMTP id r203so60274033oib.3
 for <linux-nvdimm@lists.01.org>; Thu, 06 Apr 2017 10:53:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <58E67E11.9040700@hpe.com>
References: <20170406171738.844-1-lijunpan2000@gmail.com>
 <58E67E11.9040700@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 6 Apr 2017 10:53:06 -0700
Message-ID: <CAPcyv4jtwOGXH1kMsUM9jdiLxbUfgML3r4sRGxgU3KnNm1GNSg@mail.gmail.com>
Subject: Re: [PATCH v3] libndctl: add support for the MSFT family of DSM
 functions
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: Lijun Pan <Lijun.Pan@dell.com>, Stuart Hayes <Stuart.Hayes@dell.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 6, 2017 at 10:42 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
> On 04/06/2017 01:17 PM, Lijun Pan wrote:
>> From: Lijun Pan <Lijun.Pan@dell.com>
>>
>> This patch retrieves the health data from NVDIMM-N via
>> the MSFT _DSM function[1], following JESD245A[2] standards.
>> Now 'ndctl list --dimms --health --idle' could work
>> on MSFT type NVDIMM-N, but limited to health_state,
>> temperature_celsius, and life_used_percentage.
>>
>> Sample output of 'ndclt list --dimms --health --idle'
>
> typo here:  ndctl
>> {
>>   "dev":"nmem0",
>>   "id":"802c-0f-1711-1648dd20",
>>   "state":"disabled",
>>   "health":{
>>     "health_state":"ok",
>>     "temperature_celsius":27.000000,
>>     "life_used_percentage":3
>>   }
>> }
>>
>> [1]. https://msdn.microsoft.com/library/windows/hardware/mt604741
>> [2]. https://www.jedec.org/sites/default/files/docs/JESD245A.pdf
>>
>> Cc: Stuart Hayes <Stuart.Hayes@dell.com>
>> Signed-off-by: Lijun Pan <Lijun.Pan@dell.com>
>
> The temp looks right on my system too.
>
> Tested-by: Linda Knippers <linda.knippers@hpe.com>

Thanks! I'll fixup the typo on application.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
