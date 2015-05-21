Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1432231297.28704.8.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 02/21] libnd, nfit: initial libnd infrastructure and
 NFIT support
From: Toshi Kani <toshi.kani@hp.com>
Date: Thu, 21 May 2015 12:01:37 -0600
In-Reply-To: <94F2FBAB4432B54E8AACC7DFDE6C92E37D2EE7C0@ORSMSX112.amr.corp.intel.com>
References: <20150520205536.32249.89779.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20150520205621.32249.39424.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <1432216514.26714.4.camel@misato.fc.hp.com>
	 <CAPcyv4ijJeBjX-vvMprDYwQx8PnPD3P5UJR2A-3wqNdd63p7Bg@mail.gmail.com>
	 <1432229114.28126.25.camel@misato.fc.hp.com>
	 <94F2FBAB4432B54E8AACC7DFDE6C92E37D2EE7C0@ORSMSX112.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: "Moore, Robert" <robert.moore@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "Zheng, Lv" <lv.zheng@intel.com>, Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2015-05-21 at 17:49 +0000, Moore, Robert wrote:
> What ACPICA has done here is to define these values consistently with the ToUUID ASL macro:
> 
> 
> Byte encoding of UUID/GUID strings into ACPI Buffer objects (use ToUUID from ASL):
> 
>    Input UUID/GUID String format : aabbccdd-eeff-gghh-iijj-kkllmmnnoopp
>      Expected output ACPI buffer : dd,cc,bb,aa, ff,ee, hh,gg, ii,jj, kk,ll,mm,nn,oo,pp
> 

I do not see any issue in this conversion, which is consistent with
ToUUID defined in ACPI spec.

My point is that the string format of GUID is endian-neutral.  Wiki
pages and EFI spec agree on it.  EFI 2.5 spec, Table 225 (sorry not
Table 212, which is v2.4), is also clear about how String and Buffer are
related with actual values of GUID.

Thanks,
-Toshi


