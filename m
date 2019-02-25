Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from esa1.fujitsucc.c3s2.iphmx.com (esa1.fujitsucc.c3s2.iphmx.com
 [68.232.152.245])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C514201B0386
 for <linux-nvdimm@lists.01.org>; Sun, 24 Feb 2019 20:48:25 -0800 (PST)
From: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
Subject: RE: [ndctl PATCH v2 4/4] ndctl, monitor: support NVDIMM_FAMILY_HYPERV
Date: Mon, 25 Feb 2019 04:48:18 +0000
Message-ID: <OSAPR01MB4993163079F35EEF06DFBB44F77A0@OSAPR01MB4993.jpnprd01.prod.outlook.com>
References: <PU1P153MB01691E80896E9EAA0C8245EDBF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <OSBPR01MB50009900A5FE2E8588AA6367F77E0@OSBPR01MB5000.jpnprd01.prod.outlook.com>
 <PU1P153MB016950BB76440DE9F413A615BF7E0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB016950BB76440DE9F413A615BF7E0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Content-Language: ja-JP
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
To: 'Dexuan Cui' <decui@microsoft.com>, Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Michael Kelley <mikelley@microsoft.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-ID: <linux-nvdimm@lists.01.org>

> 
> Hi Qi,
> Generally speaking, I agree with you, but here the fact is that we can only monitor this
> one single event "dimm-health-state" for Hyper-V Virtual NVDIMM, and the other
> events are meaningless for Hyper-V Virtual NVDIMM, as they're not supported by
> Hyper-V Virtual NVDIMM.
> 
> So, if the user specifies more events than just "dimm-health-state", or the user doesn't
> specify "dimm-health-state", it's reasonable to force monitor.event_flags to equal to
> ND_EVENT_HEALTH_STATE, and I explicitly print a warning.
> 
> The line "monitor.event_flags = ND_EVENT_HEALTH_STATE" only runs in a Linux VM
> running on Hyper-V. It can't adversely affect bare metal cases. In a Linux VM on
> Hyper-V, all the NVDIMMs appearing in the VM are Hyper-V Virtual NVDIMMs.
> 
> A physical NVDIMM can't be directly passed through to a VM and the hypervisors (e.g.,
> Xen, KVM, Hyper-V, Qemu, etc.) have to virtualize it to make it available to a VM. In a
> VM, the NVDIMM_FAMILY is NVDIMM_FAMILY_HYPERV only when the VM runs on
> Hyper-V.
> 
> So I think we should be good. :-)
> 
> Thanks,
> -- Dexuan

Hi Dexuan,

Thanks for your explanation.
I think at least we should document it into man page, so that the users could know that their options may be modified by monitor.
Though I have a little concern about that there may be other events for Hyper-V Virtual NVDIMM can be monitored in future...

Thanks
 Qi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
