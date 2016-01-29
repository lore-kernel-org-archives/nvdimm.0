Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1454079412.2576.33.camel@hpe.com>
Subject: Re: [PATCH 1/2] x86/lib/copy_user_64.S: Handle 4-byte uncached copy
From: Toshi Kani <toshi.kani@hpe.com>
Date: Fri, 29 Jan 2016 07:56:52 -0700
In-Reply-To: <20160129082756.GA4326@gmail.com>
References: <1454004770-6318-1-git-send-email-toshi.kani@hpe.com>
	 <1454004770-6318-2-git-send-email-toshi.kani@hpe.com>
	 <20160129082756.GA4326@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, bp@suse.de, dan.j.williams@intel.com, ross.zwisler@linux.intel.com, vishal.l.verma@intel.com, micah.parrish@hpe.com, brian.boylston@hpe.com, x86@kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2016-01-29 at 09:27 +0100, Ingo Molnar wrote:
> * Toshi Kani <toshi.kani@hpe.com> wrote:
 :
> > ---
> >  arch/x86/lib/copy_user_64.S |   44 ++++++++++++++++++++++++++++++++---
> > --------
> >  1 file changed, 33 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
> > index 982ce34..84b5578 100644
> > --- a/arch/x86/lib/copy_user_64.S
> > +++ b/arch/x86/lib/copy_user_64.S
> > @@ -232,12 +232,17 @@ ENDPROC(copy_user_enhanced_fast_string)
> >  
> >  /*
> >   * copy_user_nocache - Uncached memory copy with exception handling
> > - * This will force destination/source out of cache for more
> > performance.
> > + * This will force destination out of cache for more performance.
> > + *
> > + * Note: Cached memory copy is used when destination or size is not
> > + * naturally aligned. That is:
> > + *  - Require 8-byte alignment when size is 8 bytes or larger.
> > + *  - Require 4-byte alignment when size is 4 bytes.
> >   */
> >  ENTRY(__copy_user_nocache)
 :
> So at minimum this patch needs to add quite a few comments to explain the
> alignment dependent control flow.
> 
> Assembly code is hard enough to read as-is. Adding 20 more lines with 
> zero in-line comments is a mistake.
> 
> Btw., while at it, please add comments for the control flow of the whole 
> function.  Above a certain complexity that is a must for assembly
> functions.

Agreed.  I will add comments for the whole function.

Thanks,
-Toshi
