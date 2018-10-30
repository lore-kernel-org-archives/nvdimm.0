Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F159921184ADE
 for <linux-nvdimm@lists.01.org>; Tue, 30 Oct 2018 15:25:54 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id o14so12751091oth.4
 for <linux-nvdimm@lists.01.org>; Tue, 30 Oct 2018 15:25:54 -0700 (PDT)
MIME-Version: 1.0
References: <20181029191054.7694-1-msys.mizuma@gmail.com>
In-Reply-To: <20181029191054.7694-1-msys.mizuma@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 30 Oct 2018 15:25:42 -0700
Message-ID: <CAPcyv4graB2RCwXCoN5LpgOi_knLsEMs6nf436u4Ti=6VZ5w3w@mail.gmail.com>
Subject: Re: [PATCH] tools/testing/nvdimm: Fix the index for dimm devices.
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
To: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 29, 2018 at 12:11 PM Masayoshi Mizuma <msys.mizuma@gmail.com> wrote:
>
> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
>
> KASAN reports following global out of bounds access while
> nfit_test is being loaded. The out of bound access happens
> the following reference to dimm_fail_cmd_flags[dimm]. 'dimm' is
> over than the index value, NUM_DCR (==5).
>
> ---
>   static int override_return_code(int dimm, unsigned int func, int rc)
>   {
>           if ((1 << func) & dimm_fail_cmd_flags[dimm]) {
>
> dimm_fail_cmd_flags[] definition:
>   static unsigned long dimm_fail_cmd_flags[NUM_DCR];
> ---
>
> 'dimm' is the return value of get_dimm(), and get_dimm() returns
> the index of handle[] array. The handle[] has 7 index, and the
> index #0 to #4 is for nfit_test.0 and #5, #6 is for nfit_test.1.
> NUM_DCR is only for nfit_test.0. Let's add for nfit_test.1.
>
> KASAN report:
> ==================================================================
> BUG: KASAN: global-out-of-bounds in nfit_test_ctl+0x47bb/0x55b0 [nfit_test]
> Read of size 8 at addr ffffffffc10cbbe8 by task kworker/u41:0/8
> ...
> Call Trace:
>  dump_stack+0xea/0x1b0
>  ? dump_stack_print_info.cold.0+0x1b/0x1b
>  ? kmsg_dump_rewind_nolock+0xd9/0xd9
>  print_address_description+0x65/0x22e
>  ? nfit_test_ctl+0x47bb/0x55b0 [nfit_test]
>  kasan_report.cold.6+0x92/0x1a6
>  nfit_test_ctl+0x47bb/0x55b0 [nfit_test]
> ...
> The buggy address belongs to the variable:
>  dimm_fail_cmd_flags+0x28/0xffffffffffffa440 [nfit_test]
> ==================================================================

Thanks, good catch. This mostly looks ok just one change request below...

>
> Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> ---
>  tools/testing/nvdimm/test/nfit.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> index 9527d47a1070..38f066ce2f47 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -104,6 +104,8 @@
>  enum {
>         NUM_PM  = 3,
>         NUM_DCR = 5,
> +       NUM_DCR_ALL = NUM_DCR + 2, /* 5 DCRs for test.0, 2 DCRs for test.1 */

Let's just use ARRAY_SIZE(handle) in place of introducing NUM_DCR_ALL.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
