Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8AA3A21B06E91
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jul 2017 15:20:46 -0700 (PDT)
Date: Tue, 25 Jul 2017 16:22:47 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: FIle copy to FAT FS on NVDIMM hits BUG_ON at fs/buffer.c:3305!
Message-ID: <20170725222247.GA26391@linux.intel.com>
References: <1501018096.2042.70.camel@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1501018096.2042.70.camel@hpe.com>
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "hirofumi@mail.parknet.co.jp" <hirofumi@mail.parknet.co.jp>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 25, 2017 at 09:37:38PM +0000, Kani, Toshimitsu wrote:
> Hi,
> =

> Copying files to vfat FS on an NVDIMM device hits
> BUG_ON(!PageLocked(page)) in try_to_free_buffers().  It happens on
> 4.13-rc1, and happens on older kernels as well.
> =

> A simple reproducer is shown below.  It is 100% reproducible on my
> setup (8GB of regular memory and 16GB of NVDIMM).  It usually hits in
> the 3rd or 4th file copy and does not repeat with the while-loop.=A0
> Interestingly, it hits only when an NVDIMM device is set as raw or
> memory mode.  It does not hit with sector mode.

Interesting, thanks for the report..  I was able to reproduce this in my KVM
setup with a virtualized NVDIMM using v4.12.  I also tried reproducing it w=
ith
BRD, and wasn't able.

I'll take a look.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
