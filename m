Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x229.google.com (mail-ot0-x229.google.com
 [IPv6:2607:f8b0:4003:c0f::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 00E0C2034D83C
 for <linux-nvdimm@lists.01.org>; Tue,  7 Nov 2017 07:31:53 -0800 (PST)
Received: by mail-ot0-x229.google.com with SMTP id c47so12344008otj.6
 for <linux-nvdimm@lists.01.org>; Tue, 07 Nov 2017 07:35:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AT5PR84MB008261397FEA00F43F7DCEC6AB510@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
References: <20171030204127.4779-1-Lijun.Pan@dell.com>
 <CAPcyv4gxRuMBb2cCnONg5Hq2PgzirHwOULjOfspOezkeBrmfGw@mail.gmail.com>
 <AT5PR84MB008261397FEA00F43F7DCEC6AB510@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 7 Nov 2017 07:35:51 -0800
Message-ID: <CAPcyv4h6ZVX-ViULt8Varbpa0vfN=3WVQd1uQ+fFAr9ZXo_E-Q@mail.gmail.com>
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
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: Lijun Pan <Lijun.Pan@dell.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 6, 2017 at 6:50 PM, Elliott, Robert (Persistent Memory)
<elliott@hpe.com> wrote:
>
>
>> -----Original Message-----
>> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On
>> Behalf Of Dan Williams
>> Sent: Monday, November 06, 2017 5:32 PM
>> To: Lijun Pan <Lijun.Pan@dell.com>
>> Cc: linux-nvdimm@lists.01.org
>> Subject: Re: [PATCH] acpi/nfit: export read_only attribute of dimms
>>
>> On Mon, Oct 30, 2017 at 1:41 PM, Lijun Pan <Lijun.Pan@dell.com>
>> wrote:
>> > Though flags attribute provides enough information about
>> > the dimm, it is nice to export the read_only attribute if
>> > bit3 of NVDIMM state flag is set.
>> > If error is injected by BIOS, bit3 and bit1 are both set.
>> > If DIMM is set to read-only by BIOS, bit3 is set.
>> > Hence bit3 is good enough to tell whether the dimm is in
>> > read-only mode or not.
>>
>> Hmm, can you say about more about why we need this additional
>> attribute?
>>
>> Applications don't read and write the DIMM directly, they only
>> interface with the DIMM through namespaces of a given region. The
>> region device already has a 'read_only' attribute. See
>> read_only_show() in drivers/nvdimm/region_devs.c.
>
> A few more points:
>
> 1. The full NVDIMM State Flags value is already reported for
> the nmem device, so reporting bit 3 separately as "read_only"
> would be redundant.
>
> 2. For NVDIMM-Ns, the system is not preventing writing to memory;
> system firmware is just warning that any writes will not be
> persistent across power loss.
>
> 3. Considering the different layers:
> * the pmem and btt drivers blocks writes themselves, so it makes
> sense for them to report ro at the pmem device layer.
> * the nmem layer doesn't block writes, so shouldn't report anything
> about them being restricted.
> * the region layer doesn't block writes, so shouldn't report anything
> about them being restricted.

The rationale for surfacing the read_only attribute at the region
level, even though the region does not directly host I/O, is that
regions host attributes that are common to all namespaces in that
region. I see regions as distinct from the nmem level where there is
not necessarily a direct correlation to namespaces, especially when
nmems are optional in the device hierarchy. Regions are also the
gateway interface for setting labels and aggregating state across
several DIMMs.

> * the region layer does need to pass along the NVDIMM state flags
> to the pmem and btt drivers; read_only might not be the best name
> as a user-visible attribute with that information.

The state flags are ACPI specific, so we need to translate to
something Linux generic when it moves to the libnvdimm sub-system.
Read-only when the energy source fails is a preventative measure, the
other state flags indicate that data has already been lost.

> Some driver or software might find temporarily writing to those
> locations in-place would be useful (e.g. run fsck before copying
> the repaired filesystem content to another storage device), so we
> shouldn't cut them off unnecessarily.

The read_only attribute can be overridden, i.e. it's only a default
value for safety.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
