From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 04/17] kunit: test: add kunit_stream a std::stream
 like logger
Date: Thu, 2 May 2019 13:00:08 +0200
Message-ID: <20190502110008.GC12416@kroah.com>
References: <20190501230126.229218-1-brendanhiggins@google.com>
 <20190501230126.229218-5-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190501230126.229218-5-brendanhiggins@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brendan Higgins <brendanhiggins@google.com>
Cc: frowand.list@gmail.com, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, robh@kernel.org, sboyd@kernel.org, shuah@kernel.org, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, linux-um@lists.infradead.org, Alexander.Levin@microsoft.com, Tim.Bird@sony.com, amir73il@gmail.com, dan.carpenter@oracle.com, dan.j.williams@intel.com, daniel@ffwll.ch, jdike@addtoit.com, joel@jms.id.au, julia.lawall@lip6.fr, khilman@baylibre.com, knut.omang@oracle.com, logang@deltatee.com, mpe@ellerman.id.au, pmladek@suse.com, richard@nod.at, rientjes@google.com
List-Id: linux-nvdimm@lists.01.org

On Wed, May 01, 2019 at 04:01:13PM -0700, Brendan Higgins wrote:
> A lot of the expectation and assertion infrastructure prints out fairly
> complicated test failure messages, so add a C++ style log library for
> for logging test results.

Ideally we would always use a standard logging format, like the
kselftest tests all are aiming to do.  That way the output can be easily
parsed by tools to see if the tests succeed/fail easily.

Any chance of having this logging framework enforcing that format as
well?

thanks,

greg k-h
