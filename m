Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM03-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam03on072a.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe48::72a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 78D54820F6
 for <linux-nvdimm@lists.01.org>; Thu, 16 Feb 2017 14:40:26 -0800 (PST)
Subject: Re: [PATCH 1/3] Allow all supported HPE DSM functions to be called
References: <cover.1486750246.git.linda.knippers@hpe.com>
 <5d86cd3620ca9eb3cda38cce0401b2984526cad7.1486750247.git.linda.knippers@hpe.com>
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
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <fbc7faf0-e759-0db3-edfe-c32ec453e696@hpe.com>
Date: Thu, 16 Feb 2017 17:40:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jdDrZzzVx5+uSb2tHg4MvqWeyzMXunq3F3L6dzYaBOyw@mail.gmail.com>
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



On 2/16/2017 4:07 PM, Dan Williams wrote:
> On Thu, Feb 16, 2017 at 12:48 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> On Thu, Feb 16, 2017 at 12:13 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
> [..]
>>> I am fairly certain that for production use we wouldn't expect management
>>> tools to use more than one DSM family at a time. Tools using DSMs
>>> from one family wouldn't switch to using a new family for one operation
>>> and then switch back for another operation.
>>
>> If the kernel makes it safe I don't see why this is a blocker,
>> especially if the goal is to reduce interface proliferation over time.
>
> In fact, we can make it even simpler than dynamically changing family,
> just have ND_IOCTL_VENDOR always route to uuid
> ""4309ac30-0d11-11e4-9191-0800200c9a66" and function number 9. Then
> that becomes the de facto method for Linux to issue a vendor-specific
> command for any DIMM.

Several problems.
That family is documented for RFIC 0x0201.
No NVDIMM-N platform supports that DSM family.
When platforms do support 0x0201, some will also support NVDIMM-N.  Since 
opcodes are not documented, how do would they not step on each other?

I don't think that works at all.

-- ljk


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
