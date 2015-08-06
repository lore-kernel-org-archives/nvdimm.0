Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 5 Aug 2015 17:27:37 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 13/24] visorbus: switch from ioremap_cache to memremap
Message-ID: <20150806002737.GA25628@kroah.com>
References: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150730165451.33962.48793.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150730165451.33962.48793.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com, linux-arch@vger.kernel.org, toshi.kani@hp.com, linux-nvdimm@lists.01.org, mcgrof@suse.com, linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk, Benjamin Romer <benjamin.romer@unisys.com>, David Kershner <david.kershner@unisys.com>, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 30, 2015 at 12:54:51PM -0400, Dan Williams wrote:
> In preparation for deprecating ioremap_cache() convert its usage in
> visorbus to memremap.
> 
> Cc: Benjamin Romer <benjamin.romer@unisys.com>
> Cc: David Kershner <david.kershner@unisys.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/staging/unisys/visorbus/visorchannel.c |   16 +++++++++-------
>  drivers/staging/unisys/visorbus/visorchipset.c |   17 +++++++++--------
>  2 files changed, 18 insertions(+), 15 deletions(-)
> 

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
