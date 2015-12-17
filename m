Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 17 Dec 2015 07:51:14 -0800
Message-ID: <CAPcyv4hOJuT=i2A_0vDQHsL7MXNgVN_p17q3UW6EcTkxsCMmeg@mail.gmail.com>
Subject: -next regression: "driver cohandle -EPROBE_DEFER from bus_type.match()"
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: tomeu.vizoso@collabora.com, m.szyprowski@samsung.com, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Stephen Rothwell <sfr@canb.auug.org.au>
List-ID: <linux-nvdimm@lists.01.org>

The commit below causes the libnvdimm sub-system to stop loading.
This is due to the fact that nvdimm_bus_match() returns the result of
test_bit() which may be negative.  If there are any other bus match
functions using test_bit they may be similarly impacted.

Can we queue a fixup like the following to libnvdimm, and maybe
others, ahead of this driver core change?

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 7e2c43f701bc..2b2181cdeb63 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -62,7 +62,7 @@ static int nvdimm_bus_match(struct device *dev,
struct device_driver *drv)
{
       struct nd_device_driver *nd_drv = to_nd_device_driver(drv);

-       return test_bit(to_nd_device_type(dev), &nd_drv->type);
+       return !!test_bit(to_nd_device_type(dev), &nd_drv->type);
}

static struct module *to_bus_provider(struct device *dev)




Other ideas?

commit 09a14906a26e454cad7ff0ad96af40fc4cd90eb0
Author: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date:   Tue Dec 8 10:00:45 2015 +0100

   ARM: 8472/1: driver cohandle -EPROBE_DEFER from bus_type.match()

   Allow implementations of the match() callback in struct bus_type to
   return errors and if it's -EPROBE_DEFER then queue the device for
   deferred probing.

   This is useful to buses such as AMBA in which devices are registered
   before their matching information can be retrieved from the HW
   (typically because a clock driver hasn't probed yet).

   [changed if-else code structure, adjusted documentation to match the code,
   extended comments]

   Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
   Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
   Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
   Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
