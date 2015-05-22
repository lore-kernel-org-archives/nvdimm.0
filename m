Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1432308084.1428.6.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 02/21] libnd, nfit: initial libnd infrastructure and
 NFIT support
From: Toshi Kani <toshi.kani@hp.com>
Date: Fri, 22 May 2015 09:21:24 -0600
In-Reply-To: <94F2FBAB4432B54E8AACC7DFDE6C92E37D2EED26@ORSMSX112.amr.corp.intel.com>
References: <20150520205536.32249.89779.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20150520205621.32249.39424.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <1432216514.26714.4.camel@misato.fc.hp.com>
	 <CAPcyv4ijJeBjX-vvMprDYwQx8PnPD3P5UJR2A-3wqNdd63p7Bg@mail.gmail.com>
	 <1432229114.28126.25.camel@misato.fc.hp.com>
	 <94F2FBAB4432B54E8AACC7DFDE6C92E37D2EE7C0@ORSMSX112.amr.corp.intel.com>
	 <1432231297.28704.8.camel@misato.fc.hp.com>
	 <CAPcyv4gjh_2Uy=gLN793=PTWh4X5e=A6tbtVTvaeLxEoHjxw0w@mail.gmail.com>
	 <1432237458.29840.17.camel@misato.fc.hp.com>
	 <1432238358.29840.25.camel@misato.fc.hp.com>	<555E474B.2060306@hp.com>
	 <CAPcyv4jB7DmJ3msAcQmHJov0kiqcSdcz2R5UsSaN3kc3OLbUoA@mail.gmail.com>
	 <94F2FBAB4432B54E8AACC7DFDE6C92E37D2EED26@ORSMSX112.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: "Moore, Robert" <robert.moore@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, Linda Knippers <linda.knippers@hp.com>, Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, "Zheng, Lv" <lv.zheng@intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2015-05-22 at 14:58 +0000, Moore, Robert wrote:
> It looks to me that you are correct and I screwed up when I made those strings.
> The odd thing is that we had discussed this whole issue internally for a few days
>  -- then I went ahead and messed up the strings. I think my brain was going
> around in circles.

Yes, endianness is always fun... :-)

> Anyway, here is the latest info, please have a look:
> 
> 
> Below is the GUID for volatile memory region directly from the ACPI spec:
> 
> 
> { 0x7305944F, 0xFDDA, 0x44E3, 0xB1, 0x6C, 0x3F, 0x22, 0xD2, 0x52, 0xE5, 0xD0 }
> 
> Here is an example of ToUUID using a corrected version of the GUID string. Note that the ordering of the string is identical to the version in the ACPI spec:
> 
>       11:      Name (UUID, ToUUID ("7305944F-FDDA-44E3-B16C-3F22D252E5D0"))
> 
> 
> Here is the AML output of the ToUUID macro. Note that the first three fields are reversed, the rest of the string is left as-is (as per the ToUUID definition):
> 
> 00000024:  08 55 55 49 44 .........    ".UUID"
> 00000029:  11 13 0A 10 4F 94 05 73     "....O..s"
> 00000031:  DA FD E3 44 B1 6C 3F 22     "...D.l?""
> 00000039:  D2 52 E5 D0 ............    ".R.."
> 
> This is the important part:
> 
>            4F 94 05 73     "....O..s"
> 00000031:  DA FD E3 44 B1 6C 3F 22     "...D.l?""
> 00000039:  D2 52 E5 D0
> 
> 
> I believe that this is correct.

Looks good!

Thanks,
-Toshi


