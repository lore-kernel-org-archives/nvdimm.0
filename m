Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-BY2-obe.outbound.protection.outlook.com
 (mail-by2nam01on071c.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe42::71c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 47698820F6
 for <linux-nvdimm@lists.01.org>; Thu, 16 Feb 2017 14:52:36 -0800 (PST)
Subject: Re: [PATCH 1/3] Allow all supported HPE DSM functions to be called
References: <cover.1486750246.git.linda.knippers@hpe.com>
 <CAPcyv4gRNeuQFwDtwGzBbs+CKZnkYibCMm0UXCD2ZWyOZN0GJg@mail.gmail.com>
 <58A1F84A.2090605@hpe.com>
 <CAPcyv4iW8Kwvm9dFgM7se6kQ7ZOXqX89hz7=FhOrpAbcCEcgAQ@mail.gmail.com>
 <58A4E20F.8040302@hpe.com>
 <CAPcyv4iog-kV3-Bu2KYzC7hxkAO82mbUfY-nyYdEXReJC8nioQ@mail.gmail.com>
 <58A4F63D.70908@hpe.com>
 <CAPcyv4i8GSU13GZBta+YH0NfVcDztLy2SjfNJmtdpjs+7igULQ@mail.gmail.com>
 <56cd91c8-a5d8-7339-2ff2-f2e706691c8b@hpe.com>
 <CAPcyv4ggMwddnkHxAkLkSHLpM6h6t3zJQ3mr2P4t+6xPZx0dxw@mail.gmail.com>
 <58A607F2.6030904@hpe.com>
 <CAPcyv4gpmz-1E23pHdoy49k+CWXBb-m-7PRbBOb18xTgyhcbUw@mail.gmail.com>
 <CAPcyv4jdDrZzzVx5+uSb2tHg4MvqWeyzMXunq3F3L6dzYaBOyw@mail.gmail.com>
 <fbc7faf0-e759-0db3-edfe-c32ec453e696@hpe.com>
 <CAPcyv4j=vmjNgY8rzWTnWpyp3TFk5YbDeHupX99SMZQb-gi=EQ@mail.gmail.com>
 <9d96b4d3-0571-c859-92e8-8e013206a301@hpe.com>
 <CAPcyv4gL3GCT6YnfOWpRG23vvmkf+ctZKXeXqGKrsJucKCxKqA@mail.gmail.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <8cfa36e1-2bdd-3e8a-1124-e210db2d7eb8@hpe.com>
Date: Thu, 16 Feb 2017 17:52:29 -0500
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gL3GCT6YnfOWpRG23vvmkf+ctZKXeXqGKrsJucKCxKqA@mail.gmail.com>
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



On 2/16/2017 5:49 PM, Dan Williams wrote:
> On Thu, Feb 16, 2017 at 2:47 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
>>>> Several problems.
>>>> That family is documented for RFIC 0x0201.
>>>> No NVDIMM-N platform supports that DSM family.
>>>> When platforms do support 0x0201, some will also support NVDIMM-N.  Since
>>>> opcodes are not documented, how do would they not step on each other?
>>>>
>>>> I don't think that works at all.
>>>>
>>>
>>> I'm confused there is no correlation between FIC and DSM family,
>>
>>
>> Page 7 of version 1.3 of your DSM spec says:
>>
>> Platforms that have the _DSM interface implemented, as outlined in this
>> section, can support a NVDIMM region with Region Format Interface Code
>> (RFIC) of 0x0201.
>>
>> Other DSM documents reference RFIC 0x0101.
>>
>>> at least not one Linux enforces.
>>
>>
>> That is true, but FW developers aren't being as loose.
>
> Yes, they are. We have 3 0x101 DSM families.

And they're all implemented for 0x101 devices.

-- ljk
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
