Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x22e.google.com (mail-io0-x22e.google.com
 [IPv6:2607:f8b0:4001:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4FD2A20945BF5
 for <linux-nvdimm@lists.01.org>; Wed, 20 Sep 2017 09:49:28 -0700 (PDT)
Received: by mail-io0-x22e.google.com with SMTP id 21so4960473iof.6
 for <linux-nvdimm@lists.01.org>; Wed, 20 Sep 2017 09:52:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKccVazyS6x=G0r0TKnGVRy+41hG+AgNTuUTGkYmbu0h9iiRcg@mail.gmail.com>
References: <CAKccVazzW5Jc21SxdP1BCUyfR3R=LEv-O92nupVVUCB6Jc0PEA@mail.gmail.com>
 <CAPcyv4gcdXw3B=x08F+YpOZ1MG_eVWe4VcL=akaZgETzc1nbxA@mail.gmail.com>
 <CAKccVazyS6x=G0r0TKnGVRy+41hG+AgNTuUTGkYmbu0h9iiRcg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 20 Sep 2017 09:52:32 -0700
Message-ID: <CAPcyv4hH5xU1qmD5vzCcDmcVNsM8CPQLAzd6DYWO1ezOeyV5Gg@mail.gmail.com>
Subject: Re: Access to NVDIMM JEDEC registers
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
To: Brian Stark <brian.stark@sanmina.com>
Cc: Raghu Kulkarni <raghu.kulkarni@sanmina.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 20, 2017 at 9:10 AM, Brian Stark <brian.stark@sanmina.com> wrote:
> Thanks for the response Dan,
>
> As a developer of NVDIMMs we interface to our controller using the SMBUS
> interface, which is part of the JEDEC standard.  In the past we have always
> tested and accessed out NVDIMMs by directly manipulating the SMBUS
> controller defined in the chipsets.  As you may be aware this was never a
> very good solution as there is an inherent synchronization problem with any
> other actors that may require SMBUS access, but it was the only method
> available.  The solution above was good enough for testing hardware, but is
> a security risk when deploying in an end user environment, not to mention
> the multiple corner cases opened up trying to synchronize SMBUS access with
> TSOD or the BMC.
>
> The DSM interface provides functions 27 and 28 (I2C Read and Write
> respectively) .  Most of the other functions provide the required
> functionality for NVDIMMs and is almost a one to one mapping of our own API
> using the method mentioned above.
>
> Before the OS support was added this was the only method, and end users
> needed this type of support.  So what was intended to be used for testing
> and at the most reference code, ended up being used by early adopters of the
> technology.  The way I interpret the ACPI support in the BIOS is that now
> all access to the SMBUS will go through a single actor, which is definitely
> appreciated and preferred.  I need to research this more elegant solution so
> that I can communicate to the end user the best way to deploy this
> technology.  We have been working with the Windows support, but we are just
> getting started evaluating the Linux support as the JEDEC standard gains
> traction.  My task is to provide a smooth transition for current customers
> to the new paradigm, and provide a comprehensive reference for potential new
> adopters of the technology.
>
> As a low level guy I am always more comfortable starting at the bottom.  I
> have been given a link to github of pmem/ndctl, do you believe that this
> will provide me the visibility I need for my task described in the previous
> paragraph?

I maintain that pmem/ndctl project as a place to land generic /
cross-vendor NVDIMM enabling. The current state is that the Linux
kernel has support for passing commands to 4 different DSM (Device
Specific Method) "families". Where the Microsoft spec [1] is one of
the command families, there are 2 defined by HPE [2], and one by Intel
[3]. Of those command sets I believe only the Microsoft spec and one
of the HPE specs provide direct SMBUS/I2C commands.

What that means is that the utility to read the JEDEC registers would need to:

1/ Determine if the DIMM is standard JEDEC defined DIMM (the ACPI NFIT
should indicate this)

2/ Determine if the BIOS provides a DSM command family for the DIMM
that enables direct SMBUS commands.

3/ Craft the command in the proper format and send it to the Linux driver.

There is some precedent in the library for providing a common front
end for all the various SMART/Health commands across vendors. I assume
we would do something similar for enabling direct SMBUS access across
the Microsoft and HPE specs.

Does that answer your question, or did I prematurely jump into the
solution space?

[1]: msdn.microsoft.com/library/windows/hardware/mt604741
[2]: github.com/HewlettPackard/hpe-nvm/blob/master/Documentation
[3]: pmem.io/documents/NVDIMM_DSM_Interface-V1.6.pdf
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
