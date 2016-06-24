From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: dm stripe: add DAX support
Date: Fri, 24 Jun 2016 16:02:40 -0400
Message-ID: <20160624200239.GA15587@redhat.com>
References: <1466792610-30369-1-git-send-email-toshi.kani@hpe.com>
 <201606250312.OzHHesq4%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201606250312.OzHHesq4%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kbuild-all-JC7UmRfGjtg@public.gmane.org, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Fri, Jun 24 2016 at  3:58pm -0400,
kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> Hi,
> 
> [auto build test WARNING on dm/for-next]
> [also build test WARNING on v4.7-rc4 next-20160624]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Toshi-Kani/dm-stripe-add-DAX-support/20160625-022600
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
> config: m68k-sun3_defconfig (attached as .config)
> compiler: m68k-linux-gcc (GCC) 4.9.0
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=m68k 
> 
> All warnings (new ones prefixed by >>):
> 
>    drivers/md/dm-stripe.c:452:2: error: unknown field 'direct_access' specified in initializer
>      .direct_access = stripe_direct_access,
>      ^
>    drivers/md/dm-stripe.c:452:2: warning: missing braces around initializer [-Wmissing-braces]
>    drivers/md/dm-stripe.c:452:2: warning: (near initialization for 'stripe_target.list') [-Wmissing-braces]
> >> drivers/md/dm-stripe.c:452:2: warning: initialization from incompatible pointer type
>    drivers/md/dm-stripe.c:452:2: warning: (near initialization for 'stripe_target.list.next')

FYI, overzealous kbuild robot build failure here.. I haven't staged the
prereq DM core changes yet because I'm waiting for Jens to take the 2
block changes those depend on.

Mike
