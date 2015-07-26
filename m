Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Sun, 26 Jul 2015 19:25:27 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 08/25] arch: introduce memremap()
Message-ID: <20150726172527.GA29513@lst.de>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com> <20150725023842.8664.97620.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150725023842.8664.97620.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com, linux-arch@vger.kernel.org, toshi.kani@hp.com, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 24, 2015 at 10:38:42PM -0400, Dan Williams wrote:
> The behavior change to return NULL on an unsupported request is reserved
> for a later patch.

Why?

> +enum {
> +	MEMREMAP_WB = 1 << 0,
> +	MEMREMAP_WT = 1 << 1,
> +	MEMREMAP_CACHE = MEMREMAP_WB,

What's the point of having this MEMREMAP_CACHE alias?

Also please document the meaning of the flags for the poor users.

