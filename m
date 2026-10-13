Received: from mail-yx2-f7.google.com (mail-yx2-f7.google.com [74.125.224.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD4736F8EB
	for <nvdimm@lists.linux.dev>; Tue, 13 Oct 2026 01:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.135
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791853389; cv=pass; b=DFo9sQ5lPgZa7sbq2bWDO5vENZP5IzSinjMjay6OTa+GEovSymNNabG2/S0I/aUqoaoDwqL+lZplgY15kiAvs+RrPHoyNQYcQ0po8uHbd4CNyjmmkivyEiQMCMzFMw7Uot2YJ9g0WTRTnuAdU33faWbzlsvkufKbSL1BgpJKOcs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791853389; c=relaxed/simple;
	bh=lowpFmrvsNjlgMHo2szT6XZJz28KEXOM+3vhDqNGI3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AX+JOS/eJTdrkCr40Y8SJV5LFx3T68EOyfKMvPDm/q8nFsLUvWhSVmBAZwkaUGiy9vn9bF9UJETs5uIOdx15UkCJJYiye8kuGULhHOZzuWTxDozERkWd+reMY3PEgsVDsdmLZ4PH7I1sajoGejyHBGFbHm+QXkPf/ni9Zz9QVak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iYwkwrNA; arc=pass smtp.client-ip=74.125.224.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iYwkwrNA"
Received: by mail-yx2-f7.google.com with SMTP id 956f58d0204a3-6755dd402fbso1024144d50.1
        for <nvdimm@lists.linux.dev>; Mon, 12 Oct 2026 18:03:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791853387; cv=none;
        d=google.com; s=arc-20260327;
        b=gpDIZ7X4ju/IoMMqG/3W9BvbPuTS1kjVG9NcEtk43FApeMTkiv62wU2H+ilfz+8c0R
         9JhdmB3jf1qWXBTnuLQFZNhxqFo8gBwGc7d9EalxkzM+DlOImTNQ7e5oI/TjSnS9NUl3
         iNWTpDg3b59UyUgnalfBcT0h2VKiu9G0kgKbQGYG9vcY37Y1NGoVgLznhNOnIgP7BI0W
         6Lwj1Rx3nKCoMJDJXbPhHTSYWHUR3U1dolkdsUSMZ9NKNm/xLruPl7fZWj5B7hkt6Byk
         v048vJUxmfFJWPym2/eOoZroJ5KkkGNA6AvWplP+nH8lrpd/UIPvp0n2IcYtAxDdWnkH
         j1rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UTuAYK18jDYjig15mU1GjIAjcvhGQddvH30uBR7Fy04=;
        fh=q6dky5wIErAMF0uUVqaNvWIVpHkBMUiBspt1YE7Qjf0=;
        b=ZG2EIc+vWN58d5twSR1ZF35he2SiKdFrfUEE8zPcgWhDJ/KMQkxKjIp2X4SuF2yuXy
         lb7pNXPjJ2jkAwh7uaKCjLYOaBCfacO2KqOVf2Skj+CIwx8CfAqAotqkxgnogWnZAW1z
         ykbPEfF/u8QVCnB8tu1olD4ny5NjQKh5JvdxT/lUdWz2KME+CiFc5ppvh5MKU0P7I1ET
         IcXn/iaLq43p1PXxT8JyHtQ03iJyPtDZKOx1rQw4tpZE+Ru/nwhvQlKlPH4thckhaFNV
         BXTwAQfP4qpDC8hYEL4gOAegea0jN0EP5srC1RfcwRW1Nf2PFZy4OzT/8aZhZVLV+S7P
         D9LA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791853387; x=1792458187; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UTuAYK18jDYjig15mU1GjIAjcvhGQddvH30uBR7Fy04=;
        b=iYwkwrNAftnfehhE2lIgK3YV0ti+dXbkmwyIZ69kRJB5FqZ2MLxQU81KdPBzUuWhaO
         xMpPxOEpUB+unPw07wWoo5skIUYLb/aWS8GkCbIL7oa0t67ch8ybgK0hjqZbeR3VumLa
         Qd3F9iuXTt2ytoMpdzhsch4c0tHLX3YB5cof5Aj/TnmlWUQa2ffpd6mrI0DUWLZo/7kC
         CC1d2qfLUGqm1iEjChEDyWU/Y1B3T8CpyCi4YiQnW7iOkx2alfTbAFqrzbl729xBxspK
         VaTyimIvOehROio/mOlXmaCap0eWrnNTPlk6MVMvtXRZnXziX2TqQ5i0qJ1tH9/tmGy7
         XZ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791853387; x=1792458187;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UTuAYK18jDYjig15mU1GjIAjcvhGQddvH30uBR7Fy04=;
        b=lfZuu0oQ+CO4jZ8ddZfFhG3NtNlPPegOUDfAQaIx333wks/6Bvnd8MxEoP1iJ0ooin
         mMD/VT6fcBF4Qeuj0xrJDs0VG7rEhMKNS4UW/iwwqfZtGn1Uaktx821CHEJYtgFcra1J
         PHTI1mtE6KfxkoRGFt+PrttuqZIU/eXaL4cSlLPKQu1q4mzEEjg9kr5580t/yl8ela9y
         XlTRIVPt6xIAswboY/m/TRNF97hEmE8KydnZ94niBrhtanD3rl1wgPusIe76Pjw3CkFN
         sAgX6aAhCo0omzctXF75TH+gYy/XGJJzyCF9LXlrudl6WQuTXOBLNnqIvgjibRGr5m81
         7HpQ==
X-Forwarded-Encrypted: i=1; AKwUvBx6zslVHgoUt8GbEbI5qm85px+ZdVGtI6n+T2LMaAAcafeu0m2E7L9FME5nfyZlpyYUsmSSMBM=@lists.linux.dev
X-Gm-Message-State: AFq9FYLQst00GniFjNySwf7wFnDitNMYwtBQg01qRlwplEq4BOyhPpN/
	zpYuL8HJ6OKTpRPGNAgryyqIrqmij8pGCvLivLxdDq7OXUbEk7DYIJs8g1eFrEiQdVRB2MjX1GE
	xdGoy6V6pkya6A+/V5YP9n6VaJdFlBfA=
X-Gm-Gg: AYBFou3EuxtKZpMp0V0amiTqdpRSUz76AZSYXEvxCLp73cIEpzjvP4RldeDvwUe2lC0
	5fdSbRuXf5MinyLi+EKoUWejjxrNCR3tL1RHhWSpaQhdj/NtXPT9Bwh2zY/826Mlgq9XYFoUK9l
	/0DGOOOuTUDZXwjVDOTKH1Kzpr5xScwT732Mph3mzOv+6yEkClEB6PjYuAC3KPc4Sd/BiBmnxcb
	TIbN7Z7bsoePSW1pHmGXdnUkeZs885AvccSimMSdt46ifjtGdya/Z+dpAzvs9CloQGcuuyakz4K
	zT6UqrTIy/nfZ2J7O9+e3eRjlYnwelQnwYCqagqCNXNXCTMbRYX0kUA=
X-Received: by 2002:a05:690e:1688:b0:679:42c1:d156 with SMTP id
 956f58d0204a3-67942c1d3e2mr2820147d50.137.1791853387325; Mon, 12 Oct 2026
 18:03:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261012151857.22534-1-jianyungao89@gmail.com> <as1nmV342j-eUOYm@aschofie-mobl2.lan>
In-Reply-To: <as1nmV342j-eUOYm@aschofie-mobl2.lan>
From: Jianyun Gao <jianyungao89@gmail.com>
Date: Tue, 13 Oct 2026 09:02:56 +0800
X-Gm-Features: AclHuK9sFgO33rPYLTn8ixdiEhdZBta4PDJKOZxl9dlxJLJscw0iQpyhSfFl2bw
Message-ID: <CAHP3+4Dr-XsZggVSf=THU7NBb8RANc5MCREHORkXV5shcgk22w@mail.gmail.com>
Subject: Re: [PATCH v2] dax: fix dax_core_init error return code
To: Alison Schofield <alison.schofield@intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, 
	"open list:DEVICE DIRECT ACCESS (DAX)" <nvdimm@lists.linux.dev>, 
	"open list:DEVICE DIRECT ACCESS (DAX)" <linux-cxl@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Dan,

Thank you for reviewing the patch! The revised commit message looks
great to me. I'm OK with it.

Best regards,
Jianyun

On Tue, Oct 13, 2026 at 7:05=E2=80=AFAM Alison Schofield
<alison.schofield@intel.com> wrote:
>
> On Mon, Oct 12, 2026 at 11:18:57PM +0800, jianyungao89@gmail.com wrote:
> > From: Jianyun Gao <jianyungao89@gmail.com>
> >
> > dax_core_init() mistakenly returns 0 on error paths. Change the
> > error return to use rc so the actual error code is propagated
> > to the caller.
>
>
> Hi Jianyun,
>
> Thanks for the patch. The change looks good to me.
>
> I'd like to expand the commit message to explain the impact of the bug,
> not just describe the correction. I've proposed a revised message below.
>
>         dax: Return errors from dax_core_init()
>
>         dax_core_init() returns success when either the character device
>         number allocation or DAX bus registration fails, even though the
>         error paths have already released the initialized resources.
>
>         For modular DAX, this allows the module to remain loaded despite
>         failed initialization, leaving subsequent users and module remova=
l
>         to access resources that have already been released.
>
>         Return the error code from the failed operation so that module
>         loading fails rather than reporting successful initialization
>         after the resources have been released.
>
> Please let me know if you're OK with the above, and I'll amend the commit
> message and merge the patch.
>
> -- Alison
>
>
> >
> > Fixes: 9567da0b408a ("device-dax: Introduce bus + driver model")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
> > ---
> >
> > Changes in v2:
> > - Drop unnecessary goto label, keep direct return for dax_fs_init() err=
or
> > - Add Fixes tag and Cc stable
> >
> > Link: https://lore.kernel.org/lkml/20261011132017.31131-1-jianyungao89@=
gmail.com/ # v1
> >
> >  drivers/dax/super.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > index 45f84b0eb909..210f4af479f0 100644
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> > @@ -738,7 +738,7 @@ static int __init dax_core_init(void)
> >       unregister_chrdev_region(dax_devt, MINORMASK+1);
> >  err_chrdev:
> >       dax_fs_exit();
> > -     return 0;
> > +     return rc;
> >  }
> >
> >  static void __exit dax_core_exit(void)
> > --
> > 2.34.1
> >
