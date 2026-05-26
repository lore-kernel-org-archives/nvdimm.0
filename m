Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28CC3B6C1E
	for <nvdimm@lists.linux.dev>; Tue, 26 May 2026 06:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779778263; cv=none; b=c9ylJTlHz3VhXiDtFfyU7qYzXqLyeHEhth4IQQ4kiwMh1kgc7h8PajRwWOlS32zDFejb9I040zQLhCbH6OU2r9twR9bIWtQuy0+OSqPzY1fHgfv6i6mdqogJ73CyXIbC+DfoF/BEEJ8sgyjRhlIzYwGLSwAnctJaVlsOQsONw94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779778263; c=relaxed/simple;
	bh=JrYMnKy+RGy07VquUCS67pI8OhH3AKJZn5M4f0WgmzA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BENCyQwWyuSTkDe3Pi9EPk4u8cdwsIUtRgBB7KyBu5LacbjLydf84l3HqRnGQ+9kK54r03IK4PeEJfNP4ewM2bcG3ucXDuUHRGWKykM4rZkSVUPJLs845coyJWhAzA4SNn4L93YBuPOIfQGpFxvO/Rivy03sqTZFmFe/VYQ7rPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GOwziB5S; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GOwziB5S"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64Q5TBQa1085020;
	Tue, 26 May 2026 06:50:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=PrwTuY
	u0RsVmm22Omf0tOcv8akyFtP2ypJqOoF2tnus=; b=GOwziB5SWe5eW12YoOa0IJ
	9GDUmiXakpNu9jfkXXeHCX+yIYcdhVmDhL2tZAvNuh0BzcKB8TQ8mynu5AyySU/D
	edVwRXowgRKCW3dl06CUVTyoNjH/UFaWcnhdUTiOppHOxtnXyHjx+w7XF33VcJiL
	9Oo0Oyv3jZ/oRwiLt5qnFO3h/MQlGIOpeqmmAc0nh3VFNjuxq41JC4oPHFLRN5dl
	PIyUjGyIxzyPW9C6nfPtNf4mlHG3j0OPYpKFFwR3uwNsda99XqZ1QjFyxyVu/5YG
	c4VWO9Cyznznv5WtiCmU/kCGXWEocLPTPq2VPPn68rhCQvnb4km7Tca9CTUtLyIA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eb4s2argu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 May 2026 06:50:58 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64Q6dAW2004911;
	Tue, 26 May 2026 06:50:57 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ebpxw091j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 May 2026 06:50:57 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64Q6otqn51118378
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 May 2026 06:50:55 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 32A8620049;
	Tue, 26 May 2026 06:50:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8AE1920040;
	Tue, 26 May 2026 06:50:52 +0000 (GMT)
Received: from aboo.ibm.com (unknown [9.124.218.202])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 26 May 2026 06:50:52 +0000 (GMT)
Message-ID: <931f4a4169163fc27ba168539b32e8dc7b75538d.camel@linux.ibm.com>
Subject: Re: [PATCH v5] nvdimm/btt: Handle preemption in BTT lane acquisition
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
        Vishal Verma
	 <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	 <iweiny@kernel.org>,
        aboorvad@linux.ibm.com
