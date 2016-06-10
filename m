Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from na01-bl2-obe.outbound.protection.outlook.com
 (mail-bl2on0700.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fc09::700])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8C8551A1E02
 for <linux-nvdimm@lists.01.org>; Fri, 10 Jun 2016 07:46:50 -0700 (PDT)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH] efi: kernel param for legacy NVDIMM support
Date: Fri, 10 Jun 2016 14:46:26 +0000
Message-ID: <DF4PR84MB016965ECBD5DF92D9091E816AB500@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
References: <CAA9_cmeQUaxShZfnARt=j4iResPTwjxrK_toA6CJgtRAnzEgYQ@mail.gmail.com>
In-Reply-To: <CAA9_cmeQUaxShZfnARt=j4iResPTwjxrK_toA6CJgtRAnzEgYQ@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Yigal Korman <yigal@plexistor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On
> Behalf Of Dan Williams
> Sent: Friday, June 10, 2016 9:28 AM
> To: Yigal Korman <yigal@plexistor.com>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>; linux-
> efi@vger.kernel.org; linux-nvdimm@lists.01.org
> Subject: Re: [PATCH] efi: kernel param for legacy NVDIMM support
> 
> On Fri, Jun 10, 2016 at 1:48 AM, Yigal Korman <yigal@plexistor.com>
> wrote:
> > On Thu, Jun 9, 2016 at 11:27 PM, Dan Williams
...
> We should always look for an NFIT in the type-14 case.  Injecting a
> crafted NFIT for this legacy case removes confusion as there is only
> one action the kernel takes and no possibility for collisions.  I
> also
> do not want to make it easier for firmware developers to skip the
> necessary due diligence to decide whether attributes like numa
> topology, posted write queue flush mechanisms, and media health,
> etc...  need description.

I'll also reiterate that NVDIMM ranges may also be reported using
the UEFI and E820 reserved types.  The simple E820 and UEFI memory
map persistent memory type values do not contain enough information
to properly talk to an NVDIMM; the information in ACPI NFIT is
crucial.

---
Robert Elliott, HPE Persistent Memory


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
