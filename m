Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com
 [IPv6:2607:f8b0:4864:20::e44])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1F97F21173C6E
 for <linux-nvdimm@lists.01.org>; Tue, 30 Oct 2018 18:45:06 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id r5so316252vso.4
 for <linux-nvdimm@lists.01.org>; Tue, 30 Oct 2018 18:45:06 -0700 (PDT)
Date: Tue, 30 Oct 2018 21:45:00 -0400
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: Re: [PATCH] tools/testing/nvdimm: Fix the index for dimm devices.
Message-ID: <20181031014459.l46tc7fentem2yrr@gabell>
References: <20181029191054.7694-1-msys.mizuma@gmail.com>
 <CAPcyv4jaHTOL1F9aT35i_DWLoaS75SDXdwV3nA11QZufStFPcA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jaHTOL1F9aT35i_DWLoaS75SDXdwV3nA11QZufStFPcA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 30, 2018 at 03:30:05PM -0700, Dan Williams wrote:
> On Mon, Oct 29, 2018 at 12:11 PM Masayoshi Mizuma <msys.mizuma@gmail.com> wrote:
> >
> > From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> >
> > KASAN reports following global out of bounds access while
> > nfit_test is being loaded. The out of bound access happens
> > the following reference to dimm_fail_cmd_flags[dimm]. 'dimm' is
> > over than the index value, NUM_DCR (==5).
> >
> > ---
> 
> One more small comment, please be careful to not use "---" in the
> changelog because this causes "git am" to stop parsing the changelog
> right at this point. I lost your sign-off and debug information when
> test applying this.

Sorry. Got it.

- Masa
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
