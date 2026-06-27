Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231A12949E0;
	Sat, 27 Jun 2026 08:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782550397; cv=pass; b=d2Kp3yDgXJJ3NSog4DAIExCg+S0YRk6AVNBPqGrxQQ69iHp0+GahBN0EiKKwYrInyip+ZbujWHt7gs6pJt727FnmNBLuYzuwG2xuDBpTyhNYvSd9bJcVFhDBrmMwDbmZH1XZDdzdxXxdLsc5Y+qWwpa1R52jaFaWzqoIKle8mag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782550397; c=relaxed/simple;
	bh=Rzk5L0awvCvWEAsORzQ9bQ2zCXjrnt8nmPAZ8JNHQu4=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=E6041l+5OK6mFyCpV46kOzCOjtFFlzA7FDq8105jAVdIuDVHFDc01eVUoI1zUaD3WSRzXjz1wyUPSLpUpvnmYpS853zZV94H/PDbbBHyOZRbXbspiqHpSEmo3f/jNu3iCGq56V0loV+zu728mDAZF02wAuNtsrQRr/i2jSsT6ss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=XZBj3KvI; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="XZBj3KvI"
ARC-Seal: i=1; a=rsa-sha256; t=1782550392; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=FrklaJkEGMZdRVcDiAEIPgrUcTprK/8kYOEiW6q+SQkLSFExW/AX3ctsszbvkJ/+bqTTEZP9pgV+ZYY1+WPqrPSZp+mxl89X1jUF2/d89YLJpXKCm69uFfTbuslWaGROCUZ6/H06fIWChXgmzTwxfg15jnAzIs7txpTXAkss4YU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782550392; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=XRr9atgIwN93/df1+0fKjKE769Lk7ZWwqIUKWgTaXI0=; 
	b=S9U3g6IAkOG2Aebq4/3QTCfu9WvtMJB0QbGEbFZnyrM4NgZPw7G19Su+FtLHavyam7Ci1ttrYZ1DSfy5avgA6YuRA/4dAyxPVDWWbbd5x3+o7HEYsVIw2UADh08nOH8BxGJkv1JBRyP1tcxvBMUTxkT9Hzvg9ZwstfmlgN+xvKI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782550392;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=XRr9atgIwN93/df1+0fKjKE769Lk7ZWwqIUKWgTaXI0=;
	b=XZBj3KvIKN7rvDGGIzY+5oB/YwZnfyv4m90tUs5TcyRcCeeLOe/6oUoXURVWwVsM
	qCmgeRzVlinh5siLdJWxKvLYnJhgQJlo36DvGaMiRKNG3JpKRS900gUIcRZeI5CmrJO
	2waS5UEG5WQDuPGit9m/rMlttoiyawcELroNiIeA=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1782550391677430.979504149547; Sat, 27 Jun 2026 01:53:11 -0700 (PDT)
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1782550389067617.6778432013716; Sat, 27 Jun 2026 01:53:09 -0700 (PDT)
Date: Sat, 27 Jun 2026 16:53:08 +0800
From: Li Chen <me@linux.beauty>
To: "Pankaj Gupta" <pankaj.gupta.linux@gmail.com>
Cc: "Dan Williams" <dan.j.williams@intel.com>,
	"Vishal Verma" <vishal.l.verma@intel.com>,
	"Dave Jiang" <dave.jiang@intel.com>,
	"Ira Weiny" <ira.weiny@intel.com>,
	"Alison Schofield" <alison.schofield@intel.com>,
	"virtualization" <virtualization@lists.linux.dev>,
	"nvdimm" <nvdimm@lists.linux.dev>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <19f084860c8.3959ac405441214.5537045160824133666@linux.beauty>
In-Reply-To: <CAM9Jb+hf6KEWRKtWr6PQByRQ869jL6Ws7J_ShFjKY_YicTbS_g@mail.gmail.com>
References: <20260621130246.2973254-1-me@linux.beauty> <20260621130246.2973254-2-me@linux.beauty> <CAM9Jb+hf6KEWRKtWr6PQByRQ869jL6Ws7J_ShFjKY_YicTbS_g@mail.gmail.com>
Subject: Re: [PATCH v6 01/12] nvdimm: preserve flush callback errors
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

 ---- On Tue, 23 Jun 2026 17:46:20 +0800  Pankaj Gupta <pankaj.gupta.linux@=
gmail.com> wrote ---=20
 > > nvdimm_flush() currently converts any non-zero provider flush error to
 > > -EIO. That loses useful errno values from provider callbacks.
 > >
 > > A local virtio-pmem mkfs sanity test showed the masking clearly:
 > >
 > >   wipefs: /dev/pmem0: cannot flush modified buffers: Input/output erro=
r
 > >   mkfs.ext4: Input/output error while writing out and closing file sys=
tem
 > >   nd_region region0: dbg: nvdimm_flush rc=3D-5
 > >
 > > The virtio-pmem callback can return -ENOMEM when async_pmem_flush() fa=
ils
 > > to allocate a child flush bio, but nvdimm_flush() hides that as -EIO b=
efore
 > > pmem_submit_bio() converts it to a block status.
 > >
 > > Return the provider callback error directly. The generic flush path st=
ill
 > > returns 0, and pmem_submit_bio() already handles errno-to-blk_status
 > > conversion for bio completion.
 > >
 > > Signed-off-by: Li Chen <me@linux.beauty>
 > > ---
 > > v3->v4:
 > > - New patch.
 > >
 > >  drivers/nvdimm/region_devs.c | 6 ++----
 > >  1 file changed, 2 insertions(+), 4 deletions(-)
 > >
 > > diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs=
.c
 > > index e35c2e18518f0..0cd96503c0596 100644
 > > --- a/drivers/nvdimm/region_devs.c
 > > +++ b/drivers/nvdimm/region_devs.c
 > > @@ -1114,10 +1114,8 @@ int nvdimm_flush(struct nd_region *nd_region, s=
truct bio *bio)
 > >
 > >         if (!nd_region->flush)
 > >                 rc =3D generic_nvdimm_flush(nd_region);
 > > -       else {
 > > -               if (nd_region->flush(nd_region, bio))
 > > -                       rc =3D -EIO;
 > > -       }
 > > +       else
 > > +               rc =3D nd_region->flush(nd_region, bio);
 >=20
 > IIRC this was introduced as a generic populate error type since a
 > failed flush can also propagate host-side errors, which may not be
 > relevant to the guest.
 > That said, we could still consider handling specific cases like
 > -ENOMEM, unless there is a better approach to address this.

Ah, yes, you are absolutely right. I went too far here.

Regards,
Li=E2=80=8B


