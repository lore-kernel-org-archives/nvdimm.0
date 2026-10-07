Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3945649D5BD
	for <nvdimm@lists.linux.dev>; Wed,  7 Oct 2026 12:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791377385; cv=pass; b=YEbI0Es+g5DMJ7WEIidHeE6yX2liW8oyVRyXJsJ/fBBqh1KPC0w/6E7DS5tdhEUOW/fX+YpjXlrl+GM6E6faxfXGSrM2mAa59v753fTwYbM7T3LSgAlBCS7xb0QrlW1HAJWmBM3kkcJUkvu64CTMy2DL1dB1AZ4hWmcdXMnjs34=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791377385; c=relaxed/simple;
	bh=mAgXxfJyyCw2IfTJGYnt6Q3vjMyFJUM/9cY0xhm0WzY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MkOohUVPcKfOMHbsZt9Mp/oqtNlB9O5wtYg4qEuSq8T7VijINyVXMjvOYqUCvZ1oLUtFJkICqE0PrMf6wIm9K9Kj+x6MrX1hdUaI7XzcwcJGE76Vd5yoM9+efu/XZb6iUGhxbUBMHGMfp0bvbzB5/9Ttoglel6N1jNRTpwKR0Ok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=PgLYza8g; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="PgLYza8g"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-53582498790so3039031cf.2
        for <nvdimm@lists.linux.dev>; Wed, 07 Oct 2026 05:49:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791377377; cv=none;
        d=google.com; s=arc-20260327;
        b=MfV1Ppokw36ePQPElrpp6RQYs1JkOVw++SEJfRDXSsvVwHfYhXmMtQm9k/x3bO8gUm
         tVpvRjHUrl0Kd1pCLiRIff1szYrDGTaU54JA3FviQ0DWHZw//dFKs89w1JoM+tybhQDF
         Q0SpYMQqzD0vMVFGKacbNHuGSGs7/+23R0063OnAqfQPtTFYvXBbOozHDy47F9kxqcTf
         Q1jRyjqWBQ1ecutKeK25uy2MLP0SIlpgk9HBl9gNXeJVe72wG6FUP2TSsHj5bZKDfzZO
         eL5MrlrrrAOGErc3mD4xqbnkdOjL9Bu4NMofDG2yBMecgbKj4puGDjZAfXsDv5X4s8SL
         XmnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=uxDzaT2//lTPxw9qRyuCA3FIYAYiZrpJTXv/2HtipC4=;
        fh=JImZpJIUn81TdLhwWU/r17UuIfacLZ3bvEOP41xjuk0=;
        b=Zo/FG+zPtnFZtYFf6ukHckE0sESpMpRy62UW/PSR9nzDZ8vSs37HW2QoP2vlFA+z59
         zI9tNHkQ6eVUQujTi0WHT8Xm+2UK/KlJ1t/eXxTizB04LGIxwKvwSUmD85QMhv10iYHs
         CihDWImsBaoTb7CUoMIXwLE5j4D9ODLK+SMG5nwEehngpXIn+ySgEYaDV++OoynQHXVC
         ZxixtQ63FO1IueL/ZMZMujEkM22YIPHRRRX3FKHuS6LKtBWl2RbGxns7xBsrElNgRyG+
         ExLN7+JfLsLKy4UKaoXuhEnb8lM/7gHqbFxZhMu7PJZV36qPePUs27KRGx5AYIZSoNjG
         O2ew==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1791377377; x=1791982177; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uxDzaT2//lTPxw9qRyuCA3FIYAYiZrpJTXv/2HtipC4=;
        b=PgLYza8gL3Jn1NhMGzbqABbWxien/K66It3Qh+F+lZ/sI2ycHu6HMa+PMLUB/I+xO6
         U087o7HkX/P9I4C1tsCmtkV0+/kxra1/xO5Vchu+5ksiDmrsr0/DasX0N3aOilo1sgxC
         HM2DKu41VBV3JWPt7KlOosZUXF/GBpR2UEvYk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791377377; x=1791982177;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=uxDzaT2//lTPxw9qRyuCA3FIYAYiZrpJTXv/2HtipC4=;
        b=u+IHEocWvgZPVFwGDENM4lN9zQNKHV9gq2Vxlgr6EHA7V29J4EOa1MFelHwP7jciPa
         qYaBVEl/RYYO7xsK7rAXL8hNMJGVnc+TfOwyIKu8lmRNG4Fucw8RBAU/O0h444r5kkjo
         DcnUnftHmxqWfFhGFjypkbqLVAo1UdYL4aJNwpP8m07HFf2DUiffcbtoSYYNbyXMpNra
         G6Zi9w8Qb2SlIOCdBvyyGf/LpJo6U2AX04TTr1+CYpWs8a3sVTmWamMjCUH4y84mEq7F
         sQgka2zpanMgaInB8PBu6P/TMujLiCDm4jwBkyTVDR0HkqGWIhMSGdsKe8DG70yMCkdy
         zD7A==
