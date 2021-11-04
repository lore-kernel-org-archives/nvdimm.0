Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176FE2C96
	for <nvdimm@lists.linux.dev>; Thu,  4 Nov 2021 16:00:12 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id p18so7885614plf.13
        for <nvdimm@lists.linux.dev>; Thu, 04 Nov 2021 09:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eSifGIqsCTP9GBlZp4CuNfkuWtTxzcVl3sD9B5/yv/c=;
        b=LQcB0O9OwdWpiQu2T5EPFRgOOeANm7N+m8/++ElmVo/b8Q+297K8ZhI/tDyKTVF/me
         eAwEQAkItmWLsUfiyKXrmAN9S7vhAcqAdg1FdguSKDlBsWe2o0FafXj4IgAdSnAY9/Rx
         jjK7DHdjiLx34R5o53fu42m4oElUxvc0Etztwkx4R6Fjq/eWUK53z3GMf9vzS9mZkqzv
         sGNsFiIJlJmAPntOj3n/hW3EdUQzqjCXgWOH9TZ3uE/GlbrKZ65ct4boW1QeplflbpOZ
         xKZfpkNnE4PBA4o47CcRXpyc5+s+rYF1wx/V6lpiZCMkYOBXu6Ivd2FHYvqFbe9ZP9SQ
         n4+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eSifGIqsCTP9GBlZp4CuNfkuWtTxzcVl3sD9B5/yv/c=;
        b=u+HozaqhwTFhYXJIE2d6nd5ujjY1EkLmGO6eiPWdEoz8c4Xs1JIRK6K7c45FFcPEno
         eRfeI3rCEnIO3jELx+jBwUDQzF9pcE4glTvUb6kExCohfa8uLsHZJU7bWeJmNVMt7d01
         hV+S5Hi51qzCWo5RWahgP6f4jBXkRJZwkrtlR8HU9ekO1FB3o008tvPo4mYkPhf2FEjK
         0GP/nbdFCcs10DmHM0kSV01P8PCltzLUju6vqhIJLBUQzwQLl3v/oyyev6YmujZN2Twv
         nNYGLdhigk86cGswzWmIRl295a5mgH2fCIV6gUOhzqDUd+WAYWZzWLTjlFB3HVVpcHh6
         wvuQ==
X-Gm-Message-State: AOAM530lWjEh1GkzECKTb7rb2EhDGdBHUXikVU2WC6U3JCTW6Lt3mOjh
	xITVEzW7SmL2Cx3n5VraqwYqjXtW7k6DtMm9Q8JocQ==
X-Google-Smtp-Source: ABdhPJyxrVmYq/Lvt1py6er+G3/6lxPJMwW3pzaFwsX20J42FdKHzlPXdThqmYg6rvrfrUengCpdiEzeDeO2c4zpT/o=
X-Received: by 2002:a17:902:8a97:b0:13e:6e77:af59 with SMTP id
 p23-20020a1709028a9700b0013e6e77af59mr44854573plo.4.1636041612436; Thu, 04
 Nov 2021 09:00:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <YYOLRW7yx9IFn9mG@infradead.org>
In-Reply-To: <YYOLRW7yx9IFn9mG@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 4 Nov 2021 09:00:01 -0700
Message-ID: <CAPcyv4hU+dFYc3fXnGhBPAsid03yFYZSym_sTBjHeUUrt6s5gQ@mail.gmail.com>
Subject: Re: qemu-emulated nfit devices disappeared
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 4, 2021 at 12:27 AM Christoph Hellwig <hch@infradead.org> wrote=
:
>
> I've update my typical test configs last week without saving the old
> ones, and now the Qemu emulated NFIT devices don't show anyway more
> despite the kernel showing a NFIT table:
>
> # mesg | grep -i nfit
> [    0.009184] ACPI: NFIT 0x00000000BFFE02FA 000198 (v01 BOCHS BXPCNFIT 0=
0000001 BXPC 00000001)
> [    0.009206] ACPI: Reserving NFIT table memory at [mem 0xbffe02fa-0xbff=
e0491]
>
> # lsblk
> NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> sda      8:0    0    8M  0 disk
> sr0     11:0    1 1024M  0 rom
> nullb0 250:0    0  250G  0 disk
> vda    252:0    0   10G  0 disk
> =E2=94=94=E2=94=80vda1 252:1    0   10G  0 part /
>
> Any idea what might be missing in the attached config?  This seems to
> be independent of the tested kernel version (5.14, 5.15, master).

Can you share your qemu command line and the output of:

ndctl list -vvv
