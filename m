Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF5B38E5EC;
	Wed, 25 Feb 2026 11:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772020111; cv=pass; b=GseNQZilOBVW/tv5QhUiO+jXwdtyEPkv3aHAlzp2NOYygKMieuO53a6KePcp3oE2+zdO3xiCsoQf3dlFQcVhdChco51/WnIkIMlWzh+NU2RCv30/saHWUeIPtM3ouTHMjzU6Nk+YzJtmc8riLA8HvuvS+Naq2uTXrdDtPQhkIoU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772020111; c=relaxed/simple;
	bh=dZ3edq/YN6yQDqlZKy2z3+87IqHY2WFKWha60KtK70M=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=je4LMPLan1aQlcRyGUWtuFBk/vjGoa2+RSL0FfDRAE8mHds8zRpR3UjRFrfLopR77aHEdJxT7eQl+1QU40dT1Xb3HOjHUE2Ur8k9KquU4XCw4sNFO+N0/jTwO7e2QpGoNCsYVUkeSX96x8VU/yQ2fUKig7SnWTley0WZfr5AzKI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=pftnYqcj; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="pftnYqcj"
ARC-Seal: i=1; a=rsa-sha256; t=1772020107; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=n0KzHypN0j0jHI5jvVMpfa7zsrbzFofqOwKFj0+YlbOzl/K0IsrxW4WalLGHVN1ed9jZGK0P4Swbm/BwutrddYJqSB55dNjVnuex9/aJ0nfbqY2Kiz32YjY6GJxQYvyNrs5+8UcAfZ2xWZc6qJrstRGKGmcXFn/wRuuCjY9iCms=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1772020107; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Mw4X7rzEo/voq+9aFt3+RLX+tEWI//MWMUQ1Cc8L5Jo=; 
	b=AZpYQGZrcg2qaRdeFyw0Wry2aQcZmDUVVXoo7aqZnA0VTRoOL0+l0Um1AmRCRDmOHyiKse/VJOqKO0QkyBCqFjirY53wjfIf/PMOYE+OustQXLn/fR9h45a1TA3obrsm9Dtj7WGNbodlY4eXZwAZOpH7kgGruJ5n0/gZ84ApArQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772020107;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Mw4X7rzEo/voq+9aFt3+RLX+tEWI//MWMUQ1Cc8L5Jo=;
	b=pftnYqcjy+flAAUyHUVQpi2T8WwxIF70yWRMaXzs87cTZYLc4UH/M0ZO1QvDbJAv
	LhAK8rgWV31PdAxbj5bKkx6aqhlX1P/gRMjphVMhj4ruDrfdykao0A0VO553dUKSptq
	YCeFqxDG7dOZoUn9db+lF5aHeacRHw9LS84sfo/Y=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1772020105190349.0088443322775; Wed, 25 Feb 2026 03:48:25 -0800 (PST)
Date: Wed, 25 Feb 2026 19:48:25 +0800
From: Li Chen <me@linux.beauty>
To: "Pankaj Gupta" <pankaj.gupta.linux@gmail.com>
Cc: "Dan Williams" <dan.j.williams@intel.com>,
	"Vishal Verma" <vishal.l.verma@intel.com>,
	"Dave Jiang" <dave.jiang@intel.com>,
	"Ira Weiny" <ira.weiny@intel.com>, "nvdimm" <nvdimm@lists.linux.dev>,
	"virtualization" <virtualization@lists.linux.dev>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"Michael S . Tsirkin" <mst@redhat.com>
Message-ID: <19c94a0ffd6.516800b7913233.1342136136744840318@linux.beauty>
In-Reply-To: <CAM9Jb+jvbEQ48=abnQDKwtTEBtuJ0im8SVP+BwTQz-OLh9g6mQ@mail.gmail.com>
References: <20251225042915.334117-1-me@linux.beauty> <20251225042915.334117-2-me@linux.beauty> <CAM9Jb+jvbEQ48=abnQDKwtTEBtuJ0im8SVP+BwTQz-OLh9g6mQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/5] nvdimm: virtio_pmem: always wake -ENOSPC waiters
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

Hi Pankaj,

 ---- On Fri, 02 Jan 2026 20:29:59 +0800  Pankaj Gupta <pankaj.gupta.linux@=
gmail.com> wrote ---=20
 > +CC MST
 > > virtio_pmem_host_ack() reclaims virtqueue descriptors with
 > > virtqueue_get_buf(). The -ENOSPC waiter wakeup is tied to completing t=
he
 > > returned token.
 > >
 > > If token completion is skipped for any reason, reclaimed descriptors m=
ay
 > > not wake a waiter and the submitter may sleep forever waiting for a fr=
ee
 > > slot.
 > >
 > > Always wake one -ENOSPC waiter for each virtqueue completion before
 > > touching the returned token.
 > >
 > > Use READ_ONCE()/WRITE_ONCE() for the wait_event() flags (done and
 > > wq_buf_avail). They are observed by waiters without pmem_lock, so make
 > > the accesses explicit single loads/stores and avoid compiler
 > > reordering/caching across the wait/wake paths.
 > >
 > > Signed-off-by: Li Chen <me@linux.beauty>
 > > ---
 > >  drivers/nvdimm/nd_virtio.c | 35 +++++++++++++++++++++--------------
 > >  1 file changed, 21 insertions(+), 14 deletions(-)
 > >
 > > diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
 > > index c3f07be4aa22..6f9890361d0b 100644
 > > --- a/drivers/nvdimm/nd_virtio.c
 > > +++ b/drivers/nvdimm/nd_virtio.c
 > > @@ -9,26 +9,33 @@
 > >  #include "virtio_pmem.h"
 > >  #include "nd.h"
 > >
 > > +static void virtio_pmem_wake_one_waiter(struct virtio_pmem *vpmem)
 > > +{
 > > +       struct virtio_pmem_request *req_buf;
 > > +
 > > +       if (list_empty(&vpmem->req_list))
 > > +               return;
 > > +
 > > +       req_buf =3D list_first_entry(&vpmem->req_list,
 > > +                                 struct virtio_pmem_request, list);
 >=20
 > [...]
 > > +       list_del_init(&req_buf->list);
 > > +       WRITE_ONCE(req_buf->wq_buf_avail, true);
 > > +       wake_up(&req_buf->wq_buf);
 >=20
 > Seems with the above change (3 line fix), you are allowing to wakeup a w=
aiter
 > before accessing the token. Maybe simplify the patch by just
 > keeping this change in the single patch & other changes (READ_ONCE/WRITE=
_ONCE)
 > onto separate patch with corresponding commit log.

Sorry for the late reply, I just realized I somehow missed this email :-p

Thanks for the suggestion. I'll do it in v3.

Regards,
Li=E2=80=8B

