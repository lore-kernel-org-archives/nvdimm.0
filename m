Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14DC2222D1
	for <nvdimm@lists.linux.dev>; Sat, 22 Nov 2025 07:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763797608; cv=none; b=MX2fNtEIQqbxDTq1CZ3vLUrvG3DdtSRn1LlWYxur1xnoNTTXMHOig7UBN9+rcS/UnRqeLnWDO+ALNpabgcnJ4QD2UlZSZIl7iPX7ywm++b+NfmGEOMKVy83svM7X4DuoI2eieiu4mpiV0klfdQqRy1kmOYqPMkjAWVEqbAS2jT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763797608; c=relaxed/simple;
	bh=Q2I4fYvh4oepaGQS7zTzvtbJbgRyZjD4TiTFO6vRTII=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZrcfA9OdAgTws+RL9Z/RlJWTE2AHxKhqv+aJQOSZF3lSu5Y/O8X7jGOjN8f/m2xxEMgCqIXkc2Ni1WMA4ny0/A43u2E6f7H4tJ5gTbu1PskUo54eWXuheBP3w4KzO2kU9wEfkuth50uJ8+mMNSnxe0XAC+Gn5Pg05GJm9wHDlqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BOdFpYjd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BOdFpYjd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763797604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NzKDrDr19qM8qzMg2r6gHYZungvxwnQDvei/yhzW154=;
	b=BOdFpYjdANHYcgig1kvj/A5jCJQEn8McwMgA/llycijMZnaJ9cAS+ZkPdzGoCeuGtrIz13
	NUOvHKMlW9GrXrGt9UGZ/0xTlTaquliK27GPix8sgZLEbRPyL4B+U1DO9hBU2WXe/r0dbC
	i6nbGawj9rGGyepAV+nthfkMHG7Gz/c=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-kNC59OJRORGxqkOfR_O91A-1; Sat, 22 Nov 2025 02:46:42 -0500
X-MC-Unique: kNC59OJRORGxqkOfR_O91A-1
X-Mimecast-MFC-AGG-ID: kNC59OJRORGxqkOfR_O91A_1763797601
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-63e1cca3558so3234559d50.1
        for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 23:46:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763797601; x=1764402401;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NzKDrDr19qM8qzMg2r6gHYZungvxwnQDvei/yhzW154=;
        b=LYi1JJzxqoZmtoL3YGUPoKZZKodTGooQCZQyHaV0vTbJo6Kfe5lbnL5Se8ynJEfcev
         gf4Vu+gv5cvucAgrJ6nKThOI3BM/kbHJpOTPjqo+7PJe2Ed8Kpg9XQ91PVJb0Ek01A0Y
         j802z5hoqbCxbiPav8aAW625WUW19r5TM8kUIpOLtvxFgV5U1Up6Ok6IrVXxj47S6YQu
         vN3KUQJz0zOXchJ5paZ5Dk09mZm29Xhncx6QVOxbJbMcch0+YGLjpjXyEYtefj7eSPEd
         eL3a9m/pixAFWV5Kx46ZQLAoQcWLDwJQilxIM6a7nkwz2uXpyByAoihuK6cpaRcLIZIB
         AD3g==
X-Forwarded-Encrypted: i=1; AJvYcCUHGrPQxKFlNmhTZuSPdqXfcn2W9tFtzaNT2idSJmnAAVAgrUuh0U1beRxNCgnkOXdybEmapJI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxK63++dASk7an6dtnUBD5HFYg6RCklxzSI4MLp484wG33jfayP
	0JOnl1P8TUVsx5qLzzuE7BG4Vm0Rl2BEaR9fymaBO1OPJAwvAL+cosyw3NiVL5qRAzeuaTrV19U
	qCNN1I5NdVbXzx3CjQaaUXfsDxCiZsb7I0JaY79BugXDN0ZyPTCKvQ+s2v9tHh3lsvvLH0omt+z
	M+JcA+J6xA2LHrpOIzTjN5YlvEsW/DMHEP
X-Gm-Gg: ASbGnctorNNt9e/T/DxB2Bh5p7Ql0ynbIc0CJJe0lAXI9bjBn8CTwIuEhYj0BbXtlwZ
	GB3R0KUcHhx5rXrcwjEasoE3/Zq2fFJ9aGrsZWjHQSw9BqQVFnBbkAP353uB+IEbJ20Z3EzghsI
	cVs/nzSHrrLPTvXPLivmk05Kb0t/MNOinqFPznULvoiGGiZLG6TYnmT7EA2oJ7K8HC
X-Received: by 2002:a05:690c:b98:b0:781:64f:2b1a with SMTP id 00721157ae682-78a8b56828cmr79989347b3.60.1763797600944;
        Fri, 21 Nov 2025 23:46:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHT6ReihqZuKDslp4v6LlKyjNYk5cYZ5oqfMTnv4XvlKobsBj9Saq/UGtRReN9JAQWVmvP6mmp+/fX9V/OmqWs=
X-Received: by 2002:a05:690c:b98:b0:781:64f:2b1a with SMTP id
 00721157ae682-78a8b56828cmr79989177b3.60.1763797600562; Fri, 21 Nov 2025
 23:46:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <aSEvg8z9qxSwJmZn@fedora> <CANubcdULTQo5jF7hGSWFqXw6v5DhEg=316iFNipMbsyz64aneg@mail.gmail.com>
