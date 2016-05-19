Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x229.google.com (mail-oi0-x229.google.com
 [IPv6:2607:f8b0:4003:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6E6FA1A1EDE
 for <linux-nvdimm@lists.01.org>; Thu, 19 May 2016 09:38:02 -0700 (PDT)
Received: by mail-oi0-x229.google.com with SMTP id k142so138126842oib.1
 for <linux-nvdimm@lists.01.org>; Thu, 19 May 2016 09:37:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jfNhEgoYASeyjjwfT_qoSGmbSvZ1L3e0LUMxL_N24JPQ@mail.gmail.com>
References: <CACTTzNZJyFZkGq-6sSTOzGBG3kc7E9c-Rp6Z8fdi9LRgExQPnQ@mail.gmail.com>
 <CAPcyv4ioeGGe3ujkpytzJKZHDVawX95KtrFEmBvO2oaB_j_RqA@mail.gmail.com>
 <CACTTzNbxsh-B4wbwwvf+3yC1JZECS-4S5speG7QDZuqKCXkP2w@mail.gmail.com>
 <CAPcyv4iMpEnQXjfjjfsZ2JNYTrRxSe5XLwtLiiWr1gD2YkEwbA@mail.gmail.com>
 <CACTTzNaGUsaN3ck9iG4axZqr83w9paVDBOJ+Was0Wv+fPZbOvA@mail.gmail.com>
 <CAPcyv4jfNhEgoYASeyjjwfT_qoSGmbSvZ1L3e0LUMxL_N24JPQ@mail.gmail.com>
Date: Thu, 19 May 2016 09:37:55 -0700
Message-ID: <CAPcyv4hJah+nNmWRLyvqf=3FPH9ByHeThwCTKPhOsp5Z4taQhw@mail.gmail.com>
Subject: Re: Legacy NVDIMM-F over EFI
From: Dan Williams <dan.j.williams@intel.com>
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
Cc: Toshi Kani <toshi.kani@hp.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 19, 2016 at 6:54 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Thu, May 19, 2016 at 12:28 AM, Yigal Korman <yigal@plexistor.com> wrote:
>> On Tue, May 17, 2016 at 7:33 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>>>
>>> On Tue, May 17, 2016 at 9:30 AM, Yigal Korman <yigal@plexistor.com> wrote:
>>> >
>>> > On May 17, 2016 6:57 PM, "Dan Williams" <dan.j.williams@intel.com> wrote:
>>> >>
>>> >> On Tue, May 17, 2016 at 8:36 AM, Yigal Korman <yigal@plexistor.com> wrote:
>>> >> > Hi all,
>>> >> > I've got a couple of legacy 'type 12' NVDIMM-F modules in our lab I've
>>> >> > been successfully testing.
>>> >> > Recently I moved them to a new system where EFI bootloader is used
>>> >> > (CentOS 7 installed with EFI) and  was surprised to see that they're
>>> >> > not identified as legacy 'type 12' persistent memory, are not caught
>>> >> > by the 'nd_pmem' driver and I don't get /dev/pmemX devices.
>>> >> > They show as 'type 7' in the E820 map and 'Persistent memory' in
>>> >> > /proc/iomem.
>>> >> > Is this the intended behavior? shouldn't they be identified as legacy
>>> >> > if they don't have NFIT?
>>> >>
>>> >> If the BIOS identifies it as type-7 it is broken, as far as Linux is
>>> >> concerned, if does not also export an NFIT with an ACPI0012 device.
>>> >> One would hope there are no new BIOS images being produced that use
>>> >> type-12...
>>> >
>>> > I'm not sure I understand, what was supposed to the right thing for the BIOS
>>> > to do? AFAIK there's no type-12 in EFI...
>>>
>>> The BIOS should mark the region as type-7, define an ACPI0012 device,
>>> and publish an NFIT table.
>>
>> You mean the EFI BIOS should identify the legacy NVDIMMs and create a
>> fake/default NFIT table to define them?
>
> Yes, there's really no such thing as legacy DIMMs, only pre-ACPI 6.x
> platforms.  If the ACPI implementation version is 6.x it should
> implement an NFIT for an NVDIMM.
>
>> Most of the latest servers I know of don't have support for NFIT in
>> them yet, and people still want to use NVDIMMs and EFI on them,
>> perhaps it would be better to have the kernel construct a default NFIT
>> table if one is not given?
>
> We have the "memmap=nn[KMG]!ss[KMG]" command line option, but I
> otherwise don't see a safe way for the kernel to automatically
> construct an NFIT.

As far as I can see it is a small amount of BIOS enabling, we need:

1/ an ACPI0012 device defined in the DSDT to trigger the NFIT driver to load

Device (NVDR) {
    Name (_HID, "ACPI0012" /* NVDIMM Root Device */)  // _HID: Hardware ID
}

2/ an NFIT with a single "System Physical Address Range" entry.  Here
is an example program that can generate such an NFIT:

https://github.com/pmem/ndctl/blob/master/builtin-create-nfit.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
