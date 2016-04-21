Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t5424.austin.hp.com (g1t5424.austin.hp.com [15.216.225.54])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0B4061A2221
 for <linux-nvdimm@lists.01.org>; Thu, 21 Apr 2016 09:52:38 -0700 (PDT)
Date: Thu, 21 Apr 2016 10:52:35 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [RFC v9 5/5] nvdimm: Add ioctl to return command mask.
Message-ID: <20160421165235.GA115325@tevye.fc.hp.com>
References: <cover.1460936121.git.jerry.hoemann@hpe.com>
 <9f04df3b80c68dd6406cfee5ce11a2cd8ed33b64.1460936121.git.jerry.hoemann@hpe.com>
 <CAPcyv4jiaoYnMi60ThWyeKVxj-3cWfd6ZgZq9Ot4Qfe4gXmvUQ@mail.gmail.com>
 <20160420174105.GC29474@tevye.fc.hp.com>
 <CAPcyv4iqcaaB+S-1ZMqq+nFCNsiWgs0K8hRCEoTqOzhTnA5vVA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iqcaaB+S-1ZMqq+nFCNsiWgs0K8hRCEoTqOzhTnA5vVA@mail.gmail.com>
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

On Thu, Apr 21, 2016 at 04:52:17AM -0700, Dan Williams wrote:
> On Wed, Apr 20, 2016 at 10:41 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> > On Tue, Apr 19, 2016 at 10:45:48AM -0700, Dan Williams wrote:
> >> On Sun, Apr 17, 2016 at 4:38 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> >> > The pass thru calls return command mask.  Previously, bit zero
> >> > wasn't part of command mask, but as it is now, this left commands_show
> >> > displaying "unknown" for function zero.  Add an ioctl interface
> >> > to return command mask.
> >> >
> >> > Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> >> > ---
> >> >  drivers/nvdimm/bus.c       | 10 ++++++++--
> >> >  include/uapi/linux/ndctl.h |  9 +++++++++
> >> >  2 files changed, 17 insertions(+), 2 deletions(-)
> >>
> >> Let's not add yet another ioctl for this...  just add a 'dsm_mask'
> >> attribute to the nfit_mem device in acpi_nfit_dimm_attributes.
> >
> > I don't understand this comment.
> 
> So, I'm trying to find the change that made bit zero part of the
> command mask, I think that is the source of the confusion.  Why do we
> need to ever set bit zero in the cmd_mask?
> 

In patch set 
[RFC v9 1/5] nvdimm: Add IOCTL pass thru functions


 static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
                struct nfit_mem *nfit_mem, u32 device_handle)
 {
        struct acpi_device *adev, *adev_dimm;
        struct device *dev = acpi_desc->dev;
-       const u8 *uuid = to_nfit_uuid(NFIT_DEV_DIMM);
+       const u8 *uuid;
        int i;
 
        nfit_mem->dsm_mask = acpi_desc->dimm_dsm_force_en;
@@ -939,7 +1018,12 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
                return force_enable_dimms ? 0 : -ENODEV;
        }
 
-       for (i = ND_CMD_SMART; i <= ND_CMD_VENDOR; i++)
+       if (!determine_uuid(adev_dimm->handle, nfit_cmd_family_tbl,
+                                                       &nfit_mem->dsm_uuid))
+               return force_enable_dimms ? 0 : -ENODEV;
+
+       uuid = nfit_mem->dsm_uuid;
+       for (i = 0; i <= ND_MAX_CMD; i++)
                if (acpi_check_dsm(adev_dimm->handle, uuid, 1, 1ULL << i))
                        set_bit(i, &nfit_mem->dsm_mask);
 


> > I can change just
> >         static const char * const names[] = {
> > +               [ND_CMD_IMPLEMENTED] = "cmd_mask",
> >                 [ND_CMD_ARS_CAP] = "ars_cap",
> >                 [ND_CMD_ARS_START] = "ars_start",
> >                 [ND_CMD_ARS_STATUS] = "ars_status",
> > @@ -150,6 +155,7 @@ static inline const char *nvdimm_bus_cmd_name(unsigned cmd)
> >  static inline const char *nvdimm_cmd_name(unsigned cmd)
> >  {
> >         static const char * const names[] = {
> > +               [ND_CMD_IMPLEMENTED] = "cmd_mask",
> >
> > And have same effect w/o adding the full ioctl support.
> 
> ...but there's no ND_IOCTL_IMPLEMENTED, so why would userspace ever
> care to know the name of a command it can't issue?


  I added 0 to dsm mask so a user applications could know which dsm
  function are actually implemented.

  The architecture defines the function in the DSM,  but a particular
  implementation may or may not implement all functions of a dsm.
  The dsm mask tells which function the FW implements.  And yes, we
  have different SKUs and they don't all implement all/same functions.

  A side effect of having "0" in the dsm_mask is that when
  commands_show executes:


        for_each_set_bit(cmd, &nvdimm->cmd_mask, BITS_PER_LONG)
                len += sprintf(buf + len, "%s ", nvdimm_cmd_name(cmd));
        len += sprintf(buf + len, "\n");

  The value of names[ND_CMD_IMPLEMENTED] is printed.   Currently that
  value is "unknown" which I didn't think looked correct.  Hence, the
  change.

  I my other patch, I am constructing cmd_mask as either
	(1<<ND_CMD)|dsm_mask  -or-
	(1<<ND_CMD)
  depending upon UUID.

  Now construction of cmd_mask is subject of an earlier patch set.


> 
> > But I don't see how modifying acpi_nfit_dimm_attributes affects what
> > commands show will display.
> 
> It doesn't, but I was wondering if you were trying to add support for
> discovering the dsm_mask via an ioctl.
> 
> > Are you asking me to also add a new attribute to sysfs to display the
> > command mask?
> 
> Yes, I think it would be useful to communicate the *dsm_mask* in
> sysfs, but the cmd_mask can stay as is without adding an
> ND_CMD_IMPLEMENTED entry.


  I think this is a good idea and am completely happy to do it,  but
  want to defer this until after we get basic functionality completed.



-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
