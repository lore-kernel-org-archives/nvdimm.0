Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E787D46A608
	for <nvdimm@lists.linux.dev>; Wed,  7 Oct 2026 12:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791377203; cv=pass; b=JoNLEc/zM1juevGg7GElKJ1vvfePPj7wYnGjgeZ9GqfhaeosEB/T1cMs1roDJlFgdN+ts/qeKz2H0QeMONme1sRy/26XFDishmyZg1g10XAFsvC9Eh7KqlO2skoK6kbEgv7Uzy68MtqEdpUKOP1sP+L4vfAANp1rXX3SSJIh/kY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791377203; c=relaxed/simple;
	bh=DQ66qo2LBVsMUtYcU8ALmcwIh6GNxRlKIPrYYWjh+QQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qWG15Eus+6uiiwp4s5crG9eIP1ad3LQvRxv41p4TSi0QLY4NSnla4DjuzUl741YKSMoIezI8MG49ITFJNx+HoXFPAkIJW0rrVS3XKopVA1VdE3L6wQnVeV8EgPWg24sRNQHFoIBgru4eob17Dtl8FMfTP3XxI3Y3hRtoyp5tQKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=nnAYqY7e; arc=pass smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="nnAYqY7e"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-9179bfa9e9cso28637836d6.1
        for <nvdimm@lists.linux.dev>; Wed, 07 Oct 2026 05:46:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791377193; cv=none;
        d=google.com; s=arc-20260327;
        b=gHVCth6EO4BO5rP9/XGbuqRysOlgscEcsKeksolxn/1dXz5OU4oqWE7+vaZFcwRXec
         kqAkOVszDS3nEpyphexD8TKdU8xrUMkS5Up4CfwqZn+FoZsYwZjBLuQ7RiyhP3bGJIek
         SK5yq4BSbPAVL6MIJUPyzbkoOf2jfFTr3Pe5Q5w8/4TJCnaRs9zfWsWSzrjngF33/hX1
         Xx+NM2o3XymB35m8JGRFuVYNiJ5Sc5voOxwYHrpj63rLvkGPKNHdlER9a6+UUHtrfL2h
         It3GvqltfoS9AIdMBv8sW7CJ5mz8dMI8624hiVcl/4+fQu18FtCZd/4ciKI3kU0cKm3a
         piJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=dUNhGKEa9s44b6qdRqUnNpXSObQsUXKjp/BQgjN+C1k=;
        fh=W0sxt3dvGT1xovUoP9SyDP5MVDTRd4J15I1I1i4xl9o=;
        b=PC8aMgltzgSmQKRCF9XXRnjS+kTjM38p9Wq+QKU2hSDtLxstT6uRYEmTuPmlaB30NX
         OnrV6h/zIWNPfvqcMX03+NseJTVFQF0uX5DVK9CAu4h9z5o8pX3F0DGGPqLKTTyYkBw8
         mxRbNx4daRoURCPui4+/mRld4qT+KwB4Wr9P+0MZI50tdP2rw1Ies0/kBg+0t5+lYCaD
         4VFP1MX9TeCbsN6b0a9OcPoC0EKzNMCEa+0dRZbXjUr68m8W3IZXKeaJcuwyZ4Hi+VOa
         y5rxFYmX+2rJKJAITErlqSZtSk+n/ofqBrpR0nFJCBgSjzRkglDl/DhMuQkCrYEmi+8e
         qpFg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1791377193; x=1791981993; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dUNhGKEa9s44b6qdRqUnNpXSObQsUXKjp/BQgjN+C1k=;
        b=nnAYqY7e7g2xpmsNmoLx1SyiS++scdYqd270N1eE1c+BYvhkRuARMUG8HXrNw9GeS+
         NlxhtB+HDZ2itjqVJm5bpv2LTtwTFS8D9QTuv9FGSrfU3k4LnBit0Dte80jkRXqfF33D
         6+EcqMAbAlM+aKpTg+Q1SNnRwgGM39S+2B2KU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791377193; x=1791981993;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=dUNhGKEa9s44b6qdRqUnNpXSObQsUXKjp/BQgjN+C1k=;
        b=2AkfUIl/4USPOP118AGx+7AaM46QdoSCq4rViKILU/9bXdNrYDwEEKeeUCa89pQUrk
         TkOirf1M0ZeTk9KFuVxt4P8IyxfAcjO4fTLyagiWAW+EP6ZOMQ2CSfMwNpKgwny+bvql
         KU+iK5NZv7DeS84BrqHMxHD4riQ8cKOWDWPa+Cbnyp6yasQMcz4IfKrnf/1Ka4HHNpym
         f1kCSa6tH5MtBCZs6WIp+b6UiTQn6/tPv8YqwqJuFABoQ4UW/yeC3OMPSPpOgr3+dt9j
         D38nrnaFEEK0IBKE3Zh0YXi4GANSGyPE4MMArX8PUsxhgUpOpyWoSEpCCHyLi9oSEs72
         T8uQ==
