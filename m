Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2375D1A1E6C
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 01:06:29 -0800 (PST)
Date: Thu, 10 Mar 2016 10:06:11 +0100
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 3/4] memstick: don't allocate unused major for ms_block
Message-ID: <20160310090611.GP3464@c203.arch.suse.de>
References: <20160309215702.20904.61407.stgit@noble>
 <20160309215928.20904.10315.stgit@noble>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160309215928.20904.10315.stgit@noble>
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
To: NeilBrown <neilb@suse.com>
Cc: Jens Axboe <axboe@fb.com>, Maxim Levitsky <maximlevitsky@gmail.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Keith Busch <keith.busch@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 10, 2016 at 08:59:28AM +1100, NeilBrown wrote:
> When alloc_disk(0) is used the ->major number is completely ignored.
> All devices are allocated with a major of BLOCK_EXT_MAJOR.
> =

> So remove registration and deregistration of 'major'.
> =

> Signed-off-by: NeilBrown <neilb@suse.com>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

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