> 
> 
> > -----Original Message-----
> > From: Toshi Kani [mailto:toshi.kani@hp.com]
> > Sent: Thursday, May 21, 2015 10:25 AM
> > To: Williams, Dan J
> > Cc: Jens Axboe; linux-nvdimm@lists.01.org; Neil Brown; Greg KH; Wysocki,
> > Rafael J; linux-kernel@vger.kernel.org; Moore, Robert; Linux ACPI; Zheng,
> > Lv; Christoph Hellwig; Ingo Molnar
> > Subject: Re: [PATCH v3 02/21] libnd, nfit: initial libnd infrastructure
> > and NFIT support
> > 
> > On Thu, 2015-05-21 at 08:56 -0700, Dan Williams wrote:
> > > On Thu, May 21, 2015 at 6:55 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> > > > On Wed, 2015-05-20 at 16:56 -0400, Dan Williams wrote:
> > > >  :
> > > >> +/* NVDIMM - NFIT table */
> > > >> +
> > > >> +#define UUID_VOLATILE_MEMORY            "4f940573-dafd-e344-b16c-
> > 3f22d252e5d0"
> > > >> +#define UUID_PERSISTENT_MEMORY          "79d3f066-f3b4-7440-ac43-
> > 0d3318b78cdb"
> > > >> +#define UUID_CONTROL_REGION             "f601f792-b413-5d40-910b-
> > 299367e8234c"
> > > >> +#define UUID_DATA_REGION                "3005af91-865d-0e47-a6b0-
> > 0a2db9408249"
> > > >> +#define UUID_VOLATILE_VIRTUAL_DISK      "5a53ab77-fc45-4b62-5560-
> > f7b281d1f96e"
> > > >> +#define UUID_VOLATILE_VIRTUAL_CD        "30bd5a3d-7541-ce87-6d64-
> > d2ade523c4bb"
> > > >> +#define UUID_PERSISTENT_VIRTUAL_DISK    "c902ea5c-074d-69d3-269f-
> > 4496fbe096f9"
> > > >> +#define UUID_PERSISTENT_VIRTUAL_CD      "88810108-cd42-48bb-100f-
> > 5387d53ded3d"
> > > >
> > > > acpi_str_to_uuid() performs little-endian byte-swapping, so the UUID
> > > > strings here need to be actual values.
> > > >
> > > > For instance, UUID_PERSISTENT_MEMORY should be:
> > > > #define UUID_PERSISTENT_MEMORY   "66f0d379-b4f3-4074-ac43-
> > 0d3318b78cdb"
> > > >
> > >
> > > No, the spec defines the GUID for persistent memory as:
> > >
> > > { 0x66F0D379, 0xB4F3, 0x4074, 0xAC, 0x43, 0x0D, 0x33, 0x18, 0xB7,
> > > 0x8C, 0xDB }
> > >
> > > The byte encoding for that GUID is the following (all fields stored
> > > big endian:
> > > https://en.wikipedia.org/wiki/Globally_unique_identifier#Binary_encodi
> > > ng)
> > >
> > > { 0x66, 0xF0, 0xD3, 0x79, 0xB4, 0xF3, 0x40,0x74, 0xAC, 0x43, 0x0D,
> > > 0x33, 0x18, 0xB7, 0x8C, 0xDB }
> > >
> > > The reverse ACPI string translation of a UUID buffer according to
> > > "ACPI 6 - 19.6.136 ToUUID (Convert String to UUID Macro)"
> > >
> > > { dd, cc, bb, aa, ff, ee, hh, gg, ii, jj, kk, ll, mm, nn, oo, pp }
> > >
> > > "aabbccdd-eeff-gghh-iijj-kkllmmnnoopp"
> > >
> > > "79d3f066-f3b4-7440-ac43-0d3318b78cdb"
> > >
> > > Indeed, v2 of this patchset got this wrong.  Thanks to the sharp eyes
> > > of Bob Moore on the ACPICA team, he caught this discrepancy.  It seems
> > > the ACPI spec uses the terms "GUID" and "UUID" interchangeably.
> > 
> > I agree that this thing is confusing...
> > 
> > The Wiki page you pointed states that:
> > ===
> > Byte encoding
> >  :
> > This endianness applies only to the way in which a GUID is stored, and not
> > to the way in which it is represented in text. GUIDs and RFC 4122 UUIDs
> > should be identical when displayed textually.
> > 
> > Text encoding
> >  :
> > For the first three fields, the most significant digit is on the left.
> > ===
> > 
> > Wiki page of UUID below also states that:
> > http://en.wikipedia.org/wiki/Universally_unique_identifier
> > ===
> > Definition
> >  :
> > The first 3 sequences are interpreted as complete hexadecimal numbers,
> > while the final 2 as a plain sequence of bytes. The byte order is "most
> > significant byte first (known as network byte order) ===
> > 
> > So, the text encoding of GUID represents actual value; no endianness
> > applies here.  So, the following GUID definition:
> > 
> > { 0x66F0D379, 0xB4F3, 0x4074, 0xAC, 0x43, 0x0D, 0x33, 0x18, 0xB7, 0x8C,
> > 0xDB }
> > 
> > Should be text encoded as:
> > 
> > "66f0d379-b4f3-4074-ac43-0d3318b78cdb"
> > 
> > Now, byte-encoding is confusing.  While the Wiki page you pointed states
> > that GUID has big endian per Microsoft definition, EFI spec defines
> > differently.  Please look at EFI 2.5 "Appendix A GUID and Time Formats".
> > 
> > The EFI spec states that:
> > ===
> > All EFI GUIDs (Globally Unique Identifiers) have the format described in
> > RFC 4122 and comply with the referenced algorithms for generating GUIDs.
> > It should be noted that TimeLow, TimeMid, TimeHighAndVersion fields in the
> > EFI are encoded as little endian.
> > ===
> > 
> > Table 212 defines how text representation of the GUID is stored in Buffer,
> > which is little endian format.  This table also states that the most
> > significant byte is the first in text encoding, which is consistent with
> > the Wiki pages.
> > 
> > The ACPI spec, ToUUID, is consistent with EFI spec Table 212 as well.
> > 
> > Thanks,
> > -Toshi
> 


