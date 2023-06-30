Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFF8C8DF
	for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 11:13:54 +0000 (UTC)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5183075a5ecso323978a12.0
        for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 04:13:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688123632; x=1690715632;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4NqWzpNqz4GejaakdrG2FU3sXjzVzmUMDqfldvIeJWs=;
        b=gsCC+xeyRbm7pD7giuH6k022TeNiBXupAkE357EK3G2mqwMHvl87DB+iZ+1iUJ1+tp
         FOPW5mJzWgOGCQ9QYsk8YPoyxcPOaBsNTD0j7zIT73wiXCLPiJy6KupdJOk2sC/aQGbc
         Lb6CvNRxFjHg8vJRPJz/iCVzfLKhbR1c31xf3eFLB2j3gO0ttaPdCQbi0GjzacwyH72B
         n/HHgr1uAbQVqAmySmcYZ9Le1pW9w+JhAZcOSfeWd2YKJkDKxC8RYNMrmzL85B6OE58H
         OHZnzH3zjUZKFDUup0+Cp4UgoTc4y4HxRs/GNmxhENAc+GrFz/XPdYWD2lDi8rmSM5g2
         j5lw==
X-Gm-Message-State: ABy/qLb/AknT+XulmubTuhYwNd2UWb8iTocOmCZjhiRhlUhoefUgeTed
	0/8DreI1+ataMjFsG0EP1ESJAwBZlRQQU8hB6RE=
X-Google-Smtp-Source: APBJJlFBMk4yfxaXHTVpdexNeeOE3q6Y64T1g1p+6G/uFx0CIFgz8gGoMQlz52ijPBzf51zuvCktC2iXmxNInWXqh30=
X-Received: by 2002:a05:6402:8d0:b0:516:463d:8a10 with SMTP id
 d16-20020a05640208d000b00516463d8a10mr1339755edz.3.1688123632251; Fri, 30 Jun
 2023 04:13:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230616165034.3630141-1-michal.wilczynski@intel.com>
 <20230616165034.3630141-9-michal.wilczynski@intel.com> <CAJZ5v0hPY=nermvRKiyqGg4R+jLW13B-MUr0exEuEnw33VUj7g@mail.gmail.com>
 <699b327d-acea-c51d-874a-85133b74a73c@intel.com> <CAJZ5v0jpcas1TLGVR5Cic-bz4YkkAVypShj0sfEKUmy+930vVA@mail.gmail.com>
In-Reply-To: <CAJZ5v0jpcas1TLGVR5Cic-bz4YkkAVypShj0sfEKUmy+930vVA@mail.gmail.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 30 Jun 2023 13:13:41 +0200
Message-ID: <CAJZ5v0hUiZy+yxd9mZoLM99194N0u42+UCms8Fm8s4YpkM1yFg@mail.gmail.com>
Subject: Re: [PATCH v5 08/10] acpi/nfit: Improve terminator line in acpi_nfit_ids
To: "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc: linux-acpi@vger.kernel.org, dan.j.williams@intel.com, 
	vishal.l.verma@intel.com, lenb@kernel.org, dave.jiang@intel.com, 
	ira.weiny@intel.com, rui.zhang@intel.com, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 30, 2023 at 1:04=E2=80=AFPM Rafael J. Wysocki <rafael@kernel.or=
g> wrote:
>
> On Fri, Jun 30, 2023 at 11:52=E2=80=AFAM Wilczynski, Michal
> <michal.wilczynski@intel.com> wrote:
> >
> >
> >
> > On 6/29/2023 6:14 PM, Rafael J. Wysocki wrote:
> > > On Fri, Jun 16, 2023 at 6:51=E2=80=AFPM Michal Wilczynski
> > > <michal.wilczynski@intel.com> wrote:
> > >> Currently terminator line contains redunant characters.
> > > Well, they are terminating the list properly AFAICS, so they aren't
> > > redundant and the size of it before and after the change is actually
> > > the same, isn't it?
> >
> > This syntax is correct of course, but we have an internal guidelines sp=
ecifically
> > saying that terminator line should NOT contain a comma at the end. Just=
ification:
> >
> > "Terminator line is established for the data structure arrays which may=
 have unknown,
> > to the caller, sizes. The purpose of it is to stop iteration over an ar=
ray and avoid
> > out-of-boundary access. Nevertheless, we may apply a bit more stricter =
rule to avoid
> > potential, but unlike, event of adding the entry after terminator, alre=
ady at compile time.
> > This will be achieved by not putting comma at the end of terminator lin=
e"
>
> This certainly applies to any new code.
>
> The existing code, however, is what it is and the question is how much
> of an improvement the given change makes.
>
> So yes, it may not follow the current rules for new code, but then it
> may not be worth changing to follow these rules anyway.

This is a bit like housing in a city.

Usually, there are strict requirements that must be followed while
constructing a new building, but existing buildings are not
reconstructed to follow them in the majority of cases.  It may not
even be a good idea to do that.
