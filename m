Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com
 [209.85.210.196])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7143C21197073
 for <linux-nvdimm@lists.01.org>; Thu, 29 Nov 2018 19:44:30 -0800 (PST)
Received: by mail-pf1-f196.google.com with SMTP id z9so2105551pfi.2
 for <linux-nvdimm@lists.01.org>; Thu, 29 Nov 2018 19:44:30 -0800 (PST)
Date: Thu, 29 Nov 2018 19:44:25 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [RFC v3 11/19] kunit: add Python libraries for handing KUnit
 config and kernel
Message-ID: <20181130034425.GO18410@garbanzo.do-not-panic.com>
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-12-brendanhiggins@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20181128193636.254378-12-brendanhiggins@google.com>
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
To: Brendan Higgins <brendanhiggins@google.com>
Cc: brakmo@fb.com, dri-devel@lists.freedesktop.org, linux-kselftest@vger.kernel.org, shuah@kernel.org, robh@kernel.org, frowand.list@gmail.com, linux-nvdimm@lists.01.org, richard@nod.at, knut.omang@oracle.com, kieran.bingham@ideasonboard.com, Felix Guo <felixguoxiuping@gmail.com>, joel@jms.id.au, jdike@addtoit.com, Tim.Bird@sony.com, keescook@google.com, linux-um@lists.infradead.org, rostedt@goodmis.org, julia.lawall@lip6.fr, kunit-dev@googlegroups.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, daniel@ffwll.ch, mpe@ellerman.id.au, joe@perches.com, khilman@baylibre.com
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 28, 2018 at 11:36:28AM -0800, Brendan Higgins wrote:
> The ultimate goal is to create minimal isolated test binaries; in the
> meantime we are using UML to provide the infrastructure to run tests, so
> define an abstract way to configure and run tests that allow us to
> change the context in which tests are built without affecting the user.
> This also makes pretty and dynamic error reporting, and a lot of other
> nice features easier.
> 
> kunit_config.py:
>   - parse .config and Kconfig files.
>
> 
> kunit_kernel.py: provides helper functions to:
>   - configure the kernel using kunitconfig.

We get the tools to run the config stuff, build, etc, but not a top
level 'make kunitconfig' or whatever. We have things like 'make
kvmconfig' and 'make xenconfig', I think it would be reasonable to
add similar for this.

  Luis
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
