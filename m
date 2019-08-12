Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com
 [IPv6:2607:f8b0:4864:20::541])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C98E213030A5
 for <linux-nvdimm@lists.01.org>; Mon, 12 Aug 2019 16:36:00 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id n9so44033785pgc.1
 for <linux-nvdimm@lists.01.org>; Mon, 12 Aug 2019 16:33:43 -0700 (PDT)
Date: Mon, 12 Aug 2019 16:33:36 -0700
From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [PATCH v12 03/18] kunit: test: add string_stream a std::stream
 like string builder
Message-ID: <20190812233336.GA224410@google.com>
References: <20190812182421.141150-1-brendanhiggins@google.com>
 <20190812182421.141150-4-brendanhiggins@google.com>
 <20190812225520.5A67C206A2@mail.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190812225520.5A67C206A2@mail.kernel.org>
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
To: Stephen Boyd <sboyd@kernel.org>
Cc: pmladek@suse.com, linux-doc@vger.kernel.org, peterz@infradead.org, amir73il@gmail.com, dri-devel@lists.freedesktop.org, Alexander.Levin@microsoft.com, yamada.masahiro@socionext.com, mpe@ellerman.id.au, linux-kselftest@vger.kernel.org, shuah@kernel.org, robh@kernel.org, linux-nvdimm@lists.01.org, frowand.list@gmail.com, knut.omang@oracle.com, kieran.bingham@ideasonboard.com, wfg@linux.intel.com, joel@jms.id.au, rientjes@google.com, jdike@addtoit.com, dan.carpenter@oracle.com, devicetree@vger.kernel.org, linux-kbuild@vger.kernel.org, Tim.Bird@sony.com, linux-um@lists.infradead.org, rostedt@goodmis.org, julia.lawall@lip6.fr, jpoimboe@redhat.com, kunit-dev@googlegroups.com, tytso@mit.edu, richard@nod.at, gregkh@linuxfoundation.org, rdunlap@infradead.org, linux-kernel@vger.kernel.org, mcgrof@kernel.org, daniel@ffwll.ch, keescook@google.com, linux-fsdevel@vger.kernel.org, khilman@baylibre.com
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 12, 2019 at 03:55:19PM -0700, Stephen Boyd wrote:
> Quoting Brendan Higgins (2019-08-12 11:24:06)
> > +void string_stream_clear(struct string_stream *stream)
> > +{
> > +       struct string_stream_fragment *frag_container, *frag_container_safe;
> > +
> > +       spin_lock(&stream->lock);
> > +       list_for_each_entry_safe(frag_container,
> > +                                frag_container_safe,
> > +                                &stream->fragments,
> > +                                node) {
> > +               list_del(&frag_container->node);
> 
> Shouldn't we free the allocation here? Otherwise, if some test is going
> to add, add, clear, add, it's going to leak until the test is over?

So basically this means I should add a kunit_kfree and
kunit_resource_destroy (respective equivalents to devm_kfree, and
devres_destroy) and use kunit_kfree here?

> > +       }
> > +       stream->length = 0;
> > +       spin_unlock(&stream->lock);
> > +}
> > +
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
