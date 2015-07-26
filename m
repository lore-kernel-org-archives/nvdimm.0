Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Sun, 26 Jul 2015 19:31:41 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 24/25] arch: remove ioremap_wt, replace with
	arch_memremap
Message-ID: <20150726173141.GC29513@lst.de>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com> <20150725024015.8664.42950.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150725024015.8664.42950.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com, linux-arch@vger.kernel.org, Tony Luck <tony.luck@intel.com>, toshi.kani@hp.com, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, rmk+kernel@arm.linux.org.uk, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

Documentation/x86/pat.txt needs to be updated for this change as well.
