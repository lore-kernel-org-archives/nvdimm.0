Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22c.google.com (mail-ot0-x22c.google.com
 [IPv6:2607:f8b0:4003:c0f::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 335CC20355203
 for <linux-nvdimm@lists.01.org>; Tue,  7 Nov 2017 18:13:23 -0800 (PST)
Received: by mail-ot0-x22c.google.com with SMTP id u41so1071902otf.12
 for <linux-nvdimm@lists.01.org>; Tue, 07 Nov 2017 18:17:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5db8706279db4e57b937916e908a571d@AUSX13MPS325.AMER.DELL.COM>
References: <20171030204127.4779-1-Lijun.Pan@dell.com>
 <CAPcyv4gxRuMBb2cCnONg5Hq2PgzirHwOULjOfspOezkeBrmfGw@mail.gmail.com>
 <5db8706279db4e57b937916e908a571d@AUSX13MPS325.AMER.DELL.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 7 Nov 2017 18:17:21 -0800
Message-ID: <CAPcyv4jSvdWHxV65HtuXNHk+PWjAgS1VL3_wYNh4hM-QBginCQ@mail.gmail.com>
Subject: Re: [PATCH] acpi/nfit: export read_only attribute of dimms
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
To: Lijun Pan <Lijun.Pan@dell.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 7, 2017 at 5:18 PM,  <Lijun.Pan@dell.com> wrote:
>
>
>> -----Original Message-----
>> From: Dan Williams [mailto:dan.j.williams@intel.com]
>> Sent: Monday, November 6, 2017 5:32 PM
>> To: Pan, Lijun <Lijun_Pan@Dell.com>
>> Cc: linux-nvdimm@lists.01.org
>> Subject: Re: [PATCH] acpi/nfit: export read_only attribute of dimms
>>
>> On Mon, Oct 30, 2017 at 1:41 PM, Lijun Pan <Lijun.Pan@dell.com> wrote:
>> > Though flags attribute provides enough information about
>> > the dimm, it is nice to export the read_only attribute if
>> > bit3 of NVDIMM state flag is set.
>> > If error is injected by BIOS, bit3 and bit1 are both set.
>> > If DIMM is set to read-only by BIOS, bit3 is set.
>> > Hence bit3 is good enough to tell whether the dimm is in
>> > read-only mode or not.
>>
>> Hmm, can you say about more about why we need this additional attribute?
>>
>> Applications don't read and write the DIMM directly, they only
>> interface with the DIMM through namespaces of a given region. The
>> region device already has a 'read_only' attribute. See
>> read_only_show() in drivers/nvdimm/region_devs.c.
>
> redhat's cockpit can show the server's info like dimm, cpu, network,etc.
> If the read_only attribute is exported, it is easy for the program to check.
> I agree read_only status of the specific dimm can be retrieved via checking
> bit3 of nvdimm state flag, but it is not explicit.
> If 2 nvdimms are interleaved together, region's read_only only shows that
> the region is read only, it does not show the 2 underlying physical dimms comprising
> the region are read only.

Yes, however the DIMM itself is not "read only", that's a default
policy the kernel decides when it see the "not armed" status flag set.
If cockpit wants to show this state it can get it today from the DIMM
state flags emitted by 'ndctl list', see "flag_failed_arm".

# ndctl list -Dd nmem6
{
  "dev":"nmem6",
  "id":"cdab-0a-07e0-fffffeff",
  "handle":65536,
  "phys_id":0,
  "flag_failed_arm":true,
}
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
