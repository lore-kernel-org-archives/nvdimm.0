Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377BBA5E;
	Mon,  9 Oct 2023 17:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VcwkxLG+"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so3494749a12.1;
        Mon, 09 Oct 2023 10:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696872290; x=1697477090; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hzAdnPv6S7wemZW2LOvDdjej33oUOA4jt9qFcygegX8=;
        b=VcwkxLG+6YFZiPlkhxPLhjV2kpVln/9WXyDBbsiSvfGSd8w7UoKDw90kvVQPIEsz2+
         s4Zduuu9b973JoKXZVGBzHwejCIbNwWdLSF96ExmaxzIGjk+j1pgEbAu+xIp8ZLOyVLn
         4LO4wLHgE+PxQxZBmtM34rDlyC4VN9DMP1FEFAMOGvTVzm2A+xngwAXPqAhV0hErYt8r
         CEaPh+9HMjBv6dd/PLE9jScnEuIjq+hohLdD70i9PN1zkiS0gkARm8aOHAg/Lg5llGOA
         ixeWUklZJyNRUM9VsNSOvZ3E8V2llBfUYK2GAk8VuwnGCRUgSd/4GbBSRHNR7PxHTjmn
         Z7YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696872290; x=1697477090;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hzAdnPv6S7wemZW2LOvDdjej33oUOA4jt9qFcygegX8=;
        b=Fk7yKFEvmtq5Nl/D94iiDEKQdKYUFEJ5IwCjMSLUkoCCnGSESBUryv888NYfgRFir2
         kUNaisyKbui/EQIkZcWuMKN+8Zwz1fixOGPIjyaU3uuAtCGutG1kRIjaUxZGiF7GZUFY
         k19bVHm4eiWZr717JdJY4GjknCLhP5jzAEMI6e8iWSAJjfAv5x2EtYmTjp7RbDAaYi5a
         BGIzH+9bFhf5QzCUuJDSDQodq/8b3AyYsSO/ZK6ckSXtU1PsL3FvBdtG4dEpk4i80vk+
         q/wyl908fSZpuSMaXG4zvQlh2vzlSiYyPdyZ1kG42Jv6Gxf3LztR50/hofJU1t5qbKRh
         FNzg==
X-Gm-Message-State: AOJu0YzBMK0sEkflt++ajNii6ZEVg72U1p3lcTsmwTEoKOx+hyUrb3Qf
	1Tl/clBpahaDlaRBnMX9ALs=
X-Google-Smtp-Source: AGHT+IH+tyPqS70qDikWknMDjzYLaNh8XUrbid6v4dI3mkvPqY7I02GkSEKBPm73V9X3Q4ayZd0Azg==
X-Received: by 2002:a05:6a20:8e05:b0:162:4f45:b415 with SMTP id y5-20020a056a208e0500b001624f45b415mr20823608pzj.51.1696872290343;
        Mon, 09 Oct 2023 10:24:50 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m24-20020a17090a7f9800b0027b168cb011sm8557487pjl.56.2023.10.09.10.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Oct 2023 10:24:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 9 Oct 2023 10:24:48 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
	James Morse <james.morse@arm.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Robert Richter <rric@kernel.org>, Jean Delvare <jdelvare@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alessandro Zummo <a.zummo@towertech.it>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	James Clark <james.clark@arm.com>, Leo Yan <leo.yan@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>, Pavel Machek <pavel@ucw.cz>,
	Lee Jones <lee@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Sebastian Reichel <sre@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-edac@vger.kernel.org, linux-hwmon@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
	coresight@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
	linux-leds@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-pm@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 6/7] fs/sysfs/group: make attribute_group pointers const
Message-ID: <264fa39d-aed6-4a54-a085-107997078f8d@roeck-us.net>
References: <20231009165741.746184-1-max.kellermann@ionos.com>
 <20231009165741.746184-6-max.kellermann@ionos.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231009165741.746184-6-max.kellermann@ionos.com>

On Mon, Oct 09, 2023 at 06:57:39PM +0200, Max Kellermann wrote:
> This allows passing arrays of const pointers.  The goal is to make
> lots of global variables "const" to allow them to live in the
> ".rodata" section.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

In my opinion this touches way too many subsystems in a single patch.
If someting is wrong with just one of the changes, it will be all but
impossible to revert the whole thing.

Also, I don't know why checkpatch is happy with all the

	const struct attribute_group *const*groups;

instead of

	const struct attribute_group *const *groups;

but I still don't like it.

Guenter
