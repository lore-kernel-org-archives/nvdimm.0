Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com
 [IPv6:2607:f8b0:4864:20::443])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 69CA321196834
 for <linux-nvdimm@lists.01.org>; Tue,  4 Dec 2018 02:56:17 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id b85so8041593pfc.3
 for <linux-nvdimm@lists.01.org>; Tue, 04 Dec 2018 02:56:17 -0800 (PST)
Subject: Re: [RFC v3 17/19] of: unittest: migrate tests to run on KUnit
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-18-brendanhiggins@google.com>
From: Frank Rowand <frowand.list@gmail.com>
Message-ID: <630d0c82-401e-28f8-73fc-6e684ec57bbf@gmail.com>
Date: Tue, 4 Dec 2018 02:56:10 -0800
MIME-Version: 1.0
In-Reply-To: <20181128193636.254378-18-brendanhiggins@google.com>
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

On 11/28/18 11:36 AM, Brendan Higgins wrote:
> Migrate tests without any cleanup, or modifying test logic in anyway to
> run under KUnit using the KUnit expectation and assertion API.
> 
> Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> ---
>  drivers/of/Kconfig    |    1 +
>  drivers/of/unittest.c | 1405 ++++++++++++++++++++++-------------------
>  2 files changed, 752 insertions(+), 654 deletions(-)

< snip >

I am travelling and will not have an opportunity to properly review this
patch, patch 18, or patch 19 until next week.

-Frank

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
