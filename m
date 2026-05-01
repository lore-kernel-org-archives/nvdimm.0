Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677E435F5E1
	for <nvdimm@lists.linux.dev>; Fri,  1 May 2026 10:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777633054; cv=none; b=JDYnMBDBjq+QrGRs34RB9JneNowvalCpu0152E6vX0EWNKnOCznF1ptga6xOeojzO6O4rrC6LmcRT39JmKPJCQumRcb5t7yySj2clpxLOsSnfPgaOXfQ8Okr5MSA9hJlarJz/wrTFJe87KLN+vYHI4GSvx8YPHLfetCcXb+CZkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777633054; c=relaxed/simple;
	bh=BhO/fUOKoO6j1LeoRTOwn6+773PN3Y9GOfPhH+dQ7ls=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Flyvd1usfCNpPdgJumxF4YrEWYQBQWRZzNQKIlTaZ3ZlsKeQtC1L3qDczRjZJLc/KJ92zagc545d/YXtjK899A3TgaIxbr/Oev5Ml85JjPPxfUgVne0tLRTvL3v2qu6nfDwr2nHvaZVplODQ8HT3Uf3eOVZQhaRvW3HsAvKAoVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mT3scokL; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mT3scokL"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6417tDpX2939523;
	Fri, 1 May 2026 10:57:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NP48qm
	eSinoGSkMaPXr+ttQWHyxUf5iiJWVC32cfzyA=; b=mT3scokLH4kwmcWM9Ra/2Z
	Er17LICX4QbBatNGbTV9JMAGy8+xHrT/saBcYl8xs/x+Kqvt22CzWDBx8L0C2ZTj
	1JK2t9Kqm9zVu1N5qabnbCQVKLo0IPYwlXSVsq1F3nwEY3TXlTmkJeC6hOdMosoS
	o+ASdL1G4iLdJfyZ3ULsrdgj8OzzFpF5jxV9GuDYlPefC42FKSBuSj7tDKuLVpW3
	4TsqmDA8DYkx/yMePcVP9z0PtQfxsp5x/FTdwX57k1JJrWvoMo9IhTwHXHvcI2A6
	NL3VMGeuUh15muMgNa6yftkiflCXwG17+c0metbof57Tcc4kd9R+SsryojxJZSpQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4drnb5m7n5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 May 2026 10:57:23 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 641AujKi020774;
	Fri, 1 May 2026 10:57:23 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dsamypvrj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 May 2026 10:57:22 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 641AvLNr15729082
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 1 May 2026 10:57:21 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3EE0420049;
	Fri,  1 May 2026 10:57:21 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E50E720040;
	Fri,  1 May 2026 10:57:17 +0000 (GMT)
Received: from aboo.ibm.com (unknown [9.124.223.34])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  1 May 2026 10:57:17 +0000 (GMT)
Message-ID: <7081312ccb45b067cd414a92c923f69cf1285097.camel@linux.ibm.com>
Subject: Re: [PATCH v2] nvdimm/btt: Handle preemption in BTT lane acquisition
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
        Vishal Verma
	 <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	 <ira.weiny@intel.com>,
        aboorvad@linux.ibm.com
Date: Fri, 01 May 2026 16:27:16 +0530
In-Reply-To: <20260430024652.3920875-1-alison.schofield@intel.com>
References: <20260430024652.3920875-1-alison.schofield@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (3.60.1-1.fc44) 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=AqDeGu9P c=1 sm=1 tr=0 ts=69f48713 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=QyXUC8HyAAAA:8 a=SGxpvlsyAAAA:20 a=VnNF1IyMAAAA:8 a=GX_Ns3gP8Oo0xm7IdUoA:9
 a=QEXdDO2ut3YA:10 a=bA3UWDv6hWIuX7UZL3qL:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTAxMDEwMyBTYWx0ZWRfX/leOcMxpGdBK
 LO6PFHg3V3jSXyOuqBgla4+ceIgF9gByOkMUDtn6pOi7geX5Hk2v2TdT6/ypT7I4WM2h3grJQE/
 myL750D8OpDStJS/WK5j3uvArugTizHVjXdy8sqlIVMznI0feMXdkxViscPsC6XJ4RxV19L+yEe
 v7DFL9b7Ar3G5LOC3i8SeSScDdxl5ZsZjnLAOVnId8wVY2SVAR2rZGLGhfixvDFlyOxk0x5pY7K
 W3BDiBYg60mtlg+7mhMAWmiwSHAqSeY5OOANV50PDSsAdSivV/kvbqkVxNgVqzTVFbbSGd19glu
 ZtgcVG98M+lRoyI5/X/1bT0LvbzqATI6T1iegzabJbyhK2EgsU+1wYYy3r2VIQk3iqzhlM88reI
 dRooKUn43tjRi5JjvnTD7d1X3JTOE8XpwZJSDfuTonCEEWyRqm5EWtb4Ld6RbB/1shLNUeyieQJ
 aYvmNW3HKB243BchVUw==
