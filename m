Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 9 Feb 2016 12:27:32 +0100
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] x86/lib/copy_user_64.S: Handle 4-byte nocache copy
Message-ID: <20160209112732.GB500@gmail.com>
References: <1454524511-29416-1-git-send-email-toshi.kani@hpe.com>
 <20160209102741.GA11313@gmail.com>
 <20160209111404.GA4434@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160209111404.GA4434@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Cc: Toshi Kani <toshi.kani@hpe.com>, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, dan.j.williams@intel.com, ross.zwisler@linux.intel.com, vishal.l.verma@intel.com, micah.parrish@hpe.com, brian.boylston@hpe.com, x86@kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>


* Borislav Petkov <bp@suse.de> wrote:

> On Tue, Feb 09, 2016 at 11:27:41AM +0100, Ingo Molnar wrote:
> > So another pet peeve of mine is to not use numeric labels, please use 
> > descriptively named labels instead.
>
> ... and prepend them with ".L" so that they become local labels.

Yes. A good example to follow would be arch/x86/entry/entry_64.S.

Btw., IIRC GAS is being silly about .L, i.e. there's a difference between these 
two variants:

 .Lerror_entry_from_usermode_swapgs:
 .L_error_entry_from_usermode_swapgs:

the latter would be easier to read, but does not result in a local label last I 
checked.

Right?

Thanks,

	Ingo
