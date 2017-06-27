Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk0-x22b.google.com (mail-qk0-x22b.google.com
 [IPv6:2607:f8b0:400d:c09::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F0BE21C943CA
 for <linux-nvdimm@lists.01.org>; Tue, 27 Jun 2017 07:03:58 -0700 (PDT)
Received: by mail-qk0-x22b.google.com with SMTP id r62so25781836qkf.0
 for <linux-nvdimm@lists.01.org>; Tue, 27 Jun 2017 07:05:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170627104328.GD30002@leverpostej>
References: <20170627102851.15484-1-oohall@gmail.com>
 <20170627102851.15484-2-oohall@gmail.com>
 <20170627104328.GD30002@leverpostej>
From: Oliver <oohall@gmail.com>
Date: Wed, 28 Jun 2017 00:05:27 +1000
Message-ID: <CAOSf1CGxciDwRLKv5JkessO_AGAKR4jKiY5+=3z4dptQHPssxw@mail.gmail.com>
Subject: Re: [RFC 2/4] libnvdimm: Add a device-tree interface
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
To: Mark Rutland <mark.rutland@arm.com>
Cc: devicetree@vger.kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Mark,

Thanks for the review and sorry, I really should have added more
context. I was originally just going to send this to the linux-nvdimm
list, but I figured the wider device-tree community might be
interested too.

Preamble:

Non-volatile DIMMs (nvdimms) are otherwise normal DDR DIMMs that are
based on some kind of non-volatile memory with DRAM-like performance
(i.e. not flash). The best known example would probably be Intel's 3D
XPoint technology, but there are a few others around. The non-volatile
aspect makes them useful as storage devices and being part of the
memory space allows the backing storage to be exposed to userspace via
mmap() provided the kernel supports it. The mmap() trick is enabled by
the kernel supporting "direct access" aka DAX.

With that out of the way...

On Tue, Jun 27, 2017 at 8:43 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> Hi,
>
> On Tue, Jun 27, 2017 at 08:28:49PM +1000, Oliver O'Halloran wrote:
>> A fairly bare-bones set of device-tree bindings so libnvdimm can be used
>> on powerpc and other, less cool, device-tree based platforms.
>
> ;)
>
>> Cc: devicetree@vger.kernel.org
>> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
>> ---
>> The current bindings are essentially this:
>>
>> nonvolatile-memory {
>>       compatible = "nonvolatile-memory", "special-memory";
>>       ranges;
>>
>>       region@0 {
>>               compatible = "nvdimm,byte-addressable";
>>               reg = <0x0 0x1000>;
>>       };
>>
>>       region@1000 {
>>               compatible = "nvdimm,byte-addressable";
>>               reg = <0x1000 0x1000>;
>>       };
>> };
>
> This needs to have a proper binding document under
> Documentation/devicetree/bindings/. Something like the reserved-memory
> bdings would be a good template.
>
> If we want thet "nvdimm" vendor-prefix, that'll have to be reserved,
> too (see Documentation/devicetree/bindings/vendor-prefixes.txt).

It's on my TODO list, I just wanted to get some comments on the
overall approach before doing the rest of the grunt work.

>
> What is "special-memory"? What other memory types would be described
> here?
>
> What exacctly does "nvdimm,byte-addressable" imply? I suspect that you
> also expect such memory to be compatible with mappings using (some)
> cacheable attributes?

I think it's always been assumed that nvdimm memory can be treated as
cacheable system memory for all intents and purposes. It might be
useful to be able to override it on a per-bus or per-region basis
though.

>
> Perhaps the byte-addressable property should be a boolean property on
> the region, rather than part of the compatible string.
See below.

>> To handle interleave sets, etc the plan was the add an extra property with the
>> interleave stride and a "mapping" property with <&DIMM, dimm-start-offset>
>> tuples for each dimm in the interleave set. Block MMIO regions can be added
>> with a different compatible type, but I'm not too concerned with them for
>> now.
>
> Sorry, I'm not too familiar with nonvolatile memory. What are interleave
> sets?

An interleave set refers to a group of DIMMs which share a physical
address range. The addresses in the range are assigned to different
backing DIMMs to improve performance. E.g

Addr 0 to Addr 127 are on DIMM0, Addr 127 to 255 are on DIMM1, Addr
256 to 384 are on DIMM0, etc, etc

software needs to be aware of the interleave pattern so it can
localise memory errors to a specific DIMM.

>
> What are block MMIO regions?

NVDIMMs come in two flavours: byte addressable and block aperture. The
byte addressable type can be treated as conventional memory while the
block aperture type are essentially an MMIO block device. Their
contents are accessed via the MMIO window rather than being presented
to the system as RAM so they don't have any of the features that make
NVDIMMs interesting. It would be nice if we could punt them into a
different driver, unfortunately ACPI allows storage on one DIMM to be
partitioned into byte addressable and block regions and libnvdimm
provides the management interface for both. Dan Williams, who
maintains libnvdimm and the ACPI interface to it, would be a better
person to ask about the finer details.

>
> Is there any documentation one can refer to for any of this?

Documentation/nvdimm/nvdimm.txt has a fairly detailed overview of how
libnvdimm operates. The short version is that libnvdimm provides a
"nvdimm_bus" container for "regions" and "dimms." Regions are chunks
of memory and come in the block or byte types mentioned above, while
DIMMs refer to the physical devices. A firmware specific driver
converts the firmware's hardware description into a set of DIMMs, a
set of regions, and a set of relationships between the two.

On top of that, regions are partitioned into "namespaces" which are
then exported to userspace as either a block device (with PAGE_SIZE
blocks) or as a "DAX device." In the block device case a filesystem is
used to manage the storage and provided the filesystem supports FS_DAX
and is mounted with -o dax, mmap() calls will map the backing memory
directly rather than buffering IO in the page cache. DAX devices can
be mmap()ed to access the backing storage directly so all the
management issues can be punted to userspace.

>
> [...]
>
>> +static const struct of_device_id of_nvdimm_bus_match[] = {
>> +     { .compatible = "nonvolatile-memory" },
>> +     { .compatible = "special-memory" },
>> +     { },
>> +};
>
> Why both? Is the driver handling other "special-memory"?

This is one of the things I was hoping the community could help
decide. "nonvolatile-memory" is probably a more accurate description
of the for the current usage, but the functionality does have other
uses. The interface might be useful for exposing any kind memory with
special characteristics, like high-bandwidth memory or memory on a
coherent accelerator.

Thanks,
Oliver
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
