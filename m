Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BEA210C;
	Thu,  7 Jul 2022 14:03:01 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id w185so15860453pfb.4;
        Thu, 07 Jul 2022 07:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=afbiyF16Fd4Ewaaf3EKKCpvpR7aHAsNAQp7K3TuQXs4=;
        b=EzpeppBfdoHkOWruUNAYNHzOi8S5lBuVkWR/uarc/O7MDVJ2qM1NUNdy3hxzZeKinw
         1f6tPe15AftcBiSP1Sugt5jiQpAKlLcyz+gPyHgHTvK6IkiuSg6SYHkmzqBCpGaHkm3K
         GirawtqITR+EFkG0pF8QxPm0bxzk97EH7JYJxQXFRi4d1kRfsZVOuxKRapjByLByJ3DF
         qAVqAZfaAfJT+F8T/W2rPtPmXy6/uaYwejGaDWQ5Frl3XCXwsQlqWF67lU3BIXdseGBS
         CTJ5pH+oR76s++4uNTCxHCZwHNyWF4xdxY3ay2k5fQlKGRbstnEbIjnAVDZkl7wMQgN9
         oSpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=afbiyF16Fd4Ewaaf3EKKCpvpR7aHAsNAQp7K3TuQXs4=;
        b=EvHK8nkg3Kwr3qyYYCrLIuataxQLeU3qJvhIQTm/jZLB0THuMggv4Iovr18cO8FgpH
         N5QbE7vi7Sxj6nAqDcuvir0mm5EYccyHKXxruCyMl/R+5/T/Dkqh99N9UnNJQvooyjVD
         wTLnxlJE6nziiwg0TWDsHxFNywGA1MfCDVnv8wQThWwJKyOKtIf5Xqjrbblp2UhdlFvM
         3bvv6sTopDvkfFYigGaMB6Gm1jcxxwa9nRajsQ+lkF42AKHjlRtGlxcfl/soa5xX1TUg
         kgpBBdmVtaESN8MiDfeDBI16NLkr0ISnoAA1uTjAkR8RM+Uslu66o3uB5wcuyboPDra9
         kaYQ==
X-Gm-Message-State: AJIora/DLYrUmoXgedAXvH43D5AtZB8Rh6MEKufUWhLM7QREm2v+7s5/
	YAU6zEAtzJ6wScAsaOmUujQ=
X-Google-Smtp-Source: AGRyM1uGEg1zRLKU3mt/8yK/HfEqKFBdv1eoQpzxhqHLW6DjIp1gLh6JEsU/RWRdBfoHFypH/TfaNQ==
X-Received: by 2002:a17:90b:4c8f:b0:1ec:cdd0:41b7 with SMTP id my15-20020a17090b4c8f00b001eccdd041b7mr5420238pjb.119.1657202580508;
        Thu, 07 Jul 2022 07:03:00 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k127-20020a632485000000b004148cbdd4e5sm1215293pgk.57.2022.07.07.07.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 07:02:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 7 Jul 2022 07:02:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: kernel test robot <lkp@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	virtualization@lists.linux-foundation.org,
	usbb2k-api-dev@nongnu.org, tipc-discussion@lists.sourceforge.net,
	target-devel@vger.kernel.org, sound-open-firmware@alsa-project.org,
	samba-technical@lists.samba.org, rds-devel@oss.oracle.com,
	patches@opensource.cirrus.com, osmocom-net-gprs@lists.osmocom.org,
	openipmi-developer@lists.sourceforge.net, nvdimm@lists.linux.dev,
	ntb@lists.linux.dev, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, mjpeg-users@lists.sourceforge.net,
	megaraidlinux.pdl@broadcom.com, linuxppc-dev@lists.ozlabs.org,
	linux1394-devel@lists.sourceforge.net, linux-x25@vger.kernel.org,
	linux-wpan@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-watchdog@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-unionfs@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-staging@lists.linux.dev, linux-serial@vger.kernel.org,
	linux-sctp@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	linux-rockchip@lists.infradead.org,
	linux-renesas-soc@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-pm@vger.kernel.org,
	linux-phy@lists.infradead.org, linux-perf-users@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-parport@lists.infradead.org,
	linux-parisc@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-nfc@lists.01.org, linux-mtd@lists.infradead.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-mediatek@lists.infradead.org, linux-media@vger.kernel.org,
	linux-leds@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-input@vger.kernel.org, linux-iio@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-hwmon@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-fpga@vger.kernel.org,
	linux-fbdev@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-efi@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-cxl@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-amlogic@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
	legousb-devel@lists.sourceforge.net, kvm@vger.kernel.org,
	keyrings@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
	iommu@lists.linux.dev, iommu@lists.linux-foundation.org,
	intel-wired-lan@lists.osuosl.org, greybus-dev@lists.linaro.org,
	dri-devel@lists.freedesktop.org, dm-devel@redhat.com,
	devicetree@vger.kernel.org, dev@openvswitch.org,
	dccp@vger.kernel.org, damon@lists.linux.dev, coreteam@netfilter.org,
	cgroups@vger.kernel.org, ceph-devel@vger.kernel.org,
	ath11k@lists.infradead.org, apparmor@lists.ubuntu.com,
	amd-gfx@lists.freedesktop.org, alsa-devel@alsa-project.org,
	accessrunner-general@lists.sourceforge.net
Subject: Re: [linux-next:master] BUILD REGRESSION
 088b9c375534d905a4d337c78db3b3bfbb52c4a0
Message-ID: <20220707140258.GA3492673@roeck-us.net>
References: <62c683a2.g1VSVt6BrQC6ZzOz%lkp@intel.com>
 <YsaUgfPbOg7WuBuB@kroah.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsaUgfPbOg7WuBuB@kroah.com>

On Thu, Jul 07, 2022 at 10:08:33AM +0200, Greg KH wrote:

[ ... ]
> > 
> > Unverified Error/Warning (likely false positive, please contact us if interested):
> > 
> > arch/x86/events/core.c:2114 init_hw_perf_events() warn: missing error code 'err'
> > drivers/android/binder.c:1481:19-23: ERROR: from is NULL but dereferenced.
> > drivers/android/binder.c:2920:29-33: ERROR: target_thread is NULL but dereferenced.
> > drivers/android/binder.c:353:25-35: ERROR: node -> proc is NULL but dereferenced.
> > drivers/android/binder.c:4888:16-20: ERROR: t is NULL but dereferenced.
> > drivers/base/regmap/regmap.c:1996:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9637
> > drivers/char/random.c:869:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9637
> > drivers/firmware/arm_scmi/clock.c:394:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9637
> > drivers/firmware/arm_scmi/powercap.c:376:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9637
> > drivers/gpu/drm/amd/amdgpu/../pm/powerplay/hwmgr/vega10_powertune.c:1214:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9637
> > drivers/gpu/drm/amd/display/dc/os_types.h: drm/drm_print.h is included more than once.
> > drivers/gpu/drm/bridge/ite-it66121.c:1398:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9637
> > drivers/greybus/operation.c:617:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9637
> 
> <snip>
> 
> When the compiler crashes, why are you blaming all of these different
> mailing lists?  Perhaps you need to fix your compiler :)
> 

To be fair, it says above "likely false positive, please contact us
if interested". Also, the 32-bit build errors _are_ real, and the NULL
dereferences in the binder driver are at the very least suspicious.

Guenter
