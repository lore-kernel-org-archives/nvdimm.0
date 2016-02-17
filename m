Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1455724367.2925.209.camel@hpe.com>
Subject: Re: [PATCH v3 1/2] x86/lib/copy_user_64.S: cleanup
 __copy_user_nocache()
From: Toshi Kani <toshi.kani@hpe.com>
Date: Wed, 17 Feb 2016 08:52:47 -0700
In-Reply-To: <20160217080235.GA20160@gmail.com>
References: <1455225857-12039-1-git-send-email-toshi.kani@hpe.com>
	 <1455225857-12039-2-git-send-email-toshi.kani@hpe.com>
	 <20160217080235.GA20160@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, bp@suse.de, dan.j.williams@intel.com, ross.zwisler@linux.intel.com, vishal.l.verma@intel.com, micah.parrish@hpe.com, brian.boylston@hpe.com, x86@kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2016-02-17 at 09:02 +0100, Ingo Molnar wrote:
> * Toshi Kani <toshi.kani@hpe.com> wrote:
> 
> > Add comments to __copy_user_nocache() to clarify its procedures
> > and alignment requirement.
> > 
> > Also change numeric branch target labels to named labels.  The
> > labels begin with ".L" and prefix "cun" (Copy User Nocache) to
> > keep them local and unique to the function.
> 
> So the .L labels are local, i.e. they are not emitted into the symbol
> table.
> 
> I.e. no need to name them globally!

Right, but I thought there is risk of conflicting the names with other copy
functions in the file when they also start using descriptive labels.  For
instance, ".L_finish_copy" can be easily used by other copy functions as
well.


> I've done a s/Lcun_/L_/ over the patch.

Thanks,
-Toshi
