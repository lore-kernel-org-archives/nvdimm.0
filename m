Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865193D986
	for <nvdimm@lists.linux.dev>; Mon,  9 Oct 2023 20:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="XAR5+fHu"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2b9d07a8d84so62220411fa.3
        for <nvdimm@lists.linux.dev>; Mon, 09 Oct 2023 13:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1696882824; x=1697487624; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y+Vz1bOKclq9QVOuzcbH1aPgn89tmrsRZHycaiZatEw=;
        b=XAR5+fHuM5zV4PnyWnmn5YmD0Kd3kUcSdN9MSTc16redi0iDven3pU6PiEQO7n1fKy
         lGCYTlbw3uhicFmo2DLQUKIB6yHMZkoDI7cqLhKsdOKEC+DvrO00TMWDqaUXsu8vinku
         6KmRNclf3Ikmp2QL89GsEe5uFbHo9iqMH42ZPXRXpUSiZoGxPETaFihj9Y+mXXR4ES1K
         4+jjJgggMDCHH7sXKQ03lO9nzzbdRiKpuT+5y7/aOova0l8veFZmzTHSOqVhfT40owxf
         QEgDgyHt2L0lZYr0NUhqTtT/ZfLsPyYCHe5tdT6yzGH4aKpon/e43mY6PYpgjLypCySq
         UlLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696882824; x=1697487624;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y+Vz1bOKclq9QVOuzcbH1aPgn89tmrsRZHycaiZatEw=;
        b=Behd9t6Tommd2OfdaLI6Dkj5OkvvN72wGYD5Px1k/+PN+8Jl3NsD0zQNHESyVRHA1u
         XmkyykkQD+NIrjMQyox1WOMqjbgrt1M3xXRwifwq+CU2ftY/qyYBbSDSDHBuPd7i7tes
         0zD9svuG3x0/IllwB86T8QE/MGfcaG1WUj6nl/XvQY2aM3z3MM5c6SXmGZAQfuzh/1Fj
         fa2e6cOhRh8ziDW+4FijFL5/02aIraE6qI+TwKCeQdIbtRa6WGOjMSXpb0toouzK5IuM
         RNCsbD3Jq260CMkGkLGinlaUvNr0PD9CBGI19SC6jMiB+W7E9EQXCIiQyhxCDGwsWuY2
         fpjQ==
X-Gm-Message-State: AOJu0YxkOqBW9I1DQS79b+1TxxAs8K4w2foqPxV5uaV6umJiuDyXfnjX
	KyHXjhzY5WuGyNb4gCkuGXHNiFB8G9jhHpWd6J+/Ww==
X-Google-Smtp-Source: AGHT+IEX6TNoPqier59OSFRvkXjcha7x9rPtvBMuDMX6o39QQshLcsk0zSX1nZ378MTMsNUvnOr8e/pohr3AIc4q14M=
X-Received: by 2002:a05:651c:120e:b0:2bf:fbe7:67dd with SMTP id
 i14-20020a05651c120e00b002bffbe767ddmr14845991lja.28.1696882824611; Mon, 09
 Oct 2023 13:20:24 -0700 (PDT)
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
Date: Mon, 9 Oct 2023 22:20:13 +0200
Message-ID: <CAKPOu+9=WBabTBExH1GQxhXrNH9xWciceavi6QF1nbfn9cXcig@mail.gmail.com>
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
> "*const*groups"?   That's a parsing nightmare, really hard for humans to
> read and understand.  Doesn't checkpatch complain about this?

No, checkpatch does not implement a check/warning for this style (see
my other email). There's no rule for this in coding-style.rst. Should
there be one?
