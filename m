Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5AC7B
	for <nvdimm@lists.linux.dev>; Tue, 26 Apr 2022 18:23:06 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id z16so18714301pfh.3
        for <nvdimm@lists.linux.dev>; Tue, 26 Apr 2022 11:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DquimjI7WBuJalAU6LAJx471lCu4EEpIqSRlDhHHfPk=;
        b=ksL5p3RigFZPhFG5oJwg4nU6THP3LTCHRX8Zhod9tzl8bRCpVgUwGSb3NKpnBJidXJ
         cl7poYpk4vYTCJBoBb8jogM71gpJeVk1wFXGmFNqDRX8Ae8CFHNWUFjlLD0p7RwVTpc4
         RYogqvF1zA7oTpJ6/hr0xgXIBjwfkby0JjKFUOXkjHaZgczJEBpX1EpyEzXmoBqlYmb2
         DPWgnPFEoeFSKXzCdUxbG1sjapyz/P1M9U+0XW+HdR6ZqRNtn/yfgXMruWJVLYkjSp1U
         vvPF3dshkj87x6ZlgecYqTO9/J5pC8JiStHsIU0AuO34/i8s5/X4olMU7IakGfFl3rA/
         tFkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DquimjI7WBuJalAU6LAJx471lCu4EEpIqSRlDhHHfPk=;
        b=UdBuAQO9dO4OqfVoLGHic7d8Hfz3iL3WnD5oFpR0frTyJdC+raedzkApngBvRk/ZeT
         /yortapWHD08CwBe8Qbg7iY0Xqj9/oMA/0ffLur+ywTmi6h2EmMKE/yAhT7BMqc3+kvc
         /DxK0XQ/kW7S5BX3YFMa4c/0X2E/KAHNCQAJYTaZrXKNMnKiPn3l4V6preCvA+n0/qd4
         KabTR49/RYpAdMfZydDHkNkELkZre3QEkwNPmW2SHmNB4qi+GdH6Dr92l372Bd6zBK79
         /dQy7Zd2GAeZvemn77z7fIC1x0UsgdxxwYce33o/EOC4aLi+f008uLWHWYJ+sECAWjFi
         yWEw==
X-Gm-Message-State: AOAM5328vIqui7W2+xa4HWlYMC+CXHd/7g6nNeDnU8UJ6yIsCAv8j1FR
	yWF5WxZUHG/TG16a2ncRCIYHkEvqKGioHkjmG2dK5A==
X-Google-Smtp-Source: ABdhPJzlxLx6CVU9e5P9X9+6Dk1okldpaPNZtYs2ldyopx2xJvWGYKzTtkg4w1ivaFWYsO7uYj0paT4IXcYIOwM7baw=
X-Received: by 2002:a63:1117:0:b0:399:2df0:7fb9 with SMTP id
 g23-20020a631117000000b003992df07fb9mr21133502pgl.40.1650997386125; Tue, 26
 Apr 2022 11:23:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220426123839.GF163591@kunlun.suse.cz> <CAPcyv4j66HAE_x-eAHQR71pNyR0mk5b463S6OfeokLzZHq5ezw@mail.gmail.com>
 <20220426161435.GH163591@kunlun.suse.cz> <CAPcyv4iG4L3rA3eX-H=6nVkwhO2FGqDCbQHB2Lv_gLb+jy3+bw@mail.gmail.com>
 <20220426163834.GI163591@kunlun.suse.cz> <CAPcyv4jUj3v+4Sf=1i5EjxTeX9Ur65Smib-vkuaBdKYjUrh7yA@mail.gmail.com>
 <20220426180958.GJ163591@kunlun.suse.cz>
In-Reply-To: <20220426180958.GJ163591@kunlun.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Apr 2022 11:22:55 -0700
Message-ID: <CAPcyv4hr1LDaAXCOrfub1eys=OcQXAPYv2dHGzwbY7pt=_fKZQ@mail.gmail.com>
Subject: Re: ndctl tests usable?
To: =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 26, 2022 at 11:10 AM Michal Such=C3=A1nek <msuchanek@suse.de> w=
rote:
>
> On Tue, Apr 26, 2022 at 09:47:19AM -0700, Dan Williams wrote:
> > On Tue, Apr 26, 2022 at 9:43 AM Michal Such=C3=A1nek <msuchanek@suse.de=
> wrote:
> > >
> > > On Tue, Apr 26, 2022 at 09:32:24AM -0700, Dan Williams wrote:
> > > > On Tue, Apr 26, 2022 at 9:15 AM Michal Such=C3=A1nek <msuchanek@sus=
e.de> wrote:
> > > > >
> > > > > On Tue, Apr 26, 2022 at 08:51:25AM -0700, Dan Williams wrote:
> > > > > > On Tue, Apr 26, 2022 at 5:39 AM Michal Such=C3=A1nek <msuchanek=
@suse.de> wrote:
> > > > > > >
> ...
> > > >
> > > > The modinfo just tells you what modules are available, but it does =
not
> > > > necessarily indicate which modules are actively loaded in the syste=
m
> > > > which is what ndctl_test_init() validates.
> > >
> > > Isn't what modinfo lists also what modrobe loads?
> >
> > It shows what modprobe would load on the next invocation, but
> > sometimes when nfit_test fails it's because the initramfs or something
> > else loaded the modules without respecting the extra/ (or updates/ in
> > your case) override modules.
> >
> > > There isn't any pmem so I don't see why production modules would be
> > > loaded before the test modules are installed. Unloading the modules
> > > first does not really make any difference.
> >
> > Ok, my first guess was wrong... would need more debug to see what
> > those other skip tests are complaining about.
>
> There was also missing parted and hostname command.
>
> However, the nfit.ko is detected as production even when I remove all
> the production modules just in case. lsmod confirms that the nvdimm
> modules are not loaded before the test.
>
> Maybe something goes wrong with the test module build?
>
> It is very fragile and requires complete kernel source for each
> configuration built. See below for the package
>
> https://build.opensuse.org/package/show/home:michals/nfit_test
>
> Attaching the log of test run which does not report any missing tools,
> only complains about nfit.ko being production.

Oh... something silly, ndctl_test_init() assumes that the out-of-tree
module directory is always "/lib/modules/$(uname -r)/extra"

                if (!strstr(path, "/extra/")) {
                        log_err(&log_ctx, "%s.ko: appears to be
production version: %s\n",
                                        name, path);
                        break;
                }

Looks like a build configuration variable is needed there to allow for
"updates/".
