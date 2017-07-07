Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 39BA621CE73EA
 for <linux-nvdimm@lists.01.org>; Thu,  6 Jul 2017 17:32:46 -0700 (PDT)
Date: Fri, 7 Jul 2017 01:34:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT PULL] libnvdimm for 4.13
Message-ID: <20170707003421.GC10672@ZenIV.linux.org.uk>
References: <1499386957.6081.29.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1499386957.6081.29.camel@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 07, 2017 at 12:22:38AM +0000, Williams, Dan J wrote:
> Hi Linus, please pull from:
> =

>   git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvd=
imm-for-4.13
> =

> to receive, libnvdimm updates for the latest ACPI and UEFI
> specifications. This pull request also includes new 'struct
> dax_operations' enabling to undo the abuse [1] of copy_user_nocache()
> for copy operations to pmem. The dax work originally missed 4.12 to
> address concerns raised by Al.
> =

> [1]: https://lists.01.org/pipermail/linux-nvdimm/2017-January/008364.html
> =

> All of the commits in this pull request have appeared in one or more
> -next releases with no errors reported, however, Stephen did report a
> late merge conflict between nvdimm.git and the vfs.git tree. Stephen's
> merge resolution is here:=A0http://marc.info/?l=3Dlinux-kernel&m=3D149906=
4115
> 07301&w=3D2, but to match Al's changes we appear to also need the
> incremental change below.
> =

> Please pull, I believe any straggling _flushcache() feedback at this
> point can be fixed up post -rc1. I include commit 0aed55af8834 "x86,
> uaccess: introduce copy_from_iter_flushcache for pmem / cache-bypass
> operations" at the end of this message for reference.

There will be some followup, but let's do that on top of your branch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
