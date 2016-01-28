Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1454013825.2576.31.camel@hpe.com>
Subject: Re: [PATCH 0/2] Fix BTT data corruptions after crash
From: Toshi Kani <toshi.kani@hpe.com>
Date: Thu, 28 Jan 2016 13:43:45 -0700
In-Reply-To: <CAPcyv4gc_wL6Bb8NxU42CAPN6v05MYnVVZiyijAQt9XZ6VNL_g@mail.gmail.com>
References: <1454004770-6318-1-git-send-email-toshi.kani@hpe.com>
	 <CAPcyv4gc_wL6Bb8NxU42CAPN6v05MYnVVZiyijAQt9XZ6VNL_g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>, Ross Zwisler <ross.zwisler@linux.intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, micah.parrish@hpe.com, brian.boylston@hpe.com, X86 ML <x86@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2016-01-28 at 12:12 -0800, Dan Williams wrote:
> On Thu, Jan 28, 2016 at 10:12 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> > Data corruption issues were observed in tests which initiated a system
> > crash/reset while accessing BTT devices.  This problem is reproducible.
> > 
> > The BTT driver calls pmem_rw_bytes() to update data in pmem devices.
> > This interface calls __copy_user_nocache(), which uses non-temporal
> > stores so that the stores to pmem are persistent.
> > 
> > __copy_user_nocache() uses non-temporal stores when a request size is
> > 8 bytes or larger (and is aligned by 8 bytes).  The BTT driver updates
> > the BTT map table, which entry size is 4 bytes.  Therefore, updates to
> > the map table entries remain cached, and are not written to pmem after
> > a crash.  Since the BTT driver makes previous blocks free and uses them
> > for subsequent writes, the map table ends up pointing to blocks 
> > allocated for other LBAs after a crash.
> > 
> > Patch 1 extends __copy_user_nocache() to use non-temporal store for
> > 4 byte copy.  This patch fixes the BTT data corruption issue.
> > 
> 
> Nice find!

:-)

> > Patch 2 changes arch_memcpy_to_pmem() to flush processor caches when
> > a request is not naturally aligned or is less than 4 bytes.  This is
> > defensive change.
> 
> I'm wondering if we should just document that this routine does not
> support unaligned transfers?  Maybe backed by a debug mode that does
> the alignment check.

Yes, I agree.  For this debug mode, do you have something in mind?  Or
should we add a new CONFIG option like CONFIG_PMEM_DEBUG?

Thanks,
-Toshi