X-Proofpoint-GUID: uon-27ApC-Nyy9JYcyRVfPHVKt6MzbTy
X-Proofpoint-ORIG-GUID: uon-27ApC-Nyy9JYcyRVfPHVKt6MzbTy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-01_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 phishscore=0 suspectscore=0 clxscore=1011
 lowpriorityscore=0 spamscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605010103

On Wed, 2026-04-29 at 19:46 -0700, Alison Schofield wrote:

> BTT (Block Translation Table) makes persistent memory safe for block
> I/O by guaranteeing atomic sector updates. It uses reserved lanes
> for in-flight BTT operations, which must be used exclusively.
>=20
> The btt-check unit test reports data mismatches during BTT I/O due
> to a race in lane acquisition, leading to silent data corruption.
>=20
> BTT lane acquisition uses per-CPU recursion tracking with
> migrate_disable(). However, migrate_disable() does not prevent
> preemption, so another task can run on the same CPU and share the
> recursion state. That task can observe a non-zero recursion count,
> bypass locking, and use the same lane at the same time.
>=20
> Track lane ownership per task and only allow lockless recursion for
> the owning task. Otherwise, serialize access with the lane spinlock.
> Use spin_(un)lock_bh() so softirq re-entry on the same CPU cannot
> bypass ownership checks or deadlock on the lane lock.
>=20
> Found with the NDCTL unit test btt-check.sh
>=20
> Fixes: 36c75ce3bd29 ("nd_btt: Make BTT lanes preemptible")
> Assisted-by: Claude Sonnet 4.5
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>=20
> Changes in v2:
> Use spin_(un)lock_bh() (Sashiko AI)
> Update commit log per softirq re-enty and spinlock change
>=20
> A new unit test to stress this is under review here:
> https://lore.kernel.org/nvdimm/20260424233633.3762217-1-alison.schofield@=
intel.com/
>=20
>=20
> =C2=A0drivers/nvdimm/nd.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0 1 +
> =C2=A0drivers/nvdimm/region_devs.c | 48 +++++++++++++++++++++------------=
---
> =C2=A02 files changed, 29 insertions(+), 20 deletions(-)
>=20
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index b199eea3260e..424c38ca4960 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -368,6 +368,7 @@ unsigned sizeof_namespace_label(struct nvdimm_drvdata=
 *ndd);
