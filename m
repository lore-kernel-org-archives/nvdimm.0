Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7653A202E5324
 for <linux-nvdimm@lists.01.org>; Wed, 13 Feb 2019 22:49:26 -0800 (PST)
Date: Thu, 14 Feb 2019 01:49:25 -0500 (EST)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <590537850.947438.1550126965817.JavaMail.zimbra@redhat.com>
In-Reply-To: <597B109EC20B76429F71A8A97770610D12A200FA@ALA-MBD.corp.ad.wrs.com>
References: <597B109EC20B76429F71A8A97770610D12A200FA@ALA-MBD.corp.ad.wrs.com>
Subject: Re: Is nvdimm driver RT compatible?
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
To: Yongxin Liu <Yongxin.Liu@windriver.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>


Hi Yongxin,

> 
> Hi experts,
> 
> Could anyone tell me whether Linux nvdimm driver is RT compatible?
> 
> When I was testing PMEM performance with fio using the following command, I
> got calltrace below.
> 
> # fio -filename=/dev/pmem0s -direct=1 -iodepth 1 -thread -rw=randrw
> -rwmixread=70 -ioengine=psync -bs=16k -size=1G -numjobs=30 -runtime=100
> -group_reporting -name=mytest
> 
>     BUG: scheduling while atomic: fio/2514/0x00000002
>     Modules linked in: intel_rapl nd_pmem nd_btt skx_edac iTCO_wdt
>     iTCO_vendor_support intel_powerclamp coretemp
>     crct10dif_pclmul crct10dif_common aesni_intel aes_x86_64 crypto_simd
>     cryptd i40e nvme glue_helper nvme_core lpc_ich i2c_i801 nfit
>     pcc_cpufreq wmi libnvdimm acpi_pad
>     acpi_power_meter
>     Preemption disabled at:
>     [<ffffffffc03608d9>] nd_region_acquire_lane+0x19/0x80 [libnvdimm]
>     CPU: 44 PID: 2514 Comm: fio Tainted: G        W
>     4.18.20-rt8-preempt-rt #1
>     Call Trace:
>      dump_stack+0x4f/0x6a
>      ? nd_region_acquire_lane+0x19/0x80 [libnvdimm]
>      __schedule_bug.cold.17+0x38/0x55
>      __schedule+0x484/0x6c0
>      ? _raw_spin_lock+0x17/0x40
>      schedule+0x3d/0xe0
>      rt_spin_lock_slowlock_locked+0x118/0x2a0
>      rt_spin_lock_slowlock+0x57/0x90
>      rt_spin_lock+0x52/0x60
>      btt_write_pg.isra.16+0x280/0x4b0 [nd_btt]
>      btt_make_request+0x1b1/0x320 [nd_btt]
>      generic_make_request+0x1dc/0x3f0
>      submit_bio+0x49/0x140
> 
> nd_region_acquire_lane() disables preemption with get_cpu() which causes
> "scheduling while atomic" spews on RT.
> 
> Is it safe to replace get_cpu()/put_cpu() with
> get_cpu_light()/put_cpu_light() in
> nd_region_acquire_lane()/nd_region_release_lane()?

get_cpu disables preemption on a core and get_cpu_light will just avoid
task migration across the cores. If we change this to get/put_cpu_light
I think there is possibility of a race here.

> After this replacement, the codes protected by
> nd_region_release_lane/nd_region_release_lane would become pre-emptible.
> So are these codes reentrant?

Another thing I see is when get_cpu is called in "nd_region_acquire_lane"
there is no corresponding call for "put_cpu" in same function. This is
called only in "nd_region_release_lane". It means for the duration of
these calls preemption will be disabled. 

Here, we cannot change preemption disable to migration disable for mainline.
As there is code which can result in race.

For RT only patchset as well, IIUC will have same problem as there is spin_lock 
protection on a condition and path before/without spinlock may also race.
We can have something like local_lock_* =>  local_lock_cpu

This are my two cents.

Thanks,
Pankaj

> 
> 
> 
> Thanks,
> Yongxin
> 
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
