Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A5F9A1A1E50
 for <linux-nvdimm@lists.01.org>; Mon,  1 Aug 2016 15:31:36 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id j185so212135743oih.0
 for <linux-nvdimm@lists.01.org>; Mon, 01 Aug 2016 15:31:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <de71bb80-d0be-d5b7-39ed-dd24f53cc2e9@hpe.com>
References: <20160727103505.ovq7jz4553s7kc42@c203.arch.suse.de>
 <a3a59c82-ccbb-75ac-ee21-12c58ac51d39@hpe.com>
 <20160728094518.cqtaavikkrzqnf7k@c203.arch.suse.de>
 <92aa03b2-326d-a932-90df-36cae9b11ecc@hpe.com>
 <20160729115538.hkhywboarkmzb6ti@c203.arch.suse.de>
 <de71bb80-d0be-d5b7-39ed-dd24f53cc2e9@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 1 Aug 2016 15:31:35 -0700
Message-ID: <CAPcyv4ipJvm4jtH9ZhvDuPW00-ing-uutN0kLc9JNN1aXgsFJQ@mail.gmail.com>
Subject: Re: HPE SMART data retreival
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 1, 2016 at 1:57 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
>> What's missing in here is a) the glue code to drivers/acpi/nfit.c and b) the
>> implementations of HPE1 DSMs.
>>
>> Once I have these two I'll post a RFC patch series to the ML, but in the
>> meanwhile I'm already open to comments.
>>
>> The glue code to nfit will be a bus so we have all the nice and shiny .probe()
>> .remove() .uevent() and what not.
>
> There are some things I like about this approach.  What I like most is
> that it add modularity.  I think that when the ACPI tables for NVDIMM
> devices were designed, the idea was that you could have different types
> of NVDIMMs with different capabilities and management requirements, and
> have generic as well as device-specific software.  Section 9.20.5
> describes the different fields that might be used to distinguish the
> hardware and load device or vendor-specific drivers.  We don't have
> flexibility in the current code.  Perhaps it makes sense to evolve our
> current code base to one where the root functions are in the Generic NVDIMM
> management driver and we have vendor-specific management drivers for the
> non-root device DSMs.  I don't know if we need that for the other driver
> types but management is becoming more complicated without them.

I don't think that is quite what Johannes is proposing.  This isn't a
management model per-vendor, this is a scheme to have the kernel
present unified management model across vendors and minimize the
surface area of the userspace ABI as much as possible.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
