Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1432246284.30864.17.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 02/21] libnd, nfit: initial libnd infrastructure and
 NFIT support
From: Toshi Kani <toshi.kani@hp.com>
Date: Thu, 21 May 2015 16:11:24 -0600
In-Reply-To: <CAPcyv4jB7DmJ3msAcQmHJov0kiqcSdcz2R5UsSaN3kc3OLbUoA@mail.gmail.com>
References: <20150520205536.32249.89779.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20150520205621.32249.39424.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <1432216514.26714.4.camel@misato.fc.hp.com>
	 <CAPcyv4ijJeBjX-vvMprDYwQx8PnPD3P5UJR2A-3wqNdd63p7Bg@mail.gmail.com>
	 <1432229114.28126.25.camel@misato.fc.hp.com>
	 <94F2FBAB4432B54E8AACC7DFDE6C92E37D2EE7C0@ORSMSX112.amr.corp.intel.com>
	 <1432231297.28704.8.camel@misato.fc.hp.com>
	 <CAPcyv4gjh_2Uy=gLN793=PTWh4X5e=A6tbtVTvaeLxEoHjxw0w@mail.gmail.com>
	 <1432237458.29840.17.camel@misato.fc.hp.com>
	 <1432238358.29840.25.camel@misato.fc.hp.com> <555E474B.2060306@hp.com>
	 <CAPcyv4jB7DmJ3msAcQmHJov0kiqcSdcz2R5UsSaN3kc3OLbUoA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linda Knippers <linda.knippers@hp.com>, Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "Moore, Robert" <robert.moore@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, "Zheng, Lv" <lv.zheng@intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2015-05-21 at 14:34 -0700, Dan Williams wrote:
> On Thu, May 21, 2015 at 1:59 PM, Linda Knippers <linda.knippers@hp.com> wrote:
> > On 05/21/2015 03:59 PM, Toshi Kani wrote:
:
> >
> > I've lost track of the right answer but should we be discussing
> > it in the context of this patch too?
> >
> > http://www.spinics.net/lists/linux-acpi/msg57825.html
> > [PATCH 18/19] ACPICA: ACPI 6.0: Add support for NFIT table.
> >
> > Dan's version of the file has lots of other UUIDs too, beyond NFIT.
> 
> Yeah, it's not clear whether those other GUIDs are actually GUIDs or
> these byte-swapped "EFI GUID"s.  At least for NFIT it seems that the
> intent was EFI GUID ordering due to the note about needing to match
> the "Disk Type GUID" format from the EFI spec.
> 
> I circle back with the ACPICA folks.

Endianness only matters when you store GUID data into memory (or read it
from memory).  The data values themselves are independent from the
endianness.  GUIDs, EFI GUIDs, and their text strings all represent
actual data values, and therefore no swapping is necessary.

When storing EFI GUID or text string into memory/Buffer, EFI spec
defines to store it in little-endian format.  This is handled by
EFI_GUID() macro for EFI GUID values, and ToUUID / acpi_str_to_uuid()
for a string.

Thanks,
-Toshi

