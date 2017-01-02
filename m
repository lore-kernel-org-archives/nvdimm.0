Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8E015818C8
 for <linux-nvdimm@lists.01.org>; Sun,  1 Jan 2017 21:09:43 -0800 (PST)
Date: Mon, 2 Jan 2017 05:09:27 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC] memcpy_nocache() and memcpy_writethrough()
Message-ID: <20170102050927.GY1555@ZenIV.linux.org.uk>
References: <20161026155021.20892-2-brian.boylston@hpe.com>
 <58110959.90901@plexistor.com>
 <CS1PR84MB011975E5DCF3B091E53A3FB38EAD0@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
 <5818A5C8.6040300@plexistor.com>
 <20161228234321.GA27417@ZenIV.linux.org.uk>
 <CAPcyv4gg1XNJ3E=+0HDZnx08_dvvX+Prj-rLOsXcuHHO1pBLzg@mail.gmail.com>
 <20161230035252.GV1555@ZenIV.linux.org.uk>
 <CAPcyv4gC0gaT7csVb=CbwhVNxGePDcSzOMZ_RXu+Q55uY3ScnA@mail.gmail.com>
 <20161231022558.GW1555@ZenIV.linux.org.uk>
 <DF4PR84MB016972BE1CA018A9AC4BE592AB6F0@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <DF4PR84MB016972BE1CA018A9AC4BE592AB6F0@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Moreno," Oliver" <oliver.moreno@hpe.com>, "x86@kernel.org, " <x86@kernel.org>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "boylston@burromesa.net" <boylston@burromesa.net>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 02, 2017 at 02:35:36AM +0000, Elliott, Robert (Persistent Memory) wrote:
> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> > owner@vger.kernel.org] On Behalf Of Al Viro
> > Sent: Friday, December 30, 2016 8:26 PM
> > Subject: [RFC] memcpy_nocache() and memcpy_writethrough()
> > 
> ...
> > Why does pmem need writethrough warranties, anyway?  
> 
> Using either 
> * nontemporal store instructions; or
> * following regular store instructions with a sequence of cache flush
> and store fence instructions (e.g., clflushopt or clwb + sfence)
> 
> ensures that write data has reached an "ADR-safe zone" that the system
> promises will be persistent even if there is a surprise power loss or
> a CPU suffers from an error that isn't totally catastrophic (e.g., the
> CPU getting disconnected from the SDRAM will always lose data on an
> NVDIMM-N).

Wait a sec...  In which places do you need sfence in all that?  movnt*
itself can be reordered, right?  So using that for copying and storing
the pointer afterwards would still need sfence inbetween, unless I'm
seriously misunderstanding the situation...

> Newly written data becomes globally visible before it becomes ADR-safe.
> This means software could act on the new data before a power loss, then
> see the old data reappear after the power loss - not good.  Software
> needs to understand that any data in the process of being written is
> indeterminate until the persistence guarantee is met.  The BTT shows
> one way that software can avoid that problem.

Joy.  What happens in terms of latency?  I.e. how much of a stall does
clwb inflict?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
