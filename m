Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by ml01.01.org (Postfix) with ESMTP id 886D021A13493
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 13:04:19 -0700 (PDT)
Date: Wed, 10 May 2017 22:04:07 +0200
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 1/2] x86/MCE: Export memory_error()
Message-ID: <20170510200406.mphusoidfuyq24ee@pd.tnic>
References: <20170420221818.23522-1-vishal.l.verma@intel.com>
 <CAPcyv4ijU2V-4WOPysL12ByOovAXDO=Mci1D4wNDFqxRjdvT2w@mail.gmail.com>
 <1492804517.2738.25.camel@intel.com>
 <3908561D78D1C84285E8C5FCA982C28F6127653B@ORSMSX114.amr.corp.intel.com>
 <CAPcyv4jAkCE2QBuxfxxmZfQZLCVOGLrLXqDu5TyGCVA+xJMEVg@mail.gmail.com>
 <20170421202741.GA16423@intel.com>
 <20170421210704.c5pvpn6zivvruzx3@pd.tnic>
 <20170424113620.6iq2466yhkhb33rp@pd.tnic>
 <20170425210740.GA15722@omniknight.lm.intel.com>
 <1494444606.20330.2.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1494444606.20330.2.camel@intel.com>
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "Luck," Tony" <tony.luck@intel.com>, "stable@vger.kernel.org, " <stable@vger.kernel.org>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 10, 2017 at 07:31:30PM +0000, Verma, Vishal L wrote:
> I didn't see the above patches in the RAS branches of the tip tree -

You need to be patient - we have merge window right now. Next week,
after -rc1 releases, it is business as usual again.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
