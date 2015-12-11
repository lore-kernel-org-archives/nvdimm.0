Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] nfit: acpi_nfit_notify(): Do not leave device locked
Date: Fri, 11 Dec 2015 22:01:48 +0000
Message-ID: <D2909598.28AEA%vishal.l.verma@intel.com>
References: <1449865450-8145-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1449865450-8145-1-git-send-email-khoroshilov@ispras.ru>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A1172A95C3880443B327FCB4CE67FA7A@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Khoroshilov <khoroshilov@ispras.ru>, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ldv-project@linuxtesting.org" <ldv-project@linuxtesting.org>
List-ID: <linux-nvdimm@lists.01.org>

On 12/11/15, 13:24, "Alexey Khoroshilov" <khoroshilov@ispras.ru> wrote:

>Even if dev->driver is null because we are being removed,
>it is safer to not leave device locked.
>
>Found by Linux Driver Verification project (linuxtesting.org).
>
>Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
>---
> drivers/acpi/nfit.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Looks good, thanks!
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>


>
>diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
>index e7ed39bab97d..aa45d4802707 100644
>--- a/drivers/acpi/nfit.c
>+++ b/drivers/acpi/nfit.c
>@@ -1810,7 +1810,7 @@ static void acpi_nfit_notify(struct acpi_device
>*adev, u32 event)
> 	if (!dev->driver) {
> 		/* dev->driver may be null if we're being removed */
> 		dev_dbg(dev, "%s: no driver found for dev\n", __func__);
>-		return;
>+		goto out_unlock;
> 	}
> 
> 	if (!acpi_desc) {
>-- 
>1.9.1
>
>