X-Forwarded-Encrypted: i=1; AKwUvBwTUXeTCg5uzoiO+DxXq+UBGo2gml45R3TadW0YMPPFEJDq0OIyc34cPUVOdu7rPU22Dwzzu/E=@lists.linux.dev
X-Gm-Message-State: AFuF++nWLNrlYszvgrLxWk6aspgBY97cCsr9OF+M8dQqCV79PqA/JriT
	PCgIrjYxgJGALIwA4Nh360lapwRU0rVRfP+qUX7VGWKG6DVpMu9fXiI7j4c1Szh6CbPhAybF5FE
	3F0Q0clJHK6St0XyZ/kJ1LFP0xoLZthE9NGN31mDaGg==
X-Gm-Gg: AYBFou2wXG5BprCse++j8Sf6Lb5yhHx/XxcS660tPm8xUlHCCbyGac8JANui6pdeIvF
	ulf+Q169PkZaFx6cmhzWUKeGGbjNdkDR9vycrKBDz3kg5xMh3XgAjCPy4SlYxfMT7lrQmm6bKjy
	AttbM+rugc2kKT+/6QM/gQNUubr5P4XwYXua7SMcjyByZiCVHx6588/bpVxTL0wSDvZuGmFz2X2
	lRHNSrJ6Jwq5+Z16uczCNMmf/mlfRl2m+yMwIp5dIjExfWVkbaHjQLA+0ADV/TVlcouiRane7gw
	jYntx0HTCr16A0QPCI483V01/8QJWCvTB/tt8h78d/ltXAcMEr561W4+UUaQpcX2eGP8nQyxDrY
	9LTo3RWubqO15
X-Received: by 2002:a05:6214:5992:b0:912:5f4c:ad3b with SMTP id
 6a1803df08f44-919977eb9c7mr39837396d6.16.1791377193347; Wed, 07 Oct 2026
 05:46:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261001150935.655979-1-mszeredi@redhat.com> <20261001150935.655979-4-mszeredi@redhat.com>
 <CAOQ4uxjWCRs59Qpc4t+2=i67rdJkHt=+rH07ZXv7ZzAvTjTm-A@mail.gmail.com>
 <CAOQ4uxi1+WgHJdnRKMD3tp24EOyx7iPByzSKLn_siTVY3_sRDQ@mail.gmail.com>
 <CAJfpegttAHQAGhE61t-VZqfQv9Z==ovbyLY6qp3KOK_CvjBciA@mail.gmail.com> <CAOQ4uxj76PJiumvXLHoJUKx_=FAueg3WQjYd64=B_TXo581POg@mail.gmail.com>
In-Reply-To: <CAOQ4uxj76PJiumvXLHoJUKx_=FAueg3WQjYd64=B_TXo581POg@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 7 Oct 2026 14:46:21 +0200
X-Gm-Features: AclHuK_kiKb8PFtEuseEkzlQkRsY4kgMloE-Yk2LCuIBBYBmhlknL6iE41fdO20
Message-ID: <CAJfpegsKRX-sumEA5bjvfNwpkXp35HM_QPd8taMPooR0gHpKaA@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] fuse: support 64 bit, server allocated backing ID
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, fuse-devel@lists.linux.dev, 
	John Groves <john@groves.net>, "Darrick J . Wong" <djwong@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 6 Oct 2026 at 23:24, Amir Goldstein <amir73il@gmail.com> wrote:

> Unless we gate _open() with fch->initialized, then it could fail on
> either one of these cases:
>
>                 if (!fc->passthrough || !capable(CAP_SYS_ADMIN))
>                         return -EPERM;
>
>                 if (inode->i_sb->s_stack_depth >= fc->max_stack_depth)
>                         return -ELOOP;
>
> Quite randomly.
>
> Maybe I am missing something.

No, you are right.

Thanks,
Miklos
