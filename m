Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FBD4734D4
	for <nvdimm@lists.linux.dev>; Mon,  5 Oct 2026 13:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791207210; cv=pass; b=DX+c2VgAqnv3YWJcs3wvPDFYo6M8H9pryoq8thJD5Dn+J8PjUSWn24SmAYs5UT6REsSLOpqHaMSpTDHVPminTGrcUy4SaDGh/inbGObZC2iOs7QFKJKLQcD6h1WhmrNJqpucLgCUj7UbtjJcd/9vy6VZ5/0CnbrqYWveMd9926k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791207210; c=relaxed/simple;
	bh=I/7qOpbaPjFZCfk8Hbfl7OK+toY69qdxL0Ly1nx8uco=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ri0mkdlyhwjJYr7kMjUXoqhwEZv0YPnDjymRwE55s2KQ+0KXWf31Oq3zC5tD2S/Hr4neOVot46Q8o8kjDuqnjkuY5HFlpI9rFeoMeBcB5HyXkvb8QXn4dy4HX1AutSptbVG3lBW1yRN3G8AZMSMh1geCTQhfQbD8A8YMGdXcbnE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=N6Pm7ePu; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="N6Pm7ePu"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5350c1b9e0dso25142991cf.0
        for <nvdimm@lists.linux.dev>; Mon, 05 Oct 2026 06:33:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791207207; cv=none;
        d=google.com; s=arc-20260327;
        b=O5ncKbIABnOIEIiVuR9uqtq7yGycjsszaQP5BzOviR7f6HWjxxXmRI2o1oOkyLrFjz
         9GDT4NTXtCuwA0c3pLrEfjyG6AfPOLD5fF+kllF5r0B9gEJe/iPDvwCUQ8i1s9kiHrNw
         YGha3qA6Tz9IfcZXHp/L7sIbZ5s5e7Um7C5tbZtMydQhX4cE45do90V9stEWScH6Atdz
         zk6G0ZcjbLR0xBmxFu6a7nj9bZDHeQ7vuQRThmtv40AVk60XM1N01B8yi2mqRkn+/QH/
         ByoTNGk2n4lXiZLbQ8Q2BVlEETgmKoZ0yxKq5f8vOy88xxsH4l4dIbm+CSdfE+u8Hpn9
         xj9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=7otsqulBzc6rkKlGohX6jHgXmZfiW8WkwVHav/09IiY=;
        fh=xl6OdDQ3PDomADplbfDYnut0bkxZdmSAp18S7XN+Ou0=;
        b=Xqpg/UB9lzkD3KTmC6lfbaxDpq5F8zSZgmu/yTiEMRRIonTqLKHTbGNAA2T/lE3obu
         OqYcDuERQqomyryqlnktlCmhXn2Gd/oKKeNMptE8vbl8waZjFZUM74Bu+r5ndtx4vfM3
         u3XKmBfS/Jd/55W9xGY8iv12VLeij9HNptaoObYeiDInhkxzVUpt7GgCtjdvGDqeEpHM
         rXr/OePVP20AdZfB9vTGf4+jAhNgO0KkODiWxqXmsIWxyLNbwRD5UiY1LczbusLkKLBB
         8MPD9QZf7QPR4wEouH4nbQG4z3t5C2QqKvzGKL6/QiDm5c3uMDvi5zu2+vo+G/nrf9L7
         BUSw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1791207207; x=1791812007; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7otsqulBzc6rkKlGohX6jHgXmZfiW8WkwVHav/09IiY=;
        b=N6Pm7ePu/EL8WkBbZL/7V3x2BZ0Us2Si3cYGKJhvQubynK3n+E0SrGK8pjoLS7opuv
         HNETtsNcGUhDFTx84xhvTLLaqfhpG0LRedwc0v5cSFmvYoi+Uf1DASH6AMjp/bAOc65P
         xIFqUz/E7iBhmAeRsuAOXIrSZ2siJOuzy+Rto=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791207207; x=1791812007;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7otsqulBzc6rkKlGohX6jHgXmZfiW8WkwVHav/09IiY=;
        b=Tg1k0sCNpLt/Pzi0UHNy9VQhjFmJUjFtWA28E+1kuFtWUx1J6RD4uR61o2UH4oib8H
         qJO0e6fqEeRneEzlehhHByY5q1FchwED67iIHnC6fPx0sbclJ+9FCKolD7dCPo1mNuLy
         MpmQxs/GNg4QnK2d9zdoooZZmNA75mBPHXSc3BtSaBSIhkAPAE/D02BTeBb+wx3Ct25r
         gw3NoWG+Ski60lnpX4TL4mSB/cBVHz88IVED6/UnlHWQ1xnudZIV3S463DYY+FPEcHJ2
         WvAxX6A1HQrjvq36tsB9kMLkS9/OVNherVGrmFsy+Z3lvO14uEfGwFM446xkJrylWjbv
         ipOQ==
