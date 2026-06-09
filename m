Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B3A378838;
	Tue,  9 Jun 2026 12:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781007029; cv=pass; b=i6dVe2LbVnFcqTl9M/RNN8BVaymyQnHoKlol5Xi04lUvN370IDVgla6LwHs7vEK02z1vNzfgN1Is9eMWSrEUpjHd2KG+70BhdfquteJCrudpX4Zsm8lzHLo4xSOzDbDLFgUqMtcYaYnPuEiVpv7Vz96O3UlFHgxlMowYW22ObG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781007029; c=relaxed/simple;
	bh=ZBJobU+O9hMiZ83JsJK8YLhIxWlH7xEFY81qfpXGJtY=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=HPcU7J8zyK1OA0mjsjINSATv27VXNO85MZcuZsH6XJ1FwoRXSMZor31+t4WCF9hxuGoRKCdVY1b/Wus/4NI88mVVJYQNQKsdaTfdYR/3oMVGtj1oM2DC4mE4vTL+GGv9R+v68jWQuzQPixKIsRm+/xIMS8lO3Wc/3AUzAt5t1f0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=QfjsGqZI; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="QfjsGqZI"
ARC-Seal: i=1; a=rsa-sha256; t=1781007025; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=YBDXQeVyr3hylYGDY8FM+2bE49og/YkYiSv5WZYJRy5SE9s2NqgrisL13BWsAOArRjazwgRhJPQ6HtGB6mdPKqw3ntF+DnWLYHM0Tt7N4+QbjwfT6zDB1Rn8IlD1AmbHTIwDTa1OALeS0QPWieO+VKU1dU9kovB1D3gtaDGL1/Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1781007025; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=4bXYzfVURMwu4+F7eCQ3DTcmf+jZ3xCo5JvSlXXQwHM=; 
	b=haAiJD2MYX6kbHW4LBJoOMhP2xeS4G/iJe4gfLvG7C254c8PgYRkRjPSwI80o40psq0mAGr0LlD31huUcfAV1TKjxcJ5IBMIm3+83ucob/+vShiPVU2m5lXeyKD9tdcNv9RNjNZWcE3/pT8OnT7cdcOEtIl2SNP/RqMUkawo07c=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781007025;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=4bXYzfVURMwu4+F7eCQ3DTcmf+jZ3xCo5JvSlXXQwHM=;
	b=QfjsGqZIlVHzbXMr1TRxXAk4jzkK/Di3rFXashct47KOLktbh3dWGI/yqrDBLDxq
	ZXXYMuKW88wDOk1AFsya0kjXMLVvr2BrlsiKvvj4kdwA6mgWRHWrlP02z30x7RKYosd
	RN6gj7Wc8Y6SAwfrPOoaiKmnQCXAifgox/itiLKs=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1781007023758237.3739416207793; Tue, 9 Jun 2026 05:10:23 -0700 (PDT)
Date: Tue, 09 Jun 2026 20:10:23 +0800
From: Li Chen <me@linux.beauty>
To: "Alison Schofield" <alison.schofield@intel.com>
Cc: "Pankaj Gupta" <pankaj.gupta.linux@gmail.com>,
	"Dan Williams" <dan.j.williams@intel.com>,
	"Vishal Verma" <vishal.l.verma@intel.com>,
	"Dave Jiang" <dave.jiang@intel.com>,
	"Ira Weiny" <ira.weiny@intel.com>,
	"virtualization" <virtualization@lists.linux.dev>,
	"nvdimm" <nvdimm@lists.linux.dev>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <19eac4a7e7d.66c485541986665.1385164415754211830@linux.beauty>
In-Reply-To: <ah43Hsur7KuTD-2c@aschofie-mobl2.lan>
References: <20260226025712.2236279-1-me@linux.beauty> <ah43Hsur7KuTD-2c@aschofie-mobl2.lan>
Subject: Re: [PATCH v3 0/5] nvdimm: virtio_pmem: fix request lifetime and
 converge broken queue failures
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

Hi Alison,

 ---- On Tue, 02 Jun 2026 09:51:26 +0800  Alison Schofield <alison.schofiel=
d@intel.com> wrote ---=20
 > On Thu, Feb 26, 2026 at 10:57:05AM +0800, Li Chen wrote:
 > > Hi,
 > >=20
 > > The virtio-pmem flush path uses a virtqueue cookie/token to carry a
 > > per-request context through completion. Under broken virtqueue / notif=
y
 > > failure conditions, the submitter can return and free the request obje=
ct
 > > while the host/backend may still complete the published request. The I=
RQ
 > > completion handler then dereferences freed memory when waking waiters,
 > > which is reported by KASAN as a slab-use-after-free and may manifest a=
s
 > > lock corruption (e.g. "BUG: spinlock already unlocked") without KASAN.
 > >=20
 > > In addition, the flush path has two wait sites: one for virtqueue
 > > descriptor availability (-ENOSPC from virtqueue_add_sgs()) and one for
 > > request completion. If the virtqueue becomes broken, forward progress =
is
 > > no longer guaranteed and these waiters may sleep indefinitely unless t=
he
 > > driver converges the failure and wakes all wait sites.
 > >=20
 > > This series addresses both issues:
 > >=20
 > > 1/5 nvdimm: virtio_pmem: always wake -ENOSPC waiters
 > > Wake one -ENOSPC waiter for each reclaimed used buffer, decoupled from
 > > token completion.
 > >=20
 > > 2/5 nvdimm: virtio_pmem: use READ_ONCE()/WRITE_ONCE() for wait flags
 > > Use READ_ONCE()/WRITE_ONCE() for the wait_event() flags (done and
 > > wq_buf_avail).
 > >=20
 > > 3/5 nvdimm: virtio_pmem: refcount requests for token lifetime
 > > Refcount request objects so the token lifetime spans the window where =
it
 > > is reachable through the virtqueue until completion/drain drops the
 > > virtqueue reference.
 > >=20
 > > 4/5 nvdimm: virtio_pmem: converge broken virtqueue to -EIO
 > > Track a device-level broken state to converge broken/notify failures t=
o
 > > -EIO: wake all waiters and drain/detach outstanding requests to comple=
te
 > > them with an error, and fail-fast new requests.
 > >=20
 > > 5/5 nvdimm: virtio_pmem: drain requests in freeze
 > > Drain outstanding requests in freeze() before tearing down virtqueues =
so
 > > waiters do not sleep indefinitely.
 > >=20
 > > Testing was done on QEMU x86_64 with a virtio-pmem device exported as
 > > /dev/pmem0, formatted with ext4 (-O fast_commit), mounted with DAX, an=
d
 > > stressed with fsync-heavy workloads.
 > >=20
 > > Thanks,
 > > Li Chen
 >=20
 > Hi Li Chen,
 >=20
 > Today I took a look at this set, noting that it's been sitting idle=20
 > in our nvdimm backlog for a while. I'm not able to apply it. Can you
 > post a new rev that applies to 7.1-rc6 ?
 >=20
 > Thanks,
 > Alison

Sorry for my late reply. I have just sent v4(https://lore.kernel.org/all/20=
260609120726.1714780-1-me@linux.beauty/)
which can be applied to 7.1-rc7. Thanks for your comment.

Regards,
Li=E2=80=8B

