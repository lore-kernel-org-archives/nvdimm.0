Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM03-DM3-obe.outbound.protection.outlook.com
 (mail-dm3nam03on071d.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe49::71d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A3D4D82020
 for <linux-nvdimm@lists.01.org>; Fri, 10 Feb 2017 06:28:40 -0800 (PST)
Subject: Re: How is a Region format interface codec used in NFIT/PEME/BLK/BTT
 driver?
References: <2062963119.1995548.1486669514254.ref@mail.yahoo.com>
 <2062963119.1995548.1486669514254@mail.yahoo.com>
 <CAPcyv4h37bX0yE8Ns921HLT0CJcW28EOf3hVVVtwwZHickgiQw@mail.gmail.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <143e298a-560c-c90a-7094-b4b1a09c5b1e@hpe.com>
Date: Fri, 10 Feb 2017 09:28:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAPcyv4h37bX0yE8Ns921HLT0CJcW28EOf3hVVVtwwZHickgiQw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Soccer Liu <soccer_liu@yahoo.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 2/9/2017 9:02 PM, Dan Williams wrote:
> On Thu, Feb 9, 2017 at 11:45 AM, Soccer Liu <soccer_liu@yahoo.com> wrote:
>> Hi:
>>
>>   I am trying to figure out what changes might be needed in the NVDIMM driver set for adding a new  Region format interface code.
>> After some researching, I found the following constants were defined in the NFIT header file but never really got referenced in the driver code. (It's used in the test code)
>> 64 #define NFIT_FIC_BYTE cpu_to_le16(0x101) /* byte-addressable energy backed */
>>  65 #define NFIT_FIC_BLK cpu_to_le16(0x201) /* block-addressable non-energy backed */
>>  66 #define NFIT_FIC_BYTEN cpu_to_le16(0x301) /* byte-addressable non-energy backed */
>>
>> Am I missing anything?
> 
> No, you're not missing anything. Linux simply doesn't care about the
> format interface code and instead relies on the "Address Range Type
> GUID" from the "System Physical Address (SPA) Range Structure" in the
> NFIT. In other words Linux does not differentiate support for 0x101
> and 0x301 because in both cases we end up with a "Byte Addressable
> Persistent Memory (PM) Region" in the NFIT. We also don't care about
> NFIT_FIC_BLK because that code is redundant with the definition of
> block windows in the NFIT.

I suppose we could care about FIC in the future if there is a device
that doesn't quite fit the current driver, perhaps requiring something
special with initialization or management or error handling, but it
would depend on what the new device is.

The FIC is exposed through /sys so a management tool might care.

-- ljk
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
