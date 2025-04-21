Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F69D150997
	for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 14:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745247366; cv=none; b=PSr6HeZKOkByxYG8tH/kcYxIfXZZTWg+jD07GKkWxzMml9hEXafMlLhAq2qaJHyqfOoNpIIJ6sLIgyZ6GlVt6VAK9ZwTV5rG0uoudhtv9AZxMD5GB0Mx+zRz2K3uvpS8Ld2TxkvOW1Lft9Fv/b9zBRJN8IvHZ7fALR+wwGMQbJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745247366; c=relaxed/simple;
	bh=ELRmkTdRqMv3QmAXEhzU+df4jLtDbLH6i9rhrVJgjrk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ecoO82LpCuZyVH/XFfxhBiwztXyuEdkrahaWgHDsjE/XE1W7TLuUC4JRydg9B+EvrFgJdqTaN/tEKu9aSz+xXKQB8bSD4YopgCN5CxyUMdWmbCH0D98NiEg2uct2iy2eDvvt6CPvowKTUVoe0eiBNeGtPcSq8dotxo98HfXiph0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen-com.20230601.gappssmtp.com header.i=@soleen-com.20230601.gappssmtp.com header.b=cALtUQOO; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen-com.20230601.gappssmtp.com header.i=@soleen-com.20230601.gappssmtp.com header.b="cALtUQOO"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-476f4e9cf92so29180821cf.3
        for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 07:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1745247363; x=1745852163; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ELRmkTdRqMv3QmAXEhzU+df4jLtDbLH6i9rhrVJgjrk=;
        b=cALtUQOO1mD43gxBFyXbgXoi2QgDr+UyPoSGMzdzHzinNt7RfB5H95wqP4yhoz5hUW
         Ux/IV/tupTfvZI12BFQmWBctDBGwyTmy6jy1MmAIck5lK3YNS+94Klmrsm0TgdRdeDw3
         wRDeXWNmG3VbPbvLbsNvAeGkANJ9ATV9WDqIov7n66Qw4wnx9lNC/phDhvfP2IP/vC6j
         v8mDfMbINxSc+l0xPOP/CA+16As8c0VA5rdcR9qGNq2qbhyEU/ioJEZlB3NM2D61YbmJ
         36xLPASvfCQNbfGS89I3GB6AzKThAb8qLE2AaXb7rYVRLB6HFQXScZ2kg4HImBn3Utni
         dbLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745247363; x=1745852163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ELRmkTdRqMv3QmAXEhzU+df4jLtDbLH6i9rhrVJgjrk=;
        b=s7bMKxzijXga0CkirosRbZsmGl0FDffZVFzqIF9F8lOvN1qwuuegBFEIgbeUK03i4t
         n6wQFJ94SfRd6KNr/AEb70uehvZxiyGl4NUvHZQF0bbF9bl2CNFWPdRaeH/aYvvzCDz6
         nC5k5MisFPjuMXTArcjo873emmSSEuJQElh62Izi5x77jeZiTW1UE/aeEcJB89ZKLScU
         163RqXqZm8Av9V/n8EWMDvH2ymewp/ixerSd0zbp4lexvBA+YyaukZoGCNDDccoZtGro
         s/Rck1q99QtPpBmxzrJboSdIgJFFYw0ZGY3zfutd+GC8VF++KUKY6OIPUS0JfgMumF8w
         +SQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWC3OoLMB2Lp/1I1pPs4hu7ivbBoga+wmFARTQ8YUcB+sdjLfV370yRPFJURoxp6Yx/IQIR7do=@lists.linux.dev
X-Gm-Message-State: AOJu0YyXwWPJaZZCpwABZJ4GZ1hfBLsmMEcvGmn+HB/glaozdZj5S2Ec
	ARTOHUegXqgoMHQYPDuCWaIL4997UiNeS6esQRl9jnw+b9Rho9BU0A+zmCsZ6+HGA7Vi9E6Ngvb
	1NK9WQSPWEtd4ob2uJW+WDEbIqoGLEzpoKCOYXQ==
X-Gm-Gg: ASbGncvjbW7u70WvHeF0ZDj8r1ogwlm4vD7MKZbOBWvwJWaSuT+ulWyby6v5TsncGjF
	AgV5KzPY4GcYxNyUiP1NJVDRKxICWKJuW21KRfKBalcgNZ2wgYlx26zst06rcK2Nw31l4KB576h
	27gcI9AbcUGOMyJphnavc=
X-Google-Smtp-Source: AGHT+IG7rZTE99WK1bHTOSOgL8Ei1b2E10Kh9ByX6KEwCjeK4vA8bx+QufdyTPIfemEXj3xR90xjsvbo9nLMMoN+O1w=
X-Received: by 2002:ac8:5946:0:b0:476:83d6:75ed with SMTP id
 d75a77b69052e-47aec4c3d0cmr197368441cf.34.1745247363105; Mon, 21 Apr 2025
 07:56:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250417142525.78088-1-mclapinski@google.com> <6805a8382627f_18b6012946a@iweiny-mobl.notmuch>
In-Reply-To: <6805a8382627f_18b6012946a@iweiny-mobl.notmuch>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 21 Apr 2025 10:55:25 -0400
X-Gm-Features: ATxdqUG02lj5rHej_8Beu9BNKw0fpQPgfWQ79J7N0ZJ28950dBS1dnNGeIj5FpI
Message-ID: <CA+CK2bD8t+s7gFGDCdqA8ZaoS3exM-_9N01mYY3OB4ryBGSCEQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] libnvdimm/e820: Add a new parameter to configure
 many regions per e820 entry
To: Ira Weiny <ira.weiny@intel.com>
Cc: Michal Clapinski <mclapinski@google.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 20, 2025 at 10:06=E2=80=AFPM Ira Weiny <ira.weiny@intel.com> wr=
ote:
>
> Michal Clapinski wrote:
> > Currently, the user has to specify each memory region to be used with
> > nvdimm via the memmap parameter. Due to the character limit of the
> > command line, this makes it impossible to have a lot of pmem devices.
> > This new parameter solves this issue by allowing users to divide
> > one e820 entry into many nvdimm regions.
> >
> > This change is needed for the hypervisor live update. VMs' memory will
> > be backed by those emulated pmem devices. To support various VM shapes
> > I want to create devdax devices at 1GB granularity similar to hugetlb.
>
> Why is it not sufficient to create a region out of a single memmap range
> and create multiple 1G dax devices within that single range?

This method implies using the ndctl tool to create regions and convert
them to dax devices from userspace. This does not work for our use
case. We must have these 1 GB regions available during boot because we
do not want to lose memory for a devdax label. I.e., if fsdax is
created during boot (i.e. default pmem format), it does not have a
label. However, if it is created from userspace, we create a label
with partition properties, UUID, etc. Here, we need to use kernel
parameters to specify the properties of the pmem devices during boot
so they can persist across reboots without losing any memory to
labels.

Pasha
