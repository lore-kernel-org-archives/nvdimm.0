Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1454013825.2576.31.camel@hpe.com>
References: <1454004770-6318-1-git-send-email-toshi.kani@hpe.com>
	<CAPcyv4gc_wL6Bb8NxU42CAPN6v05MYnVVZiyijAQt9XZ6VNL_g@mail.gmail.com>
	<1454013825.2576.31.camel@hpe.com>
Date: Sat, 30 Jan 2016 09:44:17 -0800
Message-ID: <CAPcyv4hsa-DCYO-YxMCKat5y-dDvGMMgJ5D-cib2TjhyNan4NA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fix BTT data corruptions after crash
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hpe.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>, Ross Zwisler <ross.zwisler@linux.intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, micah.parrish@hpe.com, brian.boylston@hpe.com, X86 ML <x86@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 28, 2016 at 12:43 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
> On Thu, 2016-01-28 at 12:12 -0800, Dan Williams wrote:
[..]
>> I'm wondering if we should just document that this routine does not
>> support unaligned transfers?  Maybe backed by a debug mode that does
>> the alignment check.
>
> Yes, I agree.  For this debug mode, do you have something in mind?  Or
> should we add a new CONFIG option like CONFIG_PMEM_DEBUG?
>

I hesitated to say yes to this since some simple alignment checks
seems like a thin reason to add a new Kconfig symbol.  However, one
way we can test that memcpy_to_pmem() properly bypasses the cache is
to invalidate the cache contents that it touches.  This would have
caught this bug without needing to do a power cycle test.  In
otherwords in debug mode run an 'invd' loop after the copy.
