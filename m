Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t5425.austin.hp.com (g1t5425.austin.hp.com [15.216.225.55])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0E0751A1F31
 for <linux-nvdimm@lists.01.org>; Fri, 18 Mar 2016 16:27:29 -0700 (PDT)
Date: Fri, 18 Mar 2016 17:27:05 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH v7 5/7] libnvdimm: advertise 'call_dsm' support
Message-ID: <20160318232705.GD71733@tevye.fc.hp.com>
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

[..]

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

  We could abstract it to "cmd_mask" and put it off nmem0 like
  family.  Same reasoning should apply.  Just something to think
  about.


-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
