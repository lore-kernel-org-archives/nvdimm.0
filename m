From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v3 15/18] Documentation: kunit: add documentation for
 KUnit
Date: Tue, 14 May 2019 07:34:22 -0600
Message-ID: <20190514073422.4287267c@lwn.net>
References: <20190514054251.186196-1-brendanhiggins@google.com>
        <20190514054251.186196-16-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190514054251.186196-16-brendanhiggins@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brendan Higgins <brendanhiggins@google.com>
Cc: frowand.list@gmail.com, gregkh@linuxfoundation.org, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, robh@kernel.org, sboyd@kernel.org, shuah@kernel.org, tytso@mit.edu, yamada.masahiro@socionext.com, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, linux-um@lists.infradead.org, Alexander.Levin@microsoft.com, Tim.Bird@sony.com, amir73il@gmail.com, dan.carpenter@oracle.com, dan.j.williams@intel.com, daniel@ffwll.ch, jdike@addtoit.com, joel@jms.id.au, julia.lawall@lip6.fr, khilman@baylibre.com, knut.omang@oracle.com, logang@deltatee.com, mpe@eller
List-Id: linux-nvdimm@lists.01.org

On Mon, 13 May 2019 22:42:49 -0700
Brendan Higgins <brendanhiggins@google.com> wrote:

> Add documentation for KUnit, the Linux kernel unit testing framework.
> - Add intro and usage guide for KUnit
> - Add API reference
> 
> Signed-off-by: Felix Guo <felixguoxiuping@gmail.com>
> Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> ---
> Changes Since Last Revision:
>  - Addressed reference to incorrect number of sections, as per Randy's
>    comment.
>  - Make section underlines same length as the section title, as per
>    Randy's comments.
> ---
>  Documentation/index.rst           |   1 +
>  Documentation/kunit/api/index.rst |  16 +
>  Documentation/kunit/api/test.rst  |  14 +
>  Documentation/kunit/faq.rst       |  62 ++++
>  Documentation/kunit/index.rst     |  79 ++++
>  Documentation/kunit/start.rst     | 180 ++++++++++
>  Documentation/kunit/usage.rst     | 575 ++++++++++++++++++++++++++++++

Certainly it's great to see all this documentation coming with this
feature!

Naturally, though, I have one request: I'd rather not see this at the top
level, which is more than crowded enough as it is.  Can this material
please go into the development tools book, alongside the kselftest
documentation?

Thanks,

jon
