Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x235.google.com (mail-wm0-x235.google.com
 [IPv6:2a00:1450:400c:c09::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B095F21ECCB28
 for <linux-nvdimm@lists.01.org>; Wed, 20 Sep 2017 09:07:42 -0700 (PDT)
Received: by mail-wm0-x235.google.com with SMTP id e71so8649989wmg.4
 for <linux-nvdimm@lists.01.org>; Wed, 20 Sep 2017 09:10:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gcdXw3B=x08F+YpOZ1MG_eVWe4VcL=akaZgETzc1nbxA@mail.gmail.com>
References: <CAKccVazzW5Jc21SxdP1BCUyfR3R=LEv-O92nupVVUCB6Jc0PEA@mail.gmail.com>
 <CAPcyv4gcdXw3B=x08F+YpOZ1MG_eVWe4VcL=akaZgETzc1nbxA@mail.gmail.com>
From: Brian Stark <brian.stark@sanmina.com>
Date: Wed, 20 Sep 2017 09:10:46 -0700
Message-ID: <CAKccVazyS6x=G0r0TKnGVRy+41hG+AgNTuUTGkYmbu0h9iiRcg@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Raghu Kulkarni <raghu.kulkarni@sanmina.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Thanks for the response Dan,

As a developer of NVDIMMs we interface to our controller using the SMBUS
interface, which is part of the JEDEC standard.  In the past we have always
tested and accessed out NVDIMMs by directly manipulating the SMBUS
controller defined in the chipsets.  As you may be aware this was never a
very good solution as there is an inherent synchronization problem with any
other actors that may require SMBUS access, but it was the only method
available.  The solution above was good enough for testing hardware, but is
a security risk when deploying in an end user environment, not to mention
the multiple corner cases opened up trying to synchronize SMBUS access with
TSOD or the BMC.

The DSM interface provides functions 27 and 28 (I2C Read and Write
respectively) .  Most of the other functions provide the required
functionality for NVDIMMs and is almost a one to one mapping of our own API
using the method mentioned above.

Before the OS support was added this was the only method, and end users
needed this type of support.  So what was intended to be used for testing
and at the most reference code, ended up being used by early adopters of
the technology.  The way I interpret the ACPI support in the BIOS is that
now all access to the SMBUS will go through a single actor, which is
definitely appreciated and preferred.  I need to research this more elegant
solution so that I can communicate to the end user the best way to deploy
this technology.  We have been working with the Windows support, but we are
just getting started evaluating the Linux support as the JEDEC standard
gains traction.  My task is to provide a smooth transition for current
customers to the new paradigm, and provide a comprehensive reference for
potential new adopters of the technology.

As a low level guy I am always more comfortable starting at the bottom.  I
have been given a link to github of pmem/ndctl, do you believe that this
will provide me the visibility I need for my task described in the previous
paragraph?

Brian

On Tue, Sep 19, 2017 at 7:42 PM, Dan Williams <dan.j.williams@intel.com>
wrote:

> On Tue, Sep 19, 2017 at 3:29 PM, Brian Stark <brian.stark@sanmina.com>
> wrote:
> > Where can I find documentation on accessing NVDIMM JEDEC registers, for
> > example if I want to read page 0 offset 0x80 (defined to be CSAVE_INFO in
> > the JEDEC specification.  How do I do this through Linux given that the
> > BIOS has locked the chipset?
>
> Unless that register is mapped somewhere and the BIOS tells the OS how
> to access it Linux can't get to it.  Does any of the methods defined
> here retrieve the information you are looking for?
>
>     https://msdn.microsoft.com/library/windows/hardware/mt604741
>

-- 
CONFIDENTIALITY
This e-mail message and any attachments thereto, is intended only for use 
by the addressee(s) named herein and may contain legally privileged and/or 
confidential information. If you are not the intended recipient of this 
e-mail message, you are hereby notified that any dissemination, 
distribution or copying of this e-mail message, and any attachments 
thereto, is strictly prohibited. If you have received this e-mail message 
in error, please immediately notify the sender and permanently delete the 
original and any copies of this email and any prints thereof.
ABSENT AN EXPRESS STATEMENT TO THE CONTRARY HEREINABOVE, THIS E-MAIL IS NOT 
INTENDED AS A SUBSTITUTE FOR A WRITING. Notwithstanding the Uniform 
Electronic Transactions Act or the applicability of any other law of 
similar substance and effect, absent an express statement to the contrary 
hereinabove, this e-mail message its contents, and any attachments hereto 
are not intended to represent an offer or acceptance to enter into a 
contract and are not otherwise intended to bind the sender, Sanmina 
Corporation (or any of its subsidiaries), or any other person or entity.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
