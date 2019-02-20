From: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [ndctl PATCH v2 0/4] add the support for NVDIMM_FAMILY_HYPERV
Date: Wed, 20 Feb 2019 05:10:09 +0000
Message-ID: <PU1P153MB01692C7450B6CF3AC19F8FACBF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Michael Kelley <mikelley-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org" <qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org


NVDIMM_FAMILY_HYPERV has been supported on this branch of the kernel:
https://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm.git/log/?h=libnvdimm-pending

Now, let's add the ndctl part as well.

Patch 0001 and 0002 have been posted on Feb 5, and this is just a resend. 

Patch 0003 and 0004 are a split version of the single patch I posted on Feb 14.
In v2, I split the single patch into 2 separate patches for easy review, and I
also added an explicit warning if the user specifies unsupported events for
"ndctl monitor". Thanks Qi Fuli for the suggestion, and thanks 
Johannes Thumshirn for reviewing the patch!

Please review the new patchset. Thanks!

Dexuan Cui (4):
  libndctl: add support for NVDIMM_FAMILY_HYPERV's _DSM Function 1
  libndctl: NVDIMM_FAMILY_HYPERV: add .smart_get_shutdown_count
    (Function 2)
  ndctl, lib: implement ndctl_dimm_get_cmd_family()
  ndctl, monitor: support NVDIMM_FAMILY_HYPERV

 ndctl/lib/Makefile.am  |   1 +
 ndctl/lib/hyperv.c     | 177 +++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/hyperv.h     |  58 ++++++++++++++
 ndctl/lib/libndctl.c   |   7 ++
 ndctl/lib/libndctl.sym |   1 +
 ndctl/lib/private.h    |   3 +
 ndctl/libndctl.h       |   1 +
 ndctl/monitor.c        |  42 ++++++++--
 ndctl/ndctl.h          |   1 +
 9 files changed, 284 insertions(+), 7 deletions(-)
 create mode 100644 ndctl/lib/hyperv.c
 create mode 100644 ndctl/lib/hyperv.h

-- 
2.19.1
