Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x22c.google.com (mail-io0-x22c.google.com
 [IPv6:2607:f8b0:4001:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8388B21E1B76D
 for <linux-nvdimm@lists.01.org>; Thu, 21 Sep 2017 08:56:46 -0700 (PDT)
Received: by mail-io0-x22c.google.com with SMTP id e189so11985222ioa.4
 for <linux-nvdimm@lists.01.org>; Thu, 21 Sep 2017 08:59:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AT5PR84MB008227F060E36A2AF273952EAB610@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
References: <CAKccVazzW5Jc21SxdP1BCUyfR3R=LEv-O92nupVVUCB6Jc0PEA@mail.gmail.com>
 <CAPcyv4gcdXw3B=x08F+YpOZ1MG_eVWe4VcL=akaZgETzc1nbxA@mail.gmail.com>
 <CAKccVazyS6x=G0r0TKnGVRy+41hG+AgNTuUTGkYmbu0h9iiRcg@mail.gmail.com>
 <AT5PR84MB008227F060E36A2AF273952EAB610@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 21 Sep 2017 08:59:52 -0700
Message-ID: <CAPcyv4iM-LMDFkCAPJyFNyDF21ywHwsn90kpB9Eezub_7D-_Tw@mail.gmail.com>
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
Cc: Raghu Kulkarni <raghu.kulkarni@sanmina.com>, Brian Stark <brian.stark@sanmina.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 20, 2017 at 2:00 PM, Elliott, Robert (Persistent Memory)
<elliott@hpe.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
> > Brian Stark
> > Sent: Wednesday, September 20, 2017 11:11 AM
> > To: Dan Williams <dan.j.williams@intel.com>
> > Cc: Raghu Kulkarni <raghu.kulkarni@sanmina.com>; linux-nvdimm@lists.01.org
> > Subject: Re: Access to NVDIMM JEDEC registers
> >
> > Thanks for the response Dan,
> >
> > As a developer of NVDIMMs we interface to our controller using the SMBUS
> > interface, which is part of the JEDEC standard.  In the past we have always
> > tested and accessed out NVDIMMs by directly manipulating the SMBUS
> > controller defined in the chipsets.  As you may be aware this was never a
> > very good solution as there is an inherent synchronization problem with any
> > other actors that may require SMBUS access, but it was the only method
> > available.  The solution above was good enough for testing hardware, but is
> > a security risk when deploying in an end user environment, not to mention
> > the multiple corner cases opened up trying to synchronize SMBUS access with
> > TSOD or the BMC.
> >
> > The DSM interface provides functions 27 and 28 (I2C Read and Write
> > respectively) .  Most of the other functions provide the required
> > functionality for NVDIMMs and is almost a one to one mapping of our own API
> > using the method mentioned above.
>
> Don't expect those DSMs to be available outside of debug modes.
> They're too dangerous for the reasons you describe:

Brian, is the JEDEC register data you want to retrieve available via
the NFIT or other DSMs? Or, can you point me to the spec that defines
the registers in question? I didn't find them in Annex L.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
