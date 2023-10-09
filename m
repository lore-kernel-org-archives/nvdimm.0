Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C32134BE
	for <nvdimm@lists.linux.dev>; Mon,  9 Oct 2023 17:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-57c0775d4fcso601811eaf.0
        for <nvdimm@lists.linux.dev>; Mon, 09 Oct 2023 10:51:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696873896; x=1697478696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xQBtcxUEBTteAt95r1bhShJsO6XhiQD8q2TBwfTAy8Y=;
        b=h0muI/Ap26w65T9aV1XL1eweoxieLwLx743KO9kCB813WB2sTbS0KjAHW0jkpitZuJ
         BKFPP/pg1udpxA2XfXjBahDEKkW5M23klV7PjZbwkKNG/ggAARhlqY5KEaaq76XhmNOU
         ylRrrrr1b4iHe0hPTPN1IygF4P1Xkoc03jM44izwRuU/A4wJHwZgc2oGvHAhaQsxx+0K
         bh+oiuu53RGrNHaHE0qCeD8yU4rkMau7gdQoRIOHT+jTR6b6LNTNiUbSGeu8mpwkhoN+
         Ydo9kKG/BmBPOmtAKUsFn40ZO884r3sggWwoZ6pWkguNe5IKPEs+NFGoVT4sjjhBHz2B
         ggKA==
X-Gm-Message-State: AOJu0YzTDYIB2tSv18fEEGZdLoeav3UWG1fIzkS6xZJlR6uHWWGI+jVN
	XjUTWmuI4im5FDh+eTsemqd9CSxuVMP3SlJJsvo=
X-Google-Smtp-Source: AGHT+IGUmF/LVHHrOgPdHxSjp/xIgIZDRO1132XTPnCUXW1CQVgDWzrxUZ1VxL2ND11CHY8bBqQ/04JupLN2zIbwRQs=
X-Received: by 2002:a4a:de08:0:b0:56e:94ed:c098 with SMTP id
 y8-20020a4ade08000000b0056e94edc098mr14198631oot.0.1696873896270; Mon, 09 Oct
 2023 10:51:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231006173055.2938160-1-michal.wilczynski@intel.com>
 <20231006173055.2938160-4-michal.wilczynski@intel.com> <CAJZ5v0jKJ6iw6Q=uYTf0at+ESkdCF0oWaXRmj7P5VLw+QppKPw@mail.gmail.com>
 <ZSEPGmCyhgSlMGRK@smile.fi.intel.com> <CAJZ5v0gF0O_d1rjOtiNj5ryXv-PURv0NgiRWyQECZZFcaBEsPQ@mail.gmail.com>
 <CAJZ5v0iDhOFDX=k7xsC_=2jjerWmrP+Na-9PFM=YGA0V-hH2xw@mail.gmail.com>
 <f8ff3c4b-376a-4de0-8674-5789bcbe7aa9@intel.com> <CAJZ5v0i4in=oyhXKOQ1MeoRP5fAhHdEFgZZp98N0pF8hB6BtbQ@mail.gmail.com>
 <be180b68-d31f-4e7f-aeaa-071be74e2696@intel.com>
In-Reply-To: <be180b68-d31f-4e7f-aeaa-071be74e2696@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 9 Oct 2023 19:51:25 +0200
Message-ID: <CAJZ5v0g=MkRwFQ88SQfRcvwnii5VnXujC7ZUaDsncodNkzdNdQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] ACPI: AC: Replace acpi_driver with platform_driver
To: "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Andy Shevchenko <andriy.shevchenko@intel.com>, 
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, rafael.j.wysocki@intel.com, lenb@kernel.org, 
	dan.j.williams@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 9, 2023 at 3:04=E2=80=AFPM Wilczynski, Michal
<michal.wilczynski@intel.com> wrote:
>
>
>
> On 10/9/2023 2:27 PM, Rafael J. Wysocki wrote:
> > On Mon, Oct 9, 2023 at 10:40=E2=80=AFAM Wilczynski, Michal
> > <michal.wilczynski@intel.com> wrote:
> >>

[cut]

> >> Yeah we could add platform device without removing acpi device, and
> >> yes that would introduce data duplication, like Andy noticed.
> > But he hasn't answered my question regarding what data duplication he
> > meant, exactly.
> >
> > So what data duplication do you mean?
>
> So what I meant was that many drivers would find it useful to have
> a struct device embedded in their 'private structure', and in that case
> there would be a duplication of platform_device and acpi_device as
> both pointers would be needed.

It all depends on how often each of them is going to be used in the
given driver.

This particular driver only needs a struct acpi_device pointer if I'm
not mistaken.

> Mind this if you only have struct device
> it's easy to get acpi device, but it's not the case the other way around.
>
> So for this driver it's just a matter of sticking to convention,

There is no convention in this respect and there is always a tradeoff
between using more memory and using more CPU time in computing in
general, but none of them should be wasted just for the sake of
following a convention.

> for the others like it would be duplication.

So I'm only talking about the driver modified by the patch at hand.

> In my version of this patch we managed to avoid this duplication, thanks
> to the contextual argument introduced before, but look at this patch:
> https://github.com/mwilczy/linux-pm/commit/cc8ef52707341e67a12067d6ead991=
d56ea017ca
>
> Author of this patch had to introduce platform_device and acpi_device to =
the struct ac, so
> there was some duplication. That is the case for many drivers to come, so=
 I decided it's better
> to change this and have a pattern with keeping only 'struct device'.

Well, if the only thing you need from a struct device is its
ACPI_COMPANION(), it is better to store a pointer to the latter.
