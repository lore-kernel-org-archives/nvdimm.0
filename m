Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x229.google.com (mail-yw0-x229.google.com
 [IPv6:2607:f8b0:4002:c05::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1DC892095D8CC
 for <linux-nvdimm@lists.01.org>; Wed, 12 Jul 2017 22:15:52 -0700 (PDT)
Received: by mail-yw0-x229.google.com with SMTP id x125so18302563ywa.0
 for <linux-nvdimm@lists.01.org>; Wed, 12 Jul 2017 22:17:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170713133545.4ABF.E1E9C6FF@jp.fujitsu.com>
References: <20170712192518.C683.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4hHBntujti2bDmB5WaBab=hCVphO=X-yVa4pJJ0iLP2PQ@mail.gmail.com>
 <20170713133545.4ABF.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 12 Jul 2017 22:17:37 -0700
Message-ID: <CAPcyv4iyU5EQJMazRuQ=TM3o15kOJwX0RnCnnxgRcfBbaJyQMw@mail.gmail.com>
Subject: Re: Some thoughts of ndctl list command output
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 12, 2017 at 9:35 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>> On Wed, Jul 12, 2017 at 3:25 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>> > Hello,
>> >
>> > I wrote current impression about ndctl.
>> > If my understanding/thoughts is wrong, please correct me.
>> >
>> >
>> > Please imagine the following situation.
>> >
>> >   - There are 2 NVDIMMs like the following figure.
>> >   - An interleaved region(namespace) is created on NVDIMM 1 and 2,
>> >     and it is /dev/pmem1.
>> >   - A storage region is created on NVDIMM 1 too, it is /dev/pmem2s.
>> >   - Another storage region is created on NVDIMM 2 as /dev/pmem3s.
>> >
>> >   +-------------------+-------------------+
>> >   |                   |    /dev/pmem2s    |   NVDIMM 1 (nmem1)
>> >   |/dev/pmem1     X   +-------------------+
>> >   |                   |    /dev/pmem3s    |   NVDIMM 2 (nmem2)
>> >   +-------------------+-------------------+
>> >
>> >
>> >   If a place (in the above figure, place "X") is broken and scrubbing can not
>> >   solve error, user will need to replace broken NVDIMM.
>> >
>> >   But, how does user can know which NVDIMM is broken?
>> >   Currently, badblock data belongs to region, not DIMM module,
>> >   there is no information which nvdimm has badblock.
>> >
>> >   In addition, even if user can find that badblock is included in NVDIMM 2
>> >   fortunately, then he/she needs to become aware that /dev/pmem3s is
>> >   also included in NVDIMM 2, because he/she need to backup the region
>> >   before replacing NVDIMM 2.
>> >
>> >   However, I suppose it may be a bit difficult for user to be aware of it.
>> >   Because current ndctl does NOT output
>> >   "Which region is included on the (broken) NVDIMM module."
>> >   It can output only
>> >   "Which NVDIMM is used for the region by "ndctl list -RD".
>> >
>> >   As a result, he/she has to SEARCH all of the regions which is mapped on
>> >   "nmem2". It may be a bit troublesome for users, I think.
>> >
>> >
>> >   In summary, I think...
>> >     - Badblock information on each NVDIMM will be helpful for user to replace
>> >       wrong NVDIMM.
>> >     - ndctl list -D need to output the information which regions/namespaces
>> >       are placed on each NVDIMM.
>>
>> You analysis is correct.
>>
>> Prior to ACPI 6.2 we would need to walk through the
>> interleave-descriptor tables to discover the translation of the
>> system-physical-address to a DIMM+offset. However, we now have the
>> "Translate SPA" _DSM which should make it easy for ndctl to translate
>> "badblocks" information at a region level back to a specific DIMM.
>
> Hmm, I checked "Translate SPA" in ACPI6.2 spec, but I have a question yet.
>
> The spec says...
>  "For a HW mirrored interleave set, the Flags Bit[0] - Mirrored
>   SPA Location bit is set and all NVDIMM Devices the SPA translates
>   to are included in the returned NVDIMM Device List."
>
>   Then, this issue will be more complex.
>   If one DIMM which belongs to a mirrored interleave set has badblocks,
>   which scenario will happen?
>
>
>   a) Bad block is reported, but _DSM says such SPA is mapped plural
>      DIMMs by the above specs, then user can not find which is wrong DIMM....
>      (This is worst scenario...)
>
>   b) Another DIMM's SPA is still good status, so badblock is
>      not showen/not reported to user. However user need to check health status
>      of each DIMMs periodically. It must be before both DIMM becomes fatal.
>
>   c) If one of DIMM has a bad block in mirrored interleave set,
>      driver can notify such event to userland.
>
>   d) etc?

My hope is that if one of the DIMMs in the mirror has a badblock that
it can be repaired from the other side of the mirror, but I assume
that type of capability would be platform implementation specific. For
now though I don't think that stops ndctl from using Translate SPA for
the non-mirrored case to identify a DIMM with a badblock.

However, I don't think identifying a DIMM with a badblocks will be the
common case for replacing a device. The Clear Uncorrectable Error
command implies DIMM devices can be repaired. If a DIMM device cannot
be repaired that will show in the SMART health of the DIMM. So, I
don't think it is critical to provide this badblock-to-DIMM
translation for remediation purposes, but I agree it's good for
statistical monitoring.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
