Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9F95821184ADE
 for <linux-nvdimm@lists.01.org>; Tue, 30 Oct 2018 20:02:16 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id 14so13254998oth.2
 for <linux-nvdimm@lists.01.org>; Tue, 30 Oct 2018 20:02:16 -0700 (PDT)
MIME-Version: 1.0
References: <20181031015025.6406-1-msys.mizuma@gmail.com>
In-Reply-To: <20181031015025.6406-1-msys.mizuma@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 30 Oct 2018 20:02:03 -0700
Message-ID: <CAPcyv4hTMTvNdQ_KTQg_1-VXOaXTOSDnHmFaObW33wuu_QiivA@mail.gmail.com>
Subject: Re: [PATCH v2] tools/testing/nvdimm: Fix the array size for dimm
 devices.
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

On Tue, Oct 30, 2018 at 6:51 PM Masayoshi Mizuma <msys.mizuma@gmail.com> wrote:
>
> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
>
> KASAN reports following global out of bounds access while
> nfit_test is being loaded. The out of bound access happens
> the following reference to dimm_fail_cmd_flags[dimm]. 'dimm' is
> over than the index value, NUM_DCR (==5).
>
>   static int override_return_code(int dimm, unsigned int func, int rc)
>   {
>           if ((1 << func) & dimm_fail_cmd_flags[dimm]) {
>
> dimm_fail_cmd_flags[] definition:
>   static unsigned long dimm_fail_cmd_flags[NUM_DCR];
>
> 'dimm' is the return value of get_dimm(), and get_dimm() returns
> the index of handle[] array. The handle[] has 7 index. Let's use
> ARRAY_SIZE(handle) as the array size.
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
>

Looks good, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
