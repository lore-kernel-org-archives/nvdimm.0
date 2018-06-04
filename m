Return-Path: <owner-linux-mm@kvack.org>
Date: Mon, 4 Jun 2018 10:08:01 -0700
From: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH v2 07/11] x86, memory_failure: Introduce {set,
 clear}_mce_nospec()
Message-ID: <20180604170801.GA17234@agluck-desk>
References: <152800336321.17112.3300876636370683279.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152800340082.17112.1154560126059273408.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152800340082.17112.1154560126059273408.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, linux-edac@vger.kernel.org, x86@kernel.org, hch@lst.de, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, jack@suse.cz
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Jun 02, 2018 at 10:23:20PM -0700, Dan Williams wrote:
> +static inline int set_mce_nospec(unsigned long pfn)
> +{
> +	int rc;
> +
> +	rc = set_memory_uc((unsigned long) __va(PFN_PHYS(pfn)), 1);

You should really do the decoy_addr thing here that I had in mce_unmap_kpfn().
Putting the virtual address of the page you mustn't accidentally prefetch
from into a register is a pretty good way to make sure that the processor
does do a prefetch.

-Tony
