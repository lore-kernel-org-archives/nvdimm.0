Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 80D7321184ADE
 for <linux-nvdimm@lists.01.org>; Tue, 30 Oct 2018 15:30:17 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id v83-v6so5992846oia.5
 for <linux-nvdimm@lists.01.org>; Tue, 30 Oct 2018 15:30:17 -0700 (PDT)
MIME-Version: 1.0
References: <20181029191054.7694-1-msys.mizuma@gmail.com>
In-Reply-To: <20181029191054.7694-1-msys.mizuma@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 30 Oct 2018 15:30:05 -0700
Message-ID: <CAPcyv4jaHTOL1F9aT35i_DWLoaS75SDXdwV3nA11QZufStFPcA@mail.gmail.com>
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

One more small comment, please be careful to not use "---" in the
changelog because this causes "git am" to stop parsing the changelog
right at this point. I lost your sign-off and debug information when
test applying this.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
