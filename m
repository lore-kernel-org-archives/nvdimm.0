Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1432852553-24865-3-git-send-email-ross.zwisler@linux.intel.com>
References: <1432852553-24865-1-git-send-email-ross.zwisler@linux.intel.com>
	<1432852553-24865-3-git-send-email-ross.zwisler@linux.intel.com>
Date: Thu, 28 May 2015 15:40:46 -0700
Message-ID: <CAPcyv4hDxtny18+d2_u-oBeSU8MgU2_mdsTWkTHsz-VwGpba=w@mail.gmail.com>
Subject: Re: [PATCH 2/6] nfit: Fix up address spaces, sparse warnings
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 28, 2015 at 3:35 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Fix a couple of sparse warnings (duplicate const, incorrect address
> space), and go back to using memcpy() instead of memcpy_toio() and
> memcpy_fromio() when talking to our block apertures.  Instead, include a
> union to alias mmio->base and mmio->aperture so that we can continue to
> reuse common code for ioremapping and deinterleaving.  mmio->base still
> has the __iomem annotation and is used via readq() and writeq() for the
> control and status registers.  mmio->aperture is used via normal
> memcpy() for aperture I/O.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: linux-nvdimm@lists.01.org
> Cc: linux-acpi@vger.kernel.org

Folded into libnd-for-next.

Thanks Ross!
