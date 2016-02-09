Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1455035786.2925.81.camel@hpe.com>
Subject: Re: [PATCH v2] x86/lib/copy_user_64.S: Handle 4-byte nocache copy
From: Toshi Kani <toshi.kani@hpe.com>
Date: Tue, 09 Feb 2016 09:36:26 -0700
In-Reply-To: <20160209120816.GC500@gmail.com>
References: <1454524511-29416-1-git-send-email-toshi.kani@hpe.com>
	 <20160209102741.GA11313@gmail.com> <20160209111404.GA4434@pd.tnic>
	 <20160209112732.GB500@gmail.com> <20160209115358.GB4434@pd.tnic>
	 <20160209120816.GC500@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, dan.j.williams@intel.com, ross.zwisler@linux.intel.com, vishal.l.verma@intel.com, micah.parrish@hpe.com, brian.boylston@hpe.com, x86@kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2016-02-09 at 13:08 +0100, Ingo Molnar wrote:
> * Borislav Petkov <bp@suse.de> wrote:
> 
> > On Tue, Feb 09, 2016 at 12:27:32PM +0100, Ingo Molnar wrote:
> > > Btw., IIRC GAS is being silly about .L, i.e. there's a difference
> > > between these 
> > > two variants:
> > > 
> > >  .Lerror_entry_from_usermode_swapgs:
> > >  .L_error_entry_from_usermode_swapgs:
> > > 
> > > the latter would be easier to read, but does not result in a local
> > > label last I 
> > > checked.
> > > 
> > > Right?
> > 
> > Seems to build ok here with "GNU assembler (GNU Binutils)
> > 2.26.51.20151207".
> > Perhaps some bug with older gas...?
> 
> Hm, indeed - I just tried it too.
> 
> This means that the (slightly) more readable .L_ prefix is preferred.

Thanks for the suggestions!  I will update the patch accordingly. 
-Toshi
