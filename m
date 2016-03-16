Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3428.houston.hp.com (g4t3428.houston.hp.com [15.201.208.56])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EB1131A1F59
 for <linux-nvdimm@lists.01.org>; Wed, 16 Mar 2016 13:21:42 -0700 (PDT)
Date: Wed, 16 Mar 2016 14:21:20 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH v7 5/7] libnvdimm: advertise 'call_dsm' support
Message-ID: <20160316202120.GA22086@tevye.fc.hp.com>
References: <cover.1458076114.git.jerry.hoemann@hpe.com>
 <5731be3c82134d47a485ca7def099030c29decd1.1458076114.git.jerry.hoemann@hpe.com>
 <CAPcyv4jD3upVC+sgWhaNrU9U4qZi=706ya84KiC59cqRGWQPog@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jD3upVC+sgWhaNrU9U4qZi=706ya84KiC59cqRGWQPog@mail.gmail.com>
Reply-To: Jerry.Hoemann@hpe.com
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 15, 2016 at 03:08:14PM -0700, Dan Williams wrote:
> On Tue, Mar 15, 2016 at 2:32 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> > Indicate to userspace that the generic 'dsm_call' capability is
> > available for the given control device.  Over time we want to deprecate
> > the per-dsm function ioctl commands and direct everything through the
> > generic envelope.
> >
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> > ---
> >  drivers/nvdimm/core.c      | 3 +++
> >  drivers/nvdimm/dimm_devs.c | 8 +++++++-
> >  include/linux/libnvdimm.h  | 1 +
> >  3 files changed, 11 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
> > index 79646d0..9b395e5 100644
> > --- a/drivers/nvdimm/core.c
> > +++ b/drivers/nvdimm/core.c
> > @@ -253,6 +253,9 @@ static ssize_t commands_show(struct device *dev,
> >
> >         for_each_set_bit(cmd, &nd_desc->dsm_mask, BITS_PER_LONG)
> >                 len += sprintf(buf + len, "%s ", nvdimm_bus_cmd_name(cmd));
> > +       if (nd_desc->call_dsm)
> > +               len += sprintf(buf + len, "%s ",
> > +                               nvdimm_bus_cmd_name(ND_CMD_CALL));
> >         len += sprintf(buf + len, "\n");
> >         return len;
> >  }
> > diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> > index c56f882..89086d6 100644
> > --- a/drivers/nvdimm/dimm_devs.c
> > +++ b/drivers/nvdimm/dimm_devs.c
> > @@ -274,14 +274,20 @@ EXPORT_SYMBOL_GPL(nvdimm_provider_data);
> >  static ssize_t commands_show(struct device *dev,
> >                 struct device_attribute *attr, char *buf)
> >  {
> > +       struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
> >         struct nvdimm *nvdimm = to_nvdimm(dev);
> > +       struct nvdimm_bus_descriptor *nd_desc;
> >         int cmd, len = 0;
> >
> > -       if (!nvdimm->dsm_mask)
> > +       if (!nvdimm->dsm_mask || !nvdimm_bus)
> >                 return sprintf(buf, "\n");
> >
> >         for_each_set_bit(cmd, nvdimm->dsm_mask, BITS_PER_LONG)
> >                 len += sprintf(buf + len, "%s ", nvdimm_cmd_name(cmd));
> > +       nd_desc = nvdimm_bus->nd_desc;
> > +       if (nd_desc->call_dsm)
> > +               len += sprintf(buf + len, "%s ",
> > +                               nvdimm_cmd_name(ND_CMD_CALL));
> >         len += sprintf(buf + len, "\n");
> >         return len;
> >  }
> > diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> > index af31d1c..458db57 100644
> > --- a/include/linux/libnvdimm.h
> > +++ b/include/linux/libnvdimm.h
> > @@ -68,6 +68,7 @@ struct nd_mapping {
> >
> >  struct nvdimm_bus_descriptor {
> >         const struct attribute_group **attr_groups;
> > +       unsigned int call_dsm:1;
> 
> We don't need this at the bus level, only at the dimm level.  I.e
> replace dsm_mask with cmd_mask as all it refers to is the ioctls that
> the dimm interface supports where command 10 is the generic
> nd_cmd_call interface.
> 
> If you want to tell userspace which functions a dimm supports that can
> be a true "dsm_mask" exported in sysfs under the nfit/ sub-directory.
> 
> For example:
> 
>     /sys/bus/nd/devices/nmem0/commands
> 
> ...shows the base/generic nd commands supported in text format, while new
> 
>     /sys/bus/nd/devices/nmem0/nfit/dsm_mask
>     /sys/bus/nd/devices/nmem0/nfit/family
> 
> ...shares the raw bit mask of ACPI _DSM command codes.  I'd like to
> pretend that a dimm will not support multiple families even though the
> spec technically allows that.  If we're forced to cross that bridge
> down the road we can add a series of alt_familyX/ sub-directories to
> detail the other supported families per-dimm.


The above touches upon multiple things, and I'm not sure I understand
all your comments.


1. nvdimm_bus_descriptor.dsm_mask has been around for quite a while.

   I think you simply want me to rename this to cmd_mask and leave
   it in nvdimm_bus_descriptor.

   however, it is still a mask of acceptable dsm functions.  we test
   the pass thru nd_command against it.

2. nvdimm_bus_descriptor.call_dsm:1;

   This was introduced in:
	https://lists.01.org/pipermail/linux-nvdimm/2016-January/004052.html

   This flag didn't really change the system behavior.  So, I don't
   think the sense of the tests on call_dsm in core.c/commands_show() and
   dimm_devs.c/commands_show() is what you intended.

   In the respective commands_show function, I think we only want to
   call nvdimm_bus_cmd_name or nvdimm_cmd_name if and only if the underlying
   DSM matches the intel example dsm. (i.e. nvdimm_bus_cmd_name and nvdimm_cmd_name
   describes function names from the intel example dsm, not hpe's example.)

   For root commands, there is currently no divergence, so we could leave
   it as proposed, or drop it as you suggest above.

   For the non-root commands, if we're using the intel dsm, we want to call
   nvdimm_cmd_name.  But if not, then the only command available is the pass
   thru "call_dsm".

   So, I'll move a flag to the nvdimm struct and set it only if we're
   using NFIT_DEV_DIMM, not for NFIT_DEV_DIMM_N_HPE[1|2].


3.  sysfs extensions

   I had planned to do some type of extension for sysfs for passthru
   after getting basic features agreed upon.  But, i hadn't thought
   it through deeply.  As for:

	/sys/bus/nd/devices/nmem0/nfit/dsm_mask
	/sys/bus/nd/devices/nmem0/nfit/family

   Don't we want:

	/sys/bus/nd/devices/nmem0/dsm_mask
	/sys/bus/nd/devices/nmem0/family

   As the mask/family is associated with the dimm.

   Do you consider this sysfs change as a requirement for accepting the
   rest of the patch set?


   Jerry

-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