In-Reply-To: <CANubcdULTQo5jF7hGSWFqXw6v5DhEg=316iFNipMbsyz64aneg@mail.gmail.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Sat, 22 Nov 2025 08:46:29 +0100
X-Gm-Features: AWmQ_bkNPMPKGc9hcr0WMHGjLmVXZ8Lp-bk_Jm40n6CY0-WAnMeo9R7n5uUvirQ
Message-ID: <CAHc6FU5ofV7s3Q4KBGFJ3gExwsMpbaZ9Vj0FEHqrOreqvQMswQ@mail.gmail.com>
Subject: Re: Fix potential data loss and corruption due to Incorrect BIO Chain Handling
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: Ming Lei <ming.lei@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	zhangshida@kylinos.cn
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: X92WpPV766yqgJR4Ow5fXVkXId-kL15HSHtQHu4jV6A_1763797601
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 22, 2025 at 7:52=E2=80=AFAM Stephen Zhang <starzhangzsd@gmail.c=
om> wrote:
> Ming Lei <ming.lei@redhat.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=8822=E6=97=
=A5=E5=91=A8=E5=85=AD 11:35=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Fri, Nov 21, 2025 at 04:17:39PM +0800, zhangshida wrote:
> > > From: Shida Zhang <zhangshida@kylinos.cn>
> > >
> > > Hello everyone,
> > >
> > > We have recently encountered a severe data loss issue on kernel versi=
on 4.19,
> > > and we suspect the same underlying problem may exist in the latest ke=
rnel versions.
> > >
> > > Environment:
> > > *   **Architecture:** arm64
> > > *   **Page Size:** 64KB
> > > *   **Filesystem:** XFS with a 4KB block size
> > >
> > > Scenario:
> > > The issue occurs while running a MySQL instance where one thread appe=
nds data
> > > to a log file, and a separate thread concurrently reads that file to =
perform
> > > CRC checks on its contents.
> > >
> > > Problem Description:
> > > Occasionally, the reading thread detects data corruption. Specificall=
y, it finds
> > > that stale data has been exposed in the middle of the file.
> > >
> > > We have captured four instances of this corruption in our production =
environment.
> > > In each case, we observed a distinct pattern:
> > >     The corruption starts at an offset that aligns with the beginning=
 of an XFS extent.
> > >     The corruption ends at an offset that is aligned to the system's =
`PAGE_SIZE` (64KB in our case).
> > >
> > > Corruption Instances:
> > > 1.  Start:`0x73be000`, **End:** `0x73c0000` (Length: 8KB)
> > > 2.  Start:`0x10791a000`, **End:** `0x107920000` (Length: 24KB)
> > > 3.  Start:`0x14535a000`, **End:** `0x145b70000` (Length: 8280KB)
> > > 4.  Start:`0x370d000`, **End:** `0x3710000` (Length: 12KB)
> > >
> > > After analysis, we believe the root cause is in the handling of chain=
ed bios, specifically
> > > related to out-of-order io completion.
> > >
> > > Consider a bio chain where `bi_remaining` is decremented as each bio =
in the chain completes.
> > > For example,
> > > if a chain consists of three bios (bio1 -> bio2 -> bio3) with
> > > bi_remaining count:
> > > 1->2->2
> >
> > Right.
> >
> > > if the bio completes in the reverse order, there will be a problem.
> > > if bio 3 completes first, it will become:
> > > 1->2->1
> >
> > Yes.
> >
> > > then bio 2 completes:
> > > 1->1->0

Currently, bio_chain_endio() will actually not decrement
__bi_remaining but it will call bio_put(bio 2) and bio_endio(parent),
which will lead to 1->2->0. And when bio 1 completes, bio 2 won't
exist anymore.

> > No, it is supposed to be 1->1->1.
> >
> > When bio 1 completes, it will become 0->0->0
> >
> > bio3's `__bi_remaining` won't drop to zero until bio2's reaches
> > zero, and bio2 won't be done until bio1 is ended.
> >
> > Please look at bio_endio():
> >
> > void bio_endio(struct bio *bio)
> > {
> > again:
> >         if (!bio_remaining_done(bio))
> >                 return;
> >         ...
> >         if (bio->bi_end_io =3D=3D bio_chain_endio) {
> >                 bio =3D __bio_chain_endio(bio);
> >         goto again;
> >         }
> >         ...
> > }
> >
>
> Exactly, bio_endio handle the process perfectly, but it seems to forget
> to check if the very first  `__bi_remaining` drops to zero and proceeds t=
o
> the next bio:
> -----
> static struct bio *__bio_chain_endio(struct bio *bio)
> {
>         struct bio *parent =3D bio->bi_private;
>
>         if (bio->bi_status && !parent->bi_status)
>                 parent->bi_status =3D bio->bi_status;
>         bio_put(bio);
>         return parent;
> }
>
> static void bio_chain_endio(struct bio *bio)
> {
>         bio_endio(__bio_chain_endio(bio));
> }
> ----

This bug could be fixed as follows:

 static void bio_chain_endio(struct bio *bio)
 {
+        if (!bio_remaining_done(bio))
+                return;
         bio_endio(__bio_chain_endio(bio));
 }

but bio_endio() already does all that, so bio_chain_endio() might just
as well just call bio_endio(bio) instead.

Thanks,
Andreas

