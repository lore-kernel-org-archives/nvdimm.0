Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC2D2EC09F
	for <nvdimm@lists.linux.dev>; Fri,  1 May 2026 11:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777635090; cv=none; b=NRHaYpZwLctmhSaH45RrjS//6cIQ6mltmA3ItzFgfEXoPy0QeV+r3OCEOhCBci5HExV+gbmj1Kw+jqCb8aewu3uPVR7f3Gt53aFCydsSZfl+w4ZaLEtLA3VLx+11eZNeR30AnxlHuBjf95QTliGhoRSwFM6gZFF+IcImy+3aFII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777635090; c=relaxed/simple;
	bh=8d59XIxF0WipcTmANC4/XbjmHhZrBPze03WrBL9q/jA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NgyNoLWwlN0rlL5Gzb3+4ZLFVSYYdJEE0j0Ehq+qOmW3gMJariEWgM23jUFv7iT4oeq3aMlSm+YPYb8/6WzGk8bIWPa2buXye9ZNzkm4Ztyv8j/8cMMPbdpZrqMAxo/HOjOOQeSX48+7ge8lmozRj5DazlpS3OihYcqLgkkNe1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DOEb46Ob; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DOEb46Ob"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6418LsJN4169201;
	Fri, 1 May 2026 11:31:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=1ogHDq
	evOQQKhFhC6tTBe1YJjnNI4BapJ3HkzmMnFHk=; b=DOEb46Ob5Mtl5elbYwKXO3
	acSmaqXvlmDt9op6cbuKB/u9pg8Kv19+0vrIc+G1Ew+ccaWIj2joHpJxALMCG81L
	8ppU1s+jrU+RWN9joA+UiX0sV+MwfhQ7xgJUShcNOO7fkdbmJsgV+MsCbaBD9/3k
	MdyA6DamlB0ukMavwRasJlBMNNwRub9iAfFWzJ2PW+W+o50uXHlOAPI+dzRZEKkt
	N5lZncRCbA9XfLsOtDw8Qs+waxN5zTSfUTRewCAVxZSu8wG+W4umSBAIcGA6IhGW
	jUFPrQHI6VyyM3qQUDsHltsqT6IKZuZHkt3SMl6vSQS+qpPubVK5WUzvxeVK3INg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4drm1eadur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 May 2026 11:31:23 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 641BO9e0012673;
	Fri, 1 May 2026 11:31:23 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ds9ehq3js-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 May 2026 11:31:22 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 641BVKqh60228006
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 1 May 2026 11:31:21 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D10FF20040;
	Fri,  1 May 2026 11:31:20 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 85B0D20043;
	Fri,  1 May 2026 11:31:17 +0000 (GMT)
Received: from aboo.ibm.com (unknown [9.124.223.34])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  1 May 2026 11:31:17 +0000 (GMT)
Message-ID: <7342d64f2905fe7479d255b301a94274f694e4dd.camel@linux.ibm.com>
Subject: Re: [PATCH v2] nvdimm/btt: Handle preemption in BTT lane acquisition
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
        Vishal Verma
	 <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	 <ira.weiny@intel.com>,
        aboorvad@linux.ibm.com
Date: Fri, 01 May 2026 17:01:15 +0530
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
X-Proofpoint-ORIG-GUID: EQB7ji4JZfTCtcSVDcUmdDackzhVt4i_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTAxMDEwOCBTYWx0ZWRfX1KslMGhesDBb
 LqNajKIj7fMecR3Oi6rAWHuTwyfBbTuiGYHuH+Dv+HUXlSxAZwNwLHQjXCxuinZGulHcTv8+1E6
 rV5hnn1F/fPPSL28zv/JrWZe7xJ5lVDa/Zsf6cUD1DIRsk8WnHiewmxJK9JuRuhMpoyt+Ciiywe
 LCLS7i21RHyssA5DqJuAv+9LfTeTWwl8tM3GJKK9f3w+scAlQ/pc0tUteSW723leoW3jPOGJptZ
 fL1ukwTR4rj/ushYCOXmuZMxN6sulnKZtDV5ONaivRzVh7gjv5OSL9D9JtR9k+iyFS9KkSUcQ8E
 iHd0ZF7+p2UIsPYKt+bHZlBhKkhVJDEFTUXoHdY+MUzBnCbQspd9+GoC38DW/MzmrM2u4u4koru
 wegpJHVFD5uisQpDrpiM5AOOMzo/2/3lhIDx+jSMaNMv8sc+6Q5jOqjCQej32w/x1YNwMXv6qR/
 p5tb+B224klvdNxCXvQ==
X-Authority-Analysis: v=2.4 cv=VZLH+lp9 c=1 sm=1 tr=0 ts=69f48f0b cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=QyXUC8HyAAAA:8 a=U8xgbXeoLhS9wvM1M9AA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: EQB7ji4JZfTCtcSVDcUmdDackzhVt4i_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-01_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 adultscore=0 lowpriorityscore=0 phishscore=0
 spamscore=0 malwarescore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605010108

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

Just a follow-up question.

I haven't reproduced this, just noticed it while reading the code.

After this patch, nd_region_acquire_lane() / nd_region_release_lane() alway=
s
hold a spinlock, IIUC, anything that sleeps/blocks in this critical section=
 will
hit:

    BUG: scheduling while atomic: ...

BTT metadata writes go arena_write_bytes() -> nvdimm_write_bytes() ->
nsio_rw_bytes(), which always calls nvdimm_flush() on write. That can call
nd_region->flush():

  - virtio_pmem_flush() uses a wait_event(), so it can block on
    every flush.

  - papr_scm_pmem_flush() only msleep() when the flush hcall
    comes back busy; the fast path does not sleep, though this is rare case=
.

So BTT on virtio_pmem looks like it could trip the BUG on metadata
writes, papr_scm only if the busy path is taken? Pre-patch, the same behavi=
our
already existed on > 256-CPU boxes where the lane spinlock was taken.

Is this an actual concern, so are we essentially saying that no sleep /
blocking wait is allowed anywhere reachable from the lane critical section?

Please correct me if I'm missing something here.

Thanks,
Aboorva
