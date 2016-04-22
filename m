Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hp.com (g4t3426.houston.hp.com [15.201.208.54])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4E5401A1EE3
 for <linux-nvdimm@lists.01.org>; Fri, 22 Apr 2016 16:15:09 -0700 (PDT)
Date: Fri, 22 Apr 2016 17:15:06 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [RFC v9 5/5] nvdimm: Add ioctl to return command mask.
Message-ID: <20160422231506.GB126763@tevye.fc.hp.com>
References: <cover.1460936121.git.jerry.hoemann@hpe.com>
 <9f04df3b80c68dd6406cfee5ce11a2cd8ed33b64.1460936121.git.jerry.hoemann@hpe.com>
 <CAPcyv4jiaoYnMi60ThWyeKVxj-3cWfd6ZgZq9Ot4Qfe4gXmvUQ@mail.gmail.com>
 <20160420174105.GC29474@tevye.fc.hp.com>
 <CAPcyv4iqcaaB+S-1ZMqq+nFCNsiWgs0K8hRCEoTqOzhTnA5vVA@mail.gmail.com>
 <20160421165235.GA115325@tevye.fc.hp.com>
 <CAPcyv4j5FVQY+QVgS640RFFG1vn9UidG0F9DcayoYNSTPqeE+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4j5FVQY+QVgS640RFFG1vn9UidG0F9DcayoYNSTPqeE+Q@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: Jerry.Hoemann@hpe.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 21, 2016 at 11:18:40AM -0700, Dan Williams wrote:
> On Thu, Apr 21, 2016 at 9:52 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> > On Thu, Apr 21, 2016 at 04:52:17AM -0700, Dan Williams wrote:
> >> On Wed, Apr 20, 2016 at 10:41 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> >> > On Tue, Apr 19, 2016 at 10:45:48AM -0700, Dan Williams wrote:
> >> >> On Sun, Apr 17, 2016 at 4:38 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> >         }
> >
> > -       for (i = ND_CMD_SMART; i <= ND_CMD_VENDOR; i++)
> > +       if (!determine_uuid(adev_dimm->handle, nfit_cmd_family_tbl,
> > +                                                       &nfit_mem->dsm_uuid))
> > +               return force_enable_dimms ? 0 : -ENODEV;
> > +
> > +       uuid = nfit_mem->dsm_uuid;
> > +       for (i = 0; i <= ND_MAX_CMD; i++)
> >                 if (acpi_check_dsm(adev_dimm->handle, uuid, 1, 1ULL << i))
> >                         set_bit(i, &nfit_mem->dsm_mask);
> >
> 
> This is confusing the ND_CMD function number space with DSMs.  We

  Yes, should have called it something like ND_MAX_DSM_FUN_IDX.

  I am looking at basing it off of bits in specified bits like below.

> already know the possible commands that may be supported because they
> are specified per-family.  This goes back to my other request to limit
> the kernel to only handling known valid function numbers, i.e. don't
> probe for known invalid functions.
> 
> For_example:
> 
> unsigned long family_mask = nfit_cmd_family_tbl[family_id].family_mask;
> 
> for_each_set_bit(i, &family_mask, BITS_PER_LONG)
>     if (acpi_check_dsm(adev_dimm->handle, uuid, 1, 1ULL << i))
>         set_bit(i, &nfit_mem->dsm_mask);
> 
> Where, for example, family_mask is statically initialized to 0x1ff in
> the Intel case.
> 
> >> > I can change just
> >> >         static const char * const names[] = {
> >> > +               [ND_CMD_IMPLEMENTED] = "cmd_mask",
> >> >                 [ND_CMD_ARS_CAP] = "ars_cap",
> >> >                 [ND_CMD_ARS_START] = "ars_start",
> >> >                 [ND_CMD_ARS_STATUS] = "ars_status",
> >> > @@ -150,6 +155,7 @@ static inline const char *nvdimm_bus_cmd_name(unsigned cmd)
> >> >  static inline const char *nvdimm_cmd_name(unsigned cmd)
> >> >  {
> >> >         static const char * const names[] = {
> >> > +               [ND_CMD_IMPLEMENTED] = "cmd_mask",
> >> >
> >> > And have same effect w/o adding the full ioctl support.
> >>
> >> ...but there's no ND_IOCTL_IMPLEMENTED, so why would userspace ever
> >> care to know the name of a command it can't issue?
> >
> >
> >   I added 0 to dsm mask so a user applications could know which dsm
> >   function are actually implemented.
> 
> Right, I don't want to add an ioctl for discovering dsm_mask.

I can interpret your statement in multiple ways.

We need to be able to call the query command (function 0) in pass thru 
to support our firmware.

Now, if you're just saying you don't want to add


+#define ND_IOCTL_CMD_MASK              _IOWR(ND_IOCTL, ND_CMD_IMPLEMENTED,\
+                                       struct nd_cmd_mask)


and other associated changes in ndctl.h, that is an entirely different
and I can rework that patch.

-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
