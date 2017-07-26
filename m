Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0340B21D09182
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 13:19:40 -0700 (PDT)
Subject: Re: [ndctl PATCH] ndctl, create-namespace: fix size alignment
 validation
References: <150109896285.13943.15686058156974485950.stgit@dwillia2-desk3.amr.corp.intel.com>
 <9f1c0f31-7e74-3c1d-b88a-406db8f4c43f@hpe.com>
 <CAPcyv4hEGA2xaEGsht4v3HBTX=gXjwL-OHQppLVNfbpeUxK-qw@mail.gmail.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <aff2c352-3b6e-f33c-e616-c9d851602399@hpe.com>
Date: Wed, 26 Jul 2017 16:21:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hEGA2xaEGsht4v3HBTX=gXjwL-OHQppLVNfbpeUxK-qw@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 7/26/2017 4:19 PM, Dan Williams wrote:
>>> @@ -570,6 +569,12 @@ static int validate_namespace_options(struct
>>> ndctl_region *region,
>>>                 else if (units == SZ_1T)
>>>                         suffix = "T";
>>>
>>> +               /*
>>> +                * Make the recommendation in the units of the '--size'
>>> +                * option
>>> +                */
>>> +               size_align = max(units, size_align) * ways;
>>
>>
>> I can't test this because I don't have the system now but doesn't this
>> introduce the same problem, but only in the failure case?  I think I'll
>> get a different recommendation if I use a size of 1M vs. 1024K vs. just
>> bytes.
>> Or is that what you want?  You want the closest value in that unit rather
>> than
>> the closest value that would meet the requirements?
>
> Right, the former, i.e. the closest without changing units.

Since it's just a recommendation, sounds harmless and probably what
half the users will want.

Thanks,

-- ljk

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
