Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C11125DD
	for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 11:04:30 +0000 (UTC)
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2b6c3e23c5fso4566351fa.0
        for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 04:04:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688123069; x=1690715069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A07KMdYL5lwtSiNQs9uf0BCUOmidGfNE7gu5dbduzz4=;
        b=RNgqJa/ouNnKE/U2p4fa45NLTH7hKATyACm4H8TPamawllvd191Sf404RfMM80vUWI
         TYzJIUVurYTyvkXzIGPbdsE8gSAvZ1nnuODqW7+OhfyQHgV69uGwCyAN/09KFoKaUvNF
         OARnXhqu/t1Qu5Tu36fgSwDT62BU9n03/0NXhtEuJRosylYoucqjMoQpNJhqzmMFUwS7
         XBkEL6lDNLBA9n6vV6u84doY9xHzjDcAaxkBfowBcAiYzWqmg8woiKzlC14nKtt45zeY
         5s9zJAEs7P53fzD2RstUCI64XCYDGx9q9HWzACn3g5tCpVOHxyiTCD3l9C2evZ4oPt7V
         gqJw==
X-Gm-Message-State: ABy/qLb37cyUqbFP2cUHnIQ0+I39nEJ8KkXBLAjnJokWZAV1Ct9fhMpc
	zR6bmwUPkGU2oNdHtEVunk05foZvxIj0DDlRTUleWf0o
X-Google-Smtp-Source: APBJJlF84Z7MEMYLZcp2VfasQuRS8ZyWLfVEDomr86EbZXXaJb4YKeVw/k4pFkw68brAtYWA4X5t2UoM06gQM64Ar1U=
X-Received: by 2002:a2e:a41a:0:b0:2b6:9ebc:d8c4 with SMTP id
 p26-20020a2ea41a000000b002b69ebcd8c4mr1748262ljn.0.1688123068602; Fri, 30 Jun
 2023 04:04:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230616165034.3630141-1-michal.wilczynski@intel.com>
 <20230616165034.3630141-9-michal.wilczynski@intel.com> <CAJZ5v0hPY=nermvRKiyqGg4R+jLW13B-MUr0exEuEnw33VUj7g@mail.gmail.com>
 <699b327d-acea-c51d-874a-85133b74a73c@intel.com>
In-Reply-To: <699b327d-acea-c51d-874a-85133b74a73c@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 30 Jun 2023 13:04:17 +0200
Message-ID: <CAJZ5v0jpcas1TLGVR5Cic-bz4YkkAVypShj0sfEKUmy+930vVA@mail.gmail.com>
Subject: Re: [PATCH v5 08/10] acpi/nfit: Improve terminator line in acpi_nfit_ids
To: "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, linux-acpi@vger.kernel.org, dan.j.williams@intel.com, 
	vishal.l.verma@intel.com, lenb@kernel.org, dave.jiang@intel.com, 
	ira.weiny@intel.com, rui.zhang@intel.com, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 30, 2023 at 11:52=E2=80=AFAM Wilczynski, Michal
<michal.wilczynski@intel.com> wrote:
>
>
>
> On 6/29/2023 6:14 PM, Rafael J. Wysocki wrote:
> > On Fri, Jun 16, 2023 at 6:51=E2=80=AFPM Michal Wilczynski
> > <michal.wilczynski@intel.com> wrote:
> >> Currently terminator line contains redunant characters.
> > Well, they are terminating the list properly AFAICS, so they aren't
> > redundant and the size of it before and after the change is actually
> > the same, isn't it?
>
> This syntax is correct of course, but we have an internal guidelines spec=
ifically
> saying that terminator line should NOT contain a comma at the end. Justif=
ication:
>
> "Terminator line is established for the data structure arrays which may h=
ave unknown,
> to the caller, sizes. The purpose of it is to stop iteration over an arra=
y and avoid
> out-of-boundary access. Nevertheless, we may apply a bit more stricter ru=
le to avoid
> potential, but unlike, event of adding the entry after terminator, alread=
y at compile time.
> This will be achieved by not putting comma at the end of terminator line"

This certainly applies to any new code.

The existing code, however, is what it is and the question is how much
of an improvement the given change makes.

So yes, it may not follow the current rules for new code, but then it
may not be worth changing to follow these rules anyway.
