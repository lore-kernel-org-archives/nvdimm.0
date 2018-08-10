Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x229.google.com (mail-it0-x229.google.com
 [IPv6:2607:f8b0:4001:c0b::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1477E210EB4CF
 for <linux-nvdimm@lists.01.org>; Fri, 10 Aug 2018 10:28:37 -0700 (PDT)
Received: by mail-it0-x229.google.com with SMTP id e14-v6so3637986itf.1
 for <linux-nvdimm@lists.01.org>; Fri, 10 Aug 2018 10:28:37 -0700 (PDT)
MIME-Version: 1.0
References: <20180730235312.GA5089@thunk.org>
 <20180731193642.GA3473@linux.intel.com>
 <30247efc-88f8-3e0b-fcd8-83801be5f041@intel.com>
 <20180810025339.GB21087@thunk.org>
 <4222843a-13ea-e88f-ca74-4e3fe53b4105@intel.com>
In-Reply-To: <4222843a-13ea-e88f-ca74-4e3fe53b4105@intel.com>
From: Dan Williams <dan.j.williams@gmail.com>
Date: Fri, 10 Aug 2018 10:28:24 -0700
Message-ID: <CAA9_cmdSxy4vw3wQwj_nkWX+s3Z5-z6rkf9H6j-q-SFZyc5URA@mail.gmail.com>
Subject: Re: Help trying to use /dev/pmem for dax debugging?
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "dave.jiang" <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org, ext4 hackers <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>
List-ID: <linux-nvdimm@lists.01.org>

Fixed here:

https://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git/commit/?h=akpm/mm&id=6a1830efaf3318696479475620414ccb703757a5

Sent from my phone, forgive formatting.

On Fri, Aug 10, 2018, 9:18 AM Dave Jiang <dave.jiang@intel.com> wrote:

>
>
> On 08/09/2018 07:53 PM, Theodore Y. Ts'o wrote:
> > On Tue, Jul 31, 2018 at 01:27:15PM -0700, Dave Jiang wrote:
> >>
> >> On 7/31/2018 12:36 PM, Ross Zwisler wrote:
> >>> On Mon, Jul 30, 2018 at 07:53:12PM -0400, Theodore Y. Ts'o wrote:
> >>>> In newer kernels, it looks like you can't use /dev/pmem0 for DAX
> >>>> unless it's marked as being DAX capable.  This appears to require
> >>>> CONFIG_NVDIMM_PFN.  But when I tried to build a kernel with that
> >>>> configured, I get the following BUG:
> >>>
> >>> You're using the memmap kernel command line parameter to reserve normal
> >>> memory to be treated as normal memory, but you've also got kernel
> address
> >>> randomization turned on in your kernel config:
> >>>
> >>> CONFIG_RANDOMIZE_BASE=y
> >>> CONFIG_RANDOMIZE_MEMORY=y
> >>>
> >>> You need to turn these off for the memmap kernel command line
> parameter, else
> >>> the memory we're using could overlap with addresses used for other
> things.
> >>
> >> I believe this issue was fixed a while back. Although we probably can
> see if
> >> that is the issue or something else.
> >
> > I turned off RANDOMIZE_BASE and RANDOMIZE_MEMORY, but that didn't fix
> > my problem.
> >
> > It turns out the problem was KASAN.  It looks like using memmap to
> > create test /dev/pmemX devices is not compatible with CONFIG_KASAN
> > being enabled.
> >
> > So I have a workaround for now, but it seems this to be a bug in
> > KASAN, or at least an unfortunate interaction between KASAN and
> > NVDIMM_PFN.
>
> Thanks Ted. I have updated the wiki Ross mentioned to reflect that.
>
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
