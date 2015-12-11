Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Fri, 11 Dec 2015 14:53:12 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] nfit: acpi_nfit_notify(): Do not leave device locked
Message-ID: <20151211215312.GA13181@linux.intel.com>
References: <1449865450-8145-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1449865450-8145-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 11, 2015 at 11:24:10PM +0300, Alexey Khoroshilov wrote:
> Even if dev->driver is null because we are being removed,
> it is safer to not leave device locked.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/acpi/nfit.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index e7ed39bab97d..aa45d4802707 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
> @@ -1810,7 +1810,7 @@ static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
>  	if (!dev->driver) {
>  		/* dev->driver may be null if we're being removed */
>  		dev_dbg(dev, "%s: no driver found for dev\n", __func__);
> -		return;
> +		goto out_unlock;
>  	}
>  
>  	if (!acpi_desc) {

This seems correct to me.  Thanks for the patch.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
