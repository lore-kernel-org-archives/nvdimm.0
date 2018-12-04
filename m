Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com
 [IPv6:2607:f8b0:4864:20::544])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 52A2121198CCF
 for <linux-nvdimm@lists.01.org>; Tue,  4 Dec 2018 02:58:35 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id z11so7226682pgu.0
 for <linux-nvdimm@lists.01.org>; Tue, 04 Dec 2018 02:58:35 -0800 (PST)
Subject: Re: [RFC v3 18/19] of: unittest: split out a couple of test cases
 from unittest
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-19-brendanhiggins@google.com>
From: Frank Rowand <frowand.list@gmail.com>
Message-ID: <990bfc7d-dc5e-d8d3-c151-9b321ff2ac10@gmail.com>
Date: Tue, 4 Dec 2018 02:58:28 -0800
MIME-Version: 1.0
In-Reply-To: <20181128193636.254378-19-brendanhiggins@google.com>
Content-Language: en-US
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
To: Brendan Higgins <brendanhiggins@google.com>, gregkh@linuxfoundation.org, keescook@google.com, mcgrof@kernel.org, shuah@kernel.org
Cc: brakmo@fb.com, robh@kernel.org, knut.omang@oracle.com, richard@nod.at, dri-devel@lists.freedesktop.org, linux-nvdimm@lists.01.org, mpe@ellerman.id.au, Tim.Bird@sony.com, linux-um@lists.infradead.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org, kieran.bingham@ideasonboard.com, julia.lawall@lip6.fr, joel@jms.id.au, linux-kselftest@vger.kernel.org, khilman@baylibre.com, joe@perches.com, daniel@ffwll.ch, jdike@addtoit.com, kunit-dev@googlegroups.com
List-ID: <linux-nvdimm@lists.01.org>

Hi Brendan,

On 11/28/18 11:36 AM, Brendan Higgins wrote:
> Split out a couple of test cases that these features in base.c from the
> unittest.c monolith. The intention is that we will eventually split out
> all test cases and group them together based on what portion of device
> tree they test.

Why does splitting this file apart improve the implementation?


> 
> Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> ---
>  drivers/of/Makefile      |   2 +-
>  drivers/of/base-test.c   | 214 ++++++++++++++++++++++++++
>  drivers/of/test-common.c | 149 ++++++++++++++++++
>  drivers/of/test-common.h |  16 ++
>  drivers/of/unittest.c    | 316 +--------------------------------------
>  5 files changed, 381 insertions(+), 316 deletions(-)
>  create mode 100644 drivers/of/base-test.c
>  create mode 100644 drivers/of/test-common.c
>  create mode 100644 drivers/of/test-common.h
>
< snip >

-Frank
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
