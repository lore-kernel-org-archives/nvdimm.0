Received: from mail-yx2-f1.google.com (mail-yx2-f1.google.com [74.125.224.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B52347B405
	for <nvdimm@lists.linux.dev>; Mon, 12 Oct 2026 14:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.129
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791814411; cv=pass; b=BUCUUGCpUWDcWP+N2tKISWv6vLnRs5nckFrdYVClpsCp4L3CKRpNvuVrCtkviP1QNwXj5V055IgHExNbu6eImWpewCl1lKS6BpQJRkGtXNjjvWefpvwEXc3mkjXETXXp+d4MJcvcxa0iBsZ3YZEnEgah5pbhfcdS0yX9iFH6HvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791814411; c=relaxed/simple;
	bh=/wyxF/Lpcmq2UAtmRiyEA+9Tty5qfE+H9o7MYaoo/uk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E4/5d3FxnwKOfYjXHvL4rEH1/nuZTmQclv8sA6C7Y2cSj89jx+54OJVj0p8Js4KiHT0MKRN+6Ayp8lbcDDqCsSA2wZPfGa8SbJCuG3F47McMhkczEIyiTTEiN/Go9UAmfC/ajFbmineabgukSb6qHNGZRUgXkvG44PNydiCesso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dLl6v2wj; arc=pass smtp.client-ip=74.125.224.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dLl6v2wj"
Received: by mail-yx2-f1.google.com with SMTP id 956f58d0204a3-66d27631526so539114d50.1
        for <nvdimm@lists.linux.dev>; Mon, 12 Oct 2026 07:13:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791814409; cv=none;
        d=google.com; s=arc-20260327;
        b=SF9umhUnwMMxz4ACDnABkfksv0CIfiSUZde6/pVLO+vPi8wraIlIN7XTtBCX9Z0S5e
         oVYT5Cbi0UYci0AxDdsY5LmBHgk5u9JQob96NBOV6tMOsYlXi8UgL4PE8W86/HCd30cw
         3M9bq/KXLp8ogO8sFerKuk00PKbuwR58tLhXjOkk2tKxdUqx5swZrrMMOv73OSLeCcJt
         JMr60j7o3Fvn8aS+9is0XyywM2l19UhEAsSJdSP1lGeDigqS30Pj/RPQYDuAw2hMvoq3
         qye237wA0BOBTTJGpchWDJZbyuaoRcG0p2kcy9cQa1pZcm5HzwzeGJlDoFr0nZV2l3yK
         f+Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/wyxF/Lpcmq2UAtmRiyEA+9Tty5qfE+H9o7MYaoo/uk=;
        fh=G/+OczA3rKvQQl/IMHLINb9AFzFitCj8/oMsDIjF6AA=;
        b=klHP7dKDPY4fuQCL6Kb1GQEGhpShqleamQ319WyOQCS9YV8Dbirp5wcR9tD8G7cHr0
         8i+9CvvJgRQoa+VV9H5PWh3way4COBNfZKGh0nsqsL+PFt966rG5oaQun1pD6i8Ed/FW
         UxHAfVs2V6NE70xmD2aujJb05RQBTbSUl47lKlfxw/hhWFuD/L+OTciMBUCCeytgcx2W
         74LB430M/doaD+sUuD9TV5x1tfwz2a3pTVTWZdrh8yDqpMaJOA0dHWnq/LKYa2Ho/wLk
         OR8jjLnCFLqvv20NWZhPeAldM5Dgnlw3VKmV7CrnjINe0pr+OWrz0fcmCR8BgYwXzF6+
         Muhg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791814409; x=1792419209; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/wyxF/Lpcmq2UAtmRiyEA+9Tty5qfE+H9o7MYaoo/uk=;
        b=dLl6v2wjNxdAFJwyQGX3Z647AO32NLkKuNmv2dHw6y/dcnaf2NEi9ougUHVgivSH1+
         hekolF2aVoVj6KLgIaNZyOW7eC9pa3OTtF3epg2yycf0Dtp7mQ6jHQvFfUSdW8ebdcL/
         u9YGehi1UrzbC8z1W+HVhZQ0COnkx0p2xa4MW9LgS7LSjduLu+PsC1C9qgQOTWbg11x/
         QasX89sBDinqCS8Tcmtz1djyyp8/LJvtut/11ZXGNkd3/g+0dhpbF7PkMk+BMWjkJiek
         uBIAX58dwQaUvRBh4LXui1PnW3bBEYR+bHxJIxxIb5ZbrxoGkKkvCzc38z1Glb0W/CvT
         r6vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791814409; x=1792419209;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/wyxF/Lpcmq2UAtmRiyEA+9Tty5qfE+H9o7MYaoo/uk=;
        b=RoInAjDZb5Es5eKe1SWrsrU8rCgqc4WaQW+wc2yGhBk4MqE3PeAfXEwKpO38fA9gdb
         O7vtv5zUgf5/MmHzXDEDWc7FDMO6nD/S78Xo0beMMS9LKzKLPdNUm/5Fd8y8Qg9Z0AYQ
         ZtURm+7j3C3wCHbvCku1VoINef9yDeJU6Nqb8m03onabh9mR/0RJmf5YLu1cEhoNjXpc
         PbdcySDTDyfX4ZUEWfCCvvq0+Q1K0XsUeZZD4NO/3clhsfiepI3JU2mufC4bZ15h8+7r
         JfXcllCtN2R+xNH9+zeMVZ/prg7T2Lv1rAE6XlI0ayDd+XUbpktr0Be4gZnMdGN+Zq6O
         fB/g==
X-Forwarded-Encrypted: i=1; AKwUvBx6+MSTxVJPE0AFnMN3OL8xN+3bzDA0RSdhpyJ1BQCWe7+jblmJl85cG3LIGv4+3wcd/rRUzp0=@lists.linux.dev
X-Gm-Message-State: AFq9FYJSQvDbDRF0lpK7BfAoKXPs7odRQBUF3Ovsk2nIS9eXfBz0h5hx
	nrRxmsoD2tUjYOQ7WZP225kI80cTrfZi1Lh4WCK4p1WguSsV+VF6WHiQRQVGWHg/6L6ohYhZc14
	YUIQ/T3nrtGNwhAlb5rcgSRarnX/HTbQ=
X-Gm-Gg: AYBFou2GaI6ClGDY6TCrR8fCVK28N10xedoWMbHDO1ia/F5bZzqlPA+dgGgA7ttjn7f
	uAZbuvOEiG6wzMi75ZrrrU4QFkZGFdGZagwkweKIjHXQE+caZDt+fFeSJeUW16pAaNIVGqiKrG4
	EjKP+gtpvTNrPJpAvRI6zbl7kQUVg0d/nZrfnAMyL5nRuhzg+l+/3BTq1KMge3zTgfjtEjLpK4R
	572OBJxsyDJRU03LOTDe8FhMZkOAMPmrnCwzBL+p7Y9KxujAsVqNcyQJs568ZKFuODza9nd/2pS
	DnxvVlO4vugiX7pl2q43Vq+U6kt3lp0vmWzW1XAtab3pbJMJK/+XgA==
X-Received: by 2002:a05:690e:400e:b0:679:5b51:3396 with SMTP id
 956f58d0204a3-6795b513703mr1122750d50.44.1791814409369; Mon, 12 Oct 2026
 07:13:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261010021010.19575-1-jianyungao89@gmail.com> <cfb6c91e-c39d-402d-9f70-4b9bf75d88a1@web.de>
In-Reply-To: <cfb6c91e-c39d-402d-9f70-4b9bf75d88a1@web.de>
From: Jianyun Gao <jianyungao89@gmail.com>
Date: Mon, 12 Oct 2026 22:13:19 +0800
X-Gm-Features: AclHuK9MdUApyJ1gGdLPd016vnZ2H_juAMBnJ0tlWD5ohK8HCeWvpaTvl4Ez6-Q
Message-ID: <CAHP3+4D3xg30cWD4obJq7W5VZhrv7bD-afntiOmyq6PybPgg7w@mail.gmail.com>
Subject: Re: [PATCH] dax: fix wrong error code returned from dax_dedupe_file_range_compare()
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
	LKML <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>, Jan Kara <jack@suse.cz>, 
	Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Markus,

Thank you for the suggestion! I will add the "Fixes" and "Cc" tags in
the next version.

Best regards,
Jianyun

On Mon, Oct 12, 2026 at 9:40=E2=80=AFPM Markus Elfring <Markus.Elfring@web.=
de> wrote:
>
> =E2=80=A6
> > Return 'status' instead to propagate the actual error code.
>
> How do you think about to add any tags (like =E2=80=9CFixes=E2=80=9D and =
=E2=80=9CCc=E2=80=9D) accordingly?
>
> See also:
> * https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/Documentation/process/submitting-patches.rst?h=3Dv7.3-rc7#n145
> * https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/Documentation/process/stable-kernel-rules.rst?h=3Dv7.3-rc7#n34
>
>
> Regards,
> Markus