> =C2=A0struct nd_percpu_lane {
> =C2=A0	int count;
> =C2=A0	spinlock_t lock;
> +	struct task_struct *owner;
> =C2=A0};
> =C2=A0
> =C2=A0enum nd_label_flags {
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index e35c2e18518f..f1c6dcd95b5a 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -905,11 +905,10 @@ void nd_region_advance_seeds(struct nd_region *nd_r=
egion, struct device *dev)
> =C2=A0 * @nd_region: region id and number of lanes possible
> =C2=A0 *
> =C2=A0 * A lane correlates to a BLK-data-window and/or a log slot in the =
BTT.
> - * We optimize for the common case where there are 256 lanes, one
> - * per-cpu.=C2=A0 For larger systems we need to lock to share lanes.=C2=
=A0 For now
> - * this implementation assumes the cost of maintaining an allocator for
> - * free lanes is on the order of the lock hold time, so it implements a
> - * static lane =3D cpu % num_lanes mapping.
> + * Lanes are shared across CPUs using a static lane =3D cpu % num_lanes
> + * mapping, with a per-lane spinlock to serialize access when multiple
> + * tasks share a lane (including when preemption causes multiple tasks
> + * to run on the same CPU).
> =C2=A0 *
> =C2=A0 * In the case of a BTT instance on top of a BLK namespace a lane m=
ay be
> =C2=A0 * acquired recursively.=C2=A0 We lock on the first instance.
> @@ -920,35 +919,44 @@ void nd_region_advance_seeds(struct nd_region *nd_r=
egion, struct device *dev)
> =C2=A0unsigned int nd_region_acquire_lane(struct nd_region *nd_region)
> =C2=A0{
> =C2=A0	unsigned int cpu, lane;
> +	struct nd_percpu_lane *ndl;
> =C2=A0
> =C2=A0	migrate_disable();
> =C2=A0	cpu =3D smp_processor_id();
> -	if (nd_region->num_lanes < nr_cpu_ids) {
> -		struct nd_percpu_lane *ndl_lock, *ndl_count;
> -
> +	if (nd_region->num_lanes < nr_cpu_ids)
> =C2=A0		lane =3D cpu % nd_region->num_lanes;
> -		ndl_count =3D per_cpu_ptr(nd_region->lane, cpu);
> -		ndl_lock =3D per_cpu_ptr(nd_region->lane, lane);
> -		if (ndl_count->count++ =3D=3D 0)
> -			spin_lock(&ndl_lock->lock);
> -	} else
> +	else
> =C2=A0		lane =3D cpu;
> =C2=A0
> +	/*
> +	 * migrate_disable() keeps the lane stable, but does not prevent
> +	 * preemption. Only the owning task may recurse without taking the
> +	 * lock.
> +	 */
> +	ndl =3D per_cpu_ptr(nd_region->lane, lane);
> +	if (READ_ONCE(ndl->owner) !=3D current) {
> +		spin_lock_bh(&ndl->lock);
> +		WRITE_ONCE(ndl->owner, current);
> +	}
> +	ndl->count++;
> +
> =C2=A0	return lane;
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(nd_region_acquire_lane);
> =C2=A0
> =C2=A0void nd_region_release_lane(struct nd_region *nd_region, unsigned i=
nt lane)
> =C2=A0{
> -	if (nd_region->num_lanes < nr_cpu_ids) {
> -		unsigned int cpu =3D smp_processor_id();
> -		struct nd_percpu_lane *ndl_lock, *ndl_count;
> +	struct nd_percpu_lane *ndl =3D per_cpu_ptr(nd_region->lane, lane);
> =C2=A0
> -		ndl_count =3D per_cpu_ptr(nd_region->lane, cpu);
> -		ndl_lock =3D per_cpu_ptr(nd_region->lane, lane);
> -		if (--ndl_count->count =3D=3D 0)
> -			spin_unlock(&ndl_lock->lock);
> +	if (WARN_ON_ONCE(READ_ONCE(ndl->owner) !=3D current))
> +		goto out;
> +
> +	if (--ndl->count =3D=3D 0) {
> +		WRITE_ONCE(ndl->owner, NULL);
> +		spin_unlock_bh(&ndl->lock);
> =C2=A0	}
> +
> +out:
> =C2=A0	migrate_enable();
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(nd_region_release_lane);
>=20
> base-commit: 028ef9c96e96197026887c0f092424679298aae8


Hi Alison,

Thanks for the fix.

I noticed a similar race in BTT and wrote a small selftest to
exercise concurrent lane usage [1].

Without your patch on the almost latest upstream kernel v7.0.0, I see silen=
t=C2=A0
data corruption on this workload, most reliably with PREEMPT_DYNAMIC set to
"lazy" or "full". With your patch applied the test passes across all four p=
reempt modes.

 =20
  # Without the patch
  echo none      -> pass
  echo voluntary -> pass
  echo lazy      -> "not ok 1 BTT lane contention: 6 process(es) saw corrup=
tion"
  echo full      -> "not ok 1 BTT lane contention: 8 process(es) saw corrup=
tion"
 =20

 =20
  # With the patch
  echo none / voluntary / lazy / full -> all pass

(Full output below)

So,

Tested-by: Aboorva Devarajan <aboorvad@linux.ibm.com>


------------------
Without Patch:
------------------

[nvdimm]# echo none > /sys/kernel/debug/sched/preempt
[nvdimm]# ./run_btt_lane_contention.sh
Creating sector-mode namespace on region1...
Namespace: namespace1.4
Block device: /dev/pmem1.4s
Running: /home/abd/linux/tools/testing/selftests/nvdimm/btt_lane_contention=
 /dev/pmem1.4s 16 100
---
TAP version 13
1..1
# device: /dev/pmem1.4s (1789 MB)
# processes: 16 (2 per CPU across 8 CPUs)
# iterations: 100 per process
# I/O size: 256 KB
# logical block size: 4096 bytes
ok 1 BTT lane contention: all data verified
# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
Cleaning up namespace namespace1.4...
[nvdimm]# echo voluntary > /sys/kernel/debug/sched/preempt
[nvdimm]# cat /sys/kernel/debug/sched/preempt=20
none (voluntary) full lazy=20
[nvdimm]# ./run_btt_lane_contention.sh
Creating sector-mode namespace on region1...
Namespace: namespace1.3
Block device: /dev/pmem1.3s
Running: /home/abd/linux/tools/testing/selftests/nvdimm/btt_lane_contention=
 /dev/pmem1.3s 16 100
---
TAP version 13
1..1
# device: /dev/pmem1.3s (1789 MB)
# processes: 16 (2 per CPU across 8 CPUs)
# iterations: 100 per process
# I/O size: 256 KB
# logical block size: 4096 bytes
ok 1 BTT lane contention: all data verified
# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
Cleaning up namespace namespace1.3...
[nvdimm]# echo lazy > /sys/kernel/debug/sched/preempt
[nvdimm]# cat /sys/kernel/debug/sched/preempt=20
none voluntary full (lazy)=20
[nvdimm]# ./run_btt_lane_contention.sh
Creating sector-mode namespace on region1...
Namespace: namespace1.4
Block device: /dev/pmem1.4s
Running: /home/abd/linux/tools/testing/selftests/nvdimm/btt_lane_contention=
 /dev/pmem1.4s 16 100
---
TAP version 13
1..1
# device: /dev/pmem1.4s (1789 MB)
# processes: 16 (2 per CPU across 8 CPUs)
# iterations: 100 per process
# I/O size: 256 KB
# logical block size: 4096 bytes
# [proc 10] MISCOMPARE iter=3D4 block=3D80 off=3D0x47180000
# [proc 10]   byte 204800: exp 0x4a got 0x42 (4096/262144 bad)
# [proc 10]   from proc 2 (shared CPU 2)
# [proc 12] MISCOMPARE iter=3D11 block=3D279 off=3D0x582c0000
# [proc 12]   byte 102400: exp 0x4c got 0x44 (4096/262144 bad)
# [proc 12]   from proc 4 (shared CPU 4)
# [proc 13] MISCOMPARE iter=3D19 block=3D143 off=3D0x5d080000
# [proc 14] MISCOMPARE iter=3D19 block=3D28 off=3D0x62380000
# [proc 14]   byte 28672: exp 0x4e got 0x46 (4096/262144 bad)
# [proc 14]   from proc 6 (shared CPU 6)
# [proc 13]   byte 249856: exp 0x4d got 0x45 (4096/262144 bad)
# [proc 13]   from proc 5 (shared CPU 5)
# [proc 1] MISCOMPARE iter=3D57 block=3D55 off=3D0x7d80000
# [proc 1]   byte 135168: exp 0x41 got 0x49 (4096/262144 bad)
# [proc 1]   from proc 9 (shared CPU 1)
# [proc 8] MISCOMPARE iter=3D71 block=3D392 off=3D0x3e000000
# [proc 8]   byte 208896: exp 0x48 got 0x40 (4096/262144 bad)
# [proc 8]   from proc 0 (shared CPU 0)
not ok 1 BTT lane contention: 6 process(es) saw corruption
# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
Cleaning up namespace namespace1.4...
[nvdimm]# echo full > /sys/kernel/debug/sched/preempt
[nvdimm]# cat /sys/kernel/debug/sched/preempt=20
none voluntary (full) lazy=20
[nvdimm]# ./run_btt_lane_contention.sh
Creating sector-mode namespace on region1...
Namespace: namespace1.3
Block device: /dev/pmem1.3s
Running: /home/abd/linux/tools/testing/selftests/nvdimm/btt_lane_contention=
 /dev/pmem1.3s 16 100
---
TAP version 13
1..1
# device: /dev/pmem1.3s (1789 MB)
# processes: 16 (2 per CPU across 8 CPUs)
# iterations: 100 per process
# I/O size: 256 KB
# logical block size: 4096 bytes
# [proc 1] MISCOMPARE iter=3D0 block=3D3 off=3D0x7080000
# [proc 4] MISCOMPARE iter=3D0 block=3D3 off=3D0x1bfc0000
# [proc 4]   byte 114688: exp 0x44 got 0x4c (4096/262144 bad)
# [proc 7] MISCOMPARE iter=3D0 block=3D2 off=3D0x30ec0000
# [proc 7]   byte 212992: exp 0x47 got 0x4f (4096/262144 bad)
# [proc 1]   byte 159744: exp 0x41 got 0x49 (4096/262144 bad)
# [proc 1]   from proc 9 (shared CPU 1)
# [proc 4]   from proc 12 (shared CPU 4)
# [proc 7]   from proc 15 (shared CPU 7)
# [proc 10] MISCOMPARE iter=3D0 block=3D2 off=3D0x45e00000
# [proc 10]   byte 139264: exp 0x4a got 0x42 (1024/262144 bad)
# [proc 10]   from proc 2 (shared CPU 2)
# [proc 3] MISCOMPARE iter=3D0 block=3D9 off=3D0x15180000
# [proc 3]   byte 217088: exp 0x43 got 0x4b (4096/262144 bad)
# [proc 3]   from proc 11 (shared CPU 3)
# [proc 0] MISCOMPARE iter=3D0 block=3D9 off=3D0x240000
# [proc 0]   byte 159744: exp 0x40 got 0x48 (4096/262144 bad)
# [proc 0]   from proc 8 (shared CPU 0)
# [proc 5] MISCOMPARE iter=3D0 block=3D9 off=3D0x23100000
# [proc 5]   byte 122880: exp 0x45 got 0x4d (4096/262144 bad)
# [proc 5]   from proc 13 (shared CPU 5)
# [proc 6] MISCOMPARE iter=3D0 block=3D14 off=3D0x2a200000
# [proc 6]   byte 57344: exp 0x46 got 0x4e (4096/262144 bad)
# [proc 6]   from proc 14 (shared CPU 6)
not ok 1 BTT lane contention: 8 process(es) saw corruption
# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
Cleaning up namespace namespace1.3...
[nvdimm]#=20


------------------
With Patch:
------------------

[nvdimm]# cat /sys/kernel/debug/sched/preempt=20
(none) voluntary full lazy=20
[nvdimm]# ./run_btt_lane_contention.sh=20
Creating sector-mode namespace on region1...
Namespace: namespace1.3
Block device: /dev/pmem1.3s
Running: /home/abd/linux/tools/testing/selftests/nvdimm/btt_lane_contention=
 /dev/pmem1.3s 16 100
---
TAP version 13
1..1
# device: /dev/pmem1.3s (1789 MB)
# processes: 16 (2 per CPU across 8 CPUs)
# iterations: 100 per process
# I/O size: 256 KB
# logical block size: 4096 bytes
ok 1 BTT lane contention: all data verified
# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
Cleaning up namespace namespace1.3...
[nvdimm]# echo voluntary > /sys/kernel/debug/sched/preempt
[nvdimm]# cat /sys/kernel/debug/sched/preempt=20
none (voluntary) full lazy=20
[nvdimm]# ./run_btt_lane_contention.sh=20
Creating sector-mode namespace on region1...
Namespace: namespace1.4
Block device: /dev/pmem1.4s
Running: /home/abd/linux/tools/testing/selftests/nvdimm/btt_lane_contention=
 /dev/pmem1.4s 16 100
---
TAP version 13
1..1
# device: /dev/pmem1.4s (1789 MB)
# processes: 16 (2 per CPU across 8 CPUs)
# iterations: 100 per process
# I/O size: 256 KB
# logical block size: 4096 bytes
ok 1 BTT lane contention: all data verified
# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
Cleaning up namespace namespace1.4...
[nvdimm]# echo lazy > /sys/kernel/debug/sched/preempt
[nvdimm]# cat /sys/kernel/debug/sched/preempt=20
none voluntary full (lazy)=20
[nvdimm]# ./run_btt_lane_contention.sh=20
Creating sector-mode namespace on region1...
Namespace: namespace1.3
Block device: /dev/pmem1.3s
Running: /home/abd/linux/tools/testing/selftests/nvdimm/btt_lane_contention=
 /dev/pmem1.3s 16 100
---
TAP version 13
1..1
# device: /dev/pmem1.3s (1789 MB)
# processes: 16 (2 per CPU across 8 CPUs)
# iterations: 100 per process
# I/O size: 256 KB
# logical block size: 4096 bytes
ok 1 BTT lane contention: all data verified
# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
Cleaning up namespace namespace1.3...
[nvdimm]# echo full > /sys/kernel/debug/sched/preempt
[nvdimm]# cat /sys/kernel/debug/sched/preempt=20
none voluntary (full) lazy=20
[nvdimm]# ./run_btt_lane_contention.sh=20
Creating sector-mode namespace on region1...
Namespace: namespace1.4
Block device: /dev/pmem1.4s
Running: /home/abd/linux/tools/testing/selftests/nvdimm/btt_lane_contention=
 /dev/pmem1.4s 16 100
---
TAP version 13
1..1
# device: /dev/pmem1.4s (1789 MB)
# processes: 16 (2 per CPU across 8 CPUs)
# iterations: 100 per process
# I/O size: 256 KB
# logical block size: 4096 bytes
ok 1 BTT lane contention: all data verified
# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
Cleaning up namespace namespace1.4...

[1] https://github.com/AboorvaDevarajan/linux/blob/btt_preempt_test/v1/tool=
s/testing/selftests/nvdimm/btt_lane_contention.c


Regards,
Aboorva
