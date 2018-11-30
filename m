Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1373421197073
 for <linux-nvdimm@lists.01.org>; Thu, 29 Nov 2018 19:45:30 -0800 (PST)
Received: by mail-pf1-f180.google.com with SMTP id c123so2108840pfb.0
 for <linux-nvdimm@lists.01.org>; Thu, 29 Nov 2018 19:45:30 -0800 (PST)
Date: Thu, 29 Nov 2018 19:45:25 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [RFC v3 14/19] Documentation: kunit: add documentation for KUnit
Message-ID: <20181130034525.GP18410@garbanzo.do-not-panic.com>
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-15-brendanhiggins@google.com>
 <b4c72234-8c56-6efa-8003-f89d99a9779e@ideasonboard.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b4c72234-8c56-6efa-8003-f89d99a9779e@ideasonboard.com>
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
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: brakmo@fb.com, Brendan Higgins <brendanhiggins@google.com>, dri-devel@lists.freedesktop.org, linux-kselftest@vger.kernel.org, shuah@kernel.org, robh@kernel.org, frowand.list@gmail.com, linux-nvdimm@lists.01.org, richard@nod.at, knut.omang@oracle.com, Felix Guo <felixguoxiuping@gmail.com>, joel@jms.id.au, Tim.Bird@sony.com, jdike@addtoit.com, keescook@google.com, linux-um@lists.infradead.org, rostedt@goodmis.org, julia.lawall@lip6.fr, kunit-dev@googlegroups.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, daniel@ffwll.ch, mpe@ellerman.id.au, joe@perches.com, khilman@baylibre.com
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 29, 2018 at 01:56:37PM +0000, Kieran Bingham wrote:
> Hi Brendan,
> 
> Please excuse the top posting, but I'm replying here as I'm following
> the section "Creating a kunitconfig" in Documentation/kunit/start.rst.
> 
> Could the three line kunitconfig file live under say
> 	 arch/um/configs/kunit_defconfig?
> 
> So that it's always provided? And could even be extended with tests
> which people would expect to be run by default? (say in distributions)

Indeed, and then a top level 'make kunitconfig' could use it as well.

  Luis
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