X-Forwarded-Encrypted: i=1; AKwUvBxAwwCwJa9k7asMmx6kuyZIgLsddKVcMeAUU0qoEups0I1DMQm1TY01s30sZT69PB7/7zfX7iM=@lists.linux.dev
X-Gm-Message-State: AFuF++l6/cRr9L5UQdaHlWaGaoa857/nsHpbBd6xAq8v5SWtewvtZR14
	bkHxhptFSf0JNcdxCeI0icrNOCcDxseWWUKm0iMHh9OiZv4t1jXlKNnMee2a65J+HgCiZIHlB+G
	xUarb71HkkLd8LCSRIyWyULcR6XIrVKIXXqoHgjxk6g==
X-Gm-Gg: AYBFou0s+00L1YBRir7Wd+oHfPSWVYj8pDiNl278GJzZitaVXjO4OCBE4etEUY0a+lC
	bhHKAIsLVm1aQ1IqvJyr4zX8myH7LBwL2malaiwofqgU7WH8vErEFCBLwhlArvxHqqQB5/Lg7cm
	ZMrh6G3phHhtS+v5h3t7tKUcbWBJ+Xvf3MS7+jSENV5PfSnfVeiofTryk1hhDMTmEkhFynMV9qO
	tnX5oCgY0ShUe+jptpfiyktH73+I/p10OPNTICBBIzpjveYpWt7wWyLpwtXtTpROjUm72gebuoL
	9s0jn831laDmMyFeaQ7zQwGGjsA9CZnFgKIgVAcCh3kVSgrzkpaJ4/odUWU+9vFevTC06xCaRRi
	wqIrH4gka8yMT
X-Received: by 2002:a05:622a:3d1:b0:532:c947:6e49 with SMTP id
 d75a77b69052e-5357556ee8dmr37063011cf.59.1791377377065; Wed, 07 Oct 2026
 05:49:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261006180115.1425232-1-mszeredi@redhat.com> <20261006180115.1425232-5-mszeredi@redhat.com>
 <6501a22c-f484-43d4-b109-5d8021cc3dc4@app.fastmail.com>
In-Reply-To: <6501a22c-f484-43d4-b109-5d8021cc3dc4@app.fastmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 7 Oct 2026 14:49:25 +0200
X-Gm-Features: AclHuK_YHztya3DDjK3LgyU2Etjp1vNeeb0RFji1-VAcGP52Hh_NQ1Uorppslkg
Message-ID: <CAJfpegsvnzcq==FHM1DRmr6LaA2daC4_NT05Qy-174O7oc2jxQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/9] fuse: support 64 bit, server allocated backing ID
To: John Groves <john@groves.net>
Cc: Miklos Szeredi <mszeredi@redhat.com>, fuse-devel@lists.linux.dev, 
	Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 6 Oct 2026 at 22:12, John Groves <john@groves.net> wrote:

> This doesn't build with CONFIG_FUSE=m. Maybe do something like this?

I'll just add EXPORT_SYMBOL(fdget_raw).   There's no reason to not
export this if fget_raw() is exported.

Thanks,
Miklos
