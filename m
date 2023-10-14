Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E16746B
	for <nvdimm@lists.linux.dev>; Sat, 14 Oct 2023 10:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GEbu361u"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-5a7cc03dee5so35816727b3.3
        for <nvdimm@lists.linux.dev>; Sat, 14 Oct 2023 03:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697278703; x=1697883503; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aD2RALeAHf4EyVH0V54MgAy7EPDrxXSYL/VcpZrTBWo=;
        b=GEbu361uVou1cE0nlBL9mjRdQXeJC9d5XoarclAGEj0eb9cmT0d5iQCv8Uks0hPsBb
         ZrGAUQ9Anu+VvAjZRJeCbFLi3l19Zg7SW5Zk0rQAyyaW/4ys+Zi8kx15rlvg1FjJORIq
         qfB6V1YU3uBlQn0rLkujSXca2ehVI/tmeMa3OuGiNN+fx/16xMxBQVOJHF3ET0Mq+uIk
         3ZWdrGR4XlO/cWqEcUn13V7mIuywzRsERPmHb1CJb/yxI0XFNkX1Ga1MkBvyEjOamiPL
         J8OrbTYVnq9aNpRSZ9FGYtLZYLBsrX7nKyk10gR3LoYyvy1Uq5KI+9/5IeXGCFHFWXh1
         8nbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697278703; x=1697883503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aD2RALeAHf4EyVH0V54MgAy7EPDrxXSYL/VcpZrTBWo=;
        b=v4QokaRTquMplWq//w2TRKKiN6W3eb6K8xCWn8hNBpcTxQxqHrztPx7iTZmAOrcOs9
         fZ7qWrIj9ofAeGcR1j7h8sHyHWr4xDrJBL9b5ePKZRcWhydHSJdpl5PT8luY8gheXsqt
         zrY0UlCSpXSDgcIAYkhfAPKQme/LEq33PVBW6rjdCFT8cZynk5cAv5EZ3dCciUDTMQAt
         7u7TKRbNjervgVCV8PW4I0lA8xZ/qMBEAEKbEU1+Wi0wz45TzHKb0VHzWIJVIdX8rAJ/
         OcujhFu1FTA5rNdMop3QyXsWAaklXYBwzR+BaXjI2rXYVq103uDyUlsG/BpFv9F2/ISV
         3eyw==
X-Gm-Message-State: AOJu0YyTXw+uu/vNLeQePlMmvvi6ZRy2lXah1vdfJx0ZkSRilLVyVNep
	j0V2cCJ2W5uVKYLX3LNvsDLhiJDZ13qmFGGyomw=
X-Google-Smtp-Source: AGHT+IEXHyobEY+S7AX/2O0DWm7a8adqtxEDJWjstkMbNv4IAw59txhFSrNML+CIpMWiPteLNE07XEW31DrQzci7Trk=
X-Received: by 2002:a25:db10:0:b0:d9a:b9fb:e6f9 with SMTP id
 g16-20020a25db10000000b00d9ab9fbe6f9mr6339988ybf.10.1697278703561; Sat, 14
 Oct 2023 03:18:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231013085722.3031537-1-michal.wilczynski@intel.com>
 <6529727e18964_f879294ea@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <f7441bb4-c2c9-4eee-9fed-ad8b28de4788@intel.com> <652978deafdf8_f8792944c@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <1c2117f1-2d22-4d08-bd9f-8c821d4a1757@intel.com> <6529b493cc785_5c0d2947d@dwillia2-mobl3.amr.corp.intel.com.notmuch>
In-Reply-To: <6529b493cc785_5c0d2947d@dwillia2-mobl3.amr.corp.intel.com.notmuch>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sat, 14 Oct 2023 13:17:47 +0300
Message-ID: <CAHp75Vc1D3ut8x8_bVRSaEGy8EdUgfubxEsAbLEzJvNDx49f_g@mail.gmail.com>
Subject: Re: [PATCH v2] ACPI: NFIT: Fix local use of devm_*()
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Wilczynski, Michal" <michal.wilczynski@intel.com>, nvdimm@lists.linux.dev, 
	linux-acpi@vger.kernel.org, rafael@kernel.org, vishal.l.verma@intel.com, 
	lenb@kernel.org, dave.jiang@intel.com, ira.weiny@intel.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 14, 2023 at 12:20=E2=80=AFAM Dan Williams <dan.j.williams@intel=
.com> wrote:
> Wilczynski, Michal wrote:

...

> "The new cleanup.h facilities that arrived in v6.5-rc1 can replace the
> the usage of devm semantics in acpi_nfit_init_interleave_set(). That
> routine appears to only be using devm to avoid goto statements. The new
> __free() annotation at variable declaration time can achieve the same
> effect more efficiently.
>
> There is no end user visible side effects of this patch, I was motivated
> to send this cleanup to practice using the new helpers."

The end-user side effect (educational and not run-time) is that: "One
should really be careful about the scope of the devm_*() APIs and use
of them just for the sake of the RAII replacement is not the best
idea, while code is still working. Hence it gives a better example for
whoever tries to use this code for educational purposes."

--=20
With Best Regards,
Andy Shevchenko
