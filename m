Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA95714015
	for <nvdimm@lists.linux.dev>; Mon, 27 Nov 2023 09:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SML1x09c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701077332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0nMIl91Eak6ZBGG/8fFVr6BWdYW3lElq6+wktXAqvfE=;
	b=SML1x09ciWZNv55GgcLZA8zEjngUyK2mcotijJ0xb1Ys5Vxm/VAApS2yPkSRaUsxbuD03v
	dFG+031AJg83Qx0hyhYC/hKS5Yzvm4s50tvL1RYv7aTsnVXeQXSg1TgxzUulhSVdwfU46I
	XfbHmkY8cCisEcR7H0xJ+7FYzE2hh6U=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-LFwmC-i6P_eCaa-lUqT2cg-1; Mon, 27 Nov 2023 04:28:50 -0500
X-MC-Unique: LFwmC-i6P_eCaa-lUqT2cg-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-285b3dd68c0so2186246a91.3
        for <nvdimm@lists.linux.dev>; Mon, 27 Nov 2023 01:28:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701077329; x=1701682129;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0nMIl91Eak6ZBGG/8fFVr6BWdYW3lElq6+wktXAqvfE=;
        b=uU92tJGluxpQBMl3wcSFVwAbdi+EYlFgGr6+u1tFX2D21z5yNdXDKtj+gvxHnKlEJY
         eGZebt7wo7HA1CdPjP/zJ0PVgD05s1vHFkhTwmehLl+BPSXfjCVH3EGt8LGXGmt+fpNe
         2a1i7LAIBymMPPOUu6HopoFbKlPIGZCMOg4C36qkWMAyJzK7vRH2uGd+AzVnNQzJ+vcs
         P2yA3j3u94WL5cD2DDJAHOcOitF7xfmw093VTwWtZbhKkV/a3ted4j5CPTb/K8ceXqyu
         Hz+fV+zAx+c+pqZjlqLxFvRX7H+Vj0vnoLP8MrkKw/ERFFg8CXr4mGfQ8h4reLEkRC9G
         yLZA==
X-Gm-Message-State: AOJu0Yz4vrAW2IWATyQm0bZU0Rq/oE/aJ83MpXLv5v/de8+os3MJJDEe
	n4ZEeR7W4ZSJsAa3hJ//RKhvFJYv2t87/5HtbGaipahkpRk4yp+gRjYhzW05vNx3sNtAuuiH/Ja
	TPdcLuCCaVRgRXhHUzGcuNNCTkJTbMitP
X-Received: by 2002:a17:90b:3b91:b0:285:a204:fc47 with SMTP id pc17-20020a17090b3b9100b00285a204fc47mr8090133pjb.17.1701077329464;
        Mon, 27 Nov 2023 01:28:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFlR0wcxBSvfFH7EuCUE7u9yM2CMc+WTwwba0kU+VSu3nWOn9orrt7wKRyWKumdp5aFjLpmynyFdbSKuH3Ehb4=
X-Received: by 2002:a17:90b:3b91:b0:285:a204:fc47 with SMTP id
 pc17-20020a17090b3b9100b00285a204fc47mr8090124pjb.17.1701077329229; Mon, 27
 Nov 2023 01:28:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <x49fs1hwk0b.fsf@segfault.usersys.redhat.com>
In-Reply-To: <x49fs1hwk0b.fsf@segfault.usersys.redhat.com>
From: Yi Zhang <yi.zhang@redhat.com>
Date: Mon, 27 Nov 2023 17:28:37 +0800
Message-ID: <CAHj4cs_fgf-tjx9z_W9t2hnN3sufuCphbTKjgqJ9EpoMEkQzYw@mail.gmail.com>
Subject: Re: [patch] ndctl: test/daxctl-devices.sh: increase the namespace size
To: Jeff Moyer <jmoyer@redhat.com>
Cc: nvdimm@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 8, 2023 at 1:34=E2=80=AFAM Jeff Moyer <jmoyer@redhat.com> wrote=
:
>
> Memory hotplug requires the namespace to be aligned to a boundary that
> depends on several factors.  Upstream kernel commit fe124c95df9e
> ("x86/mm: use max memory block size on bare metal") increased the
> typical size/alignment to 2GiB from 256MiB.  As a result, this test no
> longer passes on our bare metal test systems.
>
> This patch fixes the test failure by bumping the namespace size to
> 4GiB, which leaves room for aligning the start and end to 2GiB.
>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

Thanks Jeff

Tested-by: Yi Zhang <yi.zhang@redhat.com>

>
> diff --git a/test/daxctl-devices.sh b/test/daxctl-devices.sh
> index 56c9691..dfce74b 100755
> --- a/test/daxctl-devices.sh
> +++ b/test/daxctl-devices.sh
> @@ -44,7 +44,10 @@ setup_dev()
>         test -n "$testdev"
>
>         "$NDCTL" destroy-namespace -f -b "$testbus" "$testdev"
> -       testdev=3D$("$NDCTL" create-namespace -b "$testbus" -m devdax -fe=
 "$testdev" -s 256M | \
> +       # x86_64 memory hotplug can require up to a 2GiB-aligned chunk
> +       # of memory.  Create a 4GiB namespace, so that we will still have
> +       # enough room left after aligning the start and end.
> +       testdev=3D$("$NDCTL" create-namespace -b "$testbus" -m devdax -fe=
 "$testdev" -s 4G | \
>                 jq -er '.dev')
>         test -n "$testdev"
>  }
>
>


--=20
Best Regards,
  Yi Zhang

