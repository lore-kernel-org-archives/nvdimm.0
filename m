Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794882157;
	b=34Su7qSLqsFrgWOm9AVwr50cy3G9Yx2+/8WoRwpi7wzDJp9tqfEJoQijT4qkH7b3ShPI
	 rRJRd/g06c33GEQ5xYA7dW4P4lDqhWAPO2C8l/jZbFWvpj/BVZxHqigfxvy26DWtJvJyi
	 vQLlCaqjbu4phUNkSOCjvCaql/6JA4ZRmbpmiUCLXjw8J0WUsQs0E9v/EjtVYoqyFG29M
	 CXkPrffjpL8f7ZeHHcZfkac5DMn6OTxSFRhK2oMS1/LEjdY3m6y37hXDuppJMTH5gMyla
	 bKyJthQaSHoQ2suo1OwkU92635F0UmF7EklupSHt+TJRNcVeOqC49UedzzIS4E1Y/ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794882157;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=vhQMbf/9QOBK7STkWUtf7NSQ2paMplC/n0grkTn19So=;
	b=qnZAo24GI78WrCeVdoWXyhqmhsrd6uZ98+ox5VUNLWtOUi6Z17m6EQdrIcz4eWzZ4Ml0
	 NLRlfMVK+LFOiPz2pzmWze7VbONUIJyjckLOoVW3hWKL5Wwu1o6axRBYtN0+KXTavPsqI
	 VprmzW3y8twS1LuBC3RXIBpdvcvMrnLUZ//LnSeCf+VR0Wi0DsHIpKhmR34cVvX9oZRgU
	 kb+FSzUkTuDnEuXjqu+vI0Yz7H4qmbjEGUXEbgbNdLUkx0/bxWD5509qKwb0k9w09ekIf
	 5Lg7i9TwAyLdroAaVUsCvZTmDQXLinS8SGZGdS4yIv8DOqsgDHx5yKPD8nVYPQui8mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d7AN4EeH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D06606A31C;
	Tue, 17 Nov 2026 02:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d7AN4EeH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF201F000C4;
	Tue, 17 Nov 2026 02:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794882156;
	bh=vhQMbf/9QOBK7STkWUtf7NSQ2paMplC/n0grkTn19So=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=d7AN4EeHmlvOJjRV45jWR6YuUi6Il8n0G0jWiAGdvtH1QKSQJPbn/BusqHeV9B+he
	 ANmXvXUmIi/KNWK32/shUijmrtiBZSHWfqH1hKDU8ROOuPwJkCDchf56VjhomFDNYe
	 KasJfOrV+UgOIXGJwCrQq3Vtk5U2XvllCNhLsi7F/mGrUIKaSfWdIx5RSrh3hfxiN4
	 4mMJ9ZGzTi5maOLVLkk20n+eXu8CpB2ze9u87CkAjI+0iBfPs7yejzMUw7Aobp10QR
	 odHjwgtpTw60yNa3XCuE9QC6NoYuJWYU1wLcnozGOQrxd6XXeBSkEq/3mZoL1ghl4Q
	 o/PupYQE2Z+jQ==
Date: Tue, 17 Nov 2026 02:22:28 +0000
From: Jonathan Cameron <jic23@kernel.org>
To: Anisa Su <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, Alison
 Schofield <alison.schofield@intel.com>, Davidlohr Bueso
 <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>, Vishal Verma
 <vishal.l.verma@intel.com>, Fan Ni <nifan.cxl@gmail.com>, Li Ming
 <ming.li@zohomail.com>, Benjamin Cheatham <benjamin.cheatham@amd.com>,
 Gregory Price <gourry@gourry.net>, Richard Cheng <icheng@nvidia.com>, Anisa
 Su <anisa.su@samsung.com>
Subject: Re: [PATCH v1 02/14] cxl/port: Add dynamic capacity options to
 endpoint decoder mode
Message-ID: <20261117022228.43725ce7@jic23-hlaptop>
In-Reply-To: <20261104230445.66625-3-anisa.su@samsung.com>
References: <20261104230445.66625-1-anisa.su@samsung.com>
	<20261104230445.66625-3-anisa.su@samsung.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  5 Nov 2026 08:02:26 +0900
Anisa Su <anisa.su887@gmail.com> wrote:

> Endpoints can now carry a dynamic ram partition following the
> persistent memory partition. A DC partition is further described by
> two properties reported in its CDAT DSMAS entry: shareable and
> read-only.
> 
> Expand the decoder mode to accept 'dynamic_ram', 'dynamic_ram_shared',
Time to argue about bikeshed colors.

So we want the subtle distinction between shared and shareable?
Shared implies it is happening, shareable that it might.

I don't really care either way.

