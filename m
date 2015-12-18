Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1450451737.20148.121.camel@hpe.com>
Subject: Re: [PATCH] BTT: Change nd_btt_arena_is_valid() to verify UUID
From: Toshi Kani <toshi.kani@hpe.com>
Date: Fri, 18 Dec 2015 08:15:37 -0700
In-Reply-To: <1450427687.11503.14.camel@kernel.org>
References: <1450393200-6802-1-git-send-email-toshi.kani@hpe.com>
	 <1450427687.11503.14.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Vishal Verma <vishal@kernel.org>, dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, micah.parrish@hpe.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2015-12-18 at 01:34 -0700, Vishal Verma wrote:
> On Thu, 2015-12-17 at 16:00 -0700, Toshi Kani wrote:
> > When user unbinds a BTT disk and binds again with a different
> > sector size without wiping out the disk, a BTT disk is created
> > with a wrong size.
> 
> I think this is an incorrect usage model in the first place. You
> shouldn't expect to disable a BTT, change the sector size or uuid
> behind it, and expect it to work with the new sector size on re-
> enabling.

Well, users do test with multiple sector sizes when they evaluate BTT.  So,
this is a legitimate use-case with a missing step to wipe out the data in
between.  I believe BTT needs to be protected from this case in one way or
the other.

> While this patch makes the BTT see the right size, it is really just an
> illusion, because if you try to read the pre-sector-size-change data,
> it will be scrambled, and thus practically lost.

When user binds a new BTT, he/she does not expect any valid data left in
BTT.  mkfs is then performed before using the BTT disk.  This use-case is
similar with re-partitioning.

> Even with this patch, I can skip changing the UUID, just change the
> sector size, and re-enable it, and the total available size will appear
> to have changed.

Using the same UUID requires deliberate effort since uuidgen won't generate
the same UUID again.  We can check the sector size in addition to the UUID,
if that makes it any safer.  I am not sure how much we need to protect from
such deliberate effort, though.

> For the case of legacy (non-nfit) namespaces, the only way to change a
> BTT's properties is to recreate it using 'force_raw'. For non-legacy
> namespaces, the recommended way is to recreate the namespace with a new
> uuid, and this will cause BTT to react to the parent_uuid change and
> not try to bind itself to stale metadata. Both cases will lose any data
> on the old BTT.

Losing the data is expected after newly binding BTT, which is not an issue
here.  The issue is that BTT operates in split sector sizes when user
missed the step to wipe out the data before binding.  Yes, this patch
follows the same approach of the parent_uuid check.

> Ideally, changing BTT properties shouldn't be allowed till the parent
> namespaces is recreated, but I'm not sure there is an easy way to
> enforce this -- Dan?
> 
> Also, I wonder if this problem is solved by using libndctl to manage
> BTTs.

I have not tested with libndctl yet, but I think our bind/unbind scripts do
the same procedures. 

Thanks,
-Toshi

