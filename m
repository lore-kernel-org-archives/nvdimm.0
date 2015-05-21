Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1432231297.28704.8.camel@misato.fc.hp.com>
References: <20150520205536.32249.89779.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150520205621.32249.39424.stgit@dwillia2-desk3.amr.corp.intel.com>
	<1432216514.26714.4.camel@misato.fc.hp.com>
	<CAPcyv4ijJeBjX-vvMprDYwQx8PnPD3P5UJR2A-3wqNdd63p7Bg@mail.gmail.com>
	<1432229114.28126.25.camel@misato.fc.hp.com>
	<94F2FBAB4432B54E8AACC7DFDE6C92E37D2EE7C0@ORSMSX112.amr.corp.intel.com>
	<1432231297.28704.8.camel@misato.fc.hp.com>
Date: Thu, 21 May 2015 12:06:41 -0700
Message-ID: <CAPcyv4gjh_2Uy=gLN793=PTWh4X5e=A6tbtVTvaeLxEoHjxw0w@mail.gmail.com>
Subject: Re: [PATCH v3 02/21] libnd, nfit: initial libnd infrastructure and
 NFIT support
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>
Cc: "Moore, Robert" <robert.moore@intel.com>, Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "Zheng, Lv" <lv.zheng@intel.com>, Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 21, 2015 at 11:01 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> On Thu, 2015-05-21 at 17:49 +0000, Moore, Robert wrote:
>> What ACPICA has done here is to define these values consistently with the ToUUID ASL macro:
>>
>>
>> Byte encoding of UUID/GUID strings into ACPI Buffer objects (use ToUUID from ASL):
>>
>>    Input UUID/GUID String format : aabbccdd-eeff-gghh-iijj-kkllmmnnoopp
>>      Expected output ACPI buffer : dd,cc,bb,aa, ff,ee, hh,gg, ii,jj, kk,ll,mm,nn,oo,pp
>>
>
> I do not see any issue in this conversion, which is consistent with
> ToUUID defined in ACPI spec.
>
> My point is that the string format of GUID is endian-neutral.  Wiki
> pages and EFI spec agree on it.  EFI 2.5 spec, Table 225 (sorry not
> Table 212, which is v2.4), is also clear about how String and Buffer are
> related with actual values of GUID.

I think the critical point from the UEFI spec is the "It should also
be noted that TimeLow, TimeMid, TimeHighAndVersion fields in the EFI
are encoded as little endian".  That would imply the byte encoding
of...

{ 0x92F701F6, 0x13B4, 0x405D, 0x91, 0x0B, 0x29, 0x93, 0x67, 0xE8, 0x23, 0x4C }

...should be:

{ f6,01,f7,92,b4,13,5d,40,91,0b,29,93,67,e8,23,4c }

Which implies the text conversion should be:

"92f701f6-13b4-405d-910b-299367e8234c"

...not

> +#define UUID_CONTROL_REGION             "f601f792-b413-5d40-910b-299367e8234c"

I think ACPICA has the right order for a standard RFC 4122 id, but it
seems EFI is explicitly clarifying that the encoding is little endian
for the initial fields.  I think the EFI definition applies due to
this note in the NFIT section of the ACPI spec: "The Address Range
Type GUID values used in the ACPI NFIT must match the corresponding
values in the Disk Type GUID of the RAM Disk device path that describe
the same RAM Disk Type. Refer to the UEFI specification for details."

In hindsight it would have been nice if the NFIT spec had used an
unambiguous text encoding to define these values.
