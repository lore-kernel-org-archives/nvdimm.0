Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7114307AF2
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 14:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773929513; cv=none; b=f0DQOaGdlYzOvBYSUpzj8p6fsy4rI7EGFyN3Lq8KD586av4b2TNIMt5Ng6lLCWWx0X3CB8dhNXZT8vjkYyvC6jDfHNbeVsX0l9cUGpvKZfrf85THrINcpC0sYTQcSHfZ2cbw+ZVdgKUV3VA2XUG15LZnp2IjanGdj+HfYK5pu+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773929513; c=relaxed/simple;
	bh=79ChlbKPzsVUSS+lZ1jNyCbZerEKW93l0yflC40s7Mg=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=njQdnv+pVoZou4ifu95bY7LEXsmQ7WEX+26qaaJaiAAHEf6koIY4o7Fi8dLeW9tEnuad/NyAJWwtJbmtAoYoKsWIgvKJdifBt9+ar584KGSYuwO3ErKcx58xmEOlmtfCoxLDBeDtH+Zl6jE5fguzaNlxgRPJm/qcIhl6DJhYaqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fc6zq3khwzJ467c;
	Thu, 19 Mar 2026 22:10:47 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id EF6904056E;
	Thu, 19 Mar 2026 22:11:46 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 19 Mar
 2026 14:11:45 +0000
Date: Thu, 19 Mar 2026 14:11:44 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Alison Schofield <alison.schofield@intel.com>
CC: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Vishal Verma
	<vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, Yazen Ghannam <yazen.ghannam@amd.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, "Matthew
 Wilcox" <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Rafael J . Wysocki"
	<rafael@kernel.org>, Len Brown <len.brown@intel.com>, Pavel Machek
	<pavel@kernel.org>, Li Ming <ming.li@zohomail.com>, Jeff Johnson
	<jeff.johnson@oss.qualcomm.com>, Ying Huang <huang.ying.caritas@gmail.com>,
	Yao Xingtao <yaoxt.fnst@fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Nathan Fontenot
	<nathan.fontenot@amd.com>, Terry Bowman <terry.bowman@amd.com>, Robert
 Richter <rrichter@amd.com>, "Benjamin Cheatham" <benjamin.cheatham@amd.com>,
	Zhijian Li <lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>, Tomasz
 Wolski <tomasz.wolski@fujitsu.com>
Subject: Re: [PATCH v7 3/7] dax/cxl, hmem: Initialize hmem early and defer
 dax_cxl binding
Message-ID: <20260319141144.00005af3@huawei.com>
In-Reply-To: <abuOLq6bMPa0nNAL@aschofie-mobl2.lan>
References: <20260319011500.241426-1-Smita.KoralahalliChannabasappa@amd.com>
	<20260319011500.241426-4-Smita.KoralahalliChannabasappa@amd.com>
	<abuOLq6bMPa0nNAL@aschofie-mobl2.lan>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Wed, 18 Mar 2026 22:48:30 -0700
Alison Schofield <alison.schofield@intel.com> wrote:

> On Thu, Mar 19, 2026 at 01:14:56AM +0000, Smita Koralahalli wrote:
> > From: Dan Williams <dan.j.williams@intel.com>
> > 
> > Move hmem/ earlier in the dax Makefile so that hmem_init() runs before
> > dax_cxl.
> > 
> > In addition, defer registration of the dax_cxl driver to a workqueue
> > instead of using module_cxl_driver(). This ensures that dax_hmem has
> > an opportunity to initialize and register its deferred callback and make
> > ownership decisions before dax_cxl begins probing and claiming Soft
> > Reserved ranges.
> > 
> > Mark the dax_cxl driver as PROBE_PREFER_ASYNCHRONOUS so its probe runs
> > out of line from other synchronous probing avoiding ordering
> > dependencies while coordinating ownership decisions with dax_hmem.  
> 
> Hi Smita,
> 
> Replying to this patch, as it's my best guess as to why I may be
> seeing this WARN when I modprobe cxl-test.

Not patch 6?  dax_hmem_flush_work() is in there + it doesn't
use a static declaration of the work items.

I've not figure out the path yet but it looks more suspicious to me
than this path.

Jonathan

