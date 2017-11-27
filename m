Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F41EC21A10978
 for <linux-nvdimm@lists.01.org>; Mon, 27 Nov 2017 09:29:29 -0800 (PST)
From: "Czurylo, Krzysztof" <krzysztof.czurylo@intel.com>
Subject: RE: [PATCH] daxctl: remove libpmem dependency
Date: Mon, 27 Nov 2017 17:33:48 +0000
Message-ID: <91626014A8500F418F35F9EB590D2531AA96F5C6@IRSMSX106.ger.corp.intel.com>
References: <1510238453-7713-1-git-send-email-lukasz.plewa@intel.com>
 <CAOSf1CFMsPwFcO6Mp4fV+faEBdG5wwi3d1nGK+n-MDGF4v0oLw@mail.gmail.com>
 <x498tfe8820.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jJ0J4EkD95OXRWOogyV0tbY_WaO9WyQULL3bs+rShQBA@mail.gmail.com>
 <x49375m5blz.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4ieVYyrLgL4khMkqW-Rf36Ptzmnj0nAvoog0+zd_G3shg@mail.gmail.com>
 <91626014A8500F418F35F9EB590D2531AA96A9A8@IRSMSX106.ger.corp.intel.com>
 <CAPcyv4jmTfMw-UZxa6Fhoy7bZXqbTZc84CLby440pq72NtSGCA@mail.gmail.com>
In-Reply-To: <CAPcyv4jmTfMw-UZxa6Fhoy7bZXqbTZc84CLby440pq72NtSGCA@mail.gmail.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Dan Williams [mailto:dan.j.williams@intel.com]
> Sent: Thursday, November 23, 2017 19:09
> To: Czurylo, Krzysztof
> Cc: Jeff Moyer; Plewa, Lukasz; linux-nvdimm@lists.01.org
> Subject: Re: [PATCH] daxctl: remove libpmem dependency
> (...)
> > 3) Remove "daxctl io" command from ndctl and integrate it with NVML's
> > "pmempool" utility (or a dedicated tool/subpkg).
> > There's not much we need to do, as in practice we already have a
> > similar tool in the nvml repo (src/test/tools/ddmap). So far, it's
> > only used for testing, but could become a standalone "ddmap" or
> "daxio" utility.
> 
> I'd like to investigate this option. We need a utility to manage
> (provision, re-provision, backup) device-dax capacity, and I don't much
> care if it comes from the daxctl package, or elsewhere.
> (...) 
> Let's take a look at shipping 'daxctl io' alongside pmempool. I do not
> want multiple pmem_memcpy() implementations to start proliferating
> around various userspace packages.

If we choose this option, do we need to implement "daxctl list" command?
Since "list" is also supported by ndctl (though the output is slightly
different), I'd prefer to only implement "daxctl io" in nvml.

Anything else this tool should be able to do besides the "io"?
Are there any plans for other features/commands?

--
K.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
