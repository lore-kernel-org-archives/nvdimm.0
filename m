Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C563B7A6
	for <nvdimm@lists.linux.dev>; Mon,  9 Oct 2023 20:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="UqEPJlX+"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2c1807f3400so60244951fa.1
        for <nvdimm@lists.linux.dev>; Mon, 09 Oct 2023 13:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1696881966; x=1697486766; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vntWR/EJpWFamZ/9NMXVbCLlV4xDhJbERcnlqbMN6Xk=;
        b=UqEPJlX+pU6KADywWjKCY9XerusXNLUuEt0QqQpIhulHJZwIPjrQeKl5zwN6dYtat1
         opK0PnBMeur14X7NAFandg/qLnhSTwpnH3Z0QR1ZghHV1Bfdd06dDCJigNQ9gbd089Mu
         plnhbafV8lO+I7v66bXmDPRPgjFY0dddvuKhdnmw8NBDvqJ992OWFH1KTD6Ub3ODaf79
         k5hiwTUqrjk3MoMSZJkxZR/kZbF8bzgvBrZg5E7Z311XqYZ6Dh5tSimWo2hPDQjirjGn
         CBleLfSTN6jJOuMwYqkeRLh4Oa21jehRUDQyYTo1UHwI6jZjfcwKFjqM6hnnzbTmZZgp
         6PaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696881966; x=1697486766;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vntWR/EJpWFamZ/9NMXVbCLlV4xDhJbERcnlqbMN6Xk=;
        b=UXub50nMURjzHX3Ry1WR6RklwW8fgxSowHkrwzCDZj/1NJ9tK/6DG1auDsgLgSSxzC
         XjFgXIwYWZ0W6Ir28t/fqbEdH/QbN/s3VxP2vKlGlk4LG8E/Nww6ziy0JI3H/QyHV3SA
         Ow7BZrPPRrUOldy9W4Bu91QznCMjfj5znC8rhTWSlWXPAxuFR1Hua8ROmi8NZOb830/k
         K67YzPA2UXF/632kjxAWfSkNKrkt5UUMxHg9x2OoqpXXzVwh3DPG5Sn9eun6tYCa85Px
         jjyGkBSbx8REMOAqyEFHyDHGgItIMfCWwyRqhtaL+uReuIA0UG9DvLALNg46hWMshDsM
         tMig==
X-Gm-Message-State: AOJu0YwWReeNO+ps095sZKEirAJj57G7mcUMuzktk/u7PrqiSiDp//FJ
	lfYEP9AYOE/piferzRv6yP0XykuyBPzoBMW6pv6H1Q==
X-Google-Smtp-Source: AGHT+IFghqg7b3VfDVvZ+soPEwEaIfxhrwarlOcz2b03PC3KagC0O9BH1UGRNCP79pJ8yT5JMzxC/VoYSKvtKG/y1ws=
X-Received: by 2002:a2e:870c:0:b0:2b6:cbdb:790c with SMTP id
 m12-20020a2e870c000000b002b6cbdb790cmr11535962lji.1.1696881966432; Mon, 09
 Oct 2023 13:06:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009165741.746184-1-max.kellermann@ionos.com>
 <20231009165741.746184-6-max.kellermann@ionos.com> <264fa39d-aed6-4a54-a085-107997078f8d@roeck-us.net>
In-Reply-To: <264fa39d-aed6-4a54-a085-107997078f8d@roeck-us.net>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 9 Oct 2023 22:05:55 +0200
Message-ID: <CAKPOu+8k2x1CucWSzoouts0AfMJk+srJXWWf3iWVOeY+fWkOpQ@mail.gmail.com>
Subject: Re: [PATCH 6/7] fs/sysfs/group: make attribute_group pointers const
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, 
	James Morse <james.morse@arm.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, 
	Robert Richter <rric@kernel.org>, Jean Delvare <jdelvare@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Bart Van Assche <bvanassche@acm.org>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, 
	Jiri Slaby <jirislaby@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Mike Leach <mike.leach@linaro.org>, James Clark <james.clark@arm.com>, 
	Leo Yan <leo.yan@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Peter Zijlstra <peterz@infradead.org>, Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Sebastian Reichel <sre@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, Wim Van Sebroeck <wim@linux-watchdog.org>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-edac@vger.kernel.org, linux-hwmon@vger.kernel.org, 
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev, nvdimm@lists.linux.dev, 
	linux-nvme@lists.infradead.org, linux-rtc@vger.kernel.org, 
	linux-serial@vger.kernel.org, coresight@lists.linaro.org, 
	linux-arm-kernel@lists.infradead.org, linux-leds@vger.kernel.org, 
	linux-pci@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-pm@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-watchdog@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 9, 2023 at 7:24=E2=80=AFPM Guenter Roeck <linux@roeck-us.net> w=
rote:
> Also, I don't know why checkpatch is happy with all the
>
>         const struct attribute_group *const*groups;
>
> instead of
>
>         const struct attribute_group *const *groups;

I found out that checkpatch has no check for this at all; it does
complain about such lines, but only for local variables. But that
warning is actually a bug, because this is a check for unary
operators: it thinks the asterisk is a dereference operator, not a
pointer declaration, and complains that the unary operator must be
preceded by a space. Thus warnings on local variable are only correct
by coincidence, not by design.

Inside structs or parameters (where my coding style violations can be
found), it's a different context and thus checkpatch doesn't apply the
rules for unary operators.
