Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hp.com (g9t5008.houston.hp.com [15.240.92.66])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 966461A1E06
 for <linux-nvdimm@lists.01.org>; Wed, 16 Mar 2016 16:32:17 -0700 (PDT)
Date: Wed, 16 Mar 2016 17:31:55 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH v7 5/7] libnvdimm: advertise 'call_dsm' support
Message-ID: <20160316233155.GA25128@tevye.fc.hp.com>
References: <cover.1458076114.git.jerry.hoemann@hpe.com>
 <5731be3c82134d47a485ca7def099030c29decd1.1458076114.git.jerry.hoemann@hpe.com>
 <CAPcyv4jD3upVC+sgWhaNrU9U4qZi=706ya84KiC59cqRGWQPog@mail.gmail.com>
 <20160316202120.GA22086@tevye.fc.hp.com>
 <CAPcyv4jSuKUv6KLCX1_cOH_GdR4ZkJRGucHAFibpNbnLo+=haA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jSuKUv6KLCX1_cOH_GdR4ZkJRGucHAFibpNbnLo+=haA@mail.gmail.com>
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

On Wed, Mar 16, 2016 at 01:47:43PM -0700, Dan Williams wrote:
> On Wed, Mar 16, 2016 at 1:21 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> > On Tue, Mar 15, 2016 at 03:08:14PM -0700, Dan Williams wrote:
> [..]
> > The above touches upon multiple things, and I'm not sure I understand
> > all your comments.
> >
> >
> > 1. nvdimm_bus_descriptor.dsm_mask has been around for quite a while.
> >
> >    I think you simply want me to rename this to cmd_mask and leave
> >    it in nvdimm_bus_descriptor.
> >
> >    however, it is still a mask of acceptable dsm functions.  we test
> >    the pass thru nd_command against it.
> >
> > 2. nvdimm_bus_descriptor.call_dsm:1;
> >
> >    This was introduced in:
> >         https://lists.01.org/pipermail/linux-nvdimm/2016-January/004052.html
> >
> >    This flag didn't really change the system behavior.  So, I don't
> >    think the sense of the tests on call_dsm in core.c/commands_show() and
> >    dimm_devs.c/commands_show() is what you intended.
> >
> >    In the respective commands_show function, I think we only want to
> >    call nvdimm_bus_cmd_name or nvdimm_cmd_name if and only if the underlying
> >    DSM matches the intel example dsm. (i.e. nvdimm_bus_cmd_name and nvdimm_cmd_name
> >    describes function names from the intel example dsm, not hpe's example.)
> >
> >    For root commands, there is currently no divergence, so we could leave
> >    it as proposed, or drop it as you suggest above.
> >
> >    For the non-root commands, if we're using the intel dsm, we want to call
> >    nvdimm_cmd_name.  But if not, then the only command available is the pass
> >    thru "call_dsm".


  The above deals with what sysfs displays.  This needs to be based
  upon the type of NVDIMM/DSM it is.  The dimms know what type it is 
  and displays the correct info.  So, are we okay with above?


> 
> This is where I think we diverge.  There's nothing stopping the kernel
> from translating a
> 
> ND_IOCTL_SET_CONFIG_DATA into an "Intel - Set Namespace Label Data" or
> "HP - NVDIMM-N Set OS data".  In all cases the kernel will want to
> intercept that command whether it comes in as the generic
> ND_IOCTL_SET_CONFIG_DATA or via the ND_IOCTL_CALL interface.

  I will get back to this point in a bit.

  The IOCTL interface is different (and i have a bug.)

  For the IOCTL interface the user app *thinks* it knows the type of
  NVDIMM it is, but the user could be wrong.

  In general, the system needs to explicitly prevent an application thinking
  its running on one type of NVDIMM/DSM from calling a function on a different
  type of NVDIMM/DSM.  And this is because function "7" might be defined
  by both DSMs but have different semantics.

  The way I was achieving this was by having UUID default to either:

                uuid = type_to_nvdimm_uuid(type);
                uuid = type_to_bus_uuid(type);

  And replacing uuid only if doing the pass thru (which required the
  user app specifying the uuid.)

  Since the different firmwares use different UUIDs, firmware will
  return error on such a mis-match and the kernel would pass error
  back to the user app.

  I messed this up in my patch set last week.  I switched to using
  the actual UUID on the dimm as default and not switching the one
  passed in.  This is bad and I will fix.

  nfit.c/known_nvdimm_type() needs to do more than validate the type,
  it needs to return the uuid.  I'll change this to something like
  family_to_uuid.


> 
> >    So, I'll move a flag to the nvdimm struct and set it only if we're
> >    using NFIT_DEV_DIMM, not for NFIT_DEV_DIMM_N_HPE[1|2].
> 
> NFIT_DEV_DIMM_N_HPE* can support more than just ND_IOCTL_CALL.  Having
> the kernel do ND_IOCTL_<GENERIC> conversion to the family specific
> command allows old ndctl binaries to run against new kernels.


  I think you're making the same mistake I made when I first
  started on this.  While the 0.84 NVDIMM-N spec looks like
  a super-set of the Intel Example DSM, it is not.

  There are some frustratingly small differences in the semantics
  of the calls.  So, in general we can't assume the existing ND_IOCTL_*
  calls will do what you expect if called on NVDIMM-N.
  Some will, some won't.  This is unfortunate.

  Now for HP - NVDIMM-N Set OS data, I think the semantics are
  the same, but the current implmentation of config data is very
  limited in size (much smaller than ND_LABEL_MIN_SIZE.)  So, the
  kernel isn't using it.   But in general there is a potential need
  to intercept calls, but my changes don't address that at this time.


> 
> > 3.  sysfs extensions
> >
> >    I had planned to do some type of extension for sysfs for passthru
> >    after getting basic features agreed upon.  But, i hadn't thought
> >    it through deeply.  As for:
> >
> >         /sys/bus/nd/devices/nmem0/nfit/dsm_mask
> >         /sys/bus/nd/devices/nmem0/nfit/family
> >
> >    Don't we want:
> >
> >         /sys/bus/nd/devices/nmem0/dsm_mask
> >         /sys/bus/nd/devices/nmem0/family
> >
> >    As the mask/family is associated with the dimm.
> 
> Hmm, I think more like this:
> 
>          /sys/bus/nd/devices/nmem0/nfit/dsm_mask
>          /sys/bus/nd/devices/nmem0/family
> 
> The mask is associated with the dimm, but it is ACPI specific.
> However, you're right that the family id is truly generic and should
> be at the dimm level because the family type could span across
> non-ACPI architectures.
> 
> >    Do you consider this sysfs change as a requirement for accepting the
> >    rest of the patch set?
> 
> You can defer it to me.  I need the family information for ndctl to
> start converting from the old-style to the new-style ioctl interface.

-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
