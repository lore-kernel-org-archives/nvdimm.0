Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DD12C21FF
	for <nvdimm@lists.linux.dev>; Sun,  3 May 2026 16:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777825071; cv=none; b=ig1GkdL+HQCe9p6cavKVKzjI5+wAESbnURT4W29ae9wBe/Sis7ZcOOVk57DqW+NDGvH5lPzbeVZZT1TwQvxoPQBFoajaS0wYHy3lPCwT37QfLW8JidNxz9wgVYWGQXouteHDNiJPPIV3l5TlX1gBO6iUit57JggEkEZkhOIWbx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777825071; c=relaxed/simple;
	bh=vFE7L/STT3VNaLAKqJl08IrqupyfIrtBhL5sxZz2KMs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dRH9VCradhGUzGz/EIHoGCyIybDjNQ/m/GnK/+MrUAcmjV944haZ2+EHym0z7jSU+deZZ5aPKPHFb5iCLLGIiwiYeb4wNBEydMixPup/PM2Fmka9sYq+bI8xLGY1PK3H5I+jMrnA8Fblw6rHU8xQFltpHxiVykT1mxI5D51yS2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=r26vzz6P; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="r26vzz6P"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6434Dw2k569647;
	Sun, 3 May 2026 16:17:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=oZ87Gq
	3cIduNSQ97f/18P8rjkPnSlVhCdm+LYCaIwi8=; b=r26vzz6P4hVI2w6540Zxb5
	MOzNLRNBcnQK/Gqv9hIYeIFrCjnlRC3w/r8K14RVEf+K/1nTlk+iBuVbJujTsdI4
	JseK8Zgd5bqiLvJkRm3PJqCrytoEs5vBiu+Dp1RNEkejWipJRKblv3/CGFkHSelE
	GHshpV0nzvbcMDbFeNWN21HiqXW3gnlxCIHhhK5hhwP6ufr9YEi9KVV7Ec4D8vxG
	N8Aem0qN9YvHuB0pNhBOFGb2KE4t1FpdOJpSmCzhJ/2OJvqb3hN07grp6jN8wMW9
	0DO298hUHCD8QRqIw1xb0vp0g/cO8/5NQS7TjHRQwNS55DIwHAckSvMAD/mXPf8w
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y144dn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 03 May 2026 16:17:39 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 643G9cJR011814;
	Sun, 3 May 2026 16:17:38 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwuyvt447-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 03 May 2026 16:17:38 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 643GHaFe56164678
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 3 May 2026 16:17:36 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C1D4C20043;
	Sun,  3 May 2026 16:17:36 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BB91420040;
	Sun,  3 May 2026 16:17:33 +0000 (GMT)
Received: from aboo.ibm.com (unknown [9.39.20.6])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sun,  3 May 2026 16:17:33 +0000 (GMT)
Message-ID: <ec1f6e286d08b66a9bbf03e9e9d899e1a914ea7a.camel@linux.ibm.com>
Subject: Re: [PATCH v2] nvdimm/btt: Handle preemption in BTT lane acquisition
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
        Vishal Verma
	 <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	 <ira.weiny@intel.com>,
        aboorvad@linux.ibm.com
Date: Sun, 03 May 2026 21:47:31 +0530
In-Reply-To: <afWJMDmiLiimIqUV@aschofie-mobl2.lan>
References: <20260430024652.3920875-1-alison.schofield@intel.com>
	 <7342d64f2905fe7479d255b301a94274f694e4dd.camel@linux.ibm.com>
	 <afWJMDmiLiimIqUV@aschofie-mobl2.lan>
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
X-Proofpoint-ORIG-GUID: cxBRvQ45C-BDmh92s8sfctH3MXYH3u9E
X-Proofpoint-GUID: cxBRvQ45C-BDmh92s8sfctH3MXYH3u9E
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTAzMDE4MSBTYWx0ZWRfX4t87JZT91IyZ
 deBxdW8EK3QHu7C7Ra+Y2JgMhS87x4Al0EfkBhZjVWSRRB0h+snh60HIxN7wBjg3qjTmxR+VuIK
 vHIGkM2sh1mXI3w9h4du1Y9HHVCWlGEQ3/ET4Oj+nKBVOrloa7f+pR4Fyo1kRFLC/7pnf70P0BL
 TAWoDPdi+1+T6dm+fibz3BLI6W85Pk28kJRXt3vLP2KygGemjRLqG2R/5i+Ns7QC+H1csSkpb04
 hOzUDWIDtNamPGf1tcVeVpPqKd9hZ4XKjkeNEzElOF7IAsjnQEe1nJWDvddePskbPACQ8DB8ter
 DWQcOoBs5MKAa5pPL+xMt8R5jnKqztbY4/7m40+h/y5hjFWgh1qeWfDuygrEdFXY6t8jgydxRpW
 jv923OQN8YtDAfE5lYUl/E4FWeErgizaa962lqQheM4jcILJk+YiNRAWmCRhqLZNFjAPEEZaqHA
 3qk5e598lelWgC3gv0A==
