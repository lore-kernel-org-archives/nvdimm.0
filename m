Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1540F7B
	for <nvdimm@lists.linux.dev>; Tue, 26 Apr 2022 16:47:30 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id t13so4832278pfg.2
        for <nvdimm@lists.linux.dev>; Tue, 26 Apr 2022 09:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fZ70D0cVnnPXPK9Ej6Zn6n9gKcidZRyOEp+MolYSflo=;
        b=ntgDgHv/lSQpRZFmn+4MX9RayrJeGNGq4yCFYzNqgnmwtVFv2aJRd4ProEqNgs6dgW
         1KVM1HcTg/y5YnxlAoSwqJJhugcj8nf0rI6143nSvZeaWSeyBurvUFNA3Gz5x0Q9y+jn
         HMJ8k5rudB7CuL2+RGTf/Cv0nWQagFCzTOmOjDH9NWI+3pOrHgFqYr//mUDuVoYHmywz
         NhHGrk9iYlRs4OAIS/AMowc13fbjVz0QTkX4ItEKzncaYQTf99jUMebqeo4wmA9nrhFB
         0EwVn3aH9D5l9zoeGIPZHcqMBQHuX7HdzgJAR0xNDaj1TTL3jnR+6HM89/am8WO5ojaK
         M1kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fZ70D0cVnnPXPK9Ej6Zn6n9gKcidZRyOEp+MolYSflo=;
        b=iJ7lb3hQe6SGM7FQGGF9k2WnuFLxWZ4kH7/usR3PqP/9ZRxGphv3Mlh3FNFns91LRd
         rFKtRhzdDZUSOP8jIqlQsss60jWfKdsFrpLaG0UOyp/aRmtu07ESBbS5YAL3cqwrai0S
         bvzCf+kJGtSdVfOoOx1GGe9NSzHnG57iBbudP7ORnKeOv5N4ZrHXHDXRGJr8Zy4IIpWm
         TBpNvqv1oePUCONCeLI+wvXHobfGk2+a2naGJPrM4PjFK+GWiS7Ys+68zJUot9FNn8VM
         MyONxKErptSlPYmvyCL8NaG1965V/3UGwg4yeC16yRfUjVtIcwBKFZlRrTU6VJNv3VC4
         Y7jA==
X-Gm-Message-State: AOAM533qh4KxPLDzEG56MUQ3KfKBpIzMIykATYvsQ5fBih+qRrFUYb0u
	JOublzEiWbA6bmIm0o1UhwUja458IS41spWZPZgRWg==
X-Google-Smtp-Source: ABdhPJwODo10rc9TudmxpFOyBKYK0ZSg4IZZv0WokXo0HVbHZUWNTR3RlkWi98PRm2q7WmO/8sh8Ujc6PEnE21cDh6A=
X-Received: by 2002:a63:1117:0:b0:399:2df0:7fb9 with SMTP id
 g23-20020a631117000000b003992df07fb9mr20802671pgl.40.1650991650440; Tue, 26
 Apr 2022 09:47:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220426123839.GF163591@kunlun.suse.cz> <CAPcyv4j66HAE_x-eAHQR71pNyR0mk5b463S6OfeokLzZHq5ezw@mail.gmail.com>
 <20220426161435.GH163591@kunlun.suse.cz> <CAPcyv4iG4L3rA3eX-H=6nVkwhO2FGqDCbQHB2Lv_gLb+jy3+bw@mail.gmail.com>
 <20220426163834.GI163591@kunlun.suse.cz>
In-Reply-To: <20220426163834.GI163591@kunlun.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Apr 2022 09:47:19 -0700
Message-ID: <CAPcyv4jUj3v+4Sf=1i5EjxTeX9Ur65Smib-vkuaBdKYjUrh7yA@mail.gmail.com>
Subject: Re: ndctl tests usable?
To: =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 26, 2022 at 9:43 AM Michal Such=C3=A1nek <msuchanek@suse.de> wr=
ote:
>
> On Tue, Apr 26, 2022 at 09:32:24AM -0700, Dan Williams wrote:
> > On Tue, Apr 26, 2022 at 9:15 AM Michal Such=C3=A1nek <msuchanek@suse.de=
> wrote:
> > >
> > > On Tue, Apr 26, 2022 at 08:51:25AM -0700, Dan Williams wrote:
> > > > On Tue, Apr 26, 2022 at 5:39 AM Michal Such=C3=A1nek <msuchanek@sus=
e.de> wrote:
> > > > >
> > > > > Hello,
> > > > >
> > > > > there is some testsuite included with ndctl, and when following t=
he
> > > > > instructions to build it most tests fail or are skipped:
> > > > >
> > > > > [   95s] Ok:                 3
> > > > > [   95s] Expected Fail:      0
> > > > > [   95s] Fail:               5
> > > > > [   95s] Unexpected Pass:    0
> > > > > [   95s] Skipped:            15
> > > > > [   95s] Timeout:            0
> > > > >
> > > > > Is this the expected outcome or is this a problem with the ndctl =
build?
> > > > >
> > > > > Attaching test run log.
> > > >
> > > > I see a few missing prerequisites:
> > > >
> > > > [   78s] /usr/src/packages/BUILD/ndctl-73/test/pmem-errors.sh: line
> > > > 64: mkfs.ext4: command not found
> > > > [   95s] /usr/src/packages/BUILD/ndctl-73/test/security.sh: line 25=
:
> > > > jq: command not found
> > >
> > > Indeed, with those installed I get much more tests passing:
> > >
> > > [  148s] Ok:                 13
> > > [  148s] Expected Fail:      0
> > > [  148s] Fail:               4
> > > [  148s] Unexpected Pass:    0
> > > [  148s] Skipped:            6
> > > [  148s] Timeout:            0
> > >
> > > >
> > > > This report:
> > > >
> > > > [   51s]  1/23 ndctl:ndctl / libndctl               SKIP
> > > > 0.02s   exit status 77
> > > >
> > > > ...seems to indicate that the nfit_test modules did not appear to l=
oad
> > > > correctly. I never expected that the nfit_test modules would be
> > > > redistributable, so I was surprised to see them being installed by =
an
> > > > actual package "nfit_test-kmp-default-0_k5.17.4_1-6.1". The reason
> > > > they are not redistributable is because they require replacing the
> > > > production build of the kernel provided modules libnvdimm.ko,
> > > > nd_pmem.ko, etc... What I expect is happening is that the productio=
n
> > > > version of libnvdimm.ko is already loaded (or is the only one on th=
e
> > >
> > > AFAICT neither is the case, that's why I dump the module information =
in
> > > the log.
> >
> > The modinfo just tells you what modules are available, but it does not
> > necessarily indicate which modules are actively loaded in the system
> > which is what ndctl_test_init() validates.
>
> Isn't what modinfo lists also what modrobe loads?

It shows what modprobe would load on the next invocation, but
sometimes when nfit_test fails it's because the initramfs or something
else loaded the modules without respecting the extra/ (or updates/ in
your case) override modules.

> There isn't any pmem so I don't see why production modules would be
> loaded before the test modules are installed. Unloading the modules
> first does not really make any difference.

Ok, my first guess was wrong... would need more debug to see what
those other skip tests are complaining about.