> 'dynamic_ram_ro' and 'dynamic_ram_shared_ro'. cxl_dpa_set_part()
> selects the first dynamic ram partition whose properties match exactly.
> 
> DCD may be disabled during validation after the DC partition(s) were
> added to the DPA layout, so a decoder may only be assigned to a DC
> partition while DCD is enabled for its memdev. Add a helper,
> cxled_dcd_enabled(), to check cxl_dcd_supported().
> 
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> Tested-by: Junhee Park <jh9934.park@samsung.com>
> Tested-by: Heesoo Kim <habil.kim@samsung.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-cxl | 25 +++++++----
>  drivers/cxl/core/core.h                 | 23 ++++++++++-
>  drivers/cxl/core/hdm.c                  | 21 ++++++++--
>  drivers/cxl/core/port.c                 | 55 ++++++++++++++++++++++---
>  4 files changed, 105 insertions(+), 19 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> index 7352dbd70bc7..bcbc44fea6db 100644
> --- a/Documentation/ABI/testing/sysfs-bus-cxl
> +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> @@ -339,22 +339,29 @@ Description:
>  
>  
>  What:		/sys/bus/cxl/devices/decoderX.Y/mode
> -Date:		May, 2022
> -KernelVersion:	v6.0
> +Date:		May, 2022, November, 2026
> +KernelVersion:	v6.0, v7.5 (dynamic_ram)
>  Contact:	linux-cxl@vger.kernel.org
>  Description:
>  		(RW) When a CXL decoder is of devtype "cxl_decoder_endpoint" it
>  		translates from a host physical address range, to a device
>  		local address range. Device-local address ranges are further
> -		split into a 'ram' (volatile memory) range and 'pmem'
> -		(persistent memory) range. The 'mode' attribute emits one of
> -		'ram', 'pmem', or 'none'. The 'none' indicates the decoder is
> -		not actively decoding, or no DPA allocation policy has been
> -		set.
> +		split into a 'ram' (volatile memory) range, 'pmem' (persistent
> +		memory) range, and dynamic capacity ranges. The 'mode'
> +		attribute emits one of 'ram', 'pmem', 'none', or a dynamic
> +		capacity selector: 'dynamic_ram', 'dynamic_ram_shared',
> +		'dynamic_ram_ro' or 'dynamic_ram_shared_ro', composed from the
> +		shareable and read-only properties of the partition the decoder
> +		points at. The 'none' indicates the decoder is not actively
> +		decoding, or no DPA allocation policy has been set.
>  
>  		'mode' can be written, when the decoder is in the 'disabled'
> -		state, with either 'ram' or 'pmem' to set the boundaries for the
> -		next allocation.
> +		state, with 'ram', 'pmem', or one of the dynamic capacity
> +		selectors to set the boundaries for the next allocation. A
> +		selector picks the first dynamic capacity partition whose
> +		shareable and read-only properties match it exactly, and is
> +		accepted only while the driver has dynamic capacity enabled
> +		for the device.
>  
>  
>  What:		/sys/bus/cxl/devices/decoderX.Y/dpa_resource
> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index 8a81be004d00..24fbb5718abc 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -6,6 +6,7 @@
>  
>  #include <cxl/mailbox.h>
>  #include <linux/rwsem.h>
> +#include <cxlmem.h>
>  
>  extern const struct device_type cxl_nvdimm_bridge_type;
>  extern const struct device_type cxl_nvdimm_type;
> @@ -18,6 +19,25 @@ enum cxl_detach_mode {
>  	DETACH_INVALIDATE,
>  };
>  
> +static inline struct cxl_memdev_state *
> +cxled_to_mds(struct cxl_endpoint_decoder *cxled)
> +{
> +	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
> +
> +	return to_cxl_memdev_state(cxlmd->cxlds);
> +}
> +
> +/* Type-2 devices have no memdev state; nothing else leaves @cxlds NULL here */

Seems like an odd comment given cxlds isn't visibly used in here.
Perhaps needs to refer to it via a specific path?

> +static inline bool cxled_dcd_enabled(struct cxl_endpoint_decoder *cxled)
> +{
> +	struct cxl_memdev_state *mds = cxled_to_mds(cxled);
> +
> +	return mds && cxl_dcd_supported(mds);
> +}


> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index f3705ea44db7..9b71b58d4e36 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -203,6 +203,40 @@ static ssize_t target_list_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(target_list);
>  
> +/* Dynamic capacity selectors: the flags name one kind of DC partition */
> +static const struct {
> +	const char *name;
> +	bool shareable;
> +	bool read_only;
> +} cxl_dc_modes[] = {
> +	{ "dynamic_ram",		false,	false },
> +	{ "dynamic_ram_shared",		true,	false },

This rather highlights the disconnect in naming. 

> +	{ "dynamic_ram_ro",		false,	true },
> +	{ "dynamic_ram_shared_ro",	true,	true },
> +};
> +