Date: Tue, 26 May 2026 12:20:50 +0530
In-Reply-To: <20260515014729.107329-1-alison.schofield@intel.com>
References: <20260515014729.107329-1-alison.schofield@intel.com>
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
X-Proofpoint-GUID: 4b6lcQAnwMdXRFUGgcX0MQDPl2CCInwG
X-Authority-Analysis: v=2.4 cv=Sq2gLvO0 c=1 sm=1 tr=0 ts=6a1542d2 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=QyXUC8HyAAAA:8 a=SGxpvlsyAAAA:20 a=VnNF1IyMAAAA:8 a=JRkQpF8OEcrLvu0MFwsA:9
 a=QEXdDO2ut3YA:10 a=bA3UWDv6hWIuX7UZL3qL:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI2MDA1NiBTYWx0ZWRfX5sW+rHqI0Ps9
 dhNCmpI3doTd+95jexpRyJKBGWNQdWTmqR5Zwjrf2vStyh+7Idsonf0wuV2L6IldLoNOT/XPF5q
 giuQswq2TuIlg2ypkXpWvq+cKH0YDPplLN2X9zY3Nc0AlxLVzQBYe5hy04gnhsw8GKhojZYe5BK
 Mh5mE4NucxQnn22ZJhBDYU8Y4gxbX/DMmovckmzn+DgB/spJ0YvbbtWhM75qRZ8KAzHYdu1uIRv
 ZmVVmuQK2YCSiCe1UC9SujpnvqH9T/HlfQbOvjqEqeoOstPij6M18yaoRooyL0lgSsjE3KhHfN4
 8xSHi3MwqVOkS5FzVsnB3gUJOqqjQ1y7Wh6j0+9fPWJhhNxTAzuSXV4RfNtUdTyneH6oZFygjuj
 Yh+wahY7QLp86U3SB2aCcBKJG5VhtzTpVqDGQ4eorVnAEVBN2LMhVEt57ZvfYcIRiD0c04C0k4h
 3uk9gf/fc0cNAL9VNEg==
X-Proofpoint-ORIG-GUID: 4b6lcQAnwMdXRFUGgcX0MQDPl2CCInwG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-26_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 phishscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 clxscore=1011 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605260056

On Thu, 2026-05-14 at 18:47 -0700, Alison Schofield wrote:
> BTT lanes serialize access to per-lane metadata and workspace state
> during BTT I/O. The btt-check unit test reports data mismatches during
> BTT writes due to a race in lane acquisition that can lead to silent
> data corruption.
>=20
> The existing lane model uses a spinlock together with a per-CPU
> recursion count. That recursion model stopped being valid after BTT
> lanes became preemptible: another task can run on the same CPU,
> observe a non-zero recursion count, bypass locking, and use the same
> lane concurrently.
>=20
> BTT lanes are also held across arena_write_bytes() calls. That path
> reaches nsio_rw_bytes(), which flushes writes with nvdimm_flush().
> Some provider flush callbacks can sleep, making a spinlock the wrong
> primitive for the lane lifetime.
>=20
> Replace the spinlock-based recursion model with a dynamically
> allocated per-lane mutex array and take the lane lock
> unconditionally.
>=20
> Add might_sleep() to catch any future atomic-context caller.
>=20
> Found with the ndctl unit test btt-check.sh.
>=20
> Fixes: 36c75ce3bd29 ("nd_btt: Make BTT lanes preemptible")
> Assisted-by: Claude Sonnet 4.5
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>=20
>=20
> Changes in v5:
> - Align lane mutex entries to cachelines in SMP builds (Sashiko AI)
> - Add sparse lock annotations for lane mutexes (DaveJ)
> - s/spinlock/mutexes in the driver-api doc btt.rst
>=20
> Changes in v4:
> - Replace per-CPU lane storage w dynamically allocated mutex array (Sashi=
ko AI)
> - Remove the recursion fast path and take the lane lock unconditionally
> - Update commit log
>=20
> Changes in v3:
> Replace spinlock with a per-lane mutex (Arboorva)
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
> =C2=A0Documentation/driver-api/nvdimm/btt.rst |=C2=A0 4 +-
> =C2=A0drivers/nvdimm/nd.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 7 ++-
> =C2=A0drivers/nvdimm/region_devs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 64 ++++++++-----------------
> =C2=A03 files changed, 25 insertions(+), 50 deletions(-)
>=20
> diff --git a/Documentation/driver-api/nvdimm/btt.rst b/Documentation/driv=
er-api/nvdimm/btt.rst
> index 2d8269f834bd..e3218863ec96 100644
> --- a/Documentation/driver-api/nvdimm/btt.rst
> +++ b/Documentation/driver-api/nvdimm/btt.rst
> @@ -162,8 +162,8 @@ process::
> =C2=A0
> =C2=A0A lane number is obtained at the start of any IO, and is used for i=
ndexing into
> =C2=A0all the on-disk and in-memory data structures for the duration of t=
he IO. If
> -there are more CPUs than the max number of available lanes, than lanes a=
re
> -protected by spinlocks.
> +there are more CPUs than the max number of available lanes, then lanes a=
re
> +protected by mutexes.
> =C2=A0
> =C2=A0
> =C2=A0d. In-memory data structure: Read Tracking Table (RTT)
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index b199eea3260e..263b7dde0f87 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -366,9 +366,8 @@ unsigned sizeof_namespace_label(struct nvdimm_drvdata=
 *ndd);
