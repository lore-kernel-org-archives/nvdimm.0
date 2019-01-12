Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 450A62119EF50
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 16:37:05 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH 2/3] ndctl, inject-smart: switch to
 ndctl_cmd_submit_xlat
Date: Sat, 12 Jan 2019 00:36:49 +0000
Message-ID: <79d556b4cbc5b4e711077a65490b23e55fcb88d4.camel@intel.com>
References: <20190111225339.6939-1-vishal.l.verma@intel.com>
 <20190111225339.6939-3-vishal.l.verma@intel.com>
 <CAPcyv4hT8UZiu6Ber-yzN=swxyDmmOwbLkTBg=ZrNT1PCphyBg@mail.gmail.com>
In-Reply-To: <CAPcyv4hT8UZiu6Ber-yzN=swxyDmmOwbLkTBg=ZrNT1PCphyBg@mail.gmail.com>
Content-Language: en-US
Content-ID: <9EA2399E865A1A439D569E8FFD0E89DD@intel.com>
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
Cc: "Pathak, Ami G" <ami.g.pathak@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Fri, 2019-01-11 at 16:31 -0800, Dan Williams wrote:
> On Fri, Jan 11, 2019 at 2:53 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
> > 
> > The ndctl inject-smart command was neglecting to check the
> > 'firmware_status' field that is set by the platform firmware to indicate
> > failure. Use the new ndctl_cmd_submit_xlat facility to include the
> > firmware_status check as part of the command submission.
> > 
> > Reported-by: Ami Pathak <ami.g.pathak@intel.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > ---
> >  ndctl/inject-smart.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c
> > index eaa137a..12f3474 100644
> > --- a/ndctl/inject-smart.c
> > +++ b/ndctl/inject-smart.c
> > @@ -280,7 +280,7 @@ static int smart_set_thresh(struct ndctl_dimm *dimm)
> >                 goto out;
> >         }
> > 
> > -       rc = ndctl_cmd_submit(st_cmd);
> > +       rc = ndctl_cmd_submit_xlat(st_cmd);
> >         if (rc) {
> >                 error("%s: smart threshold command failed: %s (%d)\n",
> >                         name, strerror(abs(rc)), rc);
> > @@ -320,7 +320,7 @@ static int smart_set_thresh(struct ndctl_dimm *dimm)
> >                 ndctl_cmd_smart_threshold_set_alarm_control(sst_cmd, alarm);
> >         }
> > 
> > -       rc = ndctl_cmd_submit(sst_cmd);
> > +       rc = ndctl_cmd_submit_xlat(sst_cmd);
> >         if (rc)
> >                 error("%s: smart set threshold command failed: %s (%d)\n",
> >                         name, strerror(abs(rc)), rc);
> > @@ -351,7 +351,7 @@ out:
> >                         if (sctx.err_continue == false) \
> >                                 goto out; \
> >                 } \
> > -               rc = ndctl_cmd_submit(si_cmd); \
> > +               rc = ndctl_cmd_submit_xlat(si_cmd); \
> >                 if (rc) { \
> >                         error("%s: smart inject %s command failed: %s (%d)\n", \
> >                                 name, #arg, strerror(abs(rc)), rc); \
> > @@ -382,7 +382,7 @@ out:
> >                         if (sctx.err_continue == false) \
> >                                 goto out; \
> >                 } \
> > -               rc = ndctl_cmd_submit(si_cmd); \
> > +               rc = ndctl_cmd_submit_xlat(si_cmd); \
> >                 if (rc) { \
> >                         error("%s: smart inject %s command failed: %s (%d)\n", \
> >                                 name, #arg, strerror(abs(rc)), rc); \
> 
> These need to become if (rc < 0) just to be compatible with the
> calling convention. Maybe that's a lead in cleanup patch.

Hm, I think there may be several other lurkers that fail on positive.
I'll fix these two patches up and add a follow on patch for any others
in v2.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
