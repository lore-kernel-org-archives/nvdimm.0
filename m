Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1432216514.26714.4.camel@misato.fc.hp.com>
References: <20150520205536.32249.89779.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150520205621.32249.39424.stgit@dwillia2-desk3.amr.corp.intel.com>
	<1432216514.26714.4.camel@misato.fc.hp.com>
Date: Thu, 21 May 2015 08:56:46 -0700
Message-ID: <CAPcyv4ijJeBjX-vvMprDYwQx8PnPD3P5UJR2A-3wqNdd63p7Bg@mail.gmail.com>
Subject: Re: [PATCH v3 02/21] libnd, nfit: initial libnd infrastructure and
 NFIT support
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Robert Moore <robert.moore@intel.com>, Linux ACPI <linux-acpi@vger.kernel.org>, Lv Zheng <lv.zheng@intel.com>, Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 21, 2015 at 6:55 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> On Wed, 2015-05-20 at 16:56 -0400, Dan Williams wrote:
>  :
>> +/* NVDIMM - NFIT table */
>> +
>> +#define UUID_VOLATILE_MEMORY            "4f940573-dafd-e344-b16c-3f22d252e5d0"
>> +#define UUID_PERSISTENT_MEMORY          "79d3f066-f3b4-7440-ac43-0d3318b78cdb"
>> +#define UUID_CONTROL_REGION             "f601f792-b413-5d40-910b-299367e8234c"
>> +#define UUID_DATA_REGION                "3005af91-865d-0e47-a6b0-0a2db9408249"
>> +#define UUID_VOLATILE_VIRTUAL_DISK      "5a53ab77-fc45-4b62-5560-f7b281d1f96e"
>> +#define UUID_VOLATILE_VIRTUAL_CD        "30bd5a3d-7541-ce87-6d64-d2ade523c4bb"
>> +#define UUID_PERSISTENT_VIRTUAL_DISK    "c902ea5c-074d-69d3-269f-4496fbe096f9"
>> +#define UUID_PERSISTENT_VIRTUAL_CD      "88810108-cd42-48bb-100f-5387d53ded3d"
>
> acpi_str_to_uuid() performs little-endian byte-swapping, so the UUID
> strings here need to be actual values.
>
> For instance, UUID_PERSISTENT_MEMORY should be:
> #define UUID_PERSISTENT_MEMORY   "66f0d379-b4f3-4074-ac43-0d3318b78cdb"
>

No, the spec defines the GUID for persistent memory as:

{ 0x66F0D379, 0xB4F3, 0x4074, 0xAC, 0x43, 0x0D, 0x33, 0x18, 0xB7, 0x8C, 0xDB }

The byte encoding for that GUID is the following (all fields stored
big endian: https://en.wikipedia.org/wiki/Globally_unique_identifier#Binary_encoding)

{ 0x66, 0xF0, 0xD3, 0x79, 0xB4, 0xF3, 0x40,0x74, 0xAC, 0x43, 0x0D,
0x33, 0x18, 0xB7, 0x8C, 0xDB }

The reverse ACPI string translation of a UUID buffer according to
"ACPI 6 - 19.6.136 ToUUID (Convert String to UUID Macro)"

{ dd, cc, bb, aa, ff, ee, hh, gg, ii, jj, kk, ll, mm, nn, oo, pp }

"aabbccdd-eeff-gghh-iijj-kkllmmnnoopp"

"79d3f066-f3b4-7440-ac43-0d3318b78cdb"

Indeed, v2 of this patchset got this wrong.  Thanks to the sharp eyes
of Bob Moore on the ACPICA team, he caught this discrepancy.  It seems
the ACPI spec uses the terms "GUID" and "UUID" interchangeably.
