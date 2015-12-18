Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1450427687.11503.14.camel@kernel.org>
Subject: Re: [PATCH] BTT: Change nd_btt_arena_is_valid() to verify UUID
From: Vishal Verma <vishal@kernel.org>
Date: Fri, 18 Dec 2015 01:34:47 -0700
In-Reply-To: <1450393200-6802-1-git-send-email-toshi.kani@hpe.com>
References: <1450393200-6802-1-git-send-email-toshi.kani@hpe.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hpe.com>, dan.j.williams@intel.com"Williams, Dan J" <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, micah.parrish@hpe.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2015-12-17 at 16:00 -0700, Toshi Kani wrote:
> When user unbinds a BTT disk and binds again with a different
> sector size without wiping out the disk, a BTT disk is created
> with a wrong size.

I think this is an incorrect usage model in the first place. You
shouldn't expect to disable a BTT, change the sector size or uuid
behind it, and expect it to work with the new sector size on re-
enabling.

While this patch makes the BTT see the right size, it is really just an
illusion, because if you try to read the pre-sector-size-change data,
it will be scrambled, and thus practically lost.

Even with this patch, I can skip changing the UUID, just change the
sector size, and re-enable it, and the total available size will appear
to have changed.

For the case of legacy (non-nfit) namespaces, the only way to change a
BTT's properties is to recreate it using 'force_raw'. For non-legacy
namespaces, the recommended way is to recreate the namespace with a new
uuid, and this will cause BTT to react to the parent_uuid change and
not try to bind itself to stale metadata. Both cases will lose any data
on the old BTT.

Ideally, changing BTT properties shouldn't be allowed till the parent
namespaces is recreated, but I'm not sure there is an easy way to
enforce this -- Dan?

Also, I wonder if this problem is solved by using libndctl to manage
BTTs.


Thanks,
	-Vishal


