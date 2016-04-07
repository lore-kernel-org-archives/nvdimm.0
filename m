Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CFBB01A1FB7
 for <linux-nvdimm@lists.01.org>; Thu,  7 Apr 2016 01:27:56 -0700 (PDT)
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] libnvdimm, test: add mock SMART data payload
Date: Thu, 07 Apr 2016 10:27:54 +0200
Message-ID: <32455510.OFm6LAzW1p@c203>
In-Reply-To: <20160407005349.30117.44157.stgit@dwillia2-desk3.jf.intel.com>
References: <20160407005349.30117.44157.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mittwoch, 6. April 2016 17:53:49 CEST Dan Williams wrote:
> Provide simulated SMART data to enable the ndctl implementation of SMART
> data retrieval and parsing.
> =

> The payload is defined here, "Section 4.1 SMART and Health Info
> (Function Index 1)":
> =

>     http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf
> =

> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

[...]

> @@ -20,6 +20,35 @@ struct nd_cmd_smart {
>  	__u8 data[128];
>  } __packed;
> =

> +enum {
> +	ND_SMART_HEALTH_VALID	=3D 1 << 0,
> +	ND_SMART_TEMP_VALID 	=3D 1 << 1,
> +	ND_SMART_SPARES_VALID	=3D 1 << 2,
> +	ND_SMART_ALARM_VALID	=3D 1 << 3,
> +	ND_SMART_USED_VALID	=3D 1 << 4,
> +	ND_SMART_SHUTDOWN_VALID	=3D 1 << 5,
> +	ND_SMART_VENDOR_VALID	=3D 1 << 6,
> +	ND_SMART_TEMP_TRIP	=3D 1 << 0,
> +	ND_SMART_SPARE_TRIP	=3D 1 << 1,
> +	ND_SMART_NON_CRITICAL_HEALTH	=3D 1 << 0,
> +	ND_SMART_CRITICAL_HEALTH	=3D 1 << 1,
> +	ND_SMART_FATAL_HEALTH		=3D 1 << 2,
> +};

Why not use BIT() instead of that 1 << x stuff and #define instead of the =

abstract enum?

-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
