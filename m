Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7181D203B99A8
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jul 2018 15:11:15 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl: add an API to check support for smart
 injection
Date: Wed, 11 Jul 2018 22:10:55 +0000
Message-ID: <1531347054.7574.52.camel@intel.com>
References: <20180711211709.3007-1-vishal.l.verma@intel.com>
 <CAPcyv4hbe2rxPELdB2AmcfwcrzWSmdXDtW-tpn+dHKH7nmptHQ@mail.gmail.com>
 <1531345901.7574.50.camel@intel.com>
In-Reply-To: <1531345901.7574.50.camel@intel.com>
Content-Language: en-US
Content-ID: <30A47519C4E0514987B7B6D066DF0AAB@intel.com>
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


On Wed, 2018-07-11 at 21:51 +0000, Verma, Vishal L wrote:
> On Wed, 2018-07-11 at 14:38 -0700, Dan Williams wrote:
> > On Wed, Jul 11, 2018 at 2:17 PM, Vishal Verma <vishal.l.verma@intel
> > .com> wrote:
> > > Add an API to check whether smart injection is supported, and add an
> > > intel-dsm implementation for it. Use this check in the ndctl
> > > inject-smart command.
> > > 
> > > Reported-by: Leszek Lugin <leszek.lugin@intel.com>
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > 
> > [..]
> > > +static int intel_dimm_smart_inject_supported(struct ndctl_dimm *dimm)
> > > +{
> > > +       struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
> > > +
> > > +       if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_CALL)) {
> > > +               dbg(ctx, "unsupported cmd: %d\n", ND_CMD_CALL);
> > > +               return -EOPNOTSUPP;
> > > +       }
> > > +
> > > +       if (test_dimm_dsm(dimm, ND_INTEL_SMART_INJECT_MTEMP) ==
> > > +                       DIMM_DSM_UNSUPPORTED ||
> > > +                       test_dimm_dsm(dimm, ND_INTEL_SMART_INJECT_SPARE) ==
> > > +                       DIMM_DSM_UNSUPPORTED ||
> > > +                       test_dimm_dsm(dimm, ND_INTEL_SMART_INJECT_FATAL) ==
> > > +                       DIMM_DSM_UNSUPPORTED ||
> > > +                       test_dimm_dsm(dimm, ND_INTEL_SMART_INJECT_SHUTDOWN) ==
> > > +                       DIMM_DSM_UNSUPPORTED) {
> > > +               dbg(ctx, "smart injection functions unsupported\n");
> > > +               return -EIO;
> > 
> > Just a nit on readability. I find it jarring to split the arguments to
> > "== "on 2 different lines, especially after Neil Brown made a similar
> > observation on my code. The natural read cadence is to grok the "=="
> > statement and then move to the next operator on the following line.
> > Also, we've thankfully defined DIMM_DSM_UNSUPPORTED as zero, so it
> > would be more readable to drop == and do the following with the ||
> > operators:
> > 
> >         if (!test_dimm_dsm(dimm, ND_INTEL_SMART_INJECT_MTEMP)
> >                         || !test_dimm_dsm(dimm, ND_INTEL_SMART_INJECT_SPARE)
> >                         || !test_dimm_dsm(dimm, ND_INTEL_SMART_INJECT_FATAL)
> >                         || !test_dimm_dsm(dimm,
> > ND_INTEL_SMART_INJECT_SHUTDOWN)) {
> 
> Yes that looks much better. I'll send a v2.

I just realized, this check is not correct. INJECT_* are not separate
commands, but flags to the same command - ND_INTEL_SMART_INJECT. So
that is all we need to check for in the DSM mask.

> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
