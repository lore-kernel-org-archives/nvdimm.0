Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8E52CA0
	for <nvdimm@lists.linux.dev>; Fri, 28 Jan 2022 18:59:36 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id j16so6959171plx.4
        for <nvdimm@lists.linux.dev>; Fri, 28 Jan 2022 10:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kBbQz+1vrQjh8zY1rf+NQJqHkH3SafLp7NoALvG+TlM=;
        b=7igZFM/i33XFVSZM2s1YTUXcszqkljuhraDPJAXq4Rxn09XQm92rt/gT4NuR/P44Fa
         MPnBo9k26d2H8PFxpVTihEvJIddhA9gN43nxg4aEJWiZjh5PugSpsP28JPm5DGOUjmmv
         gGfi5o3s4qkO9wgWsSWA71qiq9UDVnBDzsV6tXsaqzg2xoi6ovG71nWmizpZF/TX8+5w
         lxFMP0qs5JzoKpaSKmLIrodAM2PKLOlZyZYloLjyeK49IfLkP8qbuNdL7GwdwJ4PLopa
         +7//ObRDy61Bs03lwjrwKQw6VMaI4dcHLZFpHnRmYTO0sWDzTnhA802PzCMT6Gdg2VGx
         l3og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kBbQz+1vrQjh8zY1rf+NQJqHkH3SafLp7NoALvG+TlM=;
        b=K6ecL/t9QcBOzlUYb+2P+dmxN5pc9BJwluz6x014UqMLYvIPDI/tPi1Uby09RYaUXy
         vp72nUsgqILqZL2Xv96eBXE6dQNJvispM9XP2Aw5VTFm6/k7KCCgdPNveXpNedvdmOzd
         9Yx5t38KxmRuPascxn6ZcoRTsGxZXxi7etPC1VssiSN/+41LVY+RE9u3SkMV19kzpSGm
         Z0+oNYCyBznJ7UiTpPlRePzyWvdJ1n/ERDv4rkh82pBgP+/kIh9cYluGQghsb9esm5Tk
         xGzIezq3bd12I7tz8TRRSbkp6gs8MSHHOjD0Pj3cef2zxhqZimFrnyAiwCiH4s04mw7T
         C0/Q==
X-Gm-Message-State: AOAM533u3YeFFdkKipPeFtRAdg7a3kgj9LMycSC2kusnlrJZTdWoGBVU
	M/B6WPWXrQl3ohrwkaywhk0i9OJedsWaQuP8Ilvh1A==
X-Google-Smtp-Source: ABdhPJz9x36kJjRfJYIckvuO6+Jc99rIlb/SZbj5F2YS4Voujflzvok9hNDifRwkFyybbysfVYpWHhw2oDGG0AonAGA=
X-Received: by 2002:a17:902:b20a:: with SMTP id t10mr9636635plr.132.1643396376380;
 Fri, 28 Jan 2022 10:59:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220128002707.391076-1-ben.widawsky@intel.com>
 <20220128002707.391076-2-ben.widawsky@intel.com> <CAPcyv4h53gj9vETFcj_RebW+Zt=q+1yOmMo9CpyzHdABanpPRg@mail.gmail.com>
In-Reply-To: <CAPcyv4h53gj9vETFcj_RebW+Zt=q+1yOmMo9CpyzHdABanpPRg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 28 Jan 2022 10:59:26 -0800
Message-ID: <CAPcyv4hj=1=+8UvqzSZqJ12ef1F15Hpzud7YjJpz7dZa0=9=QQ@mail.gmail.com>
Subject: Re: [PATCH v3 01/14] cxl/region: Add region creation ABI
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, patches@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Bjorn Helgaas <helgaas@kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Jan 28, 2022 at 10:14 AM Dan Williams <dan.j.williams@intel.com> wrote:
[..]
> Here is that put_device() I was expecting, that kfree() earlier was a
> double-free it seems.
>
> Also, I would have expected a devm action to remove this. Something like:
>
> struct cxl_port *port = to_cxl_port(cxld->dev.parent);
>
> cxl_device_lock(&port->dev);
> if (port->dev.driver)
>     devm_cxl_add_region(port->uport, cxld, id);
> else
>     rc = -ENXIO;
> cxl_device_unlock(&port->dev);
>
> ...then no matter what you know the region will be unregistered when
> the root port goes away.

...actually, the lock and ->dev.driver check here are not needed
because this attribute is only registered while the cxl_acpi driver is
bound. So, it is safe to assume this is protected as decoder remove
synchronizes against active sysfs users.