> =C2=A0			res; res =3D next, next =3D next ? next->sibling : NULL)
> =C2=A0
> =C2=A0struct nd_percpu_lane {
> -	int count;
> -	spinlock_t lock;
> -};
> +	struct mutex lock; /* serialize lane access */
> +} ____cacheline_aligned_in_smp;
> =C2=A0
> =C2=A0enum nd_label_flags {
> =C2=A0	ND_LABEL_REAP,
> @@ -420,7 +419,7 @@ struct nd_region {
> =C2=A0	struct kernfs_node *bb_state;
> =C2=A0	struct badblocks bb;
> =C2=A0	struct nd_interleave_set *nd_set;
> -	struct nd_percpu_lane __percpu *lane;
> +	struct nd_percpu_lane *lane;
> =C2=A0	int (*flush)(struct nd_region *nd_region, struct bio *bio);
> =C2=A0	struct nd_mapping mapping[] __counted_by(ndr_mappings);
> =C2=A0};
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index e35c2e18518f..9f5a34181cf5 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -192,7 +192,7 @@ static void nd_region_release(struct device *dev)
> =C2=A0
> =C2=A0		put_device(&nvdimm->dev);
> =C2=A0	}
> -	free_percpu(nd_region->lane);
> +	kfree(nd_region->lane);
> =C2=A0	if (!test_bit(ND_REGION_CXL, &nd_region->flags))
> =C2=A0		memregion_free(nd_region->id);
> =C2=A0	kfree(nd_region);
> @@ -904,52 +904,30 @@ void nd_region_advance_seeds(struct nd_region *nd_r=
egion, struct device *dev)
> =C2=A0 * nd_region_acquire_lane - allocate and lock a lane
> =C2=A0 * @nd_region: region id and number of lanes possible
> =C2=A0 *
> - * A lane correlates to a BLK-data-window and/or a log slot in the BTT.
> - * We optimize for the common case where there are 256 lanes, one
> - * per-cpu.=C2=A0 For larger systems we need to lock to share lanes.=C2=
=A0 For now
> - * this implementation assumes the cost of maintaining an allocator for
> - * free lanes is on the order of the lock hold time, so it implements a
> - * static lane =3D cpu % num_lanes mapping.
> + * A lane correlates to a log slot in the BTT. Lanes are shared across
> + * CPUs using a static lane =3D cpu % num_lanes mapping, with a per-lane
> + * mutex to serialize access.
> =C2=A0 *
> - * In the case of a BTT instance on top of a BLK namespace a lane may be
> - * acquired recursively.=C2=A0 We lock on the first instance.
> - *
> - * In the case of a BTT instance on top of PMEM, we only acquire a lane
> - * for the BTT metadata updates.
> + * Callers must be in sleepable context. The only in-tree caller is
> + * BTT's ->submit_bio handler (btt_read_pg / btt_write_pg).
> =C2=A0 */
> =C2=A0unsigned int nd_region_acquire_lane(struct nd_region *nd_region)
> +	__acquires(&nd_region->lane[lane].lock)
> =C2=A0{
> -	unsigned int cpu, lane;
> +	unsigned int lane;
> =C2=A0
> -	migrate_disable();
> -	cpu =3D smp_processor_id();
> -	if (nd_region->num_lanes < nr_cpu_ids) {
> -		struct nd_percpu_lane *ndl_lock, *ndl_count;
> -
> -		lane =3D cpu % nd_region->num_lanes;
> -		ndl_count =3D per_cpu_ptr(nd_region->lane, cpu);
> -		ndl_lock =3D per_cpu_ptr(nd_region->lane, lane);
> -		if (ndl_count->count++ =3D=3D 0)
> -			spin_lock(&ndl_lock->lock);
> -	} else
> -		lane =3D cpu;
> +	might_sleep();
> =C2=A0
> +	lane =3D raw_smp_processor_id() % nd_region->num_lanes;
> +	mutex_lock(&nd_region->lane[lane].lock);
> =C2=A0	return lane;
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(nd_region_acquire_lane);
> =C2=A0
> =C2=A0void nd_region_release_lane(struct nd_region *nd_region, unsigned i=
nt lane)
> +	__releases(&nd_region->lane[lane].lock)
> =C2=A0{
> -	if (nd_region->num_lanes < nr_cpu_ids) {
> -		unsigned int cpu =3D smp_processor_id();
> -		struct nd_percpu_lane *ndl_lock, *ndl_count;
> -
> -		ndl_count =3D per_cpu_ptr(nd_region->lane, cpu);
> -		ndl_lock =3D per_cpu_ptr(nd_region->lane, lane);
> -		if (--ndl_count->count =3D=3D 0)
> -			spin_unlock(&ndl_lock->lock);
> -	}
> -	migrate_enable();
> +	mutex_unlock(&nd_region->lane[lane].lock);
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(nd_region_release_lane);
> =C2=A0
> @@ -1019,17 +997,16 @@ static struct nd_region *nd_region_create(struct n=
vdimm_bus *nvdimm_bus,
> =C2=A0			goto err_id;
> =C2=A0	}
> =C2=A0
> -	nd_region->lane =3D alloc_percpu(struct nd_percpu_lane);
> +	nd_region->num_lanes =3D ndr_desc->num_lanes;
> +	if (!nd_region->num_lanes)
> +		goto err_percpu;
> +	nd_region->lane =3D kcalloc(nd_region->num_lanes,
> +				=C2=A0 sizeof(*nd_region->lane), GFP_KERNEL);
> =C2=A0	if (!nd_region->lane)
> =C2=A0		goto err_percpu;
Nit: can we also change this to something like err_lane since it is no
longer per-cpu?
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < nr_cpu_ids;=
 i++) {
> -		struct nd_percpu_lane *ndl;
> -
> -		ndl =3D per_cpu_ptr(nd_region->lane, i);
> -		spin_lock_init(&ndl->lock);
> -		ndl->count =3D 0;
> -	}
> +	for (i =3D 0; i < nd_region->num_lanes; i++)
> +		mutex_init(&nd_region->lane[i].lock);
> =C2=A0
> =C2=A0	for (i =3D 0; i < ndr_desc->num_mappings; i++) {
> =C2=A0		struct nd_mapping_desc *mapping =3D &ndr_desc->mapping[i];
> @@ -1046,7 +1023,6 @@ static struct nd_region *nd_region_create(struct nv=
dimm_bus *nvdimm_bus,
> =C2=A0	}
> =C2=A0	nd_region->provider_data =3D ndr_desc->provider_data;
> =C2=A0	nd_region->nd_set =3D ndr_desc->nd_set;
> -	nd_region->num_lanes =3D ndr_desc->num_lanes;
> =C2=A0	nd_region->flags =3D ndr_desc->flags;
> =C2=A0	nd_region->ro =3D ro;
> =C2=A0	nd_region->numa_node =3D ndr_desc->numa_node;
>=20
> base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731


Hi Alison,

Thanks for the fix,=20

Agree with adding mutex_destroy() in nd_region_release() for v6.

For the btt_write_pg() lock-drop window reported by Shashiko, I haven't bee=
n able to
reproduce it so far, I will report back if I observe it and it is not relat=
ed to this
patch.

Tested this on a Power10 LPAR (powerpc) haven't observed any issues so far,=
 it looks good to me.

So,

Tested-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Reviewed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>


Test logs for reference: (test-case used [1])

---------------------------------------------------------------------
Before Patch:
---------------------------------------------------------------------

$ ./run_btt_lane_contention.sh=20
Creating sector-mode namespace on region1...
Namespace: namespace1.0
Block device: /dev/pmem1s
Running: /root/abd/linux/tools/testing/selftests/nvdimm/btt_lane_contention=
 /dev/pmem1s 16 100
---
TAP version 13
1..1
# device: /dev/pmem1s (188998 MB)
# processes: 16 (2 per CPU across 8 CPUs)
# iterations: 100 per process
# I/O size: 256 KB
# logical block size: 4096 bytes
# [proc 7] MISCOMPARE iter=3D0 block=3D190 off=3D0x1432d40000
# [proc 7]   byte 159744: exp 0x47 got 0x4f (2624/262144 bad)
# [proc 7]   from proc 15 (shared CPU 7)
# [proc 8] MISCOMPARE iter=3D0 block=3D7772 off=3D0x178b900000
# [proc 8]   byte 110592: exp 0x48 got 0x40 (4096/262144 bad)
# [proc 8]   from proc 0 (shared CPU 0)
# [proc 11] MISCOMPARE iter=3D0 block=3D12974 off=3D0x2083a40000
# [proc 11]   byte 229376: exp 0x4b got 0x43 (4096/262144 bad)
# [proc 11]   from proc 3 (shared CPU 3)
# [proc 9] MISCOMPARE iter=3D0 block=3D15576 off=3D0x1ae7c40000
# [proc 9]   byte 155648: exp 0x49 got 0x41 (4096/262144 bad)
# [proc 9]   from proc 1 (shared CPU 1)
# [proc 4] MISCOMPARE iter=3D0 block=3D21237 off=3D0xcd4e40000
# [proc 4]   byte 143360: exp 0x44 got 0x4c (928/262144 bad)
# [proc 4]   from proc 12 (shared CPU 4)
# [proc 10] MISCOMPARE iter=3D0 block=3D36182 off=3D0x1f0c000000
# [proc 10]   byte 196608: exp 0x4a got 0x42 (4096/262144 bad)
# [proc 10]   from proc 2 (shared CPU 2)
# [proc 6] MISCOMPARE iter=3D0 block=3D38998 off=3D0x13aef00000
# [proc 6]   byte 241664: exp 0x46 got 0x4e (4096/262144 bad)
# [proc 6]   from proc 14 (shared CPU 6)
# [proc 13] MISCOMPARE iter=3D1 block=3D5923 off=3D0x25da000000
# [proc 13]   byte 24576: exp 0x4d got 0x45 (4096/262144 bad)
# [proc 13]   from proc 5 (shared CPU 5)
...


---------------------------------------------------------------------
After Patch:
---------------------------------------------------------------------

$ ./run_btt_lane_contention.sh=20
Creating sector-mode namespace on region1...
Namespace: namespace1.0
Block device: /dev/pmem1s
Running: /root/abd/linux/tools/testing/selftests/nvdimm/btt_lane_contention=
 /dev/pmem1s 16 100
---
TAP version 13
1..1
# device: /dev/pmem1s (188998 MB)
# processes: 16 (2 per CPU across 8 CPUs)
# iterations: 100 per process
# I/O size: 256 KB
# logical block size: 4096 bytes =20
(no miscompare issues reported)
^CCleaning up namespace namespace1.0...

---------------------------------------------------------------------


[1] https://github.com/AboorvaDevarajan/linux/blob/btt_preempt_test/v1/tool=
s/testing/selftests/nvdimm/btt_lane_contention.c

Regards,
Aboorva
