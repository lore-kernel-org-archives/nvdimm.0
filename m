Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1432216514.26714.4.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 02/21] libnd, nfit: initial libnd infrastructure and
 NFIT support
From: Toshi Kani <toshi.kani@hp.com>
Date: Thu, 21 May 2015 07:55:14 -0600
In-Reply-To: <20150520205621.32249.39424.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150520205536.32249.89779.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20150520205621.32249.39424.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: axboe@kernel.dk, linux-nvdimm@lists.01.org, neilb@suse.de, gregkh@linuxfoundation.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-kernel@vger.kernel.org, Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org, Lv Zheng <lv.zheng@intel.com>, hch@lst.de, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2015-05-20 at 16:56 -0400, Dan Williams wrote:
 :
> +/* NVDIMM - NFIT table */
> +
> +#define UUID_VOLATILE_MEMORY            "4f940573-dafd-e344-b16c-3f22d252e5d0"
> +#define UUID_PERSISTENT_MEMORY          "79d3f066-f3b4-7440-ac43-0d3318b78cdb"
> +#define UUID_CONTROL_REGION             "f601f792-b413-5d40-910b-299367e8234c"
> +#define UUID_DATA_REGION                "3005af91-865d-0e47-a6b0-0a2db9408249"
> +#define UUID_VOLATILE_VIRTUAL_DISK      "5a53ab77-fc45-4b62-5560-f7b281d1f96e"
> +#define UUID_VOLATILE_VIRTUAL_CD        "30bd5a3d-7541-ce87-6d64-d2ade523c4bb"
> +#define UUID_PERSISTENT_VIRTUAL_DISK    "c902ea5c-074d-69d3-269f-4496fbe096f9"
> +#define UUID_PERSISTENT_VIRTUAL_CD      "88810108-cd42-48bb-100f-5387d53ded3d"

acpi_str_to_uuid() performs little-endian byte-swapping, so the UUID
strings here need to be actual values.

For instance, UUID_PERSISTENT_MEMORY should be:
#define UUID_PERSISTENT_MEMORY   "66f0d379-b4f3-4074-ac43-0d3318b78cdb"

Thanks,
-Toshi

