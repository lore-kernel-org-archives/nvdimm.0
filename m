Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49F9A5C;
	Mon,  5 Jun 2023 09:51:06 +0000 (UTC)
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-75da00a1eddso121778985a.3;
        Mon, 05 Jun 2023 02:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685958665; x=1688550665;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fEf6+sWjBXsKTsFrT7bqlmG/K1hRr5Z8A0xMRJt/U+0=;
        b=kEezwXKgrU3WL43vYUDiid4YNDNM8rPGG4ijC4LejyDwSilUW+ZJMiKhd9KMDbcNA0
         6LRPM6lspDjq1p56xwyuBQCfXR5XIVqGFi35veMYqGDuhf86a/WlOfdztbRTNk0q0N3k
         mJqdXe3NnkO0TT+7Jd2cR7GlrLA8LcdJlEj08FWL2M+YouOFYxS6XePYB5TImXzI4M5S
         iuleSOlOe9T3Weed5nXG6gHrWhWFJ/rniv34gtSIspcCotSV8STOAr5bP80/tcxPRvbq
         YuHUNmabp6PnZmJpGuxaL9O0ci5PfKrbPVsATtBsZn5V7QSsux293dCjzg45ehgGjrU4
         6GVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685958665; x=1688550665;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fEf6+sWjBXsKTsFrT7bqlmG/K1hRr5Z8A0xMRJt/U+0=;
        b=Edr6JD/e0Dp5MG8P0BLInSJBOp2niXzk4Mps593rJq9DJ6ILlDzdG0jYkBxJbIQS/B
         0aNkzCEBmv8CsPMjsux3FBe+8Woszg45bhpRhDgwvqWOJBPfuJxP+TICLTOg9oOZ5tH2
         SW5GtxJ17aGtPFHwkhCKhBXwq5CV7rhhY1Rj9DQxieYw+++DwrDSXoDoysyUXr4iuDiq
         86OOvHo/JOND4JzKyE4TA4RONHHQevoYtIZOiTep7gORaJB3j+f85y574Z4eWCmsNpq3
         e7vW9drGNNiuPunQ2k8GOKNO9Rgzlyon6ZVG2LoZ/umNImK67wGbgQEmLh8KWs0YZfNG
         pk6g==
X-Gm-Message-State: AC+VfDyGC3dm//EruZjNQ3SxV8HPQzlAcioxzaI9yX3t5uigl4No0ihH
	I+Esag82ftSy5xpPxzR3rYrVX7MqPkhloY2cwOo=
X-Google-Smtp-Source: ACHHUZ7stNZIK6sRzM014sc2IYMpVCqUvmaoE6YIOMdV8ZDGsSxa9k6RR+3Ictg2Bsl33YxQ1XV1/6RntTMlHXwAZxc=
X-Received: by 2002:a37:6d0:0:b0:75d:535c:e982 with SMTP id
 199-20020a3706d0000000b0075d535ce982mr3567161qkg.14.1685958665275; Mon, 05
 Jun 2023 02:51:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230601131655.300675-1-michal.wilczynski@intel.com>
 <ZHsd-je7kDDpii2q@surfacebook> <9180d191-9713-b6a0-6a77-43310f9fe9df@intel.com>
In-Reply-To: <9180d191-9713-b6a0-6a77-43310f9fe9df@intel.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Mon, 5 Jun 2023 12:50:29 +0300
Message-ID: <CAHp75VfKwEYocq6DOnOjBY0vP0ASYM4eM3wc7XPrAB+ixgDGsA@mail.gmail.com>
Subject: Re: [PATCH v4 00/35] Remove .notify callback in acpi_device_ops
To: "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc: rafael@kernel.org, lenb@kernel.org, dan.j.williams@intel.com, 
	vishal.l.verma@intel.com, dave.jiang@intel.com, ira.weiny@intel.com, 
	rui.zhang@intel.com, jdelvare@suse.com, linux@roeck-us.net, jic23@kernel.org, 
	lars@metafoo.de, bleung@chromium.org, yu.c.chen@intel.com, 
	hdegoede@redhat.com, markgross@kernel.org, luzmaximilian@gmail.com, 
	corentin.chary@gmail.com, jprvita@gmail.com, cascardo@holoscopio.com, 
	don@syst.com.br, pali@kernel.org, jwoithe@just42.net, matan@svgalib.org, 
	kenneth.t.chan@gmail.com, malattia@linux.it, jeremy@system76.com, 
	productdev@system76.com, herton@canonical.com, coproscefalo@gmail.com, 
	tytso@mit.edu, Jason@zx2c4.com, robert.moore@intel.com, 
	linux-acpi@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-hwmon@vger.kernel.org, linux-iio@vger.kernel.org, 
	chrome-platform@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
	acpi4asus-user@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 5, 2023 at 11:39=E2=80=AFAM Wilczynski, Michal
<michal.wilczynski@intel.com> wrote:
> On 6/3/2023 1:03 PM, andy.shevchenko@gmail.com wrote:
> > Thu, Jun 01, 2023 at 03:16:55PM +0200, Michal Wilczynski kirjoitti:
> >> Currently drivers support ACPI event handlers by defining .notify
> >> callback in acpi_device_ops. This solution is suboptimal as event
> >> handler installer installs intermediary function acpi_notify_device as=
 a
> >> handler in every driver. Also this approach requires extra variable
> >> 'flags' for specifying event types that the driver want to subscribe t=
o.
> >> Additionally this is a pre-work required to align acpi_driver with
> >> platform_driver and eventually replace acpi_driver with platform_drive=
r.
> >>
> >> Remove .notify callback from the acpi_device_ops. Replace it with each
> >> driver installing and removing it's event handlers.
> > Somehow this thread is screwed up in a sense of linking messages.
> > Even on the archives there are rather individual patches.
> >
> > Please, be sure you are always use --thread when formatting it.
> > Yet you have a possibility to Cc different patches to the different
> > mailing lists and people.
>
> Hi,
> Thank you for this remark, I was trying to be clever and tried to send a =
patch
> in a bit non-canonical way. So I've send a cover letter and a couple of o=
ther
> major bits of a solution to everyone from the output of scripts/get_maint=
ainer.pl
> run on every patch from this series.
>
> ./scripts/get_maintainer.pl /home/mwilczyn/patches/remove_notify_external=
/*
>
> (where remove_notify_external contains all patches generated for this pat=
chset)
>
> For the rest I used --to-cmd and --cc-cmd options of git send-email. This=
 way I could
> send patches with minor changes to every driver to only specified people =
marked
> by get_maintainer.pl for this individual patch.
>
> Hope that when re-sending with next revision --thread can help.

You can send it to yourself first to test.

The biggest issue with your thread is making `b4` unable to catch the
thread. Since it cooperates with lore archive, it's extremely hard to
see the whole thing via the web either.

--=20
With Best Regards,
Andy Shevchenko
