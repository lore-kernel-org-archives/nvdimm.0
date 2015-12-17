Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hOJuT=i2A_0vDQHsL7MXNgVN_p17q3UW6EcTkxsCMmeg@mail.gmail.com>
References: <CAPcyv4hOJuT=i2A_0vDQHsL7MXNgVN_p17q3UW6EcTkxsCMmeg@mail.gmail.com>
Date: Thu, 17 Dec 2015 08:48:09 -0800
Message-ID: <CAPcyv4h1yhyqxdyLka2X56Q5QhCoXY3vALFBdm0gdQdYR6Vr8w@mail.gmail.com>
Subject: Re: -next regression: "driver cohandle -EPROBE_DEFER from bus_type.match()"
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: tomeu.vizoso@collabora.com, m.szyprowski@samsung.com, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Stephen Rothwell <sfr@canb.auug.org.au>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 17, 2015 at 7:51 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> The commit below causes the libnvdimm sub-system to stop loading.
> This is due to the fact that nvdimm_bus_match() returns the result of
> test_bit() which may be negative.  If there are any other bus match
> functions using test_bit they may be similarly impacted.
>
> Can we queue a fixup like the following to libnvdimm, and maybe
> others, ahead of this driver core change?
>
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index 7e2c43f701bc..2b2181cdeb63 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -62,7 +62,7 @@ static int nvdimm_bus_match(struct device *dev,
> struct device_driver *drv)
> {
>        struct nd_device_driver *nd_drv = to_nd_device_driver(drv);
>
> -       return test_bit(to_nd_device_type(dev), &nd_drv->type);
> +       return !!test_bit(to_nd_device_type(dev), &nd_drv->type);
> }
>
> static struct module *to_bus_provider(struct device *dev)
>
>
>
>
> Other ideas?

How about just checking for EPROBE_DEFER, every other non-zero value is success.