X-Forwarded-Encrypted: i=1; AKwUvByTlNR9OG+IhwYsZycfABD/xNyAL5HxROGb8rzwL3QZrUHgneWRhbbhJyefyjQiAnakEn395nE=@lists.linux.dev
X-Gm-Message-State: AFuF++nzskvWbOWVwtIymUhzxXWVm8DsPBx7h+xYTCLvttJS0B3KUjNg
	sKm0mfWjW8uoxYCgPsMLOq9+cJosT99BUCrY2g+1/uAlyIPnvkAOi6ZKWYbvgL5SlQd9Pi6n9wz
	3xC7Kxo4L3/o+A9d50DIYAcwbhUx9eLWOQXfKReq5DA==
X-Gm-Gg: AYBFou2zUYfS6+0maxB5/+6K5X0paDRoDxzpq2mn3wSf2U1ykt45mi8YaYJiv1FbFxi
	hjiGZS5S9A74u7p2wJ5ZGzyRlw0x5aVX7s6zXt+i3cdcZWk2TxhZgLkihLb0Y95WerNosddoApW
	jKbnZv4vWz7UTz2ZnpODT8MJ9c0a4evTZ56fqRHctOGdOXUIbnxoERdOxq7tAiLO5KOoCclUwVI
	C4Qwlpv0y1An5j9oHNf+l1mRYwBbRN+RNC6aO/XZIi5gPu0k1fTo2vy/SuW8cQ6seV416ROATt8
	LitUd4Crfs0xD2FGxAr6/RRRlJhKI/AGBiQcOndYxj3eo2mYTPsZ1VhbNV0sZqerXLOS++gsTah
	q0JqOX86Dq//GPiy1uzMjOmc=
X-Received: by 2002:a05:622a:1ba6:b0:533:9826:a9ac with SMTP id
 d75a77b69052e-53511e43589mr124329411cf.20.1791207207172; Mon, 05 Oct 2026
 06:33:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261001150935.655979-1-mszeredi@redhat.com> <20261001150935.655979-4-mszeredi@redhat.com>
 <CAOQ4uxjWCRs59Qpc4t+2=i67rdJkHt=+rH07ZXv7ZzAvTjTm-A@mail.gmail.com> <CAOQ4uxi1+WgHJdnRKMD3tp24EOyx7iPByzSKLn_siTVY3_sRDQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxi1+WgHJdnRKMD3tp24EOyx7iPByzSKLn_siTVY3_sRDQ@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 5 Oct 2026 15:33:15 +0200
X-Gm-Features: AclHuK98SWoqABe7rwTyIrlCpXfPZvMeW8Yn8TO-gyQNFntxAo01LmvUy6dhY_s
Message-ID: <CAJfpegttAHQAGhE61t-VZqfQv9Z==ovbyLY6qp3KOK_CvjBciA@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] fuse: support 64 bit, server allocated backing ID
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, fuse-devel@lists.linux.dev, 
	John Groves <john@groves.net>, "Darrick J . Wong" <djwong@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 1 Oct 2026 at 20:59, Amir Goldstein <amir73il@gmail.com> wrote:

> > > All 64 bit values are valid.
> >
> > Can you reserve id 0? or have a reason to need it?

I thought that removing all restrictions on the value would be nice.
But okay, zero value we can live without.

> > It would feel a little less hacky if we do:
> >     else
> >           fuse_backing_files_init_32(fc);
> >
> > and set
> >          fc->passthrough = 1;
> >
> > inside both of them to gate against fuse_backing_files_free()
> > called without processing init response,
> > or without either FUSE_PASSTHROUGH in the init response.

Bigger problem is that IOC_BACKING_OPEN can be done before or during
INIT.  So we need to take care of that case and the race as well.
Fixed by:

 - leaving the idr initialization fuse_conn_init()

 - adding fc->backing_id_32 flag which is set by fuse_backing_open()
after chekcking that fc->backing_id_64 is not set.  All under fc->lock

 - in process_init_reply() checking fc->backing_id_32 before setting
fc->backing_id_64 and failing the connection if so.  Also under
fc->lock

 - in fuse_dev_ioctl_backing_create() if fch->initialized is not set
return ENOTCONN

> Also we should not enable passthrough if rhashtable_init has failed.

rhashtable_init() can't fail if parameters are correct since it falls
back to __GFP_NOFAIL() for allocation.

Thanks,
Miklos
