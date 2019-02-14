Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1EE2820081A65
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 12:45:21 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id u16so12859605otk.8
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 12:45:21 -0800 (PST)
MIME-Version: 1.0
References: <597B109EC20B76429F71A8A97770610D12A200FA@ALA-MBD.corp.ad.wrs.com>
 <590537850.947438.1550126965817.JavaMail.zimbra@redhat.com>
In-Reply-To: <590537850.947438.1550126965817.JavaMail.zimbra@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Feb 2019 12:45:09 -0800
Message-ID: <CAPcyv4j=E+upkn=eP=w2KMHrb7Mv3-ov=j_S4pnA_HjbRF42Sw@mail.gmail.com>
Subject: Re: Is nvdimm driver RT compatible?
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
To: Pankaj Gupta <pagupta@redhat.com>
Cc: Yongxin Liu <Yongxin.Liu@windriver.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 13, 2019 at 10:50 PM Pankaj Gupta <pagupta@redhat.com> wrote:
>
>
> Hi Yongxin,
>
> >
> > Hi experts,
> >
> > Could anyone tell me whether Linux nvdimm driver is RT compatible?
> >
> > When I was testing PMEM performance with fio using the following command, I
> > got calltrace below.
> >
> > # fio -filename=/dev/pmem0s -direct=1 -iodepth 1 -thread -rw=randrw
> > -rwmixread=70 -ioengine=psync -bs=16k -size=1G -numjobs=30 -runtime=100
> > -group_reporting -name=mytest
> >
> >     BUG: scheduling while atomic: fio/2514/0x00000002
> >     Modules linked in: intel_rapl nd_pmem nd_btt skx_edac iTCO_wdt
> >     iTCO_vendor_support intel_powerclamp coretemp
> >     crct10dif_pclmul crct10dif_common aesni_intel aes_x86_64 crypto_simd
> >     cryptd i40e nvme glue_helper nvme_core lpc_ich i2c_i801 nfit
> >     pcc_cpufreq wmi libnvdimm acpi_pad
> >     acpi_power_meter
> >     Preemption disabled at:
> >     [<ffffffffc03608d9>] nd_region_acquire_lane+0x19/0x80 [libnvdimm]
> >     CPU: 44 PID: 2514 Comm: fio Tainted: G        W
> >     4.18.20-rt8-preempt-rt #1
> >     Call Trace:
> >      dump_stack+0x4f/0x6a
> >      ? nd_region_acquire_lane+0x19/0x80 [libnvdimm]
> >      __schedule_bug.cold.17+0x38/0x55
> >      __schedule+0x484/0x6c0
> >      ? _raw_spin_lock+0x17/0x40
> >      schedule+0x3d/0xe0
> >      rt_spin_lock_slowlock_locked+0x118/0x2a0
> >      rt_spin_lock_slowlock+0x57/0x90
> >      rt_spin_lock+0x52/0x60
> >      btt_write_pg.isra.16+0x280/0x4b0 [nd_btt]
> >      btt_make_request+0x1b1/0x320 [nd_btt]
> >      generic_make_request+0x1dc/0x3f0
> >      submit_bio+0x49/0x140
> >
> > nd_region_acquire_lane() disables preemption with get_cpu() which causes
> > "scheduling while atomic" spews on RT.
> >
> > Is it safe to replace get_cpu()/put_cpu() with
> > get_cpu_light()/put_cpu_light() in
> > nd_region_acquire_lane()/nd_region_release_lane()?
>
> get_cpu disables preemption on a core and get_cpu_light will just avoid
> task migration across the cores. If we change this to get/put_cpu_light
> I think there is possibility of a race here.
>
> > After this replacement, the codes protected by
> > nd_region_release_lane/nd_region_release_lane would become pre-emptible.
> > So are these codes reentrant?
>
> Another thing I see is when get_cpu is called in "nd_region_acquire_lane"
> there is no corresponding call for "put_cpu" in same function. This is
> called only in "nd_region_release_lane". It means for the duration of
> these calls preemption will be disabled.
>
> Here, we cannot change preemption disable to migration disable for mainline.
> As there is code which can result in race.
>
> For RT only patchset as well, IIUC will have same problem as there is spin_lock
> protection on a condition and path before/without spinlock may also race.
> We can have something like local_lock_* =>  local_lock_cpu
>
> This are my two cents.

The btt implementation assumes that the btt code will not be
re-entered on the same cpu. So the pre-emption disable is required for
performance, but for correctness the implementation can fall back to
using a lock along with migration being disabled. In other words I
think changing nd_region_acquire_lane() like the following would be
sufficient for RT kernels:

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index e2818f94f292..e720fc42bbc0 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -947,18 +947,15 @@ int nd_blk_region_init(struct nd_region *nd_region)
 unsigned int nd_region_acquire_lane(struct nd_region *nd_region)
 {
        unsigned int cpu, lane;
+       struct nd_percpu_lane *ndl_lock, *ndl_count;

-       cpu = get_cpu();
-       if (nd_region->num_lanes < nr_cpu_ids) {
-               struct nd_percpu_lane *ndl_lock, *ndl_count;
+       cpu = get_cpu_light();

-               lane = cpu % nd_region->num_lanes;
-               ndl_count = per_cpu_ptr(nd_region->lane, cpu);
-               ndl_lock = per_cpu_ptr(nd_region->lane, lane);
-               if (ndl_count->count++ == 0)
-                       spin_lock(&ndl_lock->lock);
-       } else
-               lane = cpu;
+       lane = cpu % nd_region->num_lanes;
+       ndl_count = per_cpu_ptr(nd_region->lane, cpu);
+       ndl_lock = per_cpu_ptr(nd_region->lane, lane);
+       if (ndl_count->count++ == 0)
+               spin_lock(&ndl_lock->lock);

        return lane;
 }
@@ -966,17 +963,14 @@ EXPORT_SYMBOL(nd_region_acquire_lane);

 void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane)
 {
-       if (nd_region->num_lanes < nr_cpu_ids) {
-               unsigned int cpu = get_cpu();
-               struct nd_percpu_lane *ndl_lock, *ndl_count;
-
-               ndl_count = per_cpu_ptr(nd_region->lane, cpu);
-               ndl_lock = per_cpu_ptr(nd_region->lane, lane);
-               if (--ndl_count->count == 0)
-                       spin_unlock(&ndl_lock->lock);
-               put_cpu();
-       }
-       put_cpu();
+       unsigned int cpu = get_cpu();
+       struct nd_percpu_lane *ndl_lock, *ndl_count;
+
+       ndl_count = per_cpu_ptr(nd_region->lane, cpu);
+       ndl_lock = per_cpu_ptr(nd_region->lane, lane);
+       if (--ndl_count->count == 0)
+               spin_unlock(&ndl_lock->lock);
+       put_cpu_light();
 }
 EXPORT_SYMBOL(nd_region_release_lane);
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
