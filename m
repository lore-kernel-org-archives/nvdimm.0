Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <555E474B.2060306@hp.com>
References: <20150520205536.32249.89779.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150520205621.32249.39424.stgit@dwillia2-desk3.amr.corp.intel.com>
	<1432216514.26714.4.camel@misato.fc.hp.com>
	<CAPcyv4ijJeBjX-vvMprDYwQx8PnPD3P5UJR2A-3wqNdd63p7Bg@mail.gmail.com>
	<1432229114.28126.25.camel@misato.fc.hp.com>
	<94F2FBAB4432B54E8AACC7DFDE6C92E37D2EE7C0@ORSMSX112.amr.corp.intel.com>
	<1432231297.28704.8.camel@misato.fc.hp.com>
	<CAPcyv4gjh_2Uy=gLN793=PTWh4X5e=A6tbtVTvaeLxEoHjxw0w@mail.gmail.com>
	<1432237458.29840.17.camel@misato.fc.hp.com>
	<1432238358.29840.25.camel@misato.fc.hp.com>
	<555E474B.2060306@hp.com>
Date: Thu, 21 May 2015 14:34:50 -0700
Message-ID: <CAPcyv4jB7DmJ3msAcQmHJov0kiqcSdcz2R5UsSaN3kc3OLbUoA@mail.gmail.com>
Subject: Re: [PATCH v3 02/21] libnd, nfit: initial libnd infrastructure and
 NFIT support
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
To: Linda Knippers <linda.knippers@hp.com>
Cc: Toshi Kani <toshi.kani@hp.com>, Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "Moore, Robert" <robert.moore@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, "Zheng, Lv" <lv.zheng@intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 21, 2015 at 1:59 PM, Linda Knippers <linda.knippers@hp.com> wrote:
> On 05/21/2015 03:59 PM, Toshi Kani wrote:
>> On Thu, 2015-05-21 at 13:44 -0600, Toshi Kani wrote:
>>> On Thu, 2015-05-21 at 12:06 -0700, Dan Williams wrote:
>>>> On Thu, May 21, 2015 at 11:01 AM, Toshi Kani <toshi.kani@hp.com> wrote:
>>>>> On Thu, 2015-05-21 at 17:49 +0000, Moore, Robert wrote:
>>>>>> What ACPICA has done here is to define these values consistently with the ToUUID ASL macro:
>>>>>>
>>>>>>
>>>>>> Byte encoding of UUID/GUID strings into ACPI Buffer objects (use ToUUID from ASL):
>>>>>>
>>>>>>    Input UUID/GUID String format : aabbccdd-eeff-gghh-iijj-kkllmmnnoopp
>>>>>>      Expected output ACPI buffer : dd,cc,bb,aa, ff,ee, hh,gg, ii,jj, kk,ll,mm,nn,oo,pp
>>>>>>
>>>>>
>>>>> I do not see any issue in this conversion, which is consistent with
>>>>> ToUUID defined in ACPI spec.
>>>>>
>>>>> My point is that the string format of GUID is endian-neutral.  Wiki
>>>>> pages and EFI spec agree on it.  EFI 2.5 spec, Table 225 (sorry not
>>>>> Table 212, which is v2.4), is also clear about how String and Buffer are
>>>>> related with actual values of GUID.
>>>>
>>>> I think the critical point from the UEFI spec is the "It should also
>>>> be noted that TimeLow, TimeMid, TimeHighAndVersion fields in the EFI
>>>> are encoded as little endian".  That would imply the byte encoding
>>>> of...
>>>>
>>>> { 0x92F701F6, 0x13B4, 0x405D, 0x91, 0x0B, 0x29, 0x93, 0x67, 0xE8, 0x23, 0x4C }
>>>>
>>>> ...should be:
>>>>
>>>> { f6,01,f7,92,b4,13,5d,40,91,0b,29,93,67,e8,23,4c }
>>>
>>> The above NFIT GUID as data values means:
>>>
>>> EFI_GUID(0x92F701F6, 0x13B4, 0x405D, 0x91, 0x0B, 0x29, 0x93, 0x67, 0xE8,
>>> 0x23, 0x4C)
>>>
>>>> Which implies the text conversion should be:
>>>>
>>>> "92f701f6-13b4-405d-910b-299367e8234c"
>>>
>>> Nope.
>>
>> Oops! Sorry, I misread your email... The above string is correct,
>> although I do not think you need such conversion.
>>
>>> EFI 2.5 spec, Appendix A "GUID and Time Formats" defines that:
>>> (NOTE, I simplified the table 225 to fit in this email)
>>> ==
>>> This specification also defines a standard text representation of the
>>> GUID. This format is also sometimes called the “registry format”. It
>>> consists of 36 characters, as follows:
>>>
>>> aabbccdd-eeff-gghh-iijj-kkllmmnnoopp
>>>  :
>>>
>>> Table 225. Text representation relationships
>>> String       Offset In Buffer   EFI_GUID
>>> aa   3                  Data1[24:31]
>>> bb      2                  Data1[16:23]
>>> cc      1                  Data1[8:15]
>>> dd      0                  Data1[0:7]
>>>  :
>>> ===
>>>
>>> Therefore:
>>>
>>> aa = Data1[21:31] = 92
>>> bb = Data1[16:23] = F7
>>> cc = Data1[8:15]  = 01
>>> dd = Data1[0:7]   = F6
>>>
>>>> ...not
>>>>
>>>>> +#define UUID_CONTROL_REGION             "f601f792-b413-5d40-910b-299367e8234c"
>>>
>>> Hence, the above string is correct.
>>
>> Misread again... Right, the above string is NOT correct.
>>
>> I think we are on the same page that the GUID strings in this patch need
>> to be changed.
>>
>> { 0x92F701F6, 0x13B4, 0x405D, 0x91, 0x0B, 0x29, 0x93, 0x67, 0xE8, 0x23,
>> 0x4C }
>>
>> should be defined as:
>>
>> "92f701f6-13b4-405d-910b-299367e8234c"
>
> I've lost track of the right answer but should we be discussing
> it in the context of this patch too?
>
> http://www.spinics.net/lists/linux-acpi/msg57825.html
> [PATCH 18/19] ACPICA: ACPI 6.0: Add support for NFIT table.
>
> Dan's version of the file has lots of other UUIDs too, beyond NFIT.

Yeah, it's not clear whether those other GUIDs are actually GUIDs or
these byte-swapped "EFI GUID"s.  At least for NFIT it seems that the
intent was EFI GUID ordering due to the note about needing to match
the "Disk Type GUID" format from the EFI spec.

I circle back with the ACPICA folks.
