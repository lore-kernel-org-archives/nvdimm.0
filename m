Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by ml01.01.org (Postfix) with ESMTP id B7D5A2193DFCA
 for <linux-nvdimm@lists.01.org>; Fri, 21 Apr 2017 14:14:45 -0700 (PDT)
Date: Fri, 21 Apr 2017 23:07:04 +0200
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] acpi, nfit: fix the memory error check in nfit_handle_mce
Message-ID: <20170421210704.c5pvpn6zivvruzx3@pd.tnic>
References: <20170420221818.23522-1-vishal.l.verma@intel.com>
 <CAPcyv4ijU2V-4WOPysL12ByOovAXDO=Mci1D4wNDFqxRjdvT2w@mail.gmail.com>
 <1492804517.2738.25.camel@intel.com>
 <3908561D78D1C84285E8C5FCA982C28F6127653B@ORSMSX114.amr.corp.intel.com>
 <CAPcyv4jAkCE2QBuxfxxmZfQZLCVOGLrLXqDu5TyGCVA+xJMEVg@mail.gmail.com>
 <20170421202741.GA16423@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170421202741.GA16423@intel.com>
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
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 21, 2017 at 01:27:41PM -0700, Luck, Tony wrote:
> Boris: you coded up a "static bool memory_error(struct mce *m)"
> function inside the patches for the corrected error thingy.
> 
> Perhaps when it goes upstream it should be available for other
> users too?

I don't see why not. struct mce.cpuvendor even has the vendor in there
so memory_error() wouldn't even have to look at boot_cpu_data when doing
per-vendor decision.

I guess we should rename it to something more global namespace-y like
"mce_is_memory_error() or so, though, before we expose it to wider
audience...

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
