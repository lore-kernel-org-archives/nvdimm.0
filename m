Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3642F20945B69
 for <linux-nvdimm@lists.01.org>; Wed, 20 Sep 2017 13:57:28 -0700 (PDT)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: Access to NVDIMM JEDEC registers
Date: Wed, 20 Sep 2017 21:00:30 +0000
Message-ID: <AT5PR84MB008227F060E36A2AF273952EAB610@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
References: <CAKccVazzW5Jc21SxdP1BCUyfR3R=LEv-O92nupVVUCB6Jc0PEA@mail.gmail.com>
 <CAPcyv4gcdXw3B=x08F+YpOZ1MG_eVWe4VcL=akaZgETzc1nbxA@mail.gmail.com>
 <CAKccVazyS6x=G0r0TKnGVRy+41hG+AgNTuUTGkYmbu0h9iiRcg@mail.gmail.com>
In-Reply-To: <CAKccVazyS6x=G0r0TKnGVRy+41hG+AgNTuUTGkYmbu0h9iiRcg@mail.gmail.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: Brian Stark <brian.stark@sanmina.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Raghu Kulkarni <raghu.kulkarni@sanmina.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
> Brian Stark
> Sent: Wednesday, September 20, 2017 11:11 AM
> To: Dan Williams <dan.j.williams@intel.com>
> Cc: Raghu Kulkarni <raghu.kulkarni@sanmina.com>; linux-nvdimm@lists.01.org
> Subject: Re: Access to NVDIMM JEDEC registers
> 
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

Don't expect those DSMs to be available outside of debug modes.
They're too dangerous for the reasons you describe:

* collisions with other entities trying to use the SMBus controllers
(CLTT/TSOD, BMICs, SMI handlers, etc.)

* lack of higher-level mutual exclusion.  JEDEC BAEBI register
accesses require performing several I2C transactions without
interruption. For example, the OPEN_PAGE register controls what
registers are actually being accessed.  Some registers are in
pairs that must be read and written together to have coherent
meaning.

* lack of security. This would let the caller do things like change
the arming, trigger a restore, download new firmware, inject errors, 
etc. 

We've discussed defining an ACPI method that software could call to
arbitrate for ownership of the SMBus controller (and give it back).
This would facilitate OS-based online firmware download tools, for example.

One stumbling block is error handling; what if some entity wins control
but doesn't give it back?  There's no way to cleanly kick it off, prevent
it from touching the SMBus controller registers if it does wake up,
and clean up whatever transactions it had in progress.

Another problem is not all the SMBus controller capabilities are
necessarily supported by a system.  Although software could program it
to run at 1 MHz, signal integrity might only be good for 100 kHz
or 400 kHz.  Only system firmware knows those restrictions.

Functionality-based DSMs are much safer and let system-provided code
(the ACPI machine language code executed in the OS context, system
firmware executed in SMM context, and system firmware executed
during the next boot) figure out how to implement the request.


---
Robert Elliott, HPE Persistent Memory


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
