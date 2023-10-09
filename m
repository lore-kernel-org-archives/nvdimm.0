Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E76538BCB
	for <nvdimm@lists.linux.dev>; Mon,  9 Oct 2023 17:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="LcNc59L1"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2b9338e4695so60707071fa.2
        for <nvdimm@lists.linux.dev>; Mon, 09 Oct 2023 10:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1696872635; x=1697477435; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HHSd56ONGtiYc/4iRkmyqmxuAngFJzU7FR00LimB0+s=;
        b=LcNc59L1EVI+ydtMCq89TjAF70C3y2TQoBNVAWe5s3XgDTy/FjA9K525InsOqad6Ht
         t5dE8rsFgsO+/nVF6nkQUidv44u58xSMDuWD6kIpbgQwqFYPSSTyB/O4zLmyr1uosY1y
         A5BRIEONPp+EqilIFrb9yJbR5dZlZBykP0YbC/p5aZXkPl7TkjJxQ8kCwxo+SH5oZ+Iu
         rFQYXhKO2rP2rF8PJztk18SCa7esIPNM0TiXKSnTmDp+2W0MxRtDL3eZogrCV53cY7Uf
         Lmsy4KXGQMCn3Db1AmBTCcX8urEIPcifOS3ZD6EG93DKeWBlCkieC9IT8KonQ+zK7hca
         Gkug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696872635; x=1697477435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HHSd56ONGtiYc/4iRkmyqmxuAngFJzU7FR00LimB0+s=;
        b=FBLd0F0lCkEUayI3OZMcNd+dRkhtUxgU9QNJXDjzYOrXAlokJzpO6uao2kvMhI8bCV
         vGcEz1Hk3zjSlIZEC63EEOdMG1NN82iz2gjVDxoejIsWENCFqfcJV7V704KG7Bjicaxn
         C2U3K3h2MHOVCNggF1ZdG2rn/YqXf0/YGcazbTk0yI30IbOD/PaDmeU9+aeFBXzHZZkr
         BMTuRnzjmK2t9zfxpwb+YeLPKOo17C3/xA5l1KsE7wXhj2WpoGxO0g+edpBC7lp4r6Il
         46YlARVOn2UUmxLJbhzVSPyNAUumQ5MJFEjdlPGs3koGiEopNZ0vdErbHLbgT9OCA3Bz
         P+nQ==
X-Gm-Message-State: AOJu0YzRhFsrv/7vP9fCkGePkIgOeIgIbD/KNc2cLWN4Le3CJ7ZC82TH
	wK0W8HaYxSS4kFr5sIzbYNHnBHG2BS0Ckbgd3F0Hvw==
X-Google-Smtp-Source: AGHT+IHBRA959tJKQ7jnBDww7hLjflOoCbxbxU4OC4L9uyovk7KidWNus9mZc9b5/3C/KVDAr0hL4Kjy/lMZJqv9EF4=
X-Received: by 2002:a2e:86d6:0:b0:2c2:9e5c:2c82 with SMTP id
 n22-20020a2e86d6000000b002c29e5c2c82mr13644840ljj.46.1696872635192; Mon, 09
 Oct 2023 10:30:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009165741.746184-1-max.kellermann@ionos.com>
 <20231009165741.746184-6-max.kellermann@ionos.com> <2023100921-that-jasmine-2240@gregkh>
In-Reply-To: <2023100921-that-jasmine-2240@gregkh>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 9 Oct 2023 19:30:24 +0200
Message-ID: <CAKPOu+8Tb2CopWgBN29hmJrmU9mjG63PyVoaewuY0FYj=aGTZA@mail.gmail.com>
Subject: Re: [PATCH 6/7] fs/sysfs/group: make attribute_group pointers const
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rafael@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Tony Luck <tony.luck@intel.com>, James Morse <james.morse@arm.com>, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, Robert Richter <rric@kernel.org>, Jean Delvare <jdelvare@suse.com>, 
	Guenter Roeck <linux@roeck-us.net>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Bart Van Assche <bvanassche@acm.org>, Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, Alessandro Zummo <a.zummo@towertech.it>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Mike Leach <mike.leach@linaro.org>, 
	James Clark <james.clark@arm.com>, Leo Yan <leo.yan@linaro.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Pavel Machek <pavel@ucw.cz>, 
	Lee Jones <lee@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Bjorn Helgaas <bhelgaas@google.com>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
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

On Mon, Oct 9, 2023 at 7:26=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> I'm all for doing this type of work, but this is going to be rough.  You
> sent patch 6/7 that hit almost all subsystems at once :(

I wasn't sure whether splitting patches was desired. In the past, I
was often asked to fold multiple patches into one. There are so many
opinions :-) but I'll gladly change to whatever is asked.

> "*const*groups"?   That's a parsing nightmare, really hard for humans to
> read and understand.  Doesn't checkpatch complain about this?

No. I'll change the coding style (and maybe take some time to fix checkpatc=
h?)
