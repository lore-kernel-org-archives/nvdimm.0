Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 17 Feb 2016 09:02:35 +0100
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v3 1/2] x86/lib/copy_user_64.S: cleanup
 __copy_user_nocache()
Message-ID: <20160217080235.GA20160@gmail.com>
References: <1455225857-12039-1-git-send-email-toshi.kani@hpe.com>
 <1455225857-12039-2-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1455225857-12039-2-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hpe.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, bp@suse.de, dan.j.williams@intel.com, ross.zwisler@linux.intel.com, vishal.l.verma@intel.com, micah.parrish@hpe.com, brian.boylston@hpe.com, x86@kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>


* Toshi Kani <toshi.kani@hpe.com> wrote:

> Add comments to __copy_user_nocache() to clarify its procedures
> and alignment requirement.
> 
> Also change numeric branch target labels to named labels.  The
> labels begin with ".L" and prefix "cun" (Copy User Nocache) to
> keep them local and unique to the function.

So the .L labels are local, i.e. they are not emitted into the symbol table.

I.e. no need to name them globally!

I've done a s/Lcun_/L_/ over the patch.

Thanks,

	Ingo
