Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1CF941A1E08
 for <linux-nvdimm@lists.01.org>; Tue, 21 Jun 2016 05:56:51 -0700 (PDT)
Date: Tue, 21 Jun 2016 14:56:17 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] x86/mm: only allow memmap=XX!YY over existing RAM
Message-ID: <20160621125617.o4dx6ncugcptbt4i@c203.arch.suse.de>
References: <1466408039-7497-1-git-send-email-yigal@plexistor.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1466408039-7497-1-git-send-email-yigal@plexistor.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Yigal Korman <yigal@plexistor.com>
Cc: linux-nvdimm@lists.01.org, x86@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 20, 2016 at 10:33:59AM +0300, Yigal Korman wrote:
> Before this patch, passing a range that is beyond the physical memory
> range will succeed, the user will see a /dev/pmem0 and will be able to
> access it. Reads will always return 0 and writes will be silently
> ignored.
> =

> I've gotten more than one bug report about mkfs.{xfs,ext4} or nvml
> failing that were eventually tracked down to be wrong values passed to
> memmap.
> =

> This patch prevents the above issue by instead of adding a new memory
> range, only update a RAM memory range with the PRAM type. This way,
> passing the wrong memmap will either not give you a pmem at all or give
> you a smaller one that actually has RAM behind it.
> =

> And if someone still needs to fake a pmem that doesn't have RAM behind
> it, they can simply do memmap=3DXX@YY,XX!YY.
> =

> Signed-off-by: Yigal Korman <yigal@plexistor.com>

Acked-by: Johannes Thumshirn <jthumshirn@suse.de>

-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
