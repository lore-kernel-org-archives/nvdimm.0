Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x22d.google.com (mail-wm0-x22d.google.com
 [IPv6:2a00:1450:400c:c09::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0CB2120945BD6
 for <linux-nvdimm@lists.01.org>; Mon, 25 Sep 2017 09:06:50 -0700 (PDT)
Received: by mail-wm0-x22d.google.com with SMTP id m72so21287108wmc.1
 for <linux-nvdimm@lists.01.org>; Mon, 25 Sep 2017 09:10:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AT5PR84MB008227F060E36A2AF273952EAB610@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
References: <CAKccVazzW5Jc21SxdP1BCUyfR3R=LEv-O92nupVVUCB6Jc0PEA@mail.gmail.com>
 <CAPcyv4gcdXw3B=x08F+YpOZ1MG_eVWe4VcL=akaZgETzc1nbxA@mail.gmail.com>
 <CAKccVazyS6x=G0r0TKnGVRy+41hG+AgNTuUTGkYmbu0h9iiRcg@mail.gmail.com>
 <AT5PR84MB008227F060E36A2AF273952EAB610@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
From: Brian Stark <brian.stark@sanmina.com>
Date: Mon, 25 Sep 2017 09:09:59 -0700
Message-ID: <CAKccVayd0UEqPC5exgA=JwMofqpjkzii5KaWCUUCHYK01TwKrg@mail.gmail.com>
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
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: Raghu Kulkarni <raghu.kulkarni@sanmina.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

I guess my understanding was that the ACPI method was already deployed.  I
was expecting this to be just a matter of replacing my kernel driver with
system calls using this method.  I am not trying to re-invent a wheel, I
just want to implement the standard methodology.  Most of our existing
customers require access to the JEDEC registers so that they can actively
monitor the health of the NVDIMM, this requires SMBUS access to the JEDEC
registers (7 bit Address 0x4X).  My assumption was that this support now
built in to the kernel.  The reason I mentioned the direct access functions
is that the standard does provide for vendor specific registers.  What I
really want to know is how much of the ACPI interface is implemented so I
know what I have to work with.

Brian

On Wed, Sep 20, 2017 at 2:00 PM, Elliott, Robert (Persistent Memory) <
elliott@hpe.com> wrote:

>
>
> > -----Original Message-----
> > From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf
> Of
> > Brian Stark
> > Sent: Wednesday, September 20, 2017 11:11 AM
> > To: Dan Williams <dan.j.williams@intel.com>
> > Cc: Raghu Kulkarni <raghu.kulkarni@sanmina.com>;
> linux-nvdimm@lists.01.org
> > Subject: Re: Access to NVDIMM JEDEC registers
> >
> > Thanks for the response Dan,
> >
> > As a developer of NVDIMMs we interface to our controller using the SMBUS
> > interface, which is part of the JEDEC standard.  In the past we have
> always
> > tested and accessed out NVDIMMs by directly manipulating the SMBUS
> > controller defined in the chipsets.  As you may be aware this was never a
> > very good solution as there is an inherent synchronization problem with
> any
> > other actors that may require SMBUS access, but it was the only method
> > available.  The solution above was good enough for testing hardware, but
> is
> > a security risk when deploying in an end user environment, not to mention
> > the multiple corner cases opened up trying to synchronize SMBUS access
> with
> > TSOD or the BMC.
> >
> > The DSM interface provides functions 27 and 28 (I2C Read and Write
> > respectively) .  Most of the other functions provide the required
> > functionality for NVDIMMs and is almost a one to one mapping of our own
> API
> > using the method mentioned above.
>
> Don't expect those DSMs to be available outside of debug modes.
> They're too dangerous for the reasons you describe:
>
> * collisions with other entities trying to use the SMBus controllers
> (CLTT/TSOD, BMICs, SMI handlers, etc.)
>
> * lack of higher-level mutual exclusion.  JEDEC BAEBI register
> accesses require performing several I2C transactions without
> interruption. For example, the OPEN_PAGE register controls what
> registers are actually being accessed.  Some registers are in
> pairs that must be read and written together to have coherent
> meaning.
>
> * lack of security. This would let the caller do things like change
> the arming, trigger a restore, download new firmware, inject errors,
> etc.
>
> We've discussed defining an ACPI method that software could call to
> arbitrate for ownership of the SMBus controller (and give it back).
> This would facilitate OS-based online firmware download tools, for example.
>
> One stumbling block is error handling; what if some entity wins control
> but doesn't give it back?  There's no way to cleanly kick it off, prevent
> it from touching the SMBus controller registers if it does wake up,
> and clean up whatever transactions it had in progress.
>
> Another problem is not all the SMBus controller capabilities are
> necessarily supported by a system.  Although software could program it
> to run at 1 MHz, signal integrity might only be good for 100 kHz
> or 400 kHz.  Only system firmware knows those restrictions.
>
> Functionality-based DSMs are much safer and let system-provided code
> (the ACPI machine language code executed in the OS context, system
> firmware executed in SMM context, and system firmware executed
> during the next boot) figure out how to implement the request.
>
>
> ---
> Robert Elliott, HPE Persistent Memory
>
>
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
