Return-Path: <owner-linux-mm@kvack.org>
Date: Wed, 17 Jun 2015 13:31:21 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 6/6] arch, x86: pmem api for ensuring durability of
	persistent memory updates
Message-ID: <20150617113121.GC9246@lst.de>
References: <20150611211354.10271.57950.stgit@dwillia2-desk3.amr.corp.intel.com> <20150611211947.10271.80768.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150611211947.10271.80768.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: arnd@arndb.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de, ross.zwisler@linux.intel.com, akpm@linux-foundation.org, jgross@suse.com, x86@kernel.org, toshi.kani@hp.com, linux-nvdimm@lists.01.org, benh@kernel.crashing.org, mcgrof@suse.com, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, stefan.bader@canonical.com, luto@amacapital.net, linux-mm@kvack.org, geert@linux-m68k.org, ralf@linux-mips.org, hmh@hmh.eng.br, mpe@ellerman.id.au, tj@kernel.org, paulus@samba.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

This mess with arch_ methods and an ops vecor is almost unreadable.

What's the problem with having something like:

pmem_foo()
{
	if (arch_has_pmem)		// or sync_pmem
		arch_pmem_foo();
	generic_pmem_foo();
}

This adds a branch at runtime, but that shoudn't really be any slower
than an indirect call on architectures that matter.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