> 
> We are able to pass all the CXL unit tests because it is only that
> first load that causes the WARN. All subsequent reloads of cxl-test
> do not unload dax_cxl and dax_hmem so they chug happily along.
> 
> I can reproduce by unloading each piece before reloading cxl-test
> # modprobe -r cxl-test
> # modprobe -r dax_cxl
> # modprobe -r dax_hmem
> # modprobe cxl-test
> and the WARN repeats.
> 
> Guessing you may recognize what is going on. Let me know if I can
> try anything else out.
> 
> 
> # dmesg (trimmed to just the init calls)
> [   34.229033] calling  fwctl_init+0x0/0xff0 [fwctl] @ 1057
> [   34.230616] initcall fwctl_init+0x0/0xff0 [fwctl] returned 0 after 186 usecs
> [   34.257096] calling  cxl_core_init+0x0/0x100 [cxl_core] @ 1057
> [   34.258395] initcall cxl_core_init+0x0/0x100 [cxl_core] returned 0 after 538 usecs
> [   34.264170] calling  cxl_port_init+0x0/0xff0 [cxl_port] @ 1057
> [   34.264982] initcall cxl_port_init+0x0/0xff0 [cxl_port] returned 0 after 110 usecs
> [   34.268058] calling  cxl_mem_driver_init+0x0/0xff0 [cxl_mem] @ 1057
> [   34.268743] initcall cxl_mem_driver_init+0x0/0xff0 [cxl_mem] returned 0 after 110 usecs
> [   34.274670] calling  cxl_pmem_init+0x0/0xff0 [cxl_pmem] @ 1057
> [   34.277835] initcall cxl_pmem_init+0x0/0xff0 [cxl_pmem] returned 0 after 1671 usecs
> [   34.285807] calling  cxl_acpi_init+0x0/0xff0 [cxl_acpi] @ 1057
> [   34.287105] initcall cxl_acpi_init+0x0/0xff0 [cxl_acpi] returned 0 after 262 usecs
> [   34.292967] calling  cxl_test_init+0x0/0xff0 [cxl_test] @ 1057
> [   34.339841] initcall cxl_test_init+0x0/0xff0 [cxl_test] returned 0 after 45832 usecs
> [   34.342259] calling  cxl_mock_mem_driver_init+0x0/0xff0 [cxl_mock_mem] @ 1063
> [   34.343459] initcall cxl_mock_mem_driver_init+0x0/0xff0 [cxl_mock_mem] returned 0 after 356 usecs
> [   34.658602] calling  dax_hmem_init+0x0/0xff0 [dax_hmem] @ 1059
> [   34.670106] calling  cxl_pci_driver_init+0x0/0xff0 [cxl_pci] @ 1100
> [   34.671023] initcall cxl_pci_driver_init+0x0/0xff0 [cxl_pci] returned 0 after 197 usecs
> [   34.673051] initcall dax_hmem_init+0x0/0xff0 [dax_hmem] returned 0 after 2225 usecs
> [   34.676011] calling  cxl_dax_region_init+0x0/0xff0 [dax_cxl] @ 1059
> [   34.676856] ------------[ cut here ]------------
> [   34.677533] WARNING: kernel/workqueue.c:4289 at __flush_work+0x4f9/0x550, CPU#3: kworker/3:2/136
> [   34.678596] Modules linked in: dax_cxl(+) cxl_pci dax_hmem cxl_mock_mem(O) cxl_test(O) cxl_acpi(O) cxl_pmem(O) cxl_mem(O) cxl_port(O) cxl_mock(O) cxl_core(O) fwctl nd_pmem nd_btt dax_pmem nfit nd_e820 libnvdimm
> [   34.680632] initcall cxl_dax_region_init+0x0/0xff0 [dax_cxl] returned 0 after 3842 usecs
> [   34.680918] CPU: 3 UID: 0 PID: 136 Comm: kworker/3:2 Tainted: G           O        7.0.0-rc4+ #156 PREEMPT(full) 
> [   34.684368] Tainted: [O]=OOT_MODULE
> [   34.684993] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
> [   34.686098] Workqueue: events_long cxl_dax_region_driver_register [dax_cxl]
> [   34.687108] RIP: 0010:__flush_work+0x4f9/0x550
> 
> That addr is this line in flush_work()
>         if (WARN_ON(!work->func))
>                 return false;
> 
> 
> [   34.687811] Code: ff 49 8b 45 00 49 8b 55 08 89 c7 48 c1 e8 04 83 e7 08 83 e0 0f 83 cf 02 49 0f ba 6d 00 03 e9 a1 fc ff ff 0f 0b e9 e6 fe ff ff <0f> 0b e9 df fe ff ff e8 9b 48 15 01 85 c0 0f 84 26 ff ff ff 80 3d
> [   34.690107] RSP: 0018:ffffc900020b7cf8 EFLAGS: 00010246
> [   34.690673] RAX: 0000000000000000 RBX: ffffffffa0ea2088 RCX: ffff8880088b2b78
> [   34.691388] RDX: 00000000834fb194 RSI: 0000000000000000 RDI: ffffffffa0ea2088
> [   34.692135] RBP: ffffc900020b7de0 R08: 0000000031ab93b0 R09: 00000000effb42e8
> [   34.692876] R10: 000000008effb42e R11: 0000000000000000 R12: ffff88807d9bb340
> [   34.693588] R13: ffffffffa0ea2088 R14: ffffffffa0ed2020 R15: 0000000000000001
> [   34.694358] FS:  0000000000000000(0000) GS:ffff8880fa45f000(0000) knlGS:0000000000000000
> [   34.695179] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   34.695775] CR2: 00007fe888b4e34c CR3: 00000000090ed004 CR4: 0000000000370ef0
> [   34.696494] Call Trace:
> [   34.696889]  <TASK>
> [   34.697238]  ? __lock_acquire+0xb08/0x2930
> [   34.697730]  ? __this_cpu_preempt_check+0x13/0x20
> [   34.698277]  flush_work+0x17/0x30
> [   34.698705]  dax_hmem_flush_work+0x10/0x20 [dax_hmem]
> [   34.699270]  cxl_dax_region_driver_register+0x9/0x30 [dax_cxl]
> [   34.699943]  process_one_work+0x203/0x6c0
> [   34.700452]  worker_thread+0x197/0x350
> [   34.700942]  ? __pfx_worker_thread+0x10/0x10
> [   34.701455]  kthread+0x108/0x140
> [   34.701915]  ? __pfx_kthread+0x10/0x10
> [   34.702396]  ret_from_fork+0x28a/0x310
> [   34.702880]  ? __pfx_kthread+0x10/0x10
> [   34.703363]  ret_from_fork_asm+0x1a/0x30
> [   34.703872]  </TASK>
> [   34.704227] irq event stamp: 11015
> [   34.704656] hardirqs last  enabled at (11025): [<ffffffff813486de>] __up_console_sem+0x5e/0x80
> [   34.705493] hardirqs last disabled at (11036): [<ffffffff813486c3>] __up_console_sem+0x43/0x80
> [   34.706354] softirqs last  enabled at (10500): [<ffffffff812ab9f3>] __irq_exit_rcu+0xc3/0x120
> [   34.707197] softirqs last disabled at (10495): [<ffffffff812ab9f3>] __irq_exit_rcu+0xc3/0x120
> [   34.708015] ---[ end trace 0000000000000000 ]---
> [   34.752127] calling  dax_init+0x0/0xff0 [device_dax] @ 1089
> [   34.754006] initcall dax_init+0x0/0xff0 [device_dax] returned 0 after 422 usecs
> [   34.759609] calling  dax_kmem_init+0x0/0xff0 [kmem] @ 1089
> [   37.338377] initcall dax_kmem_init+0x0/0xff0 [kmem] returned 0 after 2577658 usecs
> 
> 
> > 
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> > ---
> >  drivers/dax/Makefile |  3 +--
> >  drivers/dax/cxl.c    | 27 ++++++++++++++++++++++++++-
> >  2 files changed, 27 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/dax/Makefile b/drivers/dax/Makefile
> > index 5ed5c39857c8..70e996bf1526 100644
> > --- a/drivers/dax/Makefile
> > +++ b/drivers/dax/Makefile
> > @@ -1,4 +1,5 @@
> >  # SPDX-License-Identifier: GPL-2.0
> > +obj-y += hmem/
> >  obj-$(CONFIG_DAX) += dax.o
> >  obj-$(CONFIG_DEV_DAX) += device_dax.o
> >  obj-$(CONFIG_DEV_DAX_KMEM) += kmem.o
> > @@ -10,5 +11,3 @@ dax-y += bus.o
> >  device_dax-y := device.o
> >  dax_pmem-y := pmem.o
> >  dax_cxl-y := cxl.o
> > -
> > -obj-y += hmem/
> > diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
> > index 13cd94d32ff7..a2136adfa186 100644
> > --- a/drivers/dax/cxl.c
> > +++ b/drivers/dax/cxl.c
> > @@ -38,10 +38,35 @@ static struct cxl_driver cxl_dax_region_driver = {
> >  	.id = CXL_DEVICE_DAX_REGION,
> >  	.drv = {
> >  		.suppress_bind_attrs = true,
> > +		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
> >  	},
> >  };
> >  
> > -module_cxl_driver(cxl_dax_region_driver);
> > +static void cxl_dax_region_driver_register(struct work_struct *work)
> > +{
> > +	cxl_driver_register(&cxl_dax_region_driver);
> > +}
> > +
> > +static DECLARE_WORK(cxl_dax_region_driver_work, cxl_dax_region_driver_register);
> > +
> > +static int __init cxl_dax_region_init(void)
> > +{
> > +	/*
> > +	 * Need to resolve a race with dax_hmem wanting to drive regions
> > +	 * instead of CXL
> > +	 */
> > +	queue_work(system_long_wq, &cxl_dax_region_driver_work);
> > +	return 0;
> > +}
> > +module_init(cxl_dax_region_init);
> > +
> > +static void __exit cxl_dax_region_exit(void)
> > +{
> > +	flush_work(&cxl_dax_region_driver_work);
> > +	cxl_driver_unregister(&cxl_dax_region_driver);
> > +}
> > +module_exit(cxl_dax_region_exit);
> > +
> >  MODULE_ALIAS_CXL(CXL_DEVICE_DAX_REGION);
> >  MODULE_DESCRIPTION("CXL DAX: direct access to CXL regions");
> >  MODULE_LICENSE("GPL");
> > -- 
> > 2.17.1
> > 
> >   
> 

