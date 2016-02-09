Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 9 Feb 2016 12:14:05 +0100
From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2] x86/lib/copy_user_64.S: Handle 4-byte nocache copy
Message-ID: <20160209111404.GA4434@pd.tnic>
References: <1454524511-29416-1-git-send-email-toshi.kani@hpe.com>
 <20160209102741.GA11313@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20160209102741.GA11313@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Toshi Kani <toshi.kani@hpe.com>, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, dan.j.williams@intel.com, ross.zwisler@linux.intel.com, vishal.l.verma@intel.com, micah.parrish@hpe.com, brian.boylston@hpe.com, x86@kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Feb 09, 2016 at 11:27:41AM +0100, Ingo Molnar wrote:
> So another pet peeve of mine is to not use numeric labels, please use 
> descriptively named labels instead.

... and prepend them with ".L" so that they become local labels.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
