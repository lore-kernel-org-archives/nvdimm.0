Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B8AC4211E0931
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 11:28:42 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v2 4/4] ndctl, monitor: support NVDIMM_FAMILY_HYPERV
Date: Fri, 22 Mar 2019 18:28:39 +0000
Message-ID: <837eed30b0da59f91e5114aad97e919068a077e8.camel@intel.com>
References: <PU1P153MB01691E80896E9EAA0C8245EDBF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <9876fd8a491e339f2f41a47e2195d354bf0d5fb2.camel@intel.com>
 <PU1P153MB0169CA436F52268DD2BEF745BF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <PU1P153MB0169F3CEDB7C2F4965450BB6BF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4hVZLW2OSMZ9NqqsQWMg7vxyS9J1ekDZW8G44cmD9_YCw@mail.gmail.com>
 <PU1P153MB0169A7A65DB3A54040DE291ABF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4hM_DTcMJdWhWbtPFfVH_V-kYxXSSCg=MQZLoxVka=Mng@mail.gmail.com>
 <PU1P153MB01696DB78FF62FAE07473594BF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4h4tAydacTbmZRKy7hmTqWTM22r6hD+Ucm_f3H2tQUm3g@mail.gmail.com>
 <PU1P153MB01696BBE1F8859624E5452B0BF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB01696BBE1F8859624E5452B0BF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Content-Language: en-US
Content-ID: <4BB13D43EB88944CA05BD07F7A69BC15@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "decui@microsoft.com" <decui@microsoft.com>
Cc: "mikelley@microsoft.com" <mikelley@microsoft.com>, "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Fri, 2019-03-22 at 17:55 +0000, Dexuan Cui wrote:
> > From: Dan Williams <dan.j.williams@intel.com>
> > Sent: Thursday, March 21, 2019 11:12 PM
> > To: Dexuan Cui <decui@microsoft.com>
> > 
> > On Thu, Mar 21, 2019 at 11:03 PM Dexuan Cui <decui@microsoft.com> wrote:
> > > > From: Dan Williams <dan.j.williams@intel.com>
> > > > Sent: Thursday, March 21, 2019 10:37 PM
> > > > 
> > > > No, I think you misunderstand. Hyper-V implements "function-1",
> > > > "command-1" support can be emulated. The request is to translate the
> > > > Hyper-V function-1 payload into the command-1 payload format.
> > > 
> > > Then, yes, I think so. The first 2 patches of this patchset do the translation:
> > > 
> > > [ndctl,v2,1/4] libndctl: add support for NVDIMM_FAMILY_HYPERV's _DSM
> > Function 1
> > > [ndctl,v2,2/4] libndctl: NVDIMM_FAMILY_HYPERV:
> > add .smart_get_shutdown_count (Function 2)
> > > The problem is how to skip the checkings in ndctl/monitor.c: filter_dimm() on
> > Hyper-V.
> > > If we return early in filter_dimm(), mfa->num_dimm will be zero, then
> > monitor_event()
> > > can't be called, and we have no chance to monitor the events and do the
> > translation.
> > 
> > I'd rather change ndctl_dimm_cmd_is_supported() to call back into a
> > dimm-op so that the Hyper-V implementation can say "yes, I support
> > (emulate) the necessary monitor commands".
> 
> Hi Dan,
> Then we need to add a new dimm-op monitor_supported(), and change 
> ndctl/lib/intel.c and ndctl/lib/hyper.c to implement the new dimm-op, and we
> need to change the common code, i.e. ndctl_dimm_cmd_is_supported(), to use
> this new dimm-op.
> 
> If this sounds reasonable to you and Verma, I'll try to make a patchset for you
> to review.

Yep this approach sounds good to me!

> 
> Thanks,
> -- Dexuan

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
