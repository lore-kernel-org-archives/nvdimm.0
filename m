Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v1 06/10] device property: switch to use UUID API
Date: Thu, 18 Feb 2016 01:03:39 +0100
Message-ID: <7544228.v4QPX4F7J7@vostro.rjw.lan>
In-Reply-To: <1455711448-124103-7-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com> <1455711448-124103-7-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, David Airlie <airlied@linux.ie>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Mathias Nyman <mathias.nyman@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Lv Zheng <lv.zheng@intel.com>, Mark Brown <broonie@kernel.org>, Zhang Rui <rui.zhang@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org, linux-api@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wednesday, February 17, 2016 02:17:24 PM Andy Shevchenko wrote:
> Switch to use a generic UUID API instead of custom approach. It allows to
> define UUIDs, compare them, and validate.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/acpi/property.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/acpi/property.c b/drivers/acpi/property.c
> index 2aee416..1e75305 100644
> --- a/drivers/acpi/property.c
> +++ b/drivers/acpi/property.c
> @@ -25,15 +25,13 @@ static int acpi_data_get_property_array(struct acpi_device_data *data,
>  					const union acpi_object **obj);
>  
>  /* ACPI _DSD device properties UUID: daffd814-6eba-4d8c-8a91-bc9bbf4aa301 */
> -static const u8 prp_uuid[16] = {
> -	0x14, 0xd8, 0xff, 0xda, 0xba, 0x6e, 0x8c, 0x4d,
> -	0x8a, 0x91, 0xbc, 0x9b, 0xbf, 0x4a, 0xa3, 0x01
> -};
> +static const uuid_le prp_uuid =
> +	UUID_LE(0xdaffd814, 0x6eba, 0x4d8c,
> +		0x8a, 0x91, 0xbc, 0x9b, 0xbf, 0x4a, 0xa3, 0x01);
>  /* ACPI _DSD data subnodes UUID: dbb8e3e6-5886-4ba6-8795-1319f52a966b */
> -static const u8 ads_uuid[16] = {
> -	0xe6, 0xe3, 0xb8, 0xdb, 0x86, 0x58, 0xa6, 0x4b,
> -	0x87, 0x95, 0x13, 0x19, 0xf5, 0x2a, 0x96, 0x6b
> -};
> +static const uuid_le ads_uuid =
> +	UUID_LE(0xdbb8e3e6, 0x5886, 0x4ba6,
> +		0x87, 0x95, 0x13, 0x19, 0xf5, 0x2a, 0x96, 0x6b);
>  
>  static bool acpi_enumerate_nondev_subnodes(acpi_handle scope,
>  					   const union acpi_object *desc,
> @@ -138,7 +136,7 @@ static bool acpi_enumerate_nondev_subnodes(acpi_handle scope,
>  		    || links->type != ACPI_TYPE_PACKAGE)
>  			break;
>  
> -		if (memcmp(uuid->buffer.pointer, ads_uuid, sizeof(ads_uuid)))
> +		if (uuid_le_cmp(*(uuid_le *)uuid->buffer.pointer, ads_uuid))

Maybe it's too late, but I don't quite understand the pointer manipulations here.

I can see why you need a type conversion (although it looks ugly), but why do you
need to dereference it too?

Thanks,
Rafael