X-Authority-Analysis: v=2.4 cv=UbFhjqSN c=1 sm=1 tr=0 ts=69f77524 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=QyXUC8HyAAAA:8 a=ZiqqotMRNkS2OxQDU6sA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-03_05,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605030181

On Fri, 2026-05-01 at 22:18 -0700, Alison Schofield wrote:
> On Fri, May 01, 2026 at 05:01:15PM +0530, Aboorva Devarajan wrote:
> > On Wed, 2026-04-29 at 19:46 -0700, Alison Schofield wrote:
> > > BTT (Block Translation Table) makes persistent memory safe for block
> > > I/O by guaranteeing atomic sector updates. It uses reserved lanes
> > > for in-flight BTT operations, which must be used exclusively.
> > >=20
> > > The btt-check unit test reports data mismatches during BTT I/O due
> > > to a race in lane acquisition, leading to silent data corruption.
> > >=20
> > > BTT lane acquisition uses per-CPU recursion tracking with
> > > migrate_disable(). However, migrate_disable() does not prevent
> > > preemption, so another task can run on the same CPU and share the
> > > recursion state. That task can observe a non-zero recursion count,
> > > bypass locking, and use the same lane at the same time.
> > >=20
> > > Track lane ownership per task and only allow lockless recursion for
> > > the owning task. Otherwise, serialize access with the lane spinlock.
> > > Use spin_(un)lock_bh() so softirq re-entry on the same CPU cannot
> > > bypass ownership checks or deadlock on the lane lock.
> > >=20
> > > Found with the NDCTL unit test btt-check.sh
> > >=20
> > > Fixes: 36c75ce3bd29 ("nd_btt: Make BTT lanes preemptible")
> > > Assisted-by: Claude Sonnet 4.5
> > > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > > ---
> > >=20
> > > Changes in v2:
> > > Use spin_(un)lock_bh() (Sashiko AI)
> > > Update commit log per softirq re-enty and spinlock change
> > >=20
> > > A new unit test to stress this is under review here:
> > > https://lore.kernel.org/nvdimm/20260424233633.3762217-1-alison.schofi=
eld@intel.com/
> > >=20
> > >=20
> > > =C2=A0drivers/nvdimm/nd.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 1 +
> > > =C2=A0drivers/nvdimm/region_devs.c | 48 +++++++++++++++++++++--------=
-------
> > > =C2=A02 files changed, 29 insertions(+), 20 deletions(-)
> > >=20
> > > diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> > > index b199eea3260e..424c38ca4960 100644
> > > --- a/drivers/nvdimm/nd.h
> > > +++ b/drivers/nvdimm/nd.h
> > > @@ -368,6 +368,7 @@ unsigned sizeof_namespace_label(struct nvdimm_drv=
data *ndd);
> > > =C2=A0struct nd_percpu_lane {
> > > =C2=A0	int count;
> > > =C2=A0	spinlock_t lock;
> > > +	struct task_struct *owner;
> > > =C2=A0};
> > > =C2=A0
> > > =C2=A0enum nd_label_flags {
> > > diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_dev=
s.c
> > > index e35c2e18518f..f1c6dcd95b5a 100644
> > > --- a/drivers/nvdimm/region_devs.c
> > > +++ b/drivers/nvdimm/region_devs.c
> > > @@ -905,11 +905,10 @@ void nd_region_advance_seeds(struct nd_region *=
nd_region, struct device *dev)
> > > =C2=A0 * @nd_region: region id and number of lanes possible
> > > =C2=A0 *
> > > =C2=A0 * A lane correlates to a BLK-data-window and/or a log slot in =
the BTT.
> > > - * We optimize for the common case where there are 256 lanes, one
> > > - * per-cpu.=C2=A0 For larger systems we need to lock to share lanes.=
=C2=A0 For now
> > > - * this implementation assumes the cost of maintaining an allocator =
for
> > > - * free lanes is on the order of the lock hold time, so it implement=
s a
> > > - * static lane =3D cpu % num_lanes mapping.
> > > + * Lanes are shared across CPUs using a static lane =3D cpu % num_la=
nes
> > > + * mapping, with a per-lane spinlock to serialize access when multip=
le
> > > + * tasks share a lane (including when preemption causes multiple tas=
ks
> > > + * to run on the same CPU).
> > > =C2=A0 *
> > > =C2=A0 * In the case of a BTT instance on top of a BLK namespace a la=
ne may be
> > > =C2=A0 * acquired recursively.=C2=A0 We lock on the first instance.
> > > @@ -920,35 +919,44 @@ void nd_region_advance_seeds(struct nd_region *=
nd_region, struct device *dev)
> > > =C2=A0unsigned int nd_region_acquire_lane(struct nd_region *nd_region=
)
> > > =C2=A0{
> > > =C2=A0	unsigned int cpu, lane;
> > > +	struct nd_percpu_lane *ndl;
> > > =C2=A0
> > > =C2=A0	migrate_disable();
> > > =C2=A0	cpu =3D smp_processor_id();
> > > -	if (nd_region->num_lanes < nr_cpu_ids) {
> > > -		struct nd_percpu_lane *ndl_lock, *ndl_count;
> > > -
> > > +	if (nd_region->num_lanes < nr_cpu_ids)
> > > =C2=A0		lane =3D cpu % nd_region->num_lanes;
> > > -		ndl_count =3D per_cpu_ptr(nd_region->lane, cpu);
> > > -		ndl_lock =3D per_cpu_ptr(nd_region->lane, lane);
> > > -		if (ndl_count->count++ =3D=3D 0)
> > > -			spin_lock(&ndl_lock->lock);
> > > -	} else
> > > +	else
> > > =C2=A0		lane =3D cpu;
> > > =C2=A0
> > > +	/*
> > > +	 * migrate_disable() keeps the lane stable, but does not prevent
> > > +	 * preemption. Only the owning task may recurse without taking the
> > > +	 * lock.
> > > +	 */
> > > +	ndl =3D per_cpu_ptr(nd_region->lane, lane);
> > > +	if (READ_ONCE(ndl->owner) !=3D current) {
> > > +		spin_lock_bh(&ndl->lock);
> > > +		WRITE_ONCE(ndl->owner, current);
> > > +	}
> > > +	ndl->count++;
> > > +
> > > =C2=A0	return lane;
> > > =C2=A0}
> > > =C2=A0EXPORT_SYMBOL(nd_region_acquire_lane);
> > > =C2=A0
> > > =C2=A0void nd_region_release_lane(struct nd_region *nd_region, unsign=
ed int lane)
> > > =C2=A0{
> > > -	if (nd_region->num_lanes < nr_cpu_ids) {
> > > -		unsigned int cpu =3D smp_processor_id();
> > > -		struct nd_percpu_lane *ndl_lock, *ndl_count;
> > > +	struct nd_percpu_lane *ndl =3D per_cpu_ptr(nd_region->lane, lane);
> > > =C2=A0
> > > -		ndl_count =3D per_cpu_ptr(nd_region->lane, cpu);
> > > -		ndl_lock =3D per_cpu_ptr(nd_region->lane, lane);
> > > -		if (--ndl_count->count =3D=3D 0)
> > > -			spin_unlock(&ndl_lock->lock);
> > > +	if (WARN_ON_ONCE(READ_ONCE(ndl->owner) !=3D current))
> > > +		goto out;
> > > +
> > > +	if (--ndl->count =3D=3D 0) {
> > > +		WRITE_ONCE(ndl->owner, NULL);
> > > +		spin_unlock_bh(&ndl->lock);
> > > =C2=A0	}
> > > +
> > > +out:
> > > =C2=A0	migrate_enable();
> > > =C2=A0}
> > > =C2=A0EXPORT_SYMBOL(nd_region_release_lane);
> > >=20
> > > base-commit: 028ef9c96e96197026887c0f092424679298aae8
> >=20
> > Hi Alison,
> >=20
> > Just a follow-up question.
> >=20
> > I haven't reproduced this, just noticed it while reading the code.
> >=20
> > After this patch, nd_region_acquire_lane() / nd_region_release_lane() a=
lways
> > hold a spinlock, IIUC, anything that sleeps/blocks in this critical sec=
tion will
> > hit:
> >=20
> > =C2=A0=C2=A0=C2=A0 BUG: scheduling while atomic: ...
> >=20
> > BTT metadata writes go arena_write_bytes() -> nvdimm_write_bytes() ->
> > nsio_rw_bytes(), which always calls nvdimm_flush() on write. That can c=
all
> > nd_region->flush():
> >=20
> > =C2=A0 - virtio_pmem_flush() uses a wait_event(), so it can block on
> > =C2=A0=C2=A0=C2=A0 every flush.
> >=20
> > =C2=A0 - papr_scm_pmem_flush() only msleep() when the flush hcall
> > =C2=A0=C2=A0=C2=A0 comes back busy; the fast path does not sleep, thoug=
h this is rare case.
> >=20
> > So BTT on virtio_pmem looks like it could trip the BUG on metadata
> > writes, papr_scm only if the busy path is taken? Pre-patch, the same be=
haviour
> > already existed on > 256-CPU boxes where the lane spinlock was taken.
> >=20
> > Is this an actual concern, so are we essentially saying that no sleep /
> > blocking wait is allowed anywhere reachable from the lane critical sect=
ion?
> >=20
> > Please correct me if I'm missing something here.
>=20
> Thanks for the review. You found a real issue.
>=20
> The BTT lane lock is held across BTT write paths that can reach
> nvdimm_flush(), and provider flush callbacks (e.g. virtio_pmem and
> papr_scm) can sleep. So the current design incorrectly assumes that
> the lane critical section is fully atomic.
>=20
> As you pointed out, this predates this patch. The shared-lane path
> has held a spinlock across this same call chain since the original
> BTT merge. This patch probably widens the exposure by taking the lock
> unconditionally.
>=20
> I'm reworking this as a small series. The first patch converts the
> per-lane lock to a mutex so the lane critical section can safely
> sleep.

sure Alison, Thanks.

>=20
> I appreciate your testing and will probaly need to rely on it more
> in the next version.
>=20
> Thanks,
> Alison
>=20
> >=20
> > Thanks,
> > Aboorva
