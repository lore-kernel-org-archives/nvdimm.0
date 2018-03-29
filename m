Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x230.google.com (mail-it0-x230.google.com
 [IPv6:2607:f8b0:4001:c0b::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 535F12210D9DF
 for <linux-nvdimm@lists.01.org>; Wed, 28 Mar 2018 20:04:03 -0700 (PDT)
Received: by mail-it0-x230.google.com with SMTP id r19-v6so6367495itc.0
 for <linux-nvdimm@lists.01.org>; Wed, 28 Mar 2018 20:10:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL_Jsq+jC2mAXbKh9c8dbLXZmWbD-sFemrk+8p-oGMkXqSMfnQ@mail.gmail.com>
References: <20180323081209.31387-1-oohall@gmail.com>
 <20180323081209.31387-6-oohall@gmail.com>
 <20180326222448.l7ukrslvccvrjnjf@rob-hp-laptop>
 <CAOSf1CFpFwzLMx0xmM+JmbQCiOA=QU_S5g0uf-qx181vJ_Xc1w@mail.gmail.com>
 <CAL_Jsq+jC2mAXbKh9c8dbLXZmWbD-sFemrk+8p-oGMkXqSMfnQ@mail.gmail.com>
From: Oliver <oohall@gmail.com>
Date: Thu, 29 Mar 2018 14:10:40 +1100
Message-ID: <CAOSf1CH6qUrj4SuTsYzYJCjaOecPzrwYkwCe6fL90Ot6Yto0GQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] doc/devicetree: NVDIMM region documentation
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
To: Rob Herring <robh@kernel.org>
Cc: Device Tree <devicetree@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 29, 2018 at 4:06 AM, Rob Herring <robh@kernel.org> wrote:
> On Tue, Mar 27, 2018 at 9:53 AM, Oliver <oohall@gmail.com> wrote:
>> On Tue, Mar 27, 2018 at 9:24 AM, Rob Herring <robh@kernel.org> wrote:
>>> On Fri, Mar 23, 2018 at 07:12:09PM +1100, Oliver O'Halloran wrote:
>>>> Add device-tree binding documentation for the nvdimm region driver.
>>>>
>>>> Cc: devicetree@vger.kernel.org
>>>> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
>>>> ---
>>>>  .../devicetree/bindings/nvdimm/nvdimm-region.txt   | 45 ++++++++++++++++++++++
>>>>  1 file changed, 45 insertions(+)
>>>>  create mode 100644 Documentation/devicetree/bindings/nvdimm/nvdimm-region.txt
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/nvdimm/nvdimm-region.txt b/Documentation/devicetree/bindings/nvdimm/nvdimm-region.txt
>>>> new file mode 100644
>>>> index 000000000000..02091117ff16
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/nvdimm/nvdimm-region.txt
>>>> @@ -0,0 +1,45 @@
>>>> +Device-tree bindings for NVDIMM memory regions
>>>> +-----------------------------------------------------
>>>> +
>>>> +Non-volatile DIMMs are memory modules used to provide (cacheable) main memory
>>>
>>> Are DIMMs always going to be the only form factor for NV memory?
>>>
>>> And if you have multiple DIMMs, does each DT node correspond to a DIMM?
>>
>> A nvdimm-region might correspond to a single NVDIMM, a set of
>> interleaved NVDIMMs, or it might just be a chunk of normal memory that
>> you want treated as a NVDIMM for some reason. The last case is useful
>> for provisioning install media on servers since it allows you do
>> download a DVD image, turn it into an nvdimm-region, and kexec into
>> the installer which can use it as a root disk. That may seem a little
>> esoteric, but it's handy and we're using a full linux environment for
>> our boot loader so it's easy to make use of.
>
> I'm really just asking if we should drop the "dimm" name because it is
> not always a DIMM. Maybe pmem instead? I don't know, naming is
> hard(TM).

pmem is probably a better name. I'll fix that up.

>>> If not, then what if we want/need to provide power control to a DIMM?
>>
>> That would require a DIMM (and probably memory controller) specific
>> driver. I've deliberately left out how regions are mapped back to
>> DIMMs from the binding since it's not really clear to me how that
>> should work. A phandle array pointing to each DIMM device (which could
>> be anything) would do the trick, but I've found that a bit awkward to
>> plumb into the model that libnvdimm expects.
>>
>>>> +that retains its contents across power cycles. In more practical terms, they
>>>> +are kind of storage device where the contents can be accessed by the CPU
>>>> +directly, rather than indirectly via a storage controller or similar. The an
>>>> +nvdimm-region specifies a physical address range that is hosted on an NVDIMM
>>>> +device.
>>>> +
>>>> +Bindings for the region nodes:
>>>> +-----------------------------
>>>> +
>>>> +Required properties:
>>>> +     - compatible = "nvdimm-region"
>>>> +
>>>> +     - reg = <base, size>;
>>>> +             The system physical address range of this nvdimm region.
>>>> +
>>>> +Optional properties:
>>>> +     - Any relevant NUMA assocativity properties for the target platform.
>>>> +     - A "volatile" property indicating that this region is actually in
>>>> +       normal DRAM and does not require cache flushes after each write.
>>>> +
>>>> +A complete example:
>>>> +--------------------
>>>> +
>>>> +/ {
>>>> +     #size-cells = <2>;
>>>> +     #address-cells = <2>;
>>>> +
>>>> +     platform {
>>>
>>> Perhaps we need a more well defined node here. Like we have 'memory' for
>>> memory nodes.
>>
>> I think treating it as a platform device is fine. Memory nodes are
>
> Platform device is a Linux term...
>
>> special since the OS needs to know where it can allocate early in boot
>> and I don't see non-volatile memory as being similarly significant.
>> Fundamentally an NVDIMM is just a memory mapped storage device so we
>> should be able to defer looking at them until later in boot.
>
> It's not clear if 'platform' is just an example or random name or what
> the node is required to be called. In the latter case, we should be
> much more specific because 'platform' could be anything. In the former
> case, then we have no way to find or validate the node because the
> name could be anything and there's no compatible property either.

Sorry, the platform node is just there as an example. I'll remove it.

> "region" is pretty generic too.

It is, but I didn't see a compelling reason to call it something else.

>> That said you might have problems with XIP kernels and what not. I
>> think that problem is better solved through other means though.
>>
>>>> +             region@5000 {
>>>> +                     compatible = "nvdimm-region;
>>>> +                     reg = <0x00000001 0x00000000 0x00000000 0x40000000>
>>>> +
>>>> +             };
>>>> +
>>>> +             region@6000 {
>>>> +                     compatible = "nvdimm-region";
>>>> +                     reg = <0x00000001 0x00000000 0x00000000 0x40000000>
>
> Thinking about this some more, the 2 levels of nodes is pointless.
> Just follow memory nodes structure.
>
> nv-memory@100000000 {
>   compatible = "nvdimm-region";
>   reg = <0x00000001 0x00000000 0x00000000 0x40000000>;
> };
>
> nv-memory@200000000 {
>   compatible = "nvdimm-region";
>   reg = <0x00000002 0x00000000 0x00000000 0x40000000>;
> };
>
> or:
>
> nv-memory@100000000 {
>   compatible = "nvdimm-region";
>   reg = <0x00000001 0x00000000 0x00000000 0x40000000>
>     <0x00000002 0x00000000 0x00000000 0x40000000>;
> };
>
> Both forms should be allowed.

In the example you need two separate nodes since one has the
"volatile" property to indicate it's backed by normal memory while the
other doesn't. That detail is important since the OS can skip doing
cache flushes when writing to a region that it knows is volatile.

Anyway, the usefulness of having multiple ranges in the reg is a bit
dubious since you should never see dis-contiguous ranges of memory
backed by the same devices. Keep in mind that this binding here is
deliberately skeletal and leaves out the parts required to map the
region to the backing devices, once that is added there's not going to
be a whole lot of room for coalescing nodes. That said, I'll add
support for it anyway since it might be nice to have for hand-written
DTs (ours are mostly generated by FW).

Thanks,
Oliver
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
